Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9NKwBXj064180 for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 15:58:12 -0500
Received: from mail-gw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 306A311F929
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 13:59:26 -0700 (PDT)
Received: from mail-gw0-f53.google.com (mail-gw0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id gwKIue2ngqqi6jVV
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 13:59:26 -0700 (PDT)
Received: by gwb1 with SMTP id 1so2267365gwb.26
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 13:59:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19651.15840.54770.942761@tree.ty.sabi.co.uk>
References: <AANLkTi=w1o8EF6-M7o8Qi9VpY-10m+MCR8U+K1_Aze=g@mail.gmail.com>
	<87eibm4xon.fsf@willster.local.flamingspork.com>
	<AANLkTikqHvSmr=WSZ3t8m3wKOGcUmQQ1v9Qx9MqGArS+@mail.gmail.com>
	<19651.15840.54770.942761@tree.ty.sabi.co.uk>
From: Angelo McComis <angelo@mccomis.com>
Date: Sat, 23 Oct 2010 16:59:06 -0400
Message-ID: <AANLkTikcgqA_cPLyMOXkgbu_PLkZRQ7qmch+LZdp_L6H@mail.gmail.com>
Subject: Re: XFS use within multi-threaded apps
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4402362706715295820=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.uk>
Cc: Linux XFS <xfs@oss.sgi.com>

--===============4402362706715295820==
Content-Type: multipart/alternative; boundary=000e0cd6ac92cdb63604934f0831

--000e0cd6ac92cdb63604934f0831
Content-Type: text/plain; charset=UTF-8

On Sat, Oct 23, 2010 at 3:56 PM, Peter Grandi <pg_xf2@xf2.for.sabi.co.uk>wrote:

> >>> I have a use case where I'd like to forward the use of XFS. This is for
> >>> large (multi-GB, say anywhere from 5GB to 300GB) individual files, such
> as
> >>> what you'd see under a database's data file / tablespace.
>
> >> Step 1) Use XFS.
> >> Nothing, and I do mean nothing comes close to reliability and consistent
> >> performance.
>
> > I have been running iozone benchmarks, [ ... ]
>
> I think that it is exceptionally difficult to get useful results
> out of Iozone...
>
>
True - the benchmarks themselves don't tell a complete story. Specific to
iozone, I was basically comparing XFS to EXT3, and showing the results
(various record sizes, various file sizes, and various worker thread
counts)... The only true benchmark is to run the application in the way that
is characteristic of how it will be used. Database benchmarks themselves
would vary greatly between use cases: from generic looking up data (random
reads), data warehouse analytics (sequential reads), ETL (sequential reads,
sequential writes), etc.


> >>> My database vendor (who, coincidentally markets their own
> >>> filesystems and operating systems) says that there are
> >>> certain problems under XFS with specific mention of
> >>> corruption issues, if a single root or the metadata become
> >>> corrupted, the entire filesystem is gone,
>
> If that's bad enough it applies to any file system out there
> except FAT and Reiser, as they store some metadata with each
> block. ZFS and BTRFS may have something similar. But it is not
> an issue.
>
> >>> and it has performance issues on a multi-threaded workload,
> >>> caused by the single root filesystem for metadata becoming a
> >>> bottleneck.
>
> That's actually more of a problem with Lustre, in extreme cases.
>
> >> XFS has anything but performance problems on multithreaded
> >> workloads. It is *the* best of the Linux filesystems
> >> (actually... possibly any file system anywhere) for
> >> multithreaded IO.
>
> That's actually multithreaded IO to the same file, for
> multithreaded IO to different files JFS (and allegedly 'ext4') are
> also fairly good.
>
> > Well - I mentioned it above. Their current recommendation for
> > Linux is to stick with ext3... and for big file/big IO
> > operations, switch to ext4.
>
> That's just about because those are the file systems that are
> "qualified", and 'ext3' defaults give the lowest risks in case the
> application environment is misdesigned and relies on 'O_PONIES'.
>
> > [ ... ] "well, ext3 has problems whenever the kernel journal
> > thread wakes up to flush under heavy I/O,
>
> That actually happens with every file system, and it is one of
> several naive misdesigns in the Linux IO subsystem. The default
> Linux page cache flusher parameters are often too "loose" by a 1-2
> orders of magnitude, and this can cause serious problems. Nedver
> mind that the page cache
>
>
> In any case the Linux page cache itself is also a bit of a joke, a
> (hopefully) a DBMS will not use it anyhow, but use direct IO, and
> XFS is targeted at direct IO, large file, multistreaming loads.
>
>
Peter, and others:

