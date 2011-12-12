Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBC0exbQ062927 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 18:41:00 -0600
Received: from mail-gx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CCBD16EE47B
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 16:40:57 -0800 (PST)
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	HPEvh9f99sIj0CuF for <xfs@oss.sgi.com>;
	Sun, 11 Dec 2011 16:40:57 -0800 (PST)
Received: by ggnr5 with SMTP id r5so44544ggn.26
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 16:40:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111211233929.GI14273@dastard>
References: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
	<20111211233929.GI14273@dastard>
From: Xupeng Yun <xupeng@xupeng.me>
Date: Mon, 12 Dec 2011 08:40:15 +0800
Message-ID: <CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6248925681226680509=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: XFS group <xfs@oss.sgi.com>

--===============6248925681226680509==
Content-Type: multipart/alternative; boundary=e89a8f2358e140576c04b3da631a

--e89a8f2358e140576c04b3da631a
Content-Type: text/plain; charset=UTF-8

On Mon, Dec 12, 2011 at 07:39, Dave Chinner <david@fromorbit.com> wrote:
>
> > ====== XFS + 2.6.29 ======
>
> Read 21GB @ 11k iops, 210MB/s, av latency of 1.3ms/IO
> Wrote 2.3GB @ 1250 iops, 20MB/s, av latency of 0.27ms/IO
> Total 1.5m IOs, 95% @ <= 2ms
>
> > ====== XFS + 2.6.39 ======
>
> Read 6.5GB @ 3.5k iops, 55MB/s, av latency of 4.5ms/IO
> Wrote 700MB @ 386 iops, 6MB/s, av latency of 0.39ms/IO
> Total 460k IOs, 95% @ <= 10ms, 4ms > 50% < 10ms
>
> Looking at the IO stats there, this doesn't look to me like an XFS
> problem. The IO times are much, much longer on 2.6.39, so that's the
> first thing to understand. If the two tests are doing identical IO
> patterns, then I'd be looking at validating raw device performance
> first.
>

Thank you Dave.

I also did raw device and ext4 performance test with 2.6.39, all these
tests are
doing identical IO patterns(non-buffered IO, 16 IO threads, 16KB block size,
mixed random read and write, r:w=9:1):
====== raw device + 2.6.39 ======
Read 21.7GB @ 11.6k IOPS , 185MB/s, av latency of 1.37 ms/IO
Wrote 2.4GB @ 1.3k IOPS, 20MB/s, av latency of 0.095 ms/IO
Total 1.5M IOs, @ 96% <= 2ms

====== ext4 + 2.6.39 ======
Read 21.7GB @ 11.6k IOPS , 185MB/s, av latency of 1.37 ms/IO
Wrote 2.4GB @ 1.3k IOPS, 20MB/s, av latency of 0.1 ms/IO
Total 1.5M IOs, @ 96% <= 2ms

====== XFS + 2.6.39 ======
Read 6.5GB @ 3.5k iops, 55MB/s, av latency of 4.5ms/IO
Wrote 700MB @ 386 iops, 6MB/s, av latency of 0.39ms/IO
Total 460k IOs, @ 95% <= 10ms, 4ms > 50% < 10ms

here are the detailed test results:
== 2.6.39 ==
http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.39-xfs.txt
http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.39-ext4.txt
http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.39-raw.txt

== 2.6.29 ==
http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.29-xfs.txt
http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.29-ext4.txt
http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.29-raw.txt

>
> > I tried different XFS format options and different mount options, but
> > it did not help.
>
> It won't if the problem is inthe layers below XFS.
>
> e.g. IO scheduler behavioural changes could be the cause (esp. if
> you are using CFQ), the SSD could be in different states or running
> garbage collection intermittently and slowing things down, the
> filesystem could be in different states (did you use a fresh
> filesystem for each of these tests?), etc, recent mkfs.xfs will trim
> the entire device if the kernel supports it, etc.


I did all the tests on the same server with deadline scheduler, and
xfsprogs version
is 3.1.4. I also ran tests with noop scheduler, but not big difference.

--
Xupeng Yun
http://about.me/xupeng

--e89a8f2358e140576c04b3da631a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>On Mon, Dec 12, 2011 at 07:39, Dave Chinner &lt;<a href=3D"mailto:d=
avid@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>&gt;<br>&gt; &gt;=
 =3D=3D=3D=3D=3D=3D XFS + 2.6.29 =3D=3D=3D=3D=3D=3D<br>&gt;<br>&gt; Read 21=
GB @ 11k iops, 210MB/s, av latency of 1.3ms/IO<br>

&gt; Wrote 2.3GB @ 1250 iops, 20MB/s, av latency of 0.27ms/IO<br>&gt; Total=
 1.5m IOs, 95% @ &lt;=3D 2ms<br>&gt;<br>&gt; &gt; =3D=3D=3D=3D=3D=3D XFS + =
