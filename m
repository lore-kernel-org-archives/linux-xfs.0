Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBBDLfRL042633 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 07:21:41 -0600
Received: from itoolabs.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A05BB2AF80C
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 05:21:39 -0800 (PST)
Received: from itoolabs.net (be02.de01.itoolabs.net [188.40.74.249]) by
	cuda.sgi.com with ESMTP id oUpZVIIIAoTazDfh for
	<xfs@oss.sgi.com>; Sun, 11 Dec 2011 05:21:39 -0800 (PST)
Received: from [92.234.50.176] (account dop@itoolabs.co.uk HELO
	dmitry-panovs-macbook.local)
	by be02-de01.itoolabs.net (CommuniGate Pro SMTP 5.3.10)
	with ESMTPSA id 939660 for xfs@oss.sgi.com;
	Sun, 11 Dec 2011 13:21:38 +0000
Message-ID: <4EE4AE61.6000306@yahoo.co.uk>
Date: Sun, 11 Dec 2011 13:21:37 +0000
From: Dmitry Panov <dmitry.panov@yahoo.co.uk>
MIME-Version: 1.0
Subject: Data corruption, md5 changes on every mount
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

Hi guys,

I have a 2TiB XFS which is about 60% full. Recently I've noticed that 
the daily inc. backup reports file contents change for files that are 
not supposed to change.

I've created an LVM snapshot and ran xfs_check/xfs_repair. xfs_check did 
report a few problems (unknown node type). After that I ran a simple 
test: mount, calculate md5 of the problematic files, report if it 
changed, umount, sleep 10 sec. That script reported that md5 sum of at 
least one file was changing on every cycle.

Analyzing the differences I found that a 4k block that should contain 
all zeros sometimes contains random garbage (luckily most of the files 
are pcm wavs, so it's easy to verify). However I did not analyze every 
occurrence so this may be not 100% true. The files do not look as they 
are sparse according to du. Interestingly one of them appears to occupy 
one block more than necessary.

Then I did cp -a file newfile, mv newfile file and re-ran the test. No 
problems reported since.

As there were a few unclean umounts I think most likely it is a 
filesystem corruption that went unspotted by xfs_repair. It would not 
surprise me too much because xfs_repair took just 3.5 min.

Any ideas? I could just copy the files and pretend noting happened but 
is there a guarantee that doing so won't corrupt other data?


Best regards,

-- 
Dmitry Panov

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
