Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A26AF7F37
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 21:43:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7001A304043
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 19:43:42 -0700 (PDT)
Message-ID: <559ddfd7.293e460a.833d.ffffb57c@mx.google.com>
MIME-Version: 1.0
From: rakesh patel <patelrakeshcomp@gmail.com>
Subject: RE: regarding journaling mode
Date: Thu, 9 Jul 2015 08:13:10 +0530
In-Reply-To: <20150707002430.GV7943@dastard>
References: <CAMcfJ7vDCNo138qnUJ8O0ZDYxgh9k8rgFUoTN3mKcY-SiMWrzA@mail.gmail.com>
	<20150707002430.GV7943@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2882028352345891551=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-owner@oss.sgi.com, xfs@oss.sgi.com

--===============2882028352345891551==
Content-Type: multipart/alternative;
	boundary="_41924495-2CEA-4DBE-AA2E-FDD6ACA45652_"

--_41924495-2CEA-4DBE-AA2E-FDD6ACA45652_
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

How Metadata updates after data IO completion done? Write back mode does no=
t support synchronization?

Is there any other feature ??

-----Original Message-----
From: "Dave Chinner" <david@fromorbit.com>
Sent: =E2=80=8E07-=E2=80=8E07-=E2=80=8E2015 05:59
To: "Rakesh Patel" <patelrakeshcomp@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: regarding journaling mode

On Mon, Jul 06, 2015 at 11:38:32AM +0530, Rakesh Patel wrote:
> Hi,
>=20
> I come to know XFS is using writeback journaling mode.

Can you explain how you came to that conclusion?

> As per the
> journaling guide, writeback is unsafe which does not preserve data and
> metadata write synchronization.

What journalling guide would that be? Please quote your sources when
asking questions.

> I really want to know reason behind to choose writeback mode for journali=
ng
> in XFS.

Metadata updates after data IO completion are used instead of
ordering data writeback operations through the journal.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com

--_41924495-2CEA-4DBE-AA2E-FDD6ACA45652_
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; charset=
=3Dutf-8"></head><body><div><div style=3D"font-family: Calibri,sans-serif; =
font-size: 11pt;">How Metadata updates after data IO completion done? Write=
 back mode does not support synchronization?<br><br>Is there any other feat=
ure ??</div></div><div dir=3D"ltr"><hr><span style=3D"font-family: Calibri,=
sans-serif; font-size: 11pt; font-weight: bold;">From: </span><span style=
=3D"font-family: Calibri,sans-serif; font-size: 11pt;"><a href=3D"mailto:da=
vid@fromorbit.com">Dave Chinner</a></span><br><span style=3D"font-family: C=
alibri,sans-serif; font-size: 11pt; font-weight: bold;">Sent: </span><span =
style=3D"font-family: Calibri,sans-serif; font-size: 11pt;">=E2=80=8E07-=E2=
=80=8E07-=E2=80=8E2015 05:59</span><br><span style=3D"font-family: Calibri,=
sans-serif; font-size: 11pt; font-weight: bold;">To: </span><span style=3D"=
font-family: Calibri,sans-serif; font-size: 11pt;"><a href=3D"mailto:patelr=
akeshcomp@gmail.com">Rakesh Patel</a></span><br><span style=3D"font-family:=
 Calibri,sans-serif; font-size: 11pt; font-weight: bold;">Cc: </span><span =
style=3D"font-family: Calibri,sans-serif; font-size: 11pt;"><a href=3D"mail=
to:xfs@oss.sgi.com">xfs@oss.sgi.com</a></span><br><span style=3D"font-famil=
y: Calibri,sans-serif; font-size: 11pt; font-weight: bold;">Subject: </span=
><span style=3D"font-family: Calibri,sans-serif; font-size: 11pt;">Re: rega=
rding journaling mode</span><br><br></div>On Mon, Jul 06, 2015 at 11:38:32A=
M +0530, Rakesh Patel wrote:<br>&gt; Hi,<br>&gt; <br>&gt; I come to know XF=
S is using writeback journaling mode.<br><br>Can you explain how you came t=
o that conclusion?<br><br>&gt; As per the<br>&gt; journaling guide, writeba=
ck is unsafe which does not preserve data and<br>&gt; metadata write synchr=
onization.<br><br>What journalling guide would that be? Please quote your s=
ources when<br>asking questions.<br><br>&gt; I really want to know reason b=
ehind to choose writeback mode for journaling<br>&gt; in XFS.<br><br>Metada=
ta updates after data IO completion are used instead of<br>ordering data wr=
iteback operations through the journal.<br><br>Cheers,<br><br>Dave.<br>-- <=
br>Dave Chinner<br>david@fromorbit.com<br></body></html>=

--_41924495-2CEA-4DBE-AA2E-FDD6ACA45652_--


--===============2882028352345891551==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2882028352345891551==--
