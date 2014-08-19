Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D918D7F3F
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 12:44:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B57F48F8035
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 10:44:29 -0700 (PDT)
Received: from mail-ig0-f174.google.com (mail-ig0-f174.google.com
	[209.85.213.174]) by cuda.sgi.com with ESMTP id
	fPipObgRWSDTTszV (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Aug 2014 10:44:27 -0700 (PDT)
Received: by mail-ig0-f174.google.com with SMTP id c1so10426563igq.13
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 10:44:27 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Aug 2014 23:14:27 +0530
Message-ID: <CAJAKVEGTFxJ3Vb7KO5SP3ZYdO5kuKieyAaztku1MwoMG2SLyxA@mail.gmail.com>
Subject: [RFD] xfs_fsr: Adding features for online defragmentation
From: Somdeep Dey <somdeepdey10@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2875005186518367658=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2875005186518367658==
Content-Type: multipart/alternative; boundary=089e01538e5af256ba0500ff097f

--089e01538e5af256ba0500ff097f
Content-Type: text/plain; charset=UTF-8

Hello,

We are a team of three final year under-graduates from Pune Institute
<http://pict.edu/>
of Computer Technology <http://pict.edu/>, India and were looking for a
project in XFS
with a development time of about 6 - 7 months. On contacting Dave,
he suggested we work on the userspace utility, xfs_fsr.

xfs_fsr(online defragmenter):
A few possible enhancements to xfs_fsr are as follows:

1. explicit control of locality for groups of files.
2. ability to defragment only portions of files rather
than just whole files.
3. defragmenting free space.
4. enhanced/faster filesystem scanning.

Our understanding of the problem is as follows:

A) We identified the first thing needed, will be to find regions of
fragmented free space. Dave directed us to the following prototype
that he had written
(http://oss.sgi.com/archives/xfs/2012-10/msg00363.html)

B)  The next task will be to go about finding the owners of the blocks
that are causing the region of fragmented free space. It will require a
reverse block map to do this efficiently. Dave has said that he is likely
to implement it in the next couple of months, and we understand that
we will to need to define the interfaces needed to query the rmap from
userspace.

C)  Once the fragmented free space, and the files that own the blocks
that fragment the free space are found we will need to move them, and
take care of the following:
(a) move just the blocks we need to.
(b) control exactly where we move them to.

We are reviewing the recent patches on the mailing list for IOC_MOV_DATA,
which allows an arbitrary range of one file to be swapped with an arbitrary
range of another file. The core mechanism required by #2.
(http://oss.sgi.com/archives/xfs/2014-07/msg00109.html)

Hence after due consideration we are planning to execute
the 4 sub topics in the following order:
1. defragmenting free space.
2. enhanced/faster filesystem scanning.
3. ability to defragment only portions of files rather
than just whole files.
4. explicit control of locality for groups of files.

Comments regarding the same will be appreciated. We would also like to
thank
Dave for his inputs. We look forward to working with the community and hope
to
make a valuable contribution.

Regards.

--089e01538e5af256ba0500ff097f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra" style=3D"font-family:arial,sans=
-serif;font-size:13px">Hello,</div><div class=3D"gmail_extra" style=3D"font=
-family:arial,sans-serif;font-size:13px"><br></div><div class=3D"gmail_extr=
a" style=3D"font-family:arial,sans-serif;font-size:13px">
We are a team of three final year under-graduates from=C2=A0<a href=3D"http=
://pict.edu/" target=3D"_blank">Pune Institute</a></div><div class=3D"gmail=
_extra" style=3D"font-family:arial,sans-serif;font-size:13px"><a href=3D"ht=
tp://pict.edu/" target=3D"_blank">of Computer Technology</a>, India and wer=
e looking for a project in XFS=C2=A0</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">with a development time of about 6 - 7 months. On contacting Dave,=C2=
=A0</div><div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;f=
ont-size:13px">
he suggested we work on the userspace utility, xfs_fsr.</div><div class=3D"=
gmail_extra" style=3D"font-family:arial,sans-serif;font-size:13px">=C2=A0</=
div><div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-s=
ize:13px">
xfs_fsr(online defragmenter):</div><div class=3D"gmail_extra" style=3D"font=
-family:arial,sans-serif;font-size:13px">A few possible enhancements to xfs=
_fsr are as follows:</div><div class=3D"gmail_extra" style=3D"font-family:a=
rial,sans-serif;font-size:13px">
=C2=A0</div><div class=3D"gmail_extra" style=3D"font-family:arial,sans-seri=
f;font-size:13px">1. explicit control of locality for groups of files.</div=
><div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size=
:13px">2. ability to defragment only portions of files rather</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">than just whole files.</div><div class=3D"gmail_extra" style=3D"font-=
family:arial,sans-serif;font-size:13px">3. defragmenting free space.</div><=
div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:1=
3px">
4. enhanced/faster filesystem scanning.</div><div class=3D"gmail_extra" sty=
le=3D"font-family:arial,sans-serif;font-size:13px">=C2=A0</div><div class=
=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:13px">Our =
understanding of the problem is as follows:</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">=C2=A0</div><div class=3D"gmail_extra" style=3D"font-family:arial,san=
s-serif;font-size:13px">A) We identified the first thing needed, will be to=
 find regions of=C2=A0</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">fragmented free space. Dave directed us to the following prototype=C2=
=A0</div><div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;f=
ont-size:13px">
that he had written</div><div class=3D"gmail_extra" style=3D"font-family:ar=
ial,sans-serif;font-size:13px">(<a href=3D"http://oss.sgi.com/archives/xfs/=
2012-10/msg00363.html" target=3D"_blank">http://oss.sgi.com/archives/xfs/20=
12-10/msg00363.html</a>)</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">=C2=A0</div><div class=3D"gmail_extra" style=3D"font-family:arial,san=
s-serif;font-size:13px">B) =C2=A0The next task will be to go about finding =
the owners of the blocks</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">that are causing the region of fragmented free space. It will require=
 a</div><div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;fo=
