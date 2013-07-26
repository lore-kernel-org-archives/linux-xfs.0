Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 377CD29E32
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 16:04:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2602430407B
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 14:04:56 -0700 (PDT)
Received: from mail-ve0-f170.google.com (mail-ve0-f170.google.com
	[209.85.128.170]) by cuda.sgi.com with ESMTP id
	NaOWBv16rxUYW8xT (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 14:04:55 -0700 (PDT)
Received: by mail-ve0-f170.google.com with SMTP id 14so1636228vea.29
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 14:04:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130726205018.GM3111@sgi.com>
References: <1374823420041-35002.post@n7.nabble.com>
	<20130726115021.GO13468@dastard>
	<CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
	<51F2CD8B.8080207@hardwarefreak.com>
	<CAA+BczQGYoJVL0twvz2GRhH30teFPSJOsKWtofbXBrom4_Q6hg@mail.gmail.com>
	<20130726205018.GM3111@sgi.com>
Date: Fri, 26 Jul 2013 17:04:54 -0400
Message-ID: <CAA+BczSpn7Cu2rZWJ9Q2b1-Xh0365R9ykGxKHHymtRm2Q7xCuA@mail.gmail.com>
Subject: Re: understanding speculative preallocation
From: Jason Rosenberg <jbr@squareup.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7039149387723894253=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

--===============7039149387723894253==
Content-Type: multipart/alternative; boundary=047d7b342f4491e39d04e2707ee4

--047d7b342f4491e39d04e2707ee4
Content-Type: text/plain; charset=ISO-8859-1

Thanks Ben,

This is helpful.


On Fri, Jul 26, 2013 at 4:50 PM, Ben Myers <bpm@sgi.com> wrote:

> Hi Jason,
>
> On Fri, Jul 26, 2013 at 04:38:21PM -0400, Jason Rosenberg wrote:
> > Thanks for the info (most of it was, in fact, news to me).  I'm an
> > application developer trying to debug a disk space problem, that's all.
>  So
> > far, I've tracked it down to being an XFS issue.
>
> The speculative block reservations have been an issue for awhile.  You are
> not
> the first person to take issue with it.
>
> > Regardless, is there a version history for XFS vis-a-via mainline Linux?
>
> You can find a full version history for XFS back to 2.6.12 or so here:
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=summary
>
> If you're interested in going older than that look here:
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=summary
>
> The function you'll most likely want to track is xfs_iomap_write_delay,
> which
> calls xfs_iomap_eof_want_preallocate, both of which are in
> fs/xfs/xfs_iomap.c.
>
> Recently Brian Foster added a scanner to remove the speculative block
> reservations on a timer which may give you some relief.  See
> xfs_queue_eofblocks in fs/xfs/xfs_icache.c
>
> Regards,
>         Ben
>
>

--047d7b342f4491e39d04e2707ee4
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks Ben,<div><br></div><div>This is helpful.</div></div=
><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Fri, Jul =
26, 2013 at 4:50 PM, Ben Myers <span dir=3D"ltr">&lt;<a href=3D"mailto:bpm@=
sgi.com" target=3D"_blank">bpm@sgi.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hi Jason,<br>
<div class=3D"im"><br>
On Fri, Jul 26, 2013 at 04:38:21PM -0400, Jason Rosenberg wrote:<br>
&gt; Thanks for the info (most of it was, in fact, news to me). =A0I&#39;m =
an<br>
&gt; application developer trying to debug a disk space problem, that&#39;s=
 all. =A0So<br>
&gt; far, I&#39;ve tracked it down to being an XFS issue.<br>
<br>
</div>The speculative block reservations have been an issue for awhile. =A0=
You are not<br>
the first person to take issue with it.<br>
<div class=3D"im"><br>
&gt; Regardless, is there a version history for XFS vis-a-via mainline Linu=
x?<br>
<br>
</div>You can find a full version history for XFS back to 2.6.12 or so here=
:<br>
<a href=3D"http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Dxfs/xfs.git;a=3Dsummar=
y" target=3D"_blank">http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Dxfs/xfs.git;=
a=3Dsummary</a><br>
<br>
If you&#39;re interested in going older than that look here:<br>
<a href=3D"http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Darchive/xfs-import.git=
;a=3Dsummary" target=3D"_blank">http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Da=
rchive/xfs-import.git;a=3Dsummary</a><br>
<br>
The function you&#39;ll most likely want to track is xfs_iomap_write_delay,=
 which<br>
calls xfs_iomap_eof_want_preallocate, both of which are in fs/xfs/xfs_iomap=
.c.<br>
<br>
Recently Brian Foster added a scanner to remove the speculative block<br>
reservations on a timer which may give you some relief. =A0See<br>
xfs_queue_eofblocks in fs/xfs/xfs_icache.c<br>
<br>
Regards,<br>
=A0 =A0 =A0 =A0 Ben<br>
<br>
</blockquote></div><br></div>

--047d7b342f4491e39d04e2707ee4--


--===============7039149387723894253==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7039149387723894253==--
