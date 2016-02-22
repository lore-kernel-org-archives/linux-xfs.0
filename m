Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F5EB7CB7
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 02:38:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E35678F80B6
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 00:38:37 -0800 (PST)
Received: from mail-io0-f172.google.com (mail-io0-f172.google.com
	[209.85.223.172]) by cuda.sgi.com with ESMTP id
	cREfVG1SLCHHIWRX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Feb 2016 00:38:36 -0800 (PST)
Received: by mail-io0-f172.google.com with SMTP id z135so170146994iof.0
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 00:38:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160221231815.GD25832@dastard>
References: <CACj3i70osVyt=QTTqoqKGttwNC8w7Gtq479-Nk-icQrDn83hCA@mail.gmail.com>
	<20160219154347.GA27263@bfoster.bfoster>
	<CACj3i72wijiApA0gD0mRrMvPomDC5pEAr1Mvv6e3vi4HU1S_sw@mail.gmail.com>
	<20160219162913.GC27263@bfoster.bfoster>
	<20160221231815.GD25832@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 22 Feb 2016 09:38:17 +0100
Message-ID: <CACj3i732q842g_vSh9UueheQs52C9XF1AR79mOJ2g07cbzfwFw@mail.gmail.com>
Subject: Re: What is the meaning of XLOG_MIN_RECORD_BSIZE? (Missing a check?)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0088647226044025891=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs-oss <xfs@oss.sgi.com>

--===============0088647226044025891==
Content-Type: multipart/alternative; boundary=001a114157c6447cfd052c57c2de

--001a114157c6447cfd052c57c2de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 22, 2016 at 12:18 AM, Dave Chinner <david@fromorbit.com> wrote:

>
> Keep in mind that a value of 0 in the superblock is completely
> acceptible, in which case the kernel treats the log stripe unit as
> being a single sector (i.e. same as a v1 log). See, for example,
> xlog_sync() where it works out the padding to use for the log buffer
> write.
>

=E2=80=8BGood to know. :-)

Cheers,
Jan=E2=80=8B


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a114157c6447cfd052c57c2de
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Mon, Fe=
b 22, 2016 at 12:18 AM, Dave Chinner </span><span dir=3D"ltr" style=3D"font=
-family:arial,sans-serif">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span></div><div class=3D"gmail_extra"><div class=
=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8=
ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">
<br>
</span>Keep in mind that a value of 0 in the superblock is completely<br>
acceptible, in which case the kernel treats the log stripe unit as<br>
being a single sector (i.e. same as a v1 log). See, for example,<br>
xlog_sync() where it works out the padding to use for the log buffer<br>
write.<br></blockquote><div><br></div><div><div class=3D"gmail_default" sty=
le=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BGood =
to know. :-)</div></div><div><div class=3D"gmail_default" style=3D"font-fam=
ily:arial,helvetica,sans-serif;display:inline"><br></div></div><div><div cl=
ass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;displ=
ay:inline">Cheers,</div></div><div><div class=3D"gmail_default" style=3D"fo=
nt-family:arial,helvetica,sans-serif;display:inline">Jan=E2=80=8B</div>=C2=
=A0</div></div><div><br></div>-- <br><div class=3D"gmail_signature"><div di=
r=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:j=
tulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D=
"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></div><=
/div>
</div></div>

--001a114157c6447cfd052c57c2de--


--===============0088647226044025891==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0088647226044025891==--
