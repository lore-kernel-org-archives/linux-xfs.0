Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBM9A8qi210107 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 03:10:08 -0600
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E20161473F5D
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 01:12:04 -0800 (PST)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	YFb2HIzmuDXiZHrg for <xfs@oss.sgi.com>;
	Wed, 22 Dec 2010 01:12:04 -0800 (PST)
Received: by qyj19 with SMTP id 19so6138359qyj.5
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 01:12:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012220904.56914@zmi.at>
References: <AANLkTikOcJA5a6u2YDXVGAEY0CqKiATTF02VeBsSKtU0@mail.gmail.com>
	<20101222060254.GH4907@dastard> <201012220904.56914@zmi.at>
Date: Wed, 22 Dec 2010 14:42:03 +0530
Message-ID: <AANLkTikZkcftqFoZRL=of6TNSiLToYdv=D_mxMMNUj1G@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============2676616471496601121=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============2676616471496601121==
Content-Type: multipart/alternative; boundary=0015175cb07e7cd73e0497fc2586

--0015175cb07e7cd73e0497fc2586
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

There seems to be a problem in posting - I already apologized and provided
complete details. I guess this was the first time, i missed on providing th=
e
test case.

Please refer my earlier post on the same issue:


Extremely sorry for inconvenience, will take care about posting complete
details in future.

Test Case :
cp Complex directory structure(large no of files and directories) to my XFS
formatted partition:
cp -ar /LibExe /usb/sda2
Unplug the USB while the COPY is in progress.

Storage: USB Flash, USB HDD (Both)

Kernel: 2.6.34
Target: MIPS
LOGS:
usb 2-1: USB disconnect, address 7
Device sda2, XFS metadata write error block 0x0 in sda2
xfs_force_shutdown(sda2,0x1) called from line 1004 of file
fs/xfs/linux-2.6/xfs_buf.c.  Return address =3D 0x801cc294
Filesystem "sda2": I/O Error Detected.  Shutting down filesystem: sda2
Please umount the filesystem, and rectify the problem(s)

Plug in USB Port1
sd 7:0:0:0: [sdb] Attached SCSI disk
Filesystem "sda2": xfs_log_force: error 5 returned.
Filesystem "sda2": xfs_log_force: error 5 returned.
Filesystem "sda2": xfs_log_force: error 5 returned.
Filesystem "sda2": xfs_log_force: error 5 returned.
- Show quoted text -
INFO: task usb_mount:1858 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
usb_mount        D [84a42440] 8032d62c     0  1858
1816                             (user thread)
Stack : 00000107 00000000 85e7be80 00030002 84a425c8 8032d62c 7fffffff
84a42440
        00000002 8496e200 00000001 00000000 85e7bf00 85e7bef8 7fa2f2e0
8032d62c
        00000001 801d69a8 85e7bd40 801d6b34 85e7bd4c 8032dc6c 00000000
801dbc80
        85e7be80 864315a8 8662c980 00000001 00000742 00000000 00000000
84b85800
        85e7bd90 801d6cc0 7fffffff 84a42440 00000002 8032ee74 00000081
804158a0
        ...
Call Trace:
[<8032d574>] __schedule+0x618/0x6b8 from[<8032d62c>] schedule+0x18/0x3c
[<8032d62c>] schedule+0x18/0x3c from[<8032dc6c>] schedule_timeout+0x2c/0x1c=
0
[<8032dc6c>] schedule_timeout+0x2c/0x1c0 from[<8032ee74>] __down+0x8c/0xdc
[<8032ee74>] __down+0x8c/0xdc from[<8004500c>] down+0x40/0x88
[<8004500c>] down+0x40/0x88 from[<801ca838>] xfs_buf_lock+0xcc/0x15c
[<801ca838>] xfs_buf_lock+0xcc/0x15c from[<801b71a0>] xfs_getsb+0x38/0x54
[<801b71a0>] xfs_getsb+0x38/0x54 from[<801d64a8>] xfs_sync_fsdata+0x7c/0x15=
4
[<801d64a8>] xfs_sync_fsdata+0x7c/0x154 from[<801d7284>]
xfs_quiesce_data+0x34/0x60
[<801d7284>] xfs_quiesce_data+0x34/0x60 from[<801d3514>]
xfs_fs_sync_fs+0x30/0xec
[<801d3514>] xfs_fs_sync_fs+0x30/0xec from[<800ba09c>]
__fsync_super+0xa4/0xc8
[<800ba09c>] __fsync_super+0xa4/0xc8 from[<800ba0d4>] fsync_super+0x14/0x28
[<800ba0d4>] fsync_super+0x14/0x28 from[<800ba4a0>]
generic_shutdown_super+0x34/0x190
[<800ba4a0>] generic_shutdown_super+0x34/0x190 from[<800ba654>]
kill_block_super+0x58/0x80
[<800ba654>] kill_block_super+0x58/0x80 from[<800bac6c>]
deactivate_super+0x7c/0x110
[<800bac6c>] deactivate_super+0x7c/0x110 from[<800d2bbc>]
sys_umount+0x310/0x358
[<800d2bbc>] sys_umount+0x310/0x358 from[<8000ff44>] stack_done+0x20/0x3c
---------------------------------------------------------------------------=
----------
Filesystem "sda2": xfs_log_force: error 5 returned.
Please let me know in case more information is needed.

