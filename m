Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 16ECE7CBF
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 16:41:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E85198F8035
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 14:41:06 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	tq0lM6OWUx1dmrSX for <xfs@oss.sgi.com>;
	Tue, 26 Mar 2013 14:41:05 -0700 (PDT)
Date: Wed, 27 Mar 2013 08:40:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/21] xfs: add CRC checks to block format directory blocks
Message-ID: <20130326214050.GK6369@dastard>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-12-git-send-email-david@fromorbit.com>
	<20130326183909.GS22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130326183909.GS22182@sgi.com>
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

On Tue, Mar 26, 2013 at 01:39:09PM -0500, Ben Myers wrote:
> On Tue, Mar 12, 2013 at 11:30:44PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that directory buffers are made from a single struct xfs_buf, we
> > can add CRC calculation and checking callbacks. While there, add all
> > the fields to the on disk structures for future functionality such
> > as d_type support, uuids, block numbers, owner inode, etc.
> > 
> > To distinguish between the different on disk formats, change the
> > magic numbers for the new format directory blocks.
> 
> Comments below.
....
> > -	if (!block_ok) {
> > -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
> > -		xfs_buf_ioerror(bp, EFSCORRUPTED);
> > +	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
> > +
> > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +		if (hdr3->magic != be32_to_cpu(XFS_DIR3_BLOCK_MAGIC))
> > +			return false;
> > +		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
> > +			return false;
> > +		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
> > +			return false;
> > +	} else {
> > +		if (hdr3->magic != be32_to_cpu(XFS_DIR2_BLOCK_MAGIC))
> > +			return false;
> 
> This conditional only works because magic is in the same location in both
> versions of the header.  It would be better to use the version two header
> structure explicitly here, even though it's unlikely we'd ever want to change
> the location of the magic.

We are never going to change the location of the magic number - it
is a fundamental design premise of the entire CRC patch series that
the magic numbers are always in the same place. Hence we can use the
magic number to determine what the actual version of the structure
is and switch appropriately.

Indeed, there's code all through this series that assumes we can use
any version of the header to determine what the magic number is
andhence the correct version of the header to decode it...

> > @@ -1192,8 +1249,7 @@ xfs_dir2_sf_to_block(
> >  	/*
> >  	 * Create entry for ..
> >  	 */
> > -	dep = (xfs_dir2_data_entry_t *)
> > -		((char *)hdr + XFS_DIR2_DATA_DOTDOT_OFFSET);
> > +	dep = xfs_dir3_data_dotdot_entry_p(hdr);
> >  	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
> >  	dep->namelen = 2;
> >  	dep->name[0] = dep->name[1] = '.';
> > @@ -1203,7 +1259,7 @@ xfs_dir2_sf_to_block(
> >  	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
> >  	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
> >  				(char *)dep - (char *)hdr));
> > -	offset = XFS_DIR2_DATA_FIRST_OFFSET;
> > +	offset = xfs_dir3_data_first_offset(hdr);
> 
> Ah... the old macros are removed in a subsequent patch.  Good.

Right - they are still used by the shortform directory code at this
point.

> >  xfs_dir2_sf_nextentry(struct xfs_dir2_sf_hdr *hdr,
> >  		struct xfs_dir2_sf_entry *sfep)
> >  {
> > @@ -221,11 +253,43 @@ typedef struct xfs_dir2_data_free {
> >   */
> >  typedef struct xfs_dir2_data_hdr {
> >  	__be32			magic;		/* XFS_DIR2_DATA_MAGIC or */
> > -						/* XFS_DIR2_BLOCK_MAGIC */
> > +	/* XFS_DIR2_BLOCK_MAGIC */
> 
> Looks like an accidental whitespace change?
> 
> > +};
> > +
> > +#define XFS_DIR3_DATA_CRC_OFF  offsetof(struct xfs_dir3_data_hdr, hdr.crc)
> > +
> > +	static inline struct xfs_dir2_data_free *
> 
> Looks like an extra tab there.

Fixed.

> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -1876,6 +1876,7 @@ xlog_recover_do_reg_buffer(
> >  	int			bit;
> >  	int			nbits;
> >  	int                     error;
> > +	struct xfs_da_blkinfo	*info;
> >  
> >  	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
> >  
> > @@ -1935,6 +1936,7 @@ xlog_recover_do_reg_buffer(
> >  	/* Shouldn't be any more regions */
> >  	ASSERT(i == item->ri_total);
> >  
> > +	info = bp->b_addr;
> >  	switch (buf_f->blf_flags & XFS_BLF_TYPE_MASK) {
> >  	case XFS_BLF_BTREE_BUF:
> >  		switch (be32_to_cpu(*(__be32 *)bp->b_addr)) {
> 
> Looks like info is not used in this patch.  Maybe it snuck in from a subsequent
> patch?

Yeah, this was me starting to add magic number/verifier checks to
recovery. I didn't end up adding them in each individual dir patch -
I added a single patch at the end of the series that did it for all
of them in one go. I'll remove this code from this patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
