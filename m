Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBM6tsD5192917 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 00:55:54 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4093A216010
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 22:57:51 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id OyMrXI5LDFgJSgzp
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 22:57:51 -0800 (PST)
Received: by qwe5 with SMTP id 5so5222812qwe.26
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 22:57:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTin44EAmOtYrE4bd==ux4s11_QfDLVd7ROSf_+K3@mail.gmail.com>
References: <AANLkTikOcJA5a6u2YDXVGAEY0CqKiATTF02VeBsSKtU0@mail.gmail.com>
	<20101222060254.GH4907@dastard>
	<AANLkTin44EAmOtYrE4bd==ux4s11_QfDLVd7ROSf_+K3@mail.gmail.com>
Date: Wed, 22 Dec 2010 12:27:51 +0530
Message-ID: <AANLkTi=fxfTHSRTXXE=XjB+uXshVSsqK9dQwBWBH+YNj@mail.gmail.com>
Subject: Re: XFS hangs
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8262811633015000909=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============8262811633015000909==
Content-Type: multipart/alternative; boundary=0016e64c0c4e89c6b70497fa4523

--0016e64c0c4e89c6b70497fa4523
Content-Type: text/plain; charset=ISO-8859-1

I tried changing the locking in

*File :* xfs_sync.c
*Function :* int xfs_quiesce_data(struct xfs_mount *mp)
 /* write superblock and hoover up shutdown errors */
-  error = xfs_sync_fsdata(mp, SYNC_WAIT);
+ error = xfs_sync_fsdata(mp,SYNC_TRYLOCK);

This change was just out of curiousity, I am trying to reproduce the hang
with this, but didn't observe one in last many iterations.
Also, I am looking at possible side effects for the same change. Please let
me know about this.

To add to this, the code area in doubt according to me:
fs/xfs/xfs_buf_item.c
Function: void xfs_buf_iodone_callbacks( xfs_buf_t *bp), in this function,
 XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse); xfs_buf_error_relse is
registered as callback, which will unlock the lock held, but I really doubt
if the callback is getting called. Still analyzing this code area.

Please update me if this is the right direction.

Thanks & Regards,
Amit Sahrawat




On Wed, Dec 22, 2010 at 12:11 PM, Amit Sahrawat
<amit.sahrawat83@gmail.com>wrote:

> Extremely sorry for inconvenience, will take care about posting complete
> details in future.
>
> *Test Case : *
> cp Complex directory structure(large no of files and directories) to my XFS
> formatted partition:
> cp -ar /LibExe /usb/sda2
> Unplug the USB while the COPY is in progress.
>
> *Storage: *USB Flash, USB HDD (Both)
>
> *Kernel: *2.6.34
> *Target: *MIPS
> *LOGS:*
> usb 2-1: USB disconnect, address 7
> Device sda2, XFS metadata write error block 0x0 in sda2
> xfs_force_shutdown(sda2,0x1) called from line 1004 of file
> fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0x801cc294
> Filesystem "sda2": I/O Error Detected.  Shutting down filesystem: sda2
> Please umount the filesystem, and rectify the problem(s)
>
> Plug in USB Port1
> sd 7:0:0:0: [sdb] Attached SCSI disk
> Filesystem "sda2": xfs_log_force: error 5 returned.
> Filesystem "sda2": xfs_log_force: error 5 returned.
> Filesystem "sda2": xfs_log_force: error 5 returned.
> Filesystem "sda2": xfs_log_force: error 5 returned.
>   INFO: task usb_mount:1858 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> usb_mount        D [84a42440] 8032d62c     0  1858
> 1816                             (user thread)
> Stack : 00000107 00000000 85e7be80 00030002 84a425c8 8032d62c 7fffffff
> 84a42440
>         00000002 8496e200 00000001 00000000 85e7bf00 85e7bef8 7fa2f2e0
> 8032d62c
>         00000001 801d69a8 85e7bd40 801d6b34 85e7bd4c 8032dc6c 00000000
> 801dbc80
>         85e7be80 864315a8 8662c980 00000001 00000742 00000000 00000000
> 84b85800
>         85e7bd90 801d6cc0 7fffffff 84a42440 00000002 8032ee74 00000081
> 804158a0
>         ...
> Call Trace:
> [<8032d574>] __schedule+0x618/0x6b8 from[<8032d62c>] schedule+0x18/0x3c
> [<8032d62c>] schedule+0x18/0x3c from[<8032dc6c>]
> schedule_timeout+0x2c/0x1c0
> [<8032dc6c>] schedule_timeout+0x2c/0x1c0 from[<8032ee74>] __down+0x8c/0xdc
> [<8032ee74>] __down+0x8c/0xdc from[<8004500c>] down+0x40/0x88
> [<8004500c>] down+0x40/0x88 from[<801ca838>] xfs_buf_lock+0xcc/0x15c
> [<801ca838>] xfs_buf_lock+0xcc/0x15c from[<801b71a0>] xfs_getsb+0x38/0x54
> [<801b71a0>] xfs_getsb+0x38/0x54 from[<801d64a8>]
> xfs_sync_fsdata+0x7c/0x154
> [<801d64a8>] xfs_sync_fsdata+0x7c/0x154 from[<801d7284>]
> xfs_quiesce_data+0x34/0x60
> [<801d7284>] xfs_quiesce_data+0x34/0x60 from[<801d3514>]
> xfs_fs_sync_fs+0x30/0xec
> [<801d3514>] xfs_fs_sync_fs+0x30/0xec from[<800ba09c>]
> __fsync_super+0xa4/0xc8
> [<800ba09c>] __fsync_super+0xa4/0xc8 from[<800ba0d4>] fsync_super+0x14/0x28
> [<800ba0d4>] fsync_super+0x14/0x28 from[<800ba4a0>]
> generic_shutdown_super+0x34/0x190
> [<800ba4a0>] generic_shutdown_super+0x34/0x190 from[<800ba654>]
> kill_block_super+0x58/0x80
> [<800ba654>] kill_block_super+0x58/0x80 from[<800bac6c>]
> deactivate_super+0x7c/0x110
> [<800bac6c>] deactivate_super+0x7c/0x110 from[<800d2bbc>]
> sys_umount+0x310/0x358
> [<800d2bbc>] sys_umount+0x310/0x358 from[<8000ff44>] stack_done+0x20/0x3c
>
> -------------------------------------------------------------------------------------
> Filesystem "sda2": xfs_log_force: error 5 returned.
>
> Please let me know in case more information is needed.
>
> Thanks & Regards,
> Amit Sahrawat
>   On Wed, Dec 22, 2010 at 11:32 AM, Dave Chinner <david@fromorbit.com>wrote:
>
>>  On Wed, Dec 22, 2010 at 11:05:26AM +0530, Amit Sahrawat wrote:
>> > Hi,
>> > I am encountering hang of XFS filesystem, please find the logs as given
>> > below:
>> > INFO: task usb_mount:1858 blocked for more than 120 seconds.
>> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
>> message.
>> > usb_mount        D [84a42440] 8032d62c     0  1858
>> > 1816                             (user thread)
>> > Stack : 00000107 00000000 85e7be80 00030002 84a425c8 8032d62c 7fffffff
>> > 84a42440
>> >         00000002 8496e200 00000001 00000000 85e7bf00 85e7bef8 7fa2f2e0
>> > 8032d62c
>> >         00000001 801d69a8 85e7bd40 801d6b34 85e7bd4c 8032dc6c 00000000
>> > 801dbc80
>> >         85e7be80 864315a8 8662c980 00000001 00000742 00000000 00000000
>> > 84b85800
>> >         85e7bd90 801d6cc0 7fffffff 84a42440 00000002 8032ee74 00000081
>> > 804158a0
>> >         ...
>> > Call Trace:
>> > [<8032d574>] __schedule+0x618/0x6b8 from[<8032d62c>] schedule+0x18/0x3c
>> > [<8032d62c>] schedule+0x18/0x3c from[<8032dc6c>]
>> schedule_timeout+0x2c/0x1c0
>> > [<8032dc6c>] schedule_timeout+0x2c/0x1c0 from[<8032ee74>]
>> __down+0x8c/0xdc
>> > [<8032ee74>] __down+0x8c/0xdc from[<8004500c>] down+0x40/0x88
>> > [<8004500c>] down+0x40/0x88 from[<801ca838>] xfs_buf_lock+0xcc/0x15c
>> > [<801ca838>] xfs_buf_lock+0xcc/0x15c from[<801b71a0>]
>> xfs_getsb+0x38/0x54
>> > [<801b71a0>] xfs_getsb+0x38/0x54 from[<801d64a8>]
>> xfs_sync_fsdata+0x7c/0x154
>> > [<801d64a8>] xfs_sync_fsdata+0x7c/0x154 from[<801d7284>]
>> > xfs_quiesce_data+0x34/0x60
>> > [<801d7284>] xfs_quiesce_data+0x34/0x60 from[<801d3514>]
>> > xfs_fs_sync_fs+0x30/0xec
>> > [<801d3514>] xfs_fs_sync_fs+0x30/0xec from[<800ba09c>]
>> > __fsync_super+0xa4/0xc8
>> > [<800ba09c>] __fsync_super+0xa4/0xc8 from[<800ba0d4>]
>> fsync_super+0x14/0x28
>> > [<800ba0d4>] fsync_super+0x14/0x28 from[<800ba4a0>]
>> > generic_shutdown_super+0x34/0x190
>> > [<800ba4a0>] generic_shutdown_super+0x34/0x190 from[<800ba654>]
>> > kill_block_super+0x58/0x80
>> > [<800ba654>] kill_block_super+0x58/0x80 from[<800bac6c>]
>> > deactivate_super+0x7c/0x110
>> > [<800bac6c>] deactivate_super+0x7c/0x110 from[<800d2bbc>]
>> > sys_umount+0x310/0x358
>> > [<800d2bbc>] sys_umount+0x310/0x358 from[<8000ff44>]
>> stack_done+0x20/0x3c
>>
>> Please make sure you paste stack traces cleanly in your emails so we
>> can read them easily.
>> --
>> > After reboot it works fine, but during this state XFS does not works no
>> > operation.
>>
>> What kernel? What did you do to produce the error? What is the output
>> of "echo w > /proc/sysrq-trigger"? Do you have a repeatable test
>> case? What sort of storage are you using? Were there any IO errors
>> before the hang? etc, etc, etc....
>>
>> --
>>
>> For future reference, when you are reporting a problem you need to
>> be specific about what you were doing to cause the problem you are
>> reporting.  Describe your kernel, your storage, your test case, any
>> errors that occurred before the problem you are reporting, etc.
>>
>> We need this information to make any sense of your bug report, but
>> I'm getting tired of having to ask for it every time you report a
>> problem. The more information you put in your bug report, the more
>> likely we are to be able to help you. We don't have unlimited
>> amounts of time (or patience) to drag all the basic details of your
>> problem out of you over 3 or 4 emails, so including it up front will
>> help a lot....
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>
>

