Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5OKlrPT103167 for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 15:47:53 -0500
Received: from erebus.totalmanaged.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B5581495A4B
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 13:56:48 -0700 (PDT)
Received: from erebus.totalmanaged.com (mx01.totalmanaged.com
	[208.83.104.194]) by cuda.sgi.com with ESMTP id
	jQrliGDnTnIOWhbt for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2009 13:56:48 -0700 (PDT)
From: Michael Moody <michael@gsc.cc>
Date: Wed, 24 Jun 2009 13:48:16 -0700
Subject: mkfs.xfs created filesystem larger than underlying device
Message-ID: <98D6DBD179F61A46AF5C064829A832A0185042D261@erebus.totalmanaged.com>
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
Content-Type: multipart/mixed; boundary="===============6896770194648055465=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6896770194648055465==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_98D6DBD179F61A46AF5C064829A832A0185042D261erebustotalma_"

--_000_98D6DBD179F61A46AF5C064829A832A0185042D261erebustotalma_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello all.

I recently created an XFS filesystem on an x86_64 CentOS 5.3 system. I used=
 all tools in the repository:

Xfsprogs-2.9.4-1
Kernel 2.6.18-128.1.10.el5.centos.plus

It is a somewhat complex configuration of:

Areca RAID card with 16 1.5TB drives in a RAID 6 with 1 hotspare (100GB vol=
ume was created for the OS, the rest was one large volume of ~19TB)
I used pvcreate /dev/sdb to create a physical volume for LVM on the 19TB vo=
lume.
I then used vgcreate to create a volume group of 17.64TB
I used lvcreate to create 5 logical volumes, 4x4TB, and 1x1.5TB
On top of those logical volumes is drbd (/dev/drbd0-/dev/drbd4)
On top of the drbd volumes, I created a volume group of 17.50TB (/dev/drbd0=
-/dev/drbd4)
I created a logical volume of 17.49TB, upon which was created an xfs filesy=
stem with no options (mkfs.xfs mkfs.xfs /dev/Volume1-Rep-Store/Volume1-Repl=
icated -L Replicated)

The resulting filesystem is larger than the underlying logical volume:

--- Logical volume ---
  LV Name                /dev/Volume1-Rep-Store/Volume1-Replicated
  VG Name                Volume1-Rep-Store
  LV UUID                fB0q3f-80Kq-yFuy-NjKl-pmlW-jeiX-uEruWC
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                17.49 TB
  Current LE             4584899
  Segments               5
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:5

/dev/mapper/Volume1--Rep--Store-Volume1--Replicated
                       18T  411M   18T   1% /mnt/Volume1

Why is this, and how can I fix it?

Thanks,
Michael

--_000_98D6DBD179F61A46AF5C064829A832A0185042D261erebustotalma_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" xmlns:p=3D"urn:schemas-m=
icrosoft-com:office:powerpoint" xmlns:a=3D"urn:schemas-microsoft-com:office=
:access" xmlns:dt=3D"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:s=3D"=
uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882" xmlns:rs=3D"urn:schemas-microsof=
t-com:rowset" xmlns:z=3D"#RowsetSchema" xmlns:b=3D"urn:schemas-microsoft-co=
m:office:publisher" xmlns:ss=3D"urn:schemas-microsoft-com:office:spreadshee=
t" xmlns:c=3D"urn:schemas-microsoft-com:office:component:spreadsheet" xmlns=
:odc=3D"urn:schemas-microsoft-com:office:odc" xmlns:oa=3D"urn:schemas-micro=
soft-com:office:activation" xmlns:html=3D"http://www.w3.org/TR/REC-html40" =
xmlns:q=3D"http://schemas.xmlsoap.org/soap/envelope/" xmlns:D=3D"DAV:" xmln=
s:mt=3D"http://schemas.microsoft.com/sharepoint/soap/meetings/" xmlns:x2=3D=
"http://schemas.microsoft.com/office/excel/2003/xml" xmlns:ois=3D"http://sc=
hemas.microsoft.com/sharepoint/soap/ois/" xmlns:dir=3D"http://schemas.micro=
soft.com/sharepoint/soap/directory/" xmlns:ds=3D"http://www.w3.org/2000/09/=
xmldsig#" xmlns:dsp=3D"http://schemas.microsoft.com/sharepoint/dsp" xmlns:u=
dc=3D"http://schemas.microsoft.com/data/udc" xmlns:xsd=3D"http://www.w3.org=
/2001/XMLSchema" xmlns:sub=3D"http://schemas.microsoft.com/sharepoint/soap/=
2002/1/alerts/" xmlns:ec=3D"http://www.w3.org/2001/04/xmlenc#" xmlns:sp=3D"=
http://schemas.microsoft.com/sharepoint/" xmlns:sps=3D"http://schemas.micro=
soft.com/sharepoint/soap/" xmlns:xsi=3D"http://www.w3.org/2001/XMLSchema-in=
stance" xmlns:udcs=3D"http://schemas.microsoft.com/data/udc/soap" xmlns:udc=
xf=3D"http://schemas.microsoft.com/data/udc/xmlfile" xmlns:udcp2p=3D"http:/=
/schemas.microsoft.com/data/udc/parttopart" xmlns:wf=3D"http://schemas.micr=
osoft.com/sharepoint/soap/workflow/" xmlns:dsss=3D"http://schemas.microsoft=
.com/office/2006/digsig-setup" xmlns:dssi=3D"http://schemas.microsoft.com/o=
ffice/2006/digsig" xmlns:mdssi=3D"http://schemas.openxmlformats.org/package=
/2006/digital-signature" xmlns:mver=3D"http://schemas.openxmlformats.org/ma=
rkup-compatibility/2006" xmlns:m=3D"http://schemas.microsoft.com/office/200=
4/12/omml" xmlns:mrels=3D"http://schemas.openxmlformats.org/package/2006/re=
lationships" xmlns:spwp=3D"http://microsoft.com/sharepoint/webpartpages" xm=
lns:ex12t=3D"http://schemas.microsoft.com/exchange/services/2006/types" xml=
ns:ex12m=3D"http://schemas.microsoft.com/exchange/services/2006/messages" x=
mlns:pptsl=3D"http://schemas.microsoft.com/sharepoint/soap/SlideLibrary/" x=
mlns:spsl=3D"http://microsoft.com/webservices/SharePointPortalServer/Publis=
hedLinksService" xmlns:Z=3D"urn:schemas-microsoft-com:" xmlns:st=3D"&#1;" x=
mlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
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
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
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

