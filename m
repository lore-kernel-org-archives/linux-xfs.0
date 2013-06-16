Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A1137F37
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 07:59:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EA1DCAC004
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 05:59:01 -0700 (PDT)
Received: from mail-qe0-f53.google.com (mail-qe0-f53.google.com
	[209.85.128.53]) by cuda.sgi.com with ESMTP id TH3GGa4MkmxLJL4c
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 16 Jun 2013 05:58:59 -0700 (PDT)
Received: by mail-qe0-f53.google.com with SMTP id 1so1166488qee.26
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 05:58:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130616001130.GE29338@dastard>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<91017249.1356192.1371248207334.JavaMail.root@redhat.com>
	<CAC2B=ZHYV6d-1PO_=-jXsQidZnYPHVwcVAaQh2mxJt=5K03AEA@mail.gmail.com>
	<504625587.1365681.1371255450937.JavaMail.root@redhat.com>
	<CAC2B=ZF+eMyNLPQmhA_onDPEUqgNfcgCdZVvobNH9pofvioN7Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
Date: Sun, 16 Jun 2013 08:58:58 -0400
Message-ID: <CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
Subject: Re: definitions for /proc/fs/xfs/stat
From: Mark Seger <mjseger@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4882438547025343741=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Nathan Scott <nathans@redhat.com>, xfs@oss.sgi.com

--===============4882438547025343741==
Content-Type: multipart/alternative; boundary=047d7bf0f41a1e980604df450b8b

--047d7bf0f41a1e980604df450b8b
Content-Type: text/plain; charset=ISO-8859-1

ok, I have a simple reproducer.  try out the following, noting you'll
obviously have to change the directory pointed to by dname:

libc=ctypes.CDLL(ctypes.util.find_library('c'), use_errno=True)
falloc=getattr(libc, 'fallocate')

fb#!/usr/bin/python -u

import os
import sys
import time
import ctypes
import ctypes.util
from tempfile import mkstemp

dname = '/srv/node/disk0/mjs'
fname = 'foo'
fsize = 1024
nfiles = 1000

body = ' ' * fsize

time0 = time.time()
for i in range(nfiles):
    file_name = '%s/%s-%s' % (dname, fname, i)
    fd, tmppath = mkstemp(dir=dname)
    falloc(fd, 1, 0, fsize)
    os.rename(tmppath, file_name)

elapsed = time.time() - time0
tbytes = fsize * nfiles
rate = tbytes/elapsed/1024/1024

print "DName: %s" % dname
print "Bytes: %d" % (tbytes/1024/1024)
print "Time:  %.2f secs" % elapsed
print "Rate:  %.2f/sec" % rate

when I run it I see this:

segerm@az1-sw-object-0006:~$ sudo ./falloc.py
DName: /srv/node/disk0/mjs
Bytes: 9
Time:  5.84 secs
Rate:  1.67/sec

and while running collectl I see this:

#<----CPU[HYPER]-----><----------Disks-----------><----------Network---------->
#cpu sys inter  ctxsw KBRead  Reads KBWrit Writes   KBIn  PktIn  KBOut
 PktOut
   0   0   110    113      0      0      0      0      0      5      0
  3
   1   0  1576   2874      0      0 170240    665      0      3      0
  2
   4   3  2248   6623      0      0 406585   1596      0      1      0
  1
   4   3  2145   7680      0      0 473600   1850      0      1      0
  1
   2   1  2200   7406      0      0 456633   1875      0      2      0
  1
   4   3  3696   7401      0      0 454606   1823      0      1      0
  1
   3   2  3877   7354      0      0 453537   1806      0      1      0
  1
   1   0  1610   2764      0      0 163793    684      0      3      0
  3

This is the same behavior I'm seeing on swift.  10K 1KB files X 4kb minimal
block size still comes out to a lot less than the multiple GB of writes
being reported.  Actually since these whole thing only takes a few seconds
and I know a single disk can't write that fast maybe it's just a bug in the
way the kernel is reported allocated preallocated blocks and nothing to do
with XFS?  Or iis xfs responsible for the stats?

If I remove the fallocate call I see the expected amount of disk traffic.

-mark



