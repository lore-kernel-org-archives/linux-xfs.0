Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7NF0Rwt194889 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 10:00:28 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8377F1E7A85A
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 08:00:25 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id 3qza6gqe8GcOwxKb
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 08:00:25 -0700 (PDT)
Received: by bkd1 with SMTP id 1so177854bkd.26
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 08:00:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110823094505.GA3162@dastard>
References: <CAPd5bUoWZdn6j1yH6BtYEAHh8_45mfoH+aDs45-tOj30N8Tvyg@mail.gmail.com>
	<20110823094505.GA3162@dastard>
From: Muhammad Hallaj Subery <hallajs@gmail.com>
Date: Tue, 23 Aug 2011 23:00:05 +0800
Message-ID: <CAPd5bUociVBL7ZMtfxjn+yJ6Xs3L+U+Xf0FZVdOjbYUkLnPUxw@mail.gmail.com>
Subject: Re: Ubuntu 10.04.2 (2.6.32-32-server) random kernel panic on xfs write
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7088459071221656974=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============7088459071221656974==
Content-Type: multipart/alternative; boundary=0015174c16cc9be66104ab2d7470

--0015174c16cc9be66104ab2d7470
Content-Type: text/plain; charset=UTF-8

Hi Dave,

  Thanks for reply. I've checked with Ubuntu and it seems that the fix is
currently in the upstream. Is there a workaround for this? Perhaps a mount
option?

