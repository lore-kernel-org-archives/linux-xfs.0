Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5G6iUrL150014
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 01:44:30 -0500
Received: from qw-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBF0E12613F6
	for <linux-xfs@oss.sgi.com>; Mon, 15 Jun 2009 23:44:52 -0700 (PDT)
Received: from qw-out-1920.google.com (qw-out-1920.google.com [74.125.92.149])
	by cuda.sgi.com with ESMTP id F2QiGOigKFSAajKv for
	<linux-xfs@oss.sgi.com>; Mon, 15 Jun 2009 23:44:52 -0700 (PDT)
Received: by qw-out-1920.google.com with SMTP id 9so2326623qwj.32
	for <linux-xfs@oss.sgi.com>; Mon, 15 Jun 2009 23:44:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A3712BF.7030101@sandeen.net>
References: <24042506.post@talk.nabble.com> <4A3712BF.7030101@sandeen.net>
From: Smit Shah <getsmit@gmail.com>
Date: Mon, 15 Jun 2009 23:44:32 -0700
Message-ID: <8770d98c0906152344p185533a9rc144a5667d13d2de@mail.gmail.com>
Subject: Re: XFS Preallocate using ALLOCSP
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8549705744485376789=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

--===============8549705744485376789==
Content-Type: multipart/alternative; boundary=0016e6475e8606183a046c7183d0

--0016e6475e8606183a046c7183d0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Mon, Jun 15, 2009 at 8:34 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Smit Shah wrote:
> > Hi,
> >
> > I wanted to preallocate the file using the ALLOCSP so that the
> preallocated
> > space is zeroed out. Hence i used the xfsctl but the problem is that i
> > cannot execute  it as a non-root user.  So i tried using fallocate but
> when
> > i saw the xfs implementation of kernel it uses the RESVP cmd and  since
> the
> > unwritten flag is set i am assuming that the performance of writing to
> the
> > preallocated space will suffer because of the metadata updates. So is
> there
> > a way to preallocate using ALLOCSP as a non-root user or else i would be
> > required to modify the kernel ??
> >
> > TIA,
> > Smit
>
> ALLOCSP simply writes 0s to a file.... you may as well do it using posix
> calls, as a normal user, I think.
>

Even the man page of fallocate says that it allocates and initializes to
zero the disk space allocated but when i saw the code i did found out that
it does not zero it out.  Hence was a kindof confused. So posix_allocate is
similar to ALLOCSP when falloc is not supported by the underlying filesystem
 that is to ftruncate the file  and zero it out. So all of them try to
allocate contiguous blocks but the only difference is when we use the
fallocate in ext4/xfs it does not zero out the preallocated space. Am i
right ?
But  when i fallocate in ext4 i can see the write performance improvement
but not in xfs and reason i found out in one of your previous comments is
 because of the unwritten flag set in xfs. So how do we see if the unwritten
flag is set or not ? I did use xfs_info but it didnt show any such
information.

Thanks,
Smit


>
> -Eric
>

--0016e6475e8606183a046c7183d0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Mon, Jun 15, 2009 at 8:34 PM, Eric Sa=
ndeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@=
sandeen.net</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">

Smit Shah wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I wanted to preallocate the file using the ALLOCSP so that the preallo=
cated<br>
&gt; space is zeroed out. Hence i used the xfsctl but the problem is that i=
<br>
&gt; cannot execute =A0it as a non-root user. =A0So i tried using fallocate=
 but when<br>
&gt; i saw the xfs implementation of kernel it uses the RESVP cmd and =A0si=
nce the<br>
&gt; unwritten flag is set i am assuming that the performance of writing to=
 the<br>
&gt; preallocated space will suffer because of the metadata updates. So is =
there<br>
&gt; a way to preallocate using ALLOCSP as a non-root user or else i would =
be<br>
&gt; required to modify the kernel ??<br>
&gt;<br>
&gt; TIA,<br>
&gt; Smit<br>
<br>
ALLOCSP simply writes 0s to a file.... you may as well do it using posix<br=
>
calls, as a normal user, I think.<br>
<font color=3D"#888888"></font></blockquote><div><br></div><div>Even the ma=
n page of fallocate says that it allocates and initializes to zero the disk=
 space allocated but when i saw the code i did found out that it does not z=
ero it out. =A0Hence was a kindof confused.=A0So posix_allocate is similar =
to ALLOCSP when falloc is not supported by the underlying filesystem =A0tha=
t is to ftruncate the file =A0and zero it out. So all of them try to alloca=
te=A0contiguous blocks but the only difference is when we use the fallocate=
 in ext4/xfs it does not zero out the preallocated space. Am i right ?=A0</=
div>

<div>But =A0when i fallocate in ext4 i can see the write performance improv=
ement but not in xfs and reason i found out in=A0one of your previous comme=
nts is =A0because of the unwritten flag set in xfs. So how do we see if the=
 unwritten flag is set or not ? I did use xfs_info but it didnt show any su=
ch information.=A0=A0</div>

<div><br></div><div>Thanks,=A0</div><div>Smit=A0</div><div>=A0=A0</div><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex;"><font color=3D"#888888"><br>
-Eric<br>
</font></blockquote></div><br>

--0016e6475e8606183a046c7183d0--


--===============8549705744485376789==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8549705744485376789==--
