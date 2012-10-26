Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QHC2tl244729 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 12:12:02 -0500
Received: from two.mjh.name (two.mjh.name [78.47.207.35]) by cuda.sgi.com with
	ESMTP id SIPJ7Kw3LF5JcBG9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Oct 2012 10:13:47 -0700 (PDT)
Received: from jamaica.site (unknown [IPv6:2a01:198:20f:0:4107:9064:6df6:9af5])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by two.mjh.name (Postfix) with ESMTPSA id 6C2C5C05270F
	for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 17:13:46 +0000 (UTC)
Date: Fri, 26 Oct 2012 19:15:40 +0200
From: Milan =?ISO-8859-1?Q?Holz=E4pfel?= <listen@mjh.name>
Subject: Enabling quota on XFS filesystem with many files hangs
Message-Id: <20121026191540.ca9ee64db2a51e7166b7fadc@mjh.name>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello all, =


I have an XFS filesystem of size 1.2 TiB with 101 GiB free space and 14
million inodes in use. Quotas are disabled on the filesystem. I try to
enable user and group quotas by mounting with

mount /dev/xfs_device /mnt -o uquota,gquota

I first tried this with the 3.2.0 Kernel from Ubuntu 12.04 and hit an
OOM [1, 2]. In [1], it is said that the OOM is fixed in 3.5, so I tried
3.5.7 and 3.6.3 from http://kernel.ubuntu.com/~kernel-ppa/mainline/ (I
believe these are vanilla kernel.org kernels compiled with Ubuntu's
configuration). =


With 3.5.7 and 3.6.3, the OOM does not occur. For some time after
issuing the mount command, there is much I/O activity with xfs_inode
in /proc/slabinfo growing up to ~ 500k entries, which is just fine. At
some point, the I/O activity stops, but the mount does not terminate.
The system is completely idle. (The mount was the only activity on the
system.) =


In dmesg, I find

INFO: task mount:8806 blocked for more than 120 seconds.

in regular intervals. =


Can you help me with this? Thanks in advance. =


Regards,
Milan Holz=E4pfel



[1]: http://oss.sgi.com/archives/xfs/2012-06/msg00362.html
[2]: http://oss.sgi.com/archives/xfs/2012-09/msg00260.html



-- =

Milan Holz=E4pfel <listen@mjh.name>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
