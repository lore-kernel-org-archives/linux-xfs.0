Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 117927CA3
	for <xfs@oss.sgi.com>; Sat,  2 Jul 2016 03:52:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B82EA304039
	for <xfs@oss.sgi.com>; Sat,  2 Jul 2016 01:52:50 -0700 (PDT)
Received: from mail-vk0-f52.google.com (mail-vk0-f52.google.com
	[209.85.213.52]) by cuda.sgi.com with ESMTP id FL2Z4AX5Q3XXQ2mH
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Jul 2016 01:52:42 -0700 (PDT)
Received: by mail-vk0-f52.google.com with SMTP id m127so120811235vkb.3
	for <xfs@oss.sgi.com>; Sat, 02 Jul 2016 01:52:42 -0700 (PDT)
MIME-Version: 1.0
From: Nick Fisk <friskyfisk10@googlemail.com>
Date: Sat, 2 Jul 2016 09:52:40 +0100
Message-ID: <CAC5UwBi8Skjx90_XC5Z5B8P+CadawBZ3iUabKtm-2ZvrkgocZQ@mail.gmail.com>
Subject: High Fragmentation with XFS and NFS Sync
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0041416797174361698=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0041416797174361698==
Content-Type: multipart/alternative; boundary=94eb2c149e94d27fee0536a339e6

--94eb2c149e94d27fee0536a339e6
Content-Type: text/plain; charset=UTF-8

Hi, hope someone can help me here.

I'm exporting some XFS fs's to ESX via NFS with the sync option enabled. I'm
seeing really heavy fragmentation when multiple VM's are copied onto the
share at the same time. I'm also seeing kmem_alloc failures, which is
probably the biggest problem as this effectively takes everything down.

Underlying storage is a Ceph RBD, the server the FS is running on, is
running kernel 4.5.7. Mount options are currently default. I'm seeing
Millions of extents, where the ideal is listed as a couple of thousand when
running xfs_db, there is only a couple of 100 files on the FS. It looks
like roughly the extent sizes roughly match the IO size that the VM's were
written to XFS with. So it looks like each parallel IO thread is being
allocated next to each other rather than at spaced out regions of the disk.

>From what I understand, this is because each NFS write opens and closes the
file which throws off any chance that XFS will be able to use its allocation
features to stop parallel write streams from interleaving with each other.

Is there anything I can tune to try and give each write to each file a
little bit of space, so that it at least gives readahead a chance when
reading, that it might hit at least a few MB of sequential data?

I have read that inode32 allocates more randomly compared to inode64, so I'm
not sure if it's worth trying this as there will likely be less than a 1000
files per FS.

Or am I best just to run fsr after everything has been copied on?

Thanks for any advice
Nick

--94eb2c149e94d27fee0536a339e6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"color:rgb(0,0,0);font-family:monospace;font=
-size:15px;font-style:normal;font-variant:normal;font-weight:normal;letter-=
spacing:normal;line-height:normal;text-align:start;text-indent:0px;text-tra=
nsform:none;white-space:normal;word-spacing:0px;background-color:rgb(255,25=
5,255);display:inline!important;float:none">Hi, hope someone can help me he=
re.</span><br style=3D"color:rgb(0,0,0);font-family:monospace;font-size:15p=
x;font-style:normal;font-variant:normal;font-weight:normal;letter-spacing:n=
ormal;line-height:normal;text-align:start;text-indent:0px;text-transform:no=
ne;white-space:normal;word-spacing:0px"><br style=3D"color:rgb(0,0,0);font-=
family:monospace;font-size:15px;font-style:normal;font-variant:normal;font-=
weight:normal;letter-spacing:normal;line-height:normal;text-align:start;tex=
t-indent:0px;text-transform:none;white-space:normal;word-spacing:0px"><span=
 style=3D"color:rgb(0,0,0);font-family:monospace;font-size:15px;font-style:=
