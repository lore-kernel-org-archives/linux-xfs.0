Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 706A87FAB
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 06:42:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5E972304051
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 04:42:38 -0700 (PDT)
Received: from mail-qa0-f54.google.com (mail-qa0-f54.google.com
	[209.85.216.54]) by cuda.sgi.com with ESMTP id 63HXy8gJYmLkCeNP
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 17 Mar 2013 04:42:37 -0700 (PDT)
Received: by mail-qa0-f54.google.com with SMTP id hg5so1134206qab.13
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 04:42:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51455408.4070801@hardwarefreak.com>
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<51455408.4070801@hardwarefreak.com>
Date: Sun, 17 Mar 2013 17:12:36 +0530
Message-ID: <CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
Subject: Re: Xfs_repair and journalling
From: Subranshu Patel <spatel.ml@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7474647023641977033=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

--===============7474647023641977033==
Content-Type: multipart/alternative; boundary=20cf300fafc16aa40404d81d5e31

--20cf300fafc16aa40404d81d5e31
Content-Type: text/plain; charset=UTF-8

What I understand is that, XFS being a journalling filesystem makes running
xfs_repair after a unclean unmount unnecessary.

After a system crash or force power down, one can mount the filesystem
which causes the journal to be replayed and handles the half finished
writes. This is one part. But there can be other file corruption as well
and these can be handled by xfs_repair.
So the crux is to mount the filesystem so that journal will be replayed,
and then unmount the filesystem and run xfs_repair. (Assuming xfs_repair
may not be a mandatory step always)

In case of EXT4, journal will not be replayed on performing mount. One need
to invoke fsck which performs journal playback and then other corruption
checks/recovery.
Correct me if I am wrong.


On Sun, Mar 17, 2013 at 10:56 AM, Stan Hoeppner <stan@hardwarefreak.com>
wrote:
>
> On 3/16/2013 10:56 AM, Subranshu Patel wrote:
>
> > This is not observed in EXT4, fsck successfully recovers without
> > mounting the filesystem.
>
> And this is the real problem.  You're *assuming* XFS should behave in
> the same manner as EXT4.  Why would you assume a Ferrari should behave
> like a Tata Nano?
>
> XFS is far more sophisticated than EXT4 in many, many ways, including
> recovery after unclean shutdown.  XFS kernel code performs journal
> playback/recovery automatically when the filesystem is mounted.
> xfs_repair is a tool for fixing filesystems that are broken, not simply
> in need of journal playback.  Thus xfs_repair has no code to perform
> journal recovery.
>
> EXT4 (and EXT3) lacks this sophistication and must call a user space
> tool, e2fsck, to perform journal playback/recovery.
>
> XFS is the Ferrari of Linux filesystems and EXT is the Tata.  Keep that
> in mind as you discover many of the other differences in the future.
>
> --
> Stan
>

--20cf300fafc16aa40404d81d5e31
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>What I understand is that, XFS being a journalling fi=
lesystem makes running xfs_repair after a unclean unmount unnecessary.</div=
><div>=C2=A0</div><div>After a system crash or force power down, one can mo=
unt the filesystem which causes the journal to be replayed and handles the =
half finished writes. This is one part. But there can be other file corrupt=
ion as well and these can be handled by xfs_repair.</div>
<div>So the crux is to mount the filesystem so that journal will be replaye=
d, and then unmount the filesystem and run xfs_repair. (Assuming xfs_repair=
 may not be a mandatory step always)</div><div>=C2=A0</div><div>In case of =
EXT4, journal will not be replayed on performing mount. One need to invoke =
fsck which performs journal playback and then other corruption checks/recov=
ery.</div>
<div> </div><div>Correct me if I am wrong.</div><div>=C2=A0</div><div>=C2=
=A0</div><div>On Sun, Mar 17, 2013 at 10:56 AM, Stan Hoeppner &lt;<a href=
=3D"mailto:stan@hardwarefreak.com">stan@hardwarefreak.com</a>&gt; wrote:</d=
iv><div>&gt;</div>
<div>&gt; On 3/16/2013 10:56 AM, Subranshu Patel wrote:</div><div>&gt;</div=
><div>&gt; &gt; This is not observed in EXT4, fsck successfully recovers wi=
thout</div><div>&gt; &gt; mounting the filesystem.</div><div>&gt;</div>
<div>&gt; And this is the real problem. =C2=A0You&#39;re *assuming* XFS sho=
uld behave in</div><div>&gt; the same manner as EXT4. =C2=A0Why would you a=
ssume a Ferrari should behave</div><div>&gt; like a Tata Nano?</div><div>&g=
t;</div>
<div>&gt; XFS is far more sophisticated than EXT4 in many, many ways, inclu=
ding</div><div>&gt; recovery after unclean shutdown. =C2=A0XFS kernel code =
performs journal</div><div>&gt; playback/recovery automatically when the fi=
lesystem is mounted.</div>
<div>&gt; xfs_repair is a tool for fixing filesystems that are broken, not =
simply</div><div>&gt; in need of journal playback. =C2=A0Thus xfs_repair ha=
s no code to perform</div><div>&gt; journal recovery.</div><div>&gt;</div><=
div>
&gt; EXT4 (and EXT3) lacks this sophistication and must call a user space</=
div><div>&gt; tool, e2fsck, to perform journal playback/recovery.</div><div=
>&gt;</div><div>&gt; XFS is the Ferrari of Linux filesystems and EXT is the=
 Tata. =C2=A0Keep that</div>
<div>&gt; in mind as you discover many of the other differences in the futu=
re.</div><div>&gt;</div><div>&gt; --</div><div>&gt; Stan</div><div>&gt;</di=
v><div>=C2=A0</div></div>

--20cf300fafc16aa40404d81d5e31--


--===============7474647023641977033==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7474647023641977033==--
