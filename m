Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D5267F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 07:32:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF1D78F8033
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 05:32:53 -0700 (PDT)
Received: from mail-oi0-f42.google.com (mail-oi0-f42.google.com
	[209.85.218.42]) by cuda.sgi.com with ESMTP id oFuWtkS0nbwK81Fk
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 29 Oct 2014 05:32:53 -0700 (PDT)
Received: by mail-oi0-f42.google.com with SMTP id a3so1564871oib.15
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 05:32:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141029104304.GC13323@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<5450686F.9070307@sandeen.net>
	<CAGdb-8d5-GuB40ZgP6uM5aQMi+qqaeFd=xqzuxWhM+1AaoLSVw@mail.gmail.com>
	<54506CD9.90403@sandeen.net>
	<CAGdb-8cGAzT_0ck-pJyQX-OcnE_3FPCA9TesHW7c_raDSKEXWg@mail.gmail.com>
	<20141029044017.GG16186@dastard>
	<CAGdb-8e=wttjj+wTj8wqRWyUUz+AUmz-O0=r3+HoJ5zGgV-dkQ@mail.gmail.com>
	<20141029075134.GB13323@dastard>
	<CAGdb-8dhPe9wvoGnUsFo2Q3EZWka+i2DcFN-AqJV_G09+=4f2w@mail.gmail.com>
	<20141029103355.GI16186@dastard> <20141029104304.GC13323@dastard>
Date: Wed, 29 Oct 2014 20:32:52 +0800
Message-ID: <CAGdb-8dxgsrywS_GtgM8Y7N1fYfxgZPr4sBQ1QiuqhJ_hHDFSg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============4277488892097882973=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs <xfs@oss.sgi.com>

--===============4277488892097882973==
Content-Type: multipart/alternative; boundary=001a113d2eae65bcd405068ef64c

--001a113d2eae65bcd405068ef64c
Content-Type: text/plain; charset=UTF-8

Does it just fix the hang issue or fix the dump corrupted issue?

I just clone the git repo and checkout xfs-fixes-for-3.18-rc3, build it
again.
Now, xfsdump won't hang, but still can't restore the dump file correctly.
The result just same as kernel 3.17.1.


2014-10-29 18:43 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Wed, Oct 29, 2014 at 09:33:55PM +1100, Dave Chinner wrote:
> > On Wed, Oct 29, 2014 at 05:21:52PM +0800, Tommy Wu wrote:
> > > Same testing in same machine (just different kernel).
> > >
> > > 3.18-rc2:
> > > xfsdump will hang (the test.xfsdump.gz size stop around 57M)
> >
> > Ugh, colliding fixes to the bulkstat code. pull again from
> > the xfs-fixes-for-3.18-rc3 branch and the hang should be fixed.
>
> Ugh, I forgot the stable tag on the new commit, so I'm going to have
> to rebase that branch before it's ready to send to Linus. I'll do
> it in the morning when I'm more awake.
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

--001a113d2eae65bcd405068ef64c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Does it just fix the hang issue or fix the =
dump corrupted issue?<br><br></div>I just clone the git repo and checkout x=
fs-fixes-for-3.18-rc3, build it again.<br></div>Now, xfsdump won&#39;t hang=
, but still can&#39;t restore the dump file correctly.<br></div>The result =
just same as kernel 3.17.1.<br><br></div><div class=3D"gmail_extra"><br><di=
v class=3D"gmail_quote">2014-10-29 18:43 GMT+08:00 Dave Chinner <span dir=
=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david=
@fromorbit.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span cl=
ass=3D"">On Wed, Oct 29, 2014 at 09:33:55PM +1100, Dave Chinner wrote:<br>
&gt; On Wed, Oct 29, 2014 at 05:21:52PM +0800, Tommy Wu wrote:<br>
&gt; &gt; Same testing in same machine (just different kernel).<br>
&gt; &gt;<br>
&gt; &gt; 3.18-rc2:<br>
&gt; &gt; xfsdump will hang (the test.xfsdump.gz size stop around 57M)<br>
&gt;<br>
&gt; Ugh, colliding fixes to the bulkstat code. pull again from<br>
&gt; the xfs-fixes-for-3.18-rc3 branch and the hang should be fixed.<br>
<br>
</span>Ugh, I forgot the stable tag on the new commit, so I&#39;m going to =
have<br>
to rebase that branch before it&#39;s ready to send to Linus. I&#39;ll do<b=
r>
it in the morning when I&#39;m more awake.<br>
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

--001a113d2eae65bcd405068ef64c--


--===============4277488892097882973==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4277488892097882973==--