Thanks & Regards,
Amit Sahrawat

On Wed, Dec 22, 2010 at 1:34 PM, Michael Monnerie <
michael.monnerie@is.it-management.at> wrote:

> On Mittwoch, 22. Dezember 2010 Dave Chinner wrote:
> > For future reference, when you are reporting a problem you need to
> > be specific about what you were doing to cause the problem you are
> > reporting.  Describe your kernel, your storage, your test case, any
> > errors that occurred before the problem you are reporting, etc.
> >
> > We need this information to make any sense of your bug report, but
> > I'm getting tired of having to ask for it every time you report a
> > problem. The more information you put in your bug report, the more
> > likely we are to be able to help you. We don't have unlimited
> > amounts of time (or patience) to drag all the basic details of your
> > problem out of you over 3 or 4 emails, so including it up front will
> > help a lot....
>
> Should I update this section?
>
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_whe=
n_reporting_a_problem.3F
>
> We should probably just send that link to people so you don't have to
> write long texts all the time.
>
> Maybe above section should be updated to:
>
> Things to include are what version of XFS you are using and version of
> the kernel. If you have problems with userland packages please report
> the version of the package you are using.
>
> If the problem relates to a particular filesystem, the output from the
> xfs_info(8) command and any mount(8) options in use will also be useful
> to the developers.
>
> If you experience an oops, please run it through ksymoops so that it can
> be interpreted. Also describe what you were doing, if you can repeat it,
> and describe you kernel, storage, test case, if there was a hardware
> problem before, etc.
>
> If you have a filesystem that cannot be repaired, make sure you have
> xfsprogs 3.1.x or later and run xfs_metadump(8) to capture the metadata
> (which obfuscates filenames and attributes to protect your privacy) and
> make the dump available for someone to analyse.
>
> --
> mit freundlichen Gr=FCssen,
> Michael Monnerie, Ing. BSc
>
> it-management Internet Services: Prot=E9ger
> http://proteger.at [gesprochen: Prot-e-schee]
> Tel: +43 660 / 415 6531
>
> // ****** Radiointerview zum Thema Spam ******
> // http://www.it-podcast.at/archiv.html#podcast-100716
> //
> // Haus zu verkaufen: http://zmi.at/langegg/
>

