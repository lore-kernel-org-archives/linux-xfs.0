Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3DE637F6C
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 19:32:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1B16C304043
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:32:45 -0800 (PST)
Received: from mail-bk0-f43.google.com (mail-bk0-f43.google.com
	[209.85.214.43]) by cuda.sgi.com with ESMTP id QzDoVFMhraBfmrbR
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:32:43 -0800 (PST)
Received: by mail-bk0-f43.google.com with SMTP id mx12so760718bkb.30
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:32:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140217011714.GZ13997@dastard>
References: <1392408522-764-1-git-send-email-fdmanana@gmail.com>
	<1392478573-4513-1-git-send-email-fdmanana@gmail.com>
	<20140216230851.GX13647@dastard>
	<CAL3q7H46_AHDtACuZunRJgSymejgr73NVZ-TWNuBuD6z3j9KXg@mail.gmail.com>
	<20140217011714.GZ13997@dastard>
Date: Mon, 17 Feb 2014 01:32:41 +0000
Message-ID: <CAL3q7H6_NURS2enT8mDFR_F3JV3KLKUX1-83abJmaQCbk6Xh6Q@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============5961762970359424797=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5961762970359424797==
Content-Type: multipart/alternative; boundary=bcaec52c63dfb6963004f290215b

--bcaec52c63dfb6963004f290215b
Content-Type: text/plain; charset=UTF-8

On Monday, February 17, 2014, Dave Chinner <david@fromorbit.com> wrote:

