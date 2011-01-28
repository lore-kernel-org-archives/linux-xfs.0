Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S239g0075603 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 20:03:10 -0600
Received: from mail1.ad.kinetx.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C662297489
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 18:05:34 -0800 (PST)
Received: from mail1.ad.kinetx.com (mail1.ad.kinetx.com [74.202.133.147]) by
	cuda.sgi.com with ESMTP id 2bsCLg4n3MsphmEL for
	<xfs@oss.sgi.com>; Thu, 27 Jan 2011 18:05:34 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: XFS Preallocation
Date: Thu, 27 Jan 2011 19:05:33 -0700
Message-ID: <155CAEA5D902E7429569DD197567724A01534D42@mail1.ad.kinetx.com>
From: "Jef Fox" <jef.fox@kinetx.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3067735271007890970=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============3067735271007890970==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CBBE8F.D89A50EA"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CBBE8F.D89A50EA
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

We are having some problems with preallocation of large files.  We have
found that we can preallocate about 500 1GB files on a volume using the
resvsp and truncate commands, but the extents are still showing up as
preallocated.  Is this a problem?  The OS appears to think the files are
allocated and correctly sized.=20

=20

For reference, we are trying to create files for an external piece of
equipment to write to a SSD with.  The SSD would then be mounted in RHEL
and the data pulled off in the 1G chunks.  Because of the nature of the
data, we need to constantly erase and recreate the files and
preallocation seems to be the fastest option.  We don't really care if
the data gets 0'ed out.  Is there another method - allocsp takes too
long for this application?  Or, does it matter if XFS thinks the extents
are preallocated but unwritten if no other files are written to the
disk?

=20

Thanks

Jef

=20

=20


------_=_NextPart_001_01CBBE8F.D89A50EA
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta =
http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 12 =
(filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
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
	{mso-style-type:export-only;}
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
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue =
vlink=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal>We are =
having some problems with preallocation of large files.&nbsp; We have =
found that we can preallocate about 500 1GB files on a volume using the =
resvsp and truncate commands, but the extents are still showing up as =
preallocated.&nbsp; Is this a problem?&nbsp; The OS appears to think the =
files are allocated and correctly sized. <o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>For =
reference, we are trying to create files for an external piece of =
equipment to write to a SSD with.&nbsp; The SSD would then be mounted in =
RHEL and the data pulled off in the 1G chunks.&nbsp; Because of the =
nature of the data, we need to constantly erase and recreate the files =
and preallocation seems to be the fastest option.&nbsp; We don&#8217;t =
really care if the data gets 0&#8217;ed out.&nbsp; Is there another =
method &#8211; allocsp takes too long for this application?&nbsp; Or, =
does it matter if XFS thinks the extents are preallocated but unwritten =
if no other files are written to the disk?<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>Thanks<o:p></o:p></p><p =
class=3DMsoNormal>Jef<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p></div></body></html>
------_=_NextPart_001_01CBBE8F.D89A50EA--


--===============3067735271007890970==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3067735271007890970==--
