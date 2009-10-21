Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9LHUi3R016689 for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 12:30:44 -0500
Received: from mail-px0-f171.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7294B34B1D0
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 10:32:17 -0700 (PDT)
Received: from mail-px0-f171.google.com (mail-px0-f171.google.com
	[209.85.216.171]) by cuda.sgi.com with ESMTP id
	qGArRMltCzBPnTuH for <xfs@oss.sgi.com>;
	Wed, 21 Oct 2009 10:32:17 -0700 (PDT)
Received: by pxi1 with SMTP id 1so2416955pxi.33
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 10:32:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ADF2EE8.6010700@sandeen.net>
References: <c2dcdfa40910202307m77a9d7c5lf18e278a9ebae08e@mail.gmail.com>
	<4ADF2EE8.6010700@sandeen.net>
Date: Wed, 21 Oct 2009 23:02:16 +0530
Message-ID: <c2dcdfa40910211032y5b1d2cd8l418491327d24b87b@mail.gmail.com>
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 1992 of file
	fs/xfs/xfs_da_btree.c
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0313618089775734209=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "sandeen-xfs@sandeen.net" <sandeen-xfs@sandeen.net>, "p.mironchik@velesys.com" <p.mironchik@velesys.com>, "hch@xfs.org" <hch@xfs.org>, xfs@oss.sgi.com

--===============0313618089775734209==
Content-Type: multipart/alternative; boundary=000e0cd2960c3189750476755cbd

--000e0cd2960c3189750476755cbd
Content-Type: text/plain; charset=ISO-8859-1

Thanks Eric,

Yes, I am able to get this for the same Inode and Block number.

xfs_check reports error for dir inode 128 missing leaf entries..(exact
string I m missing), will provide you the details.

Using xfs_repair fixes the problem. But again the same operation leads to
the crash.
Even on a freshly formatted disk, I get this error.

Please let me know from where I can get this patch to try whether it fixes
for me or not.

Thanks & Regards,
Amit Sahrawat

On Wed, Oct 21, 2009 at 9:25 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Amit Sahrawat wrote:
> > Dear Eric,
> >
> >
> > I am facing an issue with file deletion in XFS. Every time, I perform a
> > remove operation the kernel crashes with the following prints.
> >
>
> Old kernel I'm afraid.  Which ABI are you using?
>
> I'd have to remind what's gone in since then, but at least this:
>
> commit ae23a5e87dbbf4657a82e1ff8ebc52ab50361c14
> Author: Eric Sandeen <sandeen@sandeen.net>
> Date:   Mon Jun 23 13:23:32 2008 +1000
>
>    [XFS] Pack some shortform dir2 structures for the ARM old ABI
>    architecture.
>
>    This should fix the longstanding issues with xfs and old ABI arm boxes,
>    which lead to various asserts and xfs shutdowns, and for which an
>    (incorrect) patch has been floating around for years.
>
>    I've verified this patch by comparing the on-disk structure layouts
> using
>    pahole from the dwarves package, as well as running through a bit of
> xfsqa
>    under qemu-arm, modified so that the check/repair phase after each test
>    actually executes check/repair from the x86 host, on the filesystem
>    populated by the arm emulator. Thus far it all looks good.
>
>    There are 2 other structures with extra padding at the end, but they
> don't
>    seem to cause trouble. I suppose they could be packed as well:
>    xfs_dir2_data_unused_t and xfs_dir2_sf_t.
>
>    Note that userspace needs a similar treatment, and any filesystems which
>    were running with the previous rogue "fix" will now see corruption
> (either
>    in the kernel, or during xfs_repair) with this fix properly in place; it
>    may be worth teaching xfs_repair to identify and fix that specific
> issue.
>
>    SGI-PV: 982930
>
>    SGI-Modid: xfs-linux-melb:xfs-kern:31280a
>
>    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>    Signed-off-by: Tim Shimmin <tes@sgi.com>
>    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
>
> comes to mind.
>
> But, do you always get an error on the same dir & block nr?  Does an
> xfs_repair fix it?  Maybe it's just plain ol' corruption.
>
> -Eric
>
> > # rm -rf 1* 2* 3* 4*
> > xfs_da_do_buf: bno 16777216
> > dir: inode 128
> > Filesystem "sda1": XFS internal error xfs_da_do_buf(1) at line 1992 of
> > file fs/xfs/xfs_da_btree.c.  Caller 0xc011d2e4
> > [<c0022618>] (dump_stack+0x0/0x14) from [<c0129b2c>]
> > (xfs_error_report+0x54/0x64)
> > [<c0129ad8>] (xfs_error_report+0x0/0x64) from [<c011cea0>]
> > (xfs_da_do_buf+0x334/0x6ec)
> > [<c011cb6c>] (xfs_da_do_buf+0x0/0x6ec) from [<c011d2e4>]
> > (xfs_da_read_buf+0x34/0x3c)
> > [<c011d2b0>] (xfs_da_read_buf+0x0/0x3c) from [<c0126030>]
> > (xfs_dir2_node_removename+0x278/0x500)
> > [<c0125db8>] (xfs_dir2_node_removename+0x0/0x500) from [<c0120760>]
> > (xfs_dir_removename+0x100/0x10c)
> > [<c0120660>] (xfs_dir_removename+0x0/0x10c) from [<c0151be0>]
> > (xfs_remove+0x280/0x424)
> >  r6 = 00000000  r5 = 00000000  r4 = 0000357C
> > [<c0151960>] (xfs_remove+0x0/0x424) from [<c015c3a0>]
> > (xfs_vn_unlink+0x30/0x60)
> > [<c015c370>] (xfs_vn_unlink+0x0/0x60) from [<c0091c58>]
> > (vfs_unlink+0x70/0xac)
> >  r7 = C3E79000  r6 = C3E5AE58  r5 = C4122EB8  r4 = 00000000
> > [<c0091be8>] (vfs_unlink+0x0/0xac) from [<c0093fbc>]
> > (do_unlinkat+0xcc/0x14c)
> >  r6 = C4123D78  r5 = C4122EB8  r4 = 00000000
> > [<c0093ef0>] (do_unlinkat+0x0/0x14c) from [<c0094054>]
> > (sys_unlink+0x18/0x1c)
> >  r7 = 0000000A  r6 = 0000000C  r5 = 00000008  r4 = BECE6A2B
> > [<c009403c>] (sys_unlink+0x0/0x1c) from [<c001de40>]
> > (ret_fast_syscall+0x0/0x2c)
> >
> > *I am using kernel version - 2.6.18.1
> > Platform - ARM
> > *
> > I have searched a lot on this issue, but no solution is available. In
> > the FAQS it is mentioned that it's been fixed 2.6.17.7 onwards.
> > But, i keep getting this issue frequently almost every time I do this
> > operation .
> >
> > Please provide me any help to sort this issue.
> >
> > Thanks & Regards,
> > Amit Sahrawat
> >
>
>

