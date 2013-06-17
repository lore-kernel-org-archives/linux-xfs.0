Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C7CB97F37
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 10:07:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A335B304051
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 08:06:58 -0700 (PDT)
Received: from mailserver2.vanderlande.com (mailserver2.vanderlande.com
	[212.61.149.236]) by cuda.sgi.com with ESMTP id
	gn2kGV4YBUAQSLoC (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 08:06:55 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============1707002425=="
MIME-Version: 1.0
From: Thomas Molszich <Thomas.Molszich@vanderlande.com>
Date: Mon, 17 Jun 2013 17:06:50 +0200
Subject: linux software raid5 on lvm: sunit/swidth required?
Message-ID: <57FC0B2322184044812B39B9440D8AF662898079AA@MBX1.vi.corp>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============1707002425==
Content-Language: de-DE
Content-Type: multipart/alternative;
	boundary="_000_57FC0B2322184044812B39B9440D8AF662898079AAMBX1vicorp_"

--_000_57FC0B2322184044812B39B9440D8AF662898079AAMBX1vicorp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello all,

At present, does one still need to calculate and pass the sunit/swidth to m=
kfs.xfs or does xfs calculate
All this on its own?
Xfsprogs 3.1.7, linked against libblkid, kernel 3.2.48 (Ubuntu 12.04 LTS), =
6x3000GB Hitachi 4k sectors
with 512b emulation, partitions and lvm 4k aligned already.

If manual calculation is still required, where can I read up on that?

With kind regards

Thomas Molszich


--_000_57FC0B2322184044812B39B9440D8AF662898079AAMBX1vicorp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40"><head><META HTTP-EQUIV=3D"Content-Type" CONTENT=
=3D"text/html; charset=3Dus-ascii"><meta name=3DGenerator content=3D"Micros=
oft Word 12 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:PMingLiU;
	panose-1:2 2 3 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"\@PMingLiU";
	panose-1:2 2 3 0 0 0 0 0 0 0;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.E-MailFormatvorlage17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:70.85pt 70.85pt 2.0cm 70.85pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue vli=
nk=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal>Hello all,<o:p><=
/o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>At =
present, does one still need to calculate and pass the sunit/swidth to mkfs=
.xfs or does xfs calculate<o:p></o:p></p><p class=3DMsoNormal>All this on i=
ts own?<o:p></o:p></p><p class=3DMsoNormal>Xfsprogs 3.1.7, linked against l=
ibblkid, kernel 3.2.48 (Ubuntu 12.04 LTS), 6x3000GB Hitachi 4k sectors <o:p=
></o:p></p><p class=3DMsoNormal>with 512b emulation, partitions and lvm 4k =
aligned already.<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p=
 class=3DMsoNormal>If manual calculation is still required, where can I rea=
d up on that?<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p cl=
ass=3DMsoNormal><span lang=3DNL style=3D'font-size:10.0pt;font-family:"Aria=
l","sans-serif"'>With kind regards<o:p></o:p></span></p><p class=3DMsoNorma=
l><span lang=3DNL style=3D'font-size:10.0pt;font-family:"Arial","sans-serif=
"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=3D'font-siz=
e:10.0pt;font-family:"Arial","sans-serif"'>Thomas Molszich<o:p></o:p></span=
></p><p class=3DMsoNormal><span style=3D'font-family:"Arial","sans-serif"'>=
<o:p>&nbsp;</o:p></span></p></div></body></html>=

--_000_57FC0B2322184044812B39B9440D8AF662898079AAMBX1vicorp_--

--===============1707002425==
Content-Type: multipart/alternative; boundary="===============0749760688=="
MIME-Version: 1.0
Content-Disposition: inline

--===============0749760688==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Think green: do you really need to print this e-mail?

Diese E-Mail enth=C3=A4lt vertrauliche und/oder rechtlich
gesch=C3=BCtzte Informationen. Wenn Sie nicht der richtige
Adressat sind oder diese E-Mail irrt=C3=BCmlich erhalten
haben, informieren Sie bitte den Absender und l=C3=B6schen
Sie diese Mail. Das unerlaubte Kopieren sowie die
unbefugte Weitergabe dieser E-Mail und der
darin enthaltenen Informationen sind nicht gestattet.

This e-mail may contain confidential and/or privileged
information. If you are not the intended recipient
(or have received this e-mail in error) please notify the
sender immediately and delete this e-mail. Any
unauthorized copying, disclosure or distribution of
the material in this e-mail is strictly forbidden.

Vanderlande Industries GmbH
Sitz der Gesellschaft:    Dortmund, Deutschland
Amtsgericht Dortmund: HRB 8539
Gesch=C3=A4ftsf=C3=BChrer:           Peter Stuer
--===============0749760688==
Content-Type: text/html; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<P><strong><span style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Arial'; COLOR: #4f=
6228">Think green: do you really need to print this e-mail?</span></strong>=
</P>
<P><span style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Arial'">Diese E-Mail enth=
=C3=A4lt vertrauliche und/oder rechtlich<br>gesch=C3=BCtzte Informationen. =
Wenn Sie nicht der richtige<br>Adressat sind oder diese E-Mail irrt=C3=BCml=
ich erhalten <br>haben, informieren Sie bitte den Absender und l=C3=B6schen=
<br>Sie diese Mail. Das unerlaubte Kopieren sowie die<br>unbefugte Weiterga=
be dieser E-Mail und der<br>darin enthaltenen Informationen sind nicht gest=
attet.</span></P>
<P><span style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Arial'">This e-mail may co=
ntain confidential and/or privileged<br>information. If you are not the int=
ended recipient<br>(or have received this e-mail in error) please notify th=
e <br>sender immediately and delete this e-mail. Any<br>unauthorized copyin=
g, disclosure or distribution of<br>the material in this e-mail is strictly=
 forbidden.</span></P>
<TABLE style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Arial'">
<TBODY>
<TR>
<TD colSpan=3D2>Vanderlande Industries GmbH</TD></TR>
<TR>
<TD>Sitz der Gesellschaft: </TD>
<TD>Dortmund, Deutschland</TD></TR>
<TR>
<TD>Amtsgericht Dortmund: </TD>
<TD>HRB 8539</TD></TR>
<TR>
<TD>Gesch=C3=A4ftsf=C3=BChrer: </TD>
<TD>Peter Stuer</TD></TR></TBODY></TABLE>
--===============0749760688==--

--===============1707002425==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1707002425==--
