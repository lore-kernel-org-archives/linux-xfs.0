Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3AF4B7CA4
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 13:46:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B0B5BAC002
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 11:46:37 -0700 (PDT)
Received: from mail-yw0-f172.google.com (mail-yw0-f172.google.com
	[209.85.161.172]) by cuda.sgi.com with ESMTP id
	E2i8OAJY35KYp395 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 May 2016 11:46:35 -0700 (PDT)
Received: by mail-yw0-f172.google.com with SMTP id o16so61996334ywd.2
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 11:46:35 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 May 2016 11:46:34 -0700
Message-ID: <CAHV_CwYrTg8H9BZ60shH4PFYW4FMY7nc6dx49+7N6O15PfvuFw@mail.gmail.com>
Subject: centos7 xfs able to mount, but unable to write,
	unable to perform repair
From: Morgan Yang <morgan.yang1982@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8682377446920324845=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8682377446920324845==
Content-Type: multipart/alternative; boundary=94eb2c0546b4100f81053386dc13

--94eb2c0546b4100f81053386dc13
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I am running CentOS 7.1. I have a 1TB drive that is formatted as XFS.

After a year of continuous use, I can no longer write to it

sudo touch /capture/a.a

touch: cannot touch =E2=80=98/capture/a.a=E2=80=99: No space left on device


However, there's plenty of room on the drive


sudo fdisk -l /dev/sdb

WARNING: fdisk GPT support is currently new, and therefore in an
experimental phase. Use at your own discretion.


Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes, 1953525168 sectors

Units =3D sectors of 1 * 512 =3D 512 bytes

Sector size (logical/physical): 512 bytes / 512 bytes

I/O size (minimum/optimal): 512 bytes / 512 bytes


I see the following on dmesg

[336198.224298] XFS (sdb): metadata I/O error: block 0x3a3836e2
("xfs_trans_read_buf_map") error 117 numblks 1

[336198.224479] XFS (sdb): Metadata corruption detected at
xfs_agi_read_verify+0x5e/0x110 [xfs], block 0x57545252

[336198.224483] XFS (sdb): Unmount and run xfs_repair

[336198.224486] XFS (sdb): First 64 bytes of corrupted metadata buffer:

[336198.224489] ffff880404f30400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00  ................

[336198.224491] ffff880404f30410: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00  ................

[336198.224494] ffff880404f30420: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00  ................

[336198.224496] ffff880404f30430: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00  ................

[336198.224554] XFS (sdb): metadata I/O error: block 0x57545252
("xfs_trans_read_buf_map") error 117 numblks 1

[337680.482764] xfs_db[25323]: segfault at 7ffe0aeceff8 ip 0000000000424085
sp 00007ffe0aecf000 error 6 in xfs_db[400000+81000]


When I try to run "xfs_repair", it can't seem to find secondary superblock


sudo xfs_repair -v /dev/sdb

Phase 1 - find and verify superblock...

couldn't verify primary superblock - not enough secondary superblocks with
matching geometry !!!



attempting to find secondary superblock...

...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
................................Sorry,
could not find valid secondary superblock

Exiting now.


Does anyone have any recommendations on how I can recover this?


Much Thanks

Morgan Yang

--94eb2c0546b4100f81053386dc13
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p style=3D"margin:0px 0px 1em;padding:0px;border:0px;font=
-size:15px;clear:both;color:rgb(36,39,41);font-family:Arial,&#39;Helvetica =
Neue&#39;,Helvetica,sans-serif;line-height:19.5px">I am running CentOS 7.1.=
 I have a 1TB drive that is formatted as XFS.</p><p style=3D"margin:0px 0px=
 1em;padding:0px;border:0px;font-size:15px;clear:both;color:rgb(36,39,41);f=
ont-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;line-height:=
19.5px">After a year of continuous use, I can no longer write to it</p><p s=
tyle=3D"margin:0px 0px 1em;padding:0px;border:0px;font-size:15px;clear:both=
;color:rgb(36,39,41);font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,s=
ans-serif;line-height:19.5px">sudo touch /capture/a.a<br></p><p style=3D"ma=
rgin:0px 0px 1em;padding:0px;border:0px;clear:both"><font color=3D"#242729"=
 face=3D"Arial, Helvetica Neue, Helvetica, sans-serif"><span style=3D"font-=
