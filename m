Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N9G4rH191564
	for <linux-xfs@oss.sgi.com>; Thu, 23 Aug 2012 04:16:05 -0500
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	6VA8AVRbtrn0K4y2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <linux-xfs@oss.sgi.com>;
	Thu, 23 Aug 2012 02:16:47 -0700 (PDT)
Received: by iagw33 with SMTP id w33so1023348iag.26
	for <linux-xfs@oss.sgi.com>; Thu, 23 Aug 2012 02:16:47 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 17:16:47 +0800
Message-ID: <CAPRu15CvOKd=1405rerOMAy7vVQGuf0fAimPP9=0CinRSNboiQ@mail.gmail.com>
Subject: =?UTF-8?Q?some_questions_aoout_extended_attribute_in_my_develo?=
	=?UTF-8?Q?pmen=E2=80=8Bt?=
From: jinxiu su <sujinxiu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1934111951657372865=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

--===============1934111951657372865==
Content-Type: multipart/alternative; boundary=20cf303bfb4e9aef1a04c7eb510d

--20cf303bfb4e9aef1a04c7eb510d
Content-Type: text/plain; charset=ISO-8859-1

Hi....I am su, a new linuxer.

I am doing some development on linux security modules(LSM), and I use
extended attribute to store the security information.

But problems encountered..

when the kernel module that I developed is working a long time ,the
extended attribute of this file named /lib/ld-2.5.so lost.Exactly, it 's
replace by zero.

and in my kernel module ,there is a policy, when create a inode, the
extended attribute will be initialized to zero. But when I check /lib/
ld-2.5.so, the inode is not changed, exactly it's not a new inode. I am
becoming confused....

I think there must be some fatal bugs in my kernel module.But I am just
wondering  in which condition  can make a file's extended attribute field
to be replaced by zero? in which condition can make /lib/ld-2.5.so extended
attribute to be zero?

--20cf303bfb4e9aef1a04c7eb510d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi....I am su, a new linuxer.<br>=A0<br>I am doing some development on linu=
x security modules(LSM), and I use extended attribute to store the security=
 information.<br>=A0<br>But problems encountered..<br>=A0<br>when the kerne=
l module that I developed is working a long time ,the extended attribute of=
 this file named /lib/<a href=3D"http://ld-2.5.so">ld-2.5.so</a> lost.Exact=
ly, it &#39;s replace by zero.<br>
=A0<br>and in my kernel module ,there is a policy, when create a inode, the=
 extended attribute will be initialized to zero. But when I check /lib/<a h=
ref=3D"http://ld-2.5.so">ld-2.5.so</a>, the inode is not changed, exactly i=
t&#39;s not a new inode. I am becoming confused....<br>
=A0<br>I think there must be some fatal bugs in my kernel module.But I am j=
ust wondering=A0 in which condition=A0 can make a file&#39;s extended attri=
bute field to be replaced by zero? in which condition can make /lib/<a href=
=3D"http://ld-2.5.so">ld-2.5.so</a> extended attribute to be zero?

--20cf303bfb4e9aef1a04c7eb510d--


--===============1934111951657372865==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1934111951657372865==--
