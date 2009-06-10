Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ACGMdl090581 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 07:16:22 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E87A1126CA7A
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 05:23:51 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id k7Wa0SYCJXTHZCyW for
	<xfs@oss.sgi.com>; Wed, 10 Jun 2009 05:23:51 -0700 (PDT)
From: "Michael Monnerie" <michael.monnerie@is.it-management.at>
References: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
In-Reply-To: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
Subject: RE: xfs_growfs doesn't grow on 2TB raid
Date: Wed, 10 Jun 2009 14:16:35 +0200
Message-ID: <00ee01c9e9c5$4cf36b20$e6da4160$@monnerie@is.it-management.at>
MIME-Version: 1.0
Content-Language: de-at
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5403583937989390663=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: 'jack the ripper' <evil_metalpeet@hotmail.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============5403583937989390663==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_00EF_01C9E9D6.107C3B20"
Content-Language: de-at

This is a multi-part message in MIME format.

------=_NextPart_000_00EF_01C9E9D6.107C3B20
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Sorry for top-posting, only have Outlook on my notebook.

=20

Isn=E2=80=99t 2TB the normal partition size limit? So if you want >2TB =
partitions, you must use GPT partitioning, =E2=80=9Cparted=E2=80=9D can =
create such partitions but not fdisk. AFAIK there is no option to simply =
change a disk from normal partitions to GPT without =
backup/repartition/restore.

=20

mfg zmi

--=20

// Michael Monnerie, Ing.BSc    -----       <http://it-management.at> =
http://it-management.at

// Tel: +43 (660) 415 6531                    .network.your.ideas.

// PGP Key:         "curl -s  <http://zmi.at/zmi.asc> =
http://zmi.at/zmi.asc | gpg --import"

// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4

// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


RoSe linux # xfs_growfs /dev/mapper/data1 -d=20
meta-data=3D/dev/mapper/data1      isize=3D256    agcount=3D9, =
agsize=3D61047928 blks=20
         =3D                       sectsz=3D512   attr=3D2=20
data     =3D                       bsize=3D4096   blocks=3D488383679, =
imaxpct=3D25=20
         =3D                       sunit=3D0      swidth=3D0 blks=20
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0=20
log      =3Dinternal               bsize=3D4096   blocks=3D32768, =
version=3D2=20
         =3D                       sectsz=3D512   sunit=3D0 blks, =
lazy-count=3D0=20
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0=20
data size unchanged, skipping

=20


------=_NextPart_000_00EF_01C9E9D6.107C3B20
Content-Type: text/html;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dutf-8">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
@font-face
	{font-family:Verdana;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman","serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.postbody
	{mso-style-name:postbody;}
span.E-MailFormatvorlage18
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page Section1
	{size:612.0pt 792.0pt;
	margin:70.85pt 70.85pt 2.0cm 70.85pt;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DDE-AT link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>Sorry for top-posting, only have Outlook on my =
notebook.<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>Isn=E2=80=99t 2TB the normal partition size limit? So if =
you want
&gt;2TB partitions, you must use GPT partitioning, =
=E2=80=9Cparted=E2=80=9D can create such
partitions but not fdisk. AFAIK there is no option to simply change a =
disk from
normal partitions to GPT without =
backup/repartition/restore.<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>mfg zmi<o:p></o:p></span></p>

<div>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>-- <o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.5pt;font-family:Consolas;
color:#1F497D'>// Michael Monnerie, Ing.BSc=C2=A0=C2=A0=C2=A0 =
-----=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 </span><span
style=3D'font-size:10.5pt;font-family:Consolas;color:#1F497D'><a
href=3D"http://it-management.at"><span lang=3DEN-US =
style=3D'color:blue'>http://it-management.at</span></a></span><span
lang=3DEN-US =
style=3D'font-size:10.5pt;font-family:Consolas;color:#1F497D'><o:p></o:p>=
</span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.5pt;font-family:Consolas;
color:#1F497D'>// Tel: +43 (660) 415 =
6531=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
.network.your.ideas.<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.5pt;font-family:Consolas;
color:#1F497D'>// PGP =
Key:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &quot;curl -s =
</span><span style=3D'font-size:
10.5pt;font-family:Consolas;color:#1F497D'><a =
href=3D"http://zmi.at/zmi.asc"><span
lang=3DEN-US =
style=3D'color:blue'>http://zmi.at/zmi.asc</span></a></span><span
lang=3DEN-US =
style=3D'font-size:10.5pt;font-family:Consolas;color:#1F497D'> | gpg
--import&quot;<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.5pt;font-family:Consolas;
color:#1F497D'>// Fingerprint: AC19 F9D5 36ED CD8A EF38=C2=A0 500E CE14 =
91F7 1C12
09B4<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.5pt;font-family:Consolas;
color:#1F497D'>// Keyserver: =
wwwkeys.eu.pgp.net=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Key-ID:
1C1209B4<o:p></o:p></span></p>

</div>

<div align=3Dcenter>

<table class=3DMsoNormalTable border=3D0 cellspacing=3D1 cellpadding=3D0 =
width=3D"90%"
 style=3D'width:90.0%'>
 <tr>
  <td style=3D'padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=3DMsoNormal><span lang=3DEN-US>RoSe linux # xfs_growfs =
/dev/mapper/data1
  -d <br>
  meta-data=3D/dev/mapper/data1&nbsp; &nbsp; &nbsp; isize=3D256&nbsp; =
&nbsp;
  agcount=3D9, agsize=3D61047928 blks <br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D&nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;sectsz=3D512&nbsp; =
&nbsp;attr=3D2 <br>
  data&nbsp; &nbsp; &nbsp;=3D&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;bsize=3D4096&nbsp; =
&nbsp;blocks=3D488383679,
  imaxpct=3D25 <br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D&nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;sunit=3D0&nbsp; &nbsp; &nbsp; =
swidth=3D0
  blks <br>
  naming&nbsp; &nbsp;=3Dversion 2&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;
  bsize=3D4096&nbsp; &nbsp;ascii-ci=3D0 <br>
  log&nbsp; &nbsp; &nbsp; =3Dinternal&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;
  &nbsp; &nbsp;bsize=3D4096&nbsp; &nbsp;blocks=3D32768, version=3D2 <br>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D&nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;sectsz=3D512&nbsp; =
&nbsp;sunit=3D0 blks,
  lazy-count=3D0 <br>
  realtime =3Dnone&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;
  &nbsp;extsz=3D4096&nbsp; &nbsp;blocks=3D0, rtextents=3D0 <br>
  data size unchanged, skipping<o:p></o:p></span></p>
  </td>
 </tr>
</table>

</div>

<p class=3DMsoNormal style=3D'margin-bottom:12.0pt'><span =
style=3D'font-size:10.0pt;
font-family:"Verdana","sans-serif"'><o:p>&nbsp;</o:p></span></p>

</div>

</body>

</html>

------=_NextPart_000_00EF_01C9E9D6.107C3B20--


--===============5403583937989390663==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5403583937989390663==--
