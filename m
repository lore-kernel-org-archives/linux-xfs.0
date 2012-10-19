Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9JEYM57261443 for <xfs@oss.sgi.com>; Fri, 19 Oct 2012 09:34:22 -0500
Received: from gws06.hcl.com (gws06.hcl.com [203.105.185.25]) by cuda.sgi.com
	with ESMTP id uotQwhJwOTeZdWnV (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Oct 2012 07:35:59 -0700 (PDT)
From: Anshul Kundra <anshul.kundra@hcl.com>
Date: Fri, 19 Oct 2012 20:05:46 +0530
Subject: xfs_behaviour
Message-ID: <CACBF2D716C5104BAC48A16827DE5B151358720B18@NDA-HCLT-EVS04.HCLT.CORP.HCL.IN>
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
Content-Type: multipart/mixed; boundary="===============2125919978285628755=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2125919978285628755==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_CACBF2D716C5104BAC48A16827DE5B151358720B18NDAHCLTEVS04H_"

--_000_CACBF2D716C5104BAC48A16827DE5B151358720B18NDAHCLTEVS04H_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable


To Developers,

I have seen a different behaviour in XFS

Suppose I have a file with inode number "131", I have noticed that the inod=
e number of file got changed without deleting the file. When we change the =
data of the file everytime it changes the inode number. The complete descri=
ption over the test is as follows

Steps are as follows:

1) I have created a file using "dd" of size 100MB:

#dd if=3D/dev/zero of=3Dxfs.img bs=3D1M count=3D100

2) Created a loopback device over the image:
#losetup /dev/loop1 xfs.img

3) Created file system:
#mkfs.xfs /dev/loop1

4) Mounted:
#mount /dev/loop1 /mnt/xfs_mnt

5) Please check the mount output:
# mount

/dev/sdb2 on / type ext3 (rw,acl,user_xattr)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
debugfs on /sys/kernel/debug type debugfs (rw)
devtmpfs on /dev type devtmpfs (rw,mode=3D0755)
tmpfs on /dev/shm type tmpfs (rw,mode=3D1777)
devpts on /dev/pts type devpts (rw,mode=3D0620,gid=3D5)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
/dev/loop0 on /mnt/mount_test type xfs (rw)
/dev/loop1 on /mnt/xfs_mnt type xfs (rw)

6) Created a file using "touch"

# touch kundra.txt

7) Checking the file and its inode number:

# ls -li
total 0
131 -rw-r--r-- 1 root root 0 2012-10-20 01:41 kundra.txt

8) I have written some data using the vim editor, I can't provide snapshot =
of vim on the list:

#vim kundra.txt

9) Now I checked the inode number using the "ls -li"
# ls -li

total 4
133 -rw-r--r-- 1 root root 19 2012-10-20 01:43 kundra.txt

Please check that the inode number ( from "131" to "133" )  and total value=
 (from "0" to "4" )in the filesystem got changed, I am assuming that the re=
asom may be due to filesystem of small size but it is showing unexpected be=
haviour.

Please provide some description over this issue, I am working on Linux SLES

# cat /etc/issue

Welcome to SUSE Linux Enterprise Server 11 SP1  (x86_64) - Kernel \r (\l).

# uname -a
Linux linux-sles 2.6.32.19-0.6-default #1 SMP Fri Aug 31 01:37:50 IST 2012 =
x86_64 x86_64 x86_64 GNU/Linux

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

