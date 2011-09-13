Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DKoOpr081682 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 15:50:24 -0500
Date: Tue, 13 Sep 2011 16:50:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Message-ID: <20110913205018.GA8543@infradead.org>
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E6EF274.7050007@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Sep 13, 2011 at 08:04:36AM +0200, Stefan Priebe - Profihost AG wrote:
> I just reported it to the scsi list as i didn't knew where the
> problems is. But then some people told be it must be a XFS problem.
> 
> Some more informations:
> 1.) It's running with 2.6.32 and 2.6.38
> 2.) I can also write to another ext2 part on the same disk
> array(aacraid driver) while xfs stucks - so i think it must be an
> xfs problem

That points a bit more towards XFS, although we've seen storage setups
create issues depending on the exact workload.  The prime culprit for
used to be the md software RAID driver, though.

> 3.) I've also tried running 3.1-rc5 but then i'm seeing this error:
> 
> BUG: unable to handle kernel NULL pointer dereference at 000000000000012c
> IP: [] inode_dio_done+0x4/0x25

Oops, that's a bug that I actually introduced myself.  Fix below:


Index: linux-2.6/fs/xfs/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_aops.c	2011-09-13 16:38:47.141089046 -0400
+++ linux-2.6/fs/xfs/xfs_aops.c	2011-09-13 16:39:09.991647077 -0400
@@ -1300,6 +1300,7 @@ xfs_end_io_direct_write(
 	bool			is_async)
 {
 	struct xfs_ioend	*ioend = iocb->private;
+	struct inode		*inode = ioend->io_inode;
 
 	/*
 	 * blockdev_direct_IO can return an error even after the I/O
@@ -1331,7 +1332,7 @@ xfs_end_io_direct_write(
 	}
 
 	/* XXX: probably should move into the real I/O completion handler */
-	inode_dio_done(ioend->io_inode);
+	inode_dio_done(inode);
 }
 
 STATIC ssize_t

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
