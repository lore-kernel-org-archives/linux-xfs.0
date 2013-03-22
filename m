Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 779D47F54
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 04:52:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0F667AC006
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 02:52:46 -0700 (PDT)
Received: from ppsw-50.csi.cam.ac.uk (ppsw-50.csi.cam.ac.uk [131.111.8.150])
	by cuda.sgi.com with ESMTP id xMfpDn4K75mvXj1I for
	<xfs@oss.sgi.com>; Fri, 22 Mar 2013 02:52:45 -0700 (PDT)
Received: from daffy.bioc.cam.ac.uk ([131.111.36.70]:49477
	helo=[192.168.1.134])
	by ppsw-50.csi.cam.ac.uk (smtp.hermes.cam.ac.uk [131.111.8.157]:25)
	with esmtpsa (PLAIN:ge217) (TLSv1:AES128-SHA:128)
	id 1UIyeS-0001ko-sQ (Exim 4.72) for xfs@oss.sgi.com
	(return-path <ge217@cam.ac.uk>); Fri, 22 Mar 2013 09:52:44 +0000
From: Graham Eliff <ge217@cam.ac.uk>
Subject: Error 117 - help please
Message-Id: <1D4217FF-BCB8-42A2-B30A-C362E0941FCD@cam.ac.uk>
Date: Fri, 22 Mar 2013 09:52:44 +0000
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
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

Dear XFS Support
I have this error and seem unable to resolve it.
Do you have any advice please?
Many Thanks
Graham


Machine running Linux version 2.6.18-194.32.1.el5.centos.plus
CentOS release 5.5 (Final)

This is from fdisk -l

Disk /dev/sda: 3999.9 GB, 3999999721472 bytes
255 heads, 63 sectors/track, 486305 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Device Boot Start End Blocks Id System
/dev/sda1 1 267350 2147483647+ ee EFI GPT


After running xfs_repair -L /dev/sda1 this is the tail end.

disconnected inode 2691081530, moving to lost+found
disconnected inode 2691081531, moving to lost+found
disconnected inode 2691081532, moving to lost+found
disconnected inode 2691081533, moving to lost+found
corrupt dinode 2691081533, extent total = 1, nblocks = 0.  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
cache_node_purge: refcount was 1, not zero (node=0x2aaac5862840)

fatal error -- 117 - couldn't iget disconnected inode

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
