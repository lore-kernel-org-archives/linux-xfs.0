Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C1B8C7F80
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 18:24:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 92AD58F804C
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 16:24:01 -0800 (PST)
Received: from BLU004-OMC4S18.hotmail.com (blu004-omc4s18.hotmail.com
	[65.55.111.157]) by cuda.sgi.com with ESMTP id VvDxJgYFoszmIW8F
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2015 16:24:00 -0800 (PST)
Message-ID: <BLU436-SMTP15464F1CAAC1F46E2593ED0FB3B0@phx.gbl>
From: James Woolliscroft <j_woolliscroft@hotmail.com>
Subject: Using XFS on Raid
Date: Thu, 5 Feb 2015 00:23:53 +0000
MIME-Version: 1.0
Content-Language: en-gb
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1331360390030808382=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1331360390030808382==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_02DA_01D040DA.06DDC5F0"
Content-Language: en-gb

------=_NextPart_000_02DA_01D040DA.06DDC5F0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

 

I am new to XFS, I have spent a significant time searching for information
and have not found any documentation relating to the use of XFS over RAID
with N Drives where the Stripe Unit >256K.

 

To be clear, using (for example) 3 Disks with RAID 5 with a Stripe Unit of
1MB and Stripe Width of 2 would give 2MB Data and 1M Parity.

 

I have found through extensive testing of RAW RAID volumes with various
chunk sizes that larger chunks tend to produce the best performance in most
cases whether Sequential, Random, Read or Write, or in combinations. I am
keen therefor to perform similar tests with XFS to determine the best
performance and would like to test the widest range of larger chunks/Stripe
Units possible, including those larger than XFS apparently permits. I am
aware that XFS performance will not necessarily mirror that of performance
tests of RAW RAID volumes but this needs to be verified by testing.

 

It appears that XFS on RHEL7 and clones is limited to a maximum Stripe Unit
of 256KB.

 

Since it is not possible to specify the correct parameters (SU=1024K, SW=2),
Is it possible and valid to specify an adjusted value where SU is reduced
and SW is increased by the same factor.

 

So using SU=256K, SW=8 would be the same as SU=1024K, SW=2 and give a total
of 2MB Data.

 

Is this valid? Are there any performance or other consequences of using
different dimensions? Is there any issue with using other permutations e.g.
SU=32K, SW=64?

 

While I understand that XFS is intended to select optimum defaults, I am
concerned and less than enthusiastic about the default settings particularly
with larger RAID chunks.

 

I also would like to find some information on how to correctly interpret the
statistics output when formatting a volume with XFS, particularly as the
process may use other settings which may require further investigation?

 

If you cannot answer these questions directly, can you point me to a
resource where I might find this information?

 

Regards

 

JW


------=_NextPart_000_02DA_01D040DA.06DDC5F0
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta =
http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 14 =
(filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	mso-fareast-language:EN-US;}
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
	font-family:"Calibri","sans-serif";
	mso-fareast-language:EN-US;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-GB link=3Dblue =
vlink=3Dpurple><div class=3DWordSection1><p =
class=3DMsoNormal>Hi,<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>I am new to =
XFS, I have spent a significant time searching for information and have =
not found any documentation relating to the use of XFS over RAID with N =
Drives where the Stripe Unit &gt;256K.<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>To be clear, =
using (for example) 3 Disks with RAID 5 with a Stripe Unit of 1MB and =
Stripe Width of 2 would give 2MB Data and 1M Parity.<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>I have found =
through extensive testing of RAW RAID volumes with various chunk sizes =
that larger chunks tend to produce the best performance in most cases =
whether Sequential, Random, Read or Write, or in combinations. I am keen =
therefor to perform similar tests with XFS to determine the best =
performance and would like to test the widest range of larger =
chunks/Stripe Units possible, including those larger than XFS apparently =
permits. I am aware that XFS performance will not necessarily mirror =
that of performance tests of RAW RAID volumes but this needs to be =
verified by testing.<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>It appears =
that XFS on RHEL7 and clones is limited to a maximum Stripe Unit of =
256KB.<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>Since it is not possible to specify the correct =
parameters (SU=3D1024K, SW=3D2), Is it possible and valid to specify an =
adjusted value where SU is reduced and SW is increased by the same =
factor.<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>So using SU=3D256K, SW=3D8 would be the same as =
SU=3D1024K, SW=3D2 and give a total of 2MB Data.<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Is this =
valid? Are there any performance or other consequences of using =
different dimensions? Is there any issue with using other permutations =
e.g. SU=3D32K, SW=3D64?<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>While I =
understand that XFS is intended to select optimum defaults, I am =
concerned and less than enthusiastic about the default settings =
particularly with larger RAID chunks.<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>I also would =
like to find some information on how to correctly interpret the =
statistics output when formatting a volume with XFS, particularly as the =
process may use other settings which may require further =
investigation?<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>If you =
cannot answer these questions directly, can you point me to a resource =
where I might find this information?<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>Regards<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>JW<o:p></o:p></p></div></body></html>
------=_NextPart_000_02DA_01D040DA.06DDC5F0--


--===============1331360390030808382==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1331360390030808382==--