normal;font-variant:normal;font-weight:normal;letter-spacing:normal;line-he=
ight:normal;text-align:start;text-indent:0px;text-transform:none;white-spac=
e:normal;word-spacing:0px;background-color:rgb(255,255,255);display:inline!=
important;float:none">I&#39;m exporting some XFS fs&#39;s to ESX via NFS wi=
th the sync option enabled. I&#39;m</span><br style=3D"color:rgb(0,0,0);fon=
t-family:monospace;font-size:15px;font-style:normal;font-variant:normal;fon=
t-weight:normal;letter-spacing:normal;line-height:normal;text-align:start;t=
ext-indent:0px;text-transform:none;white-space:normal;word-spacing:0px"><sp=
an style=3D"color:rgb(0,0,0);font-family:monospace;font-size:15px;font-styl=
e:normal;font-variant:normal;font-weight:normal;letter-spacing:normal;line-=
height:normal;text-align:start;text-indent:0px;text-transform:none;white-sp=
ace:normal;word-spacing:0px;background-color:rgb(255,255,255);display:inlin=
e!important;float:none">seeing really heavy fragmentation when multiple VM&=
#39;s are copied onto the</span><br style=3D"color:rgb(0,0,0);font-family:m=
onospace;font-size:15px;font-style:normal;font-variant:normal;font-weight:n=
ormal;letter-spacing:normal;line-height:normal;text-align:start;text-indent=
:0px;text-transform:none;white-space:normal;word-spacing:0px"><span style=
=3D"color:rgb(0,0,0);font-family:monospace;font-size:15px;font-style:normal=
;font-variant:normal;font-weight:normal;letter-spacing:normal;line-height:n=
ormal;text-align:start;text-indent:0px;text-transform:none;white-space:norm=
al;word-spacing:0px;background-color:rgb(255,255,255);display:inline!import=
ant;float:none">share at the same time. I&#39;m also seeing kmem_alloc fail=
ures, which is probably the biggest problem as this effectively takes every=
thing down. <br><br>Underlying storage is a Ceph RBD, the server the FS is =
running on, is running kernel 4.5.7. Mount options are currently default. I=
&#39;m seeing Millions of extents, where the ideal is listed as a couple of=
 thousand when running xfs_db, there is only a couple of 100 files on the F=
S. It looks like roughly the extent sizes roughly match the IO size that th=
e VM&#39;s were written to XFS with. So it looks like each parallel IO thre=
ad is being allocated next to each other rather than at spaced out regions =
of the disk.</span><br style=3D"color:rgb(0,0,0);font-family:monospace;font=
-size:15px;font-style:normal;font-variant:normal;font-weight:normal;letter-=
spacing:normal;line-height:normal;text-align:start;text-indent:0px;text-tra=
nsform:none;white-space:normal;word-spacing:0px"><br style=3D"color:rgb(0,0=
,0);font-family:monospace;font-size:15px;font-style:normal;font-variant:nor=
mal;font-weight:normal;letter-spacing:normal;line-height:normal;text-align:=
start;text-indent:0px;text-transform:none;white-space:normal;word-spacing:0=
px"><span style=3D"color:rgb(0,0,0);font-family:monospace;font-size:15px;fo=
nt-style:normal;font-variant:normal;font-weight:normal;letter-spacing:norma=
l;line-height:normal;text-align:start;text-indent:0px;text-transform:none;w=
hite-space:normal;word-spacing:0px;background-color:rgb(255,255,255);displa=
y:inline!important;float:none">From what I understand, this is because each=
 NFS write opens and closes the</span><br style=3D"color:rgb(0,0,0);font-fa=
