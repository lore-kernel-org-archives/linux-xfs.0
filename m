Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 82E307F3F
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 09:15:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 499468F804B
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 07:15:30 -0800 (PST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com
	[74.125.82.54]) by cuda.sgi.com with ESMTP id SiZt1pD9PEGkEDSB
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2016 07:15:27 -0800 (PST)
Received: by mail-wm0-f54.google.com with SMTP id b14so80000030wmb.1
	for <xfs@oss.sgi.com>; Wed, 06 Jan 2016 07:15:27 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 6 Jan 2016 10:15:25 -0500
Message-ID: <CAC2B=ZGX2bkEhdgCrpS2X5v+SpAg0jtxZ19vk_9+O9aHME-FSA@mail.gmail.com>
Subject: xfs and swift
From: Mark Seger <mjseger@gmail.com>
Content-Type: multipart/mixed; boundary=001a114b1272e039fa0528abd2ac
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>
Cc: Laurence Oberman <loberman@redhat.com>

--001a114b1272e039fa0528abd2ac
Content-Type: multipart/alternative; boundary=001a114b1272e039f30528abd2aa

--001a114b1272e039f30528abd2aa
Content-Type: text/plain; charset=UTF-8

I've recently found the performance our development swift system is
degrading over time as the number of objects/files increases.  This is a
relatively small system, each server has 3 400GB disks.  The system I'm
currently looking at has about 70GB tied up in slabs alone, close to 55GB
in xfs inodes and ili, and about 2GB free.  The kernel
is 3.14.57-1-amd64-hlinux.

Here's the way the filesystems are mounted:

/dev/sdb1 on /srv/node/disk0 type xfs
(rw,noatime,nodiratime,attr2,nobarrier,inode64,logbufs=8,logbsize=256k,sunit=512,swidth=1536,noquota)

I can do about 2000 1K file creates/sec when running 2 minute PUT tests at
100 threads.  If I repeat that tests for multiple hours, I see the number
of IOPS steadily decreasing to about 770 and the very next run it drops to
260 and continues to fall from there.  This happens at about 12M files.

The directory structure is 2 tiered, with 1000 directories per tier so we
can have about 1M of them, though they don't currently all exist.

I've written a collectl plugin that lets me watch many of the xfs stats in
real-time and also have a test script that exercises the swift PUT code
directly and so eliminates all the inter-node communications.  This script
also allows me to write to the existing swift directories as well as
redirect to an empty structure so mimics clean environment with no existing
subdirectories.

I'm attaching some xfs stats during the run and hope they're readable.
These values are in operations/sec and each line is 1 second's worth of
data.  The first set of numbers is on the clean directory and the second on
the existing 12M file one.  At the bottom of these stats are also the xfs
slab allocations as reported by collectl.  I can also watch these during a
test and can see the number of inode and ilo objects steadily grow at about
1K/sec, which is curious since I'm only creating about 300.

If there is anything else I can provide just let me know.

I don't fully understand all the xfs stats but what does jump out at me is
the XFS read/write ops have increased by a factor of about 5 when the
system is slower.  Right now the collectl plugin is not something I've
released, but if there is interest and someone would like to help me
present the data in a more organized/meaningful manner just let me know.

if there are any tuning suggestions I'm more than happy to try them out.

-mark

--001a114b1272e039f30528abd2aa
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I&#39;ve recently found the performance our development sw=
ift system is degrading over time as the number of objects/files increases.=
=C2=A0 This is a relatively small system, each server has 3 400GB disks.=C2=
=A0 The system I&#39;m currently looking at has about 70GB tied up in slabs=
 alone, close to 55GB in xfs inodes and ili, and about 2GB free.=C2=A0 The =
kernel is=C2=A03.14.57-1-amd64-hlinux.<div><br></div><div>Here&#39;s the wa=
y the filesystems are mounted:</div><div><br></div><div><div>/dev/sdb1 on /=
srv/node/disk0 type xfs (rw,noatime,nodiratime,attr2,nobarrier,inode64,logb=
ufs=3D8,logbsize=3D256k,sunit=3D512,swidth=3D1536,noquota)</div></div><div>=
<br></div><div>I can do about 2000 1K file creates/sec when running 2 minut=
e PUT tests at 100 threads.=C2=A0 If I repeat that tests for multiple hours=
, I see the number of IOPS steadily decreasing to about 770 and the very ne=
xt run it drops to 260 and continues to fall from there.=C2=A0 This happens=
 at about 12M files.</div><div><br></div><div>The directory structure is 2 =