--000e0cd2960c3189750476755cbd
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks Eric,<br>=A0<br>Yes, I am able to get this for the same Inode and Bl=
ock number.<br>=A0<br>xfs_check reports error for dir inode 128 missing lea=
f entries..(exact string I m missing), will provide you the details.<br>=A0=
<br>
Using xfs_repair fixes the problem. But again the same operation leads to t=
he crash.<br>Even on a freshly formatted disk, I get this error.<br>=A0<br>=
Please let me know from where I can get this patch to try whether it fixes =
for me or not.<br>
=A0<br>Thanks &amp; Regards,<br>Amit Sahrawat<br><br>
<div class=3D"gmail_quote">On Wed, Oct 21, 2009 at 9:25 PM, Eric Sandeen <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.=
net</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div class=3D"im">Amit Sahrawat wrote:<br>&gt; Dear Eric,<br>&gt;<br>&gt;<b=
r>&gt; I am facing an issue with file deletion in XFS. Every time, I perfor=
m a<br>&gt; remove operation the kernel crashes with the following prints.<=
br>
&gt;<br><br></div>Old kernel I&#39;m afraid. =A0Which ABI are you using?<br=
><br>I&#39;d have to remind what&#39;s gone in since then, but at least thi=
s:<br><br>commit ae23a5e87dbbf4657a82e1ff8ebc52ab50361c14<br>Author: Eric S=
andeen &lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a>&g=
t;<br>
Date: =A0 Mon Jun 23 13:23:32 2008 +1000<br><br>=A0 =A0[XFS] Pack some shor=
tform dir2 structures for the ARM old ABI<br>=A0 =A0architecture.<br><br>=
=A0 =A0This should fix the longstanding issues with xfs and old ABI arm box=
es,<br>=A0 =A0which lead to various asserts and xfs shutdowns, and for whic=
h an<br>
=A0 =A0(incorrect) patch has been floating around for years.<br><br>=A0 =A0=
I&#39;ve verified this patch by comparing the on-disk structure layouts<br>=
using<br>=A0 =A0pahole from the dwarves package, as well as running through=
 a bit of<br>
xfsqa<br>=A0 =A0under qemu-arm, modified so that the check/repair phase aft=
er each test<br>=A0 =A0actually executes check/repair from the x86 host, on=
 the filesystem<br>=A0 =A0populated by the arm emulator. Thus far it all lo=
