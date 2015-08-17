Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA15C7F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 10:15:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48670AC004
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 08:15:34 -0700 (PDT)
Received: from mail-io0-f172.google.com (mail-io0-f172.google.com
	[209.85.223.172]) by cuda.sgi.com with ESMTP id
	Lb22EUZP9wvOexkB (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 08:15:32 -0700 (PDT)
Received: by iods203 with SMTP id s203so154930532iod.0
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 08:15:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150817150401.GA29056@infradead.org>
References: <20150804112153.GG18906@infradead.org>
	<1439823687-7279-1-git-send-email-jtulak@redhat.com>
	<20150817150401.GA29056@infradead.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 17 Aug 2015 17:15:12 +0200
Message-ID: <CACj3i73YH-Dsj_y3mA6Q1opxVf5eyuT3DLgYoKk-qApFQYZ+Bw@mail.gmail.com>
Subject: Re: [PATCH v4 09/11] xfsprogs: Add mntent.h check into autoconf
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6834394439889352885=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============6834394439889352885==
Content-Type: multipart/alternative; boundary=001a11402b3ac522b5051d83456f

--001a11402b3ac522b5051d83456f
Content-Type: text/plain; charset=UTF-8

On Mon, Aug 17, 2015 at 5:04 PM, Christoph Hellwig <hch@infradead.org>
wrote:

> This looks mostly fine.  I think you could just add the
> AC_CHECK_HEADERS directly to configure.ac, but otherwise it's exactly
> what I though.
>

In configure.ac, there are no direct checks for headers, just calls of all
the various
AC_HAVE_*. I'm not sure it is a good idea to mix now. Unless you think that
all
the functions should be moved into configure.ac from the m4/ directory.



> Can you please resend all your pending patches in a single series,
> and move the UPDATES: lines and other internal changelogs to the
> cover letter instead of the patch descriptions?
>
> Thanks for doing this work!
>

Sure, I'll send it again as a whole. And np. :-)

-- 
Jan Tulak
jtulak@redhat.com

--001a11402b3ac522b5051d83456f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On M=
on, Aug 17, 2015 at 5:04 PM, Christoph Hellwig <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:hch@infradead.org" target=3D"_blank">hch@infradead.org</a>&gt;<=
/span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8=
ex;border-left:1px #ccc solid;padding-left:1ex">This looks mostly fine.=C2=
=A0 I think you could just add the<br>
AC_CHECK_HEADERS directly to <a href=3D"http://configure.ac" rel=3D"norefer=
rer" target=3D"_blank">configure.ac</a>, but otherwise it&#39;s exactly<br>
what I though.<br></blockquote><div>=C2=A0</div><div>In <a href=3D"http://c=
onfigure.ac">configure.ac</a>, there are no direct checks for headers, just=
 calls of all the various</div><div>AC_HAVE_*. I&#39;m not sure it is a goo=
d idea to mix now. Unless you think that all</div><div>the functions should=
 be moved into <a href=3D"http://configure.ac">configure.ac</a> from the m4=
/ directory.</div><div><br></div><div>=C2=A0</div><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex">
Can you please resend all your pending patches in a single series,<br>
and move the UPDATES: lines and other internal changelogs to the<br>
cover letter instead of the patch descriptions?<br>
<br>
Thanks for doing this work!<br>
</blockquote></div><div><br></div><div>Sure, I&#39;ll send it again as a wh=
ole. And np. :-)</div><div><br></div>-- <br><div class=3D"gmail_signature">=
<div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.co=
m" target=3D"_blank">jtulak@redhat.com</a><br></div></div>
</div></div>

--001a11402b3ac522b5051d83456f--


--===============6834394439889352885==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6834394439889352885==--
