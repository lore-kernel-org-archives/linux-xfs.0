Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 19:32:11 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B2W8m1027290
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 19:32:08 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A075318B15AF
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 19:33:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id WNttfAiq3H7Cf0wI for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 19:33:13 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 125C7AC6278
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:33:12 -0500 (CDT)
Message-ID: <4876C667.608@sandeen.net>
Date: Thu, 10 Jul 2008 21:33:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: deadlocked xfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

while running fs_mark:

fs_mark -d /mnt/test -D 256 -n 100000 -t 4 -s 20480 -F -S 0

which runs 4 threads making 20k files,things got stuffed up in the log,
see sysrq-w output at:

http://sandeen.fedorapeople.org/xfs/deadxfs

2 threads down this path:

 [<ffffffffa03c89f5>] :xfs:xlog_state_get_iclog_space+0x83/0x187
 [<ffffffffa03c8c1a>] :xfs:xlog_write+0x121/0x486
 [<ffffffffa03c9043>] :xfs:xfs_log_write+0x2a/0x50

this is on a 4 cpu AMD.

I made the fs with:

mkfs.xfs -dsize=1t,agcount=32 -l lazy-count=1 -f /dev/sdb

and mounted with:

mount -o nobarrier,logbsize=256k,logbufs=8,inode64 /dev/sdb /mnt/test

has this been seen before?

Thanks,

-Eric
