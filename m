Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EEC9A7F3F
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 17:39:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B05DA30406A
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 15:39:45 -0700 (PDT)
Received: from mail-qc0-f175.google.com (mail-qc0-f175.google.com
	[209.85.216.175]) by cuda.sgi.com with ESMTP id
	B5tQk8OUzx1NzM6y (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 05 Sep 2014 15:39:43 -0700 (PDT)
Received: by mail-qc0-f175.google.com with SMTP id c9so13004326qcz.20
	for <xfs@oss.sgi.com>; Fri, 05 Sep 2014 15:39:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140905212400.GA8904@laptop.bfoster>
References: <540986B1.4080306@profihost.ag>
	<20140905123058.GA29710@bfoster.bfoster>
	<5409AF40.10801@profihost.ag>
	<20140905134810.GA3965@laptop.bfoster>
	<5409FBEA.9050708@profihost.ag>
	<20140905191815.GB8400@laptop.bfoster>
	<540A19BB.8040404@profihost.ag>
	<20140905212400.GA8904@laptop.bfoster>
Date: Fri, 5 Sep 2014 18:39:42 -0400
Message-ID: <CAA43vkWa_NJvt-D8Dp3QRD35s6kN+B+7bmNPduDDqmrfA1SAdQ@mail.gmail.com>
Subject: Re: Is XFS suitable for 350 million files on 20TB storage?
From: Sean Caron <scaron@umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2164557425858334055=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, Sean Caron <scaron@umich.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe <s.priebe@profihost.ag>

--===============2164557425858334055==
Content-Type: multipart/alternative; boundary=001a11c1f0da2a1c3e05025925d2

--001a11c1f0da2a1c3e05025925d2
Content-Type: text/plain; charset=UTF-8

Hi Stefan,

Generally speaking, this is a situation that you want to avoid. At 350
million files and 20 TB, you're looking at around 17-18 MB per file at
minimum? That's pretty small. And with 350M files, a fair number of those
350M must be on the smaller side of things.

Memory is cheap these days... people can make 50 GB, 100 GB, ... files, go
ahead and read those things directly into memory, 100%. And CPU cycles are
pretty cheap, too. Certainly you get more bang per buck there, than in IOPS
on your storage system!!

Empirically, I have found from experience (currently running Linux 3.4.61;
many historical revs previous) in a reasonably large-scale (up to ~0.5 PB
in single file system, up to 270 JBOD spindles on one machine) high-I/O
(jobs running on a few-hundred-node compute cluster, or a few hundred
threads running locally on the server) environment, that XFS (and things
running on top of it, ESPECIALLY rsync) will perform MUCH better on smaller
numbers of very large files, then they will on very large numbers of small
files (I'm always trying to reinforce this to our end users).

I'm not really even saying XFS is to really blame here... in fact in 3.4.61
it has been very well-behaved; but Linux has many warts: poor
implementation of I/O and CPU scheduling algorithms; kernel does not
degrade gracefully in resource-constrained settings; if you are ultimately
using this data store as a file share, the protocol implementations have
their own issues... NFS, CIFS, etc... Not trying to dog all the hardworking
free software devs out there but clearly much work remains to be done in
many areas, to make Linux really ready to play in the "big big leagues" of
computing (unless you have a local staff of good systems programmers with
some free time on their hands...). XFS is just one piece of the puzzle we
have to work with in trying to integrate a Linux system as a good
high-throughput storage machine.

If there is any way that you can use simple catenation or some kind of
archiver... even things as simple as shar, tar, zip... to get the file
sizes up and the absolute number of files down, you should notice some big
performance gains when trying to process your 20 TB worth of stuff.

If you can't dramatically increase individual file size while dramatically
reducing the absolute number of files for whatever reason in your
environment, I think you can still win by trying to reduce the number of
files in any one directory. You want to look out for directories that have
five or six figures worth of files in them, those can be real performance
killers. If your claim of no more than 5,000 files per any directory is
accurate, that shouldn't be a big deal for XFS at all, I don't think you're
in bad shape there.

Rsync can be just the worst in this kind of scenario. It runs so slow, you
feel sometimes like you might as well be on 10 Meg Ethernet (or worse).

I'm not sure exactly what your application is here... It sounds backup
related. If you're doing rsync, you can win a little bit by dropping down a
level or two in your directory hierarchy from the top of the tree where XFS
is mounted, and running a number of rsync threads in parallel,
per-directory, instead of just one top-level rsync thread for an entire
filesystem. Experiment to find the best number of threads; run too many and
they can deadlock, or just step all over one another.

Also, I have a suspicion (sorry can't back this up quantitatively) that if
you are just trying to a straight copy from here to there, a 'cp -Rp' will
be faster than an rsync. You might be better off doing an initial copy with
'cp -Rp' and then just synchronizing diffs at the end with an rsync pass,
rather than trying to do the whole thing with rsync.

Hope some of this might help... just casual thoughts from a daily
XFS-wrangler ;)

Best,

Sean




On Fri, Sep 5, 2014 at 5:24 PM, Brian Foster <bfoster@redhat.com> wrote:

> On Fri, Sep 05, 2014 at 10:14:51PM +0200, Stefan Priebe wrote:
> >
> > Am 05.09.2014 21:18, schrieb Brian Foster:
> > ...
> >
> > >On Fri, Sep 05, 2014 at 08:07:38PM +0200, Stefan Priebe wrote:
> > >Interesting, that seems like a lot of free inodes. That's 1-2 million in
> > >each AG that we have to look around for each time we want to allocate an
> > >inode. I can't say for sure that's the source of the slowdown, but this
> > >certainly looks like the kind of workload that inspired the addition of
> > >the free inode btree (finobt) to more recent kernels.
> > >
> > >It appears that you still have quite a bit of space available in
> > >general. Could you run some local tests on this filesystem to try and
> > >quantify how much of this degradation manifests on sustained writes vs.
> > >file creation? For example, how is throughput when writing a few GB to a
> > >local test file?
> >
> > Not sure if this is what you expect:
> >
> > # dd if=/dev/zero of=bigfile oflag=direct,sync bs=4M count=1000
> > 1000+0 records in
> > 1000+0 records out
> > 4194304000 bytes (4,2 GB) copied, 125,809 s, 33,3 MB/s
> >
> > or without sync
> > # dd if=/dev/zero of=bigfile oflag=direct bs=4M count=1000
> > 1000+0 records in
> > 1000+0 records out
> > 4194304000 bytes (4,2 GB) copied, 32,5474 s, 129 MB/s
> >
> > > How about with that same amount of data broken up
> > >across a few thousand files?
> >
> > This results in heavy kworker usage.
> >
> > 4GB in 32kb files
> > # time (mkdir test; for i in $(seq 1 1 131072); do dd if=/dev/zero
> > of=test/$i bs=32k count=1 oflag=direct,sync 2>/dev/null; done)
> >
> > ...
> >
> > 55 min
> >
>
> Both seem pretty slow in general. Any way you can establish a baseline
> for these tests on this storage? If not, the only other suggestion I
> could make is to allocate inodes until all of those freecount numbers
> are accounted for and see if anything changes. That could certainly take
> some time and it's not clear it will actually help.
>
> > >Brian
> > >
> > >P.S., Alternatively if you wanted to grab a metadump of this filesystem
> > >and compress/upload it somewhere, I'd be interested to take a look at
> > >it.
> >
> > I think there might be file and directory names in it. If this is the
> case i
> > can't do it.
> >
>
> It should enable obfuscation by default, but I would suggest to restore
> it yourself and verify it meets your expectations.
>
> Brian
>
> > Stefan
> >
> >
> > >
> > >>Thanks!
> > >>
> > >>Stefan
> > >>
> > >>
> > >>
> > >>>Brian
> > >>>
> > >>>>>... as well as what your typical workflow/dataset is for this fs. It
> > >>>>>seems like you have relatively small files (15TB used across 350m
> files
> > >>>>>is around 46k per file), yes?
> > >>>>
> > >>>>Yes - most fo them are even smaller. And some files are > 5GB.
> > >>>>
> > >>>>>If so, I wonder if something like the
> > >>>>>following commit introduced in 3.12 would help:
> > >>>>>
> > >>>>>133eeb17 xfs: don't use speculative prealloc for small files
> > >>>>
> > >>>>Looks interesting.
> > >>>>
> > >>>>Stefan
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

--001a11c1f0da2a1c3e05025925d2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Stefan,</div><div><br></div>Generally speaking, th=
is is a situation that you want to avoid. At 350 million files and 20 TB, y=
ou&#39;re looking at around 17-18 MB per file at minimum? That&#39;s pretty=
 small. And with 350M files, a fair number of those 350M must be on the sma=
ller side of things.<div><br></div><div>Memory is cheap these days... peopl=
e can make 50 GB, 100 GB, ... files, go ahead and read those things directl=
y into memory, 100%. And CPU cycles are pretty cheap, too. Certainly you ge=
t more bang per buck there, than in IOPS on your storage system!!</div><div=
><br></div><div>Empirically, I have found from experience (currently runnin=
g Linux 3.4.61; many historical revs previous) in a reasonably large-scale =
(up to ~0.5 PB in single file system, up to 270 JBOD spindles on one machin=
e) high-I/O (jobs running on a few-hundred-node compute cluster, or a few h=
undred threads running locally on the server) environment, that XFS (and th=
ings running on top of it, ESPECIALLY rsync) will perform MUCH better on sm=
aller numbers of very large files, then they will on very large numbers of =
small files (I&#39;m always trying to reinforce this to our end users).</di=
v><div><br></div><div>I&#39;m not really even saying XFS is to really blame=
 here... in fact in 3.4.61 it has been very well-behaved; but Linux has man=
y warts: poor implementation of I/O and CPU scheduling algorithms; kernel d=
oes not degrade gracefully in resource-constrained settings; if you are ult=
imately using this data store as a file share, the protocol implementations=
 have their own issues... NFS, CIFS, etc... Not trying to dog all the hardw=
orking free software devs out there but clearly much work remains to be don=
e in many areas, to make Linux really ready to play in the &quot;big big le=
agues&quot; of computing (unless you have a local staff of good systems pro=
grammers with some free time on their hands...). XFS is just one piece of t=
he puzzle we have to work with in trying to integrate a Linux system as a g=
ood high-throughput storage machine.</div><div><br></div><div>If there is a=
ny way that you can use simple catenation or some kind of archiver... even =
things as simple as shar, tar, zip... to get the file sizes up and the abso=
lute number of files down, you should notice some big performance gains whe=
n trying to process your 20 TB worth of stuff.</div><div><br></div><div>If =
you can&#39;t dramatically increase individual file size while dramatically=
 reducing the absolute number of files for whatever reason in your environm=
ent, I think you can still win by trying to reduce the number of files in a=
ny one directory. You want to look out for directories that have five or si=
x figures worth of files in them, those can be real performance killers. If=
 your claim of no more than 5,000 files per any directory is accurate, that=
 shouldn&#39;t be a big deal for XFS at all, I don&#39;t think you&#39;re i=
n bad shape there.</div><div><br></div><div>Rsync can be just the worst in =
this kind of scenario. It runs so slow, you feel sometimes like you might a=
s well be on 10 Meg Ethernet (or worse).</div><div><br></div><div>I&#39;m n=
ot sure exactly what your application is here... It sounds backup related. =
If you&#39;re doing rsync, you can win a little bit by dropping down a leve=
l or two in your directory hierarchy from the top of the tree where XFS is =
mounted, and running a number of rsync threads in parallel, per-directory, =
instead of just one top-level rsync thread for an entire filesystem. Experi=
ment to find the best number of threads; run too many and they can deadlock=
, or just step all over one another.</div><div><br></div><div>Also, I have =
a suspicion (sorry can&#39;t back this up quantitatively) that if you are j=
ust trying to a straight copy from here to there, a &#39;cp -Rp&#39; will b=
e faster than an rsync. You might be better off doing an initial copy with =
&#39;cp -Rp&#39; and then just synchronizing diffs at the end with an rsync=
 pass, rather than trying to do the whole thing with rsync.</div><div><br><=
/div><div>Hope some of this might help... just casual thoughts from a daily=
 XFS-wrangler ;)</div><div><br></div><div>Best,</div><div><br></div><div>Se=
an</div><div><br></div><div><br></div></div><div class=3D"gmail_extra"><br>=
<br><div class=3D"gmail_quote">On Fri, Sep 5, 2014 at 5:24 PM, Brian Foster=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redhat.com" target=3D"_bla=
nk">bfoster@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex"><div class=3D"HOEnZb"><div class=3D"h5">On Fri, Sep 05, 2014 at 10:14:5=
1PM +0200, Stefan Priebe wrote:<br>
&gt;<br>
&gt; Am 05.09.2014 21:18, schrieb Brian Foster:<br>
&gt; ...<br>
&gt;<br>
&gt; &gt;On Fri, Sep 05, 2014 at 08:07:38PM +0200, Stefan Priebe wrote:<br>
&gt; &gt;Interesting, that seems like a lot of free inodes. That&#39;s 1-2 =
million in<br>
&gt; &gt;each AG that we have to look around for each time we want to alloc=
ate an<br>
&gt; &gt;inode. I can&#39;t say for sure that&#39;s the source of the slowd=
own, but this<br>
&gt; &gt;certainly looks like the kind of workload that inspired the additi=
on of<br>
&gt; &gt;the free inode btree (finobt) to more recent kernels.<br>
&gt; &gt;<br>
&gt; &gt;It appears that you still have quite a bit of space available in<b=
r>
&gt; &gt;general. Could you run some local tests on this filesystem to try =
and<br>
&gt; &gt;quantify how much of this degradation manifests on sustained write=
s vs.<br>
&gt; &gt;file creation? For example, how is throughput when writing a few G=
B to a<br>
&gt; &gt;local test file?<br>
&gt;<br>
&gt; Not sure if this is what you expect:<br>
&gt;<br>
&gt; # dd if=3D/dev/zero of=3Dbigfile oflag=3Ddirect,sync bs=3D4M count=3D1=
000<br>
&gt; 1000+0 records in<br>
&gt; 1000+0 records out<br>
&gt; 4194304000 bytes (4,2 GB) copied, 125,809 s, 33,3 MB/s<br>
&gt;<br>
&gt; or without sync<br>
&gt; # dd if=3D/dev/zero of=3Dbigfile oflag=3Ddirect bs=3D4M count=3D1000<b=
r>
&gt; 1000+0 records in<br>
&gt; 1000+0 records out<br>
&gt; 4194304000 bytes (4,2 GB) copied, 32,5474 s, 129 MB/s<br>
&gt;<br>
&gt; &gt; How about with that same amount of data broken up<br>
&gt; &gt;across a few thousand files?<br>
&gt;<br>
&gt; This results in heavy kworker usage.<br>
&gt;<br>
&gt; 4GB in 32kb files<br>
&gt; # time (mkdir test; for i in $(seq 1 1 131072); do dd if=3D/dev/zero<b=
r>
&gt; of=3Dtest/$i bs=3D32k count=3D1 oflag=3Ddirect,sync 2&gt;/dev/null; do=
ne)<br>
&gt;<br>
&gt; ...<br>
&gt;<br>
&gt; 55 min<br>
&gt;<br>
<br>
</div></div>Both seem pretty slow in general. Any way you can establish a b=
aseline<br>
for these tests on this storage? If not, the only other suggestion I<br>
could make is to allocate inodes until all of those freecount numbers<br>
are accounted for and see if anything changes. That could certainly take<br=
>
some time and it&#39;s not clear it will actually help.<br>
<span class=3D""><br>
&gt; &gt;Brian<br>
&gt; &gt;<br>
&gt; &gt;P.S., Alternatively if you wanted to grab a metadump of this files=
ystem<br>
&gt; &gt;and compress/upload it somewhere, I&#39;d be interested to take a =
look at<br>
&gt; &gt;it.<br>
&gt;<br>
&gt; I think there might be file and directory names in it. If this is the =
case i<br>
&gt; can&#39;t do it.<br>
&gt;<br>
<br>
</span>It should enable obfuscation by default, but I would suggest to rest=
ore<br>
it yourself and verify it meets your expectations.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Brian<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Stefan<br>
&gt;<br>
&gt;<br>
&gt; &gt;<br>
&gt; &gt;&gt;Thanks!<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt;Stefan<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt;&gt;Brian<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt;&gt;... as well as what your typical workflow/dataset =
is for this fs. It<br>
&gt; &gt;&gt;&gt;&gt;&gt;seems like you have relatively small files (15TB u=
sed across 350m files<br>
&gt; &gt;&gt;&gt;&gt;&gt;is around 46k per file), yes?<br>
&gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt;Yes - most fo them are even smaller. And some files ar=
e &gt; 5GB.<br>
&gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt;&gt;If so, I wonder if something like the<br>
&gt; &gt;&gt;&gt;&gt;&gt;following commit introduced in 3.12 would help:<br=
>
&gt; &gt;&gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt;&gt;133eeb17 xfs: don&#39;t use speculative prealloc f=
or small files<br>
&gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt;Looks interesting.<br>
&gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt;Stefan<br>
&gt;<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div><br></div>

--001a11c1f0da2a1c3e05025925d2--


--===============2164557425858334055==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2164557425858334055==--
