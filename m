Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB7737F7B
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 16:23:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 302EFAC001
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 14:23:31 -0800 (PST)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
	[209.85.217.170]) by cuda.sgi.com with ESMTP id
	FWrl3UMK6IYl8OYc (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 14:23:29 -0800 (PST)
Received: by mail-lb0-f170.google.com with SMTP id ge1so2644608lbb.1
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 14:23:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEWpfG_imbrJiCYMXntQt3fxkj=F89QkTO4Y-ztAo_5c83-qvA@mail.gmail.com>
References: <CAEWpfG_DKJt1MmWS1tARH4OmYwpSt=A-DzwKkGcD67LuR6k=Bg@mail.gmail.com>
	<20130225221639.GJ5551@dastard>
	<CAEWpfG_imbrJiCYMXntQt3fxkj=F89QkTO4Y-ztAo_5c83-qvA@mail.gmail.com>
Date: Mon, 25 Feb 2013 16:23:28 -0600
Message-ID: <CAEWpfG8dw81qoRotmCLrutNBsXarF-63dHVWEGtsjtbd+HTsmw@mail.gmail.com>
Subject: Re: Consistent throughput challenge -- fragmentation?
From: Brian Cain <brian.cain@gmail.com>
Content-Type: multipart/mixed; boundary=f46d042f96428059fc04d693fd91
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--f46d042f96428059fc04d693fd91
Content-Type: multipart/alternative; boundary=f46d042f96428059ef04d693fd8f

--f46d042f96428059ef04d693fd8f
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Feb 25, 2013 at 4:18 PM, Brian Cain <brian.cain@gmail.com> wrote:

> Here's the info from the FAQ, I'll bundle up the benchmarks.
>
>
> On Mon, Feb 25, 2013 at 4:16 PM, Dave Chinner <david@fromorbit.com> wrote:
>
>> Post your benchmark script, along with the results you see, and all
>> the other information listed here:
>>
>>
>> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>>
>
Attached is the script which runs the benchmark.  It refers to a
"/usr/bin/write-bench" which I will work on seeing how I can share.  But it
does little more than allocate a buffer, read into it from /dev/urandom,
then "open(O_DIRECT)/write(16MB)/write(16MB)/.../write(16MB)/close()" and
measure the duration of the write() calls using gettimeofday() or
clock_gettime(CLOCK_MONOTONIC).

-- 
-Brian

--f46d042f96428059ef04d693fd8f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On Mon, Feb 25, 2013 at 4:18 PM, Brian Cain <span dir=3D"ltr">&lt;<a href=
=3D"mailto:brian.cain@gmail.com" target=3D"_blank">brian.cain@gmail.com</a>=
&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin-top:0px;margin-right:0px;=
margin-bottom:0px;margin-left:0.8ex;border-left-width:1px;border-left-color=
:rgb(204,204,204);border-left-style:solid;padding-left:1ex"><div dir=3D"ltr=
">
Here&#39;s the info from the FAQ, I&#39;ll bundle up the benchmarks.</div><=
div class=3D"gmail_extra"><div><div class=3D"h5"><br><br><div class=3D"gmai=
l_quote">On Mon, Feb 25, 2013 at 4:16 PM, Dave Chinner <span dir=3D"ltr">&l=
t;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.=
com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin-top:0px;margin-right:0px;=
margin-bottom:0px;margin-left:0.8ex;border-left-width:1px;border-left-color=
:rgb(204,204,204);border-left-style:solid;padding-left:1ex"><div><div>Post =
your benchmark script, along with the results you see, and all<br>
</div></div>
the other information listed here:<br>
<br>
<a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_in=
clude_when_reporting_a_problem.3F" target=3D"_blank">http://xfs.org/index.p=
hp/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F=
</a><br>


</blockquote></div></div></div><span class=3D""><font color=3D"#888888"></f=
ont></span></div></blockquote><div><br></div><div>Attached is the script wh=
ich runs the benchmark. =A0It refers to a &quot;/usr/bin/write-bench&quot; =
which I will work on seeing how I can share. =A0But it does little more tha=
n allocate a buffer, read into it from /dev/urandom, then &quot;open(O_DIRE=
CT)/write(16MB)/write(16MB)/.../write(16MB)/close()&quot; and measure the d=
uration of the write() calls using gettimeofday() or clock_gettime(CLOCK_MO=
NOTONIC).</div>
</div><div><br></div>-- <br>-Brian
</div></div>

--f46d042f96428059ef04d693fd8f--

--f46d042f96428059fc04d693fd91
Content-Type: application/octet-stream; name=wb-model
Content-Disposition: attachment; filename=wb-model
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdm6w9vh1

IyEvYmluL3NoCgpuYnl0ZXM9MTg2Mjk0MjEwNTYwCgpmcmVlYnl0ZXMoKSB7CgllY2hvICQoKCA0
MDk2ICogJCggc3RhdCAtZiAtYyAiJWYiIC9yYXdfZGF0YSApICkpCn0KCmZyZWVibG9ja3MoKSB7
CgllY2hvICQoc3RhdCAtZiAtYyAiJWEiIC9yYXdfZGF0YSkKfQoKdG90YWxibG9ja3MoKSB7Cgll
Y2hvICQoc3RhdCAtZiAtYyAiJWIiIC9yYXdfZGF0YSkKfQoKdXNlZGJsb2NrcygpIHsKCWVjaG8g
JCgoICQodG90YWxibG9ja3MpIC0gJChmcmVlYmxvY2tzKSApKQp9Cgp1c2VkcGN0KCkgewoJZWNo
byAkKCggMTAwICogJCh1c2VkYmxvY2tzKSAvICQodG90YWxibG9ja3MpICkpCn0KCnJtb25lKCkg
ewoJZm9yIGQgaW4gJCgvYmluL2xzIC10cmQgL3Jhd19kYXRhL2V4KikgOyBkbwoJCWlmIFsgLWQg
JGQgXTsgdGhlbgoJCQllY2hvIHJlbW92ZSAkZAoJCQkvYmluL3JtIC1yZiAkZAoJCQlicmVhawoJ
CWZpIAoJZG9uZQp9CgptYWtlb25lKCkgewoJZXhuYW1lPSJleC4kKGRhdGUgKyVZJW0lZFQlSCVN
JVMpIgoJZGlybmFtZT0iL3Jhd19kYXRhLyRleG5hbWUiCglta2RpciAkZGlybmFtZQoJZGQgaWY9
L2Rldi96ZXJvIG9mPSRkaXJuYW1lL292LnMxYTEgYnM9NGsgY291bnQ9MQoJcmVwZWF0PSQoKCRu
Ynl0ZXMgLyAxMDI0IC8gMTAyNCAvIDE2KSkKICAgICAgICB4ZnNfZGIgLXIgLWMgZnJlZXNwIC9k
ZXYvbWQwID4gJHtleG5hbWV9X2ZyZWUudHh0CgkvdXNyL2Jpbi93cml0ZS1iZW5jaCAtdzEgLW4k
KCgxNioweDEwMDAwMCkpIC1yICRyZXBlYXQgLWQgLXAgLWMgJGRpcm5hbWUvb3YuczFhMS53YiA+
ICR7ZXhuYW1lfS5jc3YKfQoKZm9yIGkgaW4gJChzZXEgNDApOyBkbwoJaWYgWyAkKHVzZWRwY3Qp
IC1nZSA4MCBdOyB0aGVuCgkJcm1vbmUKCWZpCgltYWtlb25lCmRvbmUK
--f46d042f96428059fc04d693fd91
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--f46d042f96428059fc04d693fd91--
