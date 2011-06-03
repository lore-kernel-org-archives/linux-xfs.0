Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p532BbJE237156 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 21:11:38 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CB9CD21084
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 19:11:35 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id hW7XvZBKaOQqHnVJ
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 19:11:35 -0700 (PDT)
Received: by vws13 with SMTP id 13so1210687vws.26
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 19:11:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110603003907.GW561@dastard>
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<19943.56524.969126.59978@tree.ty.sabi.co.UK>
	<BANLkTim978GhfamN=TEFULP5GdfMu02-7w@mail.gmail.com>
	<4DE823DD.7060600@philkarn.net> <20110603003907.GW561@dastard>
From: Phil Karn <karn@philkarn.net>
Date: Thu, 2 Jun 2011 19:11:15 -0700
Message-ID: <BANLkTikg33_Q89XVuXZgaAAMbhDHnPR+fg@mail.gmail.com>
Subject: Re: I/O hang, possibly XFS, possibly general
Reply-To: karn@ka9q.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2246866751004462470=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Paul Anderson <pha@umich.edu>, Linux fs XFS <xfs@oss.sgi.com>

--===============2246866751004462470==
Content-Type: multipart/alternative; boundary=bcaec51ba1f5e66e2004a4c545ff

--bcaec51ba1f5e66e2004a4c545ff
Content-Type: text/plain; charset=UTF-8

On Thu, Jun 2, 2011 at 5:39 PM, Dave Chinner <david@fromorbit.com> wrote:

>
> You're ignoring the fact that delayed allocation effectively does
> this for you without needing to physically allocate the blocks.
> So when you have files that are short lived, you don't actually do
> any allocation at all, Further delayed allocation results in
> allocation order according to writeback order rather than write()
> order, so I/O patterns are much nicer when using delayed allocation.
>

Oh, I'm well aware of delayed allocation. I've just noticed that, in my
experience, it doesn't seem to work nearly as well as fallocate(). And why
should it? If you know in advance how big a file you're writing, how can it
hurt to inform your file system? I suppose the FS implementer could always
ignore that information if he felt he could somehow do a better job, but
it's hard to see how. Isn't it always better to know than to guess?

I'm talking here about the genuine fallocate() system call, not the POSIX
hack that falls back to first conventionally writing zeroes over the file.
The true fallocate() call seems very fast, and if your file system doesn't
support it then it will simply fail without harm. I still can't see any
reason not to use it.

I did know that xfs can avoid the disk allocation and writes entirely when
the files are short-lived, but Paul was talking about writing large,
long-lived files so that's what I had in mind. And when I use fallocate(),
my files are not likely to be short-lived either. Like most people I write
the vast majority of my short-lived files to /tmp, which is tmpfs, not xfs.

But you do raise an interesting point -- is there any serious performance
degradation from using fallocate() on a short-lived file? The written data
still lives in the buffer cache for a while, so if you delete the file
before it gets flushed the disk writes will still be avoided. The file
system may have a little extra work to undo the unnecessary allocation but
that doesn't seem to be a big deal.

Basicaly you are removing one of the major IO optimisation
> capabilities of XFS by preallocating everything like this.
>

"Remove" it? How is giving it the correct answer worse than letting it guess
-- even if it usually guesses correctly?

I still rely on preallocation to keep log files and mailboxes from getting
too badly fragmented.

>So you don't have any idea of how well XFS minimises fragmentation

> without needing to use preallocation? Sounds like you have a classic
> case of premature optimisation. ;)
>
>
As I said, I've tried it both ways. I found that the simple act of adding
fallocate() to rsync (which I use for practically all copying) vastly
reduces xfs fragmentation. Just as I expected it would.

Maybe I'm a little more sensitive to fragmentation than most because I've
been experimenting with storing SHA1 hashes of all my files in external
attributes. This grew out of a data deduplication tool; at first I simply
cached the hashes so I wouldn't have to recompute them on another run, but
then I just added them to every file. This lets me get a warm and fuzzy
feeling by periodically verifying that my files haven't been corrupted,
especially when I began to use SSDs with trim tools.

XFS stores both attributes and extent lists directly in the inode when
there's room, and it turns out that a default-sized xfs inode can store my
hashes provided that the extent list is small. So I now when I walk through
my file system statting everything I can read the hashes too at absolutely
no extra cost. This makes deduplication really fast.

