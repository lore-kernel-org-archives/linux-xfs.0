Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAB5d66b022433 for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 23:39:06 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 850F013AB0A6
	for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 21:40:34 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	Vo2qyFCM3IHBZuj5 for <xfs@oss.sgi.com>;
	Wed, 10 Nov 2010 21:40:34 -0800 (PST)
Received: by qyk30 with SMTP id 30so285846qyk.5
	for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 21:40:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik09-0udnrpAJ-mTxMx8iKZ5UTq-ucduQJOZkws@mail.gmail.com>
References: <AANLkTi=mLwQ0N_cErHzES1ZWvOa8jQspeYwKgn9sU4Jm@mail.gmail.com>
	<20101104125052.GA22429@infradead.org>
	<AANLkTinqK-HvuHPeaTgxJOJuWMfomP2C12G=uVcqhWdn@mail.gmail.com>
	<20101109140527.GA13041@infradead.org>
	<AANLkTik09-0udnrpAJ-mTxMx8iKZ5UTq-ucduQJOZkws@mail.gmail.com>
Date: Thu, 11 Nov 2010 11:10:33 +0530
Message-ID: <AANLkTik=-jiE5xeJCTQZnbf7AFk7Wzap5ToBDceqsEdH@mail.gmail.com>
Subject: Re: XFS mounting fails on MIPS
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6514333696457135282=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mips@linux-mips.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6514333696457135282==
Content-Type: multipart/alternative; boundary=0016363103059d42a60494c0695b

--0016363103059d42a60494c0695b
Content-Type: text/plain; charset=ISO-8859-1

I think mips folks agree with the change. I really wish to have there
comment.

I also wish to know do we really need fix in XFS for virtual indexed
architecture, I think its generic issue as many architecture now use VIVT or
VIPT caches. Do we want to say XFS is relatively unstable with virtual
indexed architecture ?


On Thu, Nov 11, 2010 at 10:27 AM, Ajeet Yadav <ajeet.yadav.77@gmail.com>wrote:

