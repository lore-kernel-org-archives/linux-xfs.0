Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3C1727CA0
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 15:28:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3717304039
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 13:28:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id m3zQnlb5mx7rhuBS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 30 Aug 2016 13:28:23 -0700 (PDT)
Date: Tue, 30 Aug 2016 16:28:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: rewrite and optimize the delalloc write path
Message-ID: <20160830202820.GA16503@bfoster.bfoster>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
	<1471816273-28940-5-git-send-email-hch@lst.de>
	<20160825143708.GD25041@bfoster.bfoster>
	<20160826143344.GB21535@lst.de>
	<20160826160339.GC17728@bfoster.bfoster>
	<20160826160753.GD17728@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160826160753.GD17728@bfoster.bfoster>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Aug 26, 2016 at 12:07:53PM -0400, Brian Foster wrote:
> On Fri, Aug 26, 2016 at 12:03:39PM -0400, Brian Foster wrote:
> > On Fri, Aug 26, 2016 at 04:33:44PM +0200, Christoph Hellwig wrote:
> > > On Thu, Aug 25, 2016 at 10:37:09AM -0400, Brian Foster wrote:
> ...
> > > (we could potentially re-derive offset_fsb from offset if we don't
> > > mind the inefficieny and recalculate maxbytes_fsb.  This already
> > > assumes mp is trivially derived from ip)
> > > 
> > > and return
> > > 
> > > alloc_blocks, end_fsb
> > > 
> > > so the function would be quite a monster in terms of its calling
> > > convention.  Additionally we'd have the related by not qute the
> > > same if blocks around XFS_MOUNT_DFLT_IOSIZE and the isize split
> > > over two functions, which doesn't exactly help understanding
> > > the flow.
> > > 
> > 
> > Not quite sure I follow the last bit, but I don't necessarily think the
> > whole thing has to be boxed into a helper to clean it up. E.g., I'd do
> > something like the appended diff (compile tested only).
> > 
> 
> ... and if the function signature is really an issue, trade off idx &
> prev for a conditional base preallocation size (applies on top of the
> previous diff):
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 45e5268..c748429 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -381,7 +381,7 @@ STATIC xfs_fsblock_t
>  xfs_iomap_prealloc_size(
>  	struct xfs_inode	*ip,
>  	xfs_off_t		offset,
> -	struct xfs_bmbt_irec	*prev)
> +	xfs_extlen_t		base)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			shift = 0;
> @@ -406,8 +406,8 @@ xfs_iomap_prealloc_size(
>  	 * always extends to MAXEXTLEN rather than falling short due to things
>  	 * like stripe unit/width alignment of real extents.
>  	 */
> -	if (prev->br_blockcount <= (MAXEXTLEN >> 1))
> -		alloc_blocks = prev->br_blockcount << 1;
> +	if (base <= (MAXEXTLEN >> 1))
> +		alloc_blocks = base << 1;
>  	else
>  		alloc_blocks = XFS_B_TO_FSB(mp, offset);
>  	if (!alloc_blocks)
> @@ -506,12 +506,10 @@ xfs_iomap_prealloc(
>  	struct xfs_inode	*ip,
>  	loff_t			offset,
>  	loff_t			count,
> -	xfs_extnum_t		idx,
> -	struct xfs_bmbt_irec	*prev)
> +	xfs_extlen_t		base)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fsblock_t		alloc_blocks;
> -	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  
>  	if (offset + count <= XFS_ISIZE(ip))
>  		return 0;
> @@ -526,12 +524,11 @@ xfs_iomap_prealloc(
>  	 */
>  	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
>  	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
> -	    idx == 0 ||
> -	    prev->br_startoff + prev->br_blockcount < offset_fsb)
> +	    !base)
>  		alloc_blocks = mp->m_writeio_blocks;
>  	else
>  		alloc_blocks =
> -			xfs_iomap_prealloc_size(ip, offset, prev);
> +			xfs_iomap_prealloc_size(ip, offset, base);
>  
>  	return alloc_blocks;
>  }
> @@ -603,8 +600,15 @@ xfs_file_iomap_begin_delay(
>  	end_fsb = orig_end_fsb =
>  		min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
>  
> -	if (eof)
> -		prealloc = xfs_iomap_prealloc(ip, offset, count, idx, &prev);
> +	if (eof) {
> +		xfs_extlen_t	base = 0;
> +
> +		/* use prev extent as base if contiguous */
> +		if (idx > 0 &&
> +		    prev.br_startoff + prev.br_blockcount < offset_fsb)

This should probably be: startoff + blockcount == offset_fsb

Brian

> +			base = prev.br_blockcount;
> +		prealloc = xfs_iomap_prealloc(ip, offset, count, base);
> +	}
>  	if (prealloc) {
>  		xfs_off_t	aligned_offset;
>  		xfs_extlen_t	align;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
