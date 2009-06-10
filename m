Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5AApgbE087914 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 05:51:43 -0500
Received: from bay0-omc2-s28.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 170F52E5672
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 03:52:01 -0700 (PDT)
Received: from bay0-omc2-s28.bay0.hotmail.com (bay0-omc2-s28.bay0.hotmail.com
	[65.54.246.164]) by cuda.sgi.com with ESMTP id 7dcLB5FURCgbeobF
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 03:52:01 -0700 (PDT)
Message-ID: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
From: jack the ripper <evil_metalpeet@hotmail.com>
Subject: xfs_growfs doesn't grow on 2TB raid
Date: Wed, 10 Jun 2009 12:52:01 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3173733216119612513=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3173733216119612513==
Content-Type: multipart/alternative;
	boundary="_06289e2e-cf01-4834-8e89-37b3052c9167_"

--_06289e2e-cf01-4834-8e89-37b3052c9167_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Hey all=2C





I ran against a problem today. I had a raid5 array with 5x500GB and
I've grown the array to 6x500GB. So far I always used this method to
add a disk to my raid setup:





    * Partition the disk with one fd partition


    * mdadm --add /dev/mddata1 /dev/sdf1=20


    * mdadm --grow /dev/mddata1 --raid-devices=3Dx


    * cryptsetup luksOpen /dev/mddata1 data1=20


    * xfs_check /dev/mapper/data1=20


    * mount the disk


    * xfs_growfs /dev/mapper/data1=20




But at the last step=2C when I do xfs_growfs=2C nothing happens. I
found out about the -d option and this is what I get (pay attention to
the last line):





		 =20
RoSe linux # xfs_growfs /dev/mapper/data1 -d


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


data size unchanged=2C skipping=09




After searching around on the net I found out that I probably hit
"a" 2TB limit but I checked my kernel support and that seems to be ok:





		  RoSe linux # zgrep -i efi /proc/config.gz


CONFIG_EFI=3Dy


CONFIG_FB_EFI=3Dy


CONFIG_EFI_VARS=3Dy


CONFIG_EFI_PARTITION=3Dy=09




Then I caught some hints about mbr and gpt=2C but is this also valid
with a software raid? That's some kind of a virtual drive=2C isn't it?
What can I do to bread this 2TB limit=2C or is it something else that
causes the grow to fail?





Proof that there is more size available:





		 =20


RoSe linux # mdadm -D /dev/mddata1


/dev/mddata1:


        Version : 0.90


  Creation Time : Sat May 30 19:25:26 2009


     Raid Level : raid5


     Array Size : 2441919680 (2328.80 GiB 2500.53 GB)


=09





		  RoSe linux # df --si


Filesystem             Size   Used  Avail Use% Mounted on


/dev/mapper/data1      2.1T   2.0T    63G  97% /mnt/data1
_________________________________________________________________
Je hele online leven op =E9=E9n stek met Windows Live
http://www.microsoft.com/belux/nl/windows/windowslive/default.aspx=

--_06289e2e-cf01-4834-8e89-37b3052c9167_
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
<span class=3D"postbody">Hey all=2C
<br>

<br>
I ran against a problem today. I had a raid5 array with 5x500GB and
I've grown the array to 6x500GB. So far I always used this method to
add a disk to my raid setup:
<br>

<br>
    * Partition the disk with one fd partition
<br>
    * mdadm --add /dev/mddata1 /dev/sdf1=20
<br>
    * mdadm --grow /dev/mddata1 --raid-devices=3Dx
<br>
    * cryptsetup luksOpen /dev/mddata1 data1=20
<br>
    * xfs_check /dev/mapper/data1=20
<br>
    * mount the disk
<br>
    * xfs_growfs /dev/mapper/data1=20
<br>

<br>But at the last step=2C when I do xfs_growfs=2C nothing happens. I
found out about the -d option and this is what I get (pay attention to
the last line):
<br>

<br>
</span><table width=3D"90%" align=3D"center" border=3D"0" cellpadding=3D"3"=
 cellspacing=3D"1"><tbody>	<tr>	  <td class=3D"code">
RoSe linux # xfs_growfs /dev/mapper/data1 -d
<br>
meta-data=3D/dev/mapper/data1&nbsp=3B &nbsp=3B &nbsp=3B isize=3D256&nbsp=3B=
 &nbsp=3B agcount=3D9=2C agsize=3D61047928 blks
