Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0LA3q2v162149 for <xfs@oss.sgi.com>; Sat, 21 Jan 2012 04:03:53 -0600
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	eerYNywcDz9pGLn2 for <xfs@oss.sgi.com>;
	Sat, 21 Jan 2012 02:03:42 -0800 (PST)
Received: by eaal1 with SMTP id l1so680373eaa.26
	for <xfs@oss.sgi.com>; Sat, 21 Jan 2012 02:03:41 -0800 (PST)
From: Christian Kildau <lists@unixhosts.org>
Subject: How to fix bad superblock or xfs_repair: error - read only 0 of 512
	bytes
Date: Sat, 21 Jan 2012 11:03:39 +0100
Message-Id: <A7348842-BA7C-474A-B2E1-04345761AB25@unixhosts.org>
Mime-Version: 1.0 (Apple Message framework v1251.1)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

I'm having some very serious issues with XFS after upgrading from a Linux D=
istro running Ubuntu 2.6.32 to 3.2.

It seems like my filesystems are damaged after attaching them to a Linux 3.=
2 server. I am also no longer able to mount the hdd on the old server that =
is still running 2.6.32!

'test disk' does find the filesystem as XFS 4 and i created a 1.5TB dump of=
 it to another hdd.

(I created the xfs filesystem on the entire hdd, not on a partition, so /de=
v/sdd is not a typo)

$ sudo mount -t xfs /dev/sdd /media/
mount: /dev/sdd: can't read superblock
(dmesg)
[236659.912663] attempt to access beyond end of device
[236659.912667] sdd: rw=3D32, want=3D2930277168, limit=3D2930275055
[236659.912670] XFS (sdd): last sector read failed

$ sudo xfs_check /dev/sdd
xfs_check: error - read only 0 of 512 bytes

$ sudo xfs_repair /dev/sdd
Phase 1 - find and verify superblock...
xfs_repair: error - read only 0 of 512 bytes


'testdisk' does find the filesystem as XFS 4 and i created a 1.5TB dump of =
it to another hdd.

Is there any way I can fix this? - Except restroring from backup? Because t=
his IS my backup!
see ubuntuforums.org/showthread.php?t=3D1910962 for more details=85


Any help is appreciated!

Thanks in advance
Chris
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