mily:monospace;font-size:15px;font-style:normal;font-variant:normal;font-we=
ight:normal;letter-spacing:normal;line-height:normal;text-align:start;text-=
indent:0px;text-transform:none;white-space:normal;word-spacing:0px"><span s=
tyle=3D"color:rgb(0,0,0);font-family:monospace;font-size:15px;font-style:no=
rmal;font-variant:normal;font-weight:normal;letter-spacing:normal;line-heig=
ht:normal;text-align:start;text-indent:0px;text-transform:none;white-space:=
normal;word-spacing:0px;background-color:rgb(255,255,255);display:inline!im=
portant;float:none">file which throws off any chance that XFS will be able =
to use its allocation</span><br style=3D"color:rgb(0,0,0);font-family:monos=
pace;font-size:15px;font-style:normal;font-variant:normal;font-weight:norma=
l;letter-spacing:normal;line-height:normal;text-align:start;text-indent:0px=
;text-transform:none;white-space:normal;word-spacing:0px"><span style=3D"co=
lor:rgb(0,0,0);font-family:monospace;font-size:15px;font-style:normal;font-=
variant:normal;font-weight:normal;letter-spacing:normal;line-height:normal;=
text-align:start;text-indent:0px;text-transform:none;white-space:normal;wor=
d-spacing:0px;background-color:rgb(255,255,255);display:inline!important;fl=
oat:none">features to stop parallel write streams from interleaving with ea=
ch other.</span><br style=3D"color:rgb(0,0,0);font-family:monospace;font-si=
ze:15px;font-style:normal;font-variant:normal;font-weight:normal;letter-spa=
cing:normal;line-height:normal;text-align:start;text-indent:0px;text-transf=
orm:none;white-space:normal;word-spacing:0px"><br style=3D"color:rgb(0,0,0)=
;font-family:monospace;font-size:15px;font-style:normal;font-variant:normal=
;font-weight:normal;letter-spacing:normal;line-height:normal;text-align:sta=
rt;text-indent:0px;text-transform:none;white-space:normal;word-spacing:0px"=
><span style=3D"color:rgb(0,0,0);font-family:monospace;font-size:15px;font-=
style:normal;font-variant:normal;font-weight:normal;letter-spacing:normal;l=
ine-height:normal;text-align:start;text-indent:0px;text-transform:none;whit=
e-space:normal;word-spacing:0px;background-color:rgb(255,255,255);display:i=
nline!important;float:none">Is there anything I can tune to try and give ea=
ch write to each file a</span><br style=3D"color:rgb(0,0,0);font-family:mon=
ospace;font-size:15px;font-style:normal;font-variant:normal;font-weight:nor=
mal;letter-spacing:normal;line-height:normal;text-align:start;text-indent:0=
px;text-transform:none;white-space:normal;word-spacing:0px"><span style=3D"=
color:rgb(0,0,0);font-family:monospace;font-size:15px;font-style:normal;fon=
t-variant:normal;font-weight:normal;letter-spacing:normal;line-height:norma=
l;text-align:start;text-indent:0px;text-transform:none;white-space:normal;w=
ord-spacing:0px;background-color:rgb(255,255,255);display:inline!important;=
float:none">little bit of space, so that it at least gives readahead a chan=
ce when</span><br style=3D"color:rgb(0,0,0);font-family:monospace;font-size=
:15px;font-style:normal;font-variant:normal;font-weight:normal;letter-spaci=
ng:normal;line-height:normal;text-align:start;text-indent:0px;text-transfor=
m:none;white-space:normal;word-spacing:0px"><span style=3D"color:rgb(0,0,0)=
;font-family:monospace;font-size:15px;font-style:normal;font-variant:normal=
;font-weight:normal;letter-spacing:normal;line-height:normal;text-align:sta=
rt;text-indent:0px;text-transform:none;white-space:normal;word-spacing:0px;=
background-color:rgb(255,255,255);display:inline!important;float:none">read=
ing, that it might hit at least a few MB of sequential data?</span><br styl=
e=3D"color:rgb(0,0,0);font-family:monospace;font-size:15px;font-style:norma=
l;font-variant:normal;font-weight:normal;letter-spacing:normal;line-height:=
normal;text-align:start;text-indent:0px;text-transform:none;white-space:nor=
mal;word-spacing:0px"><br style=3D"color:rgb(0,0,0);font-family:monospace;f=
ont-size:15px;font-style:normal;font-variant:normal;font-weight:normal;lett=
er-spacing:normal;line-height:normal;text-align:start;text-indent:0px;text-=
transform:none;white-space:normal;word-spacing:0px"><span style=3D"color:rg=
b(0,0,0);font-family:monospace;font-size:15px;font-style:normal;font-varian=
t:normal;font-weight:normal;letter-spacing:normal;line-height:normal;text-a=
lign:start;text-indent:0px;text-transform:none;white-space:normal;word-spac=
ing:0px;background-color:rgb(255,255,255);display:inline!important;float:no=
ne">I have read that inode32 allocates more randomly compared to inode64, s=
o I&#39;m</span><br style=3D"color:rgb(0,0,0);font-family:monospace;font-si=
ze:15px;font-style:normal;font-variant:normal;font-weight:normal;letter-spa=
cing:normal;line-height:normal;text-align:start;text-indent:0px;text-transf=
orm:none;white-space:normal;word-spacing:0px"><span style=3D"color:rgb(0,0,=
0);font-family:monospace;font-size:15px;font-style:normal;font-variant:norm=
al;font-weight:normal;letter-spacing:normal;line-height:normal;text-align:s=
tart;text-indent:0px;text-transform:none;white-space:normal;word-spacing:0p=
x;background-color:rgb(255,255,255);display:inline!important;float:none">no=
t sure if it&#39;s worth trying this as there will likely be less than a 10=
00</span><br style=3D"color:rgb(0,0,0);font-family:monospace;font-size:15px=
;font-style:normal;font-variant:normal;font-weight:normal;letter-spacing:no=
rmal;line-height:normal;text-align:start;text-indent:0px;text-transform:non=
e;white-space:normal;word-spacing:0px"><span style=3D"color:rgb(0,0,0);font=
-family:monospace;font-size:15px;font-style:normal;font-variant:normal;font=
-weight:normal;letter-spacing:normal;line-height:normal;text-align:start;te=
xt-indent:0px;text-transform:none;white-space:normal;word-spacing:0px;backg=
round-color:rgb(255,255,255);display:inline!important;float:none">files per=
 FS.</span><br style=3D"color:rgb(0,0,0);font-family:monospace;font-size:15=
