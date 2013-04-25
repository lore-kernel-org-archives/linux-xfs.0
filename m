Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E9AF229DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 13:56:09 -0500 (CDT)
Date: Thu, 25 Apr 2013 13:56:05 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 18/22] xfs: add CRC protection to remote attributes
Message-ID: <20130425185605.GE29359@sgi.com>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<1364965892-19623-19-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1364965892-19623-19-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 03, 2013 at 04:11:28PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are two ways of doing this - the first is to add a CRC to the
> remote attribute entry in the attribute block. The second is to
> treat them similar to the remote symlink, where each fragment has
> it's own header and identifies fragment location in the attribute.
> 
> The problem with the CRC in the remote attr entry is that we cannot
> identify the owner of the metadata from the metadata blocks
> themselves, or where the blocks fit into the remote attribute. The
> down side to this approach is that we never know when the attribute
> has been read from disk or not and so we have to verify it every
> time it is read, and we must calculate it during the create
> transaction and log it. We do not log CRCs for any other metadata,
> and so this creates a unique set of coherency problems that, in
> general, are best avoided.
> 
> Adding an identifying header to each allocated block allows us to
> identify each fragment and where in the attribute it is located. It
> enables us to rebuild the remote attribute from just the raw blocks
> containing the attribute. It also provides us to do per-block CRCs
> verification at IO time rather than during the transaction context
> that creates it or every time it is read into a user buffer. Hence
> it avoids all the problems that an external, logged CRC has, and
> provides all the benefits of self identifying metadata.
> 
> The only complexity is that we have to add a header per fragment,
> and we don't know how many fragments will be needed prior to
> allocations. If we take the symlink example, the header is 56 bytes
> and hence for a 4k block size filesystem, in the worst case 16
> headers requires 1 extra block for the 64k attribute data. For 512
> byte filesystems the worst case is an extra block for every 9
> fragments (i.e. 16 extra blocks in the worse case). This will be
> very rare and so it's not really a major concern.
> 
> Because allocation is done in two steps - the first finds a hole
> large enough in the attribute file, the second does the allocation -
> we only need to find a hole big enough for a worst case allocation.
> We only need to allocate enough extra blocks for number of headers
> required by the fragments, and we can calculate that as we go....
> 
> Hence it really only makes sense to use the same model as for
> symlinks - it doesn't add that much complexity, does not require an
> attribute tree format change, and does not require logging
> calculated CRC values.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Comments below.

> ---
>  fs/xfs/xfs_attr_remote.c |  324 ++++++++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_attr_remote.h |   19 +++
>  2 files changed, 292 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> index d0d67e9..53da46b 100644
> --- a/fs/xfs/xfs_attr_remote.c
> +++ b/fs/xfs/xfs_attr_remote.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> + * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
>   *
>   * This program is free software; you can redistribute it and/or
> @@ -37,63 +38,232 @@
>  #include "xfs_attr_remote.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
> -
> +#include "xfs_cksum.h"
> +#include "xfs_buf_item.h"
>  
>  #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
>  
>  /*
> + * Each contiguous block has a header, so it is not just a simple attribute
> + * length to FSB conversion.
> + */
> +static int
> +xfs_attr3_rmt_blocks(
> +	struct xfs_mount *mp,
> +	int		attrlen)
> +{
> +	int		fsblocks = 0;
> +	int		len = attrlen;
> +
> +	do {
> +		fsblocks++;
> +		len -= XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
> +	} while (len > 0);
> +
> +	return fsblocks;
> +}

The loop seems like overkill.  I think this can be calculated without looping.

> +
> +static bool
> +xfs_attr3_rmt_verify(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	struct xfs_attr3_rmt_hdr *rmt = bp->b_addr;
> +
> +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> +		return false;
> +	if (rmt->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
> +		return false;
> +	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_uuid))
> +		return false;
> +	if (bp->b_bn != be64_to_cpu(rmt->rm_blkno))
> +		return false;
> +	if (be32_to_cpu(rmt->rm_offset) +
> +				be32_to_cpu(rmt->rm_bytes) >= MAXPATHLEN)
> +		return false;

Why are we limited to 1024 bytes here?

> +	if (rmt->rm_owner == 0)
> +		return false;

Under what circumstances is the owner 0?

