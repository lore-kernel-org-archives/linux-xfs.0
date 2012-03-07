Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q27HdPXe136564 for <xfs@oss.sgi.com>; Wed, 7 Mar 2012 11:39:25 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id gu2AhbUKe9vMGGpZ for <xfs@oss.sgi.com>;
	Wed, 07 Mar 2012 09:39:24 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 2A5434963345
	for <xfs@oss.sgi.com>; Wed,  7 Mar 2012 11:39:24 -0600 (CST)
Message-ID: <4F579D4C.4040208@sandeen.net>
Date: Wed, 07 Mar 2012 11:39:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Printk for ENOSPC due to lack of inodes
References: <20120227003733.GA28162@Xye>
In-Reply-To: <20120227003733.GA28162@Xye>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 2/26/12 6:37 PM, Raghavendra D Prabhu wrote:
> Hi,
> 
> While diagnosing a MySQL crash (on a Centos 5.7 box), I noticed that
> it had failed with ENOSPC earlier; it was rebooted after that; now
> after reboot, even though space was there, ENOSPC was showing up, I
> also did df -i and it showed inodes available. At this point,
> mounting with inode64 option was tried, which fixed it. 
> http://oss.sgi.com/archives/xfs/2011-03/msg00299.html helped me
> here.

Yeah, that's kind of a bummer.  And given the semi-ugly situation
we're in with inode32, maybe a syslog message would be good.

But a few things; I don't think we want to warn on every inode-allocation
ENOSPC.  Ideally I'd probably do a WARN_ON_ONCE or a ratelimited printk.
xfs_warn_once_per_fs()?  :)

I'd probably also want to only do it in the case where the ENOSPC was due
to either inode32, or due to fragmented freespace.

Without looking very hard yet; could this be done in xfs_dialloc() so that
the exact reason for the ENOSPC can be issued?  (maxicount, inode32, or
no free contiguous space...)

-Eric

> 
> So, I have attached a patch here.
> 
> =====================================================================
> 
> 
> When a ENOSPC is encountered and it is due to lack of inodes (particularly
> without inode64), it is not possible to detect this (df -i doesn't help here),
> so adding a printk which can aid in detecting this.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  fs/xfs/xfs_qm.c       |    3 +++
>  fs/xfs/xfs_vnodeops.c |   10 ++++++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index c872fea..fbefa87 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -987,6 +987,9 @@ xfs_qm_qino_alloc(
>  
>      error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip, &committed);
>      if (error) {
> +        if (error == ENOSPC)
> +            xfs_err(mp, "Out of inodes: Required %d, Current %llu, Maximum %llu",
> +                    XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
>          xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
>                   XFS_TRANS_ABORT);
>          return error;
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index ebdb888..7542c36 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -946,8 +946,11 @@ xfs_create(
>      error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev,
>                     prid, resblks > 0, &ip, &committed);
>      if (error) {
> -        if (error == ENOSPC)
> +        if (error == ENOSPC) {
> +            xfs_err(mp, "Out of inodes: Required %d, Current %llu, Maximum %llu",
> +                    XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
>              goto out_trans_cancel;
> +        }
>          goto out_trans_abort;
>      }
>  
> @@ -1610,8 +1613,11 @@ xfs_symlink(
>      error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
>                     prid, resblks > 0, &ip, NULL);
>      if (error) {
> -        if (error == ENOSPC)
> +        if (error == ENOSPC) {
> +            xfs_err(mp, "Out of inodes: Required %d, Current %llu, Maximum %llu",
> +                    XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
>              goto error_return;
> +        }
>          goto error1;
>      }
>  
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
