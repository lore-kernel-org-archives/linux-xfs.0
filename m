Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E7ED87F5F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 21:25:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 607AAAC015
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 19:25:03 -0700 (PDT)
Received: from mail-vk0-f42.google.com (mail-vk0-f42.google.com
	[209.85.213.42]) by cuda.sgi.com with ESMTP id bJ3CAIbYDTTlABMZ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2015 19:24:58 -0700 (PDT)
Received: by vkaw128 with SMTP id w128so16801967vka.2
	for <xfs@oss.sgi.com>; Wed, 02 Sep 2015 19:24:57 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 3 Sep 2015 14:24:57 +1200
Message-ID: <CA+nZN+grRZBNruxua4inJ-cMe_WX2XSPjsrP+qb579Si8R6ihA@mail.gmail.com>
Subject: XFS and nobarriers on Intel SSD
From: Richard Bade <hitrich@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8583955529140234271=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8583955529140234271==
Content-Type: multipart/alternative; boundary=bcaec548a7ef45e997051ece7d0b

--bcaec548a7ef45e997051ece7d0b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Everyone,
I have a question about nobarriers. In the XFS FAQ it looks like the
recommendation is that if you have a Battery Backed raid controller you
should set nobarriers for performance reasons.
Our LSI card doesn=E2=80=99t have battery backed cache as it=E2=80=99s conf=
igured in HBA
mode (IT) rather than Raid (IR). Our Intel s3710 SSD=E2=80=99s do have a ca=
pacitor
backed cache though.
So is it recommended that barriers are turned off as the drive has a safe
cache (I am confident that the cache will write out to disk on power
failure)?

The reason I am asking about this is that we are seeing some significant
I/O delays on the disks causing a =E2=80=9CSCSI Task Abort=E2=80=9D from th=
e OS. This seems
to be triggered by the drive receiving a =E2=80=9CSynchronize cache command=
=E2=80=9D.
My current thinking is that setting no barriers will stop the drive
receiving a sync command and therefore stop the I/O delay associated with
it.

This is happening on our Ceph storage cluster. For those not familiar with
Ceph, it uses XFS as the underlying filesystem for the object stores.

Has anyone else encountered this issue?
Any info or suggestions about this would be appreciated.

Regards,
Richard

--bcaec548a7ef45e997051ece7d0b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Everyone,</div><div>I have a question about nobarr=
iers. In the XFS FAQ it looks like the recommendation is that if you have a=
 Battery Backed raid controller you should set nobarriers for performance r=
easons.</div><div>Our LSI card doesn=E2=80=99t have battery backed cache as=
 it=E2=80=99s configured in HBA mode (IT) rather than Raid (IR). Our Intel =
s3710 SSD=E2=80=99s do have a capacitor backed cache though.</div><div>So i=
s it recommended that barriers are turned off as the drive has a safe cache=
 (I am confident that the cache will write out to disk on power failure)?</=
div><div><br></div><div>The reason I am asking about this is that we are se=
eing some significant I/O delays on the disks causing a =E2=80=9CSCSI Task =
Abort=E2=80=9D from the OS. This seems to be triggered by the drive receivi=
ng a =E2=80=9CSynchronize cache command=E2=80=9D.</div><div>My current thin=
king is that setting no barriers will stop the drive receiving a sync comma=
nd and therefore stop the I/O delay associated with it.</div><div><br></div=
><div>This is happening on our Ceph storage cluster. For those not familiar=
 with Ceph, it uses XFS as the underlying filesystem for the object stores.=
</div><div><br></div><div>Has anyone else encountered this issue?</div><div=
>Any info or suggestions about this would be appreciated.=C2=A0</div><div><=
br></div><div>Regards,</div><div>Richard</div><div><br></div></div>

--bcaec548a7ef45e997051ece7d0b--


--===============8583955529140234271==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8583955529140234271==--
