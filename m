Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 01:10:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3B8A4wP014755
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 01:10:05 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A92E277DE86
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 01:10:41 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id HiQCGfDgXFn0mVW2 for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 01:10:41 -0700 (PDT)
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by smtp7-g19.free.fr (Postfix) with ESMTP id B36A4322884
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 10:10:09 +0200 (CEST)
Received: from galadriel.home (pla78-1-82-235-234-79.fbx.proxad.net [82.235.234.79])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 48BC132283B
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 10:10:09 +0200 (CEST)
Date: Fri, 11 Apr 2008 10:06:50 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: About external log and barriers
Message-ID: <20080411100650.67ae85c1@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Just to mention an interesting thing I've tested : using a fast SSD
(MTRON 7000) to hold the filesystem log for a big RAID array gives an
high boost for small IO on the filesystem, somewhat similar to a "no
barrier" but much safer, and quicker for random file  1KB open and
read.

The benchmark creates 250000 1KB files, then randomly open, stat and
read them. I made an average of several runs to compensate for the
randomness of the test.

 
mkfs.xfs -f -l logdev=/dev/sdb1,size=134217728 /dev/vg0/lv0 

... testing 250000 files ...
#1 sequential create     : 189.197 seconds (1321.37 op/s).
#2 random open           : 6.199 seconds (40328.99 op/s).
#3 random stat           : 1.981 seconds (126228.58 op/s).
#4 random read           : 10.851 seconds (23038.37 op/s).
#5 sequential delete     : 50.638 seconds (4937.01 op/s).

# internal log, no barrier
#1 sequential create     : 387.128 seconds (645.78 op/s).
#2 random open           : 12.585 seconds (19864.55 op/s).
#3 random stat           : 1.935 seconds (129192.01 op/s).
#4 random read           : 35.002 seconds (7142.51 op/s).
#5 sequential delete     : 20.691 seconds (12082.71 op/s).

#internal log, with barriers (fs on /dev/sda5)
... testing 250000 files ...
#1 sequential create     : 4728.878 seconds (52.87 op/s). -> OUCH.
#2 random open           : 7.645 seconds (32700.42 op/s).
#3 random stat           : 1.931 seconds (129446.22 op/s).
#4 random read           : 15.157 seconds (6494.04 op/s).
#5 sequential delete     : too long, ^C after a few minutes!

#external log on SSD, with barriers ( fs on /dev/sda5)
... testing 250000 files ...
#1 sequential create     : 193.766 seconds (1290.22 op/s).
#2 random open           : 4.197 seconds (59567.76 op/s).
#3 random stat           : 1.967 seconds (127069.32 op/s).
#4 random read           : 13.847 seconds (18054.43 op/s).
#5 sequential delete     : 53.281 seconds (4692.11 op/s).

Apparently small writes are just too slow to be usable with barriers,
unless you're using a 1500$ SSD to store your log :)

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
