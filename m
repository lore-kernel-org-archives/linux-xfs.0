Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3ODO0jT070176 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 08:24:00 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id CS97ehDl8sj54Rrj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Apr 2012 06:23:59 -0700 (PDT)
Received: by pbcuo1 with SMTP id uo1so141312pbc.26
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 06:23:58 -0700 (PDT)
Date: Tue, 24 Apr 2012 21:23:46 +0800
From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC]xfs: using GFP_NOFS for blkdev_issue_flush
Message-ID: <20120424132346.GA24575@kernel.org>
References: <4F8BC112.9090508@fusionio.com> <4F8BC30D.5040601@kernel.org>
	<20120418013746.GL6734@dastard>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120418013746.GL6734@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Wed, Apr 18, 2012 at 11:37:46AM +1000, Dave Chinner wrote:
> On Mon, Apr 16, 2012 at 02:58:21PM +0800, Shaohua Li wrote:
> > On 4/16/12 2:49 PM, Shaohua Li wrote:
> > >
> > >flush request is issued in transaction commit code path usually, so
> > >looks using
> > >GFP_KERNEL to allocate memory for flush request bio falls into the classic
> > >deadlock issue (memory reclaim recursion). Use GFP_NOFS to avoid recursion
> > >from reclaim context. Per Dave Chinner, there is only blkdev_issue_flush
> > >might
> > >be buggy here. But using GFP_NOFS by default for all calls should not
> > >matter.
> 
> Can you update the commit message like I suggested previously?
Copied exactly.


Issuing a block device flush request in transaction context using GFP_KERNEL
directly can cause deadlocks due to memory reclaim recursion. Use GFP_NOFS to
avoid recursion from reclaim context.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
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
