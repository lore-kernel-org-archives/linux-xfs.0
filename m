Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5F2647CF6
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 09:43:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B185CAC003
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 07:43:12 -0700 (PDT)
Received: from mail-io0-f179.google.com (mail-io0-f179.google.com
	[209.85.223.179]) by cuda.sgi.com with ESMTP id
	DFRLuQAiceS3hlgP (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 29 Apr 2016 07:43:06 -0700 (PDT)
Received: by mail-io0-f179.google.com with SMTP id 190so104001115iow.1
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 07:43:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160429015927.GN18496@dastard>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461832149-18276-1-git-send-email-jtulak@redhat.com>
	<20160429015927.GN18496@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 29 Apr 2016 16:42:46 +0200
Message-ID: <CACj3i72T-zQbM+c+EhY6ys4pcccsXq=-kNOEWSQXO-E2=qXNOQ@mail.gmail.com>
Subject: Re: [RFC PATCH] xfstests: Add mkfs input validation tests
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8541394956913147908=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

--===============8541394956913147908==
Content-Type: multipart/alternative; boundary=001a114079ae2c88430531a0a9ff

--001a114079ae2c88430531a0a9ff
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 29, 2016 at 3:59 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Apr 28, 2016 at 10:29:09AM +0200, Jan Tulak wrote:
> > Test inputs for my mkfs-cleaning patchset. This test will fail with the
> old sphageti code mkfs, among others because the old code accepts incorre=
ct
> values.
> >
> >
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Jan Tulak <jtulak@redhat.com>
>
> Please don't strip the commit messages from patches you've picked up
> from other people - it loses valuable information, as well as the
> original author of the code. i.e. The original commit message was:
>
> =E2=80=8BSorry about that. I removed it mistakenly long time ago, and now=
, I
didn't realised I should copy yours instead of making my own.



>
> From: Dave Chinner <dchinner@redhat.com>
>
> mkfs.xfs does not do a very good job of input validation. This test
> is designed to exercise the input validation and test good/bad
> combinations of options being set. It will not pass on a current
> mkfs.xfs binary - it is designed to be the test case for a input
> validation cleanup.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>
> > ---
> >
> > Hi guys,
> >
> > I'm sending this patch although the mentioned patchset is not yet merge=
d.
> > It might help you a bit with checking if there are any issues with
> > the patchset, as here it is clear, what options works and what not.
>
> in which case, a "_require_xfs_mkfs_validation" rule should be
> written to determine the version of mkfs being. e.g. by testing one
> of the failure cases that the unfixed binary says is ok.
> ....
> > +# basic "should fail" options
> > +# logarithm based options are no longer valid
> > +# NOTE: umm, when it got invalid? It seems to be still supported...
> > +#do_mkfs_fail -s log=3D10 $SCRATCH_DEV
> > +#do_mkfs_fail -b log=3D10 $SCRATCH_DEV
> > +#do_mkfs_fail -n log=3D10 $SCRATCH_DEV
> > +#do_mkfs_fail -i log=3D10 $SCRATCH_DEV
> > +#do_mkfs_fail -d sectlog=3D10 $SCRATCH_DEV
> > +#do_mkfs_fail -l sectlog=3D10 $SCRATCH_DEV
>
> They were expected to fail because I was going to remove the log
> options from mkfs as part of the cleanup series because they are
> redundant and nobody uses them. i.e this test was written with what
> I wanted as the end result of the mkfs input validation cleanup, not
> an iteration of the current behaviour.
>
> After all the data section tests, the new tests you've added all
> seem to be pretty ad-hoc.  What I was fleshing out in this test was
> a relatively complete set exercising each the different options mkfs
> supports.
>
> I'd only iterated data section options so far in this test. I'd just
> started on the naming section tests, and had not added any but a
> basic test. That needs to be iterated, as do the inode, log (both
> internal and external), metadata and realtime options....
>
> =E2=80=8BI added many of the new lines when I found some issue, to preven=
t
regressions. But yeah, I will put it into an orderly fashion and iterate
through other things


>
> > +# invalid file section tests
> > +rm -f $fsimg
> > +$XFS_IO_PROG -f -c "truncate $fssize" $fsimg
> > +do_mkfs_fail -d file $fsimg
> > +do_mkfs_fail -d file,name=3D$fsimg
>
> Why should these fail - size should not be required if the image
> file already exists and is of sufficient size....
>

=E2=80=8BWell, they should pass. I'm sending an updated patch to the set as=
 well.


> > +
> > +# naming section tests
> > +do_mkfs_pass -n size=3D65536 $SCRATCH_DEV
> > +
> > +# boolean options
> > +$XFS_IO_PROG -f -c "truncate $fssize" $fsimg
> > +do_mkfs_pass -d file=3D1,size=3D$fssize $fsimg
> > +do_mkfs_pass -d file=3D0 $SCRATCH_DEV
> > +do_mkfs_fail -d file=3D1 $SCRATCH_DEV
>
> More image file tests, belong in the data section with the other
> image file tests.
> =E2=80=8B=E2=80=8B
>

> > +# Specific flag combinations where some bug appeared during developmen=
t,
> > +# to catch the same issue if it re-appears. If there are multiple
> similar
> > +# checks, move them to a standalone block.
> > +
> > +
> > +do_mkfs_pass -m crc=3D1,finobt=3D1 $SCRATCH_DEV
>
> What about all the other invalid cases?
>
> > +do_mkfs_pass -m crc=3D1 -n ftype=3D1 $SCRATCH_DEV
> > +do_mkfs_pass -m crc=3D0 -n ftype=3D1 $SCRATCH_DEV
> > +do_mkfs_fail -m crc=3D1 -n ftype=3D0 $SCRATCH_DEV
> > +do_mkfs_pass -m crc=3D0 -n ftype=3D0 $SCRATCH_DEV
> > +do_mkfs_pass -n ftype=3D1 -m crc=3D0 $SCRATCH_DEV
>
> One of the cleanup requirements was that option parsing would not
> be order sensitive, so I don't think you need to iterate parameters
> in different orders. That would just blow out the test matrix
> unnecessarily. Also, if you really need to repeat the same test but
> with different orders, please place those tests sequentially in the
> file so it's clear that they are duplicate/order swapped tests....
> =E2=80=8B
>

=E2=80=8BI added it as a test that the order independency really works. Thi=
s is one
case, where the original code was order-dependent... But maybe such test is
not necessary, as it should be so by design and there is no way to screw it
up for all options at once. =E2=80=8B



=E2=80=8BSo to sum all the email, I will make an updated version with more =
test
data. However, it will take me some time, because in few days, exams on my
university are starting, so I need to focus there and start learning.=E2=80=
=8B :-)