size:15px;line-height:19.5px">touch: cannot touch =E2=80=98/capture/a.a=E2=
=80=99: No space left on device</span></font></p><p style=3D"margin:0px 0px=
 1em;padding:0px;border:0px;clear:both"><span style=3D"color:rgb(36,39,41);=
font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:1=
5px;line-height:19.5px"><br></span></p><p style=3D"margin:0px 0px 1em;paddi=
ng:0px;border:0px;clear:both"><span style=3D"color:rgb(36,39,41);font-famil=
y:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:15px;line-h=
eight:19.5px">However, there&#39;s plenty of room on the drive</span><font =
color=3D"#242729" face=3D"Arial, Helvetica Neue, Helvetica, sans-serif"><sp=
an style=3D"font-size:15px;line-height:19.5px"><br></span></font></p><p sty=
le=3D"margin:0px 0px 1em;padding:0px;border:0px;clear:both"><font color=3D"=
#242729" face=3D"Arial, Helvetica Neue, Helvetica, sans-serif"><span style=
=3D"font-size:15px;line-height:19.5px"><br></span></font></p><p style=3D"ma=
rgin:0px 0px 1em;padding:0px;border:0px;clear:both"><font color=3D"#242729"=
 face=3D"Arial, Helvetica Neue, Helvetica, sans-serif"><span style=3D"font-=
