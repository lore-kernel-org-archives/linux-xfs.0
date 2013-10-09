Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E64947FB8
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 13:59:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 60583AC002
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 11:59:21 -0700 (PDT)
Received: from mail-vc0-f177.google.com (mail-vc0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	77NxfxtgTQHLHK4C (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 11:59:19 -0700 (PDT)
Received: by mail-vc0-f177.google.com with SMTP id hv10so851698vcb.36
	for <xfs@oss.sgi.com>; Wed, 09 Oct 2013 11:59:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131008202342.GA4446@dastard>
References: <CAGa4098ZKd2KQfWMgNXYgLr9LJF8r-MpFgQAn3G-W+ovDGHTAw@mail.gmail.com>
	<20131001201909.GR12541@dastard>
	<CAGa409_tDjbsdnf+wDiM7666FeQSjmMfOVdqG-SxOD_WUZMiZQ@mail.gmail.com>
	<20131002104253.GT12541@dastard>
	<CAGa409_wO74zGP1d85RGZ7WbfBPr7s_tKaW3u9k8=9Ps-D5FjQ@mail.gmail.com>
	<20131004214353.GK4446@dastard>
	<CAGa4099NNUJV4_JbU0izLf0k3bcj3afHPTXt=HO2263_TESbNA@mail.gmail.com>
	<20131008202342.GA4446@dastard>
Date: Wed, 9 Oct 2013 11:59:19 -0700
Message-ID: <CAGa409_Wk9L5mD_p0MzCbMKxHFRrFWKaf+ejFD+tUnhmeHBO3g@mail.gmail.com>
Subject: Re: xfs_repair segfault
From: Viet Nguyen <vietnguyen@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1664665025215170852=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============1664665025215170852==
Content-Type: multipart/alternative; boundary=001a1133225288794f04e8537bd2

--001a1133225288794f04e8537bd2
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Oct 8, 2013 at 1:23 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Oct 07, 2013 at 01:09:09PM -0700, Viet Nguyen wrote:
> > Thanks. That seemed to fix that bug.
> >
> > Now I'm getting a lot of this:
> > xfs_da_do_buf(2): XFS_CORRUPTION_ERROR
>
> Right, that's blocks that are being detected as corrupt when they
> are read. You can ignore that for now.
>
> > fatal error -- can't read block 8388608 for directory inode 8628218
>
> That's a corrupted block list of some kind - it should junk the
> inode.
>
> > Then xfs_repair exits.
>
> I'm not sure why that happens. Is it exiting cleanly or crashing?
> Can you take a metadump of the filesystem and provide it for someone
> to debug the problems it causes repair?
>

It seems to be exiting cleanly with return code 1. I created a metadump,
but it's 9.6GB. I suppose I can put up on a secure FTP or something like
that, but it does seem a big large to shuffle around.


>
> > What I've been doing is what I saw in the FAQ where I would use xfs_db
> and
> > write core.mode 0 for these inodes. But there are just so many of them.
> And
> > is that even the right thing to do?
>
> That marks the inode as "free" which effectively junks it and then
> xfs_repair will free all it's extents next time it is run. Basically
> you are removing the files from the filesystem and making them
> unrecoverable.
>

In the case of directories, it blows away just directory but xfs_repair
later on scans for orphan files, no? Or am I mistaken on how that works.

Thanks,
Viet

--001a1133225288794f04e8537bd2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><br><div class=3D"gmail=
_quote">On Tue, Oct 8, 2013 at 1:23 PM, Dave Chinner <span dir=3D"ltr">&lt;=
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Mon, Oct 07, 2013 at 01=
:09:09PM -0700, Viet Nguyen wrote:<br>
&gt; Thanks. That seemed to fix that bug.<br>
&gt;<br>
&gt; Now I&#39;m getting a lot of this:<br>
&gt; xfs_da_do_buf(2): XFS_CORRUPTION_ERROR<br>
<br>
</div>Right, that&#39;s blocks that are being detected as corrupt when they=
<br>
are read. You can ignore that for now.<br>
<div class=3D"im"><br>
&gt; fatal error -- can&#39;t read block 8388608 for directory inode 862821=
8<br>
<br>
</div>That&#39;s a corrupted block list of some kind - it should junk the<b=
r>
inode.<br>
<br>
&gt; Then xfs_repair exits.<br>
<br>
I&#39;m not sure why that happens. Is it exiting cleanly or crashing?<br>
Can you take a metadump of the filesystem and provide it for someone<br>
to debug the problems it causes repair?<br></blockquote><div><br></div><div=
>It seems to be exiting cleanly with return code 1. I created a metadump, b=
ut it&#39;s 9.6GB. I suppose I can put up on a secure FTP or something like=
 that, but it does seem a big large to shuffle around.</div>
<div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im"><br>
&gt; What I&#39;ve been doing is what I saw in the FAQ where I would use xf=
s_db and<br>
&gt; write core.mode 0 for these inodes. But there are just so many of them=
. And<br>
&gt; is that even the right thing to do?<br>
<br>
</div>That marks the inode as &quot;free&quot; which effectively junks it a=
nd then<br>
xfs_repair will free all it&#39;s extents next time it is run. Basically<br=
>
you are removing the files from the filesystem and making them<br>
unrecoverable.<br></blockquote><div><br></div><div>In the case of directori=
es, it blows away just directory but xfs_repair later on scans for orphan f=
iles, no? Or am I mistaken on how that works.</div><div>=A0</div><div>Thank=
s,</div>
<div>Viet</div></div></div></div>

--001a1133225288794f04e8537bd2--


--===============1664665025215170852==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1664665025215170852==--
