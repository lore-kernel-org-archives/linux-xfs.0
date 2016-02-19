Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 82BFA7F47
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 07:35:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6269D304051
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 05:35:13 -0800 (PST)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	Z1CwjmQcg20iUPQV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Feb 2016 05:35:12 -0800 (PST)
Received: by mail-io0-f171.google.com with SMTP id 9so109156419iom.1
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 05:35:12 -0800 (PST)
MIME-Version: 1.0
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 19 Feb 2016 14:34:52 +0100
Message-ID: <CACj3i70osVyt=QTTqoqKGttwNC8w7Gtq479-Nk-icQrDn83hCA@mail.gmail.com>
Subject: What is the meaning of XLOG_MIN_RECORD_BSIZE? (Missing a check?)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3204069507363898599=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

--===============3204069507363898599==
Content-Type: multipart/alternative; boundary=001a114157c66c3daf052c1f8d19

--001a114157c66c3daf052c1f8d19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi guys,

what is the meaning of XLOG_MIN_RECORD_BSIZE in libxfs/xfs_log_format.h?
It is not used anywhere. I thought it might be related to -l su/sunit
option, but seeing tests with -l su=3D4096 (the macro is set to 16k), it
looks more like a forgotten value.

There is no check for a minimal value, so I can do -l su=3D1 (or su=3D0). A=
re
there some caveat=E2=80=8Bs (other than performance) with such a small valu=
e? Can
it be that we are missing a check? Because
XLOG_BIG_RECORD_BSIZE
=E2=80=8B and XLOG_MAX_RECORD_BSIZE are used and the upper bound is limited=
.=E2=80=8B..


=E2=80=8BThanks=E2=80=8B.

Cheers,
Jan

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a114157c66c3daf052c1f8d19
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif">Hi guys,</div><div class=3D"gmail_default" style=3D"fon=
t-family:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_default"=
 style=3D"font-family:arial,helvetica,sans-serif">what is the meaning of=C2=
=A0XLOG_MIN_RECORD_BSIZE in=C2=A0libxfs/xfs_log_format.h?</div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">It is n=
ot used anywhere. I thought it might be related to -l su/sunit option, but =
seeing tests with -l su=3D4096 (the macro is set to 16k), it looks more lik=
e a forgotten value.=C2=A0</div><div><br></div><div><div class=3D"gmail_def=
ault" style=3D"font-family:arial,helvetica,sans-serif">There is no check fo=
r a minimal value, so I can do -l su=3D1 (or su=3D0). Are there some caveat=
=E2=80=8Bs (other than performance) with such a small value? Can it be that=
 we are missing a check? Because=C2=A0</div>XLOG_BIG_RECORD_BSIZE<div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;display:=
inline">=E2=80=8B and XLOG_MAX_RECORD_BSIZE are used and the upper bound is=
 limited.=E2=80=8B..</div><br></div><div><br></div><div><div class=3D"gmail=
_default" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BThanks=
=E2=80=8B.</div><div class=3D"gmail_default" style=3D"font-family:arial,hel=
vetica,sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-fam=
ily:arial,helvetica,sans-serif">Cheers,</div><div class=3D"gmail_default" s=
tyle=3D"font-family:arial,helvetica,sans-serif">Jan</div></div><div><br></d=
iv>-- <br><div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"=
ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D=
"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" targe=
t=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div>

--001a114157c66c3daf052c1f8d19--


--===============3204069507363898599==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3204069507363898599==--
