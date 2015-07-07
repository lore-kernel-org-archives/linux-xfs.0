Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ECEA97F4E
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 21:51:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D94BA304066
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 19:51:29 -0700 (PDT)
Received: from mail-pa0-f41.google.com (mail-pa0-f41.google.com
	[209.85.220.41]) by cuda.sgi.com with ESMTP id Dn29RHWagK9d3tBt
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jul 2015 19:51:25 -0700 (PDT)
Received: by pacws9 with SMTP id ws9so106387615pac.0
	for <xfs@oss.sgi.com>; Mon, 06 Jul 2015 19:51:24 -0700 (PDT)
Message-ID: <559b3eab.46f0440a.bad8e.7195@mx.google.com>
MIME-Version: 1.0
From: rakesh patel <patelrakeshcomp@gmail.com>
Subject: RE: regarding journaling mode
Date: Tue, 7 Jul 2015 08:21:16 +0530
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
Content-Type: multipart/mixed; boundary="===============4075747192894380250=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============4075747192894380250==
Content-Type: multipart/alternative;
	boundary="_5C4CE296-BE70-44B1-9754-48BEBA71448B_"

--_5C4CE296-BE70-44B1-9754-48BEBA71448B_
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

How metadata is committed only after data? Is there any other file system f=
eature? Because write back mode does not preserve it?

Rakesh

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

--_5C4CE296-BE70-44B1-9754-48BEBA71448B_
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; charset=
=3Dutf-8"></head><body><div><div style=3D"font-family: Calibri,sans-serif; =
font-size: 11pt;">How metadata is committed only after data? Is there any o=
ther file system feature? Because write back mode does not preserve it?<br>=
<br>Rakesh</div></div><div dir=3D"ltr"><hr><span style=3D"font-family: Cali=
bri,sans-serif; font-size: 11pt; font-weight: bold;">From: </span><span sty=
le=3D"font-family: Calibri,sans-serif; font-size: 11pt;"><a href=3D"mailto:=
david@fromorbit.com">Dave Chinner</a></span><br><span style=3D"font-family:=
 Calibri,sans-serif; font-size: 11pt; font-weight: bold;">Sent: </span><spa=
n style=3D"font-family: Calibri,sans-serif; font-size: 11pt;">=E2=80=8E07-=
=E2=80=8E07-=E2=80=8E2015 05:59</span><br><span style=3D"font-family: Calib=
ri,sans-serif; font-size: 11pt; font-weight: bold;">To: </span><span style=
=3D"font-family: Calibri,sans-serif; font-size: 11pt;"><a href=3D"mailto:pa=
telrakeshcomp@gmail.com">Rakesh Patel</a></span><br><span style=3D"font-fam=
ily: Calibri,sans-serif; font-size: 11pt; font-weight: bold;">Cc: </span><s=
pan style=3D"font-family: Calibri,sans-serif; font-size: 11pt;"><a href=3D"=
mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a></span><br><span style=3D"font-f=
amily: Calibri,sans-serif; font-size: 11pt; font-weight: bold;">Subject: </=
span><span style=3D"font-family: Calibri,sans-serif; font-size: 11pt;">Re: =
regarding journaling mode</span><br><br></div>On Mon, Jul 06, 2015 at 11:38=
:32AM +0530, Rakesh Patel wrote:<br>&gt; Hi,<br>&gt; <br>&gt; I come to kno=
w XFS is using writeback journaling mode.<br><br>Can you explain how you ca=
me to that conclusion?<br><br>&gt; As per the<br>&gt; journaling guide, wri=
teback is unsafe which does not preserve data and<br>&gt; metadata write sy=
nchronization.<br><br>What journalling guide would that be? Please quote yo=
ur sources when<br>asking questions.<br><br>&gt; I really want to know reas=
on behind to choose writeback mode for journaling<br>&gt; in XFS.<br><br>Me=
tadata updates after data IO completion are used instead of<br>ordering dat=
a writeback operations through the journal.<br><br>Cheers,<br><br>Dave.<br>=
-- <br>Dave Chinner<br>david@fromorbit.com<br></body></html>=

--_5C4CE296-BE70-44B1-9754-48BEBA71448B_--


--===============4075747192894380250==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4075747192894380250==--
