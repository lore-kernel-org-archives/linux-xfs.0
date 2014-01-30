Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64F017F81
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 14:26:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D6AC30407A
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 12:26:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id foH2WYmtPYONmlf2 for
	<xfs@oss.sgi.com>; Thu, 30 Jan 2014 12:26:08 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0UKQ7EN001091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 15:26:08 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s0UKQ7d8013177
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 15:26:07 -0500
Message-ID: <52EAB55E.5030204@redhat.com>
Date: Thu, 30 Jan 2014 15:26:06 -0500
From: Brian Foster <bfoster@redhat.com>
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
To: xfs@oss.sgi.com

On 01/28/2014 11:28 PM, Eric Sandeen wrote:
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

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