Thanks and cheers,
Jan


=E2=80=8B
>
>
> > +# if user states crc=3D0,finobt=3D1, fail instead of warning
> > +do_mkfs_fail -m crc=3D0,finobt=3D1 $SCRATCH_DEV
>
> Why is this separate to the other crc,finobt test? Please try to
> keep the parameter checks in logical groupings....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
=E2=80=8B

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a114079ae2c88430531a0a9ff
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Fri, Ap=
r 29, 2016 at 3:59 AM, Dave Chinner </span><span dir=3D"ltr" style=3D"font-=
family:arial,sans-serif">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex"><span>On Thu, Apr 28, 2016 at 10:29:09A=
M +0200, Jan Tulak wrote:<br>
&gt; Test inputs for my mkfs-cleaning patchset. This test will fail with th=
e old sphageti code mkfs, among others because the old code accepts incorre=
ct values.<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; Signed-off-by: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com"=
 target=3D"_blank">dchinner@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Jan Tulak &lt;<a href=3D"mailto:jtulak@redhat.com" targ=
et=3D"_blank">jtulak@redhat.com</a>&gt;<br>
<br>
</span>Please don&#39;t strip the commit messages from patches you&#39;ve p=
icked up<br>
from other people - it loses valuable information, as well as the<br>
original author of the code. i.e. The original commit message was:<br>
<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">=E2=80=8BSorry about that. I removed it mistakenly=
 long time ago, and now, I didn&#39;t realised I should copy yours instead =
