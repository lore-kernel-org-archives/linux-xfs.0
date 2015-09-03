Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E71227F60
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 04:02:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 573D5AC002
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 02:02:05 -0700 (PDT)
Received: from mail-io0-f180.google.com (mail-io0-f180.google.com
	[209.85.223.180]) by cuda.sgi.com with ESMTP id
	8p7LfSaEfdCiuQX7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 02:02:04 -0700 (PDT)
Received: by ioiz6 with SMTP id z6so50304335ioi.2
	for <xfs@oss.sgi.com>; Thu, 03 Sep 2015 02:02:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150831190120.GK349@infradead.org>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-10-git-send-email-jtulak@redhat.com>
	<20150831190120.GK349@infradead.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 3 Sep 2015 11:01:44 +0200
Message-ID: <CACj3i73Px4Zxfyz1GMZN=4r_LeONPMwfLT=P7C7bNDDshJ1ipA@mail.gmail.com>
Subject: Re: [PATCH 10/11] xfsprogs: add dummy mntent for OS X
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4642377753699671035=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============4642377753699671035==
Content-Type: multipart/alternative; boundary=001a11409e3e763f1f051ed4091a

--001a11409e3e763f1f051ed4091a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2015 at 9:01 PM, Christoph Hellwig <hch@infradead.org>
wrote:

> On Wed, Aug 26, 2015 at 02:02:34PM +0200, Jan Tulak wrote:
> > Because these calls are used only by xfs_fsr, which can't
> > work on OS X unless a way how to mount XFS is found,
> > there is not use in implementing these calls.
>
> Take a look at the quota code for the BSD alternative to mntent.
> That code should be moved into a common location and used by fsr.
>

=E2=80=8BI tried to find it, but didn't found... Could you point me where i=
t is?
Quota/freebsd.h has just few lines with one definition with errno =3D
-ENOSYS, and in other files in quota/, I didn't saw anything BSD specific.

Thanks,
Jan


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a11409e3e763f1f051ed4091a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Mon, Aug 31, 2015 at 9:01 PM, Christoph Hellwig <span dir=
=3D"ltr">&lt;<a href=3D"mailto:hch@infradead.org" target=3D"_blank">hch@inf=
radead.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span cl=
ass=3D"">On Wed, Aug 26, 2015 at 02:02:34PM +0200, Jan Tulak wrote:<br>
&gt; Because these calls are used only by xfs_fsr, which can&#39;t<br>
&gt; work on OS X unless a way how to mount XFS is found,<br>
&gt; there is not use in implementing these calls.<br>
<br>
</span>Take a look at the quota code for the BSD alternative to mntent.<br>
That code should be moved into a common location and used by fsr.<br>
</blockquote></div><br><div class=3D"gmail_default" style=3D"font-family:ar=
ial,helvetica,sans-serif">=E2=80=8BI tried to find it, but didn&#39;t found=
... Could you point me where it is?=C2=A0</div><div class=3D"gmail_default"=
 style=3D"font-family:arial,helvetica,sans-serif">Quota/freebsd.h has just =
few lines with one definition with errno =3D -ENOSYS, and in other files in=
 quota/, I didn&#39;t saw anything BSD specific.</div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif"><br></div><div cla=
ss=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">Thank=
s,</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,s=
ans-serif">Jan</div><br clear=3D"all"><div><br></div>-- <br><div class=3D"g=
mail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></=
div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.co=
m</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me=
</a></div></div></div></div>
</div></div>

--001a11409e3e763f1f051ed4091a--


--===============4642377753699671035==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4642377753699671035==--