> On Sun, Feb 16, 2014 at 11:43:17PM +0000, Filipe David Manana wrote:
> > On Sun, Feb 16, 2014 at 11:08 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> > > On Sat, Feb 15, 2014 at 03:36:13PM +0000, Filipe David Borba Manana
> wrote:
> > >> Test for a btrfs incremental send issue where we end up sending a
> > >> wrong section of data from a file extent if the corresponding file
> > >> extent is compressed and the respective file extent item has a non
> > >> zero data offset.
> > >>
> > >> Fixed by the following linux kernel btrfs patch:
> > >>
> > >>    Btrfs: use right clone root offset for compressed extents
> > >>
> > >> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> > >> ---
> > >>
> > >> V2: Made the test more reliable. Now it doesn't depend anymore of
> btrfs'
> > >>     hole punch implementation leaving hole file extent items when we
> punch
> > >>     beyond the file's current size.
> > >>
> > >>  tests/btrfs/040     |  115
> +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >>  tests/btrfs/040.out |    1 +
> > >>  tests/btrfs/group   |    1 +
> > >>  3 files changed, 117 insertions(+)
> > >>  create mode 100755 tests/btrfs/040
> > >>  create mode 100644 tests/btrfs/040.out
> > >>
> > >> diff --git a/tests/btrfs/040 b/tests/btrfs/040
> > >> new file mode 100755
> > >> index 0000000..d6b37bf
> > >> --- /dev/null
> > >> +++ b/tests/btrfs/040
> > >> @@ -0,0 +1,115 @@
> > >> +#! /bin/bash
> > >> +# FS QA Test No. btrfs/040
> > >> +#
> > >> +# Test for a btrfs incremental send issue where we end up sending a
> > >> +# wrong section of data from a file extent if the corresponding file
> > >> +# extent is compressed and the respective file extent item has a non
> > >> +# zero data offset.
> > >> +#
> > >> +# Fixed by the following linux kernel btrfs patch:
> > >> +#
> > >> +#   Btrfs: use right clone root offset for compressed extents
> > >> +#
> > >>
> +#-----------------------------------------------------------------------
> > >> +# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
> > >> +#
> > >> +# This program is free software; you can redistribute it and/or
> > >> +# modify it under the terms of the GNU General Public License as
> > >> +# published by the Free Software Foundation.
> > >> +#
> > >> +# This program is distributed in the hope that it would be useful,
> > >> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > >> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > >> +# GNU General Public License for more details.
> > >> +#
> > >> +# You should have received a copy of the GNU General Public License
> > >> +# along with this program; if not, write the Free Software
> Foundation,
> > >> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > >>
> +#-----------------------------------------------------------------------
> > >> +#
> > >> +
> > >> +seq=`basename $0`
> > >> +seqres=$RESULT_DIR/$seq
> > >> +echo "QA output created by $seq"
> > >> +
> > >> +here=`pwd`
> > >> +tmp=`mktemp -d`
> > >> +status=1     # failure is the default!
> > >> +trap "_cleanup; exit \$status" 0 1 2 3 15
> > >> +
> > >> +_cleanup()
> > >> +{
> > >> +    rm -fr $tmp
> > >> +}
> > >> +
> > >> +# get standard environment, filters and checks
> > >> +. ./common/rc
> > >> +. ./common/filter
> > >> +
> > >> +# real QA test starts here
> > >> +_supported_fs btrfs
> > >> +_supported_os Linux
> > >> +_require_scratch
> > >> +_need_to_be_root
> > >> +
> > >> +FSSUM_PROG=$here/src/fssum
> > >> +[ -x $FSSUM_PROG ] || _notrun "fssum not built"
> > >> +
> > >> +rm -f $seqres.full
> Users don't stop doing doing stuff on a filesystem when a single
> failure occurs, so why should the tests? If you stop the moment a
> single failure occurs then you aren't ever going to stress the error
> handling paths, are you?
>
> > > _run_btrfs_util_prog()
> > > {
> > >         run_check $BTRFS_UTIL_PROG $*
> > > }
> > >
> > > would be a good start because it gets that run_check pattern out of
> > > the main test scripts and hence out of the heads of test writers.
> >
> > Well, will get rid of those run_check calls, but that will imply
> > adding some | _filter_scratch in many places. So shortening lines is
> > not a great argument :)
>
> I'm not talking about shortening lines here. I'm talking about the
> correct principles and conceptsi being in the forefront of a test
> writer's mind. Having the concept of "need to filter the output" in
> the head of test writers is *exactly* the right mindset to have.
>
> Indeed, if you have a block of code that needs common filtering,
> that's easy to do:
>
> do_test()
> {
>         # put test in function
> }
>
> do_test | _filter_scratch
>
> Will apply that filter to the entire output of the test, and so
> you don't need it on every command.
>
> Remember - an xfstest is not a "pass/fail" test. It's a "run this
> set of commands, and then check the entire output matches the known
> good output" test. i.e. we are testing the entire set of commands as
> a whole - we are not testing each individual command that is run.
> It's a very different principle to the "test every command that can
> fail" method of writing tests.
>
> _fail should only be used if the test cannot possibly be continued
> (e.g. scratch filesystem corrupted and cannot be mounted).  If one
> of the early commands fails, then that's fine - the test will fail -
> but we still want to run the other commands if we can so as to get
> the best test coverage we can get even on failed tests.


Thanks for the detailed explanation Dave, very useful :)



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

--bcaec52c63dfb6963004f290215b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>On Monday, February 17, 2014, Dave Chinner &lt;<a href=3D"mailto:da=
vid@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
On Sun, Feb 16, 2014 at 11:43:17PM +0000, Filipe David Manana wrote:<br>
&gt; On Sun, Feb 16, 2014 at 11:08 PM, Dave Chinner &lt;<a>david@fromorbit.=
com</a>&gt; wrote:<br>
&gt; &gt; On Sat, Feb 15, 2014 at 03:36:13PM +0000, Filipe David Borba Mana=
na wrote:<br>
&gt; &gt;&gt; Test for a btrfs incremental send issue where we end up sendi=
ng a<br>
&gt; &gt;&gt; wrong section of data from a file extent if the corresponding=
 file<br>
