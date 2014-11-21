Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEA547F3F
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 10:36:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6EEE0AC005
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 08:36:37 -0800 (PST)
Received: from mail-ig0-f169.google.com (mail-ig0-f169.google.com
	[209.85.213.169]) by cuda.sgi.com with ESMTP id
	jE7YtoVKONgQ1NWR (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Nov 2014 08:36:35 -0800 (PST)
Received: by mail-ig0-f169.google.com with SMTP id hl2so1852108igb.4
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 08:36:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141119001941.GA37095@bfoster.bfoster>
References: <CAJtCNH0tgtCw0F7322b_qvbM9-uGGSsLLiPQj6jk1yyvWDQMYg@mail.gmail.com>
	<20141118133206.GA5226@bfoster.bfoster>
	<20141118223518.GR23575@dastard>
	<20141119001941.GA37095@bfoster.bfoster>
Date: Fri, 21 Nov 2014 22:06:35 +0530
Message-ID: <CAJtCNH2irjpu3T57XPHPXHZ0FXm7V-diaA4g3DtjAmcRV2xmWA@mail.gmail.com>
Subject: Re: How to determine the reserved blocks in xfs filesystem ?
From: Mukul Malhotra <smilemukul2005@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7162235599344135061=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

--===============7162235599344135061==
Content-Type: multipart/alternative; boundary=089e0112ccea5499cb0508610c89

--089e0112ccea5499cb0508610c89
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thanks a lot for the solution.

=E2=80=8BMukul

On Wed, Nov 19, 2014 at 5:49 AM, Brian Foster <bfoster@redhat.com> wrote:

> On Wed, Nov 19, 2014 at 09:35:18AM +1100, Dave Chinner wrote:
> > On Tue, Nov 18, 2014 at 08:32:07AM -0500, Brian Foster wrote:
> > > On Tue, Nov 18, 2014 at 06:05:58PM +0530, Mukul Malhotra wrote:
> > > > =E2=80=8BHello,
> > > >
> > > > Does xfs have reserved blocks too, like ext* ? if yes, how can they
> be
> > > > determined ?=E2=80=8B
> > > >
> > >
> > > XFS reserves blocks internally such that it can perform operations wh=
en
> > > all free space is consumed, etc. It looks like 5% is the default.
> >
> > Not quite.
> >
> >         /*
> >          * We default to 5% or 8192 fsbs of space reserved, whichever i=
s
> >          * smaller.  This is intended to cover concurrent allocation
> >          * transactions when we initially hit enospc. These each requir=
e
> a 4
> >          * block reservation. Hence by default we cover roughly 2000
> concurrent
> >          * allocation reservations.
> >          */
> >
> > So, in most cases, there are 32MB of reserved blocks available for
> > internal emergency use.
> >
>
> Yep, I glossed right over the hard cap... thanks. ;)
>
> Brian
>
> > > I don't think it's "like ext4," however, which reserves blocks for th=
e
> > > root user. I don't believe the reserved blocks in XFS are accessible
> for
> > > file allocation by any user unless the reserve pool is modified as
> such.
> >
> > Most definitely not "like ext4". The reserved blocks are considered
> > "used space" (i.e. not available to any user) and are reported as
> > such in statfs() output (e.g. via df).
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
>

--089e0112ccea5499cb0508610c89
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-size:small">Tha=
nks a lot for the solution.<br></div><div class=3D"gmail_extra"><br clear=
=3D"all"><div><div class=3D"gmail_signature"><div dir=3D"ltr"><div class=3D=
"gmail_default" style=3D"font-size:small;display:inline">=E2=80=8BMukul<br>=
</div></div></div></div>
<br><div class=3D"gmail_quote">On Wed, Nov 19, 2014 at 5:49 AM, Brian Foste=
r <span dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redhat.com" target=3D"_bl=
ank">bfoster@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex"><span class=3D"">On Wed, Nov 19, 2014 at 09:35:18AM +1100, Dave Chinne=
r wrote:<br>
&gt; On Tue, Nov 18, 2014 at 08:32:07AM -0500, Brian Foster wrote:<br>
&gt; &gt; On Tue, Nov 18, 2014 at 06:05:58PM +0530, Mukul Malhotra wrote:<b=
r>
&gt; &gt; &gt; =E2=80=8BHello,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Does xfs have reserved blocks too, like ext* ? if yes, how c=
an they be<br>
&gt; &gt; &gt; determined ?=E2=80=8B<br>
&gt; &gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; XFS reserves blocks internally such that it can perform operation=
s when<br>
&gt; &gt; all free space is consumed, etc. It looks like 5% is the default.=
<br>
&gt;<br>
&gt; Not quite.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * We default to 5% or 8192 fsbs of s=
pace reserved, whichever is<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * smaller.=C2=A0 This is intended to=
 cover concurrent allocation<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * transactions when we initially hit=
 enospc. These each require a 4<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * block reservation. Hence by defaul=
t we cover roughly 2000 concurrent<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * allocation reservations.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;<br>
&gt; So, in most cases, there are 32MB of reserved blocks available for<br>
&gt; internal emergency use.<br>
&gt;<br>
<br>
</span>Yep, I glossed right over the hard cap... thanks. ;)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Brian<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; &gt; I don&#39;t think it&#39;s &quot;like ext4,&quot; however, which =
reserves blocks for the<br>
&gt; &gt; root user. I don&#39;t believe the reserved blocks in XFS are acc=
essible for<br>
&gt; &gt; file allocation by any user unless the reserve pool is modified a=
s such.<br>
&gt;<br>
&gt; Most definitely not &quot;like ext4&quot;. The reserved blocks are con=
sidered<br>
&gt; &quot;used space&quot; (i.e. not available to any user) and are report=
ed as<br>
&gt; such in statfs() output (e.g. via df).<br>
&gt;<br>
&gt; Cheers,<br>
&gt;<br>
&gt; Dave.<br>
&gt; --<br>
&gt; Dave Chinner<br>
&gt; <a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div></div>

--089e0112ccea5499cb0508610c89--


--===============7162235599344135061==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7162235599344135061==--
