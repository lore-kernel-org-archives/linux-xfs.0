Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A3BC17CA3
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 04:20:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 688778F80A1
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 02:20:49 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	a5XWmBiLoHRhFbWX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2016 02:20:47 -0700 (PDT)
Received: by mail-io0-f181.google.com with SMTP id p194so69910745iod.1
	for <xfs@oss.sgi.com>; Fri, 03 Jun 2016 02:20:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160603005324.GS12670@dastard>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<20160510061054.GI26977@dastard>
	<CACj3i715X7X65=BjSW8GZLhUF-YjQVShC-_Udmxe24XB1ACb1w@mail.gmail.com>
	<20160603005324.GS12670@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 3 Jun 2016 11:20:27 +0200
Message-ID: <CACj3i70LGZ7TKWRdKVTi4MyyL5DhnH5Fr-3Q6O5qhKbYfvWJbA@mail.gmail.com>
Subject: Re: [PATCH 00/19 v2] mkfs cleaning
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7952063941769495864=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--===============7952063941769495864==
Content-Type: multipart/alternative; boundary=001a113ee27ee2b06205345c3c7d

--001a113ee27ee2b06205345c3c7d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 3, 2016 at 2:53 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Jun 01, 2016 at 03:19:34PM +0200, Jan Tulak wrote:
> > On Tue, May 10, 2016 at 8:10 AM, Dave Chinner <david@fromorbit.com>
> wrote:
> >
> > >
> > > Looking at xfstests runs, new failures are:
> > >
> > > generic/054 -
> > > generic/055 - both fail with:
> > >
> > > +*** mkfs failed: -l version=3D2,su=3D4096 ***
> > >
> > > and the .full file has this specific error:
> > >
> > > Illegal value 4096 for -l su option. value is too small
> > >
> > > indicating that we should be allowing (2^N * block size) log
> > > stripe units to be set. This will be a limit configuration issue,
> > > most likely needing fixing in mkfs.
> > >
> >
> > =E2=80=8BI'm looking on it, but this issue was introduced by Eric's fix=
 for
> > patch "mkfs:
> > table based parsing for converted parameters":
> >
> > =E2=80=8B> =E2=80=8B
> > The kernel enforces a max of XLOG_MAX_RECORD_BSIZE,
> > =E2=80=8B> =E2=80=8B
> > and it should match the limits in L_SUNIT after all ...
>
> So nobody got it right, then.  i.e. Eric's changes made it the same
> as what was in my original patchset, which means *I got it wrong*,
> too.
>
> Really, it's not at all important who made the incorrect change or
> why it was wrong - it's easy very make mistakes or get complex
> things wrong. What matters is that we identify the problem code, we
> fix the problem, and we try not to make the same error again.
> Mistakes are a learning opportunity for everyone, not just the
> person who wrote or reviewed the code.
>
> =E2=80=8BYeah, I was just trying to get together all the info. =E2=80=8B


> > And looking on fs/xfs/xfs_super.c, the MIN value is enforced too. So
> maybe
> > it is the test what needs fixing? Otherwise, I would put something
> > like XFS_MIN_SECTORSIZE there.
> >
> > See http://lxr.free-electrons.com/source/fs/xfs/xfs_super.c#L435
>
> mp->m_logbsize is the incore log buffer size and this is checking
> that the iclogsize passed in as a mount option is within the valid
> range (16k->256k). It is not checking stripe unit alignment limits.
> We can write an iclogbuf at any sector offset in the log; the log
> stripe unit is simply an alignment guide. i.e. a lsunit =3D 4096 is 8
> sector alignment, so the iclogbuf when written is padded out to 8
> sector boundaries so that log writes are always aligned and sized to
> the log stripe unit.
>
> The only actual limit on iclogbuf size vs lsunit is that the
> iclogbuf size must be >=3D than the lsunit, which limits the lsunit
> to XLOG_MAX_RECORD_BSIZE. i.e valid range for specifying lsunit on
> the command line is 1 <=3D lsunit <=3D XLOG_MAX_RECORD_BSIZE.
>

OK. Only, it seems we mixed lsu and lsunit. From manpage: lsunit is
specified in 512-bytes block units.

So the correct ranges for both lsunit and lsu should be:
1 <=3D lsunit <=3D BTOBB(XLOG_MAX_RECORD_BSIZE)
BBTOB(1) <=3D lsu <=3D XLOG_MAX_RECORD_BSIZE

Which will be further limited from the bottom by the physical block size,
but that check is already in place and working.

If this sounds ok, I will send the patch.

