Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E34747F6C
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 19:36:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6D2C8AC065
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:36:06 -0800 (PST)
Received: from mail-bk0-f53.google.com (mail-bk0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id wzBuYeL5p4xFtOll
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:36:04 -0800 (PST)
Received: by mail-bk0-f53.google.com with SMTP id my13so4027553bkb.12
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:36:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140217011929.GA13997@dastard>
References: <1392408522-764-1-git-send-email-fdmanana@gmail.com>
	<1392596438-6509-1-git-send-email-fdmanana@gmail.com>
	<20140217011929.GA13997@dastard>
Date: Mon, 17 Feb 2014 01:36:02 +0000
Message-ID: <CAL3q7H4JLbMS+JL4h4du60S1vKFtvceP-Mx-e=0v4nTBwjkATA@mail.gmail.com>
Subject: Re: [PATCH] xfstests: add regression test for btrfs incremental send
From: Filipe David Manana <fdmanana@gmail.com>
Reply-To: fdmanana@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8505334364473525909=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============8505334364473525909==
Content-Type: multipart/alternative; boundary=047d7b873f16b76d4804f2902dd3

--047d7b873f16b76d4804f2902dd3
Content-Type: text/plain; charset=UTF-8

On Monday, February 17, 2014, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Feb 17, 2014 at 12:20:38AM +0000, Filipe David Borba Manana wrote:
> > Test for a btrfs incremental send issue where we end up sending a
> > wrong section of data from a file extent if the corresponding file
> > extent is compressed and the respective file extent item has a non
> > zero data offset.
> >
> > Fixed by the following linux kernel btrfs patch:
> >
> >    Btrfs: use right clone root offset for compressed extents
> >
> > Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com<javascript:;>
> >
> > ---
> >
> > V2: Made the test more reliable. Now it doesn't depend anymore of btrfs'
> >     hole punch implementation leaving hole file extent items when we
> punch
> >     beyond the file's current size.
> > V3: Filter xfs_io output and make less use of the run_check function, as
> >     suggested by Dave Chinner.
>
> Awesome. Thanks for the quick turn around.
>
> >  common/rc           |    5 +++
> >  tests/btrfs/040     |  119
> +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/040.out |    9 ++++
> >  tests/btrfs/group   |    1 +
> >  4 files changed, 134 insertions(+)
> >  create mode 100755 tests/btrfs/040
> >  create mode 100644 tests/btrfs/040.out
> >
> > diff --git a/common/rc b/common/rc
> > index e91568b..27be009 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2207,6 +2207,11 @@ run_check()
> >       "$@" >> $seqres.full 2>&1 || _fail "failed: '$@'"
> >  }
> >
> > +_run_btrfs_util_prog()
> > +{
> > +     run_check $BTRFS_UTIL_PROG $*
> > +}
>
> Can you do a cleanup of all the other btrfs tests that can use this?


Ok. I just did that for all the test cases not yet merged, as you probably
noticed already.
For the ones already in the repository, I'll see if I can do it soon this
coming week.

Thanks


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com <javascript:;>
>


-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

--047d7b873f16b76d4804f2902dd3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>On Monday, February 17, 2014, Dave Chinner &lt;<a href=3D"mailto:da=
vid@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
On Mon, Feb 17, 2014 at 12:20:38AM +0000, Filipe David Borba Manana wrote:<=
br>
&gt; Test for a btrfs incremental send issue where we end up sending a<br>
&gt; wrong section of data from a file extent if the corresponding file<br>
&gt; extent is compressed and the respective file extent item has a non<br>
&gt; zero data offset.<br>
&gt;<br>
&gt; Fixed by the following linux kernel btrfs patch:<br>
&gt;<br>
&gt; =C2=A0 =C2=A0Btrfs: use right clone root offset for compressed extents=
<br>
&gt;<br>
&gt; Signed-off-by: Filipe David Borba Manana &lt;<a href=3D"javascript:;" =
onclick=3D"_e(event, &#39;cvml&#39;, &#39;fdmanana@gmail.com&#39;)">fdmanan=
a@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;<br>
&gt; V2: Made the test more reliable. Now it doesn&#39;t depend anymore of =
btrfs&#39;<br>
&gt; =C2=A0 =C2=A0 hole punch implementation leaving hole file extent items=
 when we punch<br>
&gt; =C2=A0 =C2=A0 beyond the file&#39;s current size.<br>
&gt; V3: Filter xfs_io output and make less use of the run_check function, =
as<br>
&gt; =C2=A0 =C2=A0 suggested by Dave Chinner.<br>
<br>
Awesome. Thanks for the quick turn around.<br>
<br>
&gt; =C2=A0common/rc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A05 ++=
+<br>
&gt; =C2=A0tests/btrfs/040 =C2=A0 =C2=A0 | =C2=A0119 ++++++++++++++++++++++=
+++++++++++++++++++++++++++++<br>
&gt; =C2=A0tests/btrfs/040.out | =C2=A0 =C2=A09 ++++<br>
&gt; =C2=A0tests/btrfs/group =C2=A0 | =C2=A0 =C2=A01 +<br>
&gt; =C2=A04 files changed, 134 insertions(+)<br>
&gt; =C2=A0create mode 100755 tests/btrfs/040<br>
&gt; =C2=A0create mode 100644 tests/btrfs/040.out<br>
&gt;<br>
&gt; diff --git a/common/rc b/common/rc<br>
&gt; index e91568b..27be009 100644<br>
&gt; --- a/common/rc<br>
&gt; +++ b/common/rc<br>
&gt; @@ -2207,6 +2207,11 @@ run_check()<br>
&gt; =C2=A0 =C2=A0 =C2=A0 &quot;$@&quot; &gt;&gt; $seqres.full 2&gt;&amp;1 =
|| _fail &quot;failed: &#39;$@&#39;&quot;<br>
&gt; =C2=A0}<br>
&gt;<br>
&gt; +_run_btrfs_util_prog()<br>
&gt; +{<br>
&gt; + =C2=A0 =C2=A0 run_check $BTRFS_UTIL_PROG $*<br>
&gt; +}<br>
<br>
Can you do a cleanup of all the other btrfs tests that can use this?</block=
quote><div><br></div><div>Ok. I just did=C2=A0that for all the test cases n=
ot yet merged, as you probably noticed already.</div><div>For the ones alre=
ady in the repository, I&#39;ll see if I can do it soon this coming week.</=
div>
<div><br></div><div>Thanks</div><div>=C2=A0</div><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex">
<br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"javascript:;" onclick=3D"_e(event, &#39;cvml&#39;, &#39;david@fr=
omorbit.com&#39;)">david@fromorbit.com</a><br>
</blockquote><br><br>-- <br>Filipe David Manana,<br><br>&quot;Reasonable me=
n adapt themselves to the world.<br>=C2=A0Unreasonable men adapt the world =
to themselves.<br>=C2=A0That&#39;s why all progress depends on unreasonable=
 men.&quot;<br>
<br>

--047d7b873f16b76d4804f2902dd3--


--===============8505334364473525909==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8505334364473525909==--