--0016e64c0c4e89c6b70497fa4523
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>I tried changing the locking in </div>
<div>=A0</div>
<div><strong>File :</strong> xfs_sync.c</div>
<div><strong>Function :</strong> int xfs_quiesce_data(struct xfs_mount=A0*m=
p)</div>
<div>=A0/* write superblock and hoover up shutdown errors */<br>- =A0error =
=3D xfs_sync_fsdata(mp, SYNC_WAIT);<br>+ error =3D xfs_sync_fsdata(mp,SYNC_=
TRYLOCK);</div>
<div>=A0</div>
<div>This change was just out of curiousity, I am trying to reproduce the h=
ang with this, but didn&#39;t observe one in last many iterations.</div>
<div>Also, I am looking at possible side effects for the same change. Pleas=
e let me know about this.</div>
<div>=A0</div>
<div>To add to this, the code area in doubt according to me:</div>
<div>fs/xfs/xfs_buf_item.c</div>
<div>Function: void xfs_buf_iodone_callbacks(=A0xfs_buf_t=A0*bp), in this f=
unction,</div>
<div>=A0XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse); xfs_buf_error_rels=
e is registered as callback, which will unlock the lock held, but I really =
doubt if the callback is getting called. Still analyzing this code area.</d=
iv>

<div>=A0</div>
<div>Please update me if this is the right direction.</div>
<div>=A0</div>
<div>Thanks &amp; Regards,</div>
<div>Amit Sahrawat</div>
<div>=A0</div>
<div><br><br>=A0</div>
<div class=3D"gmail_quote">On Wed, Dec 22, 2010 at 12:11 PM, Amit Sahrawat =
<span dir=3D"ltr">&lt;<a href=3D"mailto:amit.sahrawat83@gmail.com">amit.sah=
rawat83@gmail.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>Extremely sorry for inconvenience, will take care about posting comple=
te details in future.</div>
<div>=A0</div>
<div><strong>Test Case : </strong></div>
<div>cp Complex directory structure(large no of files and directories)=A0to=
 my XFS formatted partition:</div>