Thanks for this great discussion. I appreciate the thought that went into
all of the replies.

In the end, we had a sit down discussion with our vendor.  They admitted
that they "support" XFS, but have very few customers using it (said they can
count them on one hand), and when I pressed them on if it's a technology
limitation, they threw down the gauntlet and said "look, we're giving you
our frank recommendation here. EXT3."  They quoted as having 10+TB databases
running OLTP transactions on XFS, with 4-5GB/sec sustained throughput to the
disk system.  And 20-30TB for data warehouse type operations.  When pressed
about the cache flush issue, they mentioned they use direct IO under ext3,
and it's not an issue in that case.

In doing my research, I searched for references of other Fortune nn-sized
companies who use this DB and use XFS underneath it. I came up empty
handed...  I searched my network for large-ish companies using XFS, and how
they were using it.  I'm not sure if we're bordering on "secret sauce" type
stuff here, but I had an extremely difficult time getting enterprise
references to back up the research I've done.

For our use, we had to opt to follow the vendor recommendation, and it came
down to not wanting to be one of those that they can count on one hand using
XFS with their product.

I'm still confounded by why - when XFS is technically superior in these
cases - is it so obscure?  Are Enterprise Linux guys just not looking this
deep under the covers to uncover performance enhancements like this? Is it
because RedHat didn't to include the XFS tools in the distro until recently,
causing XFS to not be a choice part of it? Are other Linux folks "next,
next, finish..." people when it comes to how they install?  I really don't
get it.

Thanks for all the discussion folks. I hope to put forth other use cases as
the surface.

--000e0cd6ac92cdb63604934f0831
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 23, 2010 at 3:56 PM, Peter Grandi <span dir=3D"ltr">&lt;<a href=
=3D"mailto:pg_xf2@xf2.for.sabi.co.uk">pg_xf2@xf2.for.sabi.co.uk</a>&gt;</sp=
an> wrote:<br><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" =
style=3D"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 20=
4); padding-left: 1ex;">

<div class=3D"im">&gt;&gt;&gt; I have a use case where I&#39;d like to forw=
ard the use of XFS. This is for<br>
&gt;&gt;&gt; large (multi-GB, say anywhere from 5GB to 300GB) individual fi=
les, such as<br>
&gt;&gt;&gt; what you&#39;d see under a database&#39;s data file / tablespa=
ce.<br>
<br>
</div><div class=3D"im">&gt;&gt; Step 1) Use XFS.<br>
&gt;&gt; Nothing, and I do mean nothing comes close to reliability and cons=
istent<br>
&gt;&gt; performance.<br>
<br>
</div>&gt; I have been running iozone benchmarks, [ ... ]<br>
<br>
I think that it is exceptionally difficult to get useful results<br>
out of Iozone...<br>
<div class=3D"im"><br></div></blockquote><div><br>True - the benchmarks the=
mselves don&#39;t tell a complete story. Specific to iozone, I was basicall=
y comparing XFS to EXT3, and showing the results (various record sizes, var=
ious file sizes, and various worker thread counts)... The only true benchma=
rk is to run the application in the way that is characteristic of how it wi=
ll be used. Database benchmarks themselves would vary greatly between use c=
ases: from generic looking up data (random reads), data warehouse analytics=
 (sequential reads), ETL (sequential reads, sequential writes), etc.=C2=A0 =
<br>

=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 0pt =
0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;"><div =
class=3D"im">
&gt;&gt;&gt; My database vendor (who, coincidentally markets their own<br>
&gt;&gt;&gt; filesystems and operating systems) says that there are<br>
&gt;&gt;&gt; certain problems under XFS with specific mention of<br>
&gt;&gt;&gt; corruption issues, if a single root or the metadata become<br>
&gt;&gt;&gt; corrupted, the entire filesystem is gone,<br>
<br>
</div>If that&#39;s bad enough it applies to any file system out there<br>
except FAT and Reiser, as they store some metadata with each<br>
block. ZFS and BTRFS may have something similar. But it is not<br>
an issue.<br>
<div class=3D"im"><br></div></blockquote><div></div><blockquote class=3D"gm=
ail_quote" style=3D"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(2=
04, 204, 204); padding-left: 1ex;"><div class=3D"im">&gt;&gt;&gt; and it ha=
s performance issues on a multi-threaded workload,<br>


