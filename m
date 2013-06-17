Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E567C7F37
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 05:57:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5C461AC001
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 03:57:22 -0700 (PDT)
Received: from mail-qe0-f51.google.com (mail-qe0-f51.google.com
	[209.85.128.51]) by cuda.sgi.com with ESMTP id mEyHyoUFqG8r0iUT
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 17 Jun 2013 03:57:15 -0700 (PDT)
Received: by mail-qe0-f51.google.com with SMTP id a11so1586586qen.10
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 03:57:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1597962722.1767244.1371447710942.JavaMail.root@redhat.com>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<419435719.1662203.1371431489790.JavaMail.root@redhat.com>
	<20130617024603.GJ29338@dastard>
	<1597962722.1767244.1371447710942.JavaMail.root@redhat.com>
Date: Mon, 17 Jun 2013 06:57:14 -0400
Message-ID: <CAC2B=ZENLd7hoP=U08hyb6xFw6ye0nL5MMW+iDnTXTcoKCYEvA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============2702422139783393369=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Nathan Scott <nathans@redhat.com>
Cc: xfs@oss.sgi.com

--===============2702422139783393369==
Content-Type: multipart/alternative; boundary=047d7bf0f41a9492cc04df57757b

--047d7bf0f41a9492cc04df57757b
Content-Type: text/plain; charset=ISO-8859-1

all - good conversation and again, thanks for digging into this.  The
comment about me running on an older kernel seems to be the problem and by
rerunning my test on precise/3.5.0-23-generic all seems to be operating
correctly, so I guess that was it.

However, the one thing that does jump out of this is that proc/fs/xsfstats
and pcp were both showing many hundred MB/sec during tests that only ran
for a few seconds, which is impossible so it still feels some like sort of
accounting bug to me.  On the other hand if the fact that this was an older
kernel, and newer kernels are fine, perhaps it's something just to note and
not worry about.

thanks again...

-mark


On Mon, Jun 17, 2013 at 1:41 AM, Nathan Scott <nathans@redhat.com> wrote:

> Hey Dave,
>
> ----- Original Message -----
> > ...
> > Must be an old version of RHEL6, because 6.4 doesn't do any IO at
> > all, same as upstream. This test workload is purely a metadata only
> > workload (no data is written) and so it all gets gathered up by
> > delayed logging.
>
> *nod* - RHEL6.3.
>
> > > I think it is still possible, FWIW.  One could use python ctypes (as in
> > > Marks test program) and achieve a page-aligned POSIX memalign,
> >
> > I wasn't aware you could get memalign() through python at all. I
> > went looking for this exact solution a couple of month ago when
> > these problems started to be reported and couldn't find anything
> > ...
>
> Yes, on reflection it doesn't jive too well with the way python wants
> to do reads, in particular - os.read takes a file and a size, there's
> no buffer exposed at the API level (for input).
>
> It would need to be a separate python module to the core set I guess
> (with a C component), and a slightly different API - or at least some
> additional APIs which can take in an aligned buffer, rather than just
> allocating one each time - but I believe it's still feasible.
>
> cheers.
>
> --
> Nathan
>

--047d7bf0f41a9492cc04df57757b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">all - good conversation and again, thanks for digging into=
 this. =A0The comment about me running on an older kernel seems to be the p=
roblem and by rerunning my test on precise/3.5.0-23-generic all seems to be=
 operating correctly, so I guess that was it.<div>
<br></div><div style>However, the one thing that does jump out of this is t=
hat proc/fs/xsfstats and pcp were both showing many hundred MB/sec during t=
ests that only ran for a few seconds, which is impossible so it still feels=
 some like sort of accounting bug to me. =A0On the other hand if the fact t=
hat this was an older kernel, and newer kernels are fine, perhaps it&#39;s =
something just to note and not worry about.</div>
<div style><br></div><div style>thanks again...</div><div style><br></div><=
div style>-mark</div></div><div class=3D"gmail_extra"><br><br><div class=3D=
"gmail_quote">On Mon, Jun 17, 2013 at 1:41 AM, Nathan Scott <span dir=3D"lt=
r">&lt;<a href=3D"mailto:nathans@redhat.com" target=3D"_blank">nathans@redh=
at.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hey Dave,<br>
<br>
----- Original Message -----<br>
&gt; ...<br>
<div class=3D"im">&gt; Must be an old version of RHEL6, because 6.4 doesn&#=
39;t do any IO at<br>
&gt; all, same as upstream. This test workload is purely a metadata only<br=
>
&gt; workload (no data is written) and so it all gets gathered up by<br>
&gt; delayed logging.<br>
<br>
</div>*nod* - RHEL6.3.<br>
<div class=3D"im"><br>
&gt; &gt; I think it is still possible, FWIW. =A0One could use python ctype=
s (as in<br>
&gt; &gt; Marks test program) and achieve a page-aligned POSIX memalign,<br=
>
&gt;<br>
&gt; I wasn&#39;t aware you could get memalign() through python at all. I<b=
r>
&gt; went looking for this exact solution a couple of month ago when<br>
&gt; these problems started to be reported and couldn&#39;t find anything<b=
r>
</div>&gt; ...<br>
<br>
Yes, on reflection it doesn&#39;t jive too well with the way python wants<b=
r>
to do reads, in particular - os.read takes a file and a size, there&#39;s<b=
r>
no buffer exposed at the API level (for input).<br>
<br>
It would need to be a separate python module to the core set I guess<br>
(with a C component), and a slightly different API - or at least some<br>
additional APIs which can take in an aligned buffer, rather than just<br>
allocating one each time - but I believe it&#39;s still feasible.<br>
<br>
cheers.<br>
<br>
--<br>
Nathan<br>
</blockquote></div><br></div>

--047d7bf0f41a9492cc04df57757b--


--===============2702422139783393369==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2702422139783393369==--
