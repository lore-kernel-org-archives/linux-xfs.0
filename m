Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBA8PxmN059929 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 02:25:59 -0600
Received: from mail-px0-f179.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E9F014F3ADE
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 00:26:34 -0800 (PST)
Received: from mail-px0-f179.google.com (mail-px0-f179.google.com
	[209.85.216.179]) by cuda.sgi.com with ESMTP id
	t9eJOCBNPCTqZk2Y for <xfs@oss.sgi.com>;
	Thu, 10 Dec 2009 00:26:34 -0800 (PST)
Received: by pxi9 with SMTP id 9so1133070pxi.32
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 00:26:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091130064356.GD30608@discord.disaster>
References: <409bd82b0911292117n5aa11961u86e787d20acbd2b3@mail.gmail.com>
	<20091130064356.GD30608@discord.disaster>
Date: Thu, 10 Dec 2009 13:56:32 +0530
Message-ID: <409bd82b0912100026v4a268ee7g827dfa663503c8f3@mail.gmail.com>
Subject: Re: Writing journal only in Big Endian format
From: Nitin Arora <nitin.arora.del@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2296647253303442056=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "sandeen-xfs@sandeen.net" <sandeen-xfs@sandeen.net>, "p.mironchik@velesys.com" <p.mironchik@velesys.com>, "hch@xfs.org" <hch@xfs.org>, xfs@oss.sgi.com

--===============2296647253303442056==
Content-Type: multipart/alternative; boundary=0016e64cb10e8b0d59047a5b907f

--0016e64cb10e8b0d59047a5b907f
Content-Type: text/plain; charset=ISO-8859-1

Thanks Dave and Eric for your kind support.
We will then see if it is worth putting in effort for these changes or not.

Thanks




On Mon, Nov 30, 2009 at 12:13 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Nov 30, 2009 at 10:47:41AM +0530, Nitin Arora wrote:
> > The problem is that big endian machine cannot recognize the
> > journal which was written in little endian format by the little
> > endian machine and once the journal is zerod out it can be
> > mouted.
> >
> > Now the solution to above problem seems writing journal always in
> > big endian format.
>
> Or you could just replay the log on the little endian machine and do
> a clean unmount, then you should be able to move it to the big
> endian machine without losing anything.
>
> > Please suggest me, Is there any design limitation in XFS for this.
>
> No design limitation, just a *lot* of work to change. If you don't
> have a few months handy to work on this, I'd just use the above
> method....
>
> > Is it okay and feasible to implement it if yes then please give
> > some pointers so that it can be implemented,
>
> All log headers, tails and sector fills need to be converted, every log
> item format routine needs a big-endian version, log recovery needs
> to be able to read both host-format and big-endian logs, all the
> userspace tools need to learn about different log formats, QA tests
> need to be written, etc.
>
> > under some suitable
> > compile time switch.
>
> It could be done with a superblock feature bit, so the same kernel
> could support both big-endian logs and host format.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0016e64cb10e8b0d59047a5b907f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks Dave and Eric for your kind support.<br>We will then see if it is wo=
rth putting in effort for these changes or not.<br><br>Thanks <br><br><br><=
br><br><div class=3D"gmail_quote">On Mon, Nov 30, 2009 at 12:13 PM, Dave Ch=
inner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fr=
omorbit.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class=3D"im"=
>On Mon, Nov 30, 2009 at 10:47:41AM +0530, Nitin Arora wrote:<br>
&gt; The problem is that big endian machine cannot recognize the<br>
&gt; journal which was written in little endian format by the little<br>
&gt; endian machine and once the journal is zerod out it can be<br>
&gt; mouted.<br>
&gt;<br>
&gt; Now the solution to above problem seems writing journal always in<br>
&gt; big endian format.<br>
<br>
</div>Or you could just replay the log on the little endian machine and do<=
br>
a clean unmount, then you should be able to move it to the big<br>
endian machine without losing anything.<br>
<div class=3D"im"><br>
&gt; Please suggest me, Is there any design limitation in XFS for this.<br>
<br>
</div>No design limitation, just a *lot* of work to change. If you don&#39;=
t<br>
have a few months handy to work on this, I&#39;d just use the above<br>
method....<br>
<div class=3D"im"><br>
&gt; Is it okay and feasible to implement it if yes then please give<br>
&gt; some pointers so that it can be implemented,<br>
<br>
</div>All log headers, tails and sector fills need to be converted, every l=
og<br>
item format routine needs a big-endian version, log recovery needs<br>
to be able to read both host-format and big-endian logs, all the<br>
userspace tools need to learn about different log formats, QA tests<br>
need to be written, etc.<br>
<div class=3D"im"><br>
&gt; under some suitable<br>
&gt; compile time switch.<br>
<br>
</div>It could be done with a superblock feature bit, so the same kernel<br=
>
could support both big-endian logs and host format.<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></blockquote></div><br>

--0016e64cb10e8b0d59047a5b907f--


--===============2296647253303442056==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2296647253303442056==--
