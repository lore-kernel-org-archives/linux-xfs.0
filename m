Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9M98CHA076511 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 04:08:12 -0500
Received: from mail-pz0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F13852ADED
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 02:09:46 -0700 (PDT)
Received: from mail-pz0-f174.google.com (mail-pz0-f174.google.com
	[209.85.222.174]) by cuda.sgi.com with ESMTP id
	t0FutT9Fvg0TnDCW for <xfs@oss.sgi.com>;
	Thu, 22 Oct 2009 02:09:46 -0700 (PDT)
Received: by pzk4 with SMTP id 4so10048644pzk.32
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 02:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ADF4882.70106@sandeen.net>
References: <c2dcdfa40910202307m77a9d7c5lf18e278a9ebae08e@mail.gmail.com>
	<4ADF2EE8.6010700@sandeen.net>
	<c2dcdfa40910211032y5b1d2cd8l418491327d24b87b@mail.gmail.com>
	<4ADF4882.70106@sandeen.net>
Date: Thu, 22 Oct 2009 14:39:45 +0530
Message-ID: <c2dcdfa40910220209v781f6a76u31e349ea461bc10a@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============7085363735906985319=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============7085363735906985319==
Content-Type: multipart/alternative; boundary=000e0cd29a66e587d50476827473

--000e0cd29a66e587d50476827473
Content-Type: text/plain; charset=ISO-8859-1

Hi Eric,

This seems related with the directory Inodes.

I tried the changes mentioned in the patch, they didn't work for me.
As mine seems to be ARM with EABI.

When files are created at the Root . It reports Root Inode :128 at the crash
with bno:2

While suppose if another directory is created and Inode is 137
And then, rm -rf * in that directory
Crash would report error With this inode

xfs_da_do_buf: bno 8388631
dir: inode 137
Filesystem "sda4": XFS internal error xfs_da_do_buf(1) at line 1992 of file
fs/x
fs/xfs_da_btree.c.  Caller 0xc0118eb8
ry
rm: unable [<c0022618>] (dump_stack+0x0/0x14) from [<c0125700>]
(xfs_error_repor
t+0x54/0x64)
[<c01256ac>] (xfs_error_report+0x0/0x64) from [<c0118a74>]
(xfs_da_do_buf+0x334/
0x6ec)
[<c0118740>] (xfs_da_do_buf+0x0/0x6ec) from [<c0118eb8>]
(xfs_da_read_buf+0x34/0
x3c)
[<c0118e84>] (xfs_da_read_buf+0x0/0x3c) from [<c011b5c8>]
(xfs_da_node_lookup_in
t+0x70/0x318)
[<c011b558>] (xfs_da_node_lookup_int+0x0/0x318) from [<c01219d4>]
(xfs_dir2_node
_removename+0x48/0x500)
[<c012198c>] (xfs_dir2_node_removename+0x0/0x500) from [<c011c334>]
(xfs_dir_rem
ovename+0x100/0x10c)
[<c011c234>] (xfs_dir_removename+0x0/0x10c) from [<c014cde4>]
(xfs_remove+0x280/
0x424)
 r6 = 00000000  r5 = 00000000  r4 = 00003951
[<c014cb64>] (xfs_remove+0x0/0x424) from [<c0157044>]
(xfs_vn_unlink+0x30/0x60)
[<c0157014>] (xfs_vn_unlink+0x0/0x60) from [<c009175c>]
(vfs_unlink+0x70/0xac)
 r7 = C471C000  r6 = C43BF598  r5 = C395B3B8  r4 = 00000000
[<c00916ec>] (vfs_unlink+0x0/0xac) from [<c0093ac0>]
(do_unlinkat+0xcc/0x14c)
 r6 = C3968AD8  r5 = C395B3B8  r4 = 00000000
[<c00939f4>] (do_unlinkat+0x0/0x14c) from [<c0093b58>]
(sys_unlink+0x18/0x1c)
 r7 = 0000000A  r6 = 0000000C  r5 = 00000008  r4 = BEDCBC19
