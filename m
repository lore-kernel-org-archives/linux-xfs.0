Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9VCQIjG067281 for <xfs@oss.sgi.com>; Sat, 31 Oct 2009 07:26:18 -0500
Received: from mxout-08.mxes.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27C924F90D
	for <xfs@oss.sgi.com>; Sat, 31 Oct 2009 05:26:29 -0700 (PDT)
Received: from mxout-08.mxes.net (mxout-08.mxes.net [216.86.168.183]) by
	cuda.sgi.com with ESMTP id UzueG1n8pEm1yAoW for
	<xfs@oss.sgi.com>; Sat, 31 Oct 2009 05:26:29 -0700 (PDT)
Received: from [192.168.1.144] (unknown [209.94.131.238])
	by smtp.mxes.net (Postfix) with ESMTPA id 7E730509DF
	for <xfs@oss.sgi.com>; Sat, 31 Oct 2009 08:26:28 -0400 (EDT)
Message-ID: <4AEC2CF4.8040703@aol.com>
Date: Sat, 31 Oct 2009 08:26:28 -0400
From: "AndrewL733@aol.com" <AndrewL733@aol.com>
MIME-Version: 1.0
Subject: XFS and DPX files
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

For many years and with great success, I have been capturing and editing 
high bandwidth video on Linux systems with XFS filesystems exported via 
Samba. However, I am currently running into a problem and I am wondering 
if somebody has some hints about how to solve it.

Whereas in the past, I have been working with video formats such as MXF 
and QuickTime -- in which a video clip is represented by a single file 
(or by a handful of files -- one video, several audio) I now find myself 
having to deal with DPX files. Unlike MXF or QuickTime files, the DPX 
format creates one file for each frame of video or film.  For American 
video, that's about 30 files per second, 1800 files per minute, and so on.


I have a high performance 10-gigabit-based NAS that allows me to capture 
and playback "single file" uncompressed HD video streams (up to 160 
MB/sec per stream) without any problems.  I can also PLAY BACK so-called 
2K DPX video, which has the "1 file per frame structure" and has a 
higher data rate than uncompressed HD -- a bit over 300 MB/sec. However, 
when I go to WRITE DPX files, that's where the trouble begins. Even when 
I am recording "standard definition" DPX files at only a data rate of 
about 40 MB/sec or 1.3 MB/file, I am having trouble.

This is what I am observing:

1)  When I begin recording, I can see that data immediately starts 
moving across the network at a steady rate of about 41-42 MB/sec, and 
data also starts getting written to the hardware RAID at the same steady 
rate (3ware 9650 + 16 x 7200 RPM enterprise-class SATA disks)

2)  After about 3 minutes of recording, or after about 6000 files have 
been written, suddenly my server is no longer writing to the RAID 
subsystem.  The data continues to come in through the network interface, 
but the writing stops.  When I look at vmstat, I can see that "outgoing 
blocks" pretty much grind to a halt at this point.

3)  Then, after about 5-10 seconds of pause, the system begins writing 
to the RAID again.  All the while, the data has been coming into the 
network interface at a fairly steady 41-42 MB/sec.  The writing never 
seems to "catch up" and about 10 seconds after the writing begins again, 
the client application stops sending data because it senses that it has 
"dropped frames".

4)  Level 5 Samba show some curious errors now and then about 
"xfs_quota" failing -- but they don't seem to be concentrated just at 
the point where the writing stops.

   [2009/10/30 15:00:59, 3] lib/sysquotas.c:sys_get_quota(433)
   sys_get_xfs_quota() failed for mntpath[/mnt/vol1] bdev[/dev/sdb1]
   qtype[2] id[502]: No such file or directory.


By the way, I tried mounting my XFS filesytsems without quota support -- 
I don't see these messages any more, but I also still have the same 
problem that the system stops writing to the disks after about 3 minutes.

5)  If I export an iSCSI target from the exact same NAS (via iSCSI 
Enterprise Target, for example), mount it on my Windows machine and 
format it as NTFS, I don't have any trouble capturing for an hour or 
more.  So, there is clearly nothing wrong with the network or the 
cabling or the RAID subsystem itself.

6)  Similarly, if I format my storage with EXT3 instead of XFS and 
export the volume via Samba, I don't have any trouble recording for the 
same very long periods of time.  I DO observe a very different pattern 
of writing to the storage, however.  While 41-42 MB/sec comes in 
steadily over the network interface, with ext3-formated disks, the NAS 
writes to the storage at about 200-250 MB/sec every now and then.  Then 
there is no writing activity for about 4-5 seconds.  Then another burst 
of 200-250 MB/sec again. And the pattern continues.

7)  My NAS system is running a plain-vanilla 2.6.20.15 kernel.org 
kernel.  It is a 64-bit system with 3.2 Ghz Quad Core Intel 5482 CPUs 
and 4 GBs of RAM.  However, I see EXACTLY the same behavior on an an 
even more powerful Nehalem-based system with 2.93 Ghz Quad Core CPU and 
6 GBs RAM and the very latest 2.6.31.4 kernel. So, I don't think it has 
anything to do with the XFS version or the hardware, for instance. And 
as I said above, I don't have trouble handling much higher data rates 
when I am only creating a few files per hour, versus creating 30 files 
per second.

My hunch is that the problem is related to the number of files I am 
creating per second. Could it be that XFS is not handling this situation 
well, whereas this doesn't pose a problem for EXT3 or iSCSI/NTFS?  I am 
wondering if there are any specific XFS formating or mounting options 
that would make a huge difference (size of log, sectorsize, agsize, 
inode size, allocation group count, log buffers at mounting, etc).

Any ideas here? Is this a known issue? And is there a workaround? Any 
help would be greatly appreciated.

Andrew

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
