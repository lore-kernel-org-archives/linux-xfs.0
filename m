Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB44HfKa122616 for <xfs@oss.sgi.com>; Fri, 3 Dec 2010 22:17:42 -0600
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BD1314116E5
	for <xfs@oss.sgi.com>; Fri,  3 Dec 2010 20:19:25 -0800 (PST)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	nSDnb2NddA5jQy0O for <xfs@oss.sgi.com>;
	Fri, 03 Dec 2010 20:19:25 -0800 (PST)
Received: by qyk11 with SMTP id 11so1722683qyk.5
	for <xfs@oss.sgi.com>; Fri, 03 Dec 2010 20:19:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101202224506.GY16922@dastard>
References: <AANLkTi=7r8gV-cnBU9WNkn6kHz82qnUp8XD2dzAY+LF7@mail.gmail.com>
	<20101202224506.GY16922@dastard>
Date: Sat, 4 Dec 2010 09:49:25 +0530
Message-ID: <AANLkTimZt7vefTvg2XkzgUHjD3s8JD3dHLX_qbXpXrra@mail.gmail.com>
Subject: Re: XFS mount fail: XFS_WANT_CORRUPTED_GOTO fs/xfs/xfs_alloc.c
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0852677787454180745=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============0852677787454180745==
Content-Type: multipart/alternative; boundary=0015175cded4cc681904968df599

--0015175cded4cc681904968df599
Content-Type: text/plain; charset=ISO-8859-1

Our test case is automated:
1. Create large number of file of 6KB sizes ( 6KB is taken, we wanted to
increase journal load, and file size not in multiple of file system block
size)
2. Set target to reboot at random seconds seconds.
3. Next boot do "ls" of all files in XFS partition.
4. Remove all files in XFS.
5. Go back to step 1

The purpose of this test is to test journal and stability of XFS filestem.

Do you think, we should consider this test case ?

Other is when we should run xfs_repair ? because if mount fails and journal
contain dirty logs then xfs_repair does not run, we are forced to use (-L)
option but its description say that (-L) can corrupt the file system.

Other case even if xfs mount successfully, even in that case accessing some
files give IO input/ output error.

1. I recommend the following usage for xfs_repair so that we do not come
accross these problem
    Mount Success -> Umount -> run xfs_repair -> mount
    Mount fails -> try xfs_repair -> xfs_repair fails -> finally xfs_repair
-L -> mount

Adding above mount + xfs_repair procedure to script makes file system
stable. But other member of my team do not agree as it increases mount time.



On Fri, Dec 3, 2010 at 4:15 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Dec 02, 2010 at 12:31:30PM +0530, Ajeet Yadav wrote:
> > Dear all,
> > This is XFS fail mount log on linux 2.6.30.9
> >
> > XFS mounting filesystem sda2
> > Starting XFS recovery on filesystem: sda2 (logdev: internal)
> > XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1629 of file
> > fs/xfs/xfs_alloc.c.  Caller 0x80129658
> > Call Trace:
> > [<802dedc8>] dump_stack+0x8/0x34 from[<80127400>]
> > xfs_free_ag_extent+0x128/0x7ac
> > [<80127400>] xfs_free_ag_extent+0x128/0x7ac from[<80129658>]
> > xfs_free_extent+0xb8/0xe8
> > [<80129658>] xfs_free_extent+0xb8/0xe8 from[<80163978>]
> > xlog_recover_process_efi+0x160/0x214
> > [<80163978>] xlog_recover_process_efi+0x160/0x214 from[<80163ac4>]
> > xlog_recover_process_efis+0x98/0x11c
> > [<80163ac4>] xlog_recover_process_efis+0x98/0x11c from[<8016663c>]
> > xlog_recover_finish+0x28/0xdc
> > [<8016663c>] xlog_recover_finish+0x28/0xdc from[<8016aec0>]
> > xfs_mountfs+0x4d0/0x610
> > [<8016aec0>] xfs_mountfs+0x4d0/0x610 from[<80184434>]
> > xfs_fs_fill_super+0x1fc/0x418
> > [<80184434>] xfs_fs_fill_super+0x1fc/0x418 from[<800bae48>]
> > get_sb_bdev+0x11c/0x1c0
> > [<800bae48>] get_sb_bdev+0x11c/0x1c0 from[<80181f20>]
> > xfs_fs_get_sb+0x20/0x2c
> > [<80181f20>] xfs_fs_get_sb+0x20/0x2c from[<800b9424>]
> > vfs_kern_mount+0x68/0xd0
> > [<800b9424>] vfs_kern_mount+0x68/0xd0 from[<800b94f0>]
> > do_kern_mount+0x54/0x118
> > [<800b94f0>] do_kern_mount+0x54/0x118 from[<800d44e8>]
> do_mount+0x7b4/0x828
> > [<800d44e8>] do_mount+0x7b4/0x828 from[<800d45f8>] sys_mount+0x9c/0x194
> > [<800d45f8>] sys_mount+0x9c/0x194 from[<800102c4>] stack_done+0x20/0x3c
> >
> > Failed to recover EFIs on filesystem: sda2
> > XFS: log mount finish failed
>
> You corrupted a free space btree. Care to tell uswhat test you were
> running that caused this?  Did you pull the plug on the device
> during a copy again?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0015175cded4cc681904968df599
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Our test case is automated:<br>1. Create large number of file of 6KB sizes =
( 6KB is taken, we wanted to increase journal load, and file size not in mu=
ltiple of file system block size) <br>2. Set target to reboot at random sec=
onds seconds.<br>
3. Next boot do &quot;ls&quot; of all files in XFS partition.<br>4. Remove =
all files in XFS.<br>5. Go back to step 1<br><br>The purpose of this test i=
s to test journal and stability of XFS filestem.<br><br>Do you think, we sh=
ould consider this test case ?<br>
<br>Other is when we should run xfs_repair ? because if mount fails and jou=
rnal contain dirty logs then xfs_repair does not run, we are forced to use =
(-L) option but its description say that (-L) can corrupt the file system.<=
br>
<br>Other case even if xfs mount successfully, even in that case accessing =
some files give IO input/ output error.<br><br>1. I recommend the following=
 usage for xfs_repair so that we do not come accross these problem<br>=A0 =
