Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5F6F77F3F
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 10:21:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2E91F304070
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 08:21:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Fg1KHQzeA98cOmXz for
	<xfs@oss.sgi.com>; Wed, 24 Jul 2013 08:21:38 -0700 (PDT)
Message-ID: <51EFE428.3050302@redhat.com>
Date: Wed, 24 Jul 2013 10:26:48 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 5/7] xfs: create internal eofblocks structure with
	kuid_t types
References: <20130724005256.55220dc2@oracle.com>
In-Reply-To: <20130724005256.55220dc2@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On 07/24/2013 12:52 AM, Dwight Engen wrote:
> Have eofblocks ioctl convert uid_t to kuid_t into internal structure.
> Update internal filter matching to compare ids with kuid_t types.
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  fs/xfs/xfs_fs.h     |  2 +-
>  fs/xfs/xfs_icache.c | 12 ++++++------
>  fs/xfs/xfs_icache.h | 33 +++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_ioctl.c  | 10 +++++++---
>  4 files changed, 47 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index d046955..7eb4a5e 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -344,7 +344,7 @@ typedef struct xfs_error_injection {
>   * Speculative preallocation trimming.
>   */
>  #define XFS_EOFBLOCKS_VERSION		1
> -struct xfs_eofblocks {
> +struct xfs_fs_eofblocks {
>  	__u32		eof_version;
>  	__u32		eof_flags;
>  	uid_t		eof_uid;
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 3f90e1c..ed35584 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -619,7 +619,7 @@ restart:
>  
>  /*
>   * Background scanning to trim post-EOF preallocated space. This is queued
> - * based on the 'background_prealloc_discard_period' tunable (5m by default).
> + * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
>   */
>  STATIC void
>  xfs_queue_eofblocks(
> @@ -1203,15 +1203,15 @@ xfs_inode_match_id(
>  	struct xfs_inode	*ip,
>  	struct xfs_eofblocks	*eofb)
>  {
> -	if (eofb->eof_flags & XFS_EOF_FLAGS_UID &&
> -	    ip->i_d.di_uid != eofb->eof_uid)
> +	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
> +	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
>  		return 0;
>  
> -	if (eofb->eof_flags & XFS_EOF_FLAGS_GID &&
> -	    ip->i_d.di_gid != eofb->eof_gid)
> +	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
> +	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
>  		return 0;
>  
> -	if (eofb->eof_flags & XFS_EOF_FLAGS_PRID &&
> +	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
>  	    xfs_get_projid(ip) != eofb->eof_prid)
>  		return 0;
>  
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index a01afbb..3835df2 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -21,6 +21,14 @@
>  struct xfs_mount;
>  struct xfs_perag;
>  
> +struct xfs_eofblocks {
> +	__u32		eof_flags;
> +	kuid_t		eof_uid;
> +	kgid_t		eof_gid;
> +	prid_t		eof_prid;
> +	__u64		eof_min_file_size;
> +};
> +
>  #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
>  #define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
>  
> @@ -49,4 +57,29 @@ int xfs_inode_ag_iterator_tag(struct xfs_mount *mp,
>  		int flags, void *args),
>  	int flags, void *args, int tag);
>  
> +static inline int
> +xfs_fs_eofblocks_from_user(
> +	struct xfs_fs_eofblocks		*src,
> +	struct xfs_eofblocks		*dst)
> +{
> +	dst->eof_flags = src->eof_flags;
> +	dst->eof_prid = src->eof_prid;
> +	dst->eof_min_file_size = src->eof_min_file_size;
> +
> +	dst->eof_uid = INVALID_UID;
> +	if (src->eof_flags & XFS_EOF_FLAGS_UID) {
> +		dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
> +		if (!uid_valid(dst->eof_uid))
> +			return EINVAL;
> +	}
> +
> +	dst->eof_gid = INVALID_GID;
> +	if (src->eof_flags & XFS_EOF_FLAGS_GID) {
> +		dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
> +		if (!gid_valid(dst->eof_gid))
> +			return EINVAL;
> +	}
> +	return 0;
> +}
> +

Originally I thought the error checking in the ioctl() was more clear,
but it's not a big deal and the rename to *_from_user() clarifies the
functionality.

>  #endif
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 8edc780..ecab261 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1610,7 +1610,8 @@ xfs_file_ioctl(
>  		return -error;
>  
>  	case XFS_IOC_FREE_EOFBLOCKS: {
> -		struct xfs_eofblocks eofb;
> +		struct xfs_fs_eofblocks eofb;
> +		struct xfs_eofblocks keofb;
>  
>  		if (copy_from_user(&eofb, arg, sizeof(eofb)))
>  			return -XFS_ERROR(EFAULT);
> @@ -1625,8 +1626,11 @@ xfs_file_ioctl(
>  		    memchr_inv(eofb.pad64, 0, sizeof(eofb.pad64)))
>  			return -XFS_ERROR(EINVAL);
>  
> -		error = xfs_icache_free_eofblocks(mp, &eofb);
> -		return -error;
> +		error = xfs_fs_eofblocks_from_user(&eofb, &keofb);
> +		if (error)
> +			return -error;
> +
> +		return -xfs_icache_free_eofblocks(mp, &keofb);

But if we're going to create a generic *_from_user() helper, why not
be consistent and push all of the validity checks into the helper? E.g.,
the version check, flags validity check and zeroed-padding checks...

Brian

>  	}
>  
>  	default:
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