2.6.39 =3D=3D=3D=3D=3D=3D<br>&gt;<br>&gt; Read 6.5GB @ 3.5k iops, 55MB/s, a=
v latency of 4.5ms/IO<br>

&gt; Wrote 700MB @ 386 iops, 6MB/s, av latency of 0.39ms/IO<br>&gt; Total 4=
60k IOs, 95% @ &lt;=3D 10ms, 4ms &gt; 50% &lt; 10ms<br>&gt;<br>&gt; Looking=
 at the IO stats there, this doesn&#39;t look to me like an XFS<br>&gt; pro=
blem. The IO times are much, much longer on 2.6.39, so that&#39;s the<br>

&gt; first thing to understand. If the two tests are doing identical IO<br>=
&gt; patterns, then I&#39;d be looking at validating raw device performance=
<br>&gt; first.<br>&gt;<br><br><div>Thank you Dave.<br><div><br>I also did =
raw device and ext4 performance test with 2.6.39, all these tests are<br>

doing identical IO patterns(non-buffered IO, 16 IO threads, 16KB block size=
,<br>mixed random=C2=A0read and write, r:w=3D9:1):<br>=3D=3D=3D=3D=3D=3D ra=
w device + 2.6.39 =3D=3D=3D=3D=3D=3D<br>Read 21.7GB @ 11.6k IOPS , 185MB/s,=
 av latency of 1.37 ms/IO<br>

Wrote 2.4GB @ 1.3k IOPS, 20MB/s, av latency of 0.095 ms/IO<br>Total 1.5M IO=
s, @ 96% &lt;=3D 2ms<br><br>=3D=3D=3D=3D=3D=3D ext4 + 2.6.39 =3D=3D=3D=3D=
=3D=3D<br>Read 21.7GB @ 11.6k IOPS , 185MB/s, av latency of 1.37 ms/IO<br>W=
rote 2.4GB @ 1.3k IOPS, 20MB/s, av latency of 0.1 ms/IO<br>

Total 1.5M IOs, @ 96% &lt;=3D 2ms<br><br>=3D=3D=3D=3D=3D=3D XFS + 2.6.39 =
=3D=3D=3D=3D=3D=3D<br>Read 6.5GB @ 3.5k iops, 55MB/s, av latency of 4.5ms/I=
O<br>Wrote 700MB @ 386 iops, 6MB/s, av latency of 0.39ms/IO<br>Total 460k I=
Os, @ 95% &lt;=3D 10ms, 4ms &gt; 50% &lt; 10ms<br>

<br>here are the detailed test results:<div>=3D=3D 2.6.39 =3D=3D<br><a href=
=3D"http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.39-xfs.txt">=
http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.39-xfs.txt</a><b=
r><a href=3D"http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.39-=
ext4.txt">http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.39-ext=
4.txt</a><br>

<a href=3D"http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.39-ra=
w.txt">http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.39-raw.tx=
t</a><div><br></div><div>=3D=3D 2.6.29 =3D=3D</div><div><a href=3D"http://b=
log.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.29-xfs.txt">http://blog.=
xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.29-xfs.txt</a><br>

<a href=3D"http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.29-ex=
t4.txt">http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.6.29-ext4.=
txt</a><br><a href=3D"http://blog.xupeng.me/wp-content/uploads/ext4-xfs-per=
f/2.6.29-raw.txt">http://blog.xupeng.me/wp-content/uploads/ext4-xfs-perf/2.=
6.29-raw.txt</a></div>

<div><br>&gt;<br>&gt; &gt; I tried different XFS format options and differe=
nt mount options, but<br>&gt; &gt; it did not help.<br>&gt;<br>&gt; It won&=
#39;t if the problem is inthe layers below XFS.<br>&gt;<br>&gt; e.g. IO sch=
eduler behavioural changes could be the cause (esp. if<br>

&gt; you are using CFQ), the SSD could be in different states or running<br=
>&gt; garbage collection intermittently and slowing things down, the<br>&gt=
; filesystem could be in different states (did you use a fresh<br>&gt; file=
system for each of these tests?), etc, recent mkfs.xfs will trim<br>

&gt; the entire device if the kernel supports it, etc.<br><br><br>I did all=
 the tests on the same server with=C2=A0deadline scheduler, and xfsprogs ve=
rsion<br>is=C2=A03.1.4. I also ran tests with noop scheduler, but not big d=
ifference.<br>

<br>--<br>Xupeng Yun<br><a href=3D"http://about.me/xupeng">http://about.me/=
xupeng</a></div></div></div></div>

--e89a8f2358e140576c04b3da631a--


--===============6248925681226680509==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6248925681226680509==--