<br>
&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B=3D&nbsp=3B &nbsp=3B &nbsp=3B &=
nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbs=
p=3Bsectsz=3D512&nbsp=3B &nbsp=3Battr=3D2
<br>
data&nbsp=3B &nbsp=3B &nbsp=3B=3D&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=
=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3Bbsize=3D4=
096&nbsp=3B &nbsp=3Bblocks=3D488383679=2C imaxpct=3D25
<br>
&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B=3D&nbsp=3B &nbsp=3B &nbsp=3B &=
nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbs=
p=3Bsunit=3D0&nbsp=3B &nbsp=3B &nbsp=3B swidth=3D0 blks
<br>
naming&nbsp=3B &nbsp=3B=3Dversion 2&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbs=
p=3B &nbsp=3B &nbsp=3B bsize=3D4096&nbsp=3B &nbsp=3Bascii-ci=3D0
<br>
log&nbsp=3B &nbsp=3B &nbsp=3B =3Dinternal&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=
=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3Bbsize=3D4096&nbsp=3B &nbsp=3Bblocks=
=3D32768=2C version=3D2
<br>
&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B=3D&nbsp=3B &nbsp=3B &nbsp=3B &=
nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbs=
p=3Bsectsz=3D512&nbsp=3B &nbsp=3Bsunit=3D0 blks=2C lazy-count=3D0
<br>
realtime =3Dnone&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=
=3B &nbsp=3B &nbsp=3B &nbsp=3Bextsz=3D4096&nbsp=3B &nbsp=3Bblocks=3D0=2C rt=
extents=3D0
<br>
data size unchanged=2C skipping</td>	</tr></tbody></table><span class=3D"po=
stbody">
<br>

<br>After searching around on the net I found out that I probably hit
"a" 2TB limit but I checked my kernel support and that seems to be ok:
<br>

<br>
</span><table width=3D"90%" align=3D"center" border=3D"0" cellpadding=3D"3"=
 cellspacing=3D"1"><tbody>	<tr>	  <td class=3D"code">RoSe linux # zgrep -i =
efi /proc/config.gz
<br>
CONFIG_EFI=3Dy
<br>
CONFIG_FB_EFI=3Dy
<br>
CONFIG_EFI_VARS=3Dy
<br>
CONFIG_EFI_PARTITION=3Dy</td>	</tr></tbody></table><span class=3D"postbody"=
>
<br>

<br>Then I caught some hints about mbr and gpt=2C but is this also valid
with a software raid? That's some kind of a virtual drive=2C isn't it?
What can I do to bread this 2TB limit=2C or is it something else that
causes the grow to fail?
<br>

<br>
Proof that there is more size available:
<br>

<br>
</span><table width=3D"90%" align=3D"center" border=3D"0" cellpadding=3D"3"=
 cellspacing=3D"1"><tbody>	<tr>	  <td class=3D"code">
<br>
RoSe linux # mdadm -D /dev/mddata1
<br>
/dev/mddata1:
<br>
&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B Version : 0.90
<br>
&nbsp=3B Creation Time : Sat May 30 19:25:26 2009
<br>
&nbsp=3B &nbsp=3B &nbsp=3BRaid Level : raid5
<br>
&nbsp=3B &nbsp=3B &nbsp=3BArray Size : 2441919680 (2328.80 GiB 2500.53 GB)
<br>
</td>	</tr></tbody></table><span class=3D"postbody">
<br>

<br>
</span><table width=3D"90%" align=3D"center" border=3D"0" cellpadding=3D"3"=
 cellspacing=3D"1"><tbody>	<tr>	  <td class=3D"code">RoSe linux # df --si
<br>
Filesystem&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3BSiz=
e&nbsp=3B &nbsp=3BUsed&nbsp=3B Avail Use% Mounted on
<br>
/dev/mapper/data1&nbsp=3B &nbsp=3B &nbsp=3B 2.1T&nbsp=3B &nbsp=3B2.0T&nbsp=
=3B &nbsp=3B 63G&nbsp=3B 97% /mnt/data1</td></tr></tbody></table><br /><hr =
/>Je hele online leven op =E9=E9n stek? <a href=3D'http://www.microsoft.com=
/belux/nl/windows/windowslive/default.aspx' target=3D'_new'>Ontdek Windows =
Live!</a></body>
</html>=

--_06289e2e-cf01-4834-8e89-37b3052c9167_--


--===============3173733216119612513==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3173733216119612513==--