size:15px;line-height:19.5px">sudo fdisk -l /dev/sdb</span></font></p><p st=
yle=3D"margin:0px 0px 1em;padding:0px;border:0px;clear:both"><span style=3D=
"font-size:15px;line-height:19.5px;color:rgb(36,39,41);font-family:Arial,&#=
39;Helvetica Neue&#39;,Helvetica,sans-serif">WARNING: fdisk GPT support is =
currently new, and therefore in an experimental phase. Use at your own disc=
retion.</span><br></p><p style=3D"margin:0px 0px 1em;padding:0px;border:0px=
;clear:both"><font color=3D"#242729" face=3D"Arial, Helvetica Neue, Helveti=
ca, sans-serif"><span style=3D"font-size:15px;line-height:19.5px"><br></spa=
n></font></p><p style=3D"margin:0px 0px 1em;padding:0px;border:0px;clear:bo=
th"><font color=3D"#242729" face=3D"Arial, Helvetica Neue, Helvetica, sans-=
serif"><span style=3D"font-size:15px;line-height:19.5px">Disk /dev/sdb: 100=
0.2 GB, 1000204886016 bytes, 1953525168 sectors</span></font></p><p style=
=3D"margin:0px 0px 1em;padding:0px;border:0px;clear:both"><font color=3D"#2=
42729" face=3D"Arial, Helvetica Neue, Helvetica, sans-serif"><span style=3D=
"font-size:15px;line-height:19.5px">Units =3D sectors of 1 * 512 =3D 512 by=
tes</span></font></p><p style=3D"margin:0px 0px 1em;padding:0px;border:0px;=
clear:both"><font color=3D"#242729" face=3D"Arial, Helvetica Neue, Helvetic=
a, sans-serif"><span style=3D"font-size:15px;line-height:19.5px">Sector siz=
e (logical/physical): 512 bytes / 512 bytes</span></font></p><p style=3D"ma=
rgin:0px 0px 1em;padding:0px;border:0px;clear:both"></p><p style=3D"margin:=
0px 0px 1em;padding:0px;border:0px;clear:both"><font color=3D"#242729" face=
=3D"Arial, Helvetica Neue, Helvetica, sans-serif"><span style=3D"font-size:=
15px;line-height:19.5px">I/O size (minimum/optimal): 512 bytes / 512 bytes<=
/span></font></p><p style=3D"margin:0px 0px 1em;padding:0px;border:0px;clea=
r:both"><br></p><p style=3D"margin:0px 0px 1em;padding:0px;border:0px;clear=
:both">I see the following on dmesg</p><p style=3D"margin:0px 0px 1em;paddi=
ng:0px;border:0px;clear:both">[336198.224298] XFS (sdb): metadata I/O error=
: block 0x3a3836e2 (&quot;xfs_trans_read_buf_map&quot;) error 117 numblks 1=
</p><p style=3D"margin:0px 0px 1em;padding:0px;border:0px;clear:both">[3361=
98.224479] XFS (sdb): Metadata corruption detected at xfs_agi_read_verify+0=
x5e/0x110 [xfs], block 0x57545252</p><p style=3D"margin:0px 0px 1em;padding=
:0px;border:0px;clear:both">[336198.224483] XFS (sdb): Unmount and run xfs_=
repair</p><p style=3D"margin:0px 0px 1em;padding:0px;border:0px;clear:both"=
>[336198.224486] XFS (sdb): First 64 bytes of corrupted metadata buffer:</p=
><p style=3D"margin:0px 0px 1em;padding:0px;border:0px;clear:both">[336198.=
224489] ffff880404f30400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
=C2=A0................</p><p style=3D"margin:0px 0px 1em;padding:0px;border=
:0px;clear:both">[336198.224491] ffff880404f30410: 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 =C2=A0................</p><p style=3D"margin:0px 0p=
x 1em;padding:0px;border:0px;clear:both">[336198.224494] ffff880404f30420: =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =C2=A0................</p><=
p style=3D"margin:0px 0px 1em;padding:0px;border:0px;clear:both">[336198.22=
4496] ffff880404f30430: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =C2=
=A0................</p><p style=3D"margin:0px 0px 1em;padding:0px;border:0p=
x;clear:both">[336198.224554] XFS (sdb): metadata I/O error: block 0x575452=
52 (&quot;xfs_trans_read_buf_map&quot;) error 117 numblks 1</p><p style=3D"=
margin:0px 0px 1em;padding:0px;border:0px;clear:both">[337680.482764] xfs_d=
b[25323]: segfault at 7ffe0aeceff8 ip 0000000000424085 sp 00007ffe0aecf000 =
error 6 in xfs_db[400000+81000]</p><p style=3D"margin:0px 0px 1em;padding:0=
px;border:0px;clear:both"><br></p><p style=3D"margin:0px 0px 1em;padding:0p=
x;border:0px;clear:both">When I try to run &quot;xfs_repair&quot;, it can&#=
39;t seem to find secondary superblock</p><p style=3D"margin:0px 0px 1em;pa=
dding:0px;border:0px;clear:both"><br></p><p style=3D"margin:0in;font-family=
:Calibri;font-size:11pt">sudo xfs_repair -v
/dev/sdb</p><p style=3D"margin:0in;font-family:Calibri;font-size:11pt">Phas=
e 1 - find and
verify superblock...</p><p style=3D"margin:0in;font-family:Calibri;font-siz=
e:11pt">couldn&#39;t verify
primary superblock - not enough secondary superblocks with matching geometr=
y
!!!</p><p style=3D"margin:0in;font-family:Calibri;font-size:11pt">=C2=A0</p=
><p style=3D"margin:0in;font-family:Calibri;font-size:11pt">attempting to f=
ind
secondary superblock...</p><p style=3D"margin:0in;font-family:Calibri;font-=
size:11pt">................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................Sorry,
could not find valid secondary superblock</p><p style=3D"margin:0px 0px 1em=
;padding:0px;border:0px;clear:both">











</p><p style=3D"margin:0in;font-family:Calibri;font-size:11pt">Exiting now.=
</p><p style=3D"margin:0in;font-family:Calibri;font-size:11pt"><br></p><p s=
tyle=3D"margin:0in;font-family:Calibri;font-size:11pt">Does anyone have any=
 recommendations on how I can recover this?=C2=A0</p><p style=3D"margin:0in=
;font-family:Calibri;font-size:11pt"><br></p><p style=3D"margin:0in;font-fa=
mily:Calibri;font-size:11pt">Much Thanks</p><p style=3D"margin:0in;font-fam=
ily:Calibri;font-size:11pt">Morgan Yang</p><p style=3D"margin:0px 0px 1em;p=
adding:0px;border:0px;clear:both"><br></p><p style=3D"margin:0px 0px 1em;pa=
dding:0px;border:0px;clear:both"><br></p></div>

--94eb2c0546b4100f81053386dc13--


--===============8682377446920324845==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8682377446920324845==--
