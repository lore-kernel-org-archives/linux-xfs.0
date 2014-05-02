Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FD917F57
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 08:47:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8EB130405F
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 06:47:50 -0700 (PDT)
Received: from mail-ee0-f50.google.com (mail-ee0-f50.google.com
	[74.125.83.50]) by cuda.sgi.com with ESMTP id QpVL63xDKNRm1ACC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 06:47:49 -0700 (PDT)
Received: by mail-ee0-f50.google.com with SMTP id c13so3223409eek.9
	for <xfs@oss.sgi.com>; Fri, 02 May 2014 06:47:47 -0700 (PDT)
Received: from [192.168.1.14] ([37.131.65.197])
	by mx.google.com with ESMTPSA id q41sm4745878eez.7.2014.05.02.06.47.29
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Fri, 02 May 2014 06:47:47 -0700 (PDT)
Message-ID: <5363A1D8.2020402@gmail.com>
Date: Fri, 02 May 2014 16:47:04 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: XFS filesystem claims to be mounted after a disconnect
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512



I ran into a problem using XFS. The USB device on which I have an XFS
file system got disconnected and xfs_repair and xfs_check fail with a
message saying the file system is mounted writable. There is no entry
in /etc/mtab or /proc/mounts. However I see messages in the kernel log
(dmesg) about write failures to the disconnected drive.


Please let me know what I can do short of zeroing the log, which I
believe would result in some data loss.

Martin


# xfs_repair /dev/sdd104
xfs_repair: /dev/sdd104 contains a mounted filesystem

fatal error -- couldn't initialize XFS library
# xfs_check /dev/sdd104
xfs_check: /dev/sdd104 contains a mounted and writable filesystem

fatal error -- couldn't initialize XFS library


partial dmesg output:

[346220.652432] Buffer I/O error on device sdb104, logical block
3906961152
[346220.652440] Buffer I/O error on device sdb104, logical block
3906961153
[346220.652443] Buffer I/O error on device sdb104, logical block
3906961154
[346220.652446] Buffer I/O error on device sdb104, logical block
3906961155
[346220.652449] Buffer I/O error on device sdb104, logical block
3906961156
[346220.652452] Buffer I/O error on device sdb104, logical block
3906961157
[346220.652455] Buffer I/O error on device sdb104, logical block
3906961158
[346220.652459] Buffer I/O error on device sdb104, logical block
3906961159
[346220.652473] Buffer I/O error on device sdb104, logical block
3906961352
[346220.652476] Buffer I/O error on device sdb104, logical block
3906961353
[346554.917502] quiet_error: 1924 callbacks suppressed
[346554.917510] Buffer I/O error on device sdb104, logical block 0
[346554.917518] Buffer I/O error on device sdb104, logical block 1
[346554.917522] Buffer I/O error on device sdb104, logical block 2
[346554.917525] Buffer I/O error on device sdb104, logical block 3
[346554.917529] Buffer I/O error on device sdb104, logical block 4
[346554.917532] Buffer I/O error on device sdb104, logical block 5
[346554.917536] Buffer I/O error on device sdb104, logical block 6
[346554.917539] Buffer I/O error on device sdb104, logical block 7
[346554.951030] Buffer I/O error on device sdb104, logical block
3906961152
[346554.951051] Buffer I/O error on device sdb104, logical block
3906961153

The current disk is /dev/sdd104 and sdb104 doesn't appear anywhere in
the kernel, despite the messages in dmesg.

# cat /proc/partitions
major minor  #blocks  name

   7        0     131072 loop0
   8        0  488386584 sda
   8        1     204800 sda1
   8        2  104384512 sda2
   8        3          1 sda3
   8        4   15471640 sda4
   8        5   30403584 sda5
   8        6     104391 sda6
   8        7  117187584 sda7
  11        0    1048575 sr0
   8       64 1953481728 sde
   8       75 1953480687 sde11
   8       80  312571224 sdf
   8       48 1953481728 sdd
 259        0 1953480687 sdd104


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTY6GrAAoJELsEaSRwbVYrTwcQAKNYds36X3wUssi1Zbcn+AXi
UJuvx3QYVY6OF7huitlM/m9Ih9gOfFVQEbVvHEqoHXwEx2y6a5/KzCGoSHSXsxUj
KLFgXxgbdTsGEIePfW3R1v3JyY9TmuDx/U39gMPuM2nRy2sFCXc6HpBJFfUJf4uo
GY1y+w+LzFE2bTQYG+F0sWhUnBWq9klGoTsZYsghEpLNnaLgdrHLqpJkgb8RIy2C
O1sCbRD+Crs/a5W2ijCNOTchU1yV8oJOK4D7HkyyFUMqG2XRUkeRMntA93r9byo9
kYlzNJUbSPB2onzRacq5ygMKp816+e7sQaBFuYTZQB6IQRk3NGf6PWKwLBO+pY3d
2lqbjkt12jtuth6xlxiUHps83D8X/tEWz0a8oQMfjIyAoZZJTCZdg/Hd9HyVUg5A
mWPu4UpvXDsTCY/rt3owJrL+VCCxPXumpgAnKc7EiMjbjZBMDIK9YwvEpWSrtt8H
Ak11w4bdCoML/oDIK8LV/SHGinSHAC/sOaEBSX5IfvQeIeohoK7cN400jYFzkMgu
p5ZsiEtRHwl2tnZ9bgm52TYUH6KMI1qGuTPJoOWfKe7XgXAzmx+ppnzuUtDGKi1y
NXNHuD18J8InFCI08mIKaCkIg9yA/6c7Mhq2EaS+QeURcUNyUsi3J2Q7+wv34JJ0
i8TsGzSUYkqrWwDLa1+c
=gR4I
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
