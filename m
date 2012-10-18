Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9IFPVMY197834 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 10:25:32 -0500
Received: from mail-vb0-f53.google.com (mail-vb0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id vBtQ31Zs5EFxqWCC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Oct 2012 08:27:10 -0700 (PDT)
Received: by mail-vb0-f53.google.com with SMTP id fc21so9151191vbb.26
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 08:27:09 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Oct 2012 19:27:09 +0400
Message-ID: <CAGNmme5p0k5zoNufs2040Aim3mkP_q4pP7z98WoRRkhdrf0JDw@mail.gmail.com>
Subject: Question about AGFL
From: Sergey Stepanov <g65434.2@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2327171548291144651=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2327171548291144651==
Content-Type: multipart/alternative; boundary=047d7bf0ef283f4b9304cc570574

--047d7bf0ef283f4b9304cc570574
Content-Type: text/plain; charset=ISO-8859-1

Hi.

I have a device with XFS on it and if I run xfs_db on it, I get the
following:

xfs_db> agf 0
xfs_db> p
magicnum = 0x58414746
versionnum = 1
seqno = 0
length = 6553344
bnoroot = 19432
cntroot = 20689
bnolevel = 1
cntlevel = 1
flfirst = 0
fllast = 3
flcount = 4
freeblks = 6529632
longest = 6522442
btreeblks = 0
xfs_db> agfl 0
xfs_db> p
bno[0-127] = 0:1 1:2 2:3 3:4

As you can see, AGFL contains block numbers 1-4.

As far as I understand, blocks 1-3 contain roots for inode and free space
trees, so it seems really suspicious to me that they are listed in free
list.
I  digged a bit into XFS code inside Linux kernel and did not find any code
that will prevent overwriting them when B+trees will start to grow.

So, the question is did I miss something and this is a normal situation, or
is this some kind of bug or corruption?

Thanks in advance.

--047d7bf0ef283f4b9304cc570574
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<span style=3D"font-family:Arial,Tahoma,Verdana,sans-serif;font-size:12px;b=
ackground-color:rgb(255,255,255)">Hi.</span><br style=3D"font-family:Arial,=
Tahoma,Verdana,sans-serif;font-size:12px;background-color:rgb(255,255,255)"=
>
<br style=3D"font-family:Arial,Tahoma,Verdana,sans-serif;font-size:12px;bac=
kground-color:rgb(255,255,255)"><span style=3D"font-family:Arial,Tahoma,Ver=
dana,sans-serif;font-size:12px;background-color:rgb(255,255,255)">I have a =
device with XFS on it and if I run xfs_db on it, I get the following:=A0</s=
pan><br style=3D"font-family:Arial,Tahoma,Verdana,sans-serif;font-size:12px=
;background-color:rgb(255,255,255)">
<p id=3D"mailru-webagent-gen-44" style=3D"font-family:Arial,Tahoma,Verdana,=
sans-serif;font-size:12px;background-color:rgb(255,255,255)">xfs_db&gt; agf=
 0<br>xfs_db&gt; p<br>magicnum =3D 0x58414746<br>versionnum =3D 1<br>seqno =
=3D 0<br>
length =3D 6553344<br>bnoroot =3D 19432<br>cntroot =3D 20689<br>bnolevel =
=3D 1<br>cntlevel =3D 1<br>flfirst =3D 0<br>fllast =3D 3<br>flcount =3D 4<b=
r>freeblks =3D 6529632<br>longest =3D 6522442<br>btreeblks =3D 0<br>xfs_db&=
gt; agfl 0<br>xfs_db&gt; p<br>
bno[0-127] =3D 0:1 1:2 2:3 3:4<br><br>As you can see, AGFL contains block n=
umbers 1-4.<br><br>As far as I understand, blocks 1-3 contain roots for ino=
de and free space trees, so it seems really suspicious to me that they are =
listed in free list.<br>
I =A0digged a bit into XFS code inside Linux kernel and did not find any co=
de that will prevent overwriting them when B+trees will start to grow.<br><=
br>So, the question is did I miss something and this is a normal situation,=
 or is this some kind of bug or corruption?=A0<br>
<br>Thanks in advance.=A0</p>

--047d7bf0ef283f4b9304cc570574--


--===============2327171548291144651==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2327171548291144651==--