of making my own.</div><br></div><div>=C2=A0</div><blockquote class=3D"gmai=
l_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-lef=
t-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">
<br>
From: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com" target=3D"_bl=
ank">dchinner@redhat.com</a>&gt;<br>
<br>
mkfs.xfs does not do a very good job of input validation. This test<br>
is designed to exercise the input validation and test good/bad<br>
combinations of options being set. It will not pass on a current<br>
mkfs.xfs binary - it is designed to be the test case for a input<br>
validation cleanup.<br>
<br>
Signed-off-by: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com" targ=
et=3D"_blank">dchinner@redhat.com</a>&gt;<br>
<span><br>
&gt; ---<br>
&gt;<br>
&gt; Hi guys,<br>
&gt;<br>
&gt; I&#39;m sending this patch although the mentioned patchset is not yet =
merged.<br>
&gt; It might help you a bit with checking if there are any issues with<br>
&gt; the patchset, as here it is clear, what options works and what not.<br=
>
<br>
</span>in which case, a &quot;_require_xfs_mkfs_validation&quot; rule shoul=
d be<br>
written to determine the version of mkfs being. e.g. by testing one<br>
of the failure cases that the unfixed binary says is ok.<br>
....<br>
<span>&gt; +# basic &quot;should fail&quot; options<br>
&gt; +# logarithm based options are no longer valid<br>
&gt; +# NOTE: umm, when it got invalid? It seems to be still supported...<b=
r>
&gt; +#do_mkfs_fail -s log=3D10 $SCRATCH_DEV<br>
&gt; +#do_mkfs_fail -b log=3D10 $SCRATCH_DEV<br>
&gt; +#do_mkfs_fail -n log=3D10 $SCRATCH_DEV<br>
&gt; +#do_mkfs_fail -i log=3D10 $SCRATCH_DEV<br>
&gt; +#do_mkfs_fail -d sectlog=3D10 $SCRATCH_DEV<br>
&gt; +#do_mkfs_fail -l sectlog=3D10 $SCRATCH_DEV<br>
<br>
</span>They were expected to fail because I was going to remove the log<br>
options from mkfs as part of the cleanup series because they are<br>
redundant and nobody uses them. i.e this test was written with what<br>
I wanted as the end result of the mkfs input validation cleanup, not<br>
an iteration of the current behaviour.<br>
<br>
After all the data section tests, the new tests you&#39;ve added all<br>
seem to be pretty ad-hoc.=C2=A0 What I was fleshing out in this test was<br=
>
a relatively complete set exercising each the different options mkfs<br>
supports.<br>
<br>
I&#39;d only iterated data section options so far in this test. I&#39;d jus=
t<br>
started on the naming section tests, and had not added any but a<br>
basic test. That needs to be iterated, as do the inode, log (both<br>
internal and external), metadata and realtime options....<br>
<span><br></span></blockquote><div class=3D"gmail_default" style=3D"font-fa=
mily:arial,helvetica,sans-serif">=E2=80=8BI added many of the new lines whe=
n I found some issue, to prevent regressions. But yeah, I will put it into =
an orderly fashion and iterate through other things</div><div>=C2=A0</div><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;pa=
dding-left:1ex"><span>
<br>
&gt; +# invalid file section tests<br>
&gt; +rm -f $fsimg<br>
&gt; +$XFS_IO_PROG -f -c &quot;truncate $fssize&quot; $fsimg<br>
&gt; +do_mkfs_fail -d file $fsimg<br>
&gt; +do_mkfs_fail -d file,name=3D$fsimg<br>
<br>
</span>Why should these fail - size should not be required if the image<br>
file already exists and is of sufficient size....<br></blockquote><div><br>=
</div><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetic=
a,sans-serif">=E2=80=8BWell, they should pass. I&#39;m sending an updated p=
atch to the set as well.</div></div><div>=C2=A0</div><blockquote class=3D"g=
mail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-=
left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex"><span=
>
&gt; +<br>
&gt; +# naming section tests<br>
&gt; +do_mkfs_pass -n size=3D65536 $SCRATCH_DEV<br>
&gt; +<br>
&gt; +# boolean options<br>
&gt; +$XFS_IO_PROG -f -c &quot;truncate $fssize&quot; $fsimg<br>
&gt; +do_mkfs_pass -d file=3D1,size=3D$fssize $fsimg<br>
&gt; +do_mkfs_pass -d file=3D0 $SCRATCH_DEV<br>
&gt; +do_mkfs_fail -d file=3D1 $SCRATCH_DEV<br>
<br>
</span>More image file tests, belong in the data section with the other<br>
image file tests.<div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;display:inline">=E2=80=8B=E2=80=8B</div></blockquote><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-lef=
t-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;padd=
ing-left:1ex">
<span><br>
&gt; +# Specific flag combinations where some bug appeared during developme=
nt,<br>
&gt; +# to catch the same issue if it re-appears. If there are multiple sim=
ilar<br>
&gt; +# checks, move them to a standalone block.<br>
&gt; +<br>
&gt; +<br>
&gt; +do_mkfs_pass -m crc=3D1,finobt=3D1 $SCRATCH_DEV<br>
<br>
</span>What about all the other invalid cases?<br>
<span><br>
&gt; +do_mkfs_pass -m crc=3D1 -n ftype=3D1 $SCRATCH_DEV<br>
&gt; +do_mkfs_pass -m crc=3D0 -n ftype=3D1 $SCRATCH_DEV<br>
&gt; +do_mkfs_fail -m crc=3D1 -n ftype=3D0 $SCRATCH_DEV<br>
&gt; +do_mkfs_pass -m crc=3D0 -n ftype=3D0 $SCRATCH_DEV<br>
&gt; +do_mkfs_pass -n ftype=3D1 -m crc=3D0 $SCRATCH_DEV<br>
<br>
</span>One of the cleanup requirements was that option parsing would not<br=
>
be order sensitive, so I don&#39;t think you need to iterate parameters<br>
in different orders. That would just blow out the test matrix<br>
unnecessarily. Also, if you really need to repeat the same test but<br>
with different orders, please place those tests sequentially in the<br>
file so it&#39;s clear that they are duplicate/order swapped tests....<div =
class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;dis=
play:inline">=E2=80=8B</div></blockquote><div><br></div><div><div class=3D"=
gmail_default" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BI =
added it as a test that the order independency really works. This is one ca=
se, where the original code was order-dependent... But maybe such test is n=
ot necessary, as it should be so by design and there is no way to screw it =
up for all options at once. =E2=80=8B</div><br></div><div><br></div><div><b=
r></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,s=
ans-serif">=E2=80=8BSo to sum all the email, I will make an updated version=
 with more test data. However, it will take me some time, because in few da=
ys, exams on my university are starting, so I need to focus there and start=
 learning.=E2=80=8B :-)</div><div class=3D"gmail_default" style=3D"font-fam=
ily:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_default" styl=
e=3D"font-family:arial,helvetica,sans-serif">Thanks and cheers,</div><div c=
lass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">Jan=
</div><div><br></div><div><br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(20=
4,204,204);border-left-style:solid;padding-left:1ex"><div class=3D"gmail_de=
fault" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=
=80=8B</div><br>
<span><br>
&gt; +# if user states crc=3D0,finobt=3D1, fail instead of warning<br>
&gt; +do_mkfs_fail -m crc=3D0,finobt=3D1 $SCRATCH_DEV<br>
<br>
</span>Why is this separate to the other crc,finobt test? Please try to<br>
keep the parameter checks in logical groupings....<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
</font></span></blockquote></div><div class=3D"gmail_default" style=3D"font=
-family:arial,helvetica,sans-serif">=E2=80=8B</div><div><br></div>-- <br><d=
iv><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=
=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0=
/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div><=
/div></div></div>
</div></div>

--001a114079ae2c88430531a0a9ff--


--===============8541394956913147908==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8541394956913147908==--