--0015175cb07e7cd73e0497fc2586
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi,</div>
<div>=A0</div>
<div>There seems to be a problem in posting - I already apologized and prov=
ided complete details. I guess this was the first time, i missed on providi=
ng the test case.</div>
<div>=A0</div>
<div>Please refer my earlier post on the same issue:</div>
<div>=A0</div>
<div>=A0</div>
<div>Extremely sorry for inconvenience, will take care about posting comple=
te details in future.<br>=A0<br>Test Case : <br>cp Complex directory struct=
ure(large no of files and directories) to my XFS formatted partition:<br>
cp -ar /LibExe /usb/sda2<br>Unplug the USB while the COPY is in progress.<b=
r>=A0<br>Storage: USB Flash, USB HDD (Both)<br>=A0<br>Kernel: 2.6.34<br>Tar=
get: MIPS<br>LOGS:<br>usb 2-1: USB disconnect, address 7<br>Device sda2, XF=
S metadata write error block 0x0 in sda2<br>
xfs_force_shutdown(sda2,0x1) called from line 1004 of file fs/xfs/linux-2.6=
/xfs_buf.c.=A0 Return address =3D 0x801cc294<br>Filesystem &quot;sda2&quot;=
: I/O Error Detected.=A0 Shutting down filesystem: sda2<br>Please umount th=
e filesystem, and rectify the problem(s)<br>
=A0<br>Plug in USB Port1<br>sd 7:0:0:0: [sdb] Attached SCSI disk<br>Filesys=
tem &quot;sda2&quot;: xfs_log_force: error 5 returned.<br>Filesystem &quot;=
sda2&quot;: xfs_log_force: error 5 returned.<br>Filesystem &quot;sda2&quot;=
: xfs_log_force: error 5 returned.<br>
Filesystem &quot;sda2&quot;: xfs_log_force: error 5 returned.<br>- Show quo=
ted text -<br>INFO: task usb_mount:1858 blocked for more than 120 seconds.<=
br>&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disables=
 this message.<br>
usb_mount=A0=A0=A0=A0=A0=A0=A0 D [84a42440] 8032d62c=A0=A0=A0=A0 0=A0 1858=
=A0=A0 1816=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 (user thread)<br>Stack : 00000107 00000000 85e7be80 0=
0030002 84a425c8 8032d62c 7fffffff 84a42440<br>=A0=A0=A0=A0=A0=A0=A0 000000=
02 8496e200 00000001 00000000 85e7bf00 85e7bef8 7fa2f2e0 8032d62c<br>
=A0=A0=A0=A0=A0=A0=A0 00000001 801d69a8 85e7bd40 801d6b34 85e7bd4c 8032dc6c=
 00000000 801dbc80<br>=A0=A0=A0=A0=A0=A0=A0 85e7be80 864315a8 8662c980 0000=
0001 00000742 00000000 00000000 84b85800<br>=A0=A0=A0=A0=A0=A0=A0 85e7bd90 =
801d6cc0 7fffffff 84a42440 00000002 8032ee74 00000081 804158a0<br>
=A0=A0=A0=A0=A0=A0=A0 ...<br>Call Trace:<br>[&lt;8032d574&gt;] __schedule+0=
x618/0x6b8 from[&lt;8032d62c&gt;] schedule+0x18/0x3c<br>[&lt;8032d62c&gt;] =
schedule+0x18/0x3c from[&lt;8032dc6c&gt;] schedule_timeout+0x2c/0x1c0<br>[&=
lt;8032dc6c&gt;] schedule_timeout+0x2c/0x1c0 from[&lt;8032ee74&gt;] __down+=
0x8c/0xdc<br>
[&lt;8032ee74&gt;] __down+0x8c/0xdc from[&lt;8004500c&gt;] down+0x40/0x88<b=
r>[&lt;8004500c&gt;] down+0x40/0x88 from[&lt;801ca838&gt;] xfs_buf_lock+0xc=
c/0x15c<br>[&lt;801ca838&gt;] xfs_buf_lock+0xcc/0x15c from[&lt;801b71a0&gt;=
] xfs_getsb+0x38/0x54<br>
[&lt;801b71a0&gt;] xfs_getsb+0x38/0x54 from[&lt;801d64a8&gt;] xfs_sync_fsda=
ta+0x7c/0x154<br>[&lt;801d64a8&gt;] xfs_sync_fsdata+0x7c/0x154 from[&lt;801=
d7284&gt;] xfs_quiesce_data+0x34/0x60<br>[&lt;801d7284&gt;] xfs_quiesce_dat=
a+0x34/0x60 from[&lt;801d3514&gt;] xfs_fs_sync_fs+0x30/0xec<br>
[&lt;801d3514&gt;] xfs_fs_sync_fs+0x30/0xec from[&lt;800ba09c&gt;] __fsync_=
super+0xa4/0xc8<br>[&lt;800ba09c&gt;] __fsync_super+0xa4/0xc8 from[&lt;800b=
a0d4&gt;] fsync_super+0x14/0x28<br>[&lt;800ba0d4&gt;] fsync_super+0x14/0x28=
 from[&lt;800ba4a0&gt;] generic_shutdown_super+0x34/0x190<br>
