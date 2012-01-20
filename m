Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0KF73AM110477
	for <linux-xfs@oss.sgi.com>; Fri, 20 Jan 2012 09:07:03 -0600
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id G1NECRE4veMFDLJH
	for <linux-xfs@oss.sgi.com>; Fri, 20 Jan 2012 07:07:01 -0800 (PST)
Received: by yhjj56 with SMTP id j56so388010yhj.26
	for <linux-xfs@oss.sgi.com>; Fri, 20 Jan 2012 07:07:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F192B8C.1050406@tlinx.org>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116232549.GC6922@dastard>
	<CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
	<4F192B8C.1050406@tlinx.org>
Date: Fri, 20 Jan 2012 10:07:01 -0500
Message-ID: <CAFLer83sQz+=UOcxtq_O+-qUU+q4_kEYq-0fBdURPLtR=XGDZQ@mail.gmail.com>
Subject: Re: concurrent direct IO write in xfs
From: Zheng Da <zhengda1936@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2434509537441385164=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linda Walsh <xfs@tlinx.org>
Cc: Linux-Xfs <linux-xfs@oss.sgi.com>

--===============2434509537441385164==
Content-Type: multipart/alternative; boundary=20cf30563f4d70337104b6f70879

--20cf30563f4d70337104b6f70879
Content-Type: text/plain; charset=ISO-8859-1

Helllo

On Fri, Jan 20, 2012 at 3:53 AM, Linda Walsh <xfs@tlinx.org> wrote:

>
>
> Zheng Da wrote:
>
>>
>> I create a file of 4GB in XFS (the ramdisk has 5GB of space). My test
>> program overwrites 4G of data to the file
>>
> ----
>        It sounds like you are asking why multiple threads don't
> move memory from one point to another point in memory at a faster rate
> than one thread alone.
>
> I.e. if you had 2 processes doing an assembly instruction, memmov to move
> a chunk of memory from 1 area to another, would you expect to do the move
> any faster if you had 2 processors doing the move vs. 1??
>
Yes. Actually, for reading, using multiple threads is faster than a single
thread.
If you try simple memory copy with memcpy in the C library, the overall
throughput will still increase if you use multiple processors.

>
> I think the limiting factor (unless you have a slow processor and some
> REALLY fast memory, but stock x86-64 parts, today have memory running about
> 2-4 times slower than the processor -- so the memory is usually the
> bottleneck.
>
Memory bandwidth will eventually become a bottleneck, but it can still
scale for a small number of processors.

>
> Two processes wouldn't do it any faster, and might actually do it slower
> due to
> resource contention issues -- I would *think*... but I really don't know
> the
> details of how writing from mem2mem and having the target be in the format
> of
> and xfs file system, would cause cpu-bound delays that would be
> significant to
> change the fact that m2m operations are usually mem-bandwidth limited...?
>
> (I don't know the answers, just clarifying what you are asking)...
>
> Da

--20cf30563f4d70337104b6f70879
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Helllo<br><br><div class=3D"gmail_quote">On Fri, Jan 20, 2012 at 3:53 AM, L=
inda Walsh <span dir=3D"ltr">&lt;<a href=3D"mailto:xfs@tlinx.org">xfs@tlinx=
.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im"><br>
<br>
Zheng Da wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
I create a file of 4GB in XFS (the ramdisk has 5GB of space). My test progr=
am overwrites 4G of data to the file =A0<br>
</blockquote></div>
----<br>
 =A0 =A0 =A0 =A0It sounds like you are asking why multiple threads don&#39;=
t<br>
move memory from one point to another point in memory at a faster rate<br>
than one thread alone.<br>
<br>
I.e. if you had 2 processes doing an assembly instruction, memmov to move<b=
r>
a chunk of memory from 1 area to another, would you expect to do the move<b=
r>
any faster if you had 2 processors doing the move vs. 1??<br></blockquote><=
div>Yes. Actually, for reading, using multiple threads is faster than a sin=
gle thread.=A0</div><div>If you try simple memory copy with memcpy in the C=
 library, the overall throughput will still increase if you use multiple pr=
ocessors.</div>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
I think the limiting factor (unless you have a slow processor and some<br>
REALLY fast memory, but stock x86-64 parts, today have memory running about=
<br>
2-4 times slower than the processor -- so the memory is usually the bottlen=
eck.<br></blockquote><div>Memory bandwidth will eventually become a bottlen=
eck, but it can still scale for a small number of processors.=A0</div><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #cc=
c solid;padding-left:1ex">

<br>
Two processes wouldn&#39;t do it any faster, and might actually do it slowe=
r due to<br>
resource contention issues -- I would *think*... but I really don&#39;t kno=
w the<br>
details of how writing from mem2mem and having the target be in the format =
of<br>
and xfs file system, would cause cpu-bound delays that would be significant=
 to<br>
change the fact that m2m operations are usually mem-bandwidth limited...?<b=
r>
<br>
(I don&#39;t know the answers, just clarifying what you are asking)...<br><=
br></blockquote><div>Da=A0</div></div><br>

--20cf30563f4d70337104b6f70879--


--===============2434509537441385164==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2434509537441385164==--
