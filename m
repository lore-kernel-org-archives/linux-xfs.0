Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A88D47F47
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 02:49:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 314F0AC003
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 00:49:32 -0700 (PDT)
Received: from mail-ig0-f181.google.com (mail-ig0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	E1UHsAHD0CCFK0g7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 00:49:30 -0700 (PDT)
Received: by igbuu8 with SMTP id uu8so42575563igb.1
	for <xfs@oss.sgi.com>; Tue, 01 Sep 2015 00:49:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150831185944.GI349@infradead.org>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-7-git-send-email-jtulak@redhat.com>
	<20150831185944.GI349@infradead.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 1 Sep 2015 09:49:10 +0200
Message-ID: <CACj3i73ST0HaKYbXnGYbXP03p7Kqe=F+bEKEMzdg-hP+i4RY0g@mail.gmail.com>
Subject: Re: [PATCH 07/11] xfsprogs: add nftw64 translation for OS X
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8842570458254614131=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8842570458254614131==
Content-Type: multipart/alternative; boundary=047d7bdca6103b95fe051eaacadd

--047d7bdca6103b95fe051eaacadd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2015 at 8:59 PM, Christoph Hellwig <hch@infradead.org>
wrote:

> On Wed, Aug 26, 2015 at 02:02:31PM +0200, Jan Tulak wrote:
> > OS X has only nftw variant - not the 64 suffix used in xfs.
>
> Can you just use a #define?
>
>
=E2=80=8BYes, indeed I can. Changed... :-)

Jan

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--047d7bdca6103b95fe051eaacadd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Mon, Au=
g 31, 2015 at 8:59 PM, Christoph Hellwig </span><span dir=3D"ltr" style=3D"=
font-family:arial,sans-serif">&lt;<a href=3D"mailto:hch@infradead.org" targ=
et=3D"_blank">hch@infradead.org</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Wed, =
Aug 26, 2015 at 02:02:31PM +0200, Jan Tulak wrote:<br>
&gt; OS X has only nftw variant - not the 64 suffix used in xfs.<br>
<br>
</span>Can you just use a #define?<br>
<br></blockquote><div><br></div><div><div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BYes, indeed=
 I can. Changed... :-)</div></div><div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif;display:inline"><br></div></div>=
<div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans=
-serif;display:inline">Jan</div></div></div><div><br></div>-- <br><div clas=
s=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak=
<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@red=
hat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tu=
lak.me</a></div></div></div></div>
</div></div>

--047d7bdca6103b95fe051eaacadd--


--===============8842570458254614131==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8842570458254614131==--