> +	return true;
> +}
> +
> +static void
> +xfs_attr3_rmt_read_verify(
> +	struct xfs_buf	*bp)
> +{
> +	struct xfs_mount *mp = bp->b_target->bt_mount;
> +
> +	/* no verification of non-crc buffers */
> +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> +		return;
> +
> +	if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
> +			      XFS_ATTR3_RMT_CRC_OFF) ||
> +	    !xfs_attr3_rmt_verify(bp)) {
> +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +	}
> +}
> +
> +static void
> +xfs_attr3_rmt_write_verify(
> +	struct xfs_buf	*bp)
> +{
> +	struct xfs_mount *mp = bp->b_target->bt_mount;
> +	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> +
> +	/* no verification of non-crc buffers */
> +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> +		return;
> +
> +	if (!xfs_attr3_rmt_verify(bp)) {
> +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		return;
> +	}
> +
> +	if (bip) {
> +		struct xfs_attr3_rmt_hdr *rmt = bp->b_addr;
> +		rmt->rm_lsn = cpu_to_be64(bip->bli_item.li_lsn);
> +	}
> +	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
> +			 XFS_ATTR3_RMT_CRC_OFF);

Should the checksum update be inside the conditional?

> +}
> +
> +const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
> +	.verify_read = xfs_attr3_rmt_read_verify,
> +	.verify_write = xfs_attr3_rmt_write_verify,
> +};
> +
> +static int
> +xfs_attr3_rmt_hdr_set(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	uint32_t		offset,
> +	uint32_t		size,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_attr3_rmt_hdr *rmt = bp->b_addr;
> +
> +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> +		return 0;
> +
> +	rmt->rm_magic = cpu_to_be32(XFS_ATTR3_RMT_MAGIC);
> +	rmt->rm_offset = cpu_to_be32(offset);
> +	rmt->rm_bytes = cpu_to_be32(size);
> +	uuid_copy(&rmt->rm_uuid, &mp->m_sb.sb_uuid);
> +	rmt->rm_owner = cpu_to_be64(ino);
> +	rmt->rm_blkno = cpu_to_be64(bp->b_bn);
> +	bp->b_ops = &xfs_attr3_rmt_buf_ops;
> +
> +	return sizeof(struct xfs_attr3_rmt_hdr);
> +}
> +
> +/*
> + * Checking of the remote attribute header is split into two parts. the verifier
> + * does CRC, location and bounds checking, the unpacking function checks the
> + * attribute parameters and owner.
> + */
> +static bool
> +xfs_attr3_rmt_hdr_ok(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	uint32_t		offset,
> +	uint32_t		size,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_attr3_rmt_hdr *rmt = bp->b_addr;
> +
> +	if (offset != be32_to_cpu(rmt->rm_offset))
> +		return false;
> +	if (size != be32_to_cpu(rmt->rm_bytes))
> +		return false;
> +	if (ino != be64_to_cpu(rmt->rm_owner))
> +		return false;
> +
> +	/* ok */
> +	return true;
> +

Extra line.

> +}
> +
> +/*
>   * Read the value associated with an attribute from the out-of-line buffer
>   * that we stored it in.
>   */
>  int
> -xfs_attr_rmtval_get(xfs_da_args_t *args)
> +xfs_attr_rmtval_get(
> +	struct xfs_da_args	*args)
>  {
> -	xfs_bmbt_irec_t map[ATTR_RMTVALUE_MAPSIZE];
> -	xfs_mount_t *mp;
> -	xfs_daddr_t dblkno;
> -	void *dst;
> -	xfs_buf_t *bp;
> -	int nmap, error, tmp, valuelen, blkcnt, i;
> -	xfs_dablk_t lblkno;
> +	struct xfs_bmbt_irec	map[ATTR_RMTVALUE_MAPSIZE];
> +	struct xfs_mount	*mp = args->dp->i_mount;
> +	struct xfs_buf		*bp;
> +	xfs_daddr_t		dblkno;
> +	xfs_dablk_t		lblkno = args->rmtblkno;
> +	void			*dst = args->value;
> +	int			valuelen = args->valuelen;
> +	int			nmap;
> +	int			error;
> +	int			blkcnt;
> +	int			i;
> +	int			offset = 0;
>  
>  	trace_xfs_attr_rmtval_get(args);
>  
>  	ASSERT(!(args->flags & ATTR_KERNOVAL));
>  
> -	mp = args->dp->i_mount;
> -	dst = args->value;
> -	valuelen = args->valuelen;
> -	lblkno = args->rmtblkno;
>  	while (valuelen > 0) {
>  		nmap = ATTR_RMTVALUE_MAPSIZE;
>  		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
>  				       args->rmtblkcnt, map, &nmap,
>  				       XFS_BMAPI_ATTRFORK);
>  		if (error)
> -			return(error);
> +			return error;
>  		ASSERT(nmap >= 1);
>  
>  		for (i = 0; (i < nmap) && (valuelen > 0); i++) {
> +			int	byte_cnt;
> +			char	*src;
> +
>  			ASSERT((map[i].br_startblock != DELAYSTARTBLOCK) &&
>  			       (map[i].br_startblock != HOLESTARTBLOCK));
>  			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
>  			blkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
>  			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
> -						   dblkno, blkcnt, 0, &bp, NULL);
> +						   dblkno, blkcnt, 0, &bp,
> +						   &xfs_attr3_rmt_buf_ops);
>  			if (error)
> -				return(error);
> +				return error;
> +
> +			byte_cnt = min_t(int, valuelen, BBTOB(bp->b_length));
> +			byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, byte_cnt);
>  
> -			tmp = min_t(int, valuelen, BBTOB(bp->b_length));
> -			xfs_buf_iomove(bp, 0, tmp, dst, XBRW_READ);
> +			src = bp->b_addr;
> +			if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +				if (!xfs_attr3_rmt_hdr_ok(mp, args->dp->i_ino,
> +							offset, byte_cnt, bp)) {
> +					xfs_alert(mp,
> +"remote attribute header does not match required off/len/owner (0x%x/Ox%x,0x%llx)",
> +						offset, byte_cnt, args->dp->i_ino);
> +					xfs_buf_relse(bp);
> +					return EFSCORRUPTED;
> +
> +				}
> +
> +				src += sizeof(struct xfs_attr3_rmt_hdr);
> +			}
> +
> +			memcpy(dst, src, byte_cnt);

