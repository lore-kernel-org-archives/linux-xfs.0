Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KE5Hog017328 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 08:05:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9439FA193F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:05:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IL9BxEFDorMR7dK5 for
	<xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:05:16 -0800 (PST)
Date: Tue, 20 Jan 2009 09:05:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120140514.GA2976@infradead.org>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net>
	<20090120004611.GA6445@disturbed>
	<20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com>
	<20090120114906.GA12526@infradead.org>
	<20090120121335.GA19182@infradead.org>
	<20090120124515.GA31838@infradead.org> <4975D88B.7020906@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4975D88B.7020906@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Tue, Jan 20, 2009 at 02:58:35PM +0100, Jacek Luczak wrote:
> Good job! Is there some ,,quick'' fix?

The patch below makes it go away for me, alternatively just enable
CONFIG_LBD.


Index: linux-2.6/fs/xfs/xfs_types.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_types.h	2009-01-20 14:55:55.806068213 +0100
+++ linux-2.6/fs/xfs/xfs_types.h	2009-01-20 14:56:01.437945154 +0100
@@ -96,7 +96,7 @@ typedef	__uint64_t	xfs_dfilblks_t;	/* nu
 /*
  * Memory based types are conditional.
  */
-#if XFS_BIG_BLKNOS
+#if 1 //XFS_BIG_BLKNOS
 typedef	__uint64_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
 typedef __uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
 typedef __uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