&gt;&gt;&gt; caused by the single root filesystem for metadata becoming a<b=
r>
&gt;&gt;&gt; bottleneck.<br>
<br>
</div>That&#39;s actually more of a problem with Lustre, in extreme cases.<=
br>
<div class=3D"im"><br>
&gt;&gt; XFS has anything but performance problems on multithreaded<br>
&gt;&gt; workloads. It is *the* best of the Linux filesystems<br>
&gt;&gt; (actually... possibly any file system anywhere) for<br>
&gt;&gt; multithreaded IO.<br>
<br>
</div>That&#39;s actually multithreaded IO to the same file, for<br>
multithreaded IO to different files JFS (and allegedly &#39;ext4&#39;) are<=
br>
also fairly good.<br>
<div class=3D"im"><br>
&gt; Well - I mentioned it above. Their current recommendation for<br>
&gt; Linux is to stick with ext3... and for big file/big IO<br>
&gt; operations, switch to ext4.<br>
<br>
</div>That&#39;s just about because those are the file systems that are<br>
&quot;qualified&quot;, and &#39;ext3&#39; defaults give the lowest risks in=
 case the<br>
application environment is misdesigned and relies on &#39;O_PONIES&#39;.<br=
>
<br>
&gt; [ ... ] &quot;well, ext3 has problems whenever the kernel journal<br>
<div class=3D"im">&gt; thread wakes up to flush under heavy I/O,<br>
<br>
</div>That actually happens with every file system, and it is one of<br>
several naive misdesigns in the Linux IO subsystem. The default<br>
Linux page cache flusher parameters are often too &quot;loose&quot; by a 1-=
2<br>
orders of magnitude, and this can cause serious problems. Nedver<br>
mind that the page cache<br>
<br>
<br>
In any case the Linux page cache itself is also a bit of a joke, a<br>
(hopefully) a DBMS will not use it anyhow, but use direct IO, and<br>
XFS is targeted at direct IO, large file, multistreaming loads.<br>
<br></blockquote><div><br>Peter, and others:<br>=C2=A0 <br>Thanks for this =
great discussion. I appreciate the thought that went into all of the replie=
s.<br><br>In the end, we had a sit down discussion with our vendor.=C2=A0 T=
hey admitted that they &quot;support&quot; XFS, but have very few customers=
 using it (said they can count them on one hand), and when I pressed them o=
n if it&#39;s a technology limitation, they threw down the gauntlet and sai=
d &quot;look, we&#39;re giving you our frank recommendation here. EXT3.&quo=
t;=C2=A0 They quoted as having 10+TB databases running OLTP transactions on=
 XFS, with 4-5GB/sec sustained throughput to the disk system.=C2=A0 And 20-=
30TB for data warehouse type operations.=C2=A0 When pressed about the cache=
 flush issue, they mentioned they use direct IO under ext3, and it&#39;s no=
t an issue in that case.<br>

<br>In doing my research, I searched for references of other Fortune nn-siz=
ed companies who use this DB and use XFS underneath it. I came up empty han=
ded...=C2=A0 I searched my network for large-ish companies using XFS, and h=
ow they were using it.=C2=A0 I&#39;m not sure if we&#39;re bordering on &qu=
ot;secret sauce&quot; type stuff here, but I had an extremely difficult tim=
e getting enterprise references to back up the research I&#39;ve done. <br>

<br>For our use, we had to opt to follow the vendor recommendation, and it =
came down to not wanting to be one of those that they can count on one hand=
 using XFS with their product. <br><br>I&#39;m still confounded by why - wh=
en XFS is technically superior in these cases - is it so obscure?=C2=A0 Are=
 Enterprise Linux guys just not looking this deep under the covers to uncov=
er performance enhancements like this? Is it because RedHat didn&#39;t to i=
nclude the XFS tools in the distro until recently, causing XFS to not be a =
choice part of it? Are other Linux folks &quot;next, next, finish...&quot; =
people when it comes to how they install?=C2=A0 I really don&#39;t get it. =
<br>

<br>Thanks for all the discussion folks. I hope to put forth other use case=
s as the surface.<br><br><br><br><br><br><br></div></div>

--000e0cd6ac92cdb63604934f0831--


--===============4402362706715295820==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4402362706715295820==--
