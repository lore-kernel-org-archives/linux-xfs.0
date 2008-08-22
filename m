Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Aug 2008 15:25:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7MMPQsq013901
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 15:25:26 -0700
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3D71FA98C3
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 15:26:47 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.188]) by cuda.sgi.com with ESMTP id zLmW3juRy2cQTgKq for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 15:26:47 -0700 (PDT)
Date: Sat, 23 Aug 2008 00:26:46 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: agi unlinked bucket
Message-ID: <alpine.DEB.1.10.0808230017150.20126@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi there,

there's an XFS here (and since it's mounted on top of a dm-crypt device, 
it's not checked regulary. Checking the filesystem just now gave:

----------------------
# xfs_repair -V
xfs_repair version 2.9.8
# blockdev --getsize64 /dev/mapper/md3
147445706752
# xfs_check /dev/mapper/md3
agi unlinked bucket 26 is 20208090 in ag 0 (inode=20208090)
link count mismatch for inode 128 (name ?), nlink 333, counted 334
link count mismatch for inode 20208090 (name ?), nlink 0, counted 1
Command exited with non-zero status 3
----------------------

Should I worry? Would it be safe to run xfs_repair on it?
Searching for these errors in the archives only brings up scenarios with 
kernel oopses involved. Not here, the box is running fine (2.6.27-rc3, 
i386) and the filesystem is doing its job.

Thanks,
Christian.
-- 
BOFH excuse #198:

Post-it Note Sludge leaked into the monitor.
