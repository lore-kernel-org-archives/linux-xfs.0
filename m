Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3G6wTAY179908 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 01:58:29 -0500
Received: from mail-pz0-f46.google.com (mail-pz0-f46.google.com
	[209.85.210.46]) by cuda.sgi.com with ESMTP id PHGDt0KpSQ1ppz15
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 15 Apr 2012 23:58:28 -0700 (PDT)
Received: by dadz9 with SMTP id z9so7861978dad.5
	for <xfs@oss.sgi.com>; Sun, 15 Apr 2012 23:58:27 -0700 (PDT)
Message-ID: <4F8BC30D.5040601@kernel.org>
Date: Mon, 16 Apr 2012 14:58:21 +0800
From: Shaohua Li <shli@kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC]xfs: using GFP_NOFS for blkdev_issue_flush
References: <4F8BC112.9090508@fusionio.com>
In-Reply-To: <4F8BC112.9090508@fusionio.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org

On 4/16/12 2:49 PM, Shaohua Li wrote:
>
> flush request is issued in transaction commit code path usually, so
> looks using
> GFP_KERNEL to allocate memory for flush request bio falls into the classic
> deadlock issue (memory reclaim recursion). Use GFP_NOFS to avoid recursion
> from reclaim context. Per Dave Chinner, there is only blkdev_issue_flush
> might
> be buggy here. But using GFP_NOFS by default for all calls should not
> matter.
>
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
> fs/xfs/xfs_super.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux/fs/xfs/xfs_super.c
> ===================================================================
> --- linux.orig/fs/xfs/xfs_super.c 2012-04-13 10:08:26.095496072 +0800
> +++ linux/fs/xfs/xfs_super.c 2012-04-13 10:08:42.555496865 +0800
> @@ -622,7 +622,7 @@ void
> xfs_blkdev_issue_flush(
> xfs_buftarg_t *buftarg)
> {
> - blkdev_issue_flush(buftarg->bt_bdev, GFP_KERNEL, NULL);
> + blkdev_issue_flush(buftarg->bt_bdev, GFP_NOFS, NULL);
> }
>
> STATIC void
>
Oops, I apologize for the html mail, it slipped to wrong imap server. 
below one has correct format.

flush request is issued in transaction commit code path usually, so 
looks using
GFP_KERNEL to allocate memory for flush request bio falls into the classic
deadlock issue (memory reclaim recursion). Use GFP_NOFS to avoid recursion
from reclaim context. Per Dave Chinner, there is only blkdev_issue_flush 
might
be buggy here. But using GFP_NOFS by default for all calls should not 
matter.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
  fs/xfs/xfs_super.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/fs/xfs/xfs_super.c
===================================================================
--- linux.orig/fs/xfs/xfs_super.c	2012-04-13 10:08:26.095496072 +0800
+++ linux/fs/xfs/xfs_super.c	2012-04-13 10:08:42.555496865 +0800
@@ -622,7 +622,7 @@ void
  xfs_blkdev_issue_flush(
  	xfs_buftarg_t		*buftarg)
  {
-	blkdev_issue_flush(buftarg->bt_bdev, GFP_KERNEL, NULL);
+	blkdev_issue_flush(buftarg->bt_bdev, GFP_NOFS, NULL);
  }

  STATIC void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
