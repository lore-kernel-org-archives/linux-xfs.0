Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 59FFA7F6B
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 16:06:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 223308F8033
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 14:06:59 -0800 (PST)
Received: from mail-la0-f42.google.com (mail-la0-f42.google.com
	[209.85.215.42]) by cuda.sgi.com with ESMTP id bFNypepemtpAA1A1
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Feb 2013 14:06:57 -0800 (PST)
Received: by mail-la0-f42.google.com with SMTP id fe20so3227955lab.1
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 14:06:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512BDA2A.5050600@hardwarefreak.com>
References: <CAEWpfG_DKJt1MmWS1tARH4OmYwpSt=A-DzwKkGcD67LuR6k=Bg@mail.gmail.com>
	<512BDA2A.5050600@hardwarefreak.com>
Date: Mon, 25 Feb 2013 16:06:55 -0600
Message-ID: <CAEWpfG8zoRriC_UHn-eGZk+y5KwsSgEuKM92QKFyS7Yb9Gde_w@mail.gmail.com>
Subject: Re: Consistent throughput challenge -- fragmentation?
From: Brian Cain <brian.cain@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3315010088955084166=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

--===============3315010088955084166==
Content-Type: multipart/alternative; boundary=f46d0421a95b54bddb04d693c23a

--f46d0421a95b54bddb04d693c23a
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Feb 25, 2013 at 3:39 PM, Stan Hoeppner <stan@hardwarefreak.com>
wrote:
>
>
> > Can anyone provide any suggestions as to an explanation for the
behavior or
> > a way to mitigate it?  Running xfs_fsr didn't seem to improve the
results.
>
> The usual cause of such aged filesystem low performance is free space
> fragmentation.  xfs_fsr will defragment files, but in doing so it
> *increases* free space fragmentation, thus won't help the situation.
>
> > I'm happy to share benchmarks, specific results data, or describe the
> > hardware being used for the measurements if it's helpful.
>
> Paste the output of 'xfs_db -r -c freesp /dev/[device]' just before you
> do the large file write.  This will show us the free space distribution
> histogram.
>

Running now...

Here's a single sample:

   from      to extents  blocks    pct
      1       1     128     128   0.00
      2       3       6      18   0.00
      4       7       1       7   0.00
      8      15      30     275   0.00
    512    1023       1     528   0.01
   2048    4095       1    2656   0.03
4194304 8388608       1 8388588  99.96

Not sure whether the cycle following this output experienced "only good"
results or if it included poor performing samples too.  Is it only useful
to see the "freesp" output in cases where the poor performance occurred?

--
-Brian

--f46d0421a95b54bddb04d693c23a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br><br>On Mon, Feb 25, 2013 at 3:39 PM, Stan Hoeppner=
 &lt;<a href=3D"mailto:stan@hardwarefreak.com">stan@hardwarefreak.com</a>&g=
t; wrote:<br>&gt;<br>&gt;<br>&gt; &gt; Can anyone provide any suggestions a=
s to an explanation for the behavior or<br>
&gt; &gt; a way to mitigate it? =A0Running xfs_fsr didn&#39;t seem to impro=
ve the results.<br>&gt;<br>&gt; The usual cause of such aged filesystem low=
 performance is free space<br>&gt; fragmentation. =A0xfs_fsr will defragmen=
t files, but in doing so it<br>
&gt; *increases* free space fragmentation, thus won&#39;t help the situatio=
n.<br>&gt;<br>&gt; &gt; I&#39;m happy to share benchmarks, specific results=
 data, or describe the<br>&gt; &gt; hardware being used for the measurement=
s if it&#39;s helpful.<br>
&gt;<br>&gt; Paste the output of &#39;xfs_db -r -c freesp /dev/[device]&#39=
; just before you<br>&gt; do the large file write. =A0This will show us the=
 free space distribution<br>&gt; histogram.<br>&gt;<br><br>Running now...<b=
r>
<br>Here&#39;s a single sample:<br><br><div>=A0 =A0from =A0 =A0 =A0to exten=
ts =A0blocks =A0 =A0pct</div><div>=A0 =A0 =A0 1 =A0 =A0 =A0 1 =A0 =A0 128 =
=A0 =A0 128 =A0 0.00</div><div>=A0 =A0 =A0 2 =A0 =A0 =A0 3 =A0 =A0 =A0 6 =
=A0 =A0 =A018 =A0 0.00</div><div>=A0 =A0 =A0 4 =A0 =A0 =A0 7 =A0 =A0 =A0 1 =
=A0 =A0 =A0 7 =A0 0.00</div>
<div>=A0 =A0 =A0 8 =A0 =A0 =A015 =A0 =A0 =A030 =A0 =A0 275 =A0 0.00</div><d=
iv>=A0 =A0 512 =A0 =A01023 =A0 =A0 =A0 1 =A0 =A0 528 =A0 0.01</div><div>=A0=
 =A02048 =A0 =A04095 =A0 =A0 =A0 1 =A0 =A02656 =A0 0.03</div><div>4194304 8=
388608 =A0 =A0 =A0 1 8388588 =A099.96</div><div><br></div>Not sure whether =
the cycle following this output experienced &quot;only good&quot; results o=
r if it included poor performing samples too. =A0Is it only useful to see t=
he &quot;freesp&quot; output in cases where the poor performance occurred?<=
br>
<br>--<br>-Brian<br></div>

--f46d0421a95b54bddb04d693c23a--


--===============3315010088955084166==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3315010088955084166==--