On Tue, Aug 23, 2011 at 5:45 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Aug 23, 2011 at 09:46:23AM +0800, Muhammad Hallaj Subery wrote:
> > Hi all, I'm getting kernel panic on XFS write process by random. Could
> > someone point to me if this is a known issue and if there's a fix for it?
> > Attach is the log for it.
>
> > [922371.445221] BUG: unable to handle kernel paging request at
> 0000000389b14ad8
> > [922371.445730] IP: [<ffffffff81557980>] schedule+0x250/0x451
> > [922371.446093] PGD 17b7c6067 PUD 0
> > [922371.446436] Thread overran stack, or stack corrupted
>
> There's your problem - stack overflow.
>
> > [922371.446680] Oops: 0000 [#1] SMP
> > [922371.447021] last sysfs file:
> /sys/devices/system/cpu/cpu11/cache/index2/shared_cpu_map
> > [922371.447386] CPU 0
> > [922371.447585] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
> ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs reiserfs netconsole
> configfs xfs exportfs fbcon tileblit font bitblit softcursor dell_wmi dcdbas
> psmouse vga16fb joydev serio_raw vgastate power_meter bnx2 lp parport usbhid
> hid usb_storage mpt2sas scsi_transport_sas
> > [922371.452534] Pid: 803, comm: flush-8:0 Not tainted 2.6.32-32-server
> #62-Ubuntu PowerEdge R710
>
> 2.6.32 is pretty old now.
>
> > [922371.452913] RIP: 0010:[<ffffffff81557980>]  [<ffffffff81557980>]
> schedule+0x250/0x451
> > [922371.453372] RSP: 0018:ffff88022149a280  EFLAGS: 00010087
> > [922371.453616] RAX: 0000000081055cc3 RBX: ffff880009015f00 RCX:
> 0000000000000001
> > [922371.453958] RDX: ffff880222e8ae00 RSI: ffffffff817d5e00 RDI:
> ffff880222e8ae00
> > [922371.454299] RBP: ffff88022149a320 R08: 0000000000000000 R09:
> 0000000000000100
> > [922371.480427] R10: fffea2c9014dd580 R11: 0000000000000001 R12:
> 0000000000000000
> > [922371.506921] R13: ffffffff81570f40 R14: 00000001057fa251 R15:
> 00000000ffffffff
> > [922371.533337] FS:  0000000000000000(0000) GS:ffff880009000000(0000)
> knlGS:0000000000000000
> > [922371.560002] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > [922371.573587] CR2: 0000000389b14ad8 CR3: 00000001ad407000 CR4:
> 00000000000006f0
> > [922371.601358] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> > [922371.629838] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> > [922371.659001] Process flush-8:0 (pid: 803, threadinfo ffff88022149a000,
> task ffff880222e8ae00)
> > [922371.688450] Stack:
> > [922371.702807]  0000000000015f00 0000000000015f00 ffff880222e8b1d0
> ffff88022149bfd8
> > [922371.717663] <0> 0000000000015f00 ffff880222e8ae00 0000000000015f00
> ffff88022149bfd8
> > [922371.746297] <0> 0000000000015f00 ffff880222e8b1d0 0000000000015f00
> 0000000000015f00
> > [922371.788745] Call Trace:
> > [922371.802681]  [<ffffffff8155837d>] schedule_timeout+0x22d/0x300
> > [922371.816525]  [<ffffffff810f7a96>] ? find_lock_page+0x26/0x80
> > [922371.830133]  [<ffffffff810f803f>] ? find_or_create_page+0x3f/0xb0
> > [922371.843599]  [<ffffffff815592ae>] __down+0x7e/0xc0
> > [922371.856770]  [<ffffffff8108b021>] down+0x41/0x50
> > [922371.869659]  [<ffffffffa01621f3>] xfs_buf_lock+0x23/0x60 [xfs]
> > [922371.882403]  [<ffffffffa0162375>] _xfs_buf_find+0x145/0x240 [xfs]
> > [922371.894892]  [<ffffffffa01624d0>] xfs_buf_get_flags+0x60/0x170 [xfs]
> > [922371.907127]  [<ffffffffa01625f8>] xfs_buf_read_flags+0x18/0xa0 [xfs]
> > [922371.919262]  [<ffffffffa0157529>] xfs_trans_read_buf+0x1c9/0x300
> [xfs]
> > [922371.931032]  [<ffffffff810f6527>] ? unlock_page+0x27/0x30
> > [922371.942743]  [<ffffffffa0126e8e>] xfs_btree_read_buf_block+0x5e/0xc0
> [xfs]
> > [922371.954441]  [<ffffffffa0127584>]
> xfs_btree_lookup_get_block+0x84/0xf0 [xfs]
> > [922371.965886]  [<ffffffffa0127c27>] xfs_btree_lookup+0xd7/0x4a0 [xfs]
> > [922371.976976]  [<ffffffffa015d82a>] ? kmem_zone_zalloc+0x3a/0x50 [xfs]
> > [922371.987853]  [<ffffffffa0113dac>] ? xfs_allocbt_init_cursor+0x4c/0xc0
> [xfs]
> > [922371.998550]  [<ffffffffa0110d9c>] xfs_alloc_lookup_ge+0x1c/0x20 [xfs]
> > [922372.009119]  [<ffffffffa01127fb>]
> xfs_alloc_ag_vextent_near+0x5b/0x9a0 [xfs]
> > [922372.019540]  [<ffffffffa0113215>] xfs_alloc_ag_vextent+0xd5/0x130
> [xfs]
> > [922372.029747]  [<ffffffffa01139d8>] xfs_alloc_vextent+0x1f8/0x490 [xfs]
> > [922372.039761]  [<ffffffffa0121856>] xfs_bmap_btalloc+0x176/0x9f0 [xfs]
> > [922372.049512]  [<ffffffffa0122fb1>] xfs_bmap_alloc+0x21/0x40 [xfs]
> > [922372.059372]  [<ffffffffa0123b6f>] xfs_bmapi+0xb9f/0x1290 [xfs]
> > [922372.069136]  [<ffffffffa014b274>] ? xfs_log_reserve+0xd4/0xe0 [xfs]
> > [922372.078831]  [<ffffffffa0145055>]
> xfs_iomap_write_allocate+0x1c5/0x3c0 [xfs]
> > [922372.088471]  [<ffffffff8105f0fb>] ? enqueue_task_fair+0x5b/0xa0
> > [922372.098157]  [<ffffffffa0145dab>] xfs_iomap+0x2ab/0x2e0 [xfs]
> > [922372.107705]  [<ffffffffa015e45d>] xfs_map_blocks+0x2d/0x40 [xfs]
> > [922372.117076]  [<ffffffffa015f86a>] xfs_page_state_convert+0x3da/0x720
> [xfs]
> > [922372.126686]  [<ffffffff812baa3d>] ? radix_tree_delete+0x14d/0x2d0
> > [922372.136318]  [<ffffffffa015fd0a>] xfs_vm_writepage+0x7a/0x130 [xfs]
> > [922372.146051]  [<ffffffff8110f91e>] ? __dec_zone_page_state+0x2e/0x30
> > [922372.155947]  [<ffffffff81103d33>] pageout+0x123/0x280
> > [922372.165811]  [<ffffffff811042f3>] shrink_page_list+0x263/0x600
> > [922372.175760]  [<ffffffff8110499e>] shrink_inactive_list+0x30e/0x810
>
> And there's the cause - direct memroy reclaim doing writeback. XFS
> has aborted writeback in upstream kernels for quite some time for
> exactly this reason. i.e. even a dedicated writeback thread doesn't
> have enough stack space to do writeback from direct memory reclaim.
>
> Best to raise an Ubuntu bug and get them to backport the relevant
> fix:
>
> commit 070ecdca54dde9577d2697088e74e45568f48efb
> Author: Christoph Hellwig <hch@infradead.org>
> Date:   Thu Jun 3 16:22:29 2010 +1000
>
>    xfs: skip writeback from reclaim context
>
>    Allowing writeback from reclaim context causes massive problems with
> stack
>    overflows as we can call into the writeback code which tends to be a
> heavy
>    stack user both in the generic code and XFS from random contexts that
>    perform memory allocations.
>
>    Follow the example of btrfs (and in slightly different form ext4) and
> refuse
>    to write out data from reclaim context.  This issue should really be
> handled
>    by the VM so that we can tune better for this case, but until we get it
>    sorted out there we have to hack around this in each filesystem with a
>    complex writeback path.
>
>    Signed-off-by: Christoph Hellwig <hch@lst.de>
>    Reviewed-by: Dave Chinner <dchinner@redhat.com>
>
> Hope this helps.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0015174c16cc9be66104ab2d7470
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Dave,<div><br></div><div>=C2=A0 Thanks for reply. I&#39;ve checked with =
Ubuntu and it seems that the fix is currently in the upstream. Is there a w=
orkaround for this? Perhaps a mount option?<br><br><div class=3D"gmail_quot=
e">On Tue, Aug 23, 2011 at 5:45 PM, Dave Chinner <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a=
>&gt;</span> wrote:<br>


<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div><div></div><div>On Tue, Aug 23, 2011 at=
 09:46:23AM +0800, Muhammad Hallaj Subery wrote:<br>
&gt; Hi all, I&#39;m getting kernel panic on XFS write process by random. C=
ould<br>
&gt; someone point to me if this is a known issue and if there&#39;s a fix =
for it?<br>
&gt; Attach is the log for it.<br>
<br>
</div></div><div>&gt; [922371.445221] BUG: unable to handle kernel paging r=
equest at 0000000389b14ad8<br>
&gt; [922371.445730] IP: [&lt;ffffffff81557980&gt;] schedule+0x250/0x451<br=
>
&gt; [922371.446093] PGD 17b7c6067 PUD 0<br>
&gt; [922371.446436] Thread overran stack, or stack corrupted<br>
<br>
</div>There&#39;s your problem - stack overflow.<br>
<div><br>
&gt; [922371.446680] Oops: 0000 [#1] SMP<br>
&gt; [922371.447021] last sysfs file: /sys/devices/system/cpu/cpu11/cache/i=
ndex2/shared_cpu_map<br>
&gt; [922371.447386] CPU 0<br>
&gt; [922371.447585] Modules linked in: btrfs zlib_deflate crc32c libcrc32c=
 ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs reiserfs netconsole con=
figfs xfs exportfs fbcon tileblit font bitblit softcursor dell_wmi dcdbas p=
smouse vga16fb joydev serio_raw vgastate power_meter bnx2 lp parport usbhid=
 hid usb_storage mpt2sas scsi_transport_sas<br>



&gt; [922371.452534] Pid: 803, comm: flush-8:0 Not tainted 2.6.32-32-server=
 #62-Ubuntu PowerEdge R710<br>
<br>
</div>2.6.32 is pretty old now.<br>
<div><div></div><div><br>
&gt; [922371.452913] RIP: 0010:[&lt;ffffffff81557980&gt;] =C2=A0[&lt;ffffff=
ff81557980&gt;] schedule+0x250/0x451<br>
&gt; [922371.453372] RSP: 0018:ffff88022149a280 =C2=A0EFLAGS: 00010087<br>
&gt; [922371.453616] RAX: 0000000081055cc3 RBX: ffff880009015f00 RCX: 00000=
00000000001<br>
&gt; [922371.453958] RDX: ffff880222e8ae00 RSI: ffffffff817d5e00 RDI: ffff8=
80222e8ae00<br>
&gt; [922371.454299] RBP: ffff88022149a320 R08: 0000000000000000 R09: 00000=
00000000100<br>
&gt; [922371.480427] R10: fffea2c9014dd580 R11: 0000000000000001 R12: 00000=
00000000000<br>
&gt; [922371.506921] R13: ffffffff81570f40 R14: 00000001057fa251 R15: 00000=
000ffffffff<br>
&gt; [922371.533337] FS: =C2=A00000000000000000(0000) GS:ffff880009000000(0=
000) knlGS:0000000000000000<br>
&gt; [922371.560002] CS: =C2=A00010 DS: 0018 ES: 0018 CR0: 000000008005003b=
<br>
&gt; [922371.573587] CR2: 0000000389b14ad8 CR3: 00000001ad407000 CR4: 00000=
000000006f0<br>
&gt; [922371.601358] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000<br>
&gt; [922371.629838] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400<br>
&gt; [922371.659001] Process flush-8:0 (pid: 803, threadinfo ffff88022149a0=
00, task ffff880222e8ae00)<br>
&gt; [922371.688450] Stack:<br>
&gt; [922371.702807] =C2=A00000000000015f00 0000000000015f00 ffff880222e8b1=
d0 ffff88022149bfd8<br>
&gt; [922371.717663] &lt;0&gt; 0000000000015f00 ffff880222e8ae00 0000000000=
015f00 ffff88022149bfd8<br>
&gt; [922371.746297] &lt;0&gt; 0000000000015f00 ffff880222e8b1d0 0000000000=
015f00 0000000000015f00<br>
&gt; [922371.788745] Call Trace:<br>
&gt; [922371.802681] =C2=A0[&lt;ffffffff8155837d&gt;] schedule_timeout+0x22=
d/0x300<br>
&gt; [922371.816525] =C2=A0[&lt;ffffffff810f7a96&gt;] ? find_lock_page+0x26=
/0x80<br>
&gt; [922371.830133] =C2=A0[&lt;ffffffff810f803f&gt;] ? find_or_create_page=
+0x3f/0xb0<br>
&gt; [922371.843599] =C2=A0[&lt;ffffffff815592ae&gt;] __down+0x7e/0xc0<br>
&gt; [922371.856770] =C2=A0[&lt;ffffffff8108b021&gt;] down+0x41/0x50<br>
&gt; [922371.869659] =C2=A0[&lt;ffffffffa01621f3&gt;] xfs_buf_lock+0x23/0x6=
0 [xfs]<br>
&gt; [922371.882403] =C2=A0[&lt;ffffffffa0162375&gt;] _xfs_buf_find+0x145/0=
x240 [xfs]<br>
&gt; [922371.894892] =C2=A0[&lt;ffffffffa01624d0&gt;] xfs_buf_get_flags+0x6=
0/0x170 [xfs]<br>
&gt; [922371.907127] =C2=A0[&lt;ffffffffa01625f8&gt;] xfs_buf_read_flags+0x=
18/0xa0 [xfs]<br>
&gt; [922371.919262] =C2=A0[&lt;ffffffffa0157529&gt;] xfs_trans_read_buf+0x=
1c9/0x300 [xfs]<br>
&gt; [922371.931032] =C2=A0[&lt;ffffffff810f6527&gt;] ? unlock_page+0x27/0x=
30<br>
&gt; [922371.942743] =C2=A0[&lt;ffffffffa0126e8e&gt;] xfs_btree_read_buf_bl=
ock+0x5e/0xc0 [xfs]<br>
&gt; [922371.954441] =C2=A0[&lt;ffffffffa0127584&gt;] xfs_btree_lookup_get_=
block+0x84/0xf0 [xfs]<br>
&gt; [922371.965886] =C2=A0[&lt;ffffffffa0127c27&gt;] xfs_btree_lookup+0xd7=
/0x4a0 [xfs]<br>
&gt; [922371.976976] =C2=A0[&lt;ffffffffa015d82a&gt;] ? kmem_zone_zalloc+0x=
3a/0x50 [xfs]<br>
&gt; [922371.987853] =C2=A0[&lt;ffffffffa0113dac&gt;] ? xfs_allocbt_init_cu=
rsor+0x4c/0xc0 [xfs]<br>
&gt; [922371.998550] =C2=A0[&lt;ffffffffa0110d9c&gt;] xfs_alloc_lookup_ge+0=
x1c/0x20 [xfs]<br>
&gt; [922372.009119] =C2=A0[&lt;ffffffffa01127fb&gt;] xfs_alloc_ag_vextent_=
near+0x5b/0x9a0 [xfs]<br>
&gt; [922372.019540] =C2=A0[&lt;ffffffffa0113215&gt;] xfs_alloc_ag_vextent+=
0xd5/0x130 [xfs]<br>
&gt; [922372.029747] =C2=A0[&lt;ffffffffa01139d8&gt;] xfs_alloc_vextent+0x1=
f8/0x490 [xfs]<br>
&gt; [922372.039761] =C2=A0[&lt;ffffffffa0121856&gt;] xfs_bmap_btalloc+0x17=
6/0x9f0 [xfs]<br>
&gt; [922372.049512] =C2=A0[&lt;ffffffffa0122fb1&gt;] xfs_bmap_alloc+0x21/0=
x40 [xfs]<br>
&gt; [922372.059372] =C2=A0[&lt;ffffffffa0123b6f&gt;] xfs_bmapi+0xb9f/0x129=
0 [xfs]<br>
&gt; [922372.069136] =C2=A0[&lt;ffffffffa014b274&gt;] ? xfs_log_reserve+0xd=
4/0xe0 [xfs]<br>
&gt; [922372.078831] =C2=A0[&lt;ffffffffa0145055&gt;] xfs_iomap_write_alloc=
ate+0x1c5/0x3c0 [xfs]<br>
&gt; [922372.088471] =C2=A0[&lt;ffffffff8105f0fb&gt;] ? enqueue_task_fair+0=
x5b/0xa0<br>
&gt; [922372.098157] =C2=A0[&lt;ffffffffa0145dab&gt;] xfs_iomap+0x2ab/0x2e0=
 [xfs]<br>
&gt; [922372.107705] =C2=A0[&lt;ffffffffa015e45d&gt;] xfs_map_blocks+0x2d/0=
x40 [xfs]<br>
&gt; [922372.117076] =C2=A0[&lt;ffffffffa015f86a&gt;] xfs_page_state_conver=
t+0x3da/0x720 [xfs]<br>
&gt; [922372.126686] =C2=A0[&lt;ffffffff812baa3d&gt;] ? radix_tree_delete+0=
x14d/0x2d0<br>
&gt; [922372.136318] =C2=A0[&lt;ffffffffa015fd0a&gt;] xfs_vm_writepage+0x7a=
/0x130 [xfs]<br>
&gt; [922372.146051] =C2=A0[&lt;ffffffff8110f91e&gt;] ? __dec_zone_page_sta=
te+0x2e/0x30<br>
&gt; [922372.155947] =C2=A0[&lt;ffffffff81103d33&gt;] pageout+0x123/0x280<b=
r>
&gt; [922372.165811] =C2=A0[&lt;ffffffff811042f3&gt;] shrink_page_list+0x26=
3/0x600<br>
&gt; [922372.175760] =C2=A0[&lt;ffffffff8110499e&gt;] shrink_inactive_list+=
0x30e/0x810<br>
<br>
</div></div>And there&#39;s the cause - direct memroy reclaim doing writeba=
ck. XFS<br>
has aborted writeback in upstream kernels for quite some time for<br>
exactly this reason. i.e. even a dedicated writeback thread doesn&#39;t<br>
have enough stack space to do writeback from direct memory reclaim.<br>
<br>
Best to raise an Ubuntu bug and get them to backport the relevant<br>
fix:<br>
<br>
commit 070ecdca54dde9577d2697088e74e45568f48efb<br>
Author: Christoph Hellwig &lt;<a href=3D"mailto:hch@infradead.org" target=
=3D"_blank">hch@infradead.org</a>&gt;<br>
Date: =C2=A0 Thu Jun 3 16:22:29 2010 +1000<br>
<br>
 =C2=A0 =C2=A0xfs: skip writeback from reclaim context<br>
<br>
 =C2=A0 =C2=A0Allowing writeback from reclaim context causes massive proble=
ms with stack<br>
 =C2=A0 =C2=A0overflows as we can call into the writeback code which tends =
to be a heavy<br>
 =C2=A0 =C2=A0stack user both in the generic code and XFS from random conte=
xts that<br>
 =C2=A0 =C2=A0perform memory allocations.<br>
<br>
 =C2=A0 =C2=A0Follow the example of btrfs (and in slightly different form e=
xt4) and refuse<br>
 =C2=A0 =C2=A0to write out data from reclaim context. =C2=A0This issue shou=
ld really be handled<br>
 =C2=A0 =C2=A0by the VM so that we can tune better for this case, but until=
 we get it<br>
 =C2=A0 =C2=A0sorted out there we have to hack around this in each filesyst=
em with a<br>
 =C2=A0 =C2=A0complex writeback path.<br>
<br>
 =C2=A0 =C2=A0Signed-off-by: Christoph Hellwig &lt;<a href=3D"mailto:hch@ls=
t.de" target=3D"_blank">hch@lst.de</a>&gt;<br>
 =C2=A0 =C2=A0Reviewed-by: Dave Chinner &lt;<a href=3D"mailto:dchinner@redh=
at.com" target=3D"_blank">dchinner@redhat.com</a>&gt;<br>
<br>
Hope this helps.<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
</font></blockquote></div><br></div>

--0015174c16cc9be66104ab2d7470--


--===============7088459071221656974==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7088459071221656974==--
