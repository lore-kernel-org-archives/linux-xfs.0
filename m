Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70B487FB0
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 06:21:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3FB9E30404E
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 04:21:04 -0700 (PDT)
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com
	[209.85.213.176]) by cuda.sgi.com with ESMTP id
	1PYaVhuSZwBSSiHQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 04:21:03 -0700 (PDT)
Received: by mail-ig0-f176.google.com with SMTP id hn18so3943611igb.9
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 04:21:02 -0700 (PDT)
MIME-Version: 1.0
From: Hrishikesh Barua <talonx@gmail.com>
Date: Wed, 16 Jul 2014 16:50:22 +0530
Message-ID: <CAD2VtSjwu3eB+mrs2vX0G4+MJbHyNGVXvVR+P_ssNY6rydvijA@mail.gmail.com>
Subject: Occassional problems with unfreeze
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2760193764323736626=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2760193764323736626==
Content-Type: multipart/alternative; boundary=047d7b10d1792db07604fe4db814

--047d7b10d1792db07604fe4db814
Content-Type: text/plain; charset=UTF-8

We use XFS on Amazon EBS on Ubuntu 12.04.3, kernel "3.2.0-54-virtual".

Our backup scripts invoke "xfs_freeze -f" before taking a snapshot to
ensure filesystem consistency. After the snapshot is taken, we invoke
"xfs_freeze -u".

Recently, we have observed that some of these unfreeze calls exit with code
255. This results in a frozen filesystem, processes queuing up and us
having to reboot the EC2 instance. Invoking freeze -u manually results in
multiple processes like this -

     17628 ?        D      0:00 /usr/sbin/xfs_io -F -r -p xfs_freeze -x -c
thaw /mysql-vol-a
     17694 ?        D      0:00 /usr/sbin/xfs_io -F -r -p xfs_freeze -x -c
thaw /mysql-vol-a

A search on this list reveals at least one other instance of this problem -
http://oss.sgi.com/archives/xfs/2013-01/msg00437.html

No resolution seems to have happened there. Is this a known bug, or has it
been fixed since (I'm running xfsprogs 3.1.7) ?

Regards
Hrish

--047d7b10d1792db07604fe4db814
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div>We use XFS on Amazon EBS on Ubunt=
u 12.04.3, kernel &quot;3.2.0-54-virtual&quot;. <br><br></div>Our backup sc=
ripts invoke &quot;xfs_freeze -f&quot; before taking a snapshot to ensure f=
ilesystem consistency. After the snapshot is taken, we invoke &quot;xfs_fre=
eze -u&quot;.<br>

<br>Recently, we have observed that some of these unfreeze calls exit with =
code 255. This results in a frozen filesystem, processes queuing up and us =
having to reboot the EC2 instance. Invoking freeze -u manually results in m=
ultiple processes like this - <br>

<br>
                                                    =C2=A0=C2=A0=C2=A0=C2=
=A0 17628 ?=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
                                                    D=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0:00
                                                    /usr/sbin/xfs_io -F
                                                    -r -p xfs_freeze -x
                                                    -c thaw
                                                    /mysql-vol-a<br>
                                                    =C2=A0=C2=A0=C2=A0=C2=
=A0 17694 ?=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
                                                    D=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0:00
                                                    /usr/sbin/xfs_io -F
                                                    -r -p xfs_freeze -x
                                                    -c thaw
                                                    /mysql-vol-a<br>
                                                    <br></div>A search on t=
his list reveals at least one other instance of this problem - <a href=3D"h=
ttp://oss.sgi.com/archives/xfs/2013-01/msg00437.html">http://oss.sgi.com/ar=
chives/xfs/2013-01/msg00437.html</a> <br>

</div><br>No resolution seems to have happened there. Is this a known bug, =
or has it been fixed since (I&#39;m running xfsprogs 3.1.7) ?<br><br></div>=
Regards<br></div>Hrish<br></div>

--047d7b10d1792db07604fe4db814--


--===============2760193764323736626==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2760193764323736626==--
