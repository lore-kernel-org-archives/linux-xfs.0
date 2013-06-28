Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E3F2A7F5D
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 13:12:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B8AE98F8037
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 11:12:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gAeiURdsSsbEzpmb for
	<xfs@oss.sgi.com>; Fri, 28 Jun 2013 11:12:41 -0700 (PDT)
Message-ID: <51CDD15E.5070006@redhat.com>
Date: Fri, 28 Jun 2013 14:09:34 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/6] create internal eofblocks structure with kuid_t types
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
	<20130628111131.3ad961e9@oracle.com>
In-Reply-To: <20130628111131.3ad961e9@oracle.com>
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
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, xfs@oss.sgi.com

On 06/28/2013 11:11 AM, Dwight Engen wrote:
> Have eofblocks ioctl convert uid_t to kuid_t into internal structure.
> Update internal filter matching to compare ids with kuid_t types.
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  fs/xfs/xfs_fs.h     |  2 +-
>  fs/xfs/xfs_icache.c |  6 +++---
>  fs/xfs/xfs_ioctl.c  | 34 ++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_linux.h  |  8 ++++++++
>  4 files changed, 44 insertions(+), 6 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index bedf510..487dca5 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1328,6 +1328,31 @@ xfs_ioc_getbmapx(
>  	return 0;
>  }
>  
> +STATIC int
> +xfs_fs_eofblocks_to_internal(
> +	struct xfs_fs_eofblocks		*src,
> +	struct xfs_eofblocks		*dst)
> +{
> +	dst->eof_flags = src->eof_flags;
> +	dst->eof_prid = src->eof_prid;
> +	dst->eof_min_file_size = src->eof_min_file_size;
> +
> +	if (src->eof_flags & XFS_EOF_FLAGS_UID) {
> +		dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
> +		if (!uid_valid(dst->eof_uid))
> +			return XFS_ERROR(EINVAL);
> +	}
> +
> +	if (src->eof_flags & XFS_EOF_FLAGS_GID) {
> +		dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
> +		if (!gid_valid(dst->eof_gid))
> +			return XFS_ERROR(EINVAL);
> +	}
> +
> +	return 0;
> +}

Is there any harm in removing the policy from this function, storing a
potentially invalid kuid's in the xfs_eofblocks and letting the caller
determine whether an error should be returned? IOW, this function becomes:

inline void
xfs_fs_eofblocks_to_internal(
	struct xfs_fs_eofblocks		*src,
	struct xfs_eofblocks		*dst)
{
	dst->eof_flags = src->eof_flags;
	dst->eof_prid = src->eof_prid;
	dst->eof_min_file_size = src->eof_min_file_size;
	dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
	dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
}

... and xfs_file_ioctl() can check the XFS_EOF_FLAGS_UID/GID flags and
validity of the value to determine whether an error should be returned.

Also, I suspect xfs_icache.h might be a better home for this function.

> +
> +
>  /*
>   * Note: some of the ioctl's return positive numbers as a
>   * byte count indicating success, such as readlink_by_handle.
> @@ -1610,7 +1635,8 @@ xfs_file_ioctl(
>  		return -error;
>  
>  	case XFS_IOC_FREE_EOFBLOCKS: {
> -		struct xfs_eofblocks eofb;
> +		struct xfs_fs_eofblocks eofb;
> +		struct xfs_eofblocks keofb;
>  
>  		if (copy_from_user(&eofb, arg, sizeof(eofb)))
>  			return -XFS_ERROR(EFAULT);
> @@ -1625,7 +1651,11 @@ xfs_file_ioctl(
>  		    memchr_inv(eofb.pad64, 0, sizeof(eofb.pad64)))
>  			return -XFS_ERROR(EINVAL);
>  
> -		error = xfs_icache_free_eofblocks(mp, &eofb);
> +		error = xfs_fs_eofblocks_to_internal(&eofb, &keofb);
> +		if (error)
> +			return -XFS_ERROR(error);
> +
> +		error = xfs_icache_free_eofblocks(mp, &keofb);
>  		return -error;
>  	}
>  
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 761e4c0..3c2f403 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -185,6 +185,14 @@ static inline kgid_t xfs_gid_to_kgid(__uint32_t gid)
>  	return make_kgid(&init_user_ns, gid);
>  }
>  
> +struct xfs_eofblocks {
> +	__u32		eof_flags;
> +	kuid_t		eof_uid;
> +	kgid_t		eof_gid;
> +	prid_t		eof_prid;
> +	__u64		eof_min_file_size;
> +};
> +

xfs_icache.h?

Brian

>  /*
>   * Various platform dependent calls that don't fit anywhere else
>   */
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