Cheers,
Jan


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113ee27ee2b06205345c3c7d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Fri, Jun 3, 2016 at 2:53 AM, Dave Chinner <span dir=3D"ltr"=
>&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorb=
it.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;bord=
er-left-color:rgb(204,204,204);padding-left:1ex"><span class=3D"">On Wed, J=
un 01, 2016 at 03:19:34PM +0200, Jan Tulak wrote:<br>
&gt; On Tue, May 10, 2016 at 8:10 AM, Dave Chinner &lt;<a href=3D"mailto:da=
vid@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt;<br>
&gt; &gt; Looking at xfstests runs, new failures are:<br>
&gt; &gt;<br>
&gt; &gt; generic/054 -<br>
&gt; &gt; generic/055 - both fail with:<br>
&gt; &gt;<br>
&gt; &gt; +*** mkfs failed: -l version=3D2,su=3D4096 ***<br>
&gt; &gt;<br>
&gt; &gt; and the .full file has this specific error:<br>
&gt; &gt;<br>
&gt; &gt; Illegal value 4096 for -l su option. value is too small<br>
&gt; &gt;<br>
&gt; &gt; indicating that we should be allowing (2^N * block size) log<br>
&gt; &gt; stripe units to be set. This will be a limit configuration issue,=
<br>
&gt; &gt; most likely needing fixing in mkfs.<br>
&gt; &gt;<br>
&gt;<br>
&gt; =E2=80=8BI&#39;m looking on it, but this issue was introduced by Eric&=
#39;s fix for<br>
&gt; patch &quot;mkfs:<br>
&gt; table based parsing for converted parameters&quot;:<br>
&gt;<br>
&gt; =E2=80=8B&gt; =E2=80=8B<br>
&gt; The kernel enforces a max of XLOG_MAX_RECORD_BSIZE,<br>
&gt; =E2=80=8B&gt; =E2=80=8B<br>
&gt; and it should match the limits in L_SUNIT after all ...<br>
<br>
</span>So nobody got it right, then.=C2=A0 i.e. Eric&#39;s changes made it =
the same<br>
as what was in my original patchset, which means *I got it wrong*,<br>
too.<br>
<br>
Really, it&#39;s not at all important who made the incorrect change or<br>
why it was wrong - it&#39;s easy very make mistakes or get complex<br>
things wrong. What matters is that we identify the problem code, we<br>
fix the problem, and we try not to make the same error again.<br>
Mistakes are a learning opportunity for everyone, not just the<br>
person who wrote or reviewed the code.<br>
<span class=3D""><br></span></blockquote><div><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BYe=
ah, I was just trying to get together all the info. =E2=80=8B</div>=C2=A0</=
div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left-width:1px;border-left-style:solid;border-left-color:rgb(204,204,20=
4);padding-left:1ex"><span class=3D"">
&gt; And looking on fs/xfs/xfs_super.c, the MIN value is enforced too. So m=
aybe<br>
&gt; it is the test what needs fixing? Otherwise, I would put something<br>
&gt; like XFS_MIN_SECTORSIZE there.<br>
&gt;<br>
&gt; See <a href=3D"http://lxr.free-electrons.com/source/fs/xfs/xfs_super.c=
#L435" rel=3D"noreferrer" target=3D"_blank">http://lxr.free-electrons.com/s=
ource/fs/xfs/xfs_super.c#L435</a><br>
<br>
</span>mp-&gt;m_logbsize is the incore log buffer size and this is checking=
<br>
that the iclogsize passed in as a mount option is within the valid<br>
range (16k-&gt;256k). It is not checking stripe unit alignment limits.<br>
We can write an iclogbuf at any sector offset in the log; the log<br>
stripe unit is simply an alignment guide. i.e. a lsunit =3D 4096 is 8<br>
sector alignment, so the iclogbuf when written is padded out to 8<br>
sector boundaries so that log writes are always aligned and sized to<br>
the log stripe unit.<br>
<br>
The only actual limit on iclogbuf size vs lsunit is that the<br>
iclogbuf size must be &gt;=3D than the lsunit, which limits the lsunit<br>
to XLOG_MAX_RECORD_BSIZE. i.e valid range for specifying lsunit on<br>
the command line is 1 &lt;=3D lsunit &lt;=3D XLOG_MAX_RECORD_BSIZE.<br>
<div class=3D""><div class=3D"h5"></div></div></blockquote></div><div class=
=3D"gmail_extra"><br></div><div class=3D"gmail_default" style=3D"font-famil=
y:arial,helvetica,sans-serif">OK. Only, it seems we mixed lsu and lsunit. F=
rom manpage: lsunit is specified in 512-bytes block units.=C2=A0</div><div =
class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"><b=
r></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,s=
ans-serif">So the correct ranges for both lsunit and lsu should be:</div><d=
iv class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"=
><span style=3D"font-family:arial,sans-serif">1 &lt;=3D lsunit &lt;=3D BTOB=
B(XLOG_MAX_RECORD_BSIZE)</span></div><div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif"><span style=3D"font-family:arial,sa=
ns-serif">BBTOB(1) &lt;=3D lsu &lt;=3D=C2=A0</span><span style=3D"font-fami=
ly:arial,sans-serif">XLOG_MAX_RECORD_BSIZE</span></div><div class=3D"gmail_=
default" style=3D"font-family:arial,helvetica,sans-serif"><span style=3D"fo=
nt-family:arial,sans-serif"><br></span></div><div class=3D"gmail_default">W=
hich will be further limited from the bottom by the=C2=A0physical block siz=
e, but that check is already in place and working.</div><div class=3D"gmail=
_extra"><br></div><div class=3D"gmail_default" style=3D"font-family:arial,h=
elvetica,sans-serif">If this sounds ok, I will send the patch.</div><div cl=
ass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"><br>=
</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,san=
s-serif">Cheers,</div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">Jan</div><br clear=3D"all"><div><br></div>-- <br><=
div class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=
=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jt=
ulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"=
mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></div></=
div>
</div></div>

--001a113ee27ee2b06205345c3c7d--


--===============7952063941769495864==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7952063941769495864==--