> Coming back to problem, I wish to know about this problem
> Linux XFS version : 2.6.34
> Architecure: MIPS
> I am getting the following error during mount.
>
> XFS mounting filesystem sda2
> Starting XFS recovery on filesystem: sda2 (logdev: internal)
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1518 of file
> fs/xfs/xfs_alloc.c.  Caller 0x801174a0
> Call Trace:
> [<800050bc>] dump_stack+0x8/0x34
> [<80115254>] xfs_free_ag_extent+0x128/0x7a8
> [<801174a0>] xfs_free_extent+0xa0/0xcc
> [<80155278>] xlog_recover_process_efi+0x15c/0x210
> [<801553cc>] xlog_recover_process_efis+0xa0/0x12c
> [<8015590c>] xlog_recover_finish+0x28/0xcc
> [<8015d4fc>] xfs_mountfs+0x4f0/0x5d0
> [<801758d8>] xfs_fs_fill_super+0x158/0x360
> [<8008b67c>] get_sb_bdev+0x11c/0x1c4
> [<801734e0>] xfs_fs_get_sb+0x20/0x2c
> [<80089cd0>] vfs_kern_mount+0x68/0xd0
> [<80089d9c>] do_kern_mount+0x54/0x118
> [<800a4e98>] do_mount+0x7f0/0x86c
> [<800a4fb0>] sys_mount+0x9c/0xf8
> [<80002124>] stack_done+0x20/0x3c
>
> Filesystem "sda2": XFS internal error xfs_trans_cancel at line 1161 of file
> fs/xfs/xfs_trans.c.  Caller 0x801552f8
>
> Call Trace:
> [<800050bc>] dump_stack+0x8/0x34
> [<801601f0>] xfs_trans_cancel+0x88/0x118
> [<801552f8>] xlog_recover_process_efi+0x1dc/0x210
> [<801553cc>] xlog_recover_process_efis+0xa0/0x12c
> [<8015590c>] xlog_recover_finish+0x28/0xcc
> [<8015d4fc>] xfs_mountfs+0x4f0/0x5d0
> [<801758d8>] xfs_fs_fill_super+0x158/0x360
> [<8008b67c>] get_sb_bdev+0x11c/0x1c4
> [<801734e0>] xfs_fs_get_sb+0x20/0x2c
> [<80089cd0>] vfs_kern_mount+0x68/0xd0
> [<80089d9c>] do_kern_mount+0x54/0x118
> [<800a4e98>] do_mount+0x7f0/0x86c
> [<800a4fb0>] sys_mount+0x9c/0xf8
> [<80002124>] stack_done+0x20/0x3c
>
> xfs_force_shutdown(sda2,0x8) called from line 1162 of file
> fs/xfs/xfs_trans.c.  Return address = 0x80160204
> Filesystem "sda2": Corruption of in-memory data detected.  Shutting down
> filesystem: sda2
> Please umount the filesystem, and rectify the problem(s)
> Failed to recover EFIs on filesystem: sda2
> XFS: log mount finish failed
>
> With Regards
> Ajeet Yadav
>
> On Tue, Nov 9, 2010 at 7:35 PM, Christoph Hellwig <hch@infradead.org>wrote:
>
>> Hi Ajeet,
>>
>> On Tue, Nov 09, 2010 at 04:43:04PM +0530, Ajeet Yadav wrote:
>> > True, its the same system and you were right it was cache VIPT cache
>> problem
>> > the cache hold the stale value even after xlog_bread() update the
>> buffer.
>> > I do not know whether its correct ways to resolve the problem, but the
>> > problem no longer occur.
>>
>> It seems like you more less re-implemented the vmap coherency hooks
>> inside XFS, hardcoded to the mips implementation.
>>
>> The actual helpers would looks something like:
>>
>> static inline void flush_kernel_vmap_range(void *addr, int size)
>> {
>>        dma_cache_inv(addr, size);
>> }
>>
>> static inline void invalidate_kernel_vmap_range(void *addr, int size)
>> {
>>        dma_cache_inv(addr, size);
>> }
>>
>> For some reason the kernel also expects flush_dcache_page to be
>> implemented by an architecture if we want to implement these two
>> (it's keyed off ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE).
>>
>> Can someone of the mips folks helps with this?
>>
>> The testcase is easy, mounting an xfs filesystem after an unclean
>> shutdown on a machine with virtually indexed caches.
>>
>>
>

--0016363103059d42a60494c0695b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I think mips folks agree with the change. I really wish to have there comme=
nt.<div><br></div><div>I also wish to know do we really need fix in XFS for=
 virtual indexed architecture, I think its generic issue as many architectu=
re now use VIVT or VIPT caches. Do we want to say XFS is relatively unstabl=
e with virtual indexed architecture ?</div>
<div>=A0</div><div><br><div class=3D"gmail_quote">On Thu, Nov 11, 2010 at 1=
0:27 AM, Ajeet Yadav <span dir=3D"ltr">&lt;<a href=3D"mailto:ajeet.yadav.77=
@gmail.com">ajeet.yadav.77@gmail.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex;">
Coming back to problem, I wish to know about this problem<div><span style=
=3D"font-family:arial, sans-serif;font-size:13px;border-collapse:collapse">=
<div class=3D"im"><div>Linux XFS version : 2.6.34</div><div>Architecure: MI=
PS</div>

<div>I am getting the following error during mount.</div><div>=A0</div></di=
v><div><div></div><div class=3D"h5"><div>XFS mounting filesystem sda2<br>St=
arting XFS recovery on filesystem: sda2 (logdev: internal)<br>XFS internal =
error XFS_WANT_CORRUPTED_GOTO at line 1518 of file fs/xfs/xfs_alloc.c.=A0 C=
aller 0x801174a0<br>

Call Trace:<br>[&lt;800050bc&gt;] dump_stack+0x8/0x34<br>[&lt;80115254&gt;]=
 xfs_free_ag_extent+0x128/0x7a8<br>[&lt;801174a0&gt;] xfs_free_extent+0xa0/=
0xcc<br>[&lt;80155278&gt;] xlog_recover_process_efi+0x15c/0x210<br>[&lt;801=
553cc&gt;] xlog_recover_process_efis+0xa0/0x12c<br>

[&lt;8015590c&gt;] xlog_recover_finish+0x28/0xcc<br>[&lt;8015d4fc&gt;] xfs_=
mountfs+0x4f0/0x5d0<br>[&lt;801758d8&gt;] xfs_fs_fill_super+0x158/0x360<br>=
[&lt;8008b67c&gt;] get_sb_bdev+0x11c/0x1c4<br>[&lt;801734e0&gt;] xfs_fs_get=
_sb+0x20/0x2c<br>

[&lt;80089cd0&gt;] vfs_kern_mount+0x68/0xd0<br>[&lt;80089d9c&gt;] do_kern_m=
ount+0x54/0x118<br>[&lt;800a4e98&gt;] do_mount+0x7f0/0x86c<br>[&lt;800a4fb0=
&gt;] sys_mount+0x9c/0xf8<br>[&lt;80002124&gt;] stack_done+0x20/0x3c<br>

=A0<br>Filesystem &quot;sda2&quot;: XFS internal error xfs_trans_cancel at =
line 1161 of file fs/xfs/xfs_trans.c.=A0 Caller 0x801552f8<br>=A0<br>Call T=
race:<br>[&lt;800050bc&gt;] dump_stack+0x8/0x34<br>[&lt;801601f0&gt;] xfs_t=
rans_cancel+0x88/0x118<br>

[&lt;801552f8&gt;] xlog_recover_process_efi+0x1dc/0x210<br>[&lt;801553cc&gt=
;] xlog_recover_process_efis+0xa0/0x12c<br>[&lt;8015590c&gt;] xlog_recover_=
finish+0x28/0xcc<br>[&lt;8015d4fc&gt;] xfs_mountfs+0x4f0/0x5d0<br>[&lt;8017=
58d8&gt;] xfs_fs_fill_super+0x158/0x360<br>

[&lt;8008b67c&gt;] get_sb_bdev+0x11c/0x1c4<br>[&lt;801734e0&gt;] xfs_fs_get=
_sb+0x20/0x2c<br>[&lt;80089cd0&gt;] vfs_kern_mount+0x68/0xd0<br>[&lt;80089d=
9c&gt;] do_kern_mount+0x54/0x118<br>[&lt;800a4e98&gt;] do_mount+0x7f0/0x86c=
<br>

[&lt;800a4fb0&gt;] sys_mount+0x9c/0xf8<br>[&lt;80002124&gt;] stack_done+0x2=
0/0x3c<br>=A0<br>xfs_force_shutdown(sda2,0x8) called from line 1162 of file=
 fs/xfs/xfs_trans.c.=A0 Return address =3D 0x80160204<br>Filesystem &quot;s=
da2&quot;: Corruption of in-memory data detected.=A0 Shutting down filesyst=
em: sda2<br>

Please umount the filesystem, and rectify the problem(s)<br>Failed to recov=
er EFIs on filesystem: sda2<br>XFS: log mount finish failed</div><div>=A0</=
div><div>With Regards</div><div>Ajeet Yadav</div></div></div></span><div>
<div></div><div class=3D"h5"><br><div class=3D"gmail_quote">
On Tue, Nov 9, 2010 at 7:35 PM, Christoph Hellwig <span dir=3D"ltr">&lt;<a =
href=3D"mailto:hch@infradead.org" target=3D"_blank">hch@infradead.org</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex">

Hi Ajeet,<br>
<div><br>
On Tue, Nov 09, 2010 at 04:43:04PM +0530, Ajeet Yadav wrote:<br>
&gt; True, its the same system and you were right it was cache VIPT cache p=
roblem<br>
&gt; the cache hold the stale value even after xlog_bread() update the buff=
er.<br>
&gt; I do not know whether its correct ways to resolve the problem, but the=
<br>
&gt; problem no longer occur.<br>
<br>
</div>It seems like you more less re-implemented the vmap coherency hooks<b=
r>
inside XFS, hardcoded to the mips implementation.<br>
<br>
The actual helpers would looks something like:<br>
<br>
static inline void flush_kernel_vmap_range(void *addr, int size)<br>
{<br>
 =A0 =A0 =A0 =A0dma_cache_inv(addr, size);<br>
}<br>
<br>
static inline void invalidate_kernel_vmap_range(void *addr, int size)<br>
{<br>
 =A0 =A0 =A0 =A0dma_cache_inv(addr, size);<br>
}<br>
<br>
For some reason the kernel also expects flush_dcache_page to be<br>
implemented by an architecture if we want to implement these two<br>
(it&#39;s keyed off ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE).<br>
<br>
Can someone of the mips folks helps with this?<br>
<br>
The testcase is easy, mounting an xfs filesystem after an unclean<br>
shutdown on a machine with virtually indexed caches.<br>
<br>
</blockquote></div><br></div></div></div>
</blockquote></div><br></div>

--0016363103059d42a60494c0695b--


--===============6514333696457135282==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6514333696457135282==--