Not really comfortable with that yet, I'd rather stick with xfs_buf_iomove at this point.

>  			xfs_buf_relse(bp);
> -			dst += tmp;
> -			valuelen -= tmp;
> +
> +			offset += byte_cnt;
> +			dst += byte_cnt;
> +			valuelen -= byte_cnt;
>  
>  			lblkno += map[i].br_blockcount;
>  		}
>  	}
>  	ASSERT(valuelen == 0);
> -	return(0);
> +	return 0;
>  }
>  
>  /*
> @@ -101,35 +271,49 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
>   * that we have defined for it.
>   */
>  int
> -xfs_attr_rmtval_set(xfs_da_args_t *args)
> +xfs_attr_rmtval_set(
> +	struct xfs_da_args	*args)
>  {
> -	xfs_mount_t *mp;
> -	xfs_fileoff_t lfileoff;
> -	xfs_inode_t *dp;
> -	xfs_bmbt_irec_t map;
> -	xfs_daddr_t dblkno;
> -	void *src;
> -	xfs_buf_t *bp;
> -	xfs_dablk_t lblkno;
> -	int blkcnt, valuelen, nmap, error, tmp, committed;
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_bmbt_irec	map;
> +	struct xfs_buf		*bp;
> +	xfs_daddr_t		dblkno;
> +	xfs_dablk_t		lblkno;
> +	xfs_fileoff_t		lfileoff = 0;
> +	void			*src = args->value;
> +	int			blkcnt;
> +	int			valuelen;
> +	int			nmap;
> +	int			error;
> +	int			hdrcnt = 0;
> +	bool			crcs = xfs_sb_version_hascrc(&mp->m_sb);
> +	int			offset = 0;
>  
>  	trace_xfs_attr_rmtval_set(args);
>  
> -	dp = args->dp;
> -	mp = dp->i_mount;
> -	src = args->value;
> -
>  	/*
>  	 * Find a "hole" in the attribute address space large enough for
> -	 * us to drop the new attribute's value into.
> +	 * us to drop the new attribute's value into. Because CRC enable
> +	 * attributes have headers, we can't just do a straight byte to FSB
> +	 * conversion. We calculate the worst case block count in this case
> +	 * and we may not need that many, so we have to handle this when
> +	 * allocating the blocks below. 
>  	 */
> -	blkcnt = XFS_B_TO_FSB(mp, args->valuelen);
> -	lfileoff = 0;
> +	if (!crcs)
> +		blkcnt = XFS_B_TO_FSB(mp, args->valuelen);
> +	else
> +		blkcnt = xfs_attr3_rmt_blocks(mp, args->valuelen);
> +
>  	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
>  						   XFS_ATTR_FORK);
> -	if (error) {
> -		return(error);
> -	}
> +	if (error)
> +		return error;
> +
> +	/* Start with the attribute data. We'll allocate the rest afterwards. */
> +	if (crcs)
> +		blkcnt = XFS_B_TO_FSB(mp, args->valuelen);
> +
>  	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
>  	args->rmtblkcnt = blkcnt;
>  
> @@ -137,6 +321,8 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
>  	 * Roll through the "value", allocating blocks on disk as required.
>  	 */
>  	while (blkcnt > 0) {
> +		int	committed;
> +
>  		/*
>  		 * Allocate a single extent, up to the size of the value.
>  		 */
> @@ -170,6 +356,27 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
>  		       (map.br_startblock != HOLESTARTBLOCK));
>  		lblkno += map.br_blockcount;
>  		blkcnt -= map.br_blockcount;
> +		hdrcnt++;
> +
> +		/*
> +		 * If we have enough blocks for the attribute data, calculate
> +		 * how many extra blocks we need for headers. We might run
> +		 * through this multiple times in the case that the additional
> +		 * headers in the blocks needed for the data fragments spills
> +		 * into requiring more blocks. e.g. for 512 byte blocks, we'll
> +		 * spill for another block every 9 headers we require in this
> +		 * loop.
> +		 */
> +
> +		if (crcs && blkcnt == 0) {
> +			int total_len;
> +
> +			total_len = args->valuelen +
> +				    hdrcnt * sizeof(struct xfs_attr3_rmt_hdr);
> +			blkcnt = XFS_B_TO_FSB(mp, total_len);
> +			blkcnt -= args->rmtblkcnt;
> +			args->rmtblkcnt += blkcnt;
> +		}

