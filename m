Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1236E7F3F
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 16:13:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E53EE8F8059
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 14:13:45 -0700 (PDT)
Received: from mail-wg0-f44.google.com (mail-wg0-f44.google.com
	[74.125.82.44]) by cuda.sgi.com with ESMTP id COVFgsiCjtHt7Y95
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 14:13:44 -0700 (PDT)
Received: by mail-wg0-f44.google.com with SMTP id n12so2679397wgh.23
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 14:13:43 -0700 (PDT)
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
Date: Thu, 10 Oct 2013 14:13:43 -0700
Message-ID: <CAGa4098d7NL86HPX0+zyTSGafrxS3VMepbJ_3JKoaTCZud59qg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============4551038399539579914=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============4551038399539579914==
Content-Type: multipart/alternative; boundary=f46d0437499304c83e04e8697ab6

--f46d0437499304c83e04e8697ab6
Content-Type: text/plain; charset=ISO-8859-1

Luckily the files that I want to recover have metadata in them that will
help me rebuild their names. So I'm okay with blowing away the directory
inodes. I guess I wish there was a flag that I can pass to say that
xfs_repair can junk those for me instead of having to do it manually each
time.


So, the compressed metadump file is 2.4G. Any suggestions on where I should
put it, and who I send it to?

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
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

--f46d0437499304c83e04e8697ab6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Luckily the files that I want to recover have metadata in =
them that will help me rebuild their names. So I&#39;m okay with blowing aw=
ay the directory inodes. I guess I wish there was a flag that I can pass to=
 say that xfs_repair can junk those for me instead of having to do it manua=
lly each time.<div>
<br></div><div><br><div class=3D"gmail_extra">So, the compressed metadump f=
ile is 2.4G. Any suggestions on where I should put it, and who I send it to=
?<br><br><div class=3D"gmail_quote">On Tue, Oct 8, 2013 at 1:23 PM, Dave Ch=
inner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br>
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
to debug the problems it causes repair?<br>
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
unrecoverable.<br>
<div class=3D"im"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
<br>
</div>_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</blockquote></div><br></div></div></div>

--f46d0437499304c83e04e8697ab6--


--===============4551038399539579914==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4551038399539579914==--
