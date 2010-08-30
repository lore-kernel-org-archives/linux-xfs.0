Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7UMtZpA027799 for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 17:55:36 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52DF314E27B4
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 16:06:37 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	SyDuuATo9OwULiFU for <xfs@oss.sgi.com>;
	Mon, 30 Aug 2010 16:06:37 -0700 (PDT)
Received: by qyk4 with SMTP id 4so24902qyk.5
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 15:56:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C7C26E8.9070308@sandeen.net>
References: <AANLkTin-zf0chkk68pGfwDRt03QaKmNdsP3=goDEUS+p@mail.gmail.com>
	<4C7C26E8.9070308@sandeen.net>
Date: Mon, 30 Aug 2010 17:56:07 -0500
Message-ID: <AANLkTinXDQoo7ZU+w2V7N7zBrxdS=Tc71MNZ7M4R5A9w@mail.gmail.com>
Subject: Re: What should to do with ASSERT failed
From: Mike Gao <ygao.linux@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2025509688381697963=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============2025509688381697963==
Content-Type: multipart/alternative; boundary=001636310673b21339048f125e78

--001636310673b21339048f125e78
Content-Type: text/plain; charset=ISO-8859-1

Thanks very much for help. The kernel is pretty old, 2.6.19 but the xfs is
pretty new.
the block size is 512 and use mmap for test with write and read compare.
(xfstest 074).

If I ignored this ASSERT(comment out), the test will failed. I guess because
some pages never written to disk.

Assertion failed: !buffer_dirty(bh), file: fs/xfs/linux-2.6/xfs_aops.c,
line: 1399
BUG: failure at fs/xfs/support/debug.c:108/assfail()!
Kernel panic - not syncing: BUG!

EIP: 0073:[<b76f5424>] CPU: 0 Not tainted ESP: 007b:b75a6fa8 EFLAGS:
00000246
    Not tainted
EAX: 00000000 EBX: 00000e97 ECX: 00000013 EDX: 00000e97
ESI: 00000e93 EDI: 00000011 EBP: b75a6fc4 DS: 007b ES: 007b
0a7d7c94:  [<0806bd41>] show_regs+0xc5/0xca
0a7d7cc0:  [<0805a920>] panic_exit+0x25/0x3f
0a7d7cd4:  [<0807b5d5>] atomic_notifier_call_chain+0x1d/0x33
0a7d7cf4:  [<0807048f>] panic+0x4c/0xcf
0a7d7d10:  [<081724cd>] xfs_hex_dump+0x0/0x7
0a7d7d1c:  [<08168e26>] xfs_vm_writepage+0x226/0x656
0a7d7dbc:  [<0809092f>] generic_writepages+0x164/0x27b
0a7d7e4c:  [<0816926c>] xfs_vm_writepages+0x16/0x18
0a7d7e5c:  [<08090a6a>] do_writepages+0x24/0x38
0a7d7e70:  [<080bbe8b>] __writeback_single_inode+0x16d/0x2de
0a7d7ebc:  [<080bc1ba>] sync_sb_inodes+0x1be/0x25c
0a7d7ef4:  [<080bc299>] writeback_inodes+0x41/0x6c
0a7d7f08:  [<080905b5>] background_writeout+0x66/0x93
0a7d7f54:  [<0809106a>] pdflush+0xca/0x154
0a7d7f88:  [<08080a83>] kthread+0xb6/0xe6
0a7d7fb4:  [<080663ee>] run_kernel_thread+0x37/0x41
0a7d7fe0:  [<0805acee>] new_thread_handler+0x64/0x8b
0a7d7ffc:  [<a55a5a5a>] 0xa55a5a5a