&gt; &gt;&gt; extent is compressed and the respective file extent item has =
a non<br>
&gt; &gt;&gt; zero data offset.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Fixed by the following linux kernel btrfs patch:<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; =C2=A0 =C2=A0Btrfs: use right clone root offset for compresse=
d extents<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Signed-off-by: Filipe David Borba Manana &lt;<a>fdmanana@gmai=
l.com</a>&gt;<br>
&gt; &gt;&gt; ---<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; V2: Made the test more reliable. Now it doesn&#39;t depend an=
ymore of btrfs&#39;<br>
&gt; &gt;&gt; =C2=A0 =C2=A0 hole punch implementation leaving hole file ext=
ent items when we punch<br>
&gt; &gt;&gt; =C2=A0 =C2=A0 beyond the file&#39;s current size.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; =C2=A0tests/btrfs/040 =C2=A0 =C2=A0 | =C2=A0115 +++++++++++++=
++++++++++++++++++++++++++++++++++++++<br>
&gt; &gt;&gt; =C2=A0tests/btrfs/040.out | =C2=A0 =C2=A01 +<br>
&gt; &gt;&gt; =C2=A0tests/btrfs/group =C2=A0 | =C2=A0 =C2=A01 +<br>
&gt; &gt;&gt; =C2=A03 files changed, 117 insertions(+)<br>
&gt; &gt;&gt; =C2=A0create mode 100755 tests/btrfs/040<br>
&gt; &gt;&gt; =C2=A0create mode 100644 tests/btrfs/040.out<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; diff --git a/tests/btrfs/040 b/tests/btrfs/040<br>
&gt; &gt;&gt; new file mode 100755<br>
&gt; &gt;&gt; index 0000000..d6b37bf<br>
&gt; &gt;&gt; --- /dev/null<br>
&gt; &gt;&gt; +++ b/tests/btrfs/040<br>
&gt; &gt;&gt; @@ -0,0 +1,115 @@<br>
&gt; &gt;&gt; +#! /bin/bash<br>
&gt; &gt;&gt; +# FS QA Test No. btrfs/040<br>
&gt; &gt;&gt; +#<br>
&gt; &gt;&gt; +# Test for a btrfs incremental send issue where we end up se=
nding a<br>
&gt; &gt;&gt; +# wrong section of data from a file extent if the correspond=
ing file<br>
&gt; &gt;&gt; +# extent is compressed and the respective file extent item h=
as a non<br>
&gt; &gt;&gt; +# zero data offset.<br>
&gt; &gt;&gt; +#<br>
&gt; &gt;&gt; +# Fixed by the following linux kernel btrfs patch:<br>
&gt; &gt;&gt; +#<br>
&gt; &gt;&gt; +# =C2=A0 Btrfs: use right clone root offset for compressed e=
xtents<br>
&gt; &gt;&gt; +#<br>
&gt; &gt;&gt; +#-----------------------------------------------------------=
------------<br>
&gt; &gt;&gt; +# Copyright (c) 2014 Filipe Manana. =C2=A0All Rights Reserve=
d.<br>
&gt; &gt;&gt; +#<br>
&gt; &gt;&gt; +# This program is free software; you can redistribute it and=
/or<br>
&gt; &gt;&gt; +# modify it under the terms of the GNU General Public Licens=
e as<br>
&gt; &gt;&gt; +# published by the Free Software Foundation.<br>
&gt; &gt;&gt; +#<br>
&gt; &gt;&gt; +# This program is distributed in the hope that it would be u=
seful,<br>
&gt; &gt;&gt; +# but WITHOUT ANY WARRANTY; without even the implied warrant=
y of<br>
&gt; &gt;&gt; +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =C2=
=A0See the<br>
&gt; &gt;&gt; +# GNU General Public License for more details.<br>
&gt; &gt;&gt; +#<br>
&gt; &gt;&gt; +# You should have received a copy of the GNU General Public =
License<br>
&gt; &gt;&gt; +# along with this program; if not, write the Free Software F=
oundation,<br>
&gt; &gt;&gt; +# Inc., =C2=A051 Franklin St, Fifth Floor, Boston, MA =C2=A0=
02110-1301 =C2=A0USA<br>
&gt; &gt;&gt; +#-----------------------------------------------------------=
------------<br>
&gt; &gt;&gt; +#<br>
&gt; &gt;&gt; +<br>
&gt; &gt;&gt; +seq=3D`basename $0`<br>
&gt; &gt;&gt; +seqres=3D$RESULT_DIR/$seq<br>
&gt; &gt;&gt; +echo &quot;QA output created by $seq&quot;<br>
&gt; &gt;&gt; +<br>
&gt; &gt;&gt; +here=3D`pwd`<br>
&gt; &gt;&gt; +tmp=3D`mktemp -d`<br>
&gt; &gt;&gt; +status=3D1 =C2=A0 =C2=A0 # failure is the default!<br>
&gt; &gt;&gt; +trap &quot;_cleanup; exit \$status&quot; 0 1 2 3 15<br>
&gt; &gt;&gt; +<br>
&gt; &gt;&gt; +_cleanup()<br>
&gt; &gt;&gt; +{<br>
&gt; &gt;&gt; + =C2=A0 =C2=A0rm -fr $tmp<br>
&gt; &gt;&gt; +}<br>
&gt; &gt;&gt; +<br>
&gt; &gt;&gt; +# get standard environment, filters and checks<br>
&gt; &gt;&gt; +. ./common/rc<br>
&gt; &gt;&gt; +. ./common/filter<br>
&gt; &gt;&gt; +<br>
&gt; &gt;&gt; +# real QA test starts here<br>
&gt; &gt;&gt; +_supported_fs btrfs<br>
&gt; &gt;&gt; +_supported_os Linux<br>
&gt; &gt;&gt; +_require_scratch<br>
&gt; &gt;&gt; +_need_to_be_root<br>
&gt; &gt;&gt; +<br>
&gt; &gt;&gt; +FSSUM_PROG=3D$here/src/fssum<br>
&gt; &gt;&gt; +[ -x $FSSUM_PROG ] || _notrun &quot;fssum not built&quot;<br=
>
&gt; &gt;&gt; +<br>
&gt; &gt;&gt; +rm -f $seqres.full<br>Users don&#39;t stop doing doing stuff=
 on a filesystem when a single<br>