[<c0093b40>] (sys_unlink+0x0/0x1c) from [<c001de40>]
(ret_fast_syscall+0x0/0x2c)
to remove `5826'xfs_da_do_buf: bno 8388631
dir: inode 137

Checking this through xfs_check will show:
]# xfs_check /dev/sdb4
dir 128 block 8388609 extra leaf entry d5830 402
dir 128 block 8388609 extra leaf entry d5831 404
dir 128 block 8388609 extra leaf entry d5832 406
dir 128 block 8388609 extra leaf entry d5833 408
dir 128 block 8388609 extra leaf entry d5834 40a
dir 128 block 8388609 extra leaf entry d5835 40c
dir 128 block 8388609 extra leaf entry d5836 40e
dir 128 block 8388609 extra leaf entry d5837 410
...
...
dir 128 block 8388609 extra leaf entry ddab2 5fa
dir 128 block 8388609 extra leaf entry ddab3 5fc
dir 128 block 8388609 extra leaf entry ddab4 5fe
bad free block ent 1 is 65535 should be 0 for dir ino 128 block 16777216
bad free block ent 2 is 0 should be 65535 for dir ino 128 block 16777216
dir ino 128 missing leaf entry for d5a37/260
dir ino 128 missing leaf entry for d5a38/262
dir ino 128 missing leaf entry for d5a39/264
...
...

I tried checking the inode before and after corruption using xfs_db and
xfs_check
When I create files and check using xfs_check, no corruption is showed and
also xfs_db shows correct results for the inode.
While after the crash is observed, xfs_check show the errors I mentioned
above.
Also, the values for Inode using xfs_db differ from the ones I get after i
do xfs_repair -L on the device.


Can u get anything from the above mentioned log.

Thanks & Regards,
Amit Sahrawat


On Wed, Oct 21, 2009 at 11:14 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Amit Sahrawat wrote:
> > Thanks Eric,
> >
> > Yes, I am able to get this for the same Inode and Block number.
> >
> > xfs_check reports error for dir inode 128 missing leaf entries..(exact
> > string I m missing), will provide you the details.
> >
> > Using xfs_repair fixes the problem. But again the same operation leads
> > to the crash.
> > Even on a freshly formatted disk, I get this error.
> >
> > Please let me know from where I can get this patch to try whether it
> > fixes for me or not.
>
>
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=ae23a5e87dbbf4657a82e1ff8ebc52ab50361c14
>
> -Eric
>
>

--000e0cd29a66e587d50476827473
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Eric,<br><br>This seems related with the directory Inodes.<br><br>I trie=
d the changes mentioned in the patch, they didn&#39;t work for me.<br>As mi=
ne seems to be ARM with EABI.<br><br>When files are created at the Root . I=
t reports Root Inode :128 at the crash with bno:2<br>
<br>While suppose if another directory is created and Inode is 137<br>And t=
hen, rm -rf * in that directory<br>Crash would report error With this inode=
<br><br>xfs_da_do_buf: bno 8388631<br>dir: inode 137<br>Filesystem &quot;sd=
a4&quot;: XFS internal error xfs_da_do_buf(1) at line 1992 of file fs/x<br>
fs/xfs_da_btree.c.=A0 Caller 0xc0118eb8<br>ry<br>rm: unable [&lt;c0022618&g=
t;] (dump_stack+0x0/0x14) from [&lt;c0125700&gt;] (xfs_error_repor<br>t+0x5=
4/0x64)<br>[&lt;c01256ac&gt;] (xfs_error_report+0x0/0x64) from [&lt;c0118a7=
4&gt;] (xfs_da_do_buf+0x334/<br>
0x6ec)<br>[&lt;c0118740&gt;] (xfs_da_do_buf+0x0/0x6ec) from [&lt;c0118eb8&g=
t;] (xfs_da_read_buf+0x34/0<br>x3c)<br>[&lt;c0118e84&gt;] (xfs_da_read_buf+=
0x0/0x3c) from [&lt;c011b5c8&gt;] (xfs_da_node_lookup_in<br>t+0x70/0x318)<b=
r>
[&lt;c011b558&gt;] (xfs_da_node_lookup_int+0x0/0x318) from [&lt;c01219d4&gt=
;] (xfs_dir2_node<br>_removename+0x48/0x500)<br>[&lt;c012198c&gt;] (xfs_dir=
2_node_removename+0x0/0x500) from [&lt;c011c334&gt;] (xfs_dir_rem<br>ovenam=
e+0x100/0x10c)<br>
[&lt;c011c234&gt;] (xfs_dir_removename+0x0/0x10c) from [&lt;c014cde4&gt;] (=
xfs_remove+0x280/<br>0x424)<br>=A0r6 =3D 00000000=A0 r5 =3D 00000000=A0 r4 =
=3D 00003951<br>[&lt;c014cb64&gt;] (xfs_remove+0x0/0x424) from [&lt;c015704=
4&gt;] (xfs_vn_unlink+0x30/0x60)<br>
[&lt;c0157014&gt;] (xfs_vn_unlink+0x0/0x60) from [&lt;c009175c&gt;] (vfs_un=
link+0x70/0xac)<br>=A0r7 =3D C471C000=A0 r6 =3D C43BF598=A0 r5 =3D C395B3B8=
=A0 r4 =3D 00000000<br>[&lt;c00916ec&gt;] (vfs_unlink+0x0/0xac) from [&lt;c=
0093ac0&gt;] (do_unlinkat+0xcc/0x14c)<br>
=A0r6 =3D C3968AD8=A0 r5 =3D C395B3B8=A0 r4 =3D 00000000<br>[&lt;c00939f4&g=
t;] (do_unlinkat+0x0/0x14c) from [&lt;c0093b58&gt;] (sys_unlink+0x18/0x1c)<=
br>=A0r7 =3D 0000000A=A0 r6 =3D 0000000C=A0 r5 =3D 00000008=A0 r4 =3D BEDCB=
C19<br>[&lt;c0093b40&gt;] (sys_unlink+0x0/0x1c) from [&lt;c001de40&gt;] (re=
t_fast_syscall+0x0/0x2c)<br>
to remove `5826&#39;xfs_da_do_buf: bno 8388631<br>dir: inode 137<br><br>Che=
cking this through xfs_check will show:<br>]# xfs_check /dev/sdb4<br>dir 12=
8 block 8388609 extra leaf entry d5830 402<br>dir 128 block 8388609 extra l=
eaf entry d5831 404<br>
dir 128 block 8388609 extra leaf entry d5832 406<br>dir 128 block 8388609 e=
xtra leaf entry d5833 408<br>dir 128 block 8388609 extra leaf entry d5834 4=
0a<br>dir 128 block 8388609 extra leaf entry d5835 40c<br>dir 128 block 838=
8609 extra leaf entry d5836 40e<br>
dir 128 block 8388609 extra leaf entry d5837 410<br>...<br>...<br>dir 128 b=
lock 8388609 extra leaf entry ddab2 5fa<br>dir 128 block 8388609 extra leaf=
 entry ddab3 5fc<br>dir 128 block 8388609 extra leaf entry ddab4 5fe<br>
