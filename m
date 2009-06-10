Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ACU056091245 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 07:30:00 -0500
Received: from bay0-omc2-s20.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 851031D3C5B7
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 05:30:19 -0700 (PDT)
Received: from bay0-omc2-s20.bay0.hotmail.com (bay0-omc2-s20.bay0.hotmail.com
	[65.54.246.156]) by cuda.sgi.com with ESMTP id GtwmMoyF1ERqvW01
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 05:30:19 -0700 (PDT)
Message-ID: <BAY108-W43AAADA49E758366E8F23AF3450@phx.gbl>
From: jack the ripper <evil_metalpeet@hotmail.com>
Subject: RE: xfs_growfs doesn't grow on 2TB raid
Date: Wed, 10 Jun 2009 14:30:19 +0200
In-Reply-To: <00ee01c9e9c5$4cf36b20$e6da4160$@monnerie@is.it-management.at>
References: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
	<00ee01c9e9c5$4cf36b20$e6da4160$@monnerie@is.it-management.at>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7686127204652727347=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: michael.monnerie@is.it-management.at
Cc: xfs@oss.sgi.com

--===============7686127204652727347==
Content-Type: multipart/alternative;
	boundary="_be0005b9-397d-44d4-a5fc-cecf6b85c2af_"

--_be0005b9-397d-44d4-a5fc-cecf6b85c2af_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable


2TB is indeed the limit for MBR partitions but I thought this had nothing t=
o do with a "virtual" software raid? The disks an sich have indeed an MBR p=
artition table=2C but each disk is only 500GB.

Can you confirm that I need GPT for my software raid?

From: michael.monnerie@is.it-management.at
To: evil_metalpeet@hotmail.com
CC: xfs@oss.sgi.com
Subject: RE: xfs_growfs doesn't grow on 2TB raid
Date: Wed=2C 10 Jun 2009 14:16:35 +0200
















Sorry for top-posting=2C only have Outlook on my notebook.

=20

Isn=92t 2TB the normal partition size limit? So if you want
>2TB partitions=2C you must use GPT partitioning=2C =93parted=94 can create=
 such
partitions but not fdisk. AFAIK there is no option to simply change a disk =
from
normal partitions to GPT without backup/repartition/restore.

=20

mfg zmi



--=20

// Michael Monnerie=2C Ing.BSc    -----      http://it-management.at

// Tel: +43 (660) 415 6531                  =20
.network.your.ideas.

// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg
--import"

// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12
09B4

// Keyserver: wwwkeys.eu.pgp.net                  Key-ID:
1C1209B4






=20
 =20
  RoSe linux # xfs_growfs /dev/mapper/data1
  -d=20

  meta-data=3D/dev/mapper/data1      isize=3D256  =20
  agcount=3D9=2C agsize=3D61047928 blks=20

           =3D          =20
             sectsz=3D512   attr=3D2=20

  data     =3D            =20
           bsize=3D4096   blocks=3D488383679=2C
  imaxpct=3D25=20

           =3D          =20
             sunit=3D0      swidth=3D0
  blks=20

  naming   =3Dversion 2            =20
  bsize=3D4096   ascii-ci=3D0=20

  log      =3Dinternal          =20
     bsize=3D4096   blocks=3D32768=2C version=3D2=20

           =3D          =20
             sectsz=3D512   sunit=3D0 blks=2C
  lazy-count=3D0=20

  realtime =3Dnone                =20
   extsz=3D4096   blocks=3D0=2C rtextents=3D0=20

  data size unchanged=2C skipping
 =20
=20




=20


_________________________________________________________________
Reageer op foto=92s van je vrienden en bekijk hun reacties op de jouwe. Geg=
arandeerd hilariteit!=20
http://www.microsoft.com/belux/nl/windows/windowslive/products/photos.aspx=

--_be0005b9-397d-44d4-a5fc-cecf6b85c2af_
Content-Type: text/html; charset="Windows-1252"
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
2TB is indeed the limit for MBR partitions but I thought this had nothing t=
o do with a "virtual" software raid? The disks an sich have indeed an MBR p=
artition table=2C but each disk is only 500GB.<br><br>Can you confirm that =
I need GPT for my software raid?<br><br><hr id=3D"stopSpelling">From: micha=
el.monnerie@is.it-management.at<br>To: evil_metalpeet@hotmail.com<br>CC: xf=
s@oss.sgi.com<br>Subject: RE: xfs_growfs doesn't grow on 2TB raid<br>Date: =
Wed=2C 10 Jun 2009 14:16:35 +0200<br><br>






