Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1BEtIK8154859 for <xfs@oss.sgi.com>; Thu, 11 Feb 2010 08:55:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 979F8139A4F0
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2010 06:56:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kyJmZjOBvGJfU5F8 for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2010 06:56:33 -0800 (PST)
Date: Thu, 11 Feb 2010 09:56:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.32.3 x86_64 - XFS hangs, all I/O to D-state bug (again)
Message-ID: <20100211145632.GA16912@infradead.org>
References: <alpine.DEB.2.00.1002110903080.25392@p34.internal.lan>
	<20100211145123.GA13114@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100211145123.GA13114@infradead.org>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Feb 11, 2010 at 09:51:23AM -0500, Christoph Hellwig wrote:
> Can you check if this still happens with the patch below?

Or the 2.6.32 variant of it:

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-02-11 15:52:14.442003504 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2010-02-11 15:52:33.172024387 +0100
@@ -1182,8 +1182,7 @@ _xfs_buf_ioapply(
 		bp->b_flags &= ~_XBF_RUN_QUEUES;
 		rw = (bp->b_flags & XBF_WRITE) ? WRITE_SYNC : READ_SYNC;
 	} else {
-		rw = (bp->b_flags & XBF_WRITE) ? WRITE :
-		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
+		rw = (bp->b_flags & XBF_WRITE) ? WRITE : READ;
 	}
 
 	/* Special code path for reading a sub page size buffer in --

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