bad free block ent 1 is 65535 should be 0 for dir ino 128 block 16777216<br=
>bad free block ent 2 is 0 should be 65535 for dir ino 128 block 16777216<b=
r>dir ino 128 missing leaf entry for d5a37/260<br>dir ino 128 missing leaf =
entry for d5a38/262<br>
dir ino 128 missing leaf entry for d5a39/264<br>...<br>...<br><br>I tried c=
hecking the inode before and after corruption using xfs_db and xfs_check<br=
>When I create files and check using xfs_check, no corruption is showed and=
 also xfs_db shows correct results for the inode.<br>
While after the crash is observed, xfs_check show the errors I mentioned ab=
ove.<br>Also, the values for Inode using xfs_db differ from the ones I get =
after i do xfs_repair -L on the device.<br><br><br>Can u get anything from =
the above mentioned log.<br>
<br>Thanks &amp; Regards,<br>Amit Sahrawat<br><br><br><div class=3D"gmail_q=
uote">On Wed, Oct 21, 2009 at 11:14 PM, Eric Sandeen <span dir=3D"ltr">&lt;=
<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt;</span> w=
rote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class=3D"im"=
>Amit Sahrawat wrote:<br>
&gt; Thanks Eric,<br>
&gt;<br>
&gt; Yes, I am able to get this for the same Inode and Block number.<br>
&gt;<br>
&gt; xfs_check reports error for dir inode 128 missing leaf entries..(exact=
<br>
&gt; string I m missing), will provide you the details.<br>
&gt;<br>
&gt; Using xfs_repair fixes the problem. But again the same operation leads=
<br>
&gt; to the crash.<br>
&gt; Even on a freshly formatted disk, I get this error.<br>
&gt;<br>
&gt; Please let me know from where I can get this patch to try whether it<b=
r>
&gt; fixes for me or not.<br>
<br>
<br>
</div><a href=3D"http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux=
-2.6.git;a=3Dcommitdiff_plain;h=3Dae23a5e87dbbf4657a82e1ff8ebc52ab50361c14"=
 target=3D"_blank">http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/lin=
ux-2.6.git;a=3Dcommitdiff_plain;h=3Dae23a5e87dbbf4657a82e1ff8ebc52ab50361c1=
4</a><br>

<font color=3D"#888888"><br>
-Eric<br>
<br>
</font></blockquote></div><br>

--000e0cd29a66e587d50476827473--


--===============7085363735906985319==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7085363735906985319==--
