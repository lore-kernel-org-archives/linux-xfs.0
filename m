Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2AMiVMo247986 for <xfs@oss.sgi.com>; Sat, 10 Mar 2012 16:44:42 -0600
Received: from selenium.quasiparticle.net (selenium.quasiparticle.net
	[188.40.96.248]) by cuda.sgi.com with ESMTP id TUkG5KKGPSHt5H0C
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 10 Mar 2012 14:44:07 -0800 (PST)
Received: from [10.1.0.3] (unknown [10.1.0.3])
	by selenium.quasiparticle.net (Postfix) with ESMTP id BE6E320040
	for <xfs@oss.sgi.com>; Sat, 10 Mar 2012 23:44:03 +0100 (CET)
Message-ID: <4F5BD933.8040101@sfg.quasiparticle.net>
Date: Sat, 10 Mar 2012 23:44:03 +0100
From: "Dhivael i-Khial t'Jahlei" <dhivael@sfg.quasiparticle.net>
MIME-Version: 1.0
Subject: 20 wakeups/second/mounted filesystem in xfsaild
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

i recently switched from ext4 to XFS on some systems. Much to my
surprise, XFS produces quite a lot of wakeups in kernel 3.2.9.

On every mounted filesystem, the associated xfsaild will wake up 20
times per second, when the filesystem is sufficiently loaded, it will
never wake up. The filesystems are mounted with defaults, I'm seeing the
problem on virtual IDE drives in virtual machines and SSD < dmcrypt <
LVM < XFS stacks.

Am I doing something wrong, or am I seeing expected behaviour in XFS?


 -- Sean

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
