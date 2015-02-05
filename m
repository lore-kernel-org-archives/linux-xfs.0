Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E50D7FD0
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 18:48:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9FBCBAC005
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 16:48:33 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ABoZn0jeCoziDEz3 for <xfs@oss.sgi.com>;
	Wed, 04 Feb 2015 16:48:13 -0800 (PST)
Date: Thu, 5 Feb 2015 11:47:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/20] xfs: implement pNFS export operations
Message-ID: <20150205004758.GO4251@dastard>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-20-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421925006-24231-20-git-send-email-hch@lst.de>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Thu, Jan 22, 2015 at 12:10:05PM +0100, Christoph Hellwig wrote:
> Add operations to export pNFS block layouts from an XFS filesystem.  See
> the previous commit adding the operations for an explanation of them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Note that I haven't applied this patch, or attempted to compile it
yet....

> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index d617999..df68285 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -121,3 +121,4 @@ xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
>  xfs-$(CONFIG_PROC_FS)		+= xfs_stats.o
>  xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
>  xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
> +xfs-$(CONFIG_NFSD_PNFS)		+= xfs_pnfs.o

... because I'll have to jump through hoops to get it to compile, I
think.

> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 74c6211..99465ba 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -602,6 +602,8 @@ xfs_growfs_data(
>  	if (!mutex_trylock(&mp->m_growlock))
>  		return -EWOULDBLOCK;
>  	error = xfs_growfs_data_private(mp, in);
> +	if (!error)
> +		mp->m_generation++;
>  	mutex_unlock(&mp->m_growlock);
>  	return error;
>  }

Even on error I think we should bump this. Errors can come from
secondary superblock updates after the filesystem has been grown,
hence an error is not a reliable indication of whether the layout
has changed or not.

> +int
> +xfs_fs_get_uuid(
> +	struct super_block	*sb,
> +	u8			*buf,
> +	u32			*len,
> +	u64			*offset)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +
> +	if (*len < sizeof(uuid_t))
> +		return -EINVAL;
> +
> +	memcpy(buf, &mp->m_sb.sb_uuid, sizeof(uuid_t));
> +	*len = sizeof(uuid_t);
> +	*offset = offsetof(struct xfs_dsb, sb_uuid);

What purpose does the offset serve here? I can't tell from the usage
in the PNFS code. Can we ignore offset - as it seems entirely
arbitrary - and still have this work? Either way, comment please.


> +static void
> +xfs_bmbt_to_iomap(
> +	struct xfs_inode	*ip,
> +	struct iomap		*iomap,
> +	struct xfs_bmbt_irec	*imap)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	if (imap->br_startblock == HOLESTARTBLOCK) {
> +		iomap->blkno = -1;
> +		iomap->type = IOMAP_HOLE;
> +	} else if (imap->br_startblock == DELAYSTARTBLOCK) {
> +		iomap->blkno = -1;
> +		iomap->type = IOMAP_DELALLOC;

I'd like to see a IOMAP_NULL_BLOCK define here for the -1 value,
say:

#define IOMAP_NULL_BLOCK	-1LL

> +int
> +xfs_fs_map_blocks(
> +	struct inode		*inode,
> +	loff_t			offset,
> +	u64			length,
> +	struct iomap		*iomap,
> +	bool			write,
> +	u32			*device_generation)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_bmbt_irec	imap;
> +	xfs_fileoff_t		offset_fsb, end_fsb;
> +	loff_t			limit;
> +	int			bmapi_flags = XFS_BMAPI_ENTIRE;
> +	int			nimaps = 1;
> +	uint			lock_flags;
> +	int			error = 0;
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return -EIO;
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		return -ENXIO;

OK, so we are not mapping realtime inodes here. Any specific reason?
FWIW, that also means you can use XFS_FSB_TO_DADDR() in the iomap
mapping as xfs_fsb_to_db() is only needed if we might be mapping
realtime extents...

> +	for (i = 0; i < nr_maps; i++) {
> +		u64 start, length, end;
> +
> +		start = maps[i].offset;
> +		if (start > size)
> +			continue;
> +
> +		end = start + maps[i].length;
> +		if (end > size)
> +			end = size;
> +
> +		length = end - start;
> +		if (!length)
> +			continue;
> +	
   ^^^^^
Stray whitespace

> +	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
> +	if (error)
> +		goto out_drop_iolock;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	xfs_setattr_time(ip, iattr);
> +	if (iattr->ia_valid & ATTR_SIZE) {
> +		if (iattr->ia_size > i_size_read(inode)) {
> +			i_size_write(inode, iattr->ia_size);
> +			ip->i_d.di_size = iattr->ia_size;
> +		}
> +	}

The concern I have about this is that extending the file size can
expose uninitialised blocks beyond the old EOF. That can happen if
delayed allocation has previously been done on the file and we
haven't trimmed the excess beyond EOF back yet. I know the pnfs
server is not aimed at mixed usage, but it still makes me
uncomfortable in the case where you have normal NFS and PNFS clients
accessing the same files...

> +	xfs_trans_set_sync(tp);
> +	error = xfs_trans_commit(tp, 0);

I just had a thought about these sync transctions - could the NFS
server handle persistence of the maps via ->commit_metadata?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
