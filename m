Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9JKh91H236676 for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 15:43:10 -0500
Received: from rrzmta4.rz.uni-regensburg.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5566D194665C
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 13:44:21 -0700 (PDT)
Received: from rrzmta4.rz.uni-regensburg.de (rrzmta4.rz.uni-regensburg.de
	[194.94.155.55]) by cuda.sgi.com with ESMTP id KRhQ7AIghh58QtV9
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 13:44:21 -0700 (PDT)
Received: from rrzmta4.rz.uni-regensburg.de (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 899A51949
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 22:44:19 +0200 (CEST)
Received: from [192.168.2.102] (rgnb-4d053a37.pool.mediaWays.net [77.5.58.55])
	(using SSLv3 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client did not present a certificate)
	(Authenticated sender: haa07761)
	by rrzmta4.rz.uni-regensburg.de (Postfix) with ESMTPSA id 448D71930
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 22:44:19 +0200 (CEST)
Subject: Question/Problem: Mounting of XFS filesystem takes a lot of time
From: Andreas Hasenkopf <andreas.hasenkopf@physik.uni-regensburg.de>
Date: Tue, 19 Oct 2010 22:44:18 +0200
Message-ID: <1287521058.2000.21.camel@x200>
Mime-Version: 1.0
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

Hello,
since today I have quite a big problem and I'd like to get some opinions
from experts on how to proceed in solving the problem.

The Problem:
Since today mounting and unmounting of any XFS partition on my system
takes (depending on size of partition) up to 15 minutes and more.

The system in its current configuration was working fine for over 6
months and I did not change anything recently with respect of upgrades.

I have already tried booting a Linux-LiveCD and mounting the XFS
partitions in that system: same result.
Also I have run xfs_check and xfs_repair -n on the partitions on the
RAID1 configuration: mounting still takes a lot of time (15 mins +).

The System:
Ubuntu 10.04 (64bit)
AMD Phenom 9600
Asus M3A32-MVP DELUXE with Marvel Raid Controller
1x 80GB HDD with ext3 (/boot) and xfs (/)
2x 1TB HDD in RAID1 configuration (xfs)

And now to my question:
Could my problem be a software related problem (Linux, XFS, something
else) or should I consider hardware problems?



Thanks for your time
Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
