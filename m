Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 46D367F37
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 02:20:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A7D7304043
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 00:20:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wUmESf7XNTDWzBrc for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 00:20:34 -0700 (PDT)
Date: Tue, 30 Apr 2013 17:20:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/22] xfs: add CRC protection to remote attributes
Message-ID: <20130430072030.GF23072@dastard>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<1364965892-19623-19-git-send-email-david@fromorbit.com>
	<20130425185605.GE29359@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130425185605.GE29359@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 25, 2013 at 01:56:05PM -0500, Ben Myers wrote:
> On Wed, Apr 03, 2013 at 04:11:28PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > There are two ways of doing this - the first is to add a CRC to the
> > remote attribute entry in the attribute block. The second is to
> > treat them similar to the remote symlink, where each fragment has
> > it's own header and identifies fragment location in the attribute.
> > 
> > The problem with the CRC in the remote attr entry is that we cannot
> > identify the owner of the metadata from the metadata blocks
> > themselves, or where the blocks fit into the remote attribute. The
> > down side to this approach is that we never know when the attribute
> > has been read from disk or not and so we have to verify it every
> > time it is read, and we must calculate it during the create
> > transaction and log it. We do not log CRCs for any other metadata,
> > and so this creates a unique set of coherency problems that, in
> > general, are best avoided.
> > 
> > Adding an identifying header to each allocated block allows us to
> > identify each fragment and where in the attribute it is located. It
> > enables us to rebuild the remote attribute from just the raw blocks
> > containing the attribute. It also provides us to do per-block CRCs
> > verification at IO time rather than during the transaction context
> > that creates it or every time it is read into a user buffer. Hence
> > it avoids all the problems that an external, logged CRC has, and
> > provides all the benefits of self identifying metadata.
> > 
> > The only complexity is that we have to add a header per fragment,
> > and we don't know how many fragments will be needed prior to
> > allocations. If we take the symlink example, the header is 56 bytes
> > and hence for a 4k block size filesystem, in the worst case 16
> > headers requires 1 extra block for the 64k attribute data. For 512
> > byte filesystems the worst case is an extra block for every 9
> > fragments (i.e. 16 extra blocks in the worse case). This will be
> > very rare and so it's not really a major concern.
> > 
> > Because allocation is done in two steps - the first finds a hole
> > large enough in the attribute file, the second does the allocation -
> > we only need to find a hole big enough for a worst case allocation.
> > We only need to allocate enough extra blocks for number of headers
> > required by the fragments, and we can calculate that as we go....
> > 
> > Hence it really only makes sense to use the same model as for
> > symlinks - it doesn't add that much complexity, does not require an
> > attribute tree format change, and does not require logging
> > calculated CRC values.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Comments below.
> 
> > ---
> >  fs/xfs/xfs_attr_remote.c |  324 ++++++++++++++++++++++++++++++++++++++--------
> >  fs/xfs/xfs_attr_remote.h |   19 +++
> >  2 files changed, 292 insertions(+), 51 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> > index d0d67e9..53da46b 100644
> > --- a/fs/xfs/xfs_attr_remote.c
> > +++ b/fs/xfs/xfs_attr_remote.c
> > @@ -1,5 +1,6 @@
> >  /*
> >   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> > + * Copyright (c) 2013 Red Hat, Inc.
> >   * All Rights Reserved.
> >   *
> >   * This program is free software; you can redistribute it and/or
> > @@ -37,63 +38,232 @@
> >  #include "xfs_attr_remote.h"
> >  #include "xfs_trans_space.h"
> >  #include "xfs_trace.h"
> > -
> > +#include "xfs_cksum.h"
> > +#include "xfs_buf_item.h"
> >  
> >  #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
> >  
> >  /*
> > + * Each contiguous block has a header, so it is not just a simple attribute
> > + * length to FSB conversion.
> > + */
> > +static int
> > +xfs_attr3_rmt_blocks(
> > +	struct xfs_mount *mp,
> > +	int		attrlen)
> > +{
> > +	int		fsblocks = 0;
> > +	int		len = attrlen;
> > +
> > +	do {
> > +		fsblocks++;
> > +		len -= XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
> > +	} while (len > 0);
> > +
> > +	return fsblocks;
> > +}
> 
> The loop seems like overkill.  I think this can be calculated without looping.

Possibly, but the loop is obviously correct. The issue is that
XFS_ATTR3_RMT_BUF_SPACE() returns different lengths depending on the
crc version. Perhaps this could be done with division instead, but
it's far from a critial performance path so I haven't spend any time
trying to optimise it.

I think:

	buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);

	fsblocks = (attrlen + buflen - 1) / buflen;

should give the right value. Fixed.



> > +static bool
> > +xfs_attr3_rmt_verify(
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > +	struct xfs_attr3_rmt_hdr *rmt = bp->b_addr;
> > +
> > +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> > +		return false;
> > +	if (rmt->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
> > +		return false;
> > +	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_uuid))
> > +		return false;
> > +	if (bp->b_bn != be64_to_cpu(rmt->rm_blkno))
> > +		return false;
> > +	if (be32_to_cpu(rmt->rm_offset) +
> > +				be32_to_cpu(rmt->rm_bytes) >= MAXPATHLEN)
> > +		return false;
> 
> Why are we limited to 1024 bytes here?

Copy and paste error, I think. it was copied from the remote symlink
code. Should be XATTR_SIZE_MAX (64k). Fixed.

> 
> > +	if (rmt->rm_owner == 0)
> > +		return false;
> 
> Under what circumstances is the owner 0?

Never. Hence owner == 0 means the block is corrupted....

