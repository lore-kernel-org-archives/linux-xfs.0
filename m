Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2F7B67F37
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 00:21:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F3F1A8F8054
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 22:21:36 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id Mctmd1CFZuCXpSkI (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 22:21:05 -0700 (PDT)
Subject: Bug#695640: xfs_quota: cannot find mount point for path: Success
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.695640.B695640.136375676425894@bugs.debian.org>
MIME-Version: 1.0
In-Reply-To: <20130319063104.GA6369@dastard>
References: <CAA0ZO6CtLRkgrpXqapg3B5oMwGdLq8tS3y4dYG47aYX5BZkA=g@mail.gmail.com>
	<20121211221419.GZ27055@sgi.com>
	<CAA0ZO6APzwQCX=yf=qq8NkmjwDHVsgRBNCgN3KNW3RLgAWB=8A@mail.gmail.com>
	<20121211223700.GA27055@sgi.com>
	<CAA0ZO6BOUXTMpdrR-r=__-ZaAM6X39h2SisYXLfTTraTcttr+g@mail.gmail.com>
	<20121211231533.GG16353@dastard>
	<CAA0ZO6BvLQGt_9G-FSi+ZMCzJh_kmb1z2bdoPPwaVMVVK1UXJw@mail.gmail.com>
	<CAA0ZO6BGqvBdXRr9U4BagQYGa=_kC2VUgtOj+qPB5HEX2U8O7w@mail.gmail.com>
	<20130318224814.GP6369@dastard>
	<CAA0ZO6BVwPP9McKA=vn1+21gHpRCQP9P963nsSjY_zXHWeszrg@mail.gmail.com>
	<20130319063104.GA6369@dastard>
Date: Wed, 20 Mar 2013 16:19:16 +1100
Message-ID: <CAA0ZO6AxFzinTv_COhK6GqnRpSiYW95otznKvYKiWZB5+=CyBg@mail.gmail.com>
From: Brian May <brian@microcomaustralia.com.au>
Reply-To: Brian May <brian@microcomaustralia.com.au>, 695640@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3582124346447134193=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: 695640@bugs.debian.org, Ben Myers <bpm@sgi.com>

--===============3582124346447134193==
Content-Type: multipart/alternative; boundary=f46d043894630d9a2204d8545d9a

--f46d043894630d9a2204d8545d9a
Content-Type: text/plain; charset=UTF-8

On 19 March 2013 17:31, Dave Chinner <david@fromorbit.com> wrote:

> Which tells me exactly what is happening.
>
> The project quotas are not on the filesystem you directed the the
> quota command at, and xfs_quota is telling you that it can't find
> the mount point for the configured project quotas on /home. Either:
>

Hello,

Thanks for your response.

I am kind of confused still. I asked for user quotas, with the -u flag. Why
should it be trying to lookup project quotas?

I only want to get the report of user quotas. I only want to get the report
for one filesystem. A filesystem that
doesn't support project quotas, which should be fine because I am not
asking for project quotas.

This was fine under lenny, but broke under squeeze.



> # xfs_quota  -x -c "quota -N -u brian"
>

This prints the quota information 20 times. Huh?


> or
>
> # xfs_quota  -x -c "quota -N -u brian" /home /share
>

This prints the quota information 2 times. Huh?

hq ~ # xfs_quota  -x -c "quota -u brian" /home /share
Disk quotas for User brian (10000)
Filesystem              Blocks      Quota      Limit  Warn/Time
 Mounted on
/dev/mapper/hq-home    3799724          0          0   00 [--------] /home
/dev/mapper/hq-share     282856          0          0   00 [--------] /share
Disk quotas for User brian (10000)
Filesystem              Blocks      Quota      Limit  Warn/Time
 Mounted on
/dev/mapper/hq-home    3799724          0          0   00 [--------] /home
/dev/mapper/hq-share     282856          0          0   00 [--------] /share

Thanks

--f46d043894630d9a2204d8545d9a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On 19 March 2013 17:31, Dave Chinner <span dir=3D"ltr">&lt=
;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.c=
om</a>&gt;</span> wrote:<br><div class=3D"gmail_extra"><div class=3D"gmail_=
quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;=
border-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:=
solid;padding-left:1ex">
<div class=3D""><div class=3D"h5"><span style=3D"color:rgb(34,34,34)">Which=
 tells me exactly what is happening.</span><br></div></div>
<br>
The project quotas are not on the filesystem you directed the the<br>
quota command at, and xfs_quota is telling you that it can&#39;t find<br>
the mount point for the configured project quotas on /home. Either:<br></bl=
ockquote><div><br></div><div style>Hello,</div><div style><br></div><div st=
yle>Thanks for your response.</div><div style><br></div><div style>I am kin=
d of confused still. I asked for user quotas, with the -u flag. Why should =
it be trying to lookup project quotas?</div>
<div style><br></div><div style>I only want to get the report of user quota=
s. I only want to get the report for one filesystem. A filesystem that</div=
><div style>doesn&#39;t support project quotas, which should be fine becaus=
e I am not asking for project quotas.</div>
<div style><br></div><div style>This was fine under lenny, but broke under =
squeeze.</div><div style><br></div><div style>=C2=A0</div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;bo=
rder-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">
<div class=3D"im"># xfs_quota =C2=A0-x -c &quot;quota -N -u brian&quot;<br>=
</div></blockquote><div><br></div><div style>This prints the quota informat=
ion 20 times. Huh?</div><div style>=C2=A0</div><blockquote class=3D"gmail_q=
uote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-c=
olor:rgb(204,204,204);border-left-style:solid;padding-left:1ex">
or<br>
<br>
# xfs_quota =C2=A0-x -c &quot;quota -N -u brian&quot; /home /share<br></blo=
ckquote><div><br></div><div style>This prints the quota information 2 times=
. Huh?</div><div style><br></div><div style><div>hq ~ # xfs_quota =C2=A0-x =
-c &quot;quota -u brian&quot; /home /share</div>
<div>Disk quotas for User brian (10000)</div><div>Filesystem =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 =C2=A0 =C2=A0Quota =C2=A0 =
=C2=A0 =C2=A0Limit =C2=A0Warn/Time =C2=A0 =C2=A0 =C2=A0Mounted on</div><div=
>/dev/mapper/hq-home =C2=A0 =C2=A03799724 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 00 [--------] /home</div><d=
iv>
/dev/mapper/hq-share =C2=A0 =C2=A0 282856 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 00 [--------] /share</div><=
div>Disk quotas for User brian (10000)</div><div>Filesystem =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 =C2=A0 =C2=A0Quota =C2=A0 =
=C2=A0 =C2=A0Limit =C2=A0Warn/Time =C2=A0 =C2=A0 =C2=A0Mounted on</div><div=
>
/dev/mapper/hq-home =C2=A0 =C2=A03799724 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 00 [--------] /home</div><div>=
/dev/mapper/hq-share =C2=A0 =C2=A0 282856 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 00 [--------] /share</div><=
div><br></div><div style>Thanks</div></div></div></div>
</div>

--f46d043894630d9a2204d8545d9a--


--===============3582124346447134193==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3582124346447134193==--
