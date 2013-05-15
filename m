Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64BD67F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 02:09:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41F6F304066
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 00:09:02 -0700 (PDT)
Received: from mail-la0-f44.google.com (mail-la0-f44.google.com
	[209.85.215.44]) by cuda.sgi.com with ESMTP id nz0BpAXgSFgZFkEb
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 15 May 2013 00:08:58 -0700 (PDT)
Received: by mail-la0-f44.google.com with SMTP id fr10so1431129lab.3
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 00:08:56 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 May 2013 15:08:56 +0800
Message-ID: <CACeqxwRdq-wuz9xpa9p=kQvYgjJQYRMP2JLsyv7SChqx8b-ujw@mail.gmail.com>
Subject: Why xfs can not mount use barrier option?
From: ch huang <justlooks@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2850201990080185922=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2850201990080185922==
Content-Type: multipart/alternative; boundary=047d7b342f385b6dd404dcbc6cbc

--047d7b342f385b6dd404dcbc6cbc
Content-Type: text/plain; charset=ISO-8859-1

i use lvm on raid 1,/dev/CHVG01/conxfs is a logical volume,if i  mount with
barrier,the /proc/mounts still show nobarrier option ,why?

#  mount -t xfs -o barrier,attr2,noikeep,inode64 /dev/CHVG01/conxfs
 /opt/contest/
# cat /proc/mounts
/dev/CHVG01/conxfs /opt/contest xfs rw,attr2,nobarrier,inode64,noquota 0 0

--047d7b342f385b6dd404dcbc6cbc
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">i use lvm on raid 1,/dev/CHVG01/conxfs is a logical volume=
,if i =A0mount with barrier,the /proc/mounts still show nobarrier option ,w=
hy?=A0<div><br></div><div># =A0mount -t xfs -o barrier,attr2,noikeep,inode6=
4 /dev/CHVG01/conxfs =A0/opt/contest/<br>
</div><div><div># cat /proc/mounts</div></div><div>/dev/CHVG01/conxfs /opt/=
contest xfs rw,attr2,nobarrier,inode64,noquota 0 0<br></div></div>

--047d7b342f385b6dd404dcbc6cbc--


--===============2850201990080185922==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2850201990080185922==--