--_000_CACBF2D716C5104BAC48A16827DE5B151358720B18NDAHCLTEVS04H_
Content-Type: text/html; charset="us-ascii"
MIME-Version: 1.0
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
xmlns:q=3D"http://schemas.xmlsoap.org/soap/envelope/" xmlns:rtc=3D"http://m=
icrosoft.com/officenet/conferencing" xmlns:D=3D"DAV:" xmlns:Repl=3D"http://=
schemas.microsoft.com/repl/" xmlns:mt=3D"http://schemas.microsoft.com/share=
point/soap/meetings/" xmlns:x2=3D"http://schemas.microsoft.com/office/excel=
/2003/xml" xmlns:ppda=3D"http://www.passport.com/NameSpace.xsd" xmlns:ois=
=3D"http://schemas.microsoft.com/sharepoint/soap/ois/" xmlns:dir=3D"http://=
schemas.microsoft.com/sharepoint/soap/directory/" xmlns:ds=3D"http://www.w3=
.org/2000/09/xmldsig#" xmlns:dsp=3D"http://schemas.microsoft.com/sharepoint=
/dsp" xmlns:udc=3D"http://schemas.microsoft.com/data/udc" xmlns:xsd=3D"http=
://www.w3.org/2001/XMLSchema" xmlns:sub=3D"http://schemas.microsoft.com/sha=
repoint/soap/2002/1/alerts/" xmlns:ec=3D"http://www.w3.org/2001/04/xmlenc#"=
 xmlns:sp=3D"http://schemas.microsoft.com/sharepoint/" xmlns:sps=3D"http://=
schemas.microsoft.com/sharepoint/soap/" xmlns:xsi=3D"http://www.w3.org/2001=
/XMLSchema-instance" xmlns:udcs=3D"http://schemas.microsoft.com/data/udc/so=
ap" xmlns:udcxf=3D"http://schemas.microsoft.com/data/udc/xmlfile" xmlns:udc=
p2p=3D"http://schemas.microsoft.com/data/udc/parttopart" xmlns:wf=3D"http:/=
/schemas.microsoft.com/sharepoint/soap/workflow/" xmlns:dsss=3D"http://sche=
mas.microsoft.com/office/2006/digsig-setup" xmlns:dssi=3D"http://schemas.mi=
crosoft.com/office/2006/digsig" xmlns:mdssi=3D"http://schemas.openxmlformat=
s.org/package/2006/digital-signature" xmlns:mver=3D"http://schemas.openxmlf=
ormats.org/markup-compatibility/2006" xmlns:m=3D"http://schemas.microsoft.c=
om/office/2004/12/omml" xmlns:mrels=3D"http://schemas.openxmlformats.org/pa=
ckage/2006/relationships" xmlns:spwp=3D"http://microsoft.com/sharepoint/web=
partpages" xmlns:ex12t=3D"http://schemas.microsoft.com/exchange/services/20=
06/types" xmlns:ex12m=3D"http://schemas.microsoft.com/exchange/services/200=
6/messages" xmlns:pptsl=3D"http://schemas.microsoft.com/sharepoint/soap/Sli=
deLibrary/" xmlns:spsl=3D"http://microsoft.com/webservices/SharePointPortal=
Server/PublishedLinksService" xmlns:Z=3D"urn:schemas-microsoft-com:" xmlns:=
st=3D"&#1;" xmlns=3D"http://www.w3.org/TR/REC-html40"><head><META HTTP-EQUI=
V=3D"Content-Type" CONTENT=3D"text/html; charset=3Dus-ascii"><meta name=3DG=
enerator content=3D"Microsoft Word 12 (filtered medium)"><style><!--
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
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue vli=
nk=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal><span style=3D'f=
ont-family:"Courier New"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal>=
<span style=3D'font-family:"Courier New"'>To Developers,<o:p></o:p></span><=
/p><p class=3DMsoNormal><span style=3D'font-family:"Courier New"'><o:p>&nbs=
p;</o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Courier=
 New"'>I have seen a different behaviour in XFS&nbsp; <o:p></o:p></span></p=
><p class=3DMsoNormal><span style=3D'font-family:"Courier New"'><o:p>&nbsp;=
</o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Courier N=
ew"'>Suppose I have a file with inode number &quot;131&quot;, I have notice=
d that the inode number of file got changed without deleting the file. When=
 we change the data of the file everytime it changes the inode number. The =