nt-size:13px">
reverse block map to do this efficiently. Dave has said that he is likely</=
div><div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-s=
ize:13px">to implement it in the next couple of months, and we understand t=
hat</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">we will to need to define the interfaces needed to query the rmap fro=
m=C2=A0</div><div class=3D"gmail_extra" style=3D"font-family:arial,sans-ser=
if;font-size:13px">
userspace.</div><div class=3D"gmail_extra" style=3D"font-family:arial,sans-=
serif;font-size:13px">=C2=A0</div><div class=3D"gmail_extra" style=3D"font-=
family:arial,sans-serif;font-size:13px">C) =C2=A0Once the fragmented free s=
pace, and the files that own the blocks=C2=A0</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">that fragment the free space are found we will need to move them, and=
=C2=A0</div><div class=3D"gmail_extra" style=3D"font-family:arial,sans-seri=
f;font-size:13px">
take care of the following:</div><div class=3D"gmail_extra" style=3D"font-f=
amily:arial,sans-serif;font-size:13px">(a) move just the blocks we need to.=
</div><div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font=
-size:13px">
(b) control exactly where we move them to.</div><div class=3D"gmail_extra" =
style=3D"font-family:arial,sans-serif;font-size:13px">=C2=A0</div><div clas=
s=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:13px">We =
are reviewing the recent patches on the mailing list for IOC_MOV_DATA,=C2=
=A0</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">which allows an arbitrary range of one file to be swapped with an arb=
itrary</div><div class=3D"gmail_extra" style=3D"font-family:arial,sans-seri=
f;font-size:13px">
range of another file. The core mechanism required by #2.</div><div class=
=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:13px">(<a =
href=3D"http://oss.sgi.com/archives/xfs/2014-07/msg00109.html" target=3D"_b=
lank">http://oss.sgi.com/archives/xfs/2014-07/msg00109.html</a>)</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">=C2=A0</div><div class=3D"gmail_extra" style=3D"font-family:arial,san=
s-serif;font-size:13px">Hence after due consideration we are planning to ex=
ecute</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">the 4 sub topics in the following order:</div><div class=3D"gmail_ext=
ra" style=3D"font-family:arial,sans-serif;font-size:13px">1. defragmenting =
free space.</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">2. enhanced/faster filesystem scanning.</div><div class=3D"gmail_extr=
a" style=3D"font-family:arial,sans-serif;font-size:13px">3. ability to defr=
agment only portions of files rather</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">than just whole files.</div><div class=3D"gmail_extra" style=3D"font-=
family:arial,sans-serif;font-size:13px">4. explicit control of locality for=
 groups of files.</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">=C2=A0</div><div class=3D"gmail_extra" style=3D"font-family:arial,san=
s-serif;font-size:13px">Comments regarding the same will be appreciated. We=
 would also like to thank=C2=A0</div>
<div class=3D"gmail_extra" style=3D"font-family:arial,sans-serif;font-size:=
13px">Dave for his inputs. We look forward to working with the community an=
d hope to</div><div class=3D"gmail_extra" style=3D"font-family:arial,sans-s=
erif;font-size:13px">
make a valuable contribution.</div><div class=3D"gmail_extra" style=3D"font=
-family:arial,sans-serif;font-size:13px">=C2=A0</div><div class=3D"gmail_ex=
tra" style=3D"font-family:arial,sans-serif;font-size:13px">Regards.</div></=
div>

--089e01538e5af256ba0500ff097f--


--===============2875005186518367658==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2875005186518367658==--
