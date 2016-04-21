Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E2F757CA0
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 07:43:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3AD8304062
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:43:42 -0700 (PDT)
Received: from mail-ig0-f170.google.com (mail-ig0-f170.google.com
	[209.85.213.170]) by cuda.sgi.com with ESMTP id
	vtdYr4fOQvSt7285 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:43:41 -0700 (PDT)
Received: by mail-ig0-f170.google.com with SMTP id g8so80057177igr.0
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:43:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461231593-31294-16-git-send-email-jtulak@redhat.com>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461231593-31294-16-git-send-email-jtulak@redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 21 Apr 2016 14:43:21 +0200
Message-ID: <CACj3i73aW53YyEsZERZnSWHJ3y9cW85sA15KdoesCbx9wKsbPg@mail.gmail.com>
Subject: Re: [PATCH 15/19] mkfs: don't treat files as though they are block
	devices
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0398753435667369347=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

--===============0398753435667369347==
Content-Type: multipart/alternative; boundary=089e0116076e59f7680530fe0ffe

--089e0116076e59f7680530fe0ffe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 21, 2016 at 11:39 AM, Jan Tulak <jtulak@redhat.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
>
> THIS PATCH HAS KNOWN ISSUES - it fails xfs/206 and xfs/216 tests, as it
> shrinks a file instead just not using it entirely, when -d size is used.
>

=E2=80=8BSo the shrinking is happening here:
3127        /*
3128         * If the data area is a file, then grow it out to its final
size
3129         * so that the reads for the end of the device in the mount cod=
e
3130         * will succeed.
3131         */
3132        if (xi.disfile && ftruncate64(xi.dfd, dblocks * blocksize) < 0)
{=E2=80=8B


Before the patch, xi.disfile was 0 and so it didn't shrink the file to the
size of the new FS.
Now, what is the correct solve to this? Tests are written for the old
behaviour, but this shrinking seems to be an intentional thing.
It seems that the FS works ok even when this truncating is not applied, so
I think that I should remove this chunk (or change it to xi.dcreate=3D1
only), and keep the old behaviour.

What do you think about it, guys?

Cheers,
Jan



--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e0116076e59f7680530fe0ffe
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Thu, Ap=
r 21, 2016 at 11:39 AM, Jan Tulak </span><span dir=3D"ltr" style=3D"font-fa=
mily:arial,sans-serif">&lt;<a href=3D"mailto:jtulak@redhat.com" target=3D"_=
blank">jtulak@redhat.com</a>&gt;</span><span style=3D"font-family:arial,san=
s-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div class=3D"g=
mail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0=
.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-s=
tyle:solid;padding-left:1ex">From: Dave Chinner &lt;<a href=3D"mailto:dchin=
ner@redhat.com">dchinner@redhat.com</a>&gt;<br>
<br>
THIS PATCH HAS KNOWN ISSUES - it fails xfs/206 and xfs/216 tests, as it<br>
shrinks a file instead just not using it entirely, when -d size is used.<br=
></blockquote><div><br></div><div><div class=3D"gmail_default" style=3D"fon=
t-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BSo the shrinki=
ng is happening here:</div></div><div><font face=3D"arial, helvetica, sans-=
serif">3127 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*</font></div><div><font face=3D"ar=
ial, helvetica, sans-serif">3128 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * If the data =
area is a file, then grow it out to its final size</font></div><div><font f=
ace=3D"arial, helvetica, sans-serif">3129 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * so =
that the reads for the end of the device in the mount code</font></div><div=
><font face=3D"arial, helvetica, sans-serif">3130 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * will succeed.</font></div><div><font face=3D"arial, helvetica, sans-s=
erif">3131 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */</font></div><div><div class=3D"gm=
ail_default" style=3D"display:inline"><font face=3D"arial, helvetica, sans-=
serif">3132 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (xi.disfile &amp;&amp; ftruncate6=
4(xi.dfd, dblocks * blocksize) &lt; 0) {=E2=80=8B</font></div>=C2=A0</div><=
div><br></div><div><div class=3D"gmail_default" style=3D"font-family:arial,=
helvetica,sans-serif">Before the patch, xi.disfile was 0 and so it didn&#39=
;t shrink the file to the size of the new FS.</div><div class=3D"gmail_defa=
ult" style=3D"font-family:arial,helvetica,sans-serif">Now, what is the corr=
ect solve to this? Tests are written for the old behaviour, but this shrink=
ing seems to be an intentional thing.</div><div class=3D"gmail_default" sty=
le=3D"font-family:arial,helvetica,sans-serif">It seems that the FS works ok=
 even when this truncating is not applied, so I think that I should remove =
this chunk (or change it to xi.dcreate=3D1 only), and keep the old behaviou=
r.</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,s=
ans-serif"><br></div><div class=3D"gmail_default" style=3D"font-family:aria=
l,helvetica,sans-serif">What do you think about it, guys?</div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"><br></d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif">Cheers,</div><div class=3D"gmail_default" style=3D"font-family:arial,=
helvetica,sans-serif">Jan</div><br></div><div><br></div></div><div><br></di=
v>-- <br><div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"l=
tr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"=
_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=
=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--089e0116076e59f7680530fe0ffe--


--===============0398753435667369347==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0398753435667369347==--