> > +static void
> > +xfs_attr3_rmt_write_verify(
> > +	struct xfs_buf	*bp)
> > +{
> > +	struct xfs_mount *mp = bp->b_target->bt_mount;
> > +	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> > +
> > +	/* no verification of non-crc buffers */
> > +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> > +		return;
> > +
> > +	if (!xfs_attr3_rmt_verify(bp)) {
> > +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> > +		xfs_buf_ioerror(bp, EFSCORRUPTED);
> > +		return;
> > +	}
> > +
> > +	if (bip) {
> > +		struct xfs_attr3_rmt_hdr *rmt = bp->b_addr;
> > +		rmt->rm_lsn = cpu_to_be64(bip->bli_item.li_lsn);
> > +	}
> > +	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
> > +			 XFS_ATTR3_RMT_CRC_OFF);
> 
> Should the checksum update be inside the conditional?

If CRCs aren't enabled, we don't get past the first check. Otherwise
we'll always calculate them.

> > -			xfs_buf_iomove(bp, 0, tmp, dst, XBRW_READ);
> > +			src = bp->b_addr;
> > +			if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +				if (!xfs_attr3_rmt_hdr_ok(mp, args->dp->i_ino,
> > +							offset, byte_cnt, bp)) {
> > +					xfs_alert(mp,
> > +"remote attribute header does not match required off/len/owner (0x%x/Ox%x,0x%llx)",
> > +						offset, byte_cnt, args->dp->i_ino);
> > +					xfs_buf_relse(bp);
> > +					return EFSCORRUPTED;
> > +
> > +				}
> > +
> > +				src += sizeof(struct xfs_attr3_rmt_hdr);
> > +			}
> > +
> > +			memcpy(dst, src, byte_cnt);
> 
> Not really comfortable with that yet, I'd rather stick with xfs_buf_iomove at this point.

xfs_buf_iomove() is only necessary for unmapped buffers. We are
using mapped buffers here, so xfs_buf_iomove() is unnecessary as we
are guaranteed to have a contiguous buffer to manipulate at
bp->b_addr. The above code is exactly the same as what we do all
through the directory code....

FWIW, the only place that xfs_buf_iomove() is actually used is in
xfs_attr_rmtval_get(),  xfs_attr_rmtval_set(), and xfs_buf_zero(),
so I plan to get rid of it soon and just leave xfs_buf_zero()
behind...

> > @@ -170,6 +356,27 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
> >  		       (map.br_startblock != HOLESTARTBLOCK));
> >  		lblkno += map.br_blockcount;
> >  		blkcnt -= map.br_blockcount;
> > +		hdrcnt++;
> > +
> > +		/*
> > +		 * If we have enough blocks for the attribute data, calculate
> > +		 * how many extra blocks we need for headers. We might run
> > +		 * through this multiple times in the case that the additional
> > +		 * headers in the blocks needed for the data fragments spills
> > +		 * into requiring more blocks. e.g. for 512 byte blocks, we'll
> > +		 * spill for another block every 9 headers we require in this
> > +		 * loop.
> > +		 */
> > +
> > +		if (crcs && blkcnt == 0) {
> > +			int total_len;
> > +
> > +			total_len = args->valuelen +
> > +				    hdrcnt * sizeof(struct xfs_attr3_rmt_hdr);
> > +			blkcnt = XFS_B_TO_FSB(mp, total_len);
> > +			blkcnt -= args->rmtblkcnt;
> > +			args->rmtblkcnt += blkcnt;
> > +		}
> 
> It might be better if you are optimistic here, and assume that you need only
> one header before attempting the allocation.  Then if you find that you got
> less than the number of blocks you requested due to fragmentation, try again,
> assuming that you need one additional header due to that allocation.

That's exactly what the code does. It finds a hole in the extent map
large enough for worse case fragmentation (xfs_attr3_rmt_blocks()),
then resets the block count to the best case (single header, single
extent) for the first allocation.

The above code only triggers when we don't get an allocation big
enough to fit the optimistic case, so then we go around the loop
again after incrementing the required header count by one and
recalculating the remaining number of blocks required for the next
allocation.


> > @@ -188,7 +395,8 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
> >  	lblkno = args->rmtblkno;
> >  	valuelen = args->valuelen;
> >  	while (valuelen > 0) {
> > -		int buflen;
> > +		int	byte_cnt;
> > +		char	*buf;
> >  
> >  		/*
> >  		 * Try to remember where we decided to put the value.
> > @@ -210,24 +418,38 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
> >  		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt, 0);
> >  		if (!bp)
> >  			return ENOMEM;
> > +		bp->b_ops = &xfs_attr3_rmt_buf_ops;
> > +
> > +		byte_cnt = BBTOB(bp->b_length);
> > +		byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, byte_cnt);
> > +		if (valuelen < byte_cnt) {
> > +			byte_cnt = valuelen;
> > +		}
> 
> In the case where you have a buffer that is less than the length of the
> attribute, due to fragmentation, this seems like it will memcpy off the end of
> the buffer.  

bytecnt is the space available in the destination buffer and
valuelen is the remaining number of bytes in the source buffer. it
only ever reduces the byte count if the source is smaller than the
destination. IOWs, the destination buffer can never be overrun....

> tmp = min_t(int, valuelen, buflen);

Which is functionally identical to the above code....

> > +
> > +		buf = bp->b_addr;
> > +		buf += xfs_attr3_rmt_hdr_set(mp, dp->i_ino, offset,
> > +					     byte_cnt, bp);
> > +		memcpy(buf, src, byte_cnt);
> >  
> > -		buflen = BBTOB(bp->b_length);
> > -		tmp = min_t(int, valuelen, buflen);
> > -		xfs_buf_iomove(bp, 0, tmp, src, XBRW_WRITE);
> 
> Just stick with xfs_buf_iomove.

See my comments about that above....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
