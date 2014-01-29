Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC5B07F80
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 08:58:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A19978F8039
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 06:58:55 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id OS2LwI2bkwqOZCF5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jan 2014 06:58:54 -0800 (PST)
Message-ID: <52E91727.2060106@oracle.com>
Date: Wed, 29 Jan 2014 22:58:47 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: sanitize sb_inopblock in xfs_mount_validate_sb
References: <52E88357.6090104@redhat.com>
In-Reply-To: <52E88357.6090104@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>


On 01/29 2014 12:28 AM, Eric Sandeen wrote:
> xfs_mount_validate_sb doesn't check sb_inopblock for sanity
> (as does its xfs_repair counterpart, FWIW).
> 
> If it's out of bounds, we can go off the rails in i.e.
> xfs_inode_buf_verify(), which uses sb_inopblock as a loop
> limit when stepping through a metadata buffer.
> 
> The problem can be demonstrated easily by corrupting
> sb_inopblock with xfs_db and trying to mount the result:
> 
> # mkfs.xfs -dfile,name=fsfile,size=1g
> # xfs_db -x fsfile 
> xfs_db> sb 0
> xfs_db> write inopblock 512
> inopblock = 512
> xfs_db> quit
> 
> # mount -o loop fsfile  mnt
> and we blow up in xfs_inode_buf_verify().
> 
> With this patch, we get a (very noisy) corruption error,
> and fail the mount as we should.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
> index b7c9aea..511cce9 100644
> --- a/fs/xfs/xfs_sb.c
> +++ b/fs/xfs/xfs_sb.c
> @@ -288,6 +288,7 @@ xfs_mount_validate_sb(
>  	    sbp->sb_inodelog < XFS_DINODE_MIN_LOG			||
>  	    sbp->sb_inodelog > XFS_DINODE_MAX_LOG			||
>  	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
> +	    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
>  	    (sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog)	||
>  	    (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE)	||
>  	    (sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)	||

Looks good to me.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
