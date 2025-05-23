Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E232213DDAE;
	Fri, 23 May 2025 09:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747993202; cv=none; b=oe71AnlyxqmaL1IIMVT8rFGajoAcOAMoKEkPBcy1EF62IJymdiWkb4qbsSAM0Ax8Vovci57FrMrvMGV5lXDMBqxKUxhZ8hllZ1yGWB6aiEtvCS6G2dng3+JNKZ3JeUhlhkrdTgfz/gJxmkXfBEruQ44oEYCuWnUHFzzHMw05WJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747993202; c=relaxed/simple;
	bh=SPj+T24ng+dywcSL+nTlxoSYDpB57JPP7uPrqjHM6/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RAlxEUQlajlWNKEbwExo2Wg3EFg3JFXtL+mec2b3YbyeVXirLJY1yKdbtvdQ28gHOJt2lgemGt5seJCs8cMm05Zw5Dv3RqkSu6gkm77svKvu5Ji5N0fSsGXfcGSa5Rs8oPAJg8SGX+YuJS+c5rzBZtfr88BXqg7rlK0v05q5T/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HNbOexhc; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HNbOexhc"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e7387d4a336so7485919276.2;
        Fri, 23 May 2025 02:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747993199; x=1748597999; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=emv/OBOnxABiRHYiPj1bb4H2ZjmFfXAWFghCoXkCiPw=;
        b=HNbOexhc9+9hUPigSGPVDOIAAZ9VlY3fe4jJ6zqsRkWkAKIQRiJLagHoS7kRrJlINQ
         +9I85eUa4NjxHbKu6+6+JKMhWz7QC8zoyFabmWcptq/h7+Zu6irvLduA1nR/g807SCAa
         d/4/82jJvmVNiopidzyAaPO4L777IRVL8R9YKsCmu7GPMq3eoNI2/jwN1xNk1IhGUGxB
         h3eWjypMHEk4CM8yl1t/RSGjGCqokEu9GDphTFKG/K10humou+LyGhO4R9cnb/X1JfvU
         cIRxgvVKmU/fZ0aTL0RS8ZO8z1fLQutjVTaXnLr4ws0hoPf8BlkwBwRjJssdWfWMzpaK
         /Cog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747993199; x=1748597999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=emv/OBOnxABiRHYiPj1bb4H2ZjmFfXAWFghCoXkCiPw=;
        b=qFMAi3H4KdXapz+3D27GPCNnaiAYGXugUreX0g5bH5SY53Plr6L6+9k3VHzA08XoEZ
         Bt54dPjOvzaQpANDrGkPDnp0YbLjD4iPIx/9l/nN806mH/E2cDsDWLvMq7T+foiJwA76
         XmozufNbwmHNmaZBQ/z1LOAyIKoCCU4epAl1LXNJx5k6kRYYQCJ59vcZZ4dfoDdMA0FB
         jqyVHgL8VfRKAnI0tMPMeASy2Bp9hQ32PiTFG6gsHdwXSBaw0IZvTOCPoaGDi86CVBVX
         3Io1l75LGUcTwVZcGeIeUPHx+Co+GX3pWrx7QNsjyEr0ABlpqKIcfKiy7/JdQUZfSzzJ
         YLqw==
X-Forwarded-Encrypted: i=1; AJvYcCVCbrWAevcSTRwQaoZAQ6bb7n+hFeY5ZPKSOC7UvQtaXFTfEtncSgI8KTo/AhJitmLSJDFebyVOBR4x@vger.kernel.org, AJvYcCWehnNqqGrlqZKQPKsnJ68fstgRasQ2BTxsXXtQk9yD1a3EB7Yl8xdnPLPk2LRI5JWyMVeR35aSDiOdvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUtb4jI+Pn1otsMV6ydXy+H6Fow88HKG2fW7pkEyaeZvrO05V2
	R8+vUlysEXW+mkTs7f56dYv6srzXcHH2agsn231kaebaYRz7z3BprK85h3oYJjbbGtuMnECaZY+
	C0QhB4UlWwr/48yCm8Ry069KWSe5ZeY0=
X-Gm-Gg: ASbGncvYjdjCEa6QFwpYwU7wvcbKzRwKabD9xbab0G71mupMCtlV/5Qh3PThPex5dTh
	zFiWiOz5PXjB+RjUGI61AkXq/nce+NZO0huDxhK0gqpDWrJzuHpHAJRL6fW2JfaBMTJQRTkNegq
	z5Y8kdmOILofLmtpCW+hHhE1nu1XalMLlFpg==
