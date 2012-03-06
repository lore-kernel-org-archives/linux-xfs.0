Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q26HCRij177447 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 11:12:28 -0600
Received: from gws05.hcl.com (gws05.hcl.com [203.105.185.23]) by cuda.sgi.com
	with ESMTP id tgydzVC8T2445N3t (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 09:12:24 -0800 (PST)
From: Anshul Kundra <anshul.kundra@hcl.com>
Date: Tue, 6 Mar 2012 22:41:57 +0530
Subject: getbmap!!!!!!!
Message-ID: <CACBF2D716C5104BAC48A16827DE5B150A220515A6@NDA-HCLT-EVS04.HCLT.CORP.HCL.IN>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5349379865797626073=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5349379865797626073==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_CACBF2D716C5104BAC48A16827DE5B150A220515A6NDAHCLTEVS04H_"

--_000_CACBF2D716C5104BAC48A16827DE5B150A220515A6NDAHCLTEVS04H_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

To Developers ,

Please provide me some description regarding the xfs_getbmap what it suppos=
e to do , suppose I want to create a fiule and write on it I got the inode =
of file then what fields I will send to the xfs getbmap (called via xfs_ioc=
_getbmapx ) ,

-          What fields of getbmapx structure will be initialized  before pa=
ssing in the xfs_ioc_getbmapx ?

-          What it will do after passing the fields (Function overview if p=
ossible)

-          Why the arg+1 is being passed in the xfs_ioc_getbmapx
I know the reason of formatter

Xfs_ioc_getbmapx(arguments)
{

        Xfs_getbmap();
        Copy_to_user() ; // why the copying done here as in the function it=
self for every entry it is copying the information into user buffer then wh=
y outside the function call here it needs the copy again
}

Thanks & Best Regards
Anshul Kundra

________________________________
::DISCLAIMER::
---------------------------------------------------------------------------=
--------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and inte=
nded for the named recipient(s) only.
It shall not attach any liability on the originator or HCL or its affiliate=
s. Any views or opinions presented in
this email are solely those of the author and may not necessarily reflect t=
he opinions of HCL or its affiliates.
Any form of reproduction, dissemination, copying, disclosure, modification,=
 distribution and / or publication of
this message without the prior written consent of the author of this e-mail=
 is strictly prohibited. If you have
received this email in error please delete it and notify the sender immedia=
tely. Before opening any mail and
attachments please check them for viruses and defect.

---------------------------------------------------------------------------=
--------------------------------------------

--_000_CACBF2D716C5104BAC48A16827DE5B150A220515A6NDAHCLTEVS04H_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 12 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
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
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:1417020852;
	mso-list-type:hybrid;
	mso-list-template-ids:-159372058 -798058242 67698691 67698693 67698689 676=
98691 67698693 67698689 67698691 67698693;}
@list l0:level1
	{mso-level-start-at:0;
	mso-level-number-format:bullet;
	mso-level-text:-;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Calibri","sans-serif";
	mso-fareast-font-family:Calibri;
	mso-bidi-font-family:"Times New Roman";}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">To Developers ,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Please provide me some description regarding the xfs=
_getbmap what it suppose to do , suppose I want to create a fiule and write=
 on it I got the inode of file then what fields I will send to the xfs getb=
map (called via xfs_ioc_getbmapx )
 , <o:p></o:p></p>
<p class=3D"MsoListParagraph" style=3D"text-indent:-.25in;mso-list:l0 level=
1 lfo1"><![if !supportLists]><span style=3D"mso-list:Ignore">-<span style=
=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;
</span></span><![endif]>What fields of getbmapx structure will be initializ=
ed &nbsp;before passing in the xfs_ioc_getbmapx ?<o:p></o:p></p>
<p class=3D"MsoListParagraph" style=3D"text-indent:-.25in;mso-list:l0 level=
1 lfo1"><![if !supportLists]><span style=3D"mso-list:Ignore">-<span style=
=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;
</span></span><![endif]>What it will do after passing the fields (Function =
overview if possible)<o:p></o:p></p>
<p class=3D"MsoListParagraph" style=3D"text-indent:-.25in;mso-list:l0 level=
1 lfo1"><![if !supportLists]><span style=3D"mso-list:Ignore">-<span style=
=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;
</span></span><![endif]>Why the arg&#43;1 is being passed in the xfs_ioc_ge=
tbmapx <o:p>
</o:p></p>
<p class=3D"MsoNormal" style=3D"margin-left:.25in">I know the reason of for=
matter <o:p>
</o:p></p>
<p class=3D"MsoNormal" style=3D"margin-left:.25in"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"margin-left:.25in">Xfs_ioc_getbmapx(argumen=
ts)<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"margin-left:.25in">{<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"margin-left:.25in"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"margin-left:.25in">&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; Xfs_getbmap();<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"margin-left:.25in">&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; Copy_to_user() ; // why the copying done here as in the =
function itself for every entry it is copying the information into user buf=
fer then why outside the function call here it needs the copy again
<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"margin-left:.25in">}<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"margin-left:.25in"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks &amp; Best Regards <o:p></o:p></p>
<p class=3D"MsoNormal">Anshul Kundra <o:p></o:p></p>
</div>
<br>
<hr>
<font face=3D"Arial" color=3D"Gray" size=3D"1">::DISCLAIMER::<br>
---------------------------------------------------------------------------=
--------------------------------------------<br>
<br>
The contents of this e-mail and any attachment(s) are confidential and inte=
nded for the named recipient(s) only.<br>
It shall not attach any liability on the originator or HCL or its affiliate=
s. Any views or opinions presented in<br>
this email are solely those of the author and may not necessarily reflect t=
he opinions of HCL or its affiliates.<br>
Any form of reproduction, dissemination, copying, disclosure, modification,=
 distribution and / or publication of<br>
this message without the prior written consent of the author of this e-mail=
 is strictly prohibited. If you have<br>
received this email in error please delete it and notify the sender immedia=
tely. Before opening any mail and<br>
attachments please check them for viruses and defect.<br>
<br>
---------------------------------------------------------------------------=
--------------------------------------------<br>
</font>
</body>
</html>

--_000_CACBF2D716C5104BAC48A16827DE5B150A220515A6NDAHCLTEVS04H_--


--===============5349379865797626073==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5349379865797626073==--
