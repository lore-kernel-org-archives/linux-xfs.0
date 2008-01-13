Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Jan 2008 08:23:37 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0DGNVvv009221
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 08:23:33 -0800
Received: from harold.telenet-ops.be (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B570A514390
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 08:23:48 -0800 (PST)
Received: from harold.telenet-ops.be (harold.telenet-ops.be [195.130.133.65]) by cuda.sgi.com with ESMTP id JU1jGEMwevmFKoYI for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 08:23:48 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by harold.telenet-ops.be (Postfix) with SMTP id 6039C3004E
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 17:23:15 +0100 (CET)
Received: from 78-20-142-234.access.telenet.be (78-20-142-234.access.telenet.be [78.20.142.234])
	by harold.telenet-ops.be (Postfix) with ESMTP id 540BF30024
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 17:23:15 +0100 (CET)
From: "Grozdan Nikolov (openSUSE Linux)" <microchip@telenet.be>
Subject: Cannot delete a directory on a XFS file system
Date: Sun, 13 Jan 2008 17:23:12 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801131723.12626.microchip@telenet.be>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I have a small problem with XFS on a small 40 GB IDE disk that I use for my 
music collection. The disk (/dev/hdb) has only one partition on it formatted 
as XFS. On this partition, there is a directory that no matter what I do, I 
cannot delete it. I tried everything, in Konqueror, right-click on the 
directory and choose to delete it. As root on the console 
doing "rm -rf /media/data/DATA/MusicApps" ... but nothing works. 

When I try to "rm -rf" on this directory I get a message saying...

rm: cannot remove directory `MusicApps/Loops/loops/Acid Loops/Bass': Directory 
not empty

But the "Bass" directory is completely empty, there's nothing in there. Also 
when I unmount the file system and do a "xfs_check /dev/hdb1" I get a message 
saying...

link count mismatch for inode 184549517 (name ?), nlink 3, counted 2

I did several times "xfs_repair /dev/hdb1" but I still get the same result. 
xfs_check reports the same message and I still can't get rid of this empty 
directory. I'm using kernel 2.6.24-rc7, but it's the same with other kernels. 
I also did check the partition for bad block with the "badblocks" program, 
but nothing came out, so the disk is just fine.

Any ideas how I can delete this directory?
