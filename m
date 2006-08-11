Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Aug 2006 11:01:10 -0700 (PDT)
Received: from mailer.gwdg.de (mailer.gwdg.de [134.76.10.26])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7BI0tDW010397
	for <xfs@oss.sgi.com>; Fri, 11 Aug 2006 11:00:56 -0700
Date: Fri, 11 Aug 2006 20:00:08 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Directory corruption
Message-ID: <Pine.LNX.4.61.0608111955530.23379@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hello,


I was about to (finally!) fix my on-disk corruptions using a new xfsprogs, 
and this is what I got:

# xfs_check /dev/hda2
bad free block nused 1 should be 40 for dir ino 17332222 block 16777216
bad nblocks 907 for inode 109663513, counted 922
bad nblocks 849 for inode 109663521, counted 859
sb_ifree 26084, counted 26080
sb_fdblocks 1712799, counted 1712761
user quota id 0, have/exp bc 796381/796369
group quota id 0, have/exp bc 794376/794364 ic 88214/88212
group quota id 5, have/exp ic 651/653

But before I wanted to fix that, I checked which objects were affected

# find /mnt/hda2ro -inum 109663513 -o -inum 109663521
/mnt/hda2ro/var/log/kernel
/mnt/hda2ro/var/log/messages
Ok so far, but

# find /mnt/hda2ro -inum 17332222

Did not turn up anything. Is it an object that is invisible?

Jan Engelhardt
-- 
