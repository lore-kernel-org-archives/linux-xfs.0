Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2QDc8FJ052900 for <xfs@oss.sgi.com>; Sat, 26 Mar 2011 08:38:08 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F7B71DF6965
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2011 06:41:15 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	k7DUCDFAEnXoUCxH for <xfs@oss.sgi.com>;
	Sat, 26 Mar 2011 06:41:15 -0700 (PDT)
Received: by iyb26 with SMTP id 26so2179056iyb.26
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2011 06:41:15 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 26 Mar 2011 21:41:15 +0800
Message-ID: <AANLkTingRg24yJJ6Dk=KpDywtY9LrXL_jV0KWaCR-8KU@mail.gmail.com>
Subject: No space left on device on xfs filesystem with 7.7TB free
From: atyu30 atyu30 <ipostfix@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9094615267759212918=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============9094615267759212918==
Content-Type: multipart/alternative; boundary=bcaec51d22da4f631b049f62dd2c

--bcaec51d22da4f631b049f62dd2c
Content-Type: text/plain; charset=ISO-8859-1

I'm running RedHat Linux Enterprise Server 5.2, on a 64-bit x86_64 Linux
machine with kernel version 2.6.18-128.el5 smp.  I appear to have version
2.9.4 of xfsprogs.

I have a 22TB xfs filesystem ,Yesterday, the hard disk is full, today
released a 7.7T disk space.But still can not write to new file.

software ambience:

[root@Production data5]# uname -a
Linux Production 2.6.18-128.el5 #1 SMP Wed Jan 21 10:41:14 EST 2009 x86_64
x86_64 x86_64 GNU/Linux

[root@Production data5]# rpm -qa | grep xfs
xfsprogs-2.9.4-1.el5.centos
xorg-x11-xfs-1.0.2-4
kmod-xfs-0.4-2


problem:

[root@Production data5]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1              48G  6.7G   39G  15% /
/dev/sda2              81G  4.0G   73G   6% /opt
/dev/sdb1              22T   15T  7.7T  65% /data2
tmpfs                 2.0G     0  2.0G   0% /dev/shm

[root@Production data5]# df -i
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sda1            12812288  136847 12675441    2% /
/dev/sda2            21867648    8440 21859208    1% /opt
/dev/sdb1            23429382016 4625792 23424756224    1% /data2
tmpfs                 504701       1  504700    1% /dev/shm

[root@Production data5]# touch test.log
touch: cannot touch `test.log': No space left on device

--bcaec51d22da4f631b049f62dd2c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br>I&#39;m running RedHat Linux Enterprise Server 5.2, on a 64-bit x86=
_64 Linux=A0 machine with kernel version 2.6.18-128.el5 smp.=A0 I appear to=
 have version 2.9.4 of xfsprogs.<br><br>I have a 22TB xfs filesystem ,Yeste=
rday, the hard disk is full, today released a 7.7T disk space.But still can=
 not write to new file.<br>
<br>software ambience:<br><br>[root@Production data5]# uname -a<br>Linux Pr=
oduction 2.6.18-128.el5 #1 SMP Wed Jan 21 10:41:14 EST 2009 x86_64 x86_64 x=
86_64 GNU/Linux<br><br>[root@Production data5]# rpm -qa | grep xfs<br>xfspr=
ogs-2.9.4-1.el5.centos<br>
xorg-x11-xfs-1.0.2-4<br>kmod-xfs-0.4-2<br><br><br>problem:<br><br>[root@Pro=
duction data5]# df -h<br>Filesystem=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=
=A0 Used Avail Use% Mounted on<br>/dev/sda1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 48G=A0 6.7G=A0=A0 39G=A0 15% /<br>/dev/sda2=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 81G=A0 4.0G=A0=A0 73G=A0=A0 6% /opt<br>
/dev/sdb1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 22T=A0=A0 15T=A0 7.7T=A0 6=
5% /data2<br>tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.0G=A0=
=A0=A0=A0 0=A0 2.0G=A0=A0 0% /dev/shm<br><br>[root@Production data5]# df -i=
<br>Filesystem=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Inodes=A0=A0 IUsed=A0=A0 IF=
ree IUse% Mounted on<br>/dev/sda1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 12812288=
=A0 136847 12675441=A0=A0=A0 2% /<br>
/dev/sda2=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 21867648=A0=A0=A0 8440 21859208=
=A0=A0=A0 1% /opt<br>/dev/sdb1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 23429382016=
 4625792 23424756224=A0=A0=A0 1% /data2<br>tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 504701=A0=A0=A0=A0=A0=A0 1=A0 504700=A0=A0=A0 1% /dev=
/shm<br><br>[root@Production data5]# touch test.log<br>
touch: cannot touch `test.log&#39;: No space left on device<br><br><br>

--bcaec51d22da4f631b049f62dd2c--


--===============9094615267759212918==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9094615267759212918==--
