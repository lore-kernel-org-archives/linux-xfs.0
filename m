Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5MGfonp070942 for <xfs@oss.sgi.com>; Fri, 22 Jun 2012 11:41:50 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	LTDs1j2KrGa1hwlO (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Jun 2012 09:41:49 -0700 (PDT)
Date: Fri, 22 Jun 2012 12:41:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [regression] stack overflow in xfs_buf_iodone_callbacks
Message-ID: <20120622164147.GA20617@infradead.org>
References: <20120621091803.GB10673@dastard>
	<20120621163409.GA7897@infradead.org>
	<20120621232414.GD10673@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120621232414.GD10673@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jun 22, 2012 at 09:24:14AM +1000, Dave Chinner wrote:
> It may have been - I didn't catch the initial cause of the problem
> in my log because it hard-hung the VM and it wasn't in the
> scrollback buffer on the console. All I saw was a corruption error,
> a shutdown and the stack blowing up.
> 
> Still, I think there is a real problem here - any persistent device
> error on IO submission can cause this problem to occur....

Yes, I was just trying to ask what actually happened as your original
explanation didn't seem to be possible.
I think the patch below should be enough as a minimal fix to avoid the

stack overflow for 3.5. We'll need a much bigger overhaul of the buffer
error handling after that, though.


Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2012-06-22 14:20:46.696568355 +0200
+++ xfs/fs/xfs/xfs_buf.c	2012-06-22 14:21:37.733234717 +0200
@@ -1255,7 +1255,7 @@ xfs_buf_iorequest(
 	 */
 	atomic_set(&bp->b_io_remaining, 1);
 	_xfs_buf_ioapply(bp);
-	_xfs_buf_ioend(bp, 0);
+	_xfs_buf_ioend(bp, 1);
 
 	xfs_buf_rele(bp);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
