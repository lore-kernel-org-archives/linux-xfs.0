Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B989C7F61
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 07:13:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32126AC002
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 05:13:48 -0800 (PST)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com
	[209.85.223.174]) by cuda.sgi.com with ESMTP id
	gVE3r7PoKASZumvb (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 05:13:43 -0800 (PST)
Received: by iouu10 with SMTP id u10so24762311iou.0
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 05:13:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5642550C.4040603@redhat.com>
References: <56423596.3030300@redhat.com> <20151110202806.GG14311@dastard>
	<5642550C.4040603@redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 11 Nov 2015 14:13:23 +0100
Message-ID: <CACj3i732qQdTLU+zMar2VZXMvz-+TQjHSk069ubTxgMRVWMDYQ@mail.gmail.com>
Subject: Re: [PATCH] xfsprogs: fix cut & paste error in xfs_fsr.c
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8337339461303167935=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8337339461303167935==
Content-Type: multipart/alternative; boundary=001a114032fc761b9405244398e3

--001a114032fc761b9405244398e3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2015 at 9:35 PM, Eric Sandeen <sandeen@redhat.com> wrote:

> > On Tue, Nov 10, 2015 at 12:21:10PM -0600, Eric Sandeen wrote:
> >> Commit:
> >>
> >> 7141fc xfsprogs: make fsr use mntinfo when there is no mntent
> >>
> >> added an inadvertent "break;" to initallfs() after the call
> >> to find_mountpoint_check(); this is likely a cut & paste error
> >> from the call in find_mountpoint(), where we really *do* want to
> >> stop after the first one we find.
> >>
> >> Fix that by removing the break, and fix the declaration-after-code.
> >
> > That's not the right fix - the find_mountpoint_check() shoul dnot be
> > there at all. Patch to clean it all up is below.
> >
> > -Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
> >
> > fsr: clean up mountpoint checks
> >
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Fix up a stray hunk of code from commit 7141fc5 ("xfsprogs: make fsr
> > use mntinfo when there is no mntent") that coverity reported. Also
> > clean up a couple of whitespace issues introduced with that  commit,
> > too.
>
> Um, ok, well it wasn't your misapplication, it was there in the original
> patch,
> and I wasn't sure of Jan's intent, having gone so far as to add local var=
s
> to support that placement.  ;)
>
> This seems fine, I guess I'll send another patch to make *ms local to
> find_mountpoint_check(), and rename some vars ("sb" and "mp" have their
> own expected meanings in xfsprogs)
>

=E2=80=8BHmmm, sorry about the mess... :-( I will look on the patch again t=
oo.
Speaking about  Coverity, is there a way I can get to it and use it myself?
(Maybe it may be b=E2=80=8Better to continue this off list - from what I he=
ard,
Coverity guys don't like to be talk about publicly...)

Cheers,
Jan


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a114032fc761b9405244398e3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Tue, No=
v 10, 2015 at 9:35 PM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-=
family:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@redhat.com" target=
=3D"_blank">sandeen@redhat.com</a>&gt;</span><span style=3D"font-family:ari=
al,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div clas=
s=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px=
 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-=
left-style:solid;padding-left:1ex"><span class=3D"">&gt; On Tue, Nov 10, 20=
15 at 12:21:10PM -0600, Eric Sandeen wrote:<br>
&gt;&gt; Commit:<br>
&gt;&gt;<br>
&gt;&gt; 7141fc xfsprogs: make fsr use mntinfo when there is no mntent<br>
&gt;&gt;<br>
&gt;&gt; added an inadvertent &quot;break;&quot; to initallfs() after the c=
all<br>
&gt;&gt; to find_mountpoint_check(); this is likely a cut &amp; paste error=
<br>
&gt;&gt; from the call in find_mountpoint(), where we really *do* want to<b=
r>
&gt;&gt; stop after the first one we find.<br>
&gt;&gt;<br>
&gt;&gt; Fix that by removing the break, and fix the declaration-after-code=
.<br>
&gt;<br>
&gt; That&#39;s not the right fix - the find_mountpoint_check() shoul dnot =
be<br>
&gt; there at all. Patch to clean it all up is below.<br>
&gt;<br>
&gt; -Dave.<br>
&gt; --<br>
&gt; Dave Chinner<br>
&gt; <a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
&gt;<br>
&gt; fsr: clean up mountpoint checks<br>
&gt;<br>
&gt; From: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchinner=
@redhat.com</a>&gt;<br>
&gt;<br>
&gt; Fix up a stray hunk of code from commit 7141fc5 (&quot;xfsprogs: make =
fsr<br>
&gt; use mntinfo when there is no mntent&quot;) that coverity reported. Als=
o<br>
&gt; clean up a couple of whitespace issues introduced with that=C2=A0 comm=
it,<br>
&gt; too.<br>
<br>
</span>Um, ok, well it wasn&#39;t your misapplication, it was there in the =
original patch,<br>
and I wasn&#39;t sure of Jan&#39;s intent, having gone so far as to add loc=
al vars<br>
to support that placement.=C2=A0 ;)<br>
<br>
This seems fine, I guess I&#39;ll send another patch to make *ms local to<b=
r>
find_mountpoint_check(), and rename some vars (&quot;sb&quot; and &quot;mp&=
quot; have their<br>
own expected meanings in xfsprogs)<br></blockquote></div><div class=3D"gmai=
l_extra"><br></div><div class=3D"gmail_default" style=3D"font-family:arial,=
helvetica,sans-serif">=E2=80=8BHmmm, sorry about the mess... :-( I will loo=
k on the patch again too.</div><div class=3D"gmail_default" style=3D"font-f=
amily:arial,helvetica,sans-serif">Speaking about =C2=A0Coverity, is there a=
 way I can get to it and use it myself? (Maybe it may be b=E2=80=8Better to=
 continue this off list - from what I heard, Coverity guys don&#39;t like t=
o be talk about publicly...)</div><div class=3D"gmail_default" style=3D"fon=
t-family:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_default"=
 style=3D"font-family:arial,helvetica,sans-serif">Cheers,</div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">Jan</di=
v><br clear=3D"all"><div><br></div>-- <br><div class=3D"gmail_signature"><d=
iv dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mai=
lto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a hr=
ef=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></=
div></div>
</div></div>

--001a114032fc761b9405244398e3--


--===============8337339461303167935==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8337339461303167935==--
