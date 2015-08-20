Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD9C37F47
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 02:33:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5760CAC008
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 00:33:54 -0700 (PDT)
Received: from mail-io0-f177.google.com (mail-io0-f177.google.com
	[209.85.223.177]) by cuda.sgi.com with ESMTP id
	aZNcWzuuWBhk8G1G (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2015 00:33:52 -0700 (PDT)
Received: by iodb91 with SMTP id b91so36702307iod.1
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 00:33:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150820002251.GN3902@dastard>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-6-git-send-email-jtulak@redhat.com>
	<20150818214557.GC3902@dastard>
	<20150819080940.GA13130@infradead.org> <20150819102623.GK3902@dastard>
	<20150820002251.GN3902@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 20 Aug 2015 09:33:33 +0200
Message-ID: <CACj3i70p4mfqs9HZbxzbnJaGXB=vxNHPUggx183Z_yLYHdP9PA@mail.gmail.com>
Subject: Re: [PATCH 05/11] xfsprogs: missing and dummy calls for OS X support
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5387177293745152710=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

--===============5387177293745152710==
Content-Type: multipart/alternative; boundary=001a11402b3a449ad5051db92c95

--001a11402b3a449ad5051db92c95
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2015 at 2:22 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Aug 19, 2015 at 08:26:23PM +1000, Dave Chinner wrote:
> > On Wed, Aug 19, 2015 at 01:09:40AM -0700, Christoph Hellwig wrote:
> > > On Wed, Aug 19, 2015 at 07:45:57AM +1000, Dave Chinner wrote:
> > > > Hmmm, looks like I accidentally comitted an earlier version of this
> > > > patch yesterday. Jan, can you send delta patches to what I committe=
d
> > > > to address more recent review comments? Sorry, my bad.
> > >
> > > Can you revert it for now? I think most of these changes are incorrec=
t
> > > and should either be dropped for now by disabling fsx or will need
> > > a major rework.
> >
> > I'll just rebase the for-next branch, I guess, and remove it
> > completely from the history. I've got another lockdep fix that needs
> > to be pushed before it all hits tomorrow's linux-next build, anyway.
>
> Getting my trees mixed up. I'll revert the patch on the next push.


=E2=80=8BAnd as I noticed, '
xfsprogs: Add includes required for OS X builds
=E2=80=8B' was =E2=80=8Balso
selected in an older version. Other patches looks OK, though. :-)
Should I send delta patch for that one? It is just about three #includes.

=E2=80=8BCheers,
Jan=E2=80=8B


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a11402b3a449ad5051db92c95
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Thu, Aug 20, 2015 at 2:22 AM, Dave Chinner <span dir=3D"ltr=
">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromor=
bit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=
=3D"">On Wed, Aug 19, 2015 at 08:26:23PM +1000, Dave Chinner wrote:<br>
&gt; On Wed, Aug 19, 2015 at 01:09:40AM -0700, Christoph Hellwig wrote:<br>
&gt; &gt; On Wed, Aug 19, 2015 at 07:45:57AM +1000, Dave Chinner wrote:<br>
&gt; &gt; &gt; Hmmm, looks like I accidentally comitted an earlier version =
of this<br>
&gt; &gt; &gt; patch yesterday. Jan, can you send delta patches to what I c=
ommitted<br>
&gt; &gt; &gt; to address more recent review comments? Sorry, my bad.<br>
&gt; &gt;<br>
&gt; &gt; Can you revert it for now? I think most of these changes are inco=
rrect<br>
&gt; &gt; and should either be dropped for now by disabling fsx or will nee=
d<br>
&gt; &gt; a major rework.<br>
&gt;<br>
&gt; I&#39;ll just rebase the for-next branch, I guess, and remove it<br>
&gt; completely from the history. I&#39;ve got another lockdep fix that nee=
ds<br>
&gt; to be pushed before it all hits tomorrow&#39;s linux-next build, anywa=
y.<br>
<br>
</span>Getting my trees mixed up. I&#39;ll revert the patch on the next pus=
h.</blockquote><div><br></div><div><div class=3D"gmail_default" style=3D"fo=
nt-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BAnd as I noti=
ced, &#39;</div>xfsprogs: Add includes required for OS X builds<div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;display:=
inline">=E2=80=8B&#39; was =E2=80=8Balso</div></div><div><div class=3D"gmai=
l_default" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=
selected in an older version. Other patches looks OK, though. :-)</div></di=
v><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sa=
ns-serif;display:inline">Should I send delta patch for that one? It is just=
 about three #includes.</div></div></div><div><br></div><div><div class=3D"=
gmail_default" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BCh=
eers,</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetic=
a,sans-serif">Jan=E2=80=8B</div><br></div><div><br></div>-- <br><div class=
=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<=
br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redh=
at.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tul=
ak.me</a></div></div></div></div>
</div></div>

--001a11402b3a449ad5051db92c95--


--===============5387177293745152710==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5387177293745152710==--