[&lt;800ba4a0&gt;] generic_shutdown_super+0x34/0x190 from[&lt;800ba654&gt;]=
 kill_block_super+0x58/0x80<br>[&lt;800ba654&gt;] kill_block_super+0x58/0x8=
0 from[&lt;800bac6c&gt;] deactivate_super+0x7c/0x110<br>[&lt;800bac6c&gt;] =
deactivate_super+0x7c/0x110 from[&lt;800d2bbc&gt;] sys_umount+0x310/0x358<b=
r>
[&lt;800d2bbc&gt;] sys_umount+0x310/0x358 from[&lt;8000ff44&gt;] stack_done=
+0x20/0x3c<br>-------------------------------------------------------------=
------------------------<br>Filesystem &quot;sda2&quot;: xfs_log_force: err=
or 5 returned.</div>

<div>Please let me know in case more information is needed.<br>=A0<br>Thank=
s &amp; Regards,<br>Amit Sahrawat<br><br></div>
<div class=3D"gmail_quote">On Wed, Dec 22, 2010 at 1:34 PM, Michael Monneri=
e <span dir=3D"ltr">&lt;<a href=3D"mailto:michael.monnerie@is.it-management=
.at">michael.monnerie@is.it-management.at</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Mittwoch, 22. Dezember 2010 Dave Chinner wrote:<br>&gt=
; For future reference, when you are reporting a problem you need to<br>&gt=
; be specific about what you were doing to cause the problem you are<br>
&gt; reporting. =A0Describe your kernel, your storage, your test case, any<=
br>&gt; errors that occurred before the problem you are reporting, etc.<br>=
&gt;<br>&gt; We need this information to make any sense of your bug report,=
 but<br>
&gt; I&#39;m getting tired of having to ask for it every time you report a<=
br>&gt; problem. The more information you put in your bug report, the more<=
br>&gt; likely we are to be able to help you. We don&#39;t have unlimited<b=
r>
&gt; amounts of time (or patience) to drag all the basic details of your<br=
>&gt; problem out of you over 3 or 4 emails, so including it up front will<=
br>&gt; help a lot....<br><br></div>Should I update this section?<br><br>
<a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_in=
clude_when_reporting_a_problem.3F" target=3D"_blank">http://xfs.org/index.p=
hp/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F=
</a><br>
<br>We should probably just send that link to people so you don&#39;t have =
to<br>write long texts all the time.<br><br>Maybe above section should be u=
pdated to:<br><br>Things to include are what version of XFS you are using a=
nd version of<br>
the kernel. If you have problems with userland packages please report<br>th=
e version of the package you are using.<br><br>If the problem relates to a =
particular filesystem, the output from the<br>xfs_info(8) command and any m=
ount(8) options in use will also be useful<br>
to the developers.<br><br>If you experience an oops, please run it through =
ksymoops so that it can<br>be interpreted. Also describe what you were doin=
g, if you can repeat it,<br>and describe you kernel, storage, test case, if=
 there was a hardware<br>
problem before, etc.<br><br>If you have a filesystem that cannot be repaire=
d, make sure you have<br>xfsprogs 3.1.x or later and run xfs_metadump(8) to=
 capture the metadata<br>(which obfuscates filenames and attributes to prot=
ect your privacy) and<br>
make the dump available for someone to analyse.<br><br>--<br>mit freundlich=
en Gr=FCssen,<br>Michael Monnerie, Ing. BSc<br><br>it-management Internet S=
ervices: Prot=E9ger<br><a href=3D"http://proteger.at/" target=3D"_blank">ht=
tp://proteger.at</a> [gesprochen: Prot-e-schee]<br>
Tel: +43 660 / 415 6531<br><br>// ****** Radiointerview zum Thema Spam ****=
**<br>// <a href=3D"http://www.it-podcast.at/archiv.html#podcast-100716" ta=
rget=3D"_blank">http://www.it-podcast.at/archiv.html#podcast-100716</a><br>
//<br>// Haus zu verkaufen: <a href=3D"http://zmi.at/langegg/" target=3D"_b=
lank">http://zmi.at/langegg/</a><br></blockquote></div><br>

--0015175cb07e7cd73e0497fc2586--


--===============2676616471496601121==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2676616471496601121==--