complete description over the test is as follows <o:p></o:p></span></p><p c=
lass=3DMsoNormal><span style=3D'font-family:"Courier New"'><o:p>&nbsp;</o:p=
></span></p><p class=3DMsoNormal><span style=3D'font-family:"Courier New"'>=
Steps are as follows:<o:p></o:p></span></p><p class=3DMsoNormal><span style=
=3D'font-family:"Courier New"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNo=
rmal><span style=3D'font-family:"Courier New"'>1) I have created a file usi=
ng &quot;dd&quot; of size 100MB:<o:p></o:p></span></p><p class=3DMsoNormal>=
<span style=3D'font-family:"Courier New"'><o:p>&nbsp;</o:p></span></p><p cl=
ass=3DMsoNormal><span style=3D'font-family:"Courier New"'>#dd if=3D/dev/zer=
o of=3Dxfs.img bs=3D1M count=3D100<o:p></o:p></span></p><p class=3DMsoNorma=
l><span style=3D'font-family:"Courier New"'><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span style=3D'font-family:"Courier New"'>2) Created a lo=
opback device over the image:<o:p></o:p></span></p><p class=3DMsoNormal><sp=
an style=3D'font-family:"Courier New"'>#losetup /dev/loop1 xfs.img<o:p></o:=
p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Courier New"'=
><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=3D'font-famil=
y:"Courier New"'>3) Created file system:<o:p></o:p></span></p><p class=3DMs=
oNormal><span style=3D'font-family:"Courier New"'>#mkfs.xfs /dev/loop1 <o:p=
></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=3D'font-=
family:"Courier New"'>4) Mounted:<o:p></o:p></span></p><p class=3DMsoNormal=
><span style=3D'font-family:"Courier New"'>#mount /dev/loop1 /mnt/xfs_mnt <=
o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Couri=
er New"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=3D'fo=
nt-family:"Courier New"'>5) Please check the mount output:<o:p></o:p></span=
></p><p class=3DMsoNormal><span style=3D'font-family:"Courier New"'># mount=
<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Cour=
ier New"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=3D'f=
ont-family:"Courier New"'>/dev/sdb2 on / type ext3 (rw,acl,user_xattr)<o:p>=
</o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Courier N=
ew"'>proc on /proc type proc (rw)<o:p></o:p></span></p><p class=3DMsoNormal=
><span style=3D'font-family:"Courier New"'>sysfs on /sys type sysfs (rw)<o:=
p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Courier=
 New"'>debugfs on /sys/kernel/debug type debugfs (rw)<o:p></o:p></span></p>=
<p class=3DMsoNormal><span style=3D'font-family:"Courier New"'>devtmpfs on =
/dev type devtmpfs (rw,mode=3D0755)<o:p></o:p></span></p><p class=3DMsoNorm=
al><span style=3D'font-family:"Courier New"'>tmpfs on /dev/shm type tmpfs (=
rw,mode=3D1777)<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'fo=
nt-family:"Courier New"'>devpts on /dev/pts type devpts (rw,mode=3D0620,gid=
=3D5)<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:=
"Courier New"'>fusectl on /sys/fs/fuse/connections type fusectl (rw)<o:p></=
o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Courier New=
"'>rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)<o:p></o:p></s=
pan></p><p class=3DMsoNormal><span style=3D'font-family:"Courier New"'>/dev=
/loop0 on /mnt/mount_test type xfs (rw)<o:p></o:p></span></p><p class=3DMso=
Normal><span style=3D'font-family:"Courier New"'>/dev/loop1 on /mnt/xfs_mnt=
 type xfs (rw)<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'fon=
t-family:"Courier New"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><s=
pan style=3D'font-family:"Courier New"'>6) Created a file using &quot;touch=
&quot;<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family=
:"Courier New"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span styl=
e=3D'font-family:"Courier New"'># touch kundra.txt<o:p></o:p></span></p><p =
class=3DMsoNormal><span style=3D'font-family:"Courier New"'><o:p>&nbsp;</o:=
p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Courier New"'=
>7) Checking the file and its inode number:<o:p></o:p></span></p><p class=
=3DMsoNormal><span style=3D'font-family:"Courier New"'><o:p>&nbsp;</o:p></s=
pan></p><p class=3DMsoNormal><span style=3D'font-family:"Courier New"'># ls=
 -li <o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:=
