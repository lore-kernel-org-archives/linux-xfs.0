Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E0367F62
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 00:46:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5430A304039
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 22:46:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	UOfsTt7xqs6cINKW for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 22:46:19 -0700 (PDT)
Date: Fri, 19 Jul 2013 15:46:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 5/7] xfs: create internal eofblocks structure with
	kuid_t types
Message-ID: <20130719054618.GW11674@dastard>
References: <20130717114740.77f7bcee@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130717114740.77f7bcee@oracle.com>
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

On Wed, Jul 17, 2013 at 11:47:40AM -0400, Dwight Engen wrote:
> Have eofblocks ioctl convert uid_t to kuid_t into internal structure.
> Update internal filter matching to compare ids with kuid_t types.
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
....
>  
> +static inline void
> +xfs_fs_eofblocks_to_internal(
> +	struct xfs_fs_eofblocks		*src,
> +	struct xfs_eofblocks		*dst)

I'd prefer that be named xfs_fs_eofblocks_from_user() to make it
clear that we don't trust the contents of src at all...

> +{
> +	dst->eof_flags = src->eof_flags;
> +	dst->eof_prid = src->eof_prid;
> +	dst->eof_min_file_size = src->eof_min_file_size;
> +	dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
> +	dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
> +}
> +
>  #endif
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 8edc780..abbbdcf 100644
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
> @@ -1625,7 +1626,17 @@ xfs_file_ioctl(
>  		    memchr_inv(eofb.pad64, 0, sizeof(eofb.pad64)))
>  			return -XFS_ERROR(EINVAL);
>  
> -		error = xfs_icache_free_eofblocks(mp, &eofb);
> +		xfs_fs_eofblocks_to_internal(&eofb, &keofb);
> +
> +		if (keofb.eof_flags & XFS_EOF_FLAGS_UID &&
> +		    !uid_valid(keofb.eof_uid))
> +			return XFS_ERROR(EINVAL);
> +
> +		if (keofb.eof_flags & XFS_EOF_FLAGS_GID &&
> +		    !gid_valid(keofb.eof_gid))
> +			return XFS_ERROR(EINVAL);

And I think these two checks should be in
xfs_fs_eofblocks_from_user(), hence pushing all the conversion and
validation of the user-supplied parameters into the one function.

Also, we need to return negative errors from this function....

> +		error = xfs_icache_free_eofblocks(mp, &keofb);
>  		return -error;

		return -xfs_icache_free_eofblocks(mp, &keofb);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