tiered, with 1000 directories per tier so we can have about 1M of them, tho=
ugh they don&#39;t currently all exist.</div><div><br></div><div>I&#39;ve w=
ritten a collectl plugin that lets me watch many of the xfs stats in real-t=
ime and also have a test script that exercises the swift PUT code directly =
and so eliminates all the inter-node communications.=C2=A0 This script also=
 allows me to write to the existing swift directories as well as redirect t=
o an empty structure so mimics clean environment with no existing subdirect=
ories.</div><div><br></div><div>I&#39;m attaching some xfs stats during the=
 run and hope they&#39;re readable.=C2=A0 These values are in operations/se=
c and each line is 1 second&#39;s worth of data.=C2=A0 The first set of num=
bers is on the clean directory and the second on the existing 12M file one.=
=C2=A0 At the bottom of these stats are also the xfs slab allocations as re=
ported by collectl.=C2=A0 I can also watch these during a test and can see =
the number of inode and ilo objects steadily grow at about 1K/sec, which is=
 curious since I&#39;m only creating about 300.</div><div><br></div><div>If=
 there is anything else I can provide just let me know.</div><div><br></div=
><div>I don&#39;t fully understand all the xfs stats but what does jump out=
 at me is the XFS read/write ops have increased by a factor of about 5 when=
 the system is slower.=C2=A0 Right now the collectl plugin is not something=
 I&#39;ve released, but if there is interest and someone would like to help=
 me present the data in a more organized/meaningful manner just let me know=
.</div><div><br></div><div>if there are any tuning suggestions I&#39;m more=
 than happy to try them out.</div><div><br></div><div>-mark</div></div>

--001a114b1272e039f30528abd2aa--

--001a114b1272e039fa0528abd2ac
Content-Type: text/plain; charset=US-ASCII; name="tests.txt"
Content-Disposition: attachment; filename="tests.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ij2ypdrz0

