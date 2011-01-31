Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0V2anRm059309 for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 20:36:49 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B342A29D12C
	for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 18:39:16 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	kMmEayYzPCju7hx9 for <xfs@oss.sgi.com>;
	Sun, 30 Jan 2011 18:39:16 -0800 (PST)
Received: by qyk12 with SMTP id 12so5612664qyk.5
	for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 18:39:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTiktigbHHHsYrxRBja6LxQ3N_gAq_KAoLNYGRB=r@mail.gmail.com>
References: <AANLkTiktigbHHHsYrxRBja6LxQ3N_gAq_KAoLNYGRB=r@mail.gmail.com>
Date: Mon, 31 Jan 2011 11:39:15 +0900
Message-ID: <AANLkTinK25hL3Ljy42S6KrqEJ7nW_L+c77GPJhBVo=58@mail.gmail.com>
Subject: Re: [patch] xfsprogs: repair pagefault due to missed out sanity NULL
	check
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2556124010945740276=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2556124010945740276==
Content-Type: multipart/alternative; boundary=0015175ce04066cda8049b1b52f6

--0015175ce04066cda8049b1b52f6
Content-Type: text/plain; charset=ISO-8859-1

I did not receive any response / review comment on solution patch I sent.

diff -Nurp xfsprogs/repair/dir2.c xfsprogs-dirty/repair/dir2.c

--- xfsprogs/repair/dir2.c 2010-07-16 13:07:09.000000000 +0900

+++ xfsprogs-dirty/repair/dir2.c 2011-01-28 18:49:21.000000000 +0900

@@ -110,9 +110,10 @@ da_read_buf(

bplist[i] = libxfs_readbuf(mp->m_dev,

XFS_FSB_TO_DADDR(mp, bmp[i].startblock),

XFS_FSB_TO_BB(mp, bmp[i].blockcount), 0);

- if (!bplist[i])

+ if (!bplist[i]){

+ nex = i;

goto failed;

-

+ }

pftrace("readbuf %p (%llu, %d)", bplist[i],

(long long)XFS_BUF_ADDR(bplist[i]),

XFS_BUF_COUNT(bplist[i]));
On Fri, Jan 28, 2011 at 8:13 PM, Ajeet Yadav <ajeet.yadav.77@gmail.com>wrote:

> libxfs_putbuf() is called with bp = NULL, resulting in pagefault in
> libpthread.
>
> Function da_read_buf() allocate array of xfs_buf_t *
>
>    * xfs_buf_t       **bplist;*
>
> *    bplist = calloc(nex, sizeof(*bplist));*
>
> Read and fill it using
>
> *for (i = 0; i < nex; i++) {
>     bplist[i] = libxfs_readbuf()*
>
> *    if (!bplist[i]){
>         goto failed;
>     }  *
>
> *}*
>
> *failed:
>         for (i = 0; i < nex; i++)
>                 libxfs_putbuf(bplist[i]);*
>
> Now assume nex = 10,
>
> 1. Will create bplist for 10 array elements.
>
> 3. Reading from disk 0,1, 2, 3
>
> 4. When reading from disk 4, USB is removed
>
> 5. libxfs_readbuf() will at fail, pblist[4] = NULL, goto failed.
>
> 6. Since only 4 buffers were read successfully, so only 4 are in lock
> state.
>
> 7.  Error handling will unlock buffer from 1-10
>
> 8. Buffer 0-3 were read successfully, hence will have valid pdlist[i]
>
> 9. Access pblist[4] == NULL, therefore unlocking will set bp == NULL in
> libxfs_putbuf(bp);
> 10. Page fault in libpthread
>
>
> Solution patch attached with mail
>
>
>

--0015175ce04066cda8049b1b52f6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>I did not receive any response / review comment on solution patch I se=
nt.<br></div>
<div><span lang=3D"EN">
<p>diff -Nurp xfsprogs/repair/dir2.c xfsprogs-dirty/repair/dir2.c</p>
<p>--- xfsprogs/repair/dir2.c 2010-07-16 13:07:09.000000000 +0900</p>
<p>+++ xfsprogs-dirty/repair/dir2.c 2011-01-28 18:49:21.000000000 +0900</p>
<p>@@ -110,9 +110,10 @@ da_read_buf(</p>
<p>bplist[i] =3D libxfs_readbuf(mp-&gt;m_dev,</p>
<p>XFS_FSB_TO_DADDR(mp, bmp[i].startblock),</p>
<p>XFS_FSB_TO_BB(mp, bmp[i].blockcount), 0);</p>
<p>- if (!bplist[i])</p>
<p>+ if (!bplist[i]){</p>
<p>+ nex =3D i;</p>
<p>goto failed;</p>
<p>-</p>
<p>+ }</p>
<p>pftrace(&quot;readbuf %p (%llu, %d)&quot;, bplist[i],</p>
<p>(long long)XFS_BUF_ADDR(bplist[i]),</p>
<p>XFS_BUF_COUNT(bplist[i]));</p></span></div>
<div class=3D"gmail_quote">On Fri, Jan 28, 2011 at 8:13 PM, Ajeet Yadav <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:ajeet.yadav.77@gmail.com">ajeet.yadav.=
77@gmail.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt">libxfs_putbuf() is called with=A0bp =3D NULL, resulting in pa=
gefault in libpthread.</span></font></div>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt"></span></font>=A0</div>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt">Function da_read_buf() allocate array of=A0xfs_buf_t *</span>=
</font></div>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">=A0=A0=A0<strong>=A0xfs_buf_t=A0=A0=A0=A0=A0=A0 **bplist;</stro=
ng></span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt"><strong>=A0=A0=A0=A0bplist =3D calloc(nex, sizeof(*bplist));</s=
trong></span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">Read and fill it using =A0</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt"><strong>for (i =3D 0; i &lt; nex; i++) {<br>=A0=A0=A0=A0bplist[=
i] =3D libxfs_readbuf()</strong></span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt"><strong>=A0=A0=A0=A0if (!bplist[i]){<br>=A0=A0=A0=A0=A0=A0=A0=
=A0goto failed;<br>=A0=A0=A0=A0}=A0=A0</strong></span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt"><strong>}</strong></span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt"><strong>failed:<br>=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i &lt; n=
ex; i++)<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 libxfs_putbuf(bpl=
ist[i]);</strong></span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">Now assume nex =3D 10,</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">1. Will create bplist for 10 array elements.</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">3. Reading from disk 0,1, 2, 3</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">4. When reading from disk 4, USB is removed</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">5. libxfs_readbuf() will at fail,=A0pblist[4] =3D NULL, goto fa=
iled.</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">6. Since only 4 buffers were read successfully, so only 4 are i=
n lock state.</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">7. =A0Error handling=A0will unlock buffer from 1-10</span></fon=
t></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">8. Buffer 0-3 were read successfully, hence will have valid pdl=
ist[i]</span></font></p>
<p><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FONT=
-SIZE: 9pt">9. Access=A0pblist[4] =3D=3D NULL, therefore unlocking will set=
 bp =3D=3D NULL in libxfs_putbuf(bp);</span></font></p>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt">10. Page fault in libpthread</span></font></div>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt"></span></font>=A0</div>
<div>=A0</div>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt">Solution patch attached with mail</span></font></div>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt"></span></font>=A0</div>
<div><font face=3D"Bookman Old Style"><span style=3D"FONT-FAMILY: Arial; FO=
NT-SIZE: 9pt"></span></font>=A0</div></blockquote></div><br>

--0015175ce04066cda8049b1b52f6--


--===============2556124010945740276==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2556124010945740276==--
