Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3PNHqlb041950 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 18:17:52 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E0778C2151
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 16:19:51 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org
	(173-164-175-65-SFBA.hfc.comcastbusiness.net [173.164.175.65])
	by cuda.sgi.com with ESMTP id nt5kydKDtIQqoaLi for
	<xfs@oss.sgi.com>; Sun, 25 Apr 2010 16:19:51 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3PNJfLO008365 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 16:19:45 -0700
Message-ID: <4BD4CE0D.4020102@tlinx.org>
Date: Sun, 25 Apr 2010 16:19:41 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: kernel xfsdump msg cause? page allocation failure. order:4,
	mode:0x40d0
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
To: xfs-oss <xfs@oss.sgi.com>

To whoever might know about these things... :-)

Seeing a bunch of these messages lately...

Apr 23 04:48:58 Ishtar kernel: [124868.839496] xfsdump: page allocation failure. order:4, mode:0x40d0
Apr 23 04:49:45 Ishtar kernel: [124915.266269] xfsdump: page allocation failure. order:4, mode:0x40d0
Apr 23 04:50:41 Ishtar kernel: [124971.533235] xfsdump: page allocation failure. order:4, mode:0x40d0
Apr 23 04:50:52 Ishtar kernel: [124982.665850] xfsdump: page allocation failure. order:4, mode:0x40d0
Apr 23 04:50:53 Ishtar kernel: [124983.283559] xfsdump: page allocation failure. order:4, mode:0x40d0

not sure what I broke...mismatch between application sw and kernel? Not sure what other symptoms
this is causing -- or like what this failure is doing to the dump...it appears to finish successfullly.

Running 2.6.33.2 kernel/Vanilla

Running Suse 11.2 apps, with xfs-dump-3.0.1-2.1.x86_64
(which is now separate from xfsprogs which has the same version #).

Are these messages something I should be worried about?

Thanks much!
Linda Walsh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
