Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6539C7F37
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 16:46:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40802304039
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 14:46:36 -0800 (PST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id eaA6QJHpgcgRyGjG
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2016 14:46:34 -0800 (PST)
Received: by mail-wm0-f50.google.com with SMTP id l65so76311551wmf.1
	for <xfs@oss.sgi.com>; Wed, 06 Jan 2016 14:46:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160106221004.GJ21461@dastard>
References: <CAC2B=ZGX2bkEhdgCrpS2X5v+SpAg0jtxZ19vk_9+O9aHME-FSA@mail.gmail.com>
	<20160106220454.GI21461@dastard> <20160106221004.GJ21461@dastard>
Date: Wed, 6 Jan 2016 17:46:33 -0500
Message-ID: <CAC2B=ZHe+crzN4vTjuNRRFgaxFHDDX2=Jn16EcwY1-ukt1=M6g@mail.gmail.com>
Subject: Re: xfs and swift
From: Mark Seger <mjseger@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5310857108740379242=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Laurence Oberman <loberman@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

--===============5310857108740379242==
Content-Type: multipart/alternative; boundary=089e0102d91036d5860528b220ea

--089e0102d91036d5860528b220ea
Content-Type: text/plain; charset=UTF-8

dave, thanks for getting back to me and the pointer to the config doc.
 lots to absorb and play with.

the real challenge for me is that I'm doing testing as different levels.
While i realize running 100 parallel swift PUT threads on a small system is
not the ideal way to do things, it's the only easy way to get massive
numbers of objects into the fillesystem and once there, the performance of
a single stream is pretty poor and by instrumenting the swift code I can
clearly see excess time being spent in creating/writing the objects and so
that's lead us to believe the problem lies in the way xfs is configured.
 creating a new directory structure on that same mount point immediately
results in high levels of performance.

As an attempt to try to reproduce the problems w/o swift, I wrote a little
python script that simply creates files in a 2-tier structure, the first
tier consisting of 1024 directories and each directory contains 4096
subdirectories into which 1K files are created.  I'm doing this for 10000
objects as a time and then timing them, reporting the times, 10 per line so
each line represents 100 thousand file creates.

Here too I'm seeing degradation and if I look at what happens when there
are already 3M files and I write 1M more, I see these creation times/10
thousand:

 1.004236  0.961419  0.996514  1.012150  1.101794  0.999422  0.994796
 1.214535  0.997276  1.306736
 2.793429  1.201471  1.133576  1.069682  1.030985  1.096341  1.052602
 1.391364  0.999480  1.914125
 1.193892  0.967206  1.263310  0.890472  1.051962  4.253694  1.145573
 1.528848 13.586892  4.925790
 3.975442  8.896552  1.197005  3.904226  7.503806  1.294842  1.816422
 9.329792  7.270323  5.936545
 7.058685  5.516841  4.527271  1.956592  1.382551  1.510339  1.318341
13.255939  6.938845  4.106066
 2.612064  2.028795  4.647980  7.371628  5.473423  5.823201 14.229120
 0.899348  3.539658  8.501498
 4.662593  6.423530  7.980757  6.367012  3.414239  7.364857  4.143751
 6.317348 11.393067  1.273371
146.067300  1.317814  1.176529  1.177830 52.206605  1.112854  2.087990
42.328220  1.178436  1.335202
49.118140  1.368696  1.515826 44.690431  0.927428  0.920801  0.985965
 1.000591  1.027458 60.650443
 1.771318  2.690499  2.262868  1.061343  0.932998 64.064210 37.726213
 1.245129  0.743771  0.996683

nothing one set of 10K took almost 3 minutes!

my main questions at this point are is this performance expected and/or
might a newer kernel help?  and might it be possible to significantly
improve things via tuning or is it what it is?  I do realize I'm starting
with an empty directory tree whose performance degrades as it fills, but if
I wanted to tune for say 10M or maybe 100M files might I be able to expect
more consistent numbers (perhaps starting out at lower performance) as the
numbers of objects grow?  I'm basically looking for more consistency over a
broader range of numbers of files.

-mark

On Wed, Jan 6, 2016 at 5:10 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Jan 07, 2016 at 09:04:54AM +1100, Dave Chinner wrote:
> > On Wed, Jan 06, 2016 at 10:15:25AM -0500, Mark Seger wrote:
> > > I've recently found the performance our development swift system is
> > > degrading over time as the number of objects/files increases.  This is
> a
> > > relatively small system, each server has 3 400GB disks.  The system I'm
> > > currently looking at has about 70GB tied up in slabs alone, close to
> 55GB
> > > in xfs inodes and ili, and about 2GB free.  The kernel
> > > is 3.14.57-1-amd64-hlinux.
> >
> > So you go 50M cached inodes in memory, and a relatively old kernel.
> >
> > > Here's the way the filesystems are mounted:
> > >
> > > /dev/sdb1 on /srv/node/disk0 type xfs
> > >
> (rw,noatime,nodiratime,attr2,nobarrier,inode64,logbufs=8,logbsize=256k,sunit=512,swidth=1536,noquota)
> > >
> > > I can do about 2000 1K file creates/sec when running 2 minute PUT
> tests at
> > > 100 threads.  If I repeat that tests for multiple hours, I see the
> number
> > > of IOPS steadily decreasing to about 770 and the very next run it
> drops to
> > > 260 and continues to fall from there.  This happens at about 12M files.
> >
> > According to the numbers you've provided:
> >
> >       lookups         creates         removes
> > Fast: 1550            1350            300
> > Slow: 1000             900            250
> >
> > This is pretty much what I'd expect on the XFS level when going from
> > a small empty filesystem to one containing 12M 1k files.
> >
> > That does not correlate to your numbers above, so it's not at all
> > clear that there is realy a problem here at the XFS level.
> >
> > > The directory structure is 2 tiered, with 1000 directories per tier so
> we
> > > can have about 1M of them, though they don't currently all exist.
> >
> > That's insane.
> >
> > The xfs directory structure is much, much more space, time, IO and
> > memory efficient that a directory hierachy like this. The only thing
> > you need a directory hash hierarchy for is to provide sufficient
> > concurrency for your operations, which you would probably get with a
> > single level with one or two subdirs per filesystem AG.
>
> BTW, you might want to read the section on directory block size for
> a quick introduction to XFS directory design and scalability:
>
>
> https://git.kernel.org/cgit/fs/xfs/xfs-documentation.git/tree/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--089e0102d91036d5860528b220ea
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">dave, thanks for getting back to me and the pointer to the=
 config doc. =C2=A0lots to absorb and play with.<div><br></div><div>the rea=
l challenge for me is that I&#39;m doing testing as different levels.=C2=A0=
 While i realize running 100 parallel swift PUT threads on a small system i=
s not the ideal way to do things, it&#39;s the only easy way to get massive=
 numbers of objects into the fillesystem and once there, the performance of=
 a single stream is pretty poor and by instrumenting the swift code I can c=
learly see excess time being spent in creating/writing the objects and so t=
hat&#39;s lead us to believe the problem lies in the way xfs is configured.=
 =C2=A0creating a new directory structure on that same mount point immediat=
ely results in high levels of performance.</div><div><br></div><div>As an a=
ttempt to try to reproduce the problems w/o swift, I wrote a little python =
script that simply creates files in a 2-tier structure, the first tier cons=
isting of 1024 directories and each directory contains 4096 subdirectories =
into which 1K files are created.=C2=A0 I&#39;m doing this for 10000 objects=
 as a time and then timing them, reporting the times, 10 per line so each l=
ine represents 100 thousand file creates.</div><div><br></div><div>Here too=
 I&#39;m seeing degradation and if I look at what happens when there are al=
ready 3M files and I write 1M more, I see these creation times/10 thousand:=
</div><div><br></div><div><div>=C2=A01.004236 =C2=A00.961419 =C2=A00.996514=
 =C2=A01.012150 =C2=A01.101794 =C2=A00.999422 =C2=A00.994796 =C2=A01.214535=
 =C2=A00.997276 =C2=A01.306736</div><div>=C2=A02.793429 =C2=A01.201471 =C2=
=A01.133576 =C2=A01.069682 =C2=A01.030985 =C2=A01.096341 =C2=A01.052602 =C2=
=A01.391364 =C2=A00.999480 =C2=A01.914125</div><div>=C2=A01.193892 =C2=A00.=
967206 =C2=A01.263310 =C2=A00.890472 =C2=A01.051962 =C2=A04.253694 =C2=A01.=
145573 =C2=A01.528848 13.586892 =C2=A04.925790</div><div>=C2=A03.975442 =C2=
=A08.896552 =C2=A01.197005 =C2=A03.904226 =C2=A07.503806 =C2=A01.294842 =C2=
=A01.816422 =C2=A09.329792 =C2=A07.270323 =C2=A05.936545</div><div>=C2=A07.=
058685 =C2=A05.516841 =C2=A04.527271 =C2=A01.956592 =C2=A01.382551 =C2=A01.=
510339 =C2=A01.318341 13.255939 =C2=A06.938845 =C2=A04.106066</div><div>=C2=
=A02.612064 =C2=A02.028795 =C2=A04.647980 =C2=A07.371628 =C2=A05.473423 =C2=
=A05.823201 14.229120 =C2=A00.899348 =C2=A03.539658 =C2=A08.501498</div><di=
v>=C2=A04.662593 =C2=A06.423530 =C2=A07.980757 =C2=A06.367012 =C2=A03.41423=
9 =C2=A07.364857 =C2=A04.143751 =C2=A06.317348 11.393067 =C2=A01.273371</di=
v><div>146.067300 =C2=A01.317814 =C2=A01.176529 =C2=A01.177830 52.206605 =
=C2=A01.112854 =C2=A02.087990 42.328220 =C2=A01.178436 =C2=A01.335202</div>=
<div>49.118140 =C2=A01.368696 =C2=A01.515826 44.690431 =C2=A00.927428 =C2=
=A00.920801 =C2=A00.985965 =C2=A01.000591 =C2=A01.027458 60.650443</div><di=
v>=C2=A01.771318 =C2=A02.690499 =C2=A02.262868 =C2=A01.061343 =C2=A00.93299=
8 64.064210 37.726213 =C2=A01.245129 =C2=A00.743771 =C2=A00.996683</div></d=
iv><div><br></div><div>nothing one set of 10K took almost 3 minutes!</div><=
div><br></div><div>my main questions at this point are is this performance =
expected and/or might a newer kernel help? =C2=A0and might it be possible t=
o significantly improve things via tuning or is it what it is?=C2=A0 I do r=
ealize I&#39;m starting with an empty directory tree whose performance degr=
ades as it fills, but if I wanted to tune for say 10M or maybe 100M files m=
ight I be able to expect more consistent numbers (perhaps starting out at l=
ower performance) as the numbers of objects grow?=C2=A0 I&#39;m basically l=
ooking for more consistency over a broader range of numbers of files.</div>=
<div><br></div><div>-mark</div></div><div class=3D"gmail_extra"><br><div cl=
ass=3D"gmail_quote">On Wed, Jan 6, 2016 at 5:10 PM, Dave Chinner <span dir=
=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david=
@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div=
 class=3D"HOEnZb"><div class=3D"h5">On Thu, Jan 07, 2016 at 09:04:54AM +110=
0, Dave Chinner wrote:<br>
&gt; On Wed, Jan 06, 2016 at 10:15:25AM -0500, Mark Seger wrote:<br>
&gt; &gt; I&#39;ve recently found the performance our development swift sys=
tem is<br>
&gt; &gt; degrading over time as the number of objects/files increases.=C2=
=A0 This is a<br>
&gt; &gt; relatively small system, each server has 3 400GB disks.=C2=A0 The=
 system I&#39;m<br>
&gt; &gt; currently looking at has about 70GB tied up in slabs alone, close=
 to 55GB<br>
&gt; &gt; in xfs inodes and ili, and about 2GB free.=C2=A0 The kernel<br>
&gt; &gt; is 3.14.57-1-amd64-hlinux.<br>
&gt;<br>
&gt; So you go 50M cached inodes in memory, and a relatively old kernel.<br=
>
&gt;<br>
&gt; &gt; Here&#39;s the way the filesystems are mounted:<br>
&gt; &gt;<br>
&gt; &gt; /dev/sdb1 on /srv/node/disk0 type xfs<br>
&gt; &gt; (rw,noatime,nodiratime,attr2,nobarrier,inode64,logbufs=3D8,logbsi=
ze=3D256k,sunit=3D512,swidth=3D1536,noquota)<br>
&gt; &gt;<br>
&gt; &gt; I can do about 2000 1K file creates/sec when running 2 minute PUT=
 tests at<br>
&gt; &gt; 100 threads.=C2=A0 If I repeat that tests for multiple hours, I s=
ee the number<br>
&gt; &gt; of IOPS steadily decreasing to about 770 and the very next run it=
 drops to<br>
&gt; &gt; 260 and continues to fall from there.=C2=A0 This happens at about=
 12M files.<br>
&gt;<br>
&gt; According to the numbers you&#39;ve provided:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0lookups=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cre=
ates=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0removes<br>
&gt; Fast: 1550=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1350=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 300<br>
&gt; Slow: 1000=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0900=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 250<br>
&gt;<br>
&gt; This is pretty much what I&#39;d expect on the XFS level when going fr=
om<br>
&gt; a small empty filesystem to one containing 12M 1k files.<br>
&gt;<br>
&gt; That does not correlate to your numbers above, so it&#39;s not at all<=
br>
&gt; clear that there is realy a problem here at the XFS level.<br>
&gt;<br>
&gt; &gt; The directory structure is 2 tiered, with 1000 directories per ti=
er so we<br>
&gt; &gt; can have about 1M of them, though they don&#39;t currently all ex=
ist.<br>
&gt;<br>
&gt; That&#39;s insane.<br>
&gt;<br>
&gt; The xfs directory structure is much, much more space, time, IO and<br>
&gt; memory efficient that a directory hierachy like this. The only thing<b=
r>
&gt; you need a directory hash hierarchy for is to provide sufficient<br>
&gt; concurrency for your operations, which you would probably get with a<b=
r>
&gt; single level with one or two subdirs per filesystem AG.<br>
<br>
</div></div>BTW, you might want to read the section on directory block size=
 for<br>
a quick introduction to XFS directory design and scalability:<br>
<br>
<a href=3D"https://git.kernel.org/cgit/fs/xfs/xfs-documentation.git/tree/ad=
min/XFS_Performance_Tuning/filesystem_tunables.asciidoc" rel=3D"noreferrer"=
 target=3D"_blank">https://git.kernel.org/cgit/fs/xfs/xfs-documentation.git=
/tree/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc</a><br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div>

--089e0102d91036d5860528b220ea--


--===============5310857108740379242==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5310857108740379242==--