On Sat, Jun 15, 2013 at 8:11 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Sat, Jun 15, 2013 at 12:22:35PM -0400, Mark Seger wrote:
> > I was thinking a little color commentary might be helpful from a
> > perspective of what the functionally is that's driving the need for
> > fallocate.  I think I mentioned somewhere in this thread that the
> > application is OpenStack Swift, which is  a highly scalable cloud object
> > store.
>
> I'm familiar with it and the problems it causes filesystems. What
> application am I talking about here, for example?
>
> http://oss.sgi.com/pipermail/xfs/2013-June/027159.html
>
> Basically, Swift is trying to emulate Direct IO because python
> does't support Direct IO. Hence Swift is hacking around that problem
> and causing secondary issues that would never have occurred if
> Direct IO was used in the first place.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7bf0f41a1e980604df450b8b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">ok, I have a simple reproducer. =A0try out the following, =
noting you&#39;ll obviously have to change the directory pointed to by dnam=
e:<div><br></div><div><div>libc=3Dctypes.CDLL(ctypes.util.find_library(&#39=
;c&#39;), use_errno=3DTrue)<br>
</div><div>falloc=3Dgetattr(libc, &#39;fallocate&#39;)</div><div><br></div>=
<div>fb<span style=3D"font-family:&#39;courier new&#39;,monospace">#!/usr/b=
in/python -u</span></div><div><font face=3D"courier new, monospace"><br></f=
ont></div>
<div><font face=3D"courier new, monospace">import os</font></div><div><font=
 face=3D"courier new, monospace">import sys</font></div><div><font face=3D"=
courier new, monospace">import time</font></div><div><font face=3D"courier =
new, monospace">import ctypes</font></div>
<div><font face=3D"courier new, monospace">import ctypes.util</font></div><=
div><font face=3D"courier new, monospace">from tempfile import mkstemp</fon=
t></div><div><font face=3D"courier new, monospace"><br></font></div><div><f=
ont face=3D"courier new, monospace">dname =3D &#39;/srv/node/disk0/mjs&#39;=
</font></div>
<div><font face=3D"courier new, monospace">fname =3D &#39;foo&#39;</font></=
div><div><font face=3D"courier new, monospace">fsize =3D 1024</font></div><=
div><font face=3D"courier new, monospace">nfiles =3D 1000</font></div><div>=
<font face=3D"courier new, monospace"><br>
</font></div><div><font face=3D"courier new, monospace">body =3D &#39; &#39=
; * fsize</font></div><div><font face=3D"courier new, monospace"><br></font=
></div><div><font face=3D"courier new, monospace">time0 =3D time.time()</fo=
nt></div>
<div><font face=3D"courier new, monospace">for i in range(nfiles):</font></=
div><div><font face=3D"courier new, monospace">=A0 =A0 file_name =3D &#39;%=
s/%s-%s&#39; % (dname, fname, i)</font></div><div><font face=3D"courier new=
, monospace">=A0 =A0 fd, tmppath =3D mkstemp(dir=3Ddname)</font></div>
<div><font face=3D"courier new, monospace">=A0 =A0 falloc(fd, 1, 0, fsize)<=
/font></div><div><font face=3D"courier new, monospace">=A0 =A0 os.rename(tm=
ppath, file_name)</font></div><div><font face=3D"courier new, monospace"><b=
r></font></div>
<div><font face=3D"courier new, monospace">elapsed =3D time.time() - time0<=
/font></div><div><font face=3D"courier new, monospace">tbytes =3D fsize * n=
files</font></div><div><font face=3D"courier new, monospace">rate =3D tbyte=
s/elapsed/1024/1024</font></div>
<div><font face=3D"courier new, monospace"><br></font></div><div><font face=
=3D"courier new, monospace">print &quot;DName: %s&quot; % dname</font></div=
><div><font face=3D"courier new, monospace">print &quot;Bytes: %d&quot; % (=
tbytes/1024/1024)</font></div>
<div><font face=3D"courier new, monospace">print &quot;Time: =A0%.2f secs&q=
uot; % elapsed</font></div><div><font face=3D"courier new, monospace">print=
 &quot;Rate: =A0%.2f/sec&quot; % rate</font></div></div><div><br></div><div=
 style>
when I run it I see this:</div><div style><br></div><div style><div><font f=
ace=3D"courier new, monospace">segerm@az1-sw-object-0006:~$ sudo ./falloc.p=
y</font></div><div><font face=3D"courier new, monospace">DName: /srv/node/d=
isk0/mjs</font></div>
<div><font face=3D"courier new, monospace">Bytes: 9</font></div><div><font =
face=3D"courier new, monospace">Time: =A05.84 secs</font></div><div><font f=
ace=3D"courier new, monospace">Rate: =A01.67/sec</font></div><div><br></div=
><div style>
and while running collectl I see this:</div><div style><br></div><div style=
><div><font face=3D"courier new, monospace">#&lt;----CPU[HYPER]-----&gt;&lt=
;----------Disks-----------&gt;&lt;----------Network----------&gt;</font></=
div>
<div><font face=3D"courier new, monospace">#cpu sys inter =A0ctxsw KBRead =
=A0Reads KBWrit Writes =A0 KBIn =A0PktIn =A0KBOut =A0PktOut</font></div><di=
v><font face=3D"courier new, monospace">=A0 =A00 =A0 0 =A0 110 =A0 =A0113 =
=A0 =A0 =A00 =A0 =A0 =A00 =A0 =A0 =A00 =A0 =A0 =A00 =A0 =A0 =A00 =A0 =A0 =
=A05 =A0 =A0 =A00 =A0 =A0 =A0 3<br>
</font></div><div><font face=3D"courier new, monospace">=A0 =A01 =A0 0 =A01=
576 =A0 2874 =A0 =A0 =A00 =A0 =A0 =A00 170240 =A0 =A0665 =A0 =A0 =A00 =A0 =
=A0 =A03 =A0 =A0 =A00 =A0 =A0 =A0 2</font></div><div><font face=3D"courier =
new, monospace">=A0 =A04 =A0 3 =A02248 =A0 6623 =A0 =A0 =A00 =A0 =A0 =A00 4=
06585 =A0 1596 =A0 =A0 =A00 =A0 =A0 =A01 =A0 =A0 =A00 =A0 =A0 =A0 1</font><=
/div>
<div><font face=3D"courier new, monospace">=A0 =A04 =A0 3 =A02145 =A0 7680 =
=A0 =A0 =A00 =A0 =A0 =A00 473600 =A0 1850 =A0 =A0 =A00 =A0 =A0 =A01 =A0 =A0=
 =A00 =A0 =A0 =A0 1</font></div><div><font face=3D"courier new, monospace">=
=A0 =A02 =A0 1 =A02200 =A0 7406 =A0 =A0 =A00 =A0 =A0 =A00 456633 =A0 1875 =
=A0 =A0 =A00 =A0 =A0 =A02 =A0 =A0 =A00 =A0 =A0 =A0 1</font></div>
<div><font face=3D"courier new, monospace">=A0 =A04 =A0 3 =A03696 =A0 7401 =
=A0 =A0 =A00 =A0 =A0 =A00 454606 =A0 1823 =A0 =A0 =A00 =A0 =A0 =A01 =A0 =A0=
 =A00 =A0 =A0 =A0 1</font></div><div><font face=3D"courier new, monospace">=
=A0 =A03 =A0 2 =A03877 =A0 7354 =A0 =A0 =A00 =A0 =A0 =A00 453537 =A0 1806 =
=A0 =A0 =A00 =A0 =A0 =A01 =A0 =A0 =A00 =A0 =A0 =A0 1</font></div>
<div><font face=3D"courier new, monospace">=A0 =A01 =A0 0 =A01610 =A0 2764 =
=A0 =A0 =A00 =A0 =A0 =A00 163793 =A0 =A0684 =A0 =A0 =A00 =A0 =A0 =A03 =A0 =
=A0 =A00 =A0 =A0 =A0 3<br></font></div><div><br></div><div style>This is th=
e same behavior I&#39;m seeing on swift. =A010K 1KB files X 4kb minimal blo=
ck size still comes out to a lot less than the multiple GB of writes being =
reported. =A0Actually since these whole thing only takes a few seconds and =
I know a single disk can&#39;t write that fast maybe it&#39;s just a bug in=
 the way the kernel is reported allocated preallocated blocks and nothing t=
o do with XFS? =A0Or iis xfs responsible for the stats?</div>
<div style><br></div><div style>If I remove the fallocate call I see the ex=
pected amount of disk traffic.</div><div style><br></div><div style>-mark</=
div><div><br></div></div></div></div><div class=3D"gmail_extra"><br><br><di=
v class=3D"gmail_quote">
On Sat, Jun 15, 2013 at 8:11 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=
=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im">On Sat, Jun 15, 2013 at 12:22:35PM -0400, Mark Seger wrot=
e:<br>
&gt; I was thinking a little color commentary might be helpful from a<br>
&gt; perspective of what the functionally is that&#39;s driving the need fo=
r<br>
&gt; fallocate. =A0I think I mentioned somewhere in this thread that the<br=
>
&gt; application is OpenStack Swift, which is =A0a highly scalable cloud ob=
ject<br>
&gt; store.<br>
<br>
</div>I&#39;m familiar with it and the problems it causes filesystems. What=
<br>
application am I talking about here, for example?<br>
<br>
<a href=3D"http://oss.sgi.com/pipermail/xfs/2013-June/027159.html" target=
=3D"_blank">http://oss.sgi.com/pipermail/xfs/2013-June/027159.html</a><br>
<br>
Basically, Swift is trying to emulate Direct IO because python<br>
does&#39;t support Direct IO. Hence Swift is hacking around that problem<br=
>
and causing secondary issues that would never have occurred if<br>
Direct IO was used in the first place.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div>

--047d7bf0f41a1e980604df450b8b--


--===============4882438547025343741==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4882438547025343741==--
