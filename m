Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KBxuTo061820 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 06:59:56 -0500
Received: from mail-yw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F4124F37029
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 05:16:08 -0700 (PDT)
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id A4m47murpY2fDyO3
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 05:16:08 -0700 (PDT)
Received: by ywo7 with SMTP id 7so2387123ywo.26
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 05:01:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87eibm4xon.fsf@willster.local.flamingspork.com>
References: <AANLkTi=w1o8EF6-M7o8Qi9VpY-10m+MCR8U+K1_Aze=g@mail.gmail.com>
	<87eibm4xon.fsf@willster.local.flamingspork.com>
From: Angelo McComis <angelo@mccomis.com>
Date: Wed, 20 Oct 2010 08:00:47 -0400
Message-ID: <AANLkTikqHvSmr=WSZ3t8m3wKOGcUmQQ1v9Qx9MqGArS+@mail.gmail.com>
Subject: Re: XFS use within multi-threaded apps
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1867651476110358436=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stewart Smith <stewart@flamingspork.com>
Cc: xfs@oss.sgi.com

--===============1867651476110358436==
Content-Type: multipart/alternative; boundary=000e0cd40578258f6904930b2a9b

--000e0cd40578258f6904930b2a9b
Content-Type: text/plain; charset=UTF-8

Stewart, and others:

On Tue, Oct 19, 2010 at 12:24 AM, Stewart Smith <stewart@flamingspork.com>wrote:

> On Mon, 18 Oct 2010 09:42:04 -0400, Angelo McComis <angelo@mccomis.com>
> wrote:
> > I have a use case where I'd like to forward the use of XFS. This is for
> > large (multi-GB, say anywhere from 5GB to 300GB) individual files, such
> as
> > what you'd see under a database's data file / tablespace.
>
> The general advice from not only those of us who hack on database
> systems for a living (and hobby), but those that also run it in
> production on more systems than you'll ever be able to count is this for
> database system performance tuning (i.e. after making your SQL not
> completely nuts)
>
> Step 1) Use XFS.
>
> Nothing, and I do mean nothing comes close to reliability and consistent
> performance.
>
> We've seen various benchmarks where X was faster.... most of the
> time. Then suddenly your filesystem takes a mutex for 15 seconds and
> you're database performance goes down the crapper.
>
>
I have been running iozone benchmarks, both head to head ext3 versus XFS,
single LUN, default mkfs options, etc.  And the short answer is XFS wins
hands down on writes and random writes.  Ext3 wins a couple of the other
tests, but not by nearly the margin that XFS wins on the other ones.  That
was the KB/sec tests. The IOPS test was even more telling, and showed XFS
winning by orders of magnitudes on a few tests, and being close or a tie on
the ones that it didn't win.  I took two SAN luns and ran local FS versus
SAN-presented (this is FC, attached to IBM DS8k storage), and ran the tests
there.  When done with the head to head tests, I concatenated the LUNS to
make a RAID 0 / simple 2-stripe set, and ran the tests some more.

I can't say that the numbers make a lot of sense, since it's a 4gbit FC
connection


