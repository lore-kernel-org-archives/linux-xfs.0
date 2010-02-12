Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CE689j256046 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 08:06:08 -0600
Received: from mail-ew0-f227.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B68F91CC64AF
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 06:07:22 -0800 (PST)
Received: from mail-ew0-f227.google.com (mail-ew0-f227.google.com
	[209.85.219.227]) by cuda.sgi.com with ESMTP id
	GT1jpzCRFZBd44rm for <xfs@oss.sgi.com>;
	Fri, 12 Feb 2010 06:07:22 -0800 (PST)
Received: by ewy27 with SMTP id 27so2604370ewy.18
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 06:07:21 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 12 Feb 2010 15:07:21 +0100
Message-ID: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>
Subject: xfs_repair on a 1.5 TiB image has been hanging for about an hour, now
From: Richard Hartmann <richih.mailinglist@gmail.com>
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
To: xfs@oss.sgi.com

Hi all,

one of our RAIDs recovered into an inconsistant state and I need to get
back what data I can.

All steps taken happened and will continue to happen under Linux with
either Debian and/or grml.

The XFS file system that can not be mounted is in a partition which is
1.5 TiB in size.
I put an additional 2 TiB drive and used dd_rescue to copy over what the
RAID presents as one large block device.

I then ran kpartx on the image to create the appropriate devices in
/dev/mapper.

As the metadata was corrupt, I ran xfs_metadump -g and -go to have a
personal backup and one I could give out if needed.

I then ran xfs_repair -L /dev/mapper/loop1p3 which has not been making
any progress for the last hour.
I don't see much load in ways of CPU or i/o, yet there is literally no
progress at all. I am hanging at:


no . entry for directory 39756
no .. entry for directory 39756
problem with directory contents in inode 39756
cleared inode 39756
data fork in ino 39771 claims free block 8391321
bad directory block magic # 0x58443242 in block 0 for directory inode 39771
corrupt block 0 in directory inode 39771
        will junk block
no . entry for directory 39771
no .. entry for directory 39771
problem with directory contents in inode 39771
cleared inode 39771
data fork in ino 39774 claims free block 44122
data fork in ino 39774 claims free block 8432730
bad directory block magic # 0x1f1f1f1f in block 0 for directory inode 39774
corrupt block 0 in directory inode 39774
        will junk block
no . entry for directory 39774
no .. entry for directory 39774
problem with directory contents in inode 39774
cleared inode 39774
multiple . entries in directory inode 39816: clearing entry
multiple .. entries in directory inode 39816: clearing entry
bad directory block magic # 0x58443244 in block 0 for directory inode 39840
corrupt block 0 in directory inode 39840
        will junk block
no . entry for directory 39840
no .. entry for directory 39840
problem with directory contents in inode 39840
cleared inode 39840
bad . entry in directory inode 39909, was 45188: correcting
data fork in ino 40102 claims free block 8400946
ab3e1b90: Badness in key lookup (length)
bp=(bno 258176, len 8192 bytes) key=(bno 258176, len 4096 bytes)
ab3e1b90: Badness in key lookup (length)
bp=(bno 258224, len 8192 bytes) key=(bno 258224, len 4096 bytes)


Is there any way to read out the current state of xfs_repair and tell
what it is doing and when it will finish? I am aware that the end time
is impossible to predict, I am just looking for ballpark figures.


Thanks a _lot_ for any and all help,
Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