oks good.<br>
<br>=A0 =A0There are 2 other structures with extra padding at the end, but =
they<br>don&#39;t<br>=A0 =A0seem to cause trouble. I suppose they could be =
packed as well:<br>=A0 =A0xfs_dir2_data_unused_t and xfs_dir2_sf_t.<br><br>=
=A0 =A0Note that userspace needs a similar treatment, and any filesystems w=
hich<br>
=A0 =A0were running with the previous rogue &quot;fix&quot; will now see co=
rruption<br>(either<br>=A0 =A0in the kernel, or during xfs_repair) with thi=
s fix properly in place; it<br>=A0 =A0may be worth teaching xfs_repair to i=
dentify and fix that specific<br>
issue.<br><br>=A0 =A0SGI-PV: 982930<br><br>=A0 =A0SGI-Modid: xfs-linux-melb=
:xfs-kern:31280a<br><br>=A0 =A0Signed-off-by: Eric Sandeen &lt;<a href=3D"m=
ailto:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt;<br>=A0 =A0Signed-off=
-by: Tim Shimmin &lt;<a href=3D"mailto:tes@sgi.com">tes@sgi.com</a>&gt;<br>
=A0 =A0Signed-off-by: Lachlan McIlroy &lt;<a href=3D"mailto:lachlan@sgi.com=
">lachlan@sgi.com</a>&gt;<br><br>comes to mind.<br><br>But, do you always g=
et an error on the same dir &amp; block nr? =A0Does an<br>xfs_repair fix it=
? =A0Maybe it&#39;s just plain ol&#39; corruption.<br>
<font color=3D"#888888"><br>-Eric<br></font>
<div>
<div></div>
<div class=3D"h5"><br>&gt; # rm -rf 1* 2* 3* 4*<br>&gt; xfs_da_do_buf: bno =
16777216<br>&gt; dir: inode 128<br>&gt; Filesystem &quot;sda1&quot;: XFS in=
ternal error xfs_da_do_buf(1) at line 1992 of<br>&gt; file fs/xfs/xfs_da_bt=
ree.c. =A0Caller 0xc011d2e4<br>
&gt; [&lt;c0022618&gt;] (dump_stack+0x0/0x14) from [&lt;c0129b2c&gt;]<br>&g=
t; (xfs_error_report+0x54/0x64)<br>&gt; [&lt;c0129ad8&gt;] (xfs_error_repor=
t+0x0/0x64) from [&lt;c011cea0&gt;]<br>&gt; (xfs_da_do_buf+0x334/0x6ec)<br>
&gt; [&lt;c011cb6c&gt;] (xfs_da_do_buf+0x0/0x6ec) from [&lt;c011d2e4&gt;]<b=
r>&gt; (xfs_da_read_buf+0x34/0x3c)<br>&gt; [&lt;c011d2b0&gt;] (xfs_da_read_=
buf+0x0/0x3c) from [&lt;c0126030&gt;]<br>&gt; (xfs_dir2_node_removename+0x2=
78/0x500)<br>
&gt; [&lt;c0125db8&gt;] (xfs_dir2_node_removename+0x0/0x500) from [&lt;c012=
0760&gt;]<br>&gt; (xfs_dir_removename+0x100/0x10c)<br>&gt; [&lt;c0120660&gt=
;] (xfs_dir_removename+0x0/0x10c) from [&lt;c0151be0&gt;]<br>&gt; (xfs_remo=
ve+0x280/0x424)<br>
&gt; =A0r6 =3D 00000000 =A0r5 =3D 00000000 =A0r4 =3D 0000357C<br>&gt; [&lt;=
c0151960&gt;] (xfs_remove+0x0/0x424) from [&lt;c015c3a0&gt;]<br>&gt; (xfs_v=
n_unlink+0x30/0x60)<br>&gt; [&lt;c015c370&gt;] (xfs_vn_unlink+0x0/0x60) fro=
m [&lt;c0091c58&gt;]<br>
&gt; (vfs_unlink+0x70/0xac)<br>&gt; =A0r7 =3D C3E79000 =A0r6 =3D C3E5AE58 =
=A0r5 =3D C4122EB8 =A0r4 =3D 00000000<br>&gt; [&lt;c0091be8&gt;] (vfs_unlin=
k+0x0/0xac) from [&lt;c0093fbc&gt;]<br>&gt; (do_unlinkat+0xcc/0x14c)<br>&gt=
; =A0r6 =3D C4123D78 =A0r5 =3D C4122EB8 =A0r4 =3D 00000000<br>
&gt; [&lt;c0093ef0&gt;] (do_unlinkat+0x0/0x14c) from [&lt;c0094054&gt;]<br>=
&gt; (sys_unlink+0x18/0x1c)<br>&gt; =A0r7 =3D 0000000A =A0r6 =3D 0000000C =
=A0r5 =3D 00000008 =A0r4 =3D BECE6A2B<br>&gt; [&lt;c009403c&gt;] (sys_unlin=
k+0x0/0x1c) from [&lt;c001de40&gt;]<br>
&gt; (ret_fast_syscall+0x0/0x2c)<br>&gt;<br>&gt; *I am using kernel version=
 - 2.6.18.1<br>&gt; Platform - ARM<br>&gt; *<br>&gt; I have searched a lot =
on this issue, but no solution is available. In<br>&gt; the FAQS it is ment=
ioned that it&#39;s been fixed 2.6.17.7 onwards.<br>
&gt; But, i keep getting this issue frequently almost every time I do this<=
br>&gt; operation .<br>&gt;<br>&gt; Please provide me any help to sort this=
 issue.<br>&gt;<br>&gt; Thanks &amp; Regards,<br>&gt; Amit Sahrawat<br>
&gt;<br><br></div></div></blockquote></div><br>

--000e0cd2960c3189750476755cbd--


--===============0313618089775734209==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0313618089775734209==--
