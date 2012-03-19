Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2JEirCc133573
	for <linux-xfs@oss.sgi.com>; Mon, 19 Mar 2012 09:44:55 -0500
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id EZiFP7KQLu48TrKD (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Mon, 19 Mar 2012 07:44:52 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1S9dpI-0005Rf-O6
	for linux-xfs@oss.sgi.com; Mon, 19 Mar 2012 15:44:49 +0100
Received: from office1.visionpointsystems.com ([216.252.206.159])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 19 Mar 2012 15:44:48 +0100
Received: from acook by office1.visionpointsystems.com with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 19 Mar 2012 15:44:48 +0100
From: Alan Cook <acook@visionpointsystems.com>
Subject: ftruncate() Writes Last Block of File
Date: Mon, 19 Mar 2012 14:44:33 +0000 (UTC)
Message-ID: <loom.20120319T153420-855@post.gmane.org>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

I have three questions regarding the XFS implementation of ftruncate().  In the
block device driver, I can see that writes are being performed to the last block
of previously written file when ftruncate() is called.  I believe that I found
ftruncate() in the XFS sources, but all I see is the filesize being updated in
the inode.  So if ftruncate() is writing to the last block, it appears to be a
triggered event.

To test, I added printk() statements in the block device driver that outputs
jiffies for write operations.  A file is created and written (~1 MiB), and then
truncated to 8192 via ftruncate().  The original write to file happens about 20
jiffies before the call to ftruncate().  When looking at the output, there is an
additional write to what is the last block of the truncated file, which reports
the same jiffies as the call to ftruncate().

I am not reporting this as a bug, simply looking for more information, as it was
not something that I expected to happen.

Does ftruncate() actually write to the last block of the file?  If not, any
thoughts on what would be?  It only happens when ftruncate() is called.

Where in the XFS kernel code is ftruncate() implemented?  I searched around, but
have no confidence that what I see is actually the ftruncate() implementation.

If ftruncate() does write to the last block of the file, why does it do so?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