=A0 Mount Success -&gt; Umount -&gt; run xfs_repair -&gt; mount<br>
=A0 =A0 Mount fails -&gt; try xfs_repair -&gt; xfs_repair fails -&gt; final=
ly xfs_repair -L -&gt; mount<br><br>Adding above mount + xfs_repair procedu=
re to script makes file system stable. But other member of my team do not a=
gree as it increases mount time.<br>
<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0=A0 =A0 <br><br><div class=3D"gmail_quote">On Fri, Dec 3, 2=
010 at 4:15 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@=
fromorbit.com">david@fromorbit.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 0pt 0.8ex; borde=
r-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;"><div><div></div><=
div class=3D"h5">On Thu, Dec 02, 2010 at 12:31:30PM +0530, Ajeet Yadav wrot=
e:<br>

&gt; Dear all,<br>
&gt; This is XFS fail mount log on linux 2.6.30.9<br>
&gt;<br>
&gt; XFS mounting filesystem sda2<br>
&gt; Starting XFS recovery on filesystem: sda2 (logdev: internal)<br>
&gt; XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1629 of file<br>
&gt; fs/xfs/xfs_alloc.c. =A0Caller 0x80129658<br>
&gt; Call Trace:<br>
&gt; [&lt;802dedc8&gt;] dump_stack+0x8/0x34 from[&lt;80127400&gt;]<br>
&gt; xfs_free_ag_extent+0x128/0x7ac<br>
&gt; [&lt;80127400&gt;] xfs_free_ag_extent+0x128/0x7ac from[&lt;80129658&gt=
;]<br>
&gt; xfs_free_extent+0xb8/0xe8<br>
&gt; [&lt;80129658&gt;] xfs_free_extent+0xb8/0xe8 from[&lt;80163978&gt;]<br=
>
&gt; xlog_recover_process_efi+0x160/0x214<br>
&gt; [&lt;80163978&gt;] xlog_recover_process_efi+0x160/0x214 from[&lt;80163=
ac4&gt;]<br>
&gt; xlog_recover_process_efis+0x98/0x11c<br>
&gt; [&lt;80163ac4&gt;] xlog_recover_process_efis+0x98/0x11c from[&lt;80166=
63c&gt;]<br>
&gt; xlog_recover_finish+0x28/0xdc<br>
&gt; [&lt;8016663c&gt;] xlog_recover_finish+0x28/0xdc from[&lt;8016aec0&gt;=
]<br>
&gt; xfs_mountfs+0x4d0/0x610<br>
&gt; [&lt;8016aec0&gt;] xfs_mountfs+0x4d0/0x610 from[&lt;80184434&gt;]<br>
&gt; xfs_fs_fill_super+0x1fc/0x418<br>
&gt; [&lt;80184434&gt;] xfs_fs_fill_super+0x1fc/0x418 from[&lt;800bae48&gt;=
]<br>
&gt; get_sb_bdev+0x11c/0x1c0<br>
&gt; [&lt;800bae48&gt;] get_sb_bdev+0x11c/0x1c0 from[&lt;80181f20&gt;]<br>
&gt; xfs_fs_get_sb+0x20/0x2c<br>
&gt; [&lt;80181f20&gt;] xfs_fs_get_sb+0x20/0x2c from[&lt;800b9424&gt;]<br>
&gt; vfs_kern_mount+0x68/0xd0<br>
&gt; [&lt;800b9424&gt;] vfs_kern_mount+0x68/0xd0 from[&lt;800b94f0&gt;]<br>
&gt; do_kern_mount+0x54/0x118<br>
&gt; [&lt;800b94f0&gt;] do_kern_mount+0x54/0x118 from[&lt;800d44e8&gt;] do_=
mount+0x7b4/0x828<br>
&gt; [&lt;800d44e8&gt;] do_mount+0x7b4/0x828 from[&lt;800d45f8&gt;] sys_mou=
nt+0x9c/0x194<br>
&gt; [&lt;800d45f8&gt;] sys_mount+0x9c/0x194 from[&lt;800102c4&gt;] stack_d=
one+0x20/0x3c<br>
&gt;<br>
&gt; Failed to recover EFIs on filesystem: sda2<br>
&gt; XFS: log mount finish failed<br>
<br>
</div></div>You corrupted a free space btree. Care to tell uswhat test you =
were<br>
running that caused this? =A0Did you pull the plug on the device<br>
during a copy again?<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></blockquote></div><br>

--0015175cded4cc681904968df599--


--===============0852677787454180745==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0852677787454180745==--
