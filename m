Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EAEEC7FC4
	for <xfs@oss.sgi.com>; Sat, 27 Sep 2014 02:32:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D88DC304039
	for <xfs@oss.sgi.com>; Sat, 27 Sep 2014 00:32:22 -0700 (PDT)
Received: from mail-ie0-f172.google.com (mail-ie0-f172.google.com
	[209.85.223.172]) by cuda.sgi.com with ESMTP id
	fDcJeXgmlEfAbzZq (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 27 Sep 2014 00:32:21 -0700 (PDT)
Received: by mail-ie0-f172.google.com with SMTP id rp18so14999976iec.17
	for <xfs@oss.sgi.com>; Sat, 27 Sep 2014 00:32:21 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 27 Sep 2014 00:32:21 -0700
Message-ID: <CAOj3taPoXpVktWJxmYKLZrvfe7T1qYArLsoQ39gsMdj_T1hNYg@mail.gmail.com>
Subject: blktrace and xfs_db block offset mismatch
From: Sushma R <gsushma@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8078896109570181020=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8078896109570181020==
Content-Type: multipart/alternative; boundary=f46d04089005b9b55c050407087a

--f46d04089005b9b55c050407087a
Content-Type: text/plain; charset=UTF-8

Hi,

I ran blktrace while reading a file on XFS partition and here's it's output.

8,17   3        1    22.065944956  5489  D   R 20973896 + 8 [cat]

Using xfs_db, I dumped the inode for the same file and it shows the
following as its data extents.

u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,2621481,1,0]

I understand that blktrace reports in 512-byte sectors while xfs_db in
filesystem block size (which is the default 4KB on my setup).
Converting blktrace offset to fs block = 2621737 which is close to the data
extent startblock (2621481), but still off by 256 fs blocks.

Could someone please help understand the reason for this mismatch?

Thanks,
Sushma

--f46d04089005b9b55c050407087a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I ran blktrace while reading a file=
 on XFS partition and here&#39;s it&#39;s output.</div><div><br></div><div>=
8,17 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A022.065944956 =C2=A0=
5489 =C2=A0D =C2=A0 R 20973896 + 8 [cat]<br></div><div><br></div><div>Using=
 xfs_db, I dumped the inode for the same file and it shows the following as=
 its data extents.</div><div><br></div><div>u.bmx[0] =3D [startoff,startblo=
ck,blockcount,extentflag] 0:[0,2621481,1,0]<br></div><div><br></div><div>I =
understand that blktrace reports in 512-byte sectors while xfs_db in filesy=
stem block size (which is the default 4KB on my setup).</div><div>Convertin=
g blktrace offset to fs block =3D=C2=A02621737 which is close to the data e=
xtent startblock (2621481), but still off by 256 fs blocks.</div><div><br><=
/div><div>Could someone please help understand the reason for this mismatch=
?</div><div><br></div><div>Thanks,</div><div>Sushma</div></div>

--f46d04089005b9b55c050407087a--


--===============8078896109570181020==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8078896109570181020==--
