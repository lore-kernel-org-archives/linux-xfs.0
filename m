Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13D7E7CA7
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 10:08:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D59C58F8033
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 08:08:54 -0700 (PDT)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	sEUR8hEpMTcoMwGq (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 08:08:52 -0700 (PDT)
Received: by mail-io0-f171.google.com with SMTP id o126so73856143iod.0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 08:08:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160408230843.GE567@dastard>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-18-git-send-email-jtulak@redhat.com>
	<20160408000910.GB21804@dastard>
	<CACj3i73f_v=70pGrrLkRpHB-6UwiOOM2F9Sbu2aZMaJGmBLeiQ@mail.gmail.com>
	<20160408230843.GE567@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 13 Apr 2016 17:08:33 +0200
Message-ID: <CACj3i71Grs8deYRtTaGmTmgBTrge-VKQKpn1Azj_y8=KQHWbgg@mail.gmail.com>
Subject: Re: [PATCH 17/19] xfsprogs: disable truncating of files
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2791860749284124662=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============2791860749284124662==
Content-Type: multipart/alternative; boundary=001a113eb35ede269b05305f277f

--001a113eb35ede269b05305f277f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 9, 2016 at 1:08 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Apr 08, 2016 at 12:06:35PM +0200, Jan Tulak wrote:
> > On Fri, Apr 8, 2016 at 2:09 AM, Dave Chinner <david@fromorbit.com>
> wrote:
> >
> > > On Thu, Mar 24, 2016 at 12:15:34PM +0100, jtulak@redhat.com wrote:
> > > > From: Jan Tulak <jtulak@redhat.com>
> > > >
> > > > Unify mkfs.xfs behaviour a bit and never truncate files. If the use=
r
> > > > is trying to mkfs an existing file, we don't want to destroy anythi=
ng
> > > > he did with the file before (sparse file, allocations...)
> > >
> > > Why not? We do that with discard-by-default to block devices,
> > > O_TRUNC is exactly the same situation with a file - we completely
> > > re-initialise the file from a known state if mkfs has been asked to
> > > create the file.
> > >
> > But AFAIK, we don't zero-out entire spindle devices,
>
> Unless the controller above them supports discard or whatever
> implementation the storage protocol uses (e.g. UNMAP or WRITE_SAME).
> e.g, the "spindle devices" often are big raid arrays that are using
> thin provisioning, compression and dedupe internally, so running
> discard on them does make a significant difference to their
> behaviour.
>
> > we don't ask if the drive skips some blocks (i.e. because they are bad)=
,
>
> That's irrelevant to the issue at hand.
>
> > and we don't care
> > about what an underlaying layer (like LVM) did with the block device.
>
> Actually, we do, because users care about their storage stack doing
> sane management operations automatically.
>
> That's why we issued a discard - it tells the underlying devices to
> re-initialise the storage on this device *if they care about such
> things*. Stuff like thinly provisioned devices rely on mkfs
> behaviour like this to recycle used storage efficiently and
> transparently. The user expects things to "just work" and this is
> one of those things that makes it "just work".
>
> > From
> > this point of view, we shouldn't care about the file either.
> >
> > I can be missing something, though.
>
> I think you're missing the fact that we don't know what the
> *underlying storage* cares about, so we need to tell them in some
> way that a device or image file is being re-initialised from
> scratch. Whether that is by truncating the image file (so the
> filesytem can issue discards on the now unused space) or by issuing
> discard ioctls ourselves, it really doesn't matter. The key point is
> that we have a mechanism that allows us to notify the underlying
> storage of the "this is re-initialised storage" intent of mkfs.
>
> So from that perspective, the O_TRUNC behaviour should remain.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

All right=E2=80=8B, I will keep the O_TRUNC there. However, should it trunc=
ate the
file every time, or should we offer a way how to avoid the file truncating?
Until now, mkfs behaved differently based on whether -d file was given, or
not. Your explanation suggests that we should truncate every time, right?


=E2=80=8BCheers,
Jan=E2=80=8B



--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113eb35ede269b05305f277f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Sat, Apr 9, 2016 at 1:08 AM, Dave Chinner <span dir=3D"ltr"=
>&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorb=
it.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"=
margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=
=3D"">On Fri, Apr 08, 2016 at 12:06:35PM +0200, Jan Tulak wrote:<br>
&gt; On Fri, Apr 8, 2016 at 2:09 AM, Dave Chinner &lt;<a href=3D"mailto:dav=
id@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Thu, Mar 24, 2016 at 12:15:34PM +0100, <a href=3D"mailto:jtula=
k@redhat.com">jtulak@redhat.com</a> wrote:<br>
&gt; &gt; &gt; From: Jan Tulak &lt;<a href=3D"mailto:jtulak@redhat.com">jtu=
lak@redhat.com</a>&gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Unify mkfs.xfs behaviour a bit and never truncate files. If =
the user<br>
&gt; &gt; &gt; is trying to mkfs an existing file, we don&#39;t want to des=
troy anything<br>
&gt; &gt; &gt; he did with the file before (sparse file, allocations...)<br=
>
&gt; &gt;<br>
&gt; &gt; Why not? We do that with discard-by-default to block devices,<br>
&gt; &gt; O_TRUNC is exactly the same situation with a file - we completely=
<br>
&gt; &gt; re-initialise the file from a known state if mkfs has been asked =
to<br>
&gt; &gt; create the file.<br>
&gt; &gt;<br>
&gt; But AFAIK, we don&#39;t zero-out entire spindle devices,<br>
<br>
</span>Unless the controller above them supports discard or whatever<br>
implementation the storage protocol uses (e.g. UNMAP or WRITE_SAME).<br>
e.g, the &quot;spindle devices&quot; often are big raid arrays that are usi=
ng<br>
thin provisioning, compression and dedupe internally, so running<br>
discard on them does make a significant difference to their<br>
behaviour.<br>
<span class=3D""><br>
&gt; we don&#39;t ask if the drive skips some blocks (i.e. because they are=
 bad),<br>
