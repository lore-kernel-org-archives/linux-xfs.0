Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE2557F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 07:54:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA20A304039
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 05:54:06 -0700 (PDT)
Received: from mail-ig0-f173.google.com (mail-ig0-f173.google.com
	[209.85.213.173]) by cuda.sgi.com with ESMTP id
	A4qhlABcH3QSN5Ib (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 05:54:04 -0700 (PDT)
Received: by igui7 with SMTP id i7so59999579igu.1
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 05:54:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150817193223.GE26222@infradead.org>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-6-git-send-email-jtulak@redhat.com>
	<20150817193223.GE26222@infradead.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 24 Aug 2015 14:53:44 +0200
Message-ID: <CACj3i72jcVM9JiqvT8TvM+aB9sC3ycBgCCR6SsOqDWXjh4fCJw@mail.gmail.com>
Subject: Re: [PATCH 05/11] xfsprogs: missing and dummy calls for OS X support
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6549241819252397869=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============6549241819252397869==
Content-Type: multipart/alternative; boundary=047d7bd6b082bebc95051e0e1c7b

--047d7bd6b082bebc95051e0e1c7b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

As I got stuck with some C-related things in the changes for much longer
than I
anticipated, I'm making just this reply now - patches will came once I get
it
working.

On Mon, Aug 17, 2015 at 9:32 PM, Christoph Hellwig <hch@infradead.org>
wrote:
>
> Do you have any idea why MacOS defines a uuid_t, but wants unsigned
> char arguments to uuid_compare?
>

=E2=80=8Buuid_t works too. :-)=E2=80=8B=E2=80=8B



> > +static inline int nftw64(const char *path, int (*fn)(const char *,
> const struct stat *ptr, int flag, struct FTW *), int depth,
> > +         int flags)
> > +{
> > +     return nftw(path, fn, depth, flags);
> > +}

> +#define MREMAP_FIXED 1
> > +#define MREMAP_MAYMOVE 2
> > +static inline void *mremap(void *old_address, size_t old_size,
> > +                    size_t new_size, int flags, ... /* void
> *new_address */)
> > +{
> > +     return NULL;
> > +}
> > +
> > +/* FSR */
>
> Please just build the mremap file in xfs_io conditional.
>

Well, if I make io/mmap.c
=E2=80=8B(=E2=80=8B
where mremap is used
=E2=80=8B) c=E2=80=8B
onditional, then I need to
make multiple dummy calls
=E2=80=8B =E2=80=8B
or put ifdefs around every call from this file. So instead of a sing
=E2=80=8BWell, if I make io/mmap.c, where mremap is used, conditional, then=
 I need
to
make multiple dummy calls or put ifdefs around every call from that file.
So instead of a single dummy call and two defines, I ends with more
changes...=E2=80=8B

IOW, I don't see any file I could remove from xfs_io without bigger changes=
.



>
> > +typedef int __fsblkcnt_t;
> > +typedef int __fsfilcnt_t;
> > +typedef long long int __fsblkcnt64_t;
> > +typedef long long int __fsfilcnt64_t;
> > +
> > +struct statvfs64
> > +{
> > +     unsigned long int f_bsize;
> > +     unsigned long int f_frsize;
> > +     __fsblkcnt64_t f_blocks;
> > +     __fsblkcnt64_t f_bfree;
> > +     __fsblkcnt64_t f_bavail;
> > +     __fsfilcnt64_t f_files;
> > +     __fsfilcnt64_t f_ffree;
> > +     __fsfilcnt64_t f_favail;
> > +     unsigned long int f_fsid;
> > +     int __f_unused;
> > +     unsigned long int f_flag;
> > +     unsigned long int f_namemax;
> > +     int __f_spare[6];
> > +};
>
> Does MacOS support statvfs? or statfs?  We should use the proper API
> here instead of a dummy.  Or maybe just not build fsr on OSX for now,
> as that would solve the fsetxattr issue as well.
>
>
=E2=80=8BNow, this is what stopped me. As far as I can tell, simple

#define statvfs64 statfs

do the job, as Mac has the struct and the call. But statfs on Mac is missin=
g
f_frsize and related members. I tried to make something with it, but I run
out of ideas others than redefine the struct...

=E2=80=8BI still don't like the idea of removing fsr from OSX build, but if=
 the