I haven't experimented to see how many extents a file can have before the
attributes get pushed out of the inode, but by keeping most everything
contiguous I simply avoid the problem.

--bcaec51ba1f5e66e2004a4c545ff
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 2, 2011 at 5:39 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=
=3D"mailto:david@fromorbit.com">david@fromorbit.com</a>&gt;</span> wrote:<b=
r><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">

<div class=3D"im"><br>
</div>You&#39;re ignoring the fact that delayed allocation effectively does=
<br>
this for you without needing to physically allocate the blocks.<br>
So when you have files that are short lived, you don&#39;t actually do<br>
any allocation at all, Further delayed allocation results in<br>
allocation order according to writeback order rather than write()<br>
order, so I/O patterns are much nicer when using delayed allocation.<br></b=
lockquote><div><br>Oh, I&#39;m well aware of delayed allocation. I&#39;ve j=
ust noticed that, in my experience, it doesn&#39;t seem to work nearly as w=
ell as fallocate(). And why should it? If you know in advance how big a fil=
e you&#39;re writing, how can it hurt to inform your file system? I suppose=
 the FS implementer could always ignore that information if he felt he coul=
d somehow do a better job, but it&#39;s hard to see how. Isn&#39;t it alway=
s better to know than to guess?<br>

<br>I&#39;m talking here about the genuine fallocate() system call, not the=
 POSIX hack that falls back to first conventionally writing zeroes over the=
 file. The true fallocate() call seems very fast, and if your file system d=
oesn&#39;t support it then it will simply fail without harm. I still can&#3=
9;t see any reason not to use it.<br>

<br>I did know that xfs can avoid the disk allocation and writes entirely w=
hen the files are short-lived, but Paul was talking about writing large, lo=
ng-lived files so that&#39;s what I had in mind. And when I use fallocate()=
, my files are not likely to be short-lived either. Like most people I writ=
e the vast majority of my short-lived files to /tmp, which is tmpfs, not xf=
s.<br>

<br>But you do raise an interesting point -- is there any serious performan=
ce degradation from using fallocate() on a short-lived file? The written da=
ta still lives in the buffer cache for a while, so if you delete the file b=
efore it gets flushed the disk writes will still be avoided. The file syste=
m may have a little extra work to undo the unnecessary allocation but that =
doesn&#39;t seem to be a big deal.<br>

<br></div><blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 0pt 0.=
8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
Basicaly you are removing one of the major IO optimisation<br>
capabilities of XFS by preallocating everything like this.<br></blockquote>=
<div><br>&quot;Remove&quot; it? How is giving it the correct answer worse t=
han letting it guess -- even if it usually guesses correctly?<br><br>I stil=
l rely on preallocation to keep log files and mailboxes from getting too ba=
dly fragmented.<br>

<br>&gt;So you don&#39;t have any idea of how well XFS minimises fragmentat=
ion <br></div><blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 0p=
t 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
without needing to use preallocation? Sounds like you have a classic<br>
case of premature optimisation. ;)<br><br></blockquote><div><br>As I said, =
I&#39;ve tried it both ways. I found that the simple act of adding fallocat=
e() to rsync (which I use for practically all copying) vastly reduces xfs f=
ragmentation. Just as I expected it would.<br>

<br>Maybe I&#39;m a little more sensitive to fragmentation than most becaus=
e I&#39;ve been experimenting with storing SHA1 hashes of all my files in e=
xternal attributes. This grew out of a data deduplication tool; at first I =
simply cached the hashes so I wouldn&#39;t have to recompute them on anothe=
r run, but then I just added them to every file. This lets me get a warm an=
d fuzzy feeling by periodically verifying that my files haven&#39;t been co=
rrupted, especially when I began to use SSDs with trim tools.<br>

<br>XFS stores both attributes and extent lists directly in the inode when =
there&#39;s room, and it turns out that a default-sized xfs inode can store=
 my hashes provided that the extent list is small. So I now when I walk thr=
ough my file system statting everything I can read the hashes too at absolu=
tely no extra cost. This makes deduplication really fast.<br>

<br>I haven&#39;t experimented to see how many extents a file can have befo=
re the attributes get pushed out of the inode, but by keeping most everythi=
ng contiguous I simply avoid the problem.<br><br><br><br></div></div>

--bcaec51ba1f5e66e2004a4c545ff--


--===============2246866751004462470==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2246866751004462470==--