<style>
.ExternalClass p.EC_MsoNormal=2C .ExternalClass li.EC_MsoNormal=2C .Externa=
lClass div.EC_MsoNormal
{margin-bottom:.0001pt=3Bfont-size:12.0pt=3Bfont-family:'Times New Roman'=
=2C'serif'=3B}
.ExternalClass a:link=2C .ExternalClass span.EC_MsoHyperlink
{color:blue=3Btext-decoration:underline=3B}
.ExternalClass a:visited=2C .ExternalClass span.EC_MsoHyperlinkFollowed
{color:purple=3Btext-decoration:underline=3B}
.ExternalClass span.EC_postbody
{=3B}
.ExternalClass span.EC_E-MailFormatvorlage18
{font-family:'Calibri'=2C'sans-serif'=3Bcolor:#1F497D=3B}
.ExternalClass .EC_MsoChpDefault
{font-size:10.0pt=3B}
@page Section1
{size:612.0pt 792.0pt=3B}
.ExternalClass div.EC_Section1
{page:Section1=3B}
</style>





<div class=3D"EC_Section1">

<p class=3D"EC_MsoNormal"><span style=3D"font-size: 11pt=3B font-family: 'C=
alibri'=2C'sans-serif'=3B color: rgb(31=2C 73=2C 125)=3B" lang=3D"EN-US">So=
rry for top-posting=2C only have Outlook on my notebook.</span></p>

<p class=3D"EC_MsoNormal"><span style=3D"font-size: 11pt=3B font-family: 'C=
alibri'=2C'sans-serif'=3B color: rgb(31=2C 73=2C 125)=3B" lang=3D"EN-US">&n=
bsp=3B</span></p>

<p class=3D"EC_MsoNormal"><span style=3D"font-size: 11pt=3B font-family: 'C=
alibri'=2C'sans-serif'=3B color: rgb(31=2C 73=2C 125)=3B" lang=3D"EN-US">Is=
n=92t 2TB the normal partition size limit? So if you want
&gt=3B2TB partitions=2C you must use GPT partitioning=2C =93parted=94 can c=
reate such
partitions but not fdisk. AFAIK there is no option to simply change a disk =
from
normal partitions to GPT without backup/repartition/restore.</span></p>

<p class=3D"EC_MsoNormal"><span style=3D"font-size: 11pt=3B font-family: 'C=
alibri'=2C'sans-serif'=3B color: rgb(31=2C 73=2C 125)=3B" lang=3D"EN-US">&n=
bsp=3B</span></p>

<p class=3D"EC_MsoNormal"><span style=3D"font-size: 11pt=3B font-family: 'C=
alibri'=2C'sans-serif'=3B color: rgb(31=2C 73=2C 125)=3B" lang=3D"EN-US">mf=
g zmi</span></p>

<div>

<p class=3D"EC_MsoNormal"><span style=3D"font-size: 11pt=3B font-family: 'C=
alibri'=2C'sans-serif'=3B color: rgb(31=2C 73=2C 125)=3B" lang=3D"EN-US">--=
 </span></p>

<p class=3D"EC_MsoNormal"><span style=3D"font-size: 10.5pt=3B font-family: =
Consolas=3B color: rgb(31=2C 73=2C 125)=3B" lang=3D"EN-US">// Michael Monne=
rie=2C Ing.BSc&nbsp=3B&nbsp=3B&nbsp=3B -----&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B </span><span style=3D"font-size: 10.5pt=3B font-family: Consola=
s=3B color: rgb(31=2C 73=2C 125)=3B"><a href=3D"http://it-management.at"><s=
pan style=3D"color: blue=3B" lang=3D"EN-US">http://it-management.at</span><=
/a></span><span style=3D"font-size: 10.5pt=3B font-family: Consolas=3B colo=
r: rgb(31=2C 73=2C 125)=3B" lang=3D"EN-US"></span></p>

<p class=3D"EC_MsoNormal"><span style=3D"font-size: 10.5pt=3B font-family: =
Consolas=3B color: rgb(31=2C 73=2C 125)=3B" lang=3D"EN-US">// Tel: +43 (660=
) 415 6531&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B
.network.your.ideas.</span></p>