Cj4+PiBGYXN0IDw8PAojPC0tWEZTIE9wcy0tPjwtLS0tLS0tLS0tLVhGUyBMb2dnaW5nLS0tLS0t
LS0tLT48LS0tLS0tRXh0ZW50cy0tLS0tLT48LS0tLS0tRGlyT3BzLS0tLS0tLT48LS0tLVRyYW5z
LS0tPjwtLS0tWHN0cmF0LS0tPjwtLS0tLS0tQXR0ck9wcy0tLS0tPjwtLS0tLS0tLS0tLS0tLUlO
b2Rlcy0tLS0tLS0tLS0tLS0tPgojIFdyaXRlIFJlYWRzICBXcml0ZXMgV3J0S0JzIE5vUm9vbSBG
b3JjZSBTbGVlcCAgRXh0QSBCbGtBIEV4dEYgRXh0RiAgTG9vayBDcmU4IFJlbXYgR2RudCAgU3lu
YyBBc3luIEVtcHQgIFF1aWNrIFNwbGl0ICBHZXRzIFNldHMgUm1vdiBMaXN0ICBBdHB0ICBIaXQg
TWlzcyBSZWN5ICBEdXAgUmVjbCBDaGdkIAogICAgIDUzICAgNTk5ICAgICAgIDQgICAxMDI0ICAg
ICAgMCAgICAgNCAgICAgNCAgICAgMyAgIDY1ICAgMTAgICA3MCAgIDE1NSAgICA2ICAgMTQgIDI4
NCAgICAgMCAgIDc1ICAgIDEgICAgICAyICAgICAwICAgMjc1ICAgIDEgICAgMCAgIDI0ICAgICAw
ICAxNDkgICAgNSAgICAwICAgIDAgICAgMCAgICAxCiAgICAgOTIgICA4MzYgICAgICAxNiAgIDQw
OTYgICAgICAwICAgIDE2ICAgIDE2ICAgIDI0ICAxMTcgICAgOCAgIDk4ICAgMjAwICAgNTggICAx
OCAgMjcyICAgICAwICAxODEgICAgMSAgICAgIDMgICAgIDAgICAyMzUgICAxMSAgICAwICAgMTAg
ICAgIDAgIDE1MiAgIDM5ICAgIDAgICAgMCAgIDE1ICAgIDEKICAgIDM3MCAgIDczMiAgICAgMjk1
ICA3NTUyMCAgICAgIDAgICAyOTUgICAyOTUgICA1OTIgIDY4NSAgICA2ICAgOTYgIDE1OTkgMTQ0
MiAgMjkzICA4MjkgICAgIDAgMzUyNyAgICAxICAgICAgOSAgICAgMCAgIDI0NCAgMjkwICAgIDAg
ICAxMyAgICAgMCAgMTUzIDExNDQgICAgMCAgICAwICAgIDAgICAgMQogICAgMzgzICAgODM3ICAg
ICAyODQgIDcyNzA0ICAgICAgMCAgIDI4NCAgIDI4NSAgIDU1OSAgNjgzICAgMTAgIDEzMCAgMTUz
MiAxMzUyICAyODQgIDgxNiAgICAgMCAzMzQzICAgIDAgICAgICA0ICAgICAwICAgMjM2ICAyNzYg
ICAgMCAgIDEwICAgICAwICAxNTUgMTA3MyAgICAwICAgIDAgICAgOSAgICAwCiAgICAzNDEgICA3
MzQgICAgIDI4OSAgNzM5ODQgICAgICAwICAgMjg5ICAgMjg5ICAgNTgzICA2OTAgICAgOCAgIDY4
ICAxNTc0IDEzOTMgIDI5NyAgODYwICAgICAwIDM0NzIgICAgMyAgICAgIDYgICAgIDAgICAyOTEg
IDI4OCAgICAwICAgMzAgICAgIDAgIDE0MyAxMTA1ICAgIDAgICAgMCAgICAwICAgIDMKICAgIDM0
MiAgIDgxMiAgICAgMjkxICA3NDQ5NiAgICAgIDAgICAyOTEgICAyOTEgICA1ODMgIDcyMCAgICA2
ICAgNjYgIDE1NzQgMTM3NiAgMjk0ICA4NDAgICAgIDAgMzQzOSAgICAyICAgICAgMiAgICAgMCAg
IDI2MSAgMjg5ICAgIDAgICAxOSAgICAgMCAgMTQ0IDEwODcgICAgMCAgICAwICAgIDAgICAgMgog
ICAgNDI3ICAgNDE1ICAgICAzMDEgIDc3MDU2ICAgICAgMCAgIDMwMSAgIDMwMiAgIDU5OCAgODQz
ICAgMTQgIDE2NCAgMTYxMyAxMzkxICAzMDUgIDg3MCAgICAgMCAzNTMxICAgIDEgICAgICA1ICAg
ICAwICAgMjc5ICAyOTIgICAgMCAgIDI2ICAgICAwICAxNjMgMTA5MCAgICAwICAgIDAgICAgMCAg
ICAxCiAgICA0MDEgICA4MzIgICAgIDMwMiAgNzczMTIgICAgICAwICAgMzAyICAgMzAzICAgNTk4
ICA3OTcgICAxMCAgMTMwICAxNjA0IDEzOTAgIDMwMyAgODYyICAgICAwIDM1MjIgICAgMSAgICAg
IDQgICAgIDAgICAyNDQgIDI5NSAgICAwICAgMTMgICAgIDAgIDE0OCAxMDkzICAgIDAgICAgMCAg
IDkwICAgIDEKICAgIDM0OSAgIDM4NCAgICAgMjc1ICA3MDQwMCAgICAgIDAgICAyNzUgICAyNzUg
ICA1NDkgIDcxNyAgIDEwICAxMDAgIDE0ODAgMTI1OCAgMjgxICA4MTQgICAgIDAgMzIyNCAgICAx
ICAgICAgNCAgICAgMCAgIDI1MSAgMjcwICAgIDAgICAxNSAgICAgMCAgMTQ2ICA5ODUgICAgMCAg
ICAwICAgIDAgICAgMQogICAgIDc5ICAgNDMyICAgICAgIDYgICAxNTM2ICAgICAgMCAgICAgNiAg
ICAgNiAgICAgOSAgMTAyICAgIDYgICA5NiAgIDE1OCAgICAzICAgIDMgIDI1MCAgICAgMCAgIDQ3
ICAgIDAgICAgICA5ICAgICAwICAgMjQ4ICAgIDAgICAgMCAgIDE0ICAgICAwICAxNTYgICAgMiAg
ICAwICAgIDAgICAgMCAgICAwCiAgICAgNTQgICAyNTMgICAgICAgNCAgIDEwMjQgICAgICAwICAg
ICA0ICAgICA0ICAgICAyICAgNjQgICAgNCAgIDY0ICAgMTU3ICAgIDIgICAgMiAgMjc0ICAgICAw
ICAgMjMgICAgMCAgICAgIDIgICAgIDAgICAyODQgICAgMCAgICAwICAgMjYgICAgIDAgIDE1NiAg
ICAxICAgIDAgICAgMCAgICAwICAgIDAKCj4+PiBTbG93IDw8PAoKIzwtLVhGUyBPcHMtLT48LS0t
LS0tLS0tLS1YRlMgTG9nZ2luZy0tLS0tLS0tLS0+PC0tLS0tLUV4dGVudHMtLS0tLS0+PC0tLS0t
LURpck9wcy0tLS0tLS0+PC0tLS1UcmFucy0tLT48LS0tLVhzdHJhdC0tLT48LS0tLS0tLUF0dHJP
cHMtLS0tLT48LS0tLS0tLS0tLS0tLS1JTm9kZXMtLS0tLS0tLS0tLS0tLT4KIyBXcml0ZSBSZWFk
cyAgV3JpdGVzIFdydEtCcyBOb1Jvb20gRm9yY2UgU2xlZXAgIEV4dEEgQmxrQSBFeHRGIEV4dEYg
IExvb2sgQ3JlOCBSZW12IEdkbnQgIFN5bmMgQXN5biBFbXB0ICBRdWljayBTcGxpdCAgR2V0cyBT
ZXRzIFJtb3YgTGlzdCAgQXRwdCAgSGl0IE1pc3MgUmVjeSAgRHVwIFJlY2wgQ2hnZCAKICAgICAg
MCAgICA2MSAgICAgICAwICAgICAgMCAgICAgIDAgICAgIDAgICAgIDAgICAgIDAgICAgMCAgICAw
ICAgIDAgICAxMzIgICAgMCAgICAwICAyMTggICAgIDAgICAgMCAgICAwICAgICAgMCAgICAgMCAg
IDIxMyAgICAwICAgIDAgICAgMCAgICAgMCAgMTI2ICAgIDYgICAgMCAgICAwICAgIDAgICAgMAog
ICAgIDU5ICAgMTE1ICAgICAgMTEgICAyODE2ICAgICAgMCAgICAxMSAgICAxMSAgICAxNiAgIDc4
ICAgIDQgICA2NSAgIDE2MCAgIDMzICAgIDkgIDIzMCAgICAgMCAgMTA0ICAgIDAgICAgICAyICAg
ICAwICAgMjEwICAgIDcgICAgMCAgICAwICAgICAwICAxMjggICAyOCAgICAwICAgIDAgICAgMCAg
ICAwCiAgIDEzODQgIDEyNjMgICAgIDI3MiAgNjk2MzIgICAgICAwICAgMjcyICAgMjcyICAgNDIz
IDE5OTggICA5MiAxNDQzICAgODc1ICA4NzIgIDIyNyAgNTc2ICAgICAwIDI2MzkgICAgMCAgICAg
NDUgICAgIDAgICAyMTAgIDE4MiAgICAwICAgIDAgICAgIDAgIDE1MyAgNjc1ICAgIDAgICAgMCAg
ICA0ICAgIDAKICAgMTYwNCAgMTUwMyAgICAgMjk0ICA3NTI2NCAgICAgIDAgICAyOTQgICAyOTQg
ICA0MzggMjIwMSAgMTA2IDE2OTYgICA5MDcgIDg5MCAgMjQxICA1OTAgICAgIDAgMjc3MiAgICAw
ICAgICA1MyAgICAgMCAgIDIxMCAgMTg4ICAgIDAgICAgMCAgICAgMCAgMTUxICA2ODEgICAgMCAg
ICAwICAgIDkgICAgMAogICAxNjM4ICAyMjU1ICAgICAzMDkgIDc5MTA0ICAgICAgMCAgIDMwOSAg
IDMwNyAgIDQ2MCAyMzE0ICAxMTQgMTczNCAgIDk0NiAgOTM0ICAyNjAgIDYzMiAgICAgMCAyOTQy
ICAgIDAgICAgIDU0ICAgICAwICAgMjM3ICAxOTkgICAgMCAgICAwICAgICAwICAxOTMgIDY3OCAg
ICAwICAgIDAgICAgMCAgICAwCiAgIDE2NzggIDIyOTggICAgIDMzNyAgODYyNzIgICAgICAwICAg
MzM4ICAgMzMwICAgNDg2IDIzMjYgIDEyOCAxNzc5ICAxMDMxICA5ODcgIDI5MSAgNzEyICAgICAw
IDMxNjggICAgMCAgICAgNTUgICAgIDAgICAyODQgIDIyMCAgICAwICAgIDQgICAgIDAgIDE4OSAg
NzEyICAgIDAgICAgMCAgICAwICAgIDAKICAgMTU3OCAgMjQyMyAgICAgMzMzICA4NTI0OCAgICAg
IDAgICAzMzIgICAzMjUgICA0OTIgMjI2OCAgMTE4IDE2NDkgIDEwNDEgIDk5MSAgMjg5ICA3MTQg
ICAgIDAgMzE1MyAgICAwICAgICA1MSAgICAgMCAgIDI3MCAgMjIyICAgIDAgICAgMCAgICAgMCAg
MjAwICA3MDAgICAgMCAgICAwICAgIDAgICAgMAogICAxMDQwICAxODYxICAgICAyMzkgIDYxMTg0
ICAgICAgMCAgIDI0MSAgIDIzMSAgIDM1MyAxNDk2ICAgODIgMTA3MiAgIDc3NCAgNzE4ICAyMTIg
IDU4OCAgICAgMCAyMjcyICAgIDAgICAgIDMzICAgICAwICAgMjY0ICAxNjQgICAgMCAgICAwICAg
ICAwICAxNTMgIDUyNCAgICAwICAgIDAgMTczMCAgICAwCiAgIDE3MDkgIDIzNjEgICAgIDMzNiAg
ODYwMTYgICAgICAwICAgMzQwICAgMzMxICAgNDg1IDI0MDEgIDEyOCAxODEwICAxMDI5ICA5Njkg
IDI5MSAgNzA2ICAgICAwIDMxMzcgICAgMCAgICAgNTYgICAgIDAgICAyNzggIDIxNiAgICAwICAg
IDQgICAgIDAgIDE3NCAgNzIyICAgIDAgICAgMCA0NzUxICAgIDAKICAgMTYxNiAgMjA2MyAgICAg
MzI1ICA4MzIwMCAgICAgIDAgICAzMjYgICAzMjEgICA0ODUgMjI3OCAgMTE0IDE3MDcgIDEwMzgg
IDk3MyAgMjc0ICA2NzQgICAgIDEgMzA2NyAgICAwICAgICA1MyAgICAgMCAgIDI0MCAgMjE0ICAg
IDAgICAgMyAgICAgMCAgMTczICA3MzEgICAgMCAgICAwICAgIDAgICAgMAogICAxNTk5ICAxNTU3
ICAgICAzMTIgIDc5ODcyICAgICAgMCAgIDMxMiAgIDMxMyAgIDQ4MiAyMjc0ICAxMDQgMTY2NCAg
MTA0OCAgOTYyICAyNjAgIDY4NCAgICAgMCAyOTgwICAgIDAgICAgIDUyICAgICAwICAgMjI0ICAy
MDggICAgMCAgICA3ICAgICAwICAyMTkgIDY4MSAgICAwICAgIDAgICAgMCAgICAwCiAgIDExMTQg
IDEzMTIgICAgIDIyOSAgNTg2MjQgICAgICAwICAgMjI5ICAgMjMwICAgMzU2IDE1NzcgICA3MiAx
MTUyICAgODE3ICA3MDkgIDE5MiAgNTUyICAgICAwIDIxODggICAgMCAgICAgMzYgICAgIDAgICAy
MTYgIDE1NyAgICAwICAgIDMgICAgIDAgIDE2NSAgNTI0ICAgIDAgICAgMCAzNTcwICAgIDAKICAg
MTA2NiAgMTE4NSAgICAgMTc1ICA0NDgwMCAgICAgIDAgICAxNzYgICAxNzYgICAyNDkgMTQ0MCAg
IDcyIDExNTMgICA1ODUgIDQ2NiAgMTQxICA0NDAgICAgIDAgMTU3NyAgICAwICAgICAzNiAgICAg
MCAgIDIxNCAgMTA0ICAgIDAgICAgMiAgICAgMCAgMTU1ICAzMzkgICAgMCAgICAwIDQ0OTcgICAg
MAogICAgIDU0ICAgNDg3ICAgICAgIDYgICAxNTM2ICAgICAgMCAgICAgNiAgICAgNiAgICAgMiAg
IDY0ICAgIDQgICA2NCAgIDEzNyAgICAyICAgIDIgIDIzOCAgICAgMCAgIDI0ICAgIDAgICAgICAy
ICAgICAwICAgMjE2ICAgIDAgICAgMCAgICAzICAgICAwICAxMzUgICAgMiAgICAwICAgIDAgMjY2
NCAgICAwCiAgICAgIDAgICA1OTAgICAgICAgMCAgICAgIDAgICAgICAwICAgICAwICAgICAwICAg
ICAwICAgIDAgICAgMCAgICAwICAgMTM2ICAgIDAgICAgMCAgMjI0ICAgICAwICAgIDAgICAgMCAg
ICAgIDAgICAgIDAgICAyMTAgICAgMCAgICAwICAgIDAgICAgIDAgIDEzNiAgICAwICAgIDAgICAg
MCAgICAwICAgIDAKICAgICA1NCAgIDUxNCAgICAgICA0ICAgMTAyNCAgICAgIDAgICAgIDQgICAg
IDQgICAgIDIgICA2NCAgICA0ICAgNjQgICAxNDIgICAgMiAgICAyICAyNDggICAgIDAgICAyNCAg
ICAwICAgICAgMiAgICAgMCAgIDIxNCAgICAwICAgIDAgICAgMiAgICAgMCAgMTQwICAgIDIgICAg
MCAgICAwICAgIDAgICAgMAoKPj4+IHNsYWJzIDw8PAoKCnN0YWNrQGhlbGlvbi1jcDEtc3dvYmow
MDAxLW1nbXQ6fiQgc3VkbyBjb2xsZWN0bCAtc1kgLWk6MSAtYzEgLS1zbGFiZmlsdCB4ZnMKd2Fp
dGluZyBmb3IgMSBzZWNvbmQgc2FtcGxlLi4uCgojIFNMQUIgREVUQUlMCiMgICAgICAgICAgICAg
ICAgICAgICAgICAgICA8LS0tLS0tLS0tLS1PYmplY3RzLS0tLS0tLS0tLT48LS0tLS0tLS0tU2xh
YiBBbGxvY2F0aW9uLS0tLS0tPjwtLS1DaGFuZ2UtLT4KI05hbWUgICAgICAgICAgICAgICAgICAg
ICAgIEluVXNlICAgQnl0ZXMgICBBbGxvYyAgIEJ5dGVzICAgSW5Vc2UgICBCeXRlcyAgIFRvdGFs
ICAgQnl0ZXMgICBEaWZmICAgIFBjdAp4ZnNfYnRyZWVfY3VyICAgICAgICAgICAgICAgIDE4NzIg
IDM4OTM3NiAgICAxODcyICAzODkzNzYgICAgICA0OCAgMzkzMjE2ICAgICAgNDggIDM5MzIxNiAg
ICAgIDAgICAgMC4wCnhmc19kYV9zdGF0ZSAgICAgICAgICAgICAgICAgMTU4NCAgNzcyOTkyICAg
IDE1ODQgIDc3Mjk5MiAgICAgIDQ4ICA3ODY0MzIgICAgICA0OCAgNzg2NDMyICAgICAgMCAgICAw
LjAKeGZzX2RxdHJ4ICAgICAgICAgICAgICAgICAgICAgICAwICAgICAgIDAgICAgICAgMCAgICAg
ICAwICAgICAgIDAgICAgICAgMCAgICAgICAwICAgICAgIDAgICAgICAwICAgIDAuMAp4ZnNfZWZk
X2l0ZW0gICAgICAgICAgICAgICAgIDQzNjAgMTc0NDAwMCAgICA0NzYwIDE5MDQwMDAgICAgIDEx
OSAxOTQ5Njk2ICAgICAxMTkgMTk0OTY5NiAgICAgIDAgICAgMC4wCnhmc19pY3IgICAgICAgICAg
ICAgICAgICAgICAgICAgMCAgICAgICAwICAgICAgIDAgICAgICAgMCAgICAgICAwICAgICAgIDAg
ICAgICAgMCAgICAgICAwICAgICAgMCAgICAwLjAKeGZzX2lsaSAgICAgICAgICAgICAgICAgICAg
NDgxMjdLICAgNjk3Nk0gIDQ4MTk3SyAgIDY5ODZNICA5MDkzODAgICA3MTA0TSAgOTA5MzgwICAg
NzEwNE0gICAgICAwICAgIDAuMAp4ZnNfaW5vZGUgICAgICAgICAgICAgICAgICA0ODIxMEsgIDQ3
MDgwTSAgNDgyNDRLICA0NzExM00gICAxNTA3SyAgNDcxMjNNICAgMTUwN0sgIDQ3MTIzTSAgICAg
IDAgICAgMC4wCg==
--001a114b1272e039fa0528abd2ac
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--001a114b1272e039fa0528abd2ac--