failure occurs, so why should the tests? If you stop the moment a<br>
single failure occurs then you aren&#39;t ever going to stress the error<br=
>
handling paths, are you?<br>
<br>
&gt; &gt; _run_btrfs_util_prog()<br>
&gt; &gt; {<br>
&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 run_check $BTRFS_UTIL_PROG $*<br>
&gt; &gt; }<br>
&gt; &gt;<br>
&gt; &gt; would be a good start because it gets that run_check pattern out =
of<br>
&gt; &gt; the main test scripts and hence out of the heads of test writers.=
<br>
&gt;<br>
&gt; Well, will get rid of those run_check calls, but that will imply<br>
&gt; adding some | _filter_scratch in many places. So shortening lines is<b=
r>
&gt; not a great argument :)<br>
<br>
I&#39;m not talking about shortening lines here. I&#39;m talking about the<=
br>
correct principles and conceptsi being in the forefront of a test<br>
writer&#39;s mind. Having the concept of &quot;need to filter the output&qu=
ot; in<br>
the head of test writers is *exactly* the right mindset to have.<br>
<br>
Indeed, if you have a block of code that needs common filtering,<br>
that&#39;s easy to do:<br>
<br>
do_test()<br>
{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 # put test in function<br>
}<br>
<br>
do_test | _filter_scratch<br>
<br>
Will apply that filter to the entire output of the test, and so<br>
you don&#39;t need it on every command.<br>
<br>
Remember - an xfstest is not a &quot;pass/fail&quot; test. It&#39;s a &quot=
;run this<br>
set of commands, and then check the entire output matches the known<br>
good output&quot; test. i.e. we are testing the entire set of commands as<b=
r>
a whole - we are not testing each individual command that is run.<br>
It&#39;s a very different principle to the &quot;test every command that ca=
n<br>
fail&quot; method of writing tests.<br>
<br>
_fail should only be used if the test cannot possibly be continued<br>
(e.g. scratch filesystem corrupted and cannot be mounted). =C2=A0If one<br>
of the early commands fails, then that&#39;s fine - the test will fail -<br=
>
but we still want to run the other commands if we can so as to get<br>
the best test coverage we can get even on failed tests.</blockquote><div><b=
r></div><div>Thanks for the detailed explanation Dave, very useful :)</div>=
<div><br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"=
margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

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

--bcaec52c63dfb6963004f290215b--


--===============5961762970359424797==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5961762970359424797==--
