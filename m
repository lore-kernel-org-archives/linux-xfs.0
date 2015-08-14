Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B1FF27F88
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 01:13:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3675FAC002
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 23:13:16 -0700 (PDT)
Received: from mail-ig0-f179.google.com (mail-ig0-f179.google.com
	[209.85.213.179]) by cuda.sgi.com with ESMTP id
	1U1nTlCO0xt4l1Fn (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 23:13:11 -0700 (PDT)
Received: by igui7 with SMTP id i7so6164598igu.1
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 23:13:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150814015704.GV3902@dastard>
References: <55C43FBA.1080408@sandeen.net>
	<20150807113742.GB8322@bfoster.bfoster>
	<55C4E007.90709@sandeen.net>
	<CACj3i72_w6fKaJyDhaHb-vEA056kSSQnucWkWfO2LsVxci+yfA@mail.gmail.com>
	<20150814015704.GV3902@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 14 Aug 2015 08:12:49 +0200
Message-ID: <CACj3i70ZOzmpM6Zb+7JZ59nA0GJfJ-FU+h22S5ZA4vbFUAjSCA@mail.gmail.com>
Subject: Re: [PATCH] mkfs.xfs: fix ftype-vs-crc option combination testing
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3039194504297518876=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--===============3039194504297518876==
Content-Type: multipart/alternative; boundary=089e01182a34a3a7d2051d3f58bb

--089e01182a34a3a7d2051d3f58bb
Content-Type: text/plain; charset=UTF-8

On Fri, Aug 14, 2015 at 3:57 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Aug 13, 2015 at 01:14:25PM +0200, Jan Tulak wrote:
> > On Fri, Aug 7, 2015 at 6:42 PM, Eric Sandeen <sandeen@sandeen.net>
> wrote:
> > >
> > > >
> > > > IIRC, I think this is one of the core problems the big mkfs option
> > > > parsing rework that Jan is working on is supposed to fix.
> > >
> > > Yeah, I think so - Jan, if this gets in your way, let us know -
> > > I didn't mean to make your life difficult by fixing little
> > > things while you work.  :)
> >
> > Well, I would not mind if the entire codebase froze... :-D
> > But realistically, every time I do git fetch I get so many collisions
> that
> > one
> > more or less changes nothing. :-)
>
> Well, I'm hoping all the big changes getting libxfs up to date with
> the kernel code are now done, and things will settle down for the
> next few months so this will be less of a problem. Also having a
> stable master branch and a moving for-next branch for xfsprogs
> should help with this, too...
>

That would be nice.


> > And yes, in my tests I'm trying to cover the arguments order issue too.
>
> The structure of the table-based parsing should make the order of
> parsing irrelevant, as conflicts are defined in the table and so
> will be detected regardless of the order in which the options appear
> on the command line.
>

However it still has to be tested if it works as supposed. Of course I'm not
trying all combinations for all arguments. :-)

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

--089e01182a34a3a7d2051d3f58bb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Fri, Aug 14, 2015 at 3:57 AM, Dave Chinner <span dir=3D"ltr">&lt;<a =
href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</=
a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0=
 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On =
Thu, Aug 13, 2015 at 01:14:25PM +0200, Jan Tulak wrote:<br>
&gt; On Fri, Aug 7, 2015 at 6:42 PM, Eric Sandeen &lt;<a href=3D"mailto:san=
deen@sandeen.net">sandeen@sandeen.net</a>&gt; wrote:<br>
&gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; IIRC, I think this is one of the core problems the big mkfs =
option<br>
&gt; &gt; &gt; parsing rework that Jan is working on is supposed to fix.<br=
>
&gt; &gt;<br>
&gt; &gt; Yeah, I think so - Jan, if this gets in your way, let us know -<b=
r>
&gt; &gt; I didn&#39;t mean to make your life difficult by fixing little<br=
>
&gt; &gt; things while you work.=C2=A0 :)<br>
&gt;<br>
&gt; Well, I would not mind if the entire codebase froze... :-D<br>
&gt; But realistically, every time I do git fetch I get so many collisions =
that<br>
&gt; one<br>
&gt; more or less changes nothing. :-)<br>
<br>
</span>Well, I&#39;m hoping all the big changes getting libxfs up to date w=
ith<br>
the kernel code are now done, and things will settle down for the<br>
next few months so this will be less of a problem. Also having a<br>
stable master branch and a moving for-next branch for xfsprogs<br>
should help with this, too...<br></blockquote><div><br></div><div>That woul=
d be nice.</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=
=3D"">
&gt; And yes, in my tests I&#39;m trying to cover the arguments order issue=
 too.<br>
<br>
</span>The structure of the table-based parsing should make the order of<br=
>
parsing irrelevant, as conflicts are defined in the table and so<br>
will be detected regardless of the order in which the options appear<br>
on the command line.<br></blockquote></div><div><br></div><div>However it s=
till has to be tested if it works as supposed. Of course I&#39;m not</div><=
div>trying all combinations for all arguments. :-)</div><div><br></div><div=
>Cheers,</div><div>Jan</div><div><br></div>-- <br><div class=3D"gmail_signa=
ture"><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@red=
hat.com" target=3D"_blank">jtulak@redhat.com</a><br></div></div>
</div></div>

--089e01182a34a3a7d2051d3f58bb--


--===============3039194504297518876==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3039194504297518876==--
