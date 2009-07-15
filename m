Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6F81TnS180960 for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 03:01:30 -0500
Received: from sj-iport-4.cisco.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D470A637F0
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 01:09:41 -0700 (PDT)
Received: from sj-iport-4.cisco.com (sj-iport-4.cisco.com [171.68.10.86]) by
	cuda.sgi.com with ESMTP id nHbi54COpRrjn6JH for
	<xfs@oss.sgi.com>; Wed, 15 Jul 2009 01:09:41 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: How to simulate journal corruption
Date: Wed, 15 Jul 2009 04:02:01 -0400
Message-ID: <249A89BAA060C94FA0B93EA6135CC93C084463AD@xmb-rtp-20b.amer.cisco.com>
In-Reply-To: <SNT109-W27FBC11B3A147486A10FAAEC200@phx.gbl>
References: <SNT109-W2390816D3EF297CE0D07DEEC220@phx.gbl>
	<4A5B4833.9070300@sandeen.net>
	<SNT109-W27FBC11B3A147486A10FAAEC200@phx.gbl>
From: "Wentao Lv (wentalv)" <wentalv@cisco.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1858605411757753505=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: sandeen@sandeen.net
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============1858605411757753505==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CA0522.8ACA320C"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CA0522.8ACA320C
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi, Eric

=20

Could you tell me where I could find XFS-QA test cases?=20

=20

Thanks & Regards.

Lv Wentao.

=20

From: crow al [mailto:al-john@hotmail.com]=20
Sent: Wednesday, July 15, 2009 3:51 PM
To: Wentao Lv (wentalv)
Subject: FW: How to simulate journal corruption

=20



> Date: Mon, 13 Jul 2009 09:44:03 -0500
> From: sandeen@sandeen.net
> To: al-john@hotmail.com
> CC: xfs@oss.sgi.com
> Subject: Re: How to simulate journal corruption
>=20
> crow al wrote:
> > Hi, there
> >=20
> > I'm a QA engineer from Cisco. I'm working on a test case concerning
XFS
> > journal playback failure, which needs to manually inject error to
XFS.
> >=20
> > I did some google work but get no luck. Then I think maybe XFA-QA
could
> > give me some advice. That why I come to here.
> >=20
> > Is there anyone could tell me how to inject error into XFS or is
there
> > any tool could be used?
> >=20
> > Wish for your response.
> >=20
> > Thanks & Regards.
> > Lv Wentao.
>=20
> test 044 in xfstests runs something called "loggen" which will
generate
> log traffic to be replayed on mount, if I'm reading it right. Of
course
> that's an uncorrupted log ...
>=20
> There is another tool called "fsfuzzer" which writes random junk over
a
> filesystem. You could probably combine the two tools to create valid
> logs to replay, and then write varying degrees of junk on top with
> fsfuzzer, and try to replay the result.
>=20
> You could probably even use fsfuzzer "stock" and just restrict the
> fuzzing to the log portion of the filesystem.
>=20
> I'm not sure what kinds of errors you are trying to catch - oopses,
> hangs, improperly replaying a corrupted log, etc - but it sounds well
> worth doing. FWIW when I used fsfuzzer, it often ran into problems in
> the log, so I imagine you'll uncover some interesting things; if you
do,
> please share. :)
>=20
> -Eric

________________________________

What can you do with the new Windows Live? Find out
<http://www.microsoft.com/windows/windowslive/default.aspx>=20


------_=_NextPart_001_01CA0522.8ACA320C
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" =
xmlns:p=3D"urn:schemas-microsoft-com:office:powerpoint" =
xmlns:a=3D"urn:schemas-microsoft-com:office:access" =
xmlns:dt=3D"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" =
xmlns:s=3D"uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882" =
xmlns:rs=3D"urn:schemas-microsoft-com:rowset" xmlns:z=3D"#RowsetSchema" =
xmlns:b=3D"urn:schemas-microsoft-com:office:publisher" =
xmlns:ss=3D"urn:schemas-microsoft-com:office:spreadsheet" =
xmlns:c=3D"urn:schemas-microsoft-com:office:component:spreadsheet" =
xmlns:odc=3D"urn:schemas-microsoft-com:office:odc" =
xmlns:oa=3D"urn:schemas-microsoft-com:office:activation" =
xmlns:html=3D"http://www.w3.org/TR/REC-html40" =
xmlns:q=3D"http://schemas.xmlsoap.org/soap/envelope/" =
xmlns:rtc=3D"http://microsoft.com/officenet/conferencing" =
xmlns:D=3D"DAV:" xmlns:Repl=3D"http://schemas.microsoft.com/repl/" =
xmlns:mt=3D"http://schemas.microsoft.com/sharepoint/soap/meetings/" =
xmlns:x2=3D"http://schemas.microsoft.com/office/excel/2003/xml" =
xmlns:ppda=3D"http://www.passport.com/NameSpace.xsd" =
xmlns:ois=3D"http://schemas.microsoft.com/sharepoint/soap/ois/" =
xmlns:dir=3D"http://schemas.microsoft.com/sharepoint/soap/directory/" =
xmlns:ds=3D"http://www.w3.org/2000/09/xmldsig#" =
xmlns:dsp=3D"http://schemas.microsoft.com/sharepoint/dsp" =
xmlns:udc=3D"http://schemas.microsoft.com/data/udc" =
xmlns:xsd=3D"http://www.w3.org/2001/XMLSchema" =
xmlns:sub=3D"http://schemas.microsoft.com/sharepoint/soap/2002/1/alerts/"=
 xmlns:ec=3D"http://www.w3.org/2001/04/xmlenc#" =