px;font-style:normal;font-variant:normal;font-weight:normal;letter-spacing:=
normal;line-height:normal;text-align:start;text-indent:0px;text-transform:n=
one;white-space:normal;word-spacing:0px"><br style=3D"color:rgb(0,0,0);font=
-family:monospace;font-size:15px;font-style:normal;font-variant:normal;font=
-weight:normal;letter-spacing:normal;line-height:normal;text-align:start;te=
xt-indent:0px;text-transform:none;white-space:normal;word-spacing:0px"><spa=
n style=3D"color:rgb(0,0,0);font-family:monospace;font-size:15px;font-style=
:normal;font-variant:normal;font-weight:normal;letter-spacing:normal;line-h=
eight:normal;text-align:start;text-indent:0px;text-transform:none;white-spa=
ce:normal;word-spacing:0px;background-color:rgb(255,255,255);display:inline=
!important;float:none">Or am I best just to run fsr after everything has be=
en copied on?</span><br style=3D"color:rgb(0,0,0);font-family:monospace;fon=
t-size:15px;font-style:normal;font-variant:normal;font-weight:normal;letter=
-spacing:normal;line-height:normal;text-align:start;text-indent:0px;text-tr=
ansform:none;white-space:normal;word-spacing:0px"><br style=3D"color:rgb(0,=
0,0);font-family:monospace;font-size:15px;font-style:normal;font-variant:no=
rmal;font-weight:normal;letter-spacing:normal;line-height:normal;text-align=
:start;text-indent:0px;text-transform:none;white-space:normal;word-spacing:=
0px"><span style=3D"color:rgb(0,0,0);font-family:monospace;font-size:15px;f=
ont-style:normal;font-variant:normal;font-weight:normal;letter-spacing:norm=
al;line-height:normal;text-align:start;text-indent:0px;text-transform:none;=
white-space:normal;word-spacing:0px;background-color:rgb(255,255,255);displ=
ay:inline!important;float:none">Thanks for any advice</span><br style=3D"co=
lor:rgb(0,0,0);font-family:monospace;font-size:15px;font-style:normal;font-=
variant:normal;font-weight:normal;letter-spacing:normal;line-height:normal;=
text-align:start;text-indent:0px;text-transform:none;white-space:normal;wor=
d-spacing:0px"><span style=3D"color:rgb(0,0,0);font-family:monospace;font-s=
ize:15px;font-style:normal;font-variant:normal;font-weight:normal;letter-sp=
acing:normal;line-height:normal;text-align:start;text-indent:0px;text-trans=
form:none;white-space:normal;word-spacing:0px;background-color:rgb(255,255,=
255);display:inline!important;float:none">Nick</span></div>

--94eb2c149e94d27fee0536a339e6--


--===============0041416797174361698==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0041416797174361698==--
