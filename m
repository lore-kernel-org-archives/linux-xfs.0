Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE56C7F3F
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2014 00:40:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2BF7EAC004
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 22:40:09 -0700 (PDT)
Received: from mail-ob0-f173.google.com (mail-ob0-f173.google.com
	[209.85.214.173]) by cuda.sgi.com with ESMTP id
	cD8xHMDnsNGIlPdf (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Oct 2014 22:40:07 -0700 (PDT)
Received: by mail-ob0-f173.google.com with SMTP id wn1so5366180obc.18
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 22:40:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141031042511.GN13323@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<20141029212556.GH13323@dastard>
	<CAGdb-8dbGRu_GWB4qoeNP8Kso2hzkLcuFS9Pwtnm2xOkP2T0rQ@mail.gmail.com>
	<20141030050306.GI13323@dastard>
	<CAGdb-8dt23oO7nncZdtri1BeNyWkR-6UF_4QRZx2X-5+tFYSRw@mail.gmail.com>
	<20141030230457.GK13323@dastard> <20141031000954.GL13323@dastard>
	<CAGdb-8dP7nah4QuXYk_S8KbEu4Y6ZiT7tXz7dMLkwZ=VTkKQXA@mail.gmail.com>
	<20141031034925.GM13323@dastard> <20141031042511.GN13323@dastard>
Date: Fri, 31 Oct 2014 13:40:06 +0800
Message-ID: <CAGdb-8d7fb302zwaVwA0qVcCGEgRuzJStmF6sKdSak7uQpywrw@mail.gmail.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
From: Tommy Wu <wu.tommy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5930860266450976665=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

--===============5930860266450976665==
Content-Type: multipart/alternative; boundary=001a113cdf64ee626b0506b16d5c

--001a113cdf64ee626b0506b16d5c
Content-Type: text/plain; charset=UTF-8

metadump (it's just a test partition with linux 3.17 source code):
https://mega.co.nz/#!FQImhABD!8D6A0ZtXmGPhpm2gtrMBej6xPS5pKF-WM4MZxfGPbD0

2014-10-31 12:25 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Fri, Oct 31, 2014 at 02:49:25PM +1100, Dave Chinner wrote:
> > On Fri, Oct 31, 2014 at 09:51:27AM +0800, Tommy Wu wrote:
> > > After apply this patch, xfsdump will hang again.
> > >
> > > the log for xfsdump:
> > >
> https://mega.co.nz/#!tUgz3QrC!q7Ix53sl9lYCg0iKRHjgOqF0tZJAVKHBNz0OHWof-ds
> > >
> > > But 'echo w > /proc/sysrq-trigger' no any blocked task in dmesg.
> >
> > echo l > /proc/sysrq-trigger
> > echo t > /proc/sysrq-trigger
>
> Also, I just cannot reproduce a hung dump or a broken restore,
> so can you take an unobfuscated metadump of the source filesystem
> (i.e. the one you are running dump on) so I can try on an exact
> image of the filesystem you are having troubles on?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



-- 

Tommy Wu

--001a113cdf64ee626b0506b16d5c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">metadump (it&#39;s just a test partition with linux 3.17 s=
ource code):<br><a href=3D"https://mega.co.nz/#!FQImhABD!8D6A0ZtXmGPhpm2gtr=
MBej6xPS5pKF-WM4MZxfGPbD0">https://mega.co.nz/#!FQImhABD!8D6A0ZtXmGPhpm2gtr=
MBej6xPS5pKF-WM4MZxfGPbD0</a><br></div><div class=3D"gmail_extra"><br><div =
class=3D"gmail_quote">2014-10-31 12:25 GMT+08:00 Dave Chinner <span dir=3D"=
ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fro=
morbit.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D=
"">On Fri, Oct 31, 2014 at 02:49:25PM +1100, Dave Chinner wrote:<br>
&gt; On Fri, Oct 31, 2014 at 09:51:27AM +0800, Tommy Wu wrote:<br>
&gt; &gt; After apply this patch, xfsdump will hang again.<br>
&gt; &gt;<br>
&gt; &gt; the log for xfsdump:<br>
&gt; &gt; <a href=3D"https://mega.co.nz/#!tUgz3QrC!q7Ix53sl9lYCg0iKRHjgOqF0=
tZJAVKHBNz0OHWof-ds" target=3D"_blank">https://mega.co.nz/#!tUgz3QrC!q7Ix53=
sl9lYCg0iKRHjgOqF0tZJAVKHBNz0OHWof-ds</a><br>
&gt; &gt;<br>
&gt; &gt; But &#39;echo w &gt; /proc/sysrq-trigger&#39; no any blocked task=
 in dmesg.<br>
&gt;<br>
&gt; echo l &gt; /proc/sysrq-trigger<br>
&gt; echo t &gt; /proc/sysrq-trigger<br>
<br>
</span>Also, I just cannot reproduce a hung dump or a broken restore,<br>
so can you take an unobfuscated metadump of the source filesystem<br>
(i.e. the one you are running dump on) so I can try on an exact<br>
image of the filesystem you are having troubles on?<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br><div class=
=3D"gmail_signature"><br>Tommy Wu</div>
</div>

--001a113cdf64ee626b0506b16d5c--


--===============5930860266450976665==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5930860266450976665==--
