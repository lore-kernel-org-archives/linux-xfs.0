Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5G7YEHk151809
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 02:34:14 -0500
Received: from qw-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0BE090D776
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 00:42:19 -0700 (PDT)
Received: from qw-out-1920.google.com (qw-out-1920.google.com [74.125.92.144])
	by cuda.sgi.com with ESMTP id PStoh4G39RqisDiq for
	<linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 00:42:19 -0700 (PDT)
Received: by qw-out-1920.google.com with SMTP id 9so2337757qwj.32
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 00:34:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8770d98c0906152344p185533a9rc144a5667d13d2de@mail.gmail.com>
References: <24042506.post@talk.nabble.com> <4A3712BF.7030101@sandeen.net>
	<8770d98c0906152344p185533a9rc144a5667d13d2de@mail.gmail.com>
From: Smit Shah <getsmit@gmail.com>
Date: Tue, 16 Jun 2009 00:34:17 -0700
Message-ID: <8770d98c0906160034n45b8a0d0uc9520fee97e6a9ec@mail.gmail.com>
Subject: Re: XFS Preallocate using ALLOCSP
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4076527026670099945=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

--===============4076527026670099945==
Content-Type: multipart/alternative; boundary=0016e6471b9af12745046c7234af

--0016e6471b9af12745046c7234af
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Mon, Jun 15, 2009 at 11:44 PM, Smit Shah <getsmit@gmail.com> wrote:

>
>
> On Mon, Jun 15, 2009 at 8:34 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>> Smit Shah wrote:
>> > Hi,
>> >
>> > I wanted to preallocate the file using the ALLOCSP so that the
>> preallocated
>> > space is zeroed out. Hence i used the xfsctl but the problem is that i
>> > cannot execute  it as a non-root user.  So i tried using fallocate but
>> when
>> > i saw the xfs implementation of kernel it uses the RESVP cmd and  since
>> the
>> > unwritten flag is set i am assuming that the performance of writing to
>> the
>> > preallocated space will suffer because of the metadata updates. So is
>> there
>> > a way to preallocate using ALLOCSP as a non-root user or else i would be
>> > required to modify the kernel ??
>> >
>> > TIA,
>> > Smit
>>
>> ALLOCSP simply writes 0s to a file.... you may as well do it using posix
>> calls, as a normal user, I think.
>>
>
> Even the man page of fallocate says that it allocates and initializes to
> zero the disk space allocated but when i saw the code i did found out that
> it does not zero it out.  Hence was a kindof confused. So posix_allocate is
> similar to ALLOCSP when falloc is not supported by the underlying filesystem
>  that is to ftruncate the file  and zero it out. So all of them try to
> allocate contiguous blocks but the only difference is when we use the
> fallocate in ext4/xfs it does not zero out the preallocated space. Am i
> right ?
>
I guess i am not right here ftruncate simply does a lseek and wirtes to it
which might not be contiguous whereas fallocate tries to allocate contiguous
block so as to reduce fragmentation and hence i thought to reduce
fragmentation and for security reasons its better to use ALLOCSP rather than
something like ftruncate /posix_fallocate or RSEVSP which kindof performs
bad for writes with unwritten flag set and now there being a no direct way
while creating the fs to disable unwritten.


> But  when i fallocate in ext4 i can see the write performance improvement
> but not in xfs and reason i found out in one of your previous comments is
>  because of the unwritten flag set in xfs. So how do we see if the unwritten
> flag is set or not ? I did use xfs_info but it didnt show any such
> information.
>


>
> Thanks,
> Smit
>
>
>>
>> -Eric
>>
>
>

--0016e6471b9af12745046c7234af
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Mon, Jun 15, 2009 at 11:44 PM, Smit S=
hah <span dir=3D"ltr">&lt;<a href=3D"mailto:getsmit@gmail.com">getsmit@gmai=
l.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">

<br><br><div class=3D"gmail_quote"><div><div></div><div class=3D"h5">On Mon=
, Jun 15, 2009 at 8:34 PM, Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"ma=
ilto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</sp=
an> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
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
<font color=3D"#888888"></font></blockquote><div><br></div></div></div><div=
>Even the man page of fallocate says that it allocates and initializes to z=
ero the disk space allocated but when i saw the code i did found out that i=
t does not zero it out. =A0Hence was a kindof confused.=A0So posix_allocate=
 is similar to ALLOCSP when falloc is not supported by the underlying files=
ystem =A0that is to ftruncate the file =A0and zero it out. So all of them t=
ry to allocate=A0contiguous blocks but the only difference is when we use t=
he fallocate in ext4/xfs it does not zero out the preallocated space. Am i =
right ?=A0</div>

</div></blockquote><div>I guess i am not right here ftruncate simply does a=
 lseek and wirtes to it which might not be contiguous whereas fallocate tri=
es to allocate contiguous block so as to reduce fragmentation and hence i t=
hought to reduce fragmentation and for security reasons its better to use A=
LLOCSP rather than something like ftruncate /posix_fallocate or RSEVSP whic=
h kindof performs bad for writes with unwritten flag set and now there bein=
g a no direct way while creating the fs to disable unwritten.=A0</div>

<div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex;"><div class=3D"gmail_quote"><d=
iv></div>
<div>But =A0when i fallocate in ext4 i can see the write performance improv=
ement but not in xfs and reason i found out in=A0one of your previous comme=
nts is =A0because of the unwritten flag set in xfs. So how do we see if the=
 unwritten flag is set or not ? I did use xfs_info but it didnt show any su=
ch information.=A0=A0</div>


<div></div></div></blockquote><div>=A0</div><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;"=
><div class=3D"gmail_quote"><div><br></div><div>Thanks,=A0</div><div>Smit=
=A0</div>

<div>=A0=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8=
ex;border-left:1px #ccc solid;padding-left:1ex"><font color=3D"#888888"><br=
>
-Eric<br>
</font></blockquote></div><br>
</blockquote></div><br>

--0016e6471b9af12745046c7234af--


--===============4076527026670099945==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4076527026670099945==--
