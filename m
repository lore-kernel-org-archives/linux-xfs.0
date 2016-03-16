Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BBEFD7CE3
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 02:23:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A7A68F8033
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 00:23:48 -0700 (PDT)
Received: from mail-ig0-f170.google.com (mail-ig0-f170.google.com
	[209.85.213.170]) by cuda.sgi.com with ESMTP id
	0SVVzAQFxIacoNhx (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 00:23:45 -0700 (PDT)
Received: by mail-ig0-f170.google.com with SMTP id ig19so34938377igb.1
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 00:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtR4tq8+BXRX+Y4rkqn6ZrFLw-9SX=gXKkF3QS1b2c8Ksg@mail.gmail.com>
	<56E8AA22.7080301@sandeen.net>
In-Reply-To: <56E8AA22.7080301@sandeen.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 16 Mar 2016 07:23:35 +0000
Message-ID: <CAJCQCtQYMitUvPN1ORyEHvDhddJ09Hp_xK_CBc0e1Cu972S3_w@mail.gmail.com>
Subject: Re: new fs, xfs_admin new label, metadata corruption detected
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2306288043904419297=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============2306288043904419297==
Content-Type: multipart/alternative; boundary=047d7b3a8458e1d854052e2564bd

--047d7b3a8458e1d854052e2564bd
Content-Type: text/plain; charset=UTF-8

On Tue, Mar 15, 2016, 6:34 PM Eric Sandeen <sandeen@sandeen.net> wrote:

> On 3/15/16 6:08 PM, Chris Murphy wrote:
> > Is this expected? File system continues to work OK, sha256sum on the
> > single file on this fs matches the source, but the metadata corruption
> > messages are a bit scary so figured I'd ask about it.
> >
> > Filesystem created with
> > xfsprogs-4.3.0-1.fc23
> > kernel-4.4.4-300.fc23.x86_64
> >
> > mkfs.xfs defaults used on an LVM thinly provisioned volume on a single
> > spinning disk.
> >
> > # xfs_info /dev/mapper/VG-testxfs
> > meta-data=/dev/mapper/VG-testxfs isize=512    agcount=23, agsize=399984
> blks
>                                                 ^^^^^^^^^^
>
> It seems that you left a growfs step out of it, where does that come in
> to the testcase?
>


Oops I spaced it out entirely.

Much of this happened in Cockpit, which uses storaged. So no matter what
I'll have to backtrack to get exact reproduce steps. In the meantime:

Create thin pool
Create thin volume
Mkfs
Mount
Copy file
Grow (resize done in cockpit)
Delete file
Umount
Kernel and progs update and reboot
Mount
Copy file
Unmount
Relabel
<error>
Repair
Mount

Something amiss with growfs and lvresize steps?


Chris Murphy

--047d7b3a8458e1d854052e2564bd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Tue, Mar 15, 2016, 6=
:34 PM Eric Sandeen &lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sand=
een.net</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"=
margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On 3/15/16 6=
:08 PM, Chris Murphy wrote:<br>
&gt; Is this expected? File system continues to work OK, sha256sum on the<b=
r>
&gt; single file on this fs matches the source, but the metadata corruption=
<br>
&gt; messages are a bit scary so figured I&#39;d ask about it.<br>
&gt;<br>
&gt; Filesystem created with<br>
&gt; xfsprogs-4.3.0-1.fc23<br>
&gt; kernel-4.4.4-300.fc23.x86_64<br>
&gt;<br>
&gt; mkfs.xfs defaults used on an LVM thinly provisioned volume on a single=
<br>
&gt; spinning disk.<br>
&gt;<br>
&gt; # xfs_info /dev/mapper/VG-testxfs<br>
&gt; meta-data=3D/dev/mapper/VG-testxfs isize=3D512=C2=A0 =C2=A0 agcount=3D=
23, agsize=3D399984 blks<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 ^^^^^^^^^^<br>
<br>
It seems that you left a growfs step out of it, where does that come in<br>
to the testcase?<br></blockquote></div><div><br></div><div><br></div>Oops I=
 spaced it out entirely.<br><br>Much of this happened in Cockpit, which use=
s storaged. So no matter what I&#39;ll have to backtrack to get exact repro=
duce steps. In the meantime:<br><br>Create thin pool<br>Create thin volume<=
br>Mkfs<br>Mount<br>Copy file<br>Grow (resize done in cockpit)<br>Delete fi=
le<br>Umount<br>Kernel and progs update and reboot<br>Mount<br>Copy file<br=
>Unmount<br>Relabel<br>&lt;error&gt;<br>Repair<br>Mount<br><br>Something am=
iss with growfs and lvresize steps?<div><br></div><div><br></div><div>Chris=
 Murphy</div>

--047d7b3a8458e1d854052e2564bd--


--===============2306288043904419297==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2306288043904419297==--