<br>
</span>That&#39;s irrelevant to the issue at hand.<br>
<span class=3D""><br>
&gt; and we don&#39;t care<br>
&gt; about what an underlaying layer (like LVM) did with the block device.<=
br>
<br>
</span>Actually, we do, because users care about their storage stack doing<=
br>
sane management operations automatically.<br>
<br>
That&#39;s why we issued a discard - it tells the underlying devices to<br>
re-initialise the storage on this device *if they care about such<br>
things*. Stuff like thinly provisioned devices rely on mkfs<br>
behaviour like this to recycle used storage efficiently and<br>
transparently. The user expects things to &quot;just work&quot; and this is=
<br>
one of those things that makes it &quot;just work&quot;.<br>
<span class=3D""><br>
&gt; From<br>
&gt; this point of view, we shouldn&#39;t care about the file either.<br>
&gt;<br>
&gt; I can be missing something, though.<br>
<br>
</span>I think you&#39;re missing the fact that we don&#39;t know what the<=
br>
*underlying storage* cares about, so we need to tell them in some<br>
way that a device or image file is being re-initialised from<br>
scratch. Whether that is by truncating the image file (so the<br>
filesytem can issue discards on the now unused space) or by issuing<br>
discard ioctls ourselves, it really doesn&#39;t matter. The key point is<br=
>
that we have a mechanism that allows us to notify the underlying<br>
storage of the &quot;this is re-initialised storage&quot; intent of mkfs.<b=
r>
<br>
So from that perspective, the O_TRUNC behaviour should remain.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a></div></div><=
/blockquote><div><br></div><div><div class=3D"gmail_default" style=3D"font-=
family:arial,helvetica,sans-serif;display:inline">All right=E2=80=8B, I wil=
l keep the O_TRUNC there. However, should it truncate the file every time, =
or should we offer a way how to avoid the file truncating? Until now, mkfs =
behaved differently based on whether -d file was given, or not. Your explan=
ation suggests that we should truncate every time, right?</div></div></div>=
<div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra"><br></div><=
div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif=
">=E2=80=8BCheers,</div><div class=3D"gmail_default" style=3D"font-family:a=
rial,helvetica,sans-serif">Jan=E2=80=8B</div><br><br clear=3D"all"><div><br=
></div>-- <br><div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=
=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" targe=
t=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" t=
arget=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--001a113eb35ede269b05305f277f--


--===============2791860749284124662==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2791860749284124662==--