It might be better if you are optimistic here, and assume that you need only
one header before attempting the allocation.  Then if you find that you got
less than the number of blocks you requested due to fragmentation, try again,
assuming that you need one additional header due to that allocation.

>  
>  		/*
>  		 * Start the next trans in the chain.
> @@ -188,7 +395,8 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
>  	lblkno = args->rmtblkno;
>  	valuelen = args->valuelen;
>  	while (valuelen > 0) {
> -		int buflen;
> +		int	byte_cnt;
> +		char	*buf;
>  
>  		/*
>  		 * Try to remember where we decided to put the value.
> @@ -210,24 +418,38 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
>  		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt, 0);
>  		if (!bp)
>  			return ENOMEM;
> +		bp->b_ops = &xfs_attr3_rmt_buf_ops;
> +
> +		byte_cnt = BBTOB(bp->b_length);
> +		byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, byte_cnt);
> +		if (valuelen < byte_cnt) {
> +			byte_cnt = valuelen;
> +		}

In the case where you have a buffer that is less than the length of the
attribute, due to fragmentation, this seems like it will memcpy off the end of
the buffer.  

tmp = min_t(int, valuelen, buflen);

Min_t handled that situation, I think.

> +
> +		buf = bp->b_addr;
> +		buf += xfs_attr3_rmt_hdr_set(mp, dp->i_ino, offset,
> +					     byte_cnt, bp);
> +		memcpy(buf, src, byte_cnt);
>  
> -		buflen = BBTOB(bp->b_length);
> -		tmp = min_t(int, valuelen, buflen);
> -		xfs_buf_iomove(bp, 0, tmp, src, XBRW_WRITE);

Just stick with xfs_buf_iomove.

> -		if (tmp < buflen)
> -			xfs_buf_zero(bp, tmp, buflen - tmp);
> +		if (byte_cnt < BBTOB(bp->b_length))
> +			xfs_buf_zero(bp, byte_cnt,
> +				     BBTOB(bp->b_length) - byte_cnt);
>  
>  		error = xfs_bwrite(bp);	/* GROT: NOTE: synchronous write */
>  		xfs_buf_relse(bp);
>  		if (error)
>  			return error;
> -		src += tmp;
> -		valuelen -= tmp;
> +
> +		src += byte_cnt;
> +		valuelen -= byte_cnt;
> +		offset += byte_cnt;
> +		hdrcnt--;
>  
>  		lblkno += map.br_blockcount;
>  	}
>  	ASSERT(valuelen == 0);
> -	return(0);
> +	ASSERT(hdrcnt == 0);
> +	return 0;
>  }
>  
>  /*
> @@ -306,7 +528,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
>  			ASSERT(committed);
>  			args->trans = NULL;
>  			xfs_bmap_cancel(args->flist);
> -			return(error);
> +			return error;
>  		}
>  
>  		/*
> diff --git a/fs/xfs/xfs_attr_remote.h b/fs/xfs/xfs_attr_remote.h
> index 2a34b9a..0ca8d9a 100644
> --- a/fs/xfs/xfs_attr_remote.h
> +++ b/fs/xfs/xfs_attr_remote.h
> @@ -18,6 +18,25 @@
>  #ifndef __XFS_ATTR_REMOTE_H__
>  #define	__XFS_ATTR_REMOTE_H__
>  
> +#define XFS_ATTR3_RMT_MAGIC	0x5841524d	/* XARM */
> +
> +struct xfs_attr3_rmt_hdr {
> +	__be32	rm_magic;
> +	__be32	rm_offset;
> +	__be32	rm_bytes;
> +	__be32	rm_crc;
> +	uuid_t	rm_uuid;
> +	__be64	rm_owner;
> +	__be64	rm_blkno;
> +	__be64	rm_lsn;
> +};
> +
> +#define XFS_ATTR3_RMT_CRC_OFF	offsetof(struct xfs_attr3_rmt_hdr, rm_crc)
> +
> +#define XFS_ATTR3_RMT_BUF_SPACE(mp, bufsize)	\
> +	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
> +			sizeof(struct xfs_attr3_rmt_hdr) : 0))
> +
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set(struct xfs_da_args *args);
>  int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