X-Google-Smtp-Source: AGHT+IHA+SW7aA1Uz+H2reZbfT7BiR5qnto0IAwVmU4f/745lOLX/xhlKG0zU8C73Ft3cTGRXn7DFZ4+W8jWhOhhv1w=
X-Received: by 2002:a05:6902:2581:b0:e7d:70b9:4b7e with SMTP id
 3f1490d57ef6-e7d70b94c8dmr6766337276.10.1747993198576; Fri, 23 May 2025
 02:39:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMmtr1oC=fOOgAQ@mail.gmail.com>
 <aBaVsli2AKbIa4We@dread.disaster.area> <CAAiJnjor+=Zn62n09f-aJw2amX2wxQOb-2TB3rea9wDCU7ONoA@mail.gmail.com>
 <aBfhDQ6lAPmn81j0@dread.disaster.area> <7c33f38a52ccff8b94f20c0714b60b61b061ad58.camel@redhat.com>
 <a1f322ab801e7f7037951578d289c5d18c6adc4d.camel@redhat.com>
 <f01719b1901f9d796837669086d7c1cd14c9922c.camel@redhat.com> <f08554fccd3d5e2c2ec4849b0a8158d63414e356.camel@redhat.com>
In-Reply-To: <f08554fccd3d5e2c2ec4849b0a8158d63414e356.camel@redhat.com>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Fri, 23 May 2025 12:39:47 +0300
X-Gm-Features: AX0GCFunFtVoEjxneJ-r5oEiQ-L0yNEYb07vOeg9luGAy_Q0MrrrZPORLg9XtpU
Message-ID: <CAAiJnjoW-gpU6Va-nHTU_E7+b2ajhawx5JY3eJYT62p7icTebg@mail.gmail.com>
Subject: Re: Sequential read from NVMe/XFS twice slower on Fedora 42 than on
 Rocky 9.5
To: Laurence Oberman <loberman@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-nvme@lists.infradead.org, 
	linux-xfs@vger.kernel.org, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> This fell of my radar, I aologize and I was on PTO last week.
> Here is the Fedora kernel to install as mentioned
> https://people.redhat.com/loberman/customer/.fedora/

> tar hxvf fedora_kernel.tar.xz
> rpm -ivh --force --nodeps *.rpm

Rocky 9.5 kernel is still faster Fedora 42 kernel.

[root@memverge4 ~]# uname -r
6.14.5-300.fc42.x86_64
[root@memverge4 ~]#
[root@memverge4 ~]# cat /etc/*release
NAME=3D"Rocky Linux"
VERSION=3D"9.5 (Blue Onyx)"
ID=3D"rocky"
ID_LIKE=3D"rhel centos fedora"
VERSION_ID=3D"9.5"
PLATFORM_ID=3D"platform:el9"
PRETTY_NAME=3D"Rocky Linux 9.5 (Blue Onyx)"
ANSI_COLOR=3D"0;32"
LOGO=3D"fedora-logo-icon"
CPE_NAME=3D"cpe:/o:rocky:rocky:9::baseos"
HOME_URL=3D"https://rockylinux.org/"
VENDOR_NAME=3D"RESF"
VENDOR_URL=3D"https://resf.org/"
BUG_REPORT_URL=3D"https://bugs.rockylinux.org/"
SUPPORT_END=3D"2032-05-31"
ROCKY_SUPPORT_PRODUCT=3D"Rocky-Linux-9"
ROCKY_SUPPORT_PRODUCT_VERSION=3D"9.5"
REDHAT_SUPPORT_PRODUCT=3D"Rocky Linux"
REDHAT_SUPPORT_PRODUCT_VERSION=3D"9.5"
Rocky Linux release 9.5 (Blue Onyx)
Rocky Linux release 9.5 (Blue Onyx)
Rocky Linux release 9.5 (Blue Onyx)


Block access -

