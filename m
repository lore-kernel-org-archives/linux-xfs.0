Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA67C7CBF
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 05:17:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B48FA304043
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 03:17:38 -0700 (PDT)
Received: from mail-qc0-f182.google.com (mail-qc0-f182.google.com
	[209.85.216.182]) by cuda.sgi.com with ESMTP id
	ArbKVXtpRKIGXEoP (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 03:17:37 -0700 (PDT)
Received: by mail-qc0-f182.google.com with SMTP id e10so2208242qcy.27
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 03:17:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130618001540.GL29376@dastard>
References: <CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<419435719.1662203.1371431489790.JavaMail.root@redhat.com>
	<20130617024603.GJ29338@dastard>
	<1597962722.1767244.1371447710942.JavaMail.root@redhat.com>
	<CAC2B=ZENLd7hoP=U08hyb6xFw6ye0nL5MMW+iDnTXTcoKCYEvA@mail.gmail.com>
	<20130617111347.GL29338@dastard>
	<CAC2B=ZGm4W=oFY+8sWAefhH79qK5N7yma4qQh_AQaOGiQDUWhw@mail.gmail.com>
	<CAAxjCEwhwqFhPbJsJGYUCqwF5qc7iZpNJpELOkR-9NNuPzFxBw@mail.gmail.com>
	<20130618001540.GL29376@dastard>
Date: Tue, 18 Jun 2013 06:17:36 -0400
Message-ID: <CAC2B=ZGnithifLgnNV_j-8f=H+TSo=8TLyS93Hh=2L9w6XqC=w@mail.gmail.com>
Subject: Re: definitions for /proc/fs/xfs/stat
From: Mark Seger <mjseger@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3466991838748009942=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Stefan Ring <stefanrin@gmail.com>, Nathan Scott <nathans@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

--===============3466991838748009942==
Content-Type: multipart/alternative; boundary=047d7bf0f41ab5784804df6b05e0

--047d7bf0f41ab5784804df6b05e0
Content-Type: text/plain; charset=ISO-8859-1

mark - good point about the controller cache and the 1-bye/block, but
remember my files in this case are only 1 block.
dave - a long time ago I found/reported a bug in the way linux was doing
their block stats.  They were basically incrementing the byte counts as
block were written to cache and the reported numbers were ridiculously
high.  I had wondered if something like this could be going on, but also
remember the numbers being reported by xfs are much too high.  I did 10K 1K
writes, which I do understand are really 1-4k page each, but that's still
only 40MB.  If I add up all the 500MB/sec bytes xfs logging is reporting
(even one of which is over 10 times larger), I see something on the order
of of 10GB.  But again this IS with the older kernel and so may not be
worth worrying about.
-mark


On Mon, Jun 17, 2013 at 8:15 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Jun 17, 2013 at 10:28:19PM +0200, Stefan Ring wrote:
> > > I asked around and people believe the cache is on the order of a few
> GB and
> > > the test ran I was intentionally large enough to overshadow any cache
> > > effects, running for about a minute and doing 100K 1K file creates.
>  The
> > > disk write data was close to a sustained 475MB/sec and would have
> easily
> > > filled the cache in the first handful of seconds which would have
> produced
> > > enough backpressure to slow down the write rate which it never did.
> >
> > If a limited number of blocks gets written over and over, you won't
> > ever fill the cache.
>
> Right, and the XFS log is circular and about 1GB in size on the
> filesystem under test, so should fit completely in cache. Hence
> speeds faster than a physical disk are acheivable if the log stays
> resident in the cache....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7bf0f41ab5784804df6b05e0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">mark - good point about the controller cache and the 1-bye=
/block, but remember my files in this case are only 1 block.=A0<div style>d=
ave - a long time ago I found/reported a bug in the way linux was doing the=
ir block stats. =A0They were basically incrementing the byte counts as bloc=
k were written to cache and the reported numbers were=A0ridiculously high. =
=A0I had wondered if something like this could be going on, but also rememb=
er the numbers being reported by xfs are much too high. =A0I did 10K 1K wri=
tes, which I do understand are really 1-4k page each, but that&#39;s still =
only 40MB. =A0If I add up all the 500MB/sec bytes xfs logging is reporting =
(even one of which is over 10 times larger), I see something on the order o=
f of 10GB. =A0But again this IS with the older kernel and so may not be wor=
th worrying about.</div>
<div style>-mark</div></div><div class=3D"gmail_extra"><br><br><div class=
=3D"gmail_quote">On Mon, Jun 17, 2013 at 8:15 PM, Dave Chinner <span dir=3D=
"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fr=
omorbit.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On M=
on, Jun 17, 2013 at 10:28:19PM +0200, Stefan Ring wrote:<br>
&gt; &gt; I asked around and people believe the cache is on the order of a =
few GB and<br>
&gt; &gt; the test ran I was intentionally large enough to overshadow any c=
ache<br>
&gt; &gt; effects, running for about a minute and doing 100K 1K file create=
s. =A0The<br>
&gt; &gt; disk write data was close to a sustained 475MB/sec and would have=
 easily<br>
&gt; &gt; filled the cache in the first handful of seconds which would have=
 produced<br>
&gt; &gt; enough backpressure to slow down the write rate which it never di=
d.<br>
&gt;<br>
&gt; If a limited number of blocks gets written over and over, you won&#39;=
t<br>
&gt; ever fill the cache.<br>
<br>
</div></div>Right, and the XFS log is circular and about 1GB in size on the=
<br>
filesystem under test, so should fit completely in cache. Hence<br>
speeds faster than a physical disk are acheivable if the log stays<br>
resident in the cache....<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div>

--047d7bf0f41ab5784804df6b05e0--


--===============3466991838748009942==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3466991838748009942==--