>  > My database vendor (who, coincidentally markets their own filesystems
> and
> > operating systems) says that there are certain problems under XFS with
> > specific mention of corruption issues, if a single root or the metadata
> > become corrupted, the entire filesystem is gone, and it has performance
> > issues on a multi-threaded workload, caused by the single root filesystem
> > for metadata becoming a bottleneck.
>
> XFS has anything but performance problems on multithreaded
> workloads. It is *the* best of the Linux filesystems
> (actually... possibly any file system anywhere) for multithreaded
> IO. You can either benchmark it or go and read the source - check out
> the direct IO codepaths and what locks get taken (or rather, what locks
> aren't taken).
>
> Generally speaking, most DBMSs don't do much filesystem metadata
> operations, the most common being extending the data file. So what you
> really care about is multithreaded direct IO performance, scalability
> and reliability.
>
> > This feedback from the vendor is surely taken with a grain of salt as
> they
> > have marketing motivations of their own product to consider.
>
> If the vendor is who I suspect, and the filesystem being pushed is
> starting with two letters down the alphabet than XFS... I
> wouldn't. While a great file system for a number of applications, it is
> nowhere near ready for big database IO loads - to the extent that last I
> heard it still wasn't being recommended for the various DBs I care about
> (at least by the DB support guys).
>

Well -  I mentioned it above. Their current recommendation for Linux is to
stick with ext3... and for big file/big IO operations, switch to ext4. And
we had a meeting wherein we had a discussion that went like "well, ext3 has
problems whenever the kernel journal thread wakes up to flush under heavy
I/O, and ext4
is not available to us..."  and Dave Chinner on an earlier post regarding
the maturity level of ext4 and its present status.

I have been able to schedule a meeting with the folks at my vendor, on the
database software side. Aside from the questions I have, points to make,
etc., I'm curious if there's anything else, based on anyone here's input, I
should be asking them? This is a pretty grand opportunity to sit down and
grill them.

Thanks to everyone who participates on this list - you are all a great
resource and a perfect example of what the open source community is all
about.

Regards,
Angelo

--000e0cd40578258f6904930b2a9b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<font color=3D"#000066"><font size=3D"2"><font face=3D"trebuchet ms,sans-se=
rif">Stewart, and others:<br><br></font></font></font>On Tue, Oct 19, 2010 =
at 12:24 AM, Stewart Smith <span dir=3D"ltr">&lt;<a href=3D"mailto:stewart@=
flamingspork.com">stewart@flamingspork.com</a>&gt;</span> wrote:<br>

<div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margi=
n: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-le=
ft: 1ex;"><div class=3D"im">On Mon, 18 Oct 2010 09:42:04 -0400, Angelo McCo=
mis &lt;<a href=3D"mailto:angelo@mccomis.com">angelo@mccomis.com</a>&gt; wr=
ote:<br>


&gt; I have a use case where I&#39;d like to forward the use of XFS. This i=
s for<br>
&gt; large (multi-GB, say anywhere from 5GB to 300GB) individual files, suc=
h as<br>
&gt; what you&#39;d see under a database&#39;s data file / tablespace.<br>
<br>
</div>The general advice from not only those of us who hack on database<br>
systems for a living (and hobby), but those that also run it in<br>
production on more systems than you&#39;ll ever be able to count is this fo=
r<br>
database system performance tuning (i.e. after making your SQL not<br>
completely nuts)<br>
<br>
Step 1) Use XFS.<br>
<br>
Nothing, and I do mean nothing comes close to reliability and consistent<br=
>
performance.<br>
<br>
We&#39;ve seen various benchmarks where X was faster.... most of the<br>
time. Then suddenly your filesystem takes a mutex for 15 seconds and<br>
you&#39;re database performance goes down the crapper.<br>
<div class=3D"im"><br></div></blockquote><div><br>I have been running iozon=
e benchmarks, both head to head ext3 versus XFS, single LUN, default mkfs o=
ptions, etc.=C2=A0 And the short answer is XFS wins hands down on writes an=
d random writes.=C2=A0 Ext3 wins a couple of the other tests, but not by ne=
arly the margin that XFS wins on the other ones.=C2=A0 That was the KB/sec =
tests. The IOPS test was even more telling, and showed XFS winning by order=
s of magnitudes on a few tests, and being close or a tie on the ones that i=
t didn&#39;t win.=C2=A0 I took two SAN luns and ran local FS versus SAN-pre=
sented (this is FC, attached to IBM DS8k storage), and ran the tests there.=
=C2=A0 When done with the head to head tests, I concatenated the LUNS to ma=
ke a RAID 0 / simple 2-stripe set, and ran the tests some more.<br>

<br>I can&#39;t say that the numbers make a lot of sense, since it&#39;s a =
4gbit FC connection<br>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); p=
adding-left: 1ex;">

<div class=3D"im">
&gt; My database vendor (who, coincidentally markets their own filesystems =
and<br>
&gt; operating systems) says that there are certain problems under XFS with=
<br>
&gt; specific mention of corruption issues, if a single root or the metadat=
a<br>
&gt; become corrupted, the entire filesystem is gone, and it has performanc=
e<br>
&gt; issues on a multi-threaded workload, caused by the single root filesys=
tem<br>
&gt; for metadata becoming a bottleneck.<br>
<br>
</div>XFS has anything but performance problems on multithreaded<br>
workloads. It is *the* best of the Linux filesystems<br>
(actually... possibly any file system anywhere) for multithreaded<br>
IO. You can either benchmark it or go and read the source - check out<br>
the direct IO codepaths and what locks get taken (or rather, what locks<br>
aren&#39;t taken).<br>
<br>
Generally speaking, most DBMSs don&#39;t do much filesystem metadata<br>
operations, the most common being extending the data file. So what you<br>
really care about is multithreaded direct IO performance, scalability<br>
and reliability.<br>
<div class=3D"im"><br>
&gt; This feedback from the vendor is surely taken with a grain of salt as =
they<br>
&gt; have marketing motivations of their own product to consider.<br>
<br>
</div>If the vendor is who I suspect, and the filesystem being pushed is<br=
>
starting with two letters down the alphabet than XFS... I<br>
wouldn&#39;t. While a great file system for a number of applications, it is=
<br>
nowhere near ready for big database IO loads - to the extent that last I<br=
>
heard it still wasn&#39;t being recommended for the various DBs I care abou=
t<br>
(at least by the DB support guys).<br>
</blockquote><div><br>Well -=C2=A0 I mentioned it above. Their current reco=
mmendation for Linux is to stick with ext3... and for big file/big IO opera=
tions, switch to ext4. And we had a meeting wherein we had a discussion tha=
t went like &quot;well, ext3 has problems whenever the kernel journal threa=
d wakes up to flush under heavy I/O, and ext4<br>

is not available to us...&quot;=C2=A0 and Dave Chinner on an earlier post r=
egarding the maturity level of ext4 and its present status.<br><br>I have b=
een able to schedule a meeting with the folks at my vendor, on the database=
 software side. Aside from the questions I have, points to make, etc., I&#3=
9;m curious if there&#39;s anything else, based on anyone here&#39;s input,=
 I should be asking them? This is a pretty grand opportunity to sit down an=
d grill them. <br>

</div><br>Thanks to everyone who participates on this list - you are all a =
great resource and a perfect example of what the open source community is a=
ll about.<br><br>Regards,<br>Angelo<br><br></div>

--000e0cd40578258f6904930b2a9b--


--===============1867651476110358436==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1867651476110358436==--