<p class=3DMsoNormal>Hello all.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>I recently created an XFS filesystem on an x86_64 Cent=
OS 5.3
system. I used all tools in the repository:<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Xfsprogs-2.9.4-1<o:p></o:p></p>

<p class=3DMsoNormal>Kernel 2.6.18-128.1.10.el5.centos.plus<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>It is a somewhat complex configuration of:<o:p></o:p><=
/p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Areca RAID card with 16 1.5TB drives in a RAID 6 with =
1
hotspare (100GB volume was created for the OS, the rest was one large volum=
e of
~19TB)<o:p></o:p></p>

<p class=3DMsoNormal>I used pvcreate /dev/sdb to create a physical volume f=
or LVM
on the 19TB volume.<o:p></o:p></p>

<p class=3DMsoNormal>I then used vgcreate to create a volume group of 17.64=
TB<o:p></o:p></p>

<p class=3DMsoNormal>I used lvcreate to create 5 logical volumes, 4x4TB, an=
d
1x1.5TB<o:p></o:p></p>

<p class=3DMsoNormal>On top of those logical volumes is drbd (/dev/drbd0-/d=
ev/drbd4)<o:p></o:p></p>

<p class=3DMsoNormal>On top of the drbd volumes, I created a volume group o=
f
17.50TB (/dev/drbd0-/dev/drbd4)<o:p></o:p></p>

<p class=3DMsoNormal>I created a logical volume of 17.49TB, upon which was
created an xfs filesystem with no options (mkfs.xfs mkfs.xfs
/dev/Volume1-Rep-Store/Volume1-Replicated -L Replicated)<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>The resulting filesystem is larger than the underlying
logical volume:<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>--- Logical volume ---<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; LV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
/dev/Volume1-Rep-Store/Volume1-Replicated<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; VG Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Volume1-Rep-Store<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp; LV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fB0q3f-80Kq-yFuy-NjKl-pm=
lW-jeiX-uEruWC<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; LV Write Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; read/write<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; LV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; available<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; # open&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; LV Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17.49 TB<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; Current LE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4584899<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; Segments&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; Allocation&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inherit<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; Read ahead sectors&nbsp;&nbsp;&nbsp;&nbsp; auto=
<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; - currently set to&nbsp;&nbsp;&nbsp;&nbsp; 256<=
o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; Block device&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; 253:5<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>/dev/mapper/Volume1--Rep--Store-Volume1--Replicated<o:=
p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; 18T&nbsp; 411M&nbsp;&nbsp; 18T&nbsp;&nbsp; 1% /mnt/Volume1<o:p></o:p></=
p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Why is this, and how can I fix it?<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Thanks,<o:p></o:p></p>

<p class=3DMsoNormal>Michael<o:p></o:p></p>

</div>

</body>

</html>

--_000_98D6DBD179F61A46AF5C064829A832A0185042D261erebustotalma_--


--===============6896770194648055465==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6896770194648055465==--
