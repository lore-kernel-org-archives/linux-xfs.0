Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 18AE17F51
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 11:11:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ECFFF8F8064
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 09:11:25 -0800 (PST)
Received: from gws06.hcl.com (gws06.hcl.com [203.105.185.25]) by cuda.sgi.com
	with ESMTP id iVNX04T3HDcEkD4R (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Feb 2013 09:11:22 -0800 (PST)
From: Anshul Kundra <anshul.kundra@hcl.com>
Subject: XFS_DB
Date: Wed, 20 Feb 2013 17:11:18 +0000
Message-ID: <4DF92F995A2E4C48ABADDA7F8E05A63D09BE1935@NDA-HCLT-MBS02.hclt.corp.hcl.in>
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
Content-Type: multipart/mixed; boundary="===============2152681038814342476=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2152681038814342476==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_4DF92F995A2E4C48ABADDA7F8E05A63D09BE1935NDAHCLTMBS02hcl_"

--_000_4DF92F995A2E4C48ABADDA7F8E05A63D09BE1935NDAHCLTMBS02hcl_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Developers,

I have system with configuration as
RAM : 4G
SWAP: 2G

On  this system I had created an XFS file system of size 250 GB, I am using=
 xfs_db utility to  get file mapping( file name and inode number ) informat=
ion using the daddr & corresponding  File system block number.

/dev/sdd1 : 250G filesystem, 13% (29 G) full, aprox 3.5 million files

Steps executed in getting this information is as below :

test#  xfs_db -i -c "convert daddr 6612146 fsb" /dev/sdd1
0xc9c96 (826518)
test:~ #  xfs_db -i -c "blockget -n -b 826518" /dev/sdd1
xfs_db: out of memory

Utility (xfs_db ) is giving OOM in extracting  block information using "blo=
ckget" and in some cases it gives OOM when subcommand "ncheck"of xfs_db.  I=
t is mentioned in the manuals itself that ncheck is memory consuming comman=
d. When we analysed the command memory map of ncheck using "pmap"  most of =
the memory is consumed in heap. It's not utilized by cache memory.


Whether xfs_db stores  information of all the blocks  upto the requested bl=
ock or it maintains its internal structure. When checking the xfs_db codeth=
en found function call like (push_cur()  etc ) whether it is maintaining it=
s own command execution stack.

Instead of accessing the device itself can we read the metadump file to get=
 the required information of file mapping with file system block number. It=
s binary file but is there any utility which reads the metadump file itself=
 instead of file system image. As it is easier to read the metadump file in=
stead of go towards  disk access itself. There is file obfuscation in the f=
ile name for 4 characters

Whether reading metadump file for getting file mapping with file system blo=
ck number still consumes same amount of memory or this will not works.

Please provide some reference to either eliminate the OOM (in blockget and =
ncheck) or any other way either related to accessing metadump file in getti=
ng the mapping (fsbno to file name or inode number ). As currently finding =
out the cause of this memory consumption from the source itself whether opt=
imization in finding this mapping information  is possible or not

On finding out solution over the OOM I found reference of xfs_db 64  but th=
ere is no 64 bit version of utility available in xfs website either there w=
ill be some configuration option or it becomes obsolete.



Thanks & Best Regards
Anshul Kundra




::DISCLAIMER::
---------------------------------------------------------------------------=
-------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and inte=
nded for the named recipient(s) only.
E-mail transmission is not guaranteed to be secure or error-free as informa=
tion could be intercepted, corrupted,
lost, destroyed, arrive late or incomplete, or may contain viruses in trans=
mission. The e mail and its contents
(with or without referred errors) shall therefore not attach any liability =
on the originator or HCL or its affiliates.
Views or opinions, if any, presented in this email are solely those of the =
author and may not necessarily reflect the
views or opinions of HCL or its affiliates. Any form of reproduction, disse=
mination, copying, disclosure, modification,
distribution and / or publication of this message without the prior written=
 consent of authorized representative of
HCL is strictly prohibited. If you have received this email in error please=
 delete it and notify the sender immediately.
Before opening any email and/or attachments, please check them for viruses =
and other defects.

---------------------------------------------------------------------------=
-------------------------------------------------------------------------

--_000_4DF92F995A2E4C48ABADDA7F8E05A63D09BE1935NDAHCLTMBS02hcl_
Content-Type: text/html; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii">
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
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
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Developers,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I have system with configuration as <o:p></o:p></p>
<p class=3D"MsoNormal">RAM : 4G<o:p></o:p></p>
<p class=3D"MsoNormal">SWAP: 2G<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">On &nbsp;this system I had created an XFS file syste=
m of size 250 GB, I am using xfs_db utility to &nbsp;get file mapping( file=
 name and inode number ) information using the daddr &amp; corresponding &n=
bsp;File system block number. &nbsp;<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">/dev/sdd1 : 250G filesystem, 13% (29 G) full, aprox =
3.5 million files<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Steps executed in getting this information is as bel=
ow :<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">test# &nbsp;xfs_db -i -c &quot;convert daddr 6612146=
 fsb&quot; /dev/sdd1<o:p></o:p></p>
<p class=3D"MsoNormal">0xc9c96 (826518)<o:p></o:p></p>
<p class=3D"MsoNormal">test:~ # &nbsp;xfs_db -i -c &quot;blockget -n -b 826=
518&quot; /dev/sdd1<o:p></o:p></p>
<p class=3D"MsoNormal">xfs_db: out of memory<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Utility (xfs_db ) is giving OOM in extracting &nbsp;=
block information using &#8220;blockget&#8221; and in some cases it gives O=
OM when subcommand &#8220;ncheck&#8221;of xfs_db.&nbsp; It is mentioned in =
the manuals itself that ncheck is memory consuming command. When we
 analysed the command memory map of ncheck using &#8220;pmap&#8221; &nbsp;m=
ost of the memory is consumed in heap. It&#8217;s not utilized by cache mem=
ory.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Whether xfs_db stores &nbsp;information of all the b=
locks &nbsp;upto the requested block or it maintains its internal structure=
. When checking the xfs_db codethen found function call like (push_cur() &n=
bsp;etc ) whether it is maintaining its own command
 execution stack. <o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Instead of accessing the device itself can we read t=
he metadump file to get the required information of file mapping with file =
system block number. Its binary file but is there any utility which reads t=
he metadump file itself instead of
 file system image. As it is easier to read the metadump file instead of go=
 towards&nbsp; disk access itself. There is file obfuscation in the file na=
me for 4 characters
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Whether reading metadump file for getting file mappi=
ng with file system block number still consumes same amount of memory or th=
is will not works.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Please provide some reference to either eliminate th=
e OOM (in blockget and ncheck) or any other way either related to accessing=
 metadump file in getting the mapping (fsbno to file name or inode number )=
. As currently finding out the cause
 of this memory consumption from the source itself whether optimization in =
finding this mapping information &nbsp;is possible or not &nbsp;<o:p></o:p>=
</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">On finding out solution over the OOM I found referen=
ce of xfs_db 64 &nbsp;but there is no 64 bit version of utility available i=
n xfs website either there will be some configuration option or it becomes =
obsolete.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks &amp; Best Regards <o:p></o:p></p>
<p class=3D"MsoNormal">Anshul Kundra <o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;<o:p></o:p></p>
</div>
<span style=3D"FONT-FAMILY: 'Arial','sans-serif'; COLOR: gray; FONT-SIZE: 7=
.5pt; mso-fareast-font-family: 'Times New Roman'">
<P style=3D"MARGIN: 0in 0in 0pt" class=3DMsoNormal><br><br><font style=3D"F=
ONT-FAMILY: 'Arial','sans-serif'; COLOR: gray; FONT-SIZE: 9px">::DISCLAIMER=
::<br>---------------------------------------------------------------------=
---------------------------------------------------------------------------=
----</font></P>
<P style=3D"MARGIN: 0in 0in 0pt" class=3DMsoNormal><font style=3D"FONT-FAMI=
LY: 'Arial','sans-serif'; COLOR: gray; FONT-SIZE: 11px">The contents of thi=
s e-mail and any attachment(s) are confidential and intended for the named =
recipient(s) only.<br>E-mail transmission is not guaranteed to be secure or=
 error-free as information could be intercepted, corrupted, <br>lost, destr=
oyed, arrive late or incomplete, or may contain viruses in transmission. Th=
e e mail and its contents <br>(with or without referred errors) shall there=
fore not attach any liability on the originator or HCL or its affiliates. <=
br>Views or opinions, if any, presented in this email are solely those of t=
he author and may not necessarily reflect the <br>views or opinions of HCL =
or its affiliates. Any form of reproduction, dissemination, copying, disclo=
sure, modification, <br>distribution and / or publication of this message w=
ithout the prior written consent of authorized representative of <br>HCL is=
 strictly prohibited. If you have received this email in error please delet=
e it and notify the sender immediately. <br>Before opening any email and/or=
 attachments, please check them for viruses and other defects.</font></P>
<P style=3D"MARGIN: 0in 0in 0pt" class=3DMsoNormal><font style=3D"FONT-FAMI=
LY: 'Arial','sans-serif'; COLOR: gray; FONT-SIZE: 11px">-------------------=
---------------------------------------------------------------------------=
------------------------------------------------------</font></span></P></b=
ody>
</html>

--_000_4DF92F995A2E4C48ABADDA7F8E05A63D09BE1935NDAHCLTMBS02hcl_--


--===============2152681038814342476==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2152681038814342476==--