"Courier New"'>total 0<o:p></o:p></span></p><p class=3DMsoNormal><span styl=
e=3D'font-family:"Courier New"'>131 -rw-r--r-- 1 root root 0 2012-10-20 01:=
41 kundra.txt<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font=
-family:"Courier New"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><sp=
an style=3D'font-family:"Courier New"'>8) I have written some data using th=
e vim editor, I can't provide snapshot of vim on the list:<o:p></o:p></span=
></p><p class=3DMsoNormal><span style=3D'font-family:"Courier New"'><o:p>&n=
bsp;</o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Couri=
er New"'>#vim kundra.txt<o:p></o:p></span></p><p class=3DMsoNormal><span st=
yle=3D'font-family:"Courier New"'><o:p>&nbsp;</o:p></span></p><p class=3DMs=
oNormal><span style=3D'font-family:"Courier New"'>9) Now I checked the inod=
e number using the &quot;ls -li&quot;<o:p></o:p></span></p><p class=3DMsoNo=
rmal><span style=3D'font-family:"Courier New"'># ls -li<o:p></o:p></span></=
p><p class=3DMsoNormal><span style=3D'font-family:"Courier New"'><o:p>&nbsp=
;</o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Courier =
New"'>total 4<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font=
-family:"Courier New"'>133 -rw-r--r-- 1 root root 19 2012-10-20 01:43 kundr=
a.txt<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:=
"Courier New"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=
=3D'font-family:"Courier New"'>Please check that the inode number ( from &q=
uot;131&quot; to &quot;133&quot; )&nbsp; and total value (from &quot;0&quot=
; to &quot;4&quot; )in the filesystem got changed, I am assuming that the r=
easom may be due to filesystem of small size but it is showing unexpected b=
ehaviour. <o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-fa=
mily:"Courier New"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
style=3D'font-family:"Courier New"'>Please provide some description over th=
is issue, I am working on Linux SLES <o:p></o:p></span></p><p class=3DMsoNo=
rmal><span style=3D'font-family:"Courier New"'><o:p>&nbsp;</o:p></span></p>=
<p class=3DMsoNormal><span style=3D'font-family:"Courier New"'># cat /etc/i=
ssue<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:"=
Courier New"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=
=3D'font-family:"Courier New"'>Welcome to SUSE Linux Enterprise Server 11 S=
P1&nbsp; (x86_64) - Kernel \r (\l).<o:p></o:p></span></p><p class=3DMsoNorm=
al><span style=3D'font-family:"Courier New"'><o:p>&nbsp;</o:p></span></p><p=
 class=3DMsoNormal><span style=3D'font-family:"Courier New"'># uname -a <o:=
p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:"Courier=
 New"'>Linux linux-sles 2.6.32.19-0.6-default #1 SMP Fri Aug 31 01:37:50 IS=
T 2012 x86_64 x86_64 x86_64 GNU/Linux<o:p></o:p></span></p><p class=3DMsoNo=
rmal><span style=3D'font-family:"Courier New"'><o:p>&nbsp;</o:p></span></p>=
<p class=3DMsoNormal><span style=3D'font-family:"Courier New"'>Thanks &amp;=
 Best Regards&nbsp; <o:p></o:p></span></p><p class=3DMsoNormal><span style=
=3D'font-family:"Courier New"'>Anshul Kundra<o:p></o:p></span></p></div><sp=
an style=3D"FONT-FAMILY: 'Arial','sans-serif'; COLOR: gray; FONT-SIZE: 7.5p=
t; mso-fareast-font-family: 'Times New Roman'">
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
ody></html>
--_000_CACBF2D716C5104BAC48A16827DE5B151358720B18NDAHCLTEVS04H_--


--===============2125919978285628755==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2125919978285628755==--