<div>cp -ar /LibExe /usb/sda2</div>
<div>Unplug the USB while the COPY is in progress.</div>
<div>=A0</div>
<div><strong>Storage: </strong>USB Flash, USB HDD (Both)</div>
<div>=A0</div>
<div><strong>Kernel: </strong>2.6.34</div>
<div><strong>Target: </strong>MIPS</div>
<div><strong>LOGS:</strong></div>
<div>usb 2-1: USB disconnect, address 7<br>Device sda2, XFS metadata write =
error block 0x0 in sda2<br>xfs_force_shutdown(sda2,0x1) called from line 10=
04 of file fs/xfs/linux-2.6/xfs_buf.c.=A0 Return address =3D 0x801cc294<br>
Filesystem &quot;sda2&quot;: I/O Error Detected.=A0 Shutting down filesyste=
m: sda2<br>Please umount the filesystem, and rectify the problem(s)</div>
<div>=A0</div>
<div>Plug in USB Port1<br>sd 7:0:0:0: [sdb] Attached SCSI disk</div>
<div>Filesystem &quot;sda2&quot;: xfs_log_force: error 5 returned.</div>
<div>Filesystem &quot;sda2&quot;: xfs_log_force: error 5 returned.<br>Files=
ystem &quot;sda2&quot;: xfs_log_force: error 5 returned.</div>
<div>Filesystem &quot;sda2&quot;: xfs_log_force: error 5 returned.</div>
<div>
<div></div>
<div class=3D"h5">
<div>INFO: task usb_mount:1858 blocked for more than 120 seconds.<br>&quot;=
echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disables this mes=
sage.<br>usb_mount=A0=A0=A0=A0=A0=A0=A0 D [84a42440] 8032d62c=A0=A0=A0=A0 0=
=A0 1858=A0=A0 1816=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (user thread)<br>
Stack : 00000107 00000000 85e7be80 00030002 84a425c8 8032d62c 7fffffff 84a4=
2440<br>=A0=A0=A0=A0=A0=A0=A0 00000002 8496e200 00000001 00000000 85e7bf00 =
85e7bef8 7fa2f2e0 8032d62c<br>=A0=A0=A0=A0=A0=A0=A0 00000001 801d69a8 85e7b=
d40 801d6b34 85e7bd4c 8032dc6c 00000000 801dbc80<br>
=A0=A0=A0=A0=A0=A0=A0 85e7be80 864315a8 8662c980 00000001 00000742 00000000=
 00000000 84b85800<br>=A0=A0=A0=A0=A0=A0=A0 85e7bd90 801d6cc0 7fffffff 84a4=
