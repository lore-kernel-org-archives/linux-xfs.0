Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4MD7AVP067946 for <xfs@oss.sgi.com>; Sat, 22 May 2010 08:07:10 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FCA63665AB
	for <xfs@oss.sgi.com>; Sat, 22 May 2010 06:09:30 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id ZafG9DvPpTRUJq5F for
	<xfs@oss.sgi.com>; Sat, 22 May 2010 06:09:30 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4MD9QHV030521 for <xfs@oss.sgi.com>; Sat, 22 May 2010 06:09:29 -0700
Message-ID: <4BF7D787.4020903@tlinx.org>
Date: Sat, 22 May 2010 06:09:27 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfsdump -- not enough memory to dump attributes? w/>20G free -- how
	much does it need?
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
To: xfs-oss <xfs@oss.sgi.com>

I've seen the problem in the dump below and was wondering what could 
possibly cause this -- because
shows loads of free memory (>20G)...  how much memory do non-root 
attributes take to dump?


 
Dump fsname home, Mountpoint /home, Dumplevel=0
Notice: "-e" used in Xfsdump_options to allow exclusions
xfsdump -b 1m -l 0 -L home -e - /home | ( su -f -m backup -c " umask 
027;nice -19 ionice -c3 lzop > home/home-100522-0-0349.dump.lzo  " )
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.0.1 (dump format 3.0) - Running single-threaded
xfsdump: level 0 dump of Ishtar:/home
xfsdump: dump date: Sat May 22 03:49:45 2010
xfsdump: session id: 5132d03a-d58f-4899-8a3c-a2dc86efe915
xfsdump: session label: "home"
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 537916877696 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsdump: dumping non-directory files
xfsdump: WARNING: could not get list of non-root attributes for nondir 
ino 75466: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of non-root attributes for nondir 
ino 75468: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of root attributes for nondir ino 
75468: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of non-root attributes for nondir 
ino 75470: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of root attributes for nondir ino 
75470: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of non-root attributes for nondir 
ino 75497: Cannot allocate memory (12)

kernel = 2.6.34-Vanilla
xfsdump from package numberd 3.0.1-2.1
(x86_64)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
