Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1I73gOT015995 for <xfs@oss.sgi.com>; Wed, 18 Feb 2009 01:03:43 -0600
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B603512D806
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 23:03:08 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.243]) by cuda.sgi.com with ESMTP id
	yZ40VtYj1VtpZOye for <xfs@oss.sgi.com>;
	Tue, 17 Feb 2009 23:03:08 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id c5so2228239rvf.32
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 23:03:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090217093824.GB15620@infradead.org>
References: <20090216102845.GA6835@infradead.org>
	<d38e348a0902161608r466a2582pfd5fd75e17a66f12@mail.gmail.com>
	<20090217093824.GB15620@infradead.org>
Date: Wed, 18 Feb 2009 17:38:48 +1100
Message-ID: <d38e348a0902172238r5cf807adoc455636b86b59913@mail.gmail.com>
Subject: Re: [PATCH] xfsdump: fix system() error reporting
From: Timothy Shimmin <timothy.shimmin@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4309195628864833161=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

--===============4309195628864833161==
Content-Type: multipart/alternative; boundary=000e0cd255341787cb04632bacfe

--000e0cd255341787cb04632bacfe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Tue, Feb 17, 2009 at 8:38 PM, Christoph Hellwig <hch@infradead.org>wrote:

> On Tue, Feb 17, 2009 at 11:08:33AM +1100, Timothy Shimmin wrote:
> > Hi Christoph,
> >
> > Looks reasonable.
> > Though, in the case of returning -1, it might be more interesting
> > to know the value of errno ? (I presume errno would be set in that case).
>
> From looking at the manpage and the glibc implementation it seem like
> system does not actually set errno.
>
>
Fair enough.

Yeah, it didn't seem clear in the man page and
I thought it might make a call to fork, waitpid etc which might set an
errno.

Cheers,
Tim.

--000e0cd255341787cb04632bacfe
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 17, 2009 at 8:38 PM, Christoph Hellwig <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:hch@infradead.org">hch@infradead.org</a>&gt;</span> wrote:<=
br><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"bo=
rder-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding=
-left: 1ex;">
<div class=3D"Ih2E3d">On Tue, Feb 17, 2009 at 11:08:33AM +1100, Timothy Shi=
mmin wrote:<br>
&gt; Hi Christoph,<br>
&gt;<br>
&gt; Looks reasonable.<br>
&gt; Though, in the case of returning -1, it might be more interesting<br>
&gt; to know the value of errno ? (I presume errno would be set in that cas=
e).<br>
<br>
</div>From looking at the manpage and the glibc implementation it seem like=
<br>
system does not actually set errno.<br>
<br>
</blockquote></div><br>Fair enough.<br><br>Yeah, it didn&#39;t seem clear i=
n the man page and<br>I thought it might make a call to fork, waitpid etc w=
hich might set an errno.<br><br>Cheers,<br>Tim.<br>

--000e0cd255341787cb04632bacfe--


--===============4309195628864833161==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4309195628864833161==--
