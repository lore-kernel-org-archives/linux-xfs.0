Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 09A2A7F37
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 21:02:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7458304039
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 19:02:10 -0700 (PDT)
Received: from mail-qc0-f176.google.com (mail-qc0-f176.google.com
	[209.85.216.176]) by cuda.sgi.com with ESMTP id
	jF7UX52pxQOOTB1p (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 19:02:09 -0700 (PDT)
Received: by mail-qc0-f176.google.com with SMTP id o10so3227746qcv.7
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 19:02:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51A247C4.4050606@sandeen.net>
References: <512DB284.1090806@gmail.com> <51363CE6.1010807@sgi.com>
	<CAEH94LhbYShu5Q7K=G=10G6X3jUM68VL4rBBuS4zvdQsifsKGw@mail.gmail.com>
	<51A247C4.4050606@sandeen.net>
Date: Mon, 27 May 2013 10:02:08 +0800
Message-ID: <CAEH94LhUsLENPqBU1DGmLMZM4dEu6yS-+fbVOoay-4uKp4iJCg@mail.gmail.com>
Subject: Re: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
From: Zhi Yong Wu <zwu.kernel@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0319579908005234749=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Wang Sheng-Hui <shhuiw@gmail.com>, Rich Johnston <rjohnston@sgi.com>, list.btrfs@jan-o-sch.net, linux-btrfs@vger.kernel.org, xfstests <xfs@oss.sgi.com>

--===============0319579908005234749==
Content-Type: multipart/alternative; boundary=047d7bd752f64553ba04dda9890f

--047d7bd752f64553ba04dda9890f
Content-Type: text/plain; charset=ISO-8859-1

sigh, i a bit plan to give up btrfs work, and think that it's very
difficult to reach that day when its code is stable. IOWs, its community
operates not well.


On Mon, May 27, 2013 at 1:35 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 5/26/13 4:35 AM, Zhi Yong Wu wrote:
> > HI,
> >
> >   This issue still exists when xfstests is run on debian although
> > xfstests has contained this patch.
>
> "this issue" must be different, then; same error ("Invalid argument")
> but it can no longer be due to the -x option to filefrag.  There
> must be some other root cause.
>
> Needs investigation on the btrfs side.  IOWs, this looks like
> it could be a regression in btrfs?
>
> -Eric
>
> > root@debian-i386:/home/zwu/xfstests# git describe
> > linux-v3.8-122-gdc75401
> > root@debian-i386:/home/zwu/xfstests# uname -a
> > Linux debian-i386 3.10.0-rc2+ #3 SMP Sun May 26 14:04:13 CST 2013
> > x86_64 GNU/Linux
> > root@debian-i386:/home/zwu/xfstests#
> >
> >  - output mismatch (see /home/zwu/xfstests/results/btrfs/276.out.bad)
> >     --- tests/btrfs/276.out    2013-05-25 15:09:01.000000000 +0000
> >     +++ /home/zwu/xfstests/results/btrfs/276.out.bad    2013-05-26
> > 09:31:49.962876905 +0000
> >     @@ -1,3 +1,32393 @@
> >      QA output created by 276
> >      *** test backref walking
> >     +FIBMAP: Invalid argument
> >     +FIBMAP: Invalid argument
> >     +FIBMAP: Invalid argument
> >     +FIBMAP: Invalid argument
> >     +FIBMAP: Invalid argument
> >      ...
> >      (Run 'diff -u tests/btrfs/276.out
> > /home/zwu/xfstests/results/btrfs/276.out.bad' to see the entire diff)
> > [ 3877.215268] device fsid 8367602a-14fa-49eb-aff0-44da1faa3b45 devid
> > 1 transid 239 /dev/vdb
> > [ 3877.218417] btrfs: disk space caching is enabled
> > Ran: btrfs/276
> > Failures: btrfs/276
> > Failed 1 of 1 tests
> >
> > On Wed, Mar 6, 2013 at 2:43 AM, Rich Johnston <rjohnston@sgi.com> wrote:
> >> This patch has been committed.
> >>
> >> --Rich
> >>
> >> commit eba3a5206cd7f8df73d6e6dbf2bb0afca677fca8
> >> Author: Wang Sheng-Hui <shhuiw@gmail.com>
> >> Date:   Thu Feb 28 02:05:56 2013 +0000
> >>
> >>     xfstests 276: fix error 'FIBMAP: Invalid argument'
> >>
> >>
> >>     Commit 05dadc0 ("Btrfs: add fiemap's flag check") added validity
> >>     checks to the fiemap flags and hence invalid flags are now being
> >>     rejected. Test 276 passes an invalid fiemap flag to btrfs, and so
> >>     that test fails since this commit was added.
> >>
> >>     Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by -x
> option
> >>     of filefrag, and will fail with
> >>         'FIBMAP: Invalid argument'
> >>     for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
> >>          'FIEMAP failed with unsupported flags 2'
> >>     Remove the '-x' option.
> >>
> >> _______________________________________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/listinfo/xfs
> >
> >
> >
>
>


-- 
Regards,

Zhi Yong Wu

--047d7bd752f64553ba04dda9890f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">sigh, i a bit plan to give up btrfs work, and think that i=
t&#39;s very difficult to reach that day when its code is stable. IOWs, its=
 community operates not well.<br></div><div class=3D"gmail_extra"><br><br><=
div class=3D"gmail_quote">
On Mon, May 27, 2013 at 1:35 AM, Eric Sandeen <span dir=3D"ltr">&lt;<a href=
=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im">On 5/26/13 4:35 AM, Zhi Yong Wu wrote:<br>
&gt; HI,<br>
&gt;<br>
&gt; =A0 This issue still exists when xfstests is run on debian although<br=
>
&gt; xfstests has contained this patch.<br>
<br>
</div>&quot;this issue&quot; must be different, then; same error (&quot;Inv=
alid argument&quot;)<br>
but it can no longer be due to the -x option to filefrag. =A0There<br>
must be some other root cause.<br>
<br>
Needs investigation on the btrfs side. =A0IOWs, this looks like<br>
it could be a regression in btrfs?<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Eric<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; root@debian-i386:/home/zwu/xfstests# git describe<br>
&gt; linux-v3.8-122-gdc75401<br>
&gt; root@debian-i386:/home/zwu/xfstests# uname -a<br>
&gt; Linux debian-i386 3.10.0-rc2+ #3 SMP Sun May 26 14:04:13 CST 2013<br>
&gt; x86_64 GNU/Linux<br>
&gt; root@debian-i386:/home/zwu/xfstests#<br>
&gt;<br>
&gt; =A0- output mismatch (see /home/zwu/xfstests/results/btrfs/276.out.bad=
)<br>
&gt; =A0 =A0 --- tests/btrfs/276.out =A0 =A02013-05-25 15:09:01.000000000 +=
0000<br>
&gt; =A0 =A0 +++ /home/zwu/xfstests/results/btrfs/276.out.bad =A0 =A02013-0=
5-26<br>
&gt; 09:31:49.962876905 +0000<br>
&gt; =A0 =A0 @@ -1,3 +1,32393 @@<br>
&gt; =A0 =A0 =A0QA output created by 276<br>
&gt; =A0 =A0 =A0*** test backref walking<br>
&gt; =A0 =A0 +FIBMAP: Invalid argument<br>
&gt; =A0 =A0 +FIBMAP: Invalid argument<br>
&gt; =A0 =A0 +FIBMAP: Invalid argument<br>
&gt; =A0 =A0 +FIBMAP: Invalid argument<br>
&gt; =A0 =A0 +FIBMAP: Invalid argument<br>
&gt; =A0 =A0 =A0...<br>
&gt; =A0 =A0 =A0(Run &#39;diff -u tests/btrfs/276.out<br>
&gt; /home/zwu/xfstests/results/btrfs/276.out.bad&#39; to see the entire di=
ff)<br>
&gt; [ 3877.215268] device fsid 8367602a-14fa-49eb-aff0-44da1faa3b45 devid<=
br>
&gt; 1 transid 239 /dev/vdb<br>
&gt; [ 3877.218417] btrfs: disk space caching is enabled<br>
&gt; Ran: btrfs/276<br>
&gt; Failures: btrfs/276<br>
&gt; Failed 1 of 1 tests<br>
&gt;<br>
&gt; On Wed, Mar 6, 2013 at 2:43 AM, Rich Johnston &lt;<a href=3D"mailto:rj=
ohnston@sgi.com">rjohnston@sgi.com</a>&gt; wrote:<br>
&gt;&gt; This patch has been committed.<br>
&gt;&gt;<br>
&gt;&gt; --Rich<br>
&gt;&gt;<br>
&gt;&gt; commit eba3a5206cd7f8df73d6e6dbf2bb0afca677fca8<br>
&gt;&gt; Author: Wang Sheng-Hui &lt;<a href=3D"mailto:shhuiw@gmail.com">shh=
uiw@gmail.com</a>&gt;<br>
&gt;&gt; Date: =A0 Thu Feb 28 02:05:56 2013 +0000<br>
&gt;&gt;<br>
&gt;&gt; =A0 =A0 xfstests 276: fix error &#39;FIBMAP: Invalid argument&#39;=
<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; =A0 =A0 Commit 05dadc0 (&quot;Btrfs: add fiemap&#39;s flag check&q=
uot;) added validity<br>
&gt;&gt; =A0 =A0 checks to the fiemap flags and hence invalid flags are now=
 being<br>
&gt;&gt; =A0 =A0 rejected. Test 276 passes an invalid fiemap flag to btrfs,=
 and so<br>
&gt;&gt; =A0 =A0 that test fails since this commit was added.<br>
&gt;&gt;<br>
&gt;&gt; =A0 =A0 Btrfs doesn&#39;t support FIEMAP_FLAG_XATTR, which is enab=
led by -x option<br>
&gt;&gt; =A0 =A0 of filefrag, and will fail with<br>
&gt;&gt; =A0 =A0 =A0 =A0 &#39;FIBMAP: Invalid argument&#39;<br>
&gt;&gt; =A0 =A0 for &#39;filefrag -vx&#39;. &#39;filefrag -vx&#39; fails o=
n btrfs with<br>
&gt;&gt; =A0 =A0 =A0 =A0 =A0&#39;FIEMAP failed with unsupported flags 2&#39=
;<br>
&gt;&gt; =A0 =A0 Remove the &#39;-x&#39; option.<br>
&gt;&gt;<br>
&gt;&gt; _______________________________________________<br>
&gt;&gt; xfs mailing list<br>
&gt;&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt;&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_bla=
nk">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt;<br>
&gt;<br>
&gt;<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br><div>Regard=
s,</div><div>=A0</div><div>Zhi Yong Wu</div>
</div>

--047d7bd752f64553ba04dda9890f--


--===============0319579908005234749==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0319579908005234749==--