2440 00000002 8032ee74 00000081 804158a0<br>=A0=A0=A0=A0=A0=A0=A0 ...<br>Ca=
ll Trace:<br>[&lt;8032d574&gt;] __schedule+0x618/0x6b8 from[&lt;8032d62c&gt=
;] schedule+0x18/0x3c<br>
[&lt;8032d62c&gt;] schedule+0x18/0x3c from[&lt;8032dc6c&gt;] schedule_timeo=
ut+0x2c/0x1c0<br>[&lt;8032dc6c&gt;] schedule_timeout+0x2c/0x1c0 from[&lt;80=
32ee74&gt;] __down+0x8c/0xdc<br>[&lt;8032ee74&gt;] __down+0x8c/0xdc from[&l=
t;8004500c&gt;] down+0x40/0x88<br>
[&lt;8004500c&gt;] down+0x40/0x88 from[&lt;801ca838&gt;] xfs_buf_lock+0xcc/=
0x15c<br>[&lt;801ca838&gt;] xfs_buf_lock+0xcc/0x15c from[&lt;801b71a0&gt;] =
xfs_getsb+0x38/0x54<br>[&lt;801b71a0&gt;] xfs_getsb+0x38/0x54 from[&lt;801d=
64a8&gt;] xfs_sync_fsdata+0x7c/0x154<br>
[&lt;801d64a8&gt;] xfs_sync_fsdata+0x7c/0x154 from[&lt;801d7284&gt;] xfs_qu=
iesce_data+0x34/0x60<br>[&lt;801d7284&gt;] xfs_quiesce_data+0x34/0x60 from[=
&lt;801d3514&gt;] xfs_fs_sync_fs+0x30/0xec<br>[&lt;801d3514&gt;] xfs_fs_syn=
c_fs+0x30/0xec from[&lt;800ba09c&gt;] __fsync_super+0xa4/0xc8<br>
[&lt;800ba09c&gt;] __fsync_super+0xa4/0xc8 from[&lt;800ba0d4&gt;] fsync_sup=
er+0x14/0x28<br>[&lt;800ba0d4&gt;] fsync_super+0x14/0x28 from[&lt;800ba4a0&=
gt;] generic_shutdown_super+0x34/0x190<br>[&lt;800ba4a0&gt;] generic_shutdo=
wn_super+0x34/0x190 from[&lt;800ba654&gt;] kill_block_super+0x58/0x80<br>
[&lt;800ba654&gt;] kill_block_super+0x58/0x80 from[&lt;800bac6c&gt;] deacti=
vate_super+0x7c/0x110<br>[&lt;800bac6c&gt;] deactivate_super+0x7c/0x110 fro=
m[&lt;800d2bbc&gt;] sys_umount+0x310/0x358<br>[&lt;800d2bbc&gt;] sys_umount=
+0x310/0x358 from[&lt;8000ff44&gt;] stack_done+0x20/0x3c</div>
</div></div>
<div>----------------------------------------------------------------------=
---------------<br>Filesystem &quot;sda2&quot;: xfs_log_force: error 5 retu=
rned.</div>
<div><br>Please let me know in case more information is needed.</div>
<div>=A0</div>
<div>Thanks &amp; Regards,</div>
<div>Amit Sahrawat<font color=3D"#888888"><br></font></div>
<div>
<div></div>
<div class=3D"h5">
<div class=3D"gmail_quote">On Wed, Dec 22, 2010 at 11:32 AM, Dave Chinner <=
span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blan=
k">david@fromorbit.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>
<div></div>
<div>On Wed, Dec 22, 2010 at 11:05:26AM +0530, Amit Sahrawat wrote:<br>&gt;=
 Hi,<br>&gt; I am encountering hang of XFS filesystem, please find the logs=
 as given<br>&gt; below:<br>&gt; INFO: task usb_mount:1858 blocked for more=
 than 120 seconds.<br>
&gt; &quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disabl=
es this message.<br>&gt; usb_mount =A0 =A0 =A0 =A0D [84a42440] 8032d62c =A0=
 =A0 0 =A01858<br>&gt; 1816 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 (user thread)<br>&gt; Stack : 00000107 00000000 85e7be80 00030002 =
84a425c8 8032d62c 7fffffff<br>
&gt; 84a42440<br>&gt; =A0 =A0 =A0 =A0 00000002 8496e200 00000001 00000000 8=
5e7bf00 85e7bef8 7fa2f2e0<br>&gt; 8032d62c<br>&gt; =A0 =A0 =A0 =A0 00000001=
 801d69a8 85e7bd40 801d6b34 85e7bd4c 8032dc6c 00000000<br>&gt; 801dbc80<br>=
