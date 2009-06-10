Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5AFs1D0098966 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 10:54:02 -0500
Received: from bay0-omc2-s6.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87B0F126E40E
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 09:01:32 -0700 (PDT)
Received: from bay0-omc2-s6.bay0.hotmail.com (bay0-omc2-s6.bay0.hotmail.com
	[65.54.246.142]) by cuda.sgi.com with ESMTP id P7oWH7jfVAGvvvSY
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 09:01:32 -0700 (PDT)
Message-ID: <BAY108-W13BBC60EFE8CFE4B623CB3F3450@phx.gbl>
From: jack the ripper <evil_metalpeet@hotmail.com>
Subject: RE: xfs_growfs doesn't grow on 2TB raid
Date: Wed, 10 Jun 2009 17:54:20 +0200
In-Reply-To: <4A2FAFA0.9020408@dermichi.com>
References: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
	<00ee01c9e9c5$4cf36b20$e6da4160$@monnerie@is.it-management.at>
	<BAY108-W43AAADA49E758366E8F23AF3450@phx.gbl>
	<4A2FAFA0.9020408@dermichi.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3847912227194941722=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: mw@dermichi.com
Cc: xfs@oss.sgi.com

--===============3847912227194941722==
Content-Type: multipart/alternative;
	boundary="_93595df9-abb7-4578-8930-895e05b2caea_"

--_93595df9-abb7-4578-8930-895e05b2caea_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


I had not done the reboot (I'm not used to that anymore with linux). I did =
now though and everything is solved:

RoSe v1per # /root/mount.data1
mdadm: /dev/mddata1 has been started with 6 drives.
Enter LUKS passphrase:
key slot 0 unlocked.
Command successful.

RoSe v1per # xfs_growfs /mnt/data1/
meta-data=3D/dev/mapper/data1      isize=3D256    agcount=3D9=2C agsize=3D6=
1047928 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D488383679=2C ima=
xpct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D32768=2C version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks=2C lazy-co=
unt=3D0
realtime =3Dnone                   extsz=3D4096   blocks=3D0=2C rtextents=
=3D0
data blocks changed from 488383679 to 610479663

RoSe v1per # df --si
Filesystem             Size   Used  Avail Use% Mounted on
udev                    11M   349k    11M   4% /dev
shm                    1.1G      0   1.1G   0% /dev/shm
/dev/mapper/data1      2.6T   1.9T   655G  74% /mnt/data1

Thank you all for helping me so quickly and sorry for bothering all of you =
with the solution being so simple!

> Date: Wed=2C 10 Jun 2009 15:05:36 +0200
> From: mw@dermichi.com
> To: evil_metalpeet@hotmail.com
> CC: xfs@oss.sgi.com
> Subject: Re: xfs_growfs doesn't grow on 2TB raid
>=20
> > Can you confirm that I need GPT for my software raid?
> You don't need GPT for software RAID unless one of your disks is >2TB. Fo=
r example I am running a 3TB XFS file system directly on /dev/md0. Have you=
 done a reboot=2C maybe the new size has not really been applied? Never tri=
ed it with LUKS/cryptsetup though=2C maybe it won't to above 2GB.
>=20
> # df -h /dev/md0
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md0              2.8T  1.5T  1.4T  53% /san1
>=20
> hth Michael

_________________________________________________________________
Je hele online leven op =E9=E9n stek met Windows Live
http://www.microsoft.com/belux/nl/windows/windowslive/default.aspx=

--_93595df9-abb7-4578-8930-895e05b2caea_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Verdana
}
</style>
</head>
<body class=3D'hmmessage'>
I had not done the reboot (I'm not used to that anymore with linux). I did =
now though and everything is solved:<br><br>RoSe v1per # /root/mount.data1<=
br>mdadm: /dev/mddata1 has been started with 6 drives.<br>Enter LUKS passph=
rase:<br>key slot 0 unlocked.<br>Command successful.<br><br>RoSe v1per # xf=
s_growfs /mnt/data1/<br>meta-data=3D/dev/mapper/data1&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B isize=3D256&nbsp=3B&nbsp=3B&nbsp=3B agcount=3D9=2C agsi=
ze=3D61047928 blks<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B =3D&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B sectsz=3D512&nbsp=3B&nbsp=3B at=
tr=3D2<br>data&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =3D&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B bsize=3D4096&nbsp=3B&nbsp=3B blocks=3D488383679=2C imaxpct=3D25<br>&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =3D&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B sunit=3D0&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B swidth=
=3D0 blks<br>naming&nbsp=3B&nbsp=3B =3Dversion 2&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B bsize=3D4096&nbsp=3B&nbsp=3B ascii-ci=3D0<br>log&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B =3Dinternal&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B bsize=
=3D4096&nbsp=3B&nbsp=3B blocks=3D32768=2C version=3D2<br>&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =3D&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B sectsz=3D512&nbsp=3B&nbsp=3B sunit=3D0 blks=2C lazy-count=3D0<br>realti=
me =3Dnone&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B extsz=3D4096&nbsp=3B&nbsp=3B blocks=3D0=2C rtextents=3D0<br>data block=
s changed from 488383679 to 610479663<br><br>RoSe v1per # df --si<br>Filesy=
stem&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Size&nbsp=3B&nbsp=3B Used&nbsp=3B Avail Use% Mo=
unted on<br>udev&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B 11M&nbsp=3B&nbsp=3B 349k&nbsp=3B&nbsp=3B&nbsp=3B 11M&nb=
sp=3B&nbsp=3B 4% /dev<br>shm&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1.1G&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B 0&nbsp=3B&nbsp=3B 1.1G&nbsp=3B&nbsp=3B 0% /dev/shm<br>/dev/mapper/data1=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 2.6T&nbsp=3B&nbsp=3B 1.9T&nbsp=3B&=
nbsp=3B 655G&nbsp=3B 74% /mnt/data1<br><br>Thank you all for helping me so =
quickly and sorry for bothering all of you with the solution being so simpl=
e!<br><br>&gt=3B Date: Wed=2C 10 Jun 2009 15:05:36 +0200<br>&gt=3B From: mw=
@dermichi.com<br>&gt=3B To: evil_metalpeet@hotmail.com<br>&gt=3B CC: xfs@os=
s.sgi.com<br>&gt=3B Subject: Re: xfs_growfs doesn't grow on 2TB raid<br>&gt=
=3B <br>&gt=3B &gt=3B Can you confirm that I need GPT for my software raid?=
<br>&gt=3B You don't need GPT for software RAID unless one of your disks is=
 &gt=3B2TB. For example I am running a 3TB XFS file system directly on /dev=
/md0. Have you done a reboot=2C maybe the new size has not really been appl=
ied? Never tried it with LUKS/cryptsetup though=2C maybe it won't to above =
2GB.<br>&gt=3B <br>&gt=3B # df -h /dev/md0<br>&gt=3B Filesystem            =
Size  Used Avail Use% Mounted on<br>&gt=3B /dev/md0              2.8T  1.5T=
  1.4T  53% /san1<br>&gt=3B <br>&gt=3B hth Michael<br><br /><hr />Je hele o=
nline leven op =E9=E9n stek? <a href=3D'http://www.microsoft.com/belux/nl/w=
indows/windowslive/default.aspx' target=3D'_new'>Ontdek Windows Live!</a></=
body>
</html>=

--_93595df9-abb7-4578-8930-895e05b2caea_--


--===============3847912227194941722==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3847912227194941722==--