On Mon, Aug 30, 2010 at 4:47 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Mike Gao wrote:
> > xfs_vm_writepage
> > {
> >                /*
> > * A hole may still be marked uptodate because discard_buffer
> > * leaves the flag set.
> > */
> > if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
> > ASSERT(!buffer_dirty(bh));
> > imap_valid = 0;
> > continue;
> > }
> > }
> >
> > I met this case that buffer is marked as dirty which make assert failed.
> > What does this mean and what I can do with it?
>
> You can report it here, with more information on what load you were
> running,
> and the full backtrace that the ASSERT generated... thanks!
>
> And it means that we think we are in a hole, but the buffer for
> that hole is marked dirty, which we did not expect ...
>
> The change went in with this commit:
>
> 3d9b02e3c76531687ab5314e0edf266256f13c2d xfs: fix corruption case for block
> size < page size
>
> which was attempting to fix a very specific file corruption case.
>
> What kernel are you running on?
>
> What block size are you using?  (xfs_info will tell you)
>
> Thanks,
> -Eric
>
> > Thanks very much,
> > Mike
> >
> >
> > ------------------------------------------------------------------------
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--001636310673b21339048f125e78
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks very much for help. The kernel is pretty old, 2.6.19 but the xfs is =
pretty new.<div>the block size is 512 and use mmap for test with write and =
read compare. (xfstest 074).</div><div><br></div><div>If I ignored this ASS=
ERT(comment out), the test will failed. I guess because some pages never wr=
itten to disk.<br>
<br></div><div><div>Assertion failed: !buffer_dirty(bh), file: fs/xfs/linux=
-2.6/xfs_aops.c, line: 1399</div><div>BUG: failure at fs/xfs/support/debug.=
c:108/assfail()!</div><div>Kernel panic - not syncing: BUG!</div><div>=A0</=
div>
<div>EIP: 0073:[&lt;b76f5424&gt;] CPU: 0 Not tainted ESP: 007b:b75a6fa8 EFL=
AGS: 00000246</div><div>=A0=A0 =A0Not tainted</div><div>EAX: 00000000 EBX: =
00000e97 ECX: 00000013 EDX: 00000e97</div><div>ESI: 00000e93 EDI: 00000011 =
EBP: b75a6fc4 DS: 007b ES: 007b</div>
<div>0a7d7c94: =A0[&lt;0806bd41&gt;] show_regs+0xc5/0xca</div><div>0a7d7cc0=
: =A0[&lt;0805a920&gt;] panic_exit+0x25/0x3f</div><div>0a7d7cd4: =A0[&lt;08=
07b5d5&gt;] atomic_notifier_call_chain+0x1d/0x33</div><div>0a7d7cf4: =A0[&l=
t;0807048f&gt;] panic+0x4c/0xcf</div>
<div>0a7d7d10: =A0[&lt;081724cd&gt;] xfs_hex_dump+0x0/0x7</div><div>0a7d7d1=
c: =A0[&lt;08168e26&gt;] xfs_vm_writepage+0x226/0x656</div><div>0a7d7dbc: =
=A0[&lt;0809092f&gt;] generic_writepages+0x164/0x27b</div><div>0a7d7e4c: =
=A0[&lt;0816926c&gt;] xfs_vm_writepages+0x16/0x18</div>
<div>0a7d7e5c: =A0[&lt;08090a6a&gt;] do_writepages+0x24/0x38</div><div>0a7d=
7e70: =A0[&lt;080bbe8b&gt;] __writeback_single_inode+0x16d/0x2de</div><div>=
0a7d7ebc: =A0[&lt;080bc1ba&gt;] sync_sb_inodes+0x1be/0x25c</div><div>0a7d7e=
f4: =A0[&lt;080bc299&gt;] writeback_inodes+0x41/0x6c</div>
<div>0a7d7f08: =A0[&lt;080905b5&gt;] background_writeout+0x66/0x93</div><di=
v>0a7d7f54: =A0[&lt;0809106a&gt;] pdflush+0xca/0x154</div><div>0a7d7f88: =
=A0[&lt;08080a83&gt;] kthread+0xb6/0xe6</div><div>0a7d7fb4: =A0[&lt;080663e=
e&gt;] run_kernel_thread+0x37/0x41</div>
<div>0a7d7fe0: =A0[&lt;0805acee&gt;] new_thread_handler+0x64/0x8b</div><div=
>0a7d7ffc: =A0[&lt;a55a5a5a&gt;] 0xa55a5a5a</div><div><br></div><div class=
=3D"gmail_quote">On Mon, Aug 30, 2010 at 4:47 PM, Eric Sandeen <span dir=3D=
"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt=
;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex;"><div><div></div><div class=3D"h5">Mike Gao =
wrote:<br>
&gt; xfs_vm_writepage<br>
&gt; {<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*<br>
&gt; * A hole may still be marked uptodate because discard_buffer<br>
&gt; * leaves the flag set.<br>
&gt; */<br>
&gt; if (!buffer_mapped(bh) &amp;&amp; buffer_uptodate(bh)) {<br>
&gt; ASSERT(!buffer_dirty(bh));<br>
&gt; imap_valid =3D 0;<br>
&gt; continue;<br>
&gt; }<br>
&gt; }<br>
&gt;<br>
&gt; I met this case that buffer is marked as dirty which make assert faile=
d.<br>
&gt; What does this mean and what I can do with it?<br>
<br>
</div></div>You can report it here, with more information on what load you =
were running,<br>
and the full backtrace that the ASSERT generated... thanks!<br>
<br>
And it means that we think we are in a hole, but the buffer for<br>
that hole is marked dirty, which we did not expect ...<br>
<br>
The change went in with this commit:<br>
<br>
3d9b02e3c76531687ab5314e0edf266256f13c2d xfs: fix corruption case for block=
 size &lt; page size<br>
<br>
which was attempting to fix a very specific file corruption case.<br>
<br>
What kernel are you running on?<br>
<br>
What block size are you using? =A0(xfs_info will tell you)<br>
<br>
Thanks,<br>
-Eric<br>
<br>
&gt; Thanks very much,<br>
&gt; Mike<br>
&gt;<br>
&gt;<br>
&gt; ----------------------------------------------------------------------=
--<br>
&gt;<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</blockquote></div><br></div>

--001636310673b21339048f125e78--


--===============2025509688381697963==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2025509688381697963==--
