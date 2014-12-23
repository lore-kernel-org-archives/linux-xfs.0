Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ACCC57F5A
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 16:35:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D9DA8F8035
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 14:35:57 -0800 (PST)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
	[209.85.217.170]) by cuda.sgi.com with ESMTP id
	0ORoCSdUGNbSYkAD (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Dec 2014 14:35:56 -0800 (PST)
Received: by mail-lb0-f170.google.com with SMTP id 10so6111221lbg.15
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 14:35:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141221221853.GG24183@dastard>
References: <CAHJqNbx8qrs6OosFq1TGz4jqzxh82zvLRzxQ1oWpOp5MP6h3oQ@mail.gmail.com>
	<20141221221853.GG24183@dastard>
Date: Tue, 23 Dec 2014 23:35:54 +0100
Message-ID: <CAHJqNbwbH6p-_UoDk1TwRgrwLPxss-AN2x7YN63J4hzES8t2gA@mail.gmail.com>
Subject: Re: finobt option for end user
From: Alphazo <alphazo@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9007107772694394859=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============9007107772694394859==
Content-Type: multipart/alternative; boundary=089e01419b5c471636050ae9ccab

--089e01419b5c471636050ae9ccab
Content-Type: text/plain; charset=UTF-8

Thanks Dave and Michael for the very informative answers.

I have updated the official ArchLinux XFS wiki page based upon the
information I gathered here so it can benefit to others.

https://wiki.archlinux.org/index.php/XFS#Free_inode_btree

Please do not hesitate to let me know if you see any mistake in my overview.

Cheers,
Alphazo

On Sun, Dec 21, 2014 at 11:18 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Sat, Dec 20, 2014 at 11:52:57PM +0100, Alphazo wrote:
> > Hello,
> >
> > I'm pretty new to XFS. I'm considering moving away from ext4 to XFS
> because
> > of the new self-describing option, performance and reliability
> improvements
> > that XFS went through over the past year. Now I'm puzzled with the new
> free
> > inode btree option (finobt). I tried to find some documentation about it
> > but couldn't find the pros or cons. So from an end-user perspective with
> a
> > couple of TB worth of photos:
> > - Does it improve overall reliability?
>
> No effect on reliability, good or bad.
>
> > - Does it provide faster fsck/repair?
>
> No, if anything, it slows it down because there's more metadata to
> verify and rebuild.
>
> > - Does it improve any read or write operation?
>
> No.
>
> > - Is it safe to use and does it recover as well as with finobt=0?
>
> Yes and yes.
>
> > - What is the typical case for enabling it
>
> It improves performance on aged filesystems i.e. months or years
> down the track when you've added and removed millions of
> files to/from the filesystem.
>
> > and would you recommend using it
> > for any new fs creation?
>
> Consider the fact that "-m crc=1,finobt=1" will be made the mkfs
> default in 3-6 months time - that will probably co-incide with a
> xfsprogs 3.3 release....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--089e01419b5c471636050ae9ccab
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks Dave and Michael for the very informative answers.<=
div><br></div><div>I have updated the official ArchLinux XFS wiki page base=
d upon the information I gathered here so it can benefit to others.</div><d=
iv><br></div><div><a href=3D"https://wiki.archlinux.org/index.php/XFS#Free_=
inode_btree">https://wiki.archlinux.org/index.php/XFS#Free_inode_btree</a><=
br></div><div><br></div><div>Please do not hesitate to let me know if you s=
ee any mistake in my overview.</div><div><br></div><div>Cheers,</div><div>A=
lphazo</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote"=
>On Sun, Dec 21, 2014 at 11:18 PM, Dave Chinner <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>=
&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0=
 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Sa=
t, Dec 20, 2014 at 11:52:57PM +0100, Alphazo wrote:<br>
&gt; Hello,<br>
&gt;<br>
&gt; I&#39;m pretty new to XFS. I&#39;m considering moving away from ext4 t=
o XFS because<br>
&gt; of the new self-describing option, performance and reliability improve=
ments<br>
&gt; that XFS went through over the past year. Now I&#39;m puzzled with the=
 new free<br>
&gt; inode btree option (finobt). I tried to find some documentation about =
it<br>
&gt; but couldn&#39;t find the pros or cons. So from an end-user perspectiv=
e with a<br>
&gt; couple of TB worth of photos:<br>
&gt; - Does it improve overall reliability?<br>
<br>
</span>No effect on reliability, good or bad.<br>
<span class=3D""><br>
&gt; - Does it provide faster fsck/repair?<br>
<br>
</span>No, if anything, it slows it down because there&#39;s more metadata =
to<br>
verify and rebuild.<br>
<span class=3D""><br>
&gt; - Does it improve any read or write operation?<br>
<br>
</span>No.<br>
<span class=3D""><br>
&gt; - Is it safe to use and does it recover as well as with finobt=3D0?<br=
>
<br>
</span>Yes and yes.<br>
<span class=3D""><br>
&gt; - What is the typical case for enabling it<br>
<br>
</span>It improves performance on aged filesystems i.e. months or years<br>
down the track when you&#39;ve added and removed millions of<br>
files to/from the filesystem.<br>
<span class=3D""><br>
&gt; and would you recommend using it<br>
&gt; for any new fs creation?<br>
<br>
</span>Consider the fact that &quot;-m crc=3D1,finobt=3D1&quot; will be mad=
e the mkfs<br>
default in 3-6 months time - that will probably co-incide with a<br>
xfsprogs 3.3 release....<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--089e01419b5c471636050ae9ccab--


--===============9007107772694394859==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9007107772694394859==--
