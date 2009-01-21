Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0LAXE8M010252 for <xfs@oss.sgi.com>; Wed, 21 Jan 2009 04:33:15 -0600
Received: from ppsw-6.csi.cam.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48F7EA5DD3
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2009 02:33:11 -0800 (PST)
Received: from ppsw-6.csi.cam.ac.uk (ppsw-6.csi.cam.ac.uk [131.111.8.136]) by
	cuda.sgi.com with ESMTP id frZvQSiFWvQu49JM for
	<xfs@oss.sgi.com>; Wed, 21 Jan 2009 02:33:11 -0800 (PST)
Received: from hermes-2.csi.cam.ac.uk ([131.111.8.54]:46395)
	by ppsw-6.csi.cam.ac.uk (smtp.hermes.cam.ac.uk [131.111.8.156]:25)
	with esmtpa (EXTERNAL:osd1000) id 1LPaOU-0004uc-Jr (Exim 4.70) for
	xfs@oss.sgi.com (return-path <osd1000@hermes.cam.ac.uk>);
	Wed, 21 Jan 2009 10:33:10 +0000
Received: from osd1000 (helo=localhost) by hermes-2.csi.cam.ac.uk
	(hermes.cam.ac.uk)
	with local-esmtp id 1LPaOU-0006Fh-4V (Exim 4.67) for xfs@oss.sgi.com
	(return-path <osd1000@hermes.cam.ac.uk>);
	Wed, 21 Jan 2009 10:33:10 +0000
Date: Wed, 21 Jan 2009 10:33:10 +0000 (GMT)
From: Owen Dunn <osd1000@cam.ac.uk>
Subject: No space left on device on xfs filesystem with 1.6TB free
Message-ID: <alpine.LSU.2.00.0901211007200.19898@hermes-2.csi.cam.ac.uk>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

I'm running SuSE Linux Enterprise Server 10 SP2, on a 32-bit i386 Linux 
machine with kernel version 2.6.16.60-0.33-smp.  I appear to have version 
2.9.4 of xfsprogs.

I have a 6TB xfs filesystem which has been grown twice from 2TB, and which 
appears to have 1.6TB and plenty of inodes free.  However, attempts to 
create a new file fail with ENOSPC:

sf3:/EXPORT/space # touch splat
touch: cannot touch `splat': No space left on device
sf3:/EXPORT/space # df -h .
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/bigvg-lv1
                       6.0T  4.5T  1.6T  75% /EXPORT/space
sf3:/EXPORT/space # df -ih .
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/bigvg-lv1
                         4.0G    887K    4.0G    1% /EXPORT/space

Any idea what's going on and how to fix it?  xfs_check stops straight away 
with `out of memory' and xfs_repair stops in Phase 6, presumably when it 
finds itself unable to make a new lost+found directory.

Owen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
