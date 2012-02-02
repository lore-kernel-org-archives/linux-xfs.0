Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q128JCDr039649 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 02:19:13 -0600
Received: from mexforward.lss.emc.com (mexforward.lss.emc.com [128.222.32.20])
	by cuda.sgi.com with ESMTP id CEG1QnBge8SDxWXE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 00:19:11 -0800 (PST)
Received: from hop04-l1d11-si02.isus.emc.com (HOP04-L1D11-SI02.isus.emc.com
	[10.254.111.55])
	by mexforward.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id
	q128JA1I017530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 03:19:10 -0500
Received: from mailhub.lss.emc.com (mailhub.lss.emc.com [10.254.221.251]) by
	hop04-l1d11-si02.isus.emc.com (RSA Interceptor) for
	<xfs@oss.sgi.com>; Thu, 2 Feb 2012 03:18:58 -0500
Received: from mxhub11.corp.emc.com (mxhub11.corp.emc.com [10.254.92.106])
	by mailhub.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id
	q128IucX005379 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 03:18:57 -0500
From: <Kiran.Chandapu@emc.com>
Date: Thu, 2 Feb 2012 03:19:01 -0500
Subject: xfs_repair takes long time
Message-ID: <D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A02@MX03A.corp.emc.com>
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
Content-Type: multipart/mixed; boundary="===============4480466044887757730=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4480466044887757730==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A02MX03Acorpemcc_"

--_000_D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A02MX03Acorpemcc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi

My set up looks like this, we have software raid on top of it we have LVM a=
nd using XFS file system. Currently we have faced on an issue with raid /de=
v/md1 so we have activated it and when we checked we had missed PV informat=
ion, so we had to restore the metadata information from Volume group and th=
at was successful. Later we had activated VG and LV, now when I try to moun=
t the volume using xfs, I am unable to and when I check the system logs I s=
ee below logs:

Feb  2 12:21:08 DDATA kernel: XFS: bad magic number
Feb  2 12:21:08 DDATA kernel: XFS: SB validate failed

So I have realized that the file system might have corrupted and started ru=
nning xfs_repair but it takes such a long time, not sure it is because of t=
he amount of data we have on the volume around 12TB.
First time it took 3 days, incomplete and unfortunately the session got ter=
minated. Now again I have to run the repair.

Could anyone please let me know, is there any way I can speed up the proces=
s or any rough idea who much time the file system repair going to take.

Any help is really appreciated.

Thanks
-Kiran


--_000_D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A02MX03Acorpemcc_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40"><head><meta http-equiv=3DContent-Type content=
=3D"text/html; charset=3Dus-ascii"><meta name=3DGenerator content=3D"Micros=
oft Word 14 (filtered medium)"><style><!--
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
	color:#1F497D;}
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
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue vli=
nk=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal><span style=3D'c=
olor:#1F497D'>Hi <o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'=
color:#1F497D'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=
=3D'color:#1F497D'>My set up looks like this, we have software raid on top =
of it we have LVM and using XFS file system. Currently we have faced on an =
issue with raid /dev/md1 so we have activated it and when we checked we had=
 missed PV information, so we had to restore the metadata information from =
Volume group and that was successful. Later we had activated VG and LV, now=
 when I try to mount the volume using xfs, I am unable to and when I check =
the system logs I see below logs:<o:p></o:p></span></p><p class=3DMsoNormal=
><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNo=
rmal><span style=3D'color:#1F497D'>Feb&nbsp; 2 12:21:08 DDATA kernel: XFS: =
bad magic number<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'c=
olor:#1F497D'>Feb&nbsp; 2 12:21:08 DDATA kernel: XFS: SB validate failed<o:=
p></o:p></span></p><p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>=
&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=3D'color:#1F497D'>S=
o I have realized that the file system might have corrupted and started run=
ning xfs_repair but it takes such a long time, not sure it is because of th=
e amount of data we have on the volume around 12TB.<o:p></o:p></span></p><p=
 class=3DMsoNormal><span style=3D'color:#1F497D'>First time it took 3 days,=
 incomplete and unfortunately the session got terminated. Now again I have =
to run the repair. <o:p></o:p></span></p><p class=3DMsoNormal><span style=
=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span s=
tyle=3D'color:#1F497D'>Could anyone please let me know, is there any way I =
can speed up the process or any rough idea who much time the file system re=
pair going to take. <o:p></o:p></span></p><p class=3DMsoNormal><span style=
=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span s=
tyle=3D'color:#1F497D'>Any help is really appreciated. <o:p></o:p></span></=
p><p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></spa=
n></p><p class=3DMsoNormal><span style=3D'color:#1F497D'>Thanks<o:p></o:p><=
/span></p><p class=3DMsoNormal><span style=3D'color:#1F497D'>-Kiran<o:p></o=
:p></span></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p></div></body></html=
>=

--_000_D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A02MX03Acorpemcc_--


--===============4480466044887757730==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4480466044887757730==--
