Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3F1E77F3F
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 23:40:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D6BD8F8035
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 21:40:36 -0700 (PDT)
Received: from mail-oi0-f44.google.com (mail-oi0-f44.google.com
	[209.85.218.44]) by cuda.sgi.com with ESMTP id q0Jc1srC5ZD8EQiP
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 30 Oct 2014 21:40:34 -0700 (PDT)
Received: by mail-oi0-f44.google.com with SMTP id h136so5144941oig.31
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 21:40:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141031034925.GM13323@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<20141029212556.GH13323@dastard>
	<CAGdb-8dbGRu_GWB4qoeNP8Kso2hzkLcuFS9Pwtnm2xOkP2T0rQ@mail.gmail.com>
	<20141030050306.GI13323@dastard>
	<CAGdb-8dt23oO7nncZdtri1BeNyWkR-6UF_4QRZx2X-5+tFYSRw@mail.gmail.com>
	<20141030230457.GK13323@dastard> <20141031000954.GL13323@dastard>
	<CAGdb-8dP7nah4QuXYk_S8KbEu4Y6ZiT7tXz7dMLkwZ=VTkKQXA@mail.gmail.com>
	<20141031034925.GM13323@dastard>
Date: Fri, 31 Oct 2014 12:40:33 +0800
Message-ID: <CAGdb-8c+JgTY3xiKVfUdp-HPoa2aFQgxPCxWvH00bLcNV6L43w@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============3841753684617736439=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

--===============3841753684617736439==
Content-Type: multipart/alternative; boundary=089e01183f78f717450506b09830

--089e01183f78f717450506b09830
Content-Type: text/plain; charset=UTF-8

the dmesg log:
https://mega.co.nz/#!VIgnQYbK!cC0l8WKOtgJkmi0pCbpJf9mm357nzi0fpV0extUmbC0

2014-10-31 11:49 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Fri, Oct 31, 2014 at 09:51:27AM +0800, Tommy Wu wrote:
> > After apply this patch, xfsdump will hang again.
> >
> > the log for xfsdump:
> >
> https://mega.co.nz/#!tUgz3QrC!q7Ix53sl9lYCg0iKRHjgOqF0tZJAVKHBNz0OHWof-ds
> >
> > But 'echo w > /proc/sysrq-trigger' no any blocked task in dmesg.
>
> echo l > /proc/sysrq-trigger
> echo t > /proc/sysrq-trigger
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



-- 

Tommy Wu

--089e01183f78f717450506b09830
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><br></div>the dmesg log:<br><a href=3D"https://mega.c=
o.nz/#!VIgnQYbK!cC0l8WKOtgJkmi0pCbpJf9mm357nzi0fpV0extUmbC0">https://mega.c=
o.nz/#!VIgnQYbK!cC0l8WKOtgJkmi0pCbpJf9mm357nzi0fpV0extUmbC0</a><br><div><di=
v class=3D"gmail_extra"><br><div class=3D"gmail_quote">2014-10-31 11:49 GMT=
+08:00 Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit=
.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span>:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px sol=
id rgb(204,204,204);padding-left:1ex"><span class=3D"">On Fri, Oct 31, 2014=
 at 09:51:27AM +0800, Tommy Wu wrote:<br>
&gt; After apply this patch, xfsdump will hang again.<br>
&gt;<br>
&gt; the log for xfsdump:<br>
&gt; <a href=3D"https://mega.co.nz/#!tUgz3QrC!q7Ix53sl9lYCg0iKRHjgOqF0tZJAV=
KHBNz0OHWof-ds" target=3D"_blank">https://mega.co.nz/#!tUgz3QrC!q7Ix53sl9lY=
Cg0iKRHjgOqF0tZJAVKHBNz0OHWof-ds</a><br>
&gt;<br>
&gt; But &#39;echo w &gt; /proc/sysrq-trigger&#39; no any blocked task in d=
mesg.<br>
<br>
</span>echo l &gt; /proc/sysrq-trigger<br>
echo t &gt; /proc/sysrq-trigger<br>
<div class=3D""><div class=3D"h5"><br>
-Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br><div class=
=3D"gmail_signature"><br>Tommy Wu</div>
</div></div></div>

--089e01183f78f717450506b09830--


--===============3841753684617736439==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3841753684617736439==--