&gt; =A0 =A0 =A0 =A0 85e7be80 864315a8 8662c980 00000001 00000742 00000000 =
00000000<br>
&gt; 84b85800<br>&gt; =A0 =A0 =A0 =A0 85e7bd90 801d6cc0 7fffffff 84a42440 0=
0000002 8032ee74 00000081<br>&gt; 804158a0<br>&gt; =A0 =A0 =A0 =A0 ...<br>&=
gt; Call Trace:<br>&gt; [&lt;8032d574&gt;] __schedule+0x618/0x6b8 from[&lt;=
8032d62c&gt;] schedule+0x18/0x3c<br>
&gt; [&lt;8032d62c&gt;] schedule+0x18/0x3c from[&lt;8032dc6c&gt;] schedule_=
timeout+0x2c/0x1c0<br>&gt; [&lt;8032dc6c&gt;] schedule_timeout+0x2c/0x1c0 f=
rom[&lt;8032ee74&gt;] __down+0x8c/0xdc<br>&gt; [&lt;8032ee74&gt;] __down+0x=
8c/0xdc from[&lt;8004500c&gt;] down+0x40/0x88<br>
&gt; [&lt;8004500c&gt;] down+0x40/0x88 from[&lt;801ca838&gt;] xfs_buf_lock+=
0xcc/0x15c<br>&gt; [&lt;801ca838&gt;] xfs_buf_lock+0xcc/0x15c from[&lt;801b=
71a0&gt;] xfs_getsb+0x38/0x54<br>&gt; [&lt;801b71a0&gt;] xfs_getsb+0x38/0x5=
4 from[&lt;801d64a8&gt;] xfs_sync_fsdata+0x7c/0x154<br>
&gt; [&lt;801d64a8&gt;] xfs_sync_fsdata+0x7c/0x154 from[&lt;801d7284&gt;]<b=
r>&gt; xfs_quiesce_data+0x34/0x60<br>&gt; [&lt;801d7284&gt;] xfs_quiesce_da=
ta+0x34/0x60 from[&lt;801d3514&gt;]<br>&gt; xfs_fs_sync_fs+0x30/0xec<br>
&gt; [&lt;801d3514&gt;] xfs_fs_sync_fs+0x30/0xec from[&lt;800ba09c&gt;]<br>=
&gt; __fsync_super+0xa4/0xc8<br>&gt; [&lt;800ba09c&gt;] __fsync_super+0xa4/=
0xc8 from[&lt;800ba0d4&gt;] fsync_super+0x14/0x28<br>&gt; [&lt;800ba0d4&gt;=
] fsync_super+0x14/0x28 from[&lt;800ba4a0&gt;]<br>
&gt; generic_shutdown_super+0x34/0x190<br>&gt; [&lt;800ba4a0&gt;] generic_s=
hutdown_super+0x34/0x190 from[&lt;800ba654&gt;]<br>&gt; kill_block_super+0x=
58/0x80<br>&gt; [&lt;800ba654&gt;] kill_block_super+0x58/0x80 from[&lt;800b=
ac6c&gt;]<br>
&gt; deactivate_super+0x7c/0x110<br>&gt; [&lt;800bac6c&gt;] deactivate_supe=
r+0x7c/0x110 from[&lt;800d2bbc&gt;]<br>&gt; sys_umount+0x310/0x358<br>&gt; =
[&lt;800d2bbc&gt;] sys_umount+0x310/0x358 from[&lt;8000ff44&gt;] stack_done=
+0x20/0x3c<br>
<br></div></div>Please make sure you paste stack traces cleanly in your ema=
ils so we<br>can read them easily.<br>
<div>--<br>&gt; After reboot it works fine, but during this state XFS does =
not works no<br>&gt; operation.<br><br></div>What kernel? What did you do t=
o produce the error? What is the output<br>of &quot;echo w &gt; /proc/sysrq=
-trigger&quot;? Do you have a repeatable test<br>
case? What sort of storage are you using? Were there any IO errors<br>befor=
e the hang? etc, etc, etc....<br><br>--<br><br>For future reference, when y=
ou are reporting a problem you need to<br>be specific about what you were d=
oing to cause the problem you are<br>
reporting. =A0Describe your kernel, your storage, your test case, any<br>er=
rors that occurred before the problem you are reporting, etc.<br><br>We nee=
d this information to make any sense of your bug report, but<br>I&#39;m get=
ting tired of having to ask for it every time you report a<br>
problem. The more information you put in your bug report, the more<br>likel=
y we are to be able to help you. We don&#39;t have unlimited<br>amounts of =
time (or patience) to drag all the basic details of your<br>problem out of =
you over 3 or 4 emails, so including it up front will<br>
help a lot....<br><br>Cheers,<br><br>Dave.<br><font color=3D"#888888">--<br=
>Dave Chinner<br><a href=3D"mailto:david@fromorbit.com" target=3D"_blank">d=
avid@fromorbit.com</a><br></font></blockquote></div><br></div></div></block=
quote>
</div><br>

--0016e64c0c4e89c6b70497fa4523--


--===============8262811633015000909==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8262811633015000909==--
