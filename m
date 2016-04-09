Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 115A97CA0
	for <xfs@oss.sgi.com>; Sat,  9 Apr 2016 12:55:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D8F698F8037
	for <xfs@oss.sgi.com>; Sat,  9 Apr 2016 10:55:40 -0700 (PDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id 3WRgjqHwb4EgzkHK
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 09 Apr 2016 10:55:38 -0700 (PDT)
Received: by mail-wm0-f43.google.com with SMTP id v188so45941329wme.1
	for <xfs@oss.sgi.com>; Sat, 09 Apr 2016 10:55:38 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 9 Apr 2016 18:55:36 +0100
Message-ID: <CAK1feJAybrn3SGJK4u4-eNA-bSm68f6Kw2BrxKSQnL9PT8VSAQ@mail.gmail.com>
Subject: Apparently successful xfs_copy gives "-9" returncode
From: Richard C <mailing-lists@racitup.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6898341462013499142=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6898341462013499142==
Content-Type: multipart/alternative; boundary=089e01493bbccf288a053011044f

--089e01493bbccf288a053011044f
Content-Type: text/plain; charset=UTF-8

Hi all,

I'm writing a script that helps with hard disk cloning and am running into
a problem whereby xfs_copy is returning -9 when there is nothing in the log
and no indication on stdout or stderr, example below.

I've had a search and couldn't find anything mentioned. Can anyone shed any
light, maybe which version I should try if you suspect this has already
been fixed?
Dist: Ubuntu Trusty
xfsprogs: 3.1.9

$ losetup /dev/loop2 ./disk.img
$ xfs_copy /dev/loop1p6 /dev/loop2
 0%  ... 10%  ... 20%  ... 30%  ... 40%  ... 50%  ... 60%  ... 70%  ... 80%
 ... 90%  ... 100%
All copies completed.
$ echo $?
-9

Cheers,
Richard

--089e01493bbccf288a053011044f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi all,<div><br></div><div>I&#39;m writing a script that h=
elps with hard disk cloning and am running into a problem whereby xfs_copy =
is returning -9 when there is nothing in the log and no indication on stdou=
t or stderr, example below.</div><div><br></div><div>I&#39;ve had a search =
and couldn&#39;t find anything mentioned. Can anyone shed any light, maybe =
which version I should try if you suspect this has already been fixed?</div=
><div>Dist: Ubuntu Trusty</div><div>xfsprogs: 3.1.9</div><div><br></div><di=
v>$ losetup /dev/loop2 ./disk.img</div><div>$ xfs_copy /dev/loop1p6 /dev/lo=
op2</div><div><div>=C2=A00% =C2=A0... 10% =C2=A0... 20% =C2=A0... 30% =C2=
=A0... 40% =C2=A0... 50% =C2=A0... 60% =C2=A0... 70% =C2=A0... 80% =C2=A0..=
. 90% =C2=A0... 100%</div><div><div>All copies completed.</div></div><div>$=
 echo $?</div><div>-9</div><div><br></div></div><div>Cheers,</div><div>Rich=
ard</div></div>

--089e01493bbccf288a053011044f--


--===============6898341462013499142==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6898341462013499142==--