[root@memverge4 ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
--filename=3D/dev/md127 --direct=3D1 --numjobs=3D1 --iodepth=3D64 --exitall
--group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
fio-3.40
Starting 1 process
Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D34.7GiB/s][r=3D142k IOPS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3566: Fri May 23 12:20:18 20=
25
  read: IOPS=3D142k, BW=3D34.7GiB/s (37.2GB/s)(1040GiB/30001msec)
    slat (usec): min=3D3, max=3D1065, avg=3D 6.68, stdev=3D 2.19
    clat (usec): min=3D75, max=3D2712, avg=3D443.75, stdev=3D36.12
     lat (usec): min=3D83, max=3D2835, avg=3D450.43, stdev=3D36.49

File access -

[root@memverge4 ~]# mount /dev/md127 /mnt
[root@memverge4 ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
--filename=3D/mnt/testfile --direct=3D1 --numjobs=3D1 --iodepth=3D64 --exit=
all
--group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
fio-3.40
Starting 1 process
Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D41.4GiB/s][r=3D169k IOPS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3666: Fri May 23 12:21:33 20=
25
  read: IOPS=3D172k, BW=3D42.1GiB/s (45.2GB/s)(1263GiB/30001msec)
    slat (usec): min=3D3, max=3D1054, avg=3D 5.46, stdev=3D 1.81
    clat (usec): min=3D118, max=3D2500, avg=3D365.50, stdev=3D28.08
     lat (usec): min=3D121, max=3D2794, avg=3D370.96, stdev=3D28.35

Back to latest 9.5 kernel (5.14.0-503.40.1.el9_5.x86_64)

Block access -

[root@memverge4 ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
--filename=3D/dev/md127 --direct=3D1 --numjobs=3D1 --iodepth=3D64 --exitall
--group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
fio-3.40
Starting 1 process
Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D70.8GiB/s][r=3D290k IOPS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6121: Fri May 23 12:35:22 20=
25
  read: IOPS=3D287k, BW=3D70.1GiB/s (75.3GB/s)(2104GiB/30001msec)
    slat (nsec): min=3D1492, max=3D165338, avg=3D3029.64, stdev=3D1544.70
    clat (usec): min=3D71, max=3D1069, avg=3D219.56, stdev=3D21.22
     lat (usec): min=3D74, max=3D1233, avg=3D222.59, stdev=3D21.34

File access -

[root@memverge4 ~]# mount /dev/md127 /mnt
[root@memverge4 ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
--filename=3D/mnt/testfile --direct=3D1 --numjobs=3D1 --iodepth=3D64 --exit=
all
--group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_based
test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
fio-3.40
Starting 1 process
Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D73.5GiB/s][r=3D301k IOPS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6200: Fri May 23 12:36:47 20=
25
  read: IOPS=3D301k, BW=3D73.4GiB/s (78.8GB/s)(2201GiB/30001msec)
    slat (nsec): min=3D1443, max=3D291427, avg=3D2951.98, stdev=3D1952.66
    clat (usec): min=3D118, max=3D1449, avg=3D209.84, stdev=3D23.13
     lat (usec): min=3D121, max=3D1562, avg=3D212.79, stdev=3D23.23

Anton

=D1=87=D1=82, 22 =D0=BC=D0=B0=D1=8F 2025=E2=80=AF=D0=B3. =D0=B2 18:08, Laur=
ence Oberman <loberman@redhat.com>:
>
> On Mon, 2025-05-05 at 13:39 -0400, Laurence Oberman wrote:
> > On Mon, 2025-05-05 at 09:21 -0400, Laurence Oberman wrote:
> > > On Mon, 2025-05-05 at 08:29 -0400, Laurence Oberman wrote:
> > > > On Mon, 2025-05-05 at 07:50 +1000, Dave Chinner wrote:
> > > > > [cc linux-block]
> > > > >
> > > > > [original bug report:
> > > > > https://lore.kernel.org/linux-xfs/CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ=
-QzmZBMmtr1oC=3DfOOgAQ@mail.gmail.com/
> > > > >  ]
> > > > >
> > > > > On Sun, May 04, 2025 at 10:22:58AM +0300, Anton Gavriliuk
> > > > > wrote:
> > > > > > > What's the comparitive performance of an identical read
> > > > > > > profile
> > > > > > > directly on the raw MD raid0 device?
> > > > > >
> > > > > > Rocky 9.5 (5.14.0-503.40.1.el9_5.x86_64)
> > > > > >
> > > > > > [root@localhost ~]# df -mh /mnt
> > > > > > Filesystem      Size  Used Avail Use% Mounted on
> > > > > > /dev/md127       35T  1.3T   34T   4% /mnt
> > > > > >
> > > > > > [root@localhost ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
> > > > > > --filename=3D/dev/md127 --direct=3D1 --numjobs=3D1 --iodepth=3D=
64 --
> > > > > > exitall
> > > > > > --group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_bas=
ed
> > > > > > test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-
> > > > > > 256KiB,
> > > > > > (T)
> > > > > > 256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
> > > > > > fio-3.39-44-g19d9
> > > > > > Starting 1 process
> > > > > > Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D81.4GiB/s][r=3D334k IOPS][e=
ta
> > > > > > 00m:00s]
> > > > > > test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D43189: Sun May  =
4
> > > > > > 08:22:12
> > > > > > 2025
> > > > > >   read: IOPS=3D363k, BW=3D88.5GiB/s (95.1GB/s)(2656GiB/30001mse=
c)
> > > > > >     slat (nsec): min=3D971, max=3D312380, avg=3D1817.92,
> > > > > > stdev=3D1367.75
> > > > > >     clat (usec): min=3D78, max=3D1351, avg=3D174.46, stdev=3D28=
.86
> > > > > >      lat (usec): min=3D80, max=3D1352, avg=3D176.27, stdev=3D28=
.81
> > > > > >
> > > > > > Fedora 42 (6.14.5-300.fc42.x86_64)
> > > > > >
> > > > > > [root@localhost anton]# df -mh /mnt
> > > > > > Filesystem      Size  Used Avail Use% Mounted on
> > > > > > /dev/md127       35T  1.3T   34T   4% /mnt
> > > > > >
> > > > > > [root@localhost ~]# fio --name=3Dtest --rw=3Dread --bs=3D256k
> > > > > > --filename=3D/dev/md127 --direct=3D1 --numjobs=3D1 --iodepth=3D=
64 --
> > > > > > exitall
> > > > > > --group_reporting --ioengine=3Dlibaio --runtime=3D30 --time_bas=
ed
> > > > > > test: (g=3D0): rw=3Dread, bs=3D(R) 256KiB-256KiB, (W) 256KiB-
> > > > > > 256KiB,
> > > > > > (T)
> > > > > > 256KiB-256KiB, ioengine=3Dlibaio, iodepth=3D64
> > > > > > fio-3.39-44-g19d9
> > > > > > Starting 1 process
> > > > > > Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D41.0GiB/s][r=3D168k IOPS][e=
ta
> > > > > > 00m:00s]
> > > > > > test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D5685: Sun May  4
> > > > > > 10:14:00
> > > > > > 2025
> > > > > >   read: IOPS=3D168k, BW=3D41.0GiB/s (44.1GB/s)(1231GiB/30001mse=
c)
> > > > > >     slat (usec): min=3D3, max=3D273, avg=3D 5.63, stdev=3D 1.48
> > > > > >     clat (usec): min=3D67, max=3D2800, avg=3D374.99, stdev=3D29=
.90
> > > > > >      lat (usec): min=3D72, max=3D2914, avg=3D380.62, stdev=3D30=
.22
> > > > >
> > > > > So the MD block device shows the same read performance as the
> > > > > filesystem on top of it. That means this is a regression at the
> > > > > MD
> > > > > device layer or in the block/driver layers below it. i.e. it is
> > > > > not
> > > > > an XFS of filesystem issue at all.
> > > > >
> > > > > -Dave.
> > > >
> > > > I have a lab setup, let me see if I can also reproduce and then
> > > > trace
> > > > this to see where it is spending the time
> > > >
> > >
> > >
> > > Not seeing 1/2 the bandwidth but also significantly slower on
> > > Fedora42
> > > kernel.
> > > I will trace it
> > >
> > > 9.5 kernel - 5.14.0-503.40.1.el9_5.x86_64
> > >
> > > Run status group 0 (all jobs):
> > >    READ: bw=3D14.7GiB/s (15.8GB/s), 14.7GiB/s-14.7GiB/s (15.8GB/s-
> > > 15.8GB/s), io=3D441GiB (473GB), run=3D30003-30003msec
> > >
> > > Fedora42 kernel - 6.14.5-300.fc42.x86_64
> > >
> > > Run status group 0 (all jobs):
> > >    READ: bw=3D10.4GiB/s (11.2GB/s), 10.4GiB/s-10.4GiB/s (11.2GB/s-
> > > 11.2GB/s), io=3D313GiB (336GB), run=3D30001-30001msec
> > >
> > >
> > >
> > >
> >
> > Fedora42 kernel issue
> >
> > While my difference is not as severe we do see a consistently lower
> > performance on the Fedora
> > kernel. (6.14.5-300.fc42.x86_64)
> >
> > When I remove the software raid and run against a single NVME we
> > converge to be much closer.
> > Also latest upstream does not show this regression either.
> >
> > Not sure yet what is in our Fedora kernel causing this.
> > We will work it via the Bugzilla
> >
> > Regards
> > Laurence
> >
> > TLDR
> >
> >
> > Fedora Kernel
> > -------------
> > root@penguin9 blktracefedora]# uname -a
> > Linux penguin9.2 6.14.5-300.fc42.x86_64 #1 SMP PREEMPT_DYNAMIC Fri
> > May
> > 2 14:16:46 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
> >
> > 5 runs of the fio against /dev/md1
> >
> > [root@penguin9 ~]# for i in 1 2 3 4 5
> > > do
> > > ./run_fio.sh | grep -A1 "Run status group"
> > > done
> > Run status group 0 (all jobs):
> >    READ: bw=3D11.3GiB/s (12.2GB/s), 11.3GiB/s-11.3GiB/s (12.2GB/s-
> > 12.2GB/s), io=3D679GiB (729GB), run=3D60001-60001msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D11.2GiB/s (12.0GB/s), 11.2GiB/s-11.2GiB/s (12.0GB/s-
> > 12.0GB/s), io=3D669GiB (718GB), run=3D60001-60001msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D11.4GiB/s (12.2GB/s), 11.4GiB/s-11.4GiB/s (12.2GB/s-
> > 12.2GB/s), io=3D682GiB (733GB), run=3D60001-60001msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D11.1GiB/s (11.9GB/s), 11.1GiB/s-11.1GiB/s (11.9GB/s-
> > 11.9GB/s), io=3D664GiB (713GB), run=3D60001-60001msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D11.3GiB/s (12.1GB/s), 11.3GiB/s-11.3GiB/s (12.1GB/s-
> > 12.1GB/s), io=3D678GiB (728GB), run=3D60001-60001msec
> >
> > RHEL9.5
> > ------------
> > Linux penguin9.2 5.14.0-503.40.1.el9_5.x86_64 #1 SMP PREEMPT_DYNAMIC
> > Thu Apr 24 08:27:29 EDT 2025 x86_64 x86_64 x86_64 GNU/Linux
> >
> > [root@penguin9 ~]# for i in 1 2 3 4 5; do ./run_fio.sh | grep -A1
> > "Run
> > status group"; done
> > Run status group 0 (all jobs):
> >    READ: bw=3D14.9GiB/s (16.0GB/s), 14.9GiB/s-14.9GiB/s (16.0GB/s-
> > 16.0GB/s), io=3D894GiB (960GB), run=3D60003-60003msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D14.6GiB/s (15.6GB/s), 14.6GiB/s-14.6GiB/s (15.6GB/s-
> > 15.6GB/s), io=3D873GiB (938GB), run=3D60003-60003msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D14.9GiB/s (16.0GB/s), 14.9GiB/s-14.9GiB/s (16.0GB/s-
> > 16.0GB/s), io=3D892GiB (958GB), run=3D60003-60003msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D14.5GiB/s (15.6GB/s), 14.5GiB/s-14.5GiB/s (15.6GB/s-
> > 15.6GB/s), io=3D872GiB (936GB), run=3D60003-60003msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D14.7GiB/s (15.8GB/s), 14.7GiB/s-14.7GiB/s (15.8GB/s-
> > 15.8GB/s), io=3D884GiB (950GB), run=3D60003-60003msec
> >
> >
> > Remove software raid from the layers and test just on a single nvme
> > ---------------------------------------------------------------------
> > -
> >
> > fio --name=3Dtest --rw=3Dread --bs=3D256k --filename=3D/dev/nvme23n1 --
> > direct=3D1
> > --numjobs=3D1 --iodepth=3D64 --exitall --group_reporting --
> > ioengine=3Dlibaio
> > --runtime=3D60 --time_based
> >
> > Linux penguin9.2 5.14.0-503.40.1.el9_5.x86_64 #1 SMP PREEMPT_DYNAMIC
> > Thu Apr 24 08:27:29 EDT 2025 x86_64 x86_64 x86_64 GNU/Linux
> >
> > [root@penguin9 ~]# ./run_nvme_fio.sh
> >
> > Run status group 0 (all jobs):
> >    READ: bw=3D3207MiB/s (3363MB/s), 3207MiB/s-3207MiB/s (3363MB/s-
> > 3363MB/s), io=3D188GiB (202GB), run=3D60005-60005msec
> >
> >
> > Back to fedora kernel
> >
> > [root@penguin9 ~]# uname -a
> > Linux penguin9.2 6.14.5-300.fc42.x86_64 #1 SMP PREEMPT_DYNAMIC Fri
> > May
> > 2 14:16:46 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
> >
> > Within the margin of error
> >
> > Run status group 0 (all jobs):
> >    READ: bw=3D3061MiB/s (3210MB/s), 3061MiB/s-3061MiB/s (3210MB/s-
> > 3210MB/s), io=3D179GiB (193GB), run=3D60006-60006msec
> >
> >
> > Try recent upstream kernel
> > ---------------------------
> > [root@penguin9 ~]# uname -a
> > Linux penguin9.2 6.13.0-rc7+ #2 SMP PREEMPT_DYNAMIC Mon May  5
> > 10:59:12
> > EDT 2025 x86_64 x86_64 x86_64 GNU/Linux
> >
> > [root@penguin9 ~]# for i in 1 2 3 4 5; do ./run_fio.sh | grep -A1
> > "Run
> > status group"; done
> > Run status group 0 (all jobs):
> >    READ: bw=3D14.6GiB/s (15.7GB/s), 14.6GiB/s-14.6GiB/s (15.7GB/s-
> > 15.7GB/s), io=3D876GiB (941GB), run=3D60003-60003msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D14.8GiB/s (15.9GB/s), 14.8GiB/s-14.8GiB/s (15.9GB/s-
> > 15.9GB/s), io=3D891GiB (957GB), run=3D60003-60003msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D14.8GiB/s (15.9GB/s), 14.8GiB/s-14.8GiB/s (15.9GB/s-
> > 15.9GB/s), io=3D890GiB (956GB), run=3D60003-60003msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D14.5GiB/s (15.6GB/s), 14.5GiB/s-14.5GiB/s (15.6GB/s-
> > 15.6GB/s), io=3D871GiB (935GB), run=3D60003-60003msec
> >
> >
> > Update to latest upstream
> > -------------------------
> >
> > [root@penguin9 ~]# uname -a
> > Linux penguin9.2 6.15.0-rc5 #1 SMP PREEMPT_DYNAMIC Mon May  5
> > 12:18:22
> > EDT 2025 x86_64 x86_64 x86_64 GNU/Linux
> >
> > Single nvme device is once again fine
> >
> > Run status group 0 (all jobs):
> >    READ: bw=3D3061MiB/s (3210MB/s), 3061MiB/s-3061MiB/s (3210MB/s-
> > 3210MB/s), io=3D179GiB (193GB), run=3D60006-60006msec
> >
> >
> > [root@penguin9 ~]# for i in 1 2 3 4 5; do ./run_fio.sh | grep -A1
> > "Run
> > status group"; done
> > Run status group 0 (all jobs):
> >    READ: bw=3D14.7GiB/s (15.7GB/s), 14.7GiB/s-14.7GiB/s (15.7GB/s-
> > 15.7GB/s), io=3D880GiB (945GB), run=3D60003-60003msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D18.1GiB/s (19.4GB/s), 18.1GiB/s-18.1GiB/s (19.4GB/s-
> > 19.4GB/s), io=3D1087GiB (1167GB), run=3D60003-60003msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D18.0GiB/s (19.4GB/s), 18.0GiB/s-18.0GiB/s (19.4GB/s-
> > 19.4GB/s), io=3D1082GiB (1162GB), run=3D60003-60003msec
> > Run status group 0 (all jobs):
> >    READ: bw=3D18.2GiB/s (19.5GB/s), 18.2GiB/s-18.2GiB/s (19.5GB/s-
> > 19.5GB/s), io=3D1090GiB (1170GB), run=3D60005-60005msec
> >
> >
>
> This fell of my radar, I aologize and I was on PTO last week.
> Here is the Fedora kernel to install as mentioned
> https://people.redhat.com/loberman/customer/.fedora/
>
> tar hxvf fedora_kernel.tar.xz
> rpm -ivh --force --nodeps *.rpm
>
