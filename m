Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IES58I116996 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 09:28:05 -0500
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9742514D4ED1
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 07:37:54 -0700 (PDT)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id Dh1tu4O15Wt0WmIH
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 07:37:54 -0700 (PDT)
Received: by mail-qw0-f53.google.com with SMTP id 5so575213qwe.26
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 07:28:34 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 18 Aug 2010 09:27:55 -0500
Message-ID: <AANLkTimHBE_9pD1wWOkryOnqBgL2bJQTKoe52wYjfNw3@mail.gmail.com>
Subject: page discard on page error
From: Mike Gao <ygao.linux@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3366453597439823050=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3366453597439823050==
Content-Type: multipart/alternative; boundary=002354471d8cbfc1be048e19df29

--002354471d8cbfc1be048e19df29
Content-Type: text/plain; charset=ISO-8859-1

Hi, all,

I sync latest XFS last month and build into our embedded system. When I
test, I found below issue.
It seems that the xfs_iomap failed when it did allocat with
xfs_ilock_nowait().
I debug this and found that ip->i_lock is locked and there are sometime no
unlock coming between two lock trying.
This issue will give wrong data in file on disk exactly on that offset.

Filesystem "ubdb1": page discard on page 09160ac0, inode 0x43, offset
229494784.
Filesystem "ubdb1": page discard on page 09160ae0, inode 0x43, offset
229498880.
Filesystem "ubdb1": page discard on page 0915fac0, inode 0x43, offset
229502976.
Filesystem "ubdb1": page discard on page 0915fae0, inode 0x43, offset
229507072.
Filesystem "ubdb1": page discard on page 0914d440, inode 0x43, offset
229511168.


Should we just discard the page? I don't think it is good because the file
will be corrupted.
Should we fix it? I am new to XFS and more than like to hear your opinion.

Thanks very much,
Mike Gao

--002354471d8cbfc1be048e19df29
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi, all,<div><br></div><div>I sync latest XFS last month and build into our=
 embedded system. When I test, I found below issue.</div><div>It seems that=
 the xfs_iomap failed when it did allocat with xfs_ilock_nowait().</div>
<div>I debug this and found that ip-&gt;i_lock is locked and there are some=
time no unlock coming between two lock trying.</div><div>This issue will gi=
ve wrong data in file on disk exactly on that offset.</div><div><br></div>
<div><div>Filesystem &quot;ubdb1&quot;: page discard on page 09160ac0, inod=
e 0x43, offset 229494784.</div><div>Filesystem &quot;ubdb1&quot;: page disc=
ard on page 09160ae0, inode 0x43, offset 229498880.</div><div>Filesystem &q=
uot;ubdb1&quot;: page discard on page 0915fac0, inode 0x43, offset 22950297=
6.</div>
<div>Filesystem &quot;ubdb1&quot;: page discard on page 0915fae0, inode 0x4=
3, offset 229507072.</div><div>Filesystem &quot;ubdb1&quot;: page discard o=
n page 0914d440, inode 0x43, offset 229511168.</div></div><div><br></div>
<div><br></div><div>Should we just discard the page? I don&#39;t think it i=
s good because the file will be corrupted.=A0</div><div>Should we fix it? I=
 am new to XFS and more than like to hear your=A0opinion.=A0</div><div><br>=
</div>
<div>Thanks very much,</div><div>Mike Gao</div>

--002354471d8cbfc1be048e19df29--


--===============3366453597439823050==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3366453597439823050==--