<p class=3D"EC_MsoNormal"><span style=3D"font-size: 10.5pt=3B font-family: =
Consolas=3B color: rgb(31=2C 73=2C 125)=3B" lang=3D"EN-US">// PGP Key:&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B "curl -s </span=
><span style=3D"font-size: 10.5pt=3B font-family: Consolas=3B color: rgb(31=
=2C 73=2C 125)=3B"><a href=3D"http://zmi.at/zmi.asc"><span style=3D"color: =
blue=3B" lang=3D"EN-US">http://zmi.at/zmi.asc</span></a></span><span style=
=3D"font-size: 10.5pt=3B font-family: Consolas=3B color: rgb(31=2C 73=2C 12=
5)=3B" lang=3D"EN-US"> | gpg
--import"</span></p>

<p class=3D"EC_MsoNormal"><span style=3D"font-size: 10.5pt=3B font-family: =
Consolas=3B color: rgb(31=2C 73=2C 125)=3B" lang=3D"EN-US">// Fingerprint: =
AC19 F9D5 36ED CD8A EF38&nbsp=3B 500E CE14 91F7 1C12
09B4</span></p>

<p class=3D"EC_MsoNormal"><span style=3D"font-size: 10.5pt=3B font-family: =
Consolas=3B color: rgb(31=2C 73=2C 125)=3B" lang=3D"EN-US">// Keyserver: ww=
wkeys.eu.pgp.net&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B Key-ID:
1C1209B4</span></p>

</div>

<div align=3D"center">

<table class=3D"EC_MsoNormalTable" style=3D"width: 90%=3B" width=3D"90%" bo=
rder=3D"0" cellpadding=3D"0" cellspacing=3D"1">
 <tbody><tr>
  <td style=3D"padding: 2.25pt=3B">
  <p class=3D"EC_MsoNormal"><span lang=3D"EN-US">RoSe linux # xfs_growfs /d=
ev/mapper/data1
  -d <br>
  meta-data=3D/dev/mapper/data1&nbsp=3B &nbsp=3B &nbsp=3B isize=3D256&nbsp=
=3B &nbsp=3B
  agcount=3D9=2C agsize=3D61047928 blks <br>
  &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B=3D&nbsp=3B &nbsp=3B &nbsp=3B=
 &nbsp=3B &nbsp=3B &nbsp=3B
  &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3Bsectsz=3D512&nbsp=3B=
 &nbsp=3Battr=3D2 <br>
  data&nbsp=3B &nbsp=3B &nbsp=3B=3D&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbs=
p=3B &nbsp=3B &nbsp=3B
  &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3Bbsize=3D4096&nbsp=3B &nbsp=3B=
blocks=3D488383679=2C
  imaxpct=3D25 <br>
  &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B=3D&nbsp=3B &nbsp=3B &nbsp=3B=
 &nbsp=3B &nbsp=3B &nbsp=3B
  &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3Bsunit=3D0&nbsp=3B &n=
bsp=3B &nbsp=3B swidth=3D0
  blks <br>
  naming&nbsp=3B &nbsp=3B=3Dversion 2&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &n=
bsp=3B &nbsp=3B &nbsp=3B
  bsize=3D4096&nbsp=3B &nbsp=3Bascii-ci=3D0 <br>
  log&nbsp=3B &nbsp=3B &nbsp=3B =3Dinternal&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=
=3B &nbsp=3B &nbsp=3B
  &nbsp=3B &nbsp=3Bbsize=3D4096&nbsp=3B &nbsp=3Bblocks=3D32768=2C version=
=3D2 <br>
  &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B=3D&nbsp=3B &nbsp=3B &nbsp=3B=
 &nbsp=3B &nbsp=3B &nbsp=3B
  &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3Bsectsz=3D512&nbsp=3B=
 &nbsp=3Bsunit=3D0 blks=2C
  lazy-count=3D0 <br>
  realtime =3Dnone&nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nbsp=3B &nb=
sp=3B &nbsp=3B &nbsp=3B
  &nbsp=3Bextsz=3D4096&nbsp=3B &nbsp=3Bblocks=3D0=2C rtextents=3D0 <br>
  data size unchanged=2C skipping</span></p>
  </td>
 </tr>
</tbody></table>

</div>

<p class=3D"EC_MsoNormal" style=3D"margin-bottom: 12pt=3B"><span style=3D"f=
ont-size: 10pt=3B font-family: 'Verdana'=2C'sans-serif'=3B">&nbsp=3B</span>=
</p>

</div><br /><hr />Voeg vrienden toe van LinkedIn & Facebook aan je Windows =
Live netwerk. <a href=3D'http://profile.live.com/connect' target=3D'_new'>Z=
o heb je iedereen bij de hand. </a></body>
</html>=

--_be0005b9-397d-44d4-a5fc-cecf6b85c2af_--


--===============7686127204652727347==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7686127204652727347==--