xmlns:sp=3D"http://schemas.microsoft.com/sharepoint/" =
xmlns:sps=3D"http://schemas.microsoft.com/sharepoint/soap/" =
xmlns:xsi=3D"http://www.w3.org/2001/XMLSchema-instance" =
xmlns:udcs=3D"http://schemas.microsoft.com/data/udc/soap" =
xmlns:udcxf=3D"http://schemas.microsoft.com/data/udc/xmlfile" =
xmlns:udcp2p=3D"http://schemas.microsoft.com/data/udc/parttopart" =
xmlns:wf=3D"http://schemas.microsoft.com/sharepoint/soap/workflow/" =
xmlns:dsss=3D"http://schemas.microsoft.com/office/2006/digsig-setup" =
xmlns:dssi=3D"http://schemas.microsoft.com/office/2006/digsig" =
xmlns:mdssi=3D"http://schemas.openxmlformats.org/package/2006/digital-sig=
nature" =
xmlns:mver=3D"http://schemas.openxmlformats.org/markup-compatibility/2006=
" xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns:mrels=3D"http://schemas.openxmlformats.org/package/2006/relationshi=
ps" xmlns:spwp=3D"http://microsoft.com/sharepoint/webpartpages" =
xmlns:ex12t=3D"http://schemas.microsoft.com/exchange/services/2006/types"=
 =
xmlns:ex12m=3D"http://schemas.microsoft.com/exchange/services/2006/messag=
es" =
xmlns:pptsl=3D"http://schemas.microsoft.com/sharepoint/soap/SlideLibrary/=
" =
xmlns:spsl=3D"http://microsoft.com/webservices/SharePointPortalServer/Pub=
lishedLinksService" xmlns:Z=3D"urn:schemas-microsoft-com:" =
xmlns:st=3D"&#1;" xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<!--[if !mso]>
<style>
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:Verdana;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
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
p
	{mso-style-priority:99;
	mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman","serif";}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
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

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>Hi, Eric<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>Could you tell me where I could find XFS-QA test cases? =
<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>Thanks &amp; Regards.<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'>Lv Wentao.<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";
color:#1F497D'><o:p>&nbsp;</o:p></span></p>

<div>

<div style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt =
0in 0in 0in'>

<p class=3DMsoNormal><b><span =
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'>From:</span>=
</b><span
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'> crow al
[mailto:al-john@hotmail.com] <br>
<b>Sent:</b> Wednesday, July 15, 2009 3:51 PM<br>
<b>To:</b> Wentao Lv (wentalv)<br>
<b>Subject:</b> FW: How to simulate journal =
corruption<o:p></o:p></span></p>

</div>

</div>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal style=3D'margin-bottom:12.0pt'><span =
style=3D'font-size:10.0pt;
font-family:"Verdana","sans-serif"'><br>
<br>
&gt; Date: Mon, 13 Jul 2009 09:44:03 -0500<br>
&gt; From: sandeen@sandeen.net<br>
&gt; To: al-john@hotmail.com<br>
&gt; CC: xfs@oss.sgi.com<br>
&gt; Subject: Re: How to simulate journal corruption<br>
&gt; <br>
&gt; crow al wrote:<br>
&gt; &gt; Hi, there<br>
&gt; &gt; <br>
&gt; &gt; I'm a QA engineer from Cisco. I'm working on a test case =
concerning
XFS<br>
&gt; &gt; journal playback failure, which needs to manually inject error =
to
XFS.<br>
&gt; &gt; <br>
&gt; &gt; I did some google work but get no luck. Then I think maybe =
XFA-QA
could<br>
&gt; &gt; give me some advice. That why I come to here.<br>
&gt; &gt; <br>
&gt; &gt; Is there anyone could tell me how to inject error into XFS or =
is
there<br>
&gt; &gt; any tool could be used?<br>
&gt; &gt; <br>
&gt; &gt; Wish for your response.<br>
&gt; &gt; <br>
&gt; &gt; Thanks &amp; Regards.<br>
&gt; &gt; Lv Wentao.<br>
&gt; <br>
&gt; test 044 in xfstests runs something called &quot;loggen&quot; which =
will
generate<br>
&gt; log traffic to be replayed on mount, if I'm reading it right. Of =
course<br>
&gt; that's an uncorrupted log ...<br>
&gt; <br>
&gt; There is another tool called &quot;fsfuzzer&quot; which writes =
random junk
over a<br>
&gt; filesystem. You could probably combine the two tools to create =
valid<br>
&gt; logs to replay, and then write varying degrees of junk on top =
with<br>
&gt; fsfuzzer, and try to replay the result.<br>
&gt; <br>
&gt; You could probably even use fsfuzzer &quot;stock&quot; and just =
restrict
the<br>
&gt; fuzzing to the log portion of the filesystem.<br>
&gt; <br>
&gt; I'm not sure what kinds of errors you are trying to catch - =
oopses,<br>
&gt; hangs, improperly replaying a corrupted log, etc - but it sounds =
well<br>
&gt; worth doing. FWIW when I used fsfuzzer, it often ran into problems =
in<br>
&gt; the log, so I imagine you'll uncover some interesting things; if =
you do,<br>
&gt; please share. :)<br>
&gt; <br>
&gt; -Eric<o:p></o:p></span></p>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><span
style=3D'font-size:10.0pt;font-family:"Verdana","sans-serif"'>

<hr size=3D2 width=3D"100%" align=3Dcenter>

</span></div>

<p class=3DMsoNormal><span =
style=3D'font-size:10.0pt;font-family:"Verdana","sans-serif"'>What
can you do with the new Windows Live? <a
href=3D"http://www.microsoft.com/windows/windowslive/default.aspx" =
target=3D"_new">Find
out</a><o:p></o:p></span></p>

</div>

</body>

</html>

------_=_NextPart_001_01CA0522.8ACA320C--


--===============1858605411757753505==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1858605411757753505==--
