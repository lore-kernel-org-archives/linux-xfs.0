Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBKDmIf0138163 for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 07:48:18 -0600
Received: from mail-lpp01m010-f53.google.com (mail-lpp01m010-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id cpmXAwf2PVxzscje
	for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 05:48:16 -0800 (PST)
Received: by lagr15 with SMTP id r15so3185872lag.26
	for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 05:48:15 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 20 Dec 2011 19:18:15 +0530
Message-ID: <CADDb1s1cSM0vS3gnO369hwHwe5dJ0Afaf_6wNVDf0eT-jTvKCg@mail.gmail.com>
Subject: XFS: attempt to access beyond end of device
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
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
To: xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>

Hi,

While trying to open a file with a large number of extents in append
mode =96 it resulted in the below error logs continually.
I was trying to open the file in append mode, but it showed error, so
I checked for the extents =96 it has around 2238 extents. Although, it
is not repetitive, when I try on next mount and write =96 it is working
fine at times.
Also, the system does not seem to be corrupted. Since, running
xfs_repair after umount does not show any errors.
I am getting this on highly fragmented files.

xfs_bmap
/mnt/test_file:
        0: [0..591]: 2429232..2429823
        1: [592..1615]: 2427776..2428799
        2: [1616..2639]: 2426752..2427775
        3: [2640..3663]: 2425728..2426751
        4: [3664..4687]: 2424704..2425727
        5: [4688..5711]: 2423680..2424703
        6: [5712..6735]: 2422656..2423679=85
=85
=85
        2364: [2420304..2421327]: 7016..8039
        2365: [2421328..2422351]: 5992..7015
        2366: [2422352..2423375]: 4968..5991
        2367: [2423376..2424399]: 3944..4967
        2368: [2424400..2425423]: 2920..3943
        2369: [2425424..2426447]: 1896..2919
        2370: [2426448..2863695]: 3249048..3686295
        2371: [2863696..3553871]: 3686312..4376487
[  723.020000] attempt to access beyond end of device
[  723.020000] sda1: rw=3D0, want=3D1075794104417808, limit=3D19551042
[  723.028000] I/O error in filesystem ("sda1") meta-data dev sda1
block 0x3d26dd571fe08       ("xfs_trans_read_buf") error 5 buf count
4096
[  723.040000] xfs_force_shutdown(sda1,0x1) called from line 417 of
file fs/xfs/xfs_trans_buf.c.  Return address =3D 0xc022a810
[  723.052000] Filesystem "sda1": I/O Error Detected.  Shutting down
filesystem: sda1
[  723.060000] Please umount the filesystem, and rectify the problem(s)
[  723.064000] attempt to access beyond end of device
[  723.068000] sda1: rw=3D0, want=3D1075794104417808, limit=3D19551042
[  723.076000] I/O error in filesystem ("sda1") meta-data dev sda1
block 0x3d26dd571fe08       ("xfs_trans_read_buf") error 5 buf count
4096
[  723.088000] xfs_force_shutdown(sda1,0x1) called from line 417 of
file fs/xfs/xfs_trans_buf.c.  Return address =3D 0xc022a810
[  723.100000] attempt to access beyond end of device
[  723.104000] sda1: rw=3D0, want=3D1075794104417808, limit=3D19551042
[  723.108000] I/O error in filesystem ("sda1") meta-data dev sda1
block 0x3d26dd571fe08       ("xfs_trans_read_buf") error 5 buf count
4096

[  723.120000] xfs_force_shutdown(sda1,0x1) called from line 417 of
file fs/xfs/xfs_trans_buf.c.  Return address =3D 0xc022a810
[  723.132000] attempt to access beyond end of device
[  723.136000] sda1: rw=3D0, want=3D1075794104417808, limit=3D19551042
[  723.144000] I/O error in filesystem ("sda1") meta-data dev sda1
block 0x3d26dd571fe08       ("xfs_trans_read_buf") error 5 buf count
4096
[  723.156000] xfs_force_shutdown(sda1,0x1) called from line 417 of
file fs/xfs/xfs_trans_buf.c.  Return address =3D 0xc022a810
[  723.168000] attempt to access beyond end of device
[  723.172000] sda1: rw=3D0, want=3D1075794104417808, limit=3D19551042
[  723.176000] I/O error in filesystem ("sda1") meta-data dev sda1
block 0x3d26dd571fe08       ("xfs_trans_read_buf") error 5 buf count
4096
[  723.188000] xfs_force_shutdown(sda1,0x1) called from line 417 of
file fs/xfs/xfs_trans_buf.c.  Return address =3D 0xc022a810
[  723.200000] attempt to access beyond end of device
[  723.204000] sda1: rw=3D0, want=3D1075794104417808, limit=3D19551042
[  723.212000] I/O error in filesystem ("sda1") meta-data dev sda1
block 0x3d26dd571fe08       ("xfs_trans_read_buf") error 5 buf count
4096
[  723.224000] xfs_force_shutdown(sda1,0x1) called from line 417 of
file fs/xfs/xfs_trans_buf.c.  Return address =3D 0xc022a810
[  723.236000] attempt to access beyond end of device
[  723.240000] sda1: rw=3D0, want=3D1075794104417808, limit=3D19551042
[  723.244000] I/O error in filesystem ("sda1") meta-data dev sda1
block 0x3d26dd571fe08       ("xfs_trans_read_buf") error 5 buf count
4096
[  723.256000] xfs_force_shutdown(sda1,0x1) called from line 417 of
file fs/xfs/xfs_trans_buf.c.  Return address =3D 0xc022a810
[  723.268000] attempt to access beyond end of device
[  723.272000] sda1: rw=3D0, want=3D1075794104417808, limit=3D19551042
[  723.280000] I/O error in filesystem ("sda1") meta-data dev sda1
block 0x3d26dd571fe08       ("xfs_trans_read_buf") error 5 buf count
4096
[  723.292000] xfs_force_shutdown(sda1,0x1) called from line 417 of
file fs/xfs/xfs_trans_buf.c.  Return address =3D 0xc022a810
[  723.300000] attempt to access beyond end of device
[  723.308000] sda1: rw=3D0, want=3D1075794104417808, limit=3D19551042
[  723.312000] I/O error in filesystem ("sda1") meta-data dev sda1
block 0x3d26dd571fe08       ("xfs_trans_read_buf") error 5 buf count
4096
[  723.324000] xfs_force_shutdown(sda1,0x1) called from line 417 of
file fs/xfs/xfs_trans_buf.c.  Return address =3D 0xc022a810
[  723.336000] attempt to access beyond end of device
[  723.340000] sda1: rw=3D0, want=3D1075794104417808, limit=3D19551042
[  723.348000] I/O error in filesystem ("sda1") meta-data dev sda1
block 0x3d26dd571fe08       ("xfs_trans_read_buf") error 5 buf count
4096
[  723.360000] xfs_force_shutdown(sda1,0x1) called from line 417 of
file fs/xfs/xfs_trans_buf.c.  Return address =3D 0xc022a810
=85
=85
Continues
Filesystem "sda1": xfs_log_force: error 5 returned.
Filesystem "sda1": xfs_log_force: error 5 returned.


Kernel version: 2.6.35.14(long term stable kernel)
Architecture: ARM
Test Case: I am looking for a regular pattern for this; I will share
as soon as I get more information in this.

Please provide any help to this.

Thanks & Regards,
Amit Sahrawat

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
