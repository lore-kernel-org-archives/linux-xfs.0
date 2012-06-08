Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q589jVWQ192257 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 04:45:31 -0500
Received: from smtp.internet-sicherheit.de (smtp.internet-sicherheit.de
	[194.94.127.56]) by cuda.sgi.com with ESMTP id QhuEmJecUBPNwX6r
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jun 2012 02:45:29 -0700 (PDT)
Received: from [10.0.44.5] (unknown [10.0.44.5])
	by smtp.internet-sicherheit.de (Postfix) with ESMTP id F2B65EE0032
	for <xfs@oss.sgi.com>; Fri,  8 Jun 2012 11:45:25 +0200 (CEST)
Message-ID: <4FD1C9B8.70907@internet-sicherheit.de>
Date: Fri, 08 Jun 2012 11:45:28 +0200
From: "Christian J. Dietrich" <dietrich@internet-sicherheit.de>
MIME-Version: 1.0
Subject: Repeated XFS corruption on RAID-10 on Adaptec 51245
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Hey all,

I have problems with an XFS volume. Upon discovering the message
"kernel: XFS (sda3): corrupt inode 3714097 (bad size 16437 for local
fork, size =3D 60)."
I ran xfs_repair /dev/sda3 (/dev/sda3 was unmounted). It reported to
have fixed some errors.
However, after a while in normal operation, another XFS corruption
occurred on /dev/sda3. I noticed that repeatedly calling xfs_repair will
always report and fix new errors, even if the volume is not mounted in
between, e.g., "rebuilding directory inode XXX" with different (new)
values of XXX.

/dev/sda is a 12 TB RAID-10 volume on an Adaptec 51245 controller. All
disks are online and none is reported faulty.

Naive, I would assume that running xfs_repair once would fix all errors.
My guess is that the underlying RAID volume (Adaptec 51245 RAID 10) is
somehow invalid (although I can not find any indicators confirming
this). Any suggestions?

I am running CentOS 6.2 (=3DRHEL 6.2) with kernel
2.6.32-220.17.1.el6.x86_64 (most recent) and all OS updates installed.
Controller Firmware is the most recent (18948), driver version is 1.1-5.
HDDs are 2x WD2001FASS, 10x WD2002FAEX.

Thanks in advance,
Chris

-- =

Christian J. Dietrich
Institute for Internet Security - if(is)
Westf=E4lische Hochschule University of Applied Sciences
https://www.internet-sicherheit.de

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