amount
of dummies is too big, it may end that way... :-(=E2=80=8B

=E2=80=8BCheers,
Jan=E2=80=8B

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--047d7bd6b082bebc95051e0e1c7b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">As I got stuck with some C-related things in the changes f=
or much longer than I <br>anticipated, I&#39;m making just this reply now -=
 patches will came once I get it=C2=A0<div>working.</div><div><br><div clas=
s=3D"gmail_extra"><div class=3D"gmail_quote">On Mon, Aug 17, 2015 at 9:32 P=
M, Christoph Hellwig <span dir=3D"ltr">&lt;<a href=3D"mailto:hch@infradead.=
org" target=3D"_blank">hch@infradead.org</a>&gt;</span> wrote:<blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1p=
x;border-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1=
ex">Do you have any idea why MacOS defines a uuid_t, but wants unsigned<br>
char arguments to uuid_compare?<br></blockquote><div><br></div><div><div cl=
ass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">=E2=
=80=8Buuid_t works too. :-)=E2=80=8B<span style=3D"font-family:arial,helvet=
ica,sans-serif">=E2=80=8B</span></div></div><div><br></div><div>=C2=A0</div=
><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border=
-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;=
padding-left:1ex"><span class=3D"">
&gt; +static inline int nftw64(const char *path, int (*fn)(const char *, co=
nst struct stat *ptr, int flag, struct FTW *), int depth,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int flags)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return nftw(path, fn, depth, flags);<br>
&gt; +}</span>=C2=A0</blockquote><blockquote class=3D"gmail_quote" style=3D=
"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,2=
04,204);border-left-style:solid;padding-left:1ex"><span class=3D"">
&gt; +#define MREMAP_FIXED 1<br>
&gt; +#define MREMAP_MAYMOVE 2<br>
&gt; +static inline void *mremap(void *old_address, size_t old_size,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 size_t new_size, int flags, ... /* void *new_address */)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return NULL;<br>
&gt; +}<br>
&gt; +<br>
&gt; +/* FSR */<br>
<br>
</span>Please just build the mremap file in xfs_io conditional.<br></blockq=
uote><br>Well, if I make io/mmap.c <div class=3D"gmail_default" style=3D"fo=
nt-family:arial,helvetica,sans-serif;display:inline">=E2=80=8B(=E2=80=8B</d=
iv>where=C2=A0mremap is used<div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif;display:inline">=E2=80=8B) c=E2=80=8B</div>on=
ditional, then I need to</div><div class=3D"gmail_quote">make multiple dumm=
y calls<div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sa=
ns-serif;display:inline">=E2=80=8B =E2=80=8B</div>or put ifdefs around ever=
y call from this file. So instead of a sing</div><div class=3D"gmail_quote"=
><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-ser=
if">=E2=80=8BWell, if I make io/mmap.c, where mremap is used, conditional, =
then I need to</div><div class=3D"gmail_default" style=3D"font-family:arial=
,helvetica,sans-serif">make multiple dummy calls or put ifdefs around every=
 call from that file.</div><div class=3D"gmail_default" style=3D"font-famil=
y:arial,helvetica,sans-serif">So instead of a single dummy call and two def=
ines, I ends with more</div><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif">changes...=E2=80=8B</div><div class=3D"gmail=
_default" style=3D"font-family:arial,helvetica,sans-serif"><br></div><div c=
lass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">IOW=
, I don&#39;t see any file I could remove from xfs_io without bigger change=
s.</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,s=
ans-serif"><br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(=
204,204,204);border-left-style:solid;padding-left:1ex">
<span class=3D""><br>
&gt; +typedef int __fsblkcnt_t;<br>
&gt; +typedef int __fsfilcnt_t;<br>
&gt; +typedef long long int __fsblkcnt64_t;<br>
&gt; +typedef long long int __fsfilcnt64_t;<br>
&gt; +<br>
&gt; +struct statvfs64<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0unsigned long int f_bsize;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0unsigned long int f_frsize;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0__fsblkcnt64_t f_blocks;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0__fsblkcnt64_t f_bfree;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0__fsblkcnt64_t f_bavail;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0__fsfilcnt64_t f_files;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0__fsfilcnt64_t f_ffree;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0__fsfilcnt64_t f_favail;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0unsigned long int f_fsid;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int __f_unused;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0unsigned long int f_flag;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0unsigned long int f_namemax;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int __f_spare[6];<br>
&gt; +};<br>
<br>
</span>Does MacOS support statvfs? or statfs?=C2=A0 We should use the prope=
r API<br>
here instead of a dummy.=C2=A0 Or maybe just not build fsr on OSX for now,<=
br>
as that would solve the fsetxattr issue as well.<br>
<br></blockquote><div><br></div><div><div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif">=E2=80=8BNow, this is what stopped =
me. As far as I can tell, simple</div><div class=3D"gmail_default" style=3D=
"font-family:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_defa=
ult" style=3D"font-family:arial,helvetica,sans-serif">#define statvfs64 sta=
tfs</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,=
sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">do the job, as Mac has the struct and the call. Bu=
t statfs on Mac is missing</div></div><div class=3D"gmail_default" style=3D=
"">f_frsize and related members. I tried to make something with it, but I r=
un=C2=A0</div><div class=3D"gmail_default" style=3D"">out of ideas others t=
han redefine the struct...</div><div>=C2=A0</div><div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BI still d=
on&#39;t like the idea of removing fsr from OSX build, but if the amount</d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif">of dummies is too big, it may end that way... :-(=E2=80=8B</div></div=
></div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_default" st=
yle=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BCheers,</div><div c=
lass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">Jan=
=E2=80=8B</div><div><br></div>-- <br><div class=3D"gmail_signature"><div di=
r=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:j=
tulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D=
"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></div><=
/div>
</div></div></div>

--047d7bd6b082bebc95051e0e1c7b--


--===============6549241819252397869==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6549241819252397869==--
