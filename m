Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A352D7F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 04:04:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 90D288F8035
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 02:03:59 -0700 (PDT)
Received: from mail-oi0-f48.google.com (mail-oi0-f48.google.com
	[209.85.218.48]) by cuda.sgi.com with ESMTP id BJmBCn7Ampsd1aXN
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 29 Oct 2014 02:03:57 -0700 (PDT)
Received: by mail-oi0-f48.google.com with SMTP id x69so1937270oia.21
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 02:03:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141029075134.GB13323@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<5450686F.9070307@sandeen.net>
	<CAGdb-8d5-GuB40ZgP6uM5aQMi+qqaeFd=xqzuxWhM+1AaoLSVw@mail.gmail.com>
	<54506CD9.90403@sandeen.net>
	<CAGdb-8cGAzT_0ck-pJyQX-OcnE_3FPCA9TesHW7c_raDSKEXWg@mail.gmail.com>
	<20141029044017.GG16186@dastard>
	<CAGdb-8e=wttjj+wTj8wqRWyUUz+AUmz-O0=r3+HoJ5zGgV-dkQ@mail.gmail.com>
	<20141029075134.GB13323@dastard>
Date: Wed, 29 Oct 2014 17:03:57 +0800
Message-ID: <CAGdb-8cD69ufC0hkPFDNxOqcXENE1vH3X8sXWka3A3ncVVHEmQ@mail.gmail.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
From: Tommy Wu <wu.tommy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0940346225163895565=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs <xfs@oss.sgi.com>

--===============0940346225163895565==
Content-Type: multipart/alternative; boundary=047d7b5d42643b891e05068c0b74

--047d7b5d42643b891e05068c0b74
Content-Type: text/plain; charset=UTF-8

Oct 29 17:01:58 mail kernel: [  360.367165] INFO: task xfsdump:2549 blocked
for more than 120 seconds.
Oct 29 17:01:58 mail kernel: [  360.367182]       Tainted: G           O
3.18.0-rc2-1029 #1
Oct 29 17:01:58 mail kernel: [  360.367195] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 29 17:01:58 mail kernel: [  360.367211] xfsdump         D
0000000000000000     0  2549   2265 0x00000000
Oct 29 17:01:58 mail kernel: [  360.367229]  ffff8808110b8190
0000000000000082 ffff8807eb0e4800 ffff8807fa527fd8
Oct 29 17:01:58 mail kernel: [  360.367248]  ffff8808110b8190
000000000000a000 0000000000000296 000000007a9966c4
Oct 29 17:01:58 mail kernel: [  360.367266]  ffff8807fa557800
000000007a9966c4 ffff8807eb0e4800 7fffffffffffffff
Oct 29 17:01:58 mail kernel: [  360.367285] Call Trace:
Oct 29 17:01:58 mail kernel: [  360.367296]  [<ffffffff814106ad>] ?
schedule_timeout+0x15d/0x1b0
Oct 29 17:01:58 mail kernel: [  360.367310]  [<ffffffff8140f835>] ?
__down+0x65/0xb0
Oct 29 17:01:58 mail kernel: [  360.367322]  [<ffffffff8107e09d>] ?
down+0x3d/0x60
Oct 29 17:01:58 mail kernel: [  360.367359]  [<ffffffffa03637bd>] ?
xfs_buf_lock+0x1d/0x40 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367378]  [<ffffffffa0363975>] ?
_xfs_buf_find+0x195/0x270 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367398]  [<ffffffffa0363a71>] ?
xfs_buf_get_map+0x21/0x120 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367418]  [<ffffffffa03640ce>] ?
xfs_buf_read_map+0x1e/0xc0 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367438]  [<ffffffffa038c9db>] ?
xfs_trans_read_buf_map+0x10b/0x300 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367459]  [<ffffffffa0354440>] ?
xfs_read_agi+0x80/0xb0 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367478]  [<ffffffffa0354481>] ?
xfs_ialloc_read_agi+0x11/0x70 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367499]  [<ffffffffa0376532>] ?
xfs_bulkstat+0x192/0x530 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367517]  [<ffffffffa03761e0>] ?
xfs_bulkstat_one_int+0x2e0/0x2e0 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367538]  [<ffffffffa036bda2>] ?
xfs_ioc_bulkstat+0xe2/0x1c0 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367558]  [<ffffffffa036e518>] ?
xfs_file_ioctl+0x7f8/0xab0 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367577]  [<ffffffffa037221c>] ?
xfs_iunlock+0x3c/0x80 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367596]  [<ffffffffa0360ed5>] ?
xfs_free_eofblocks+0xd5/0x2a0 [xfs]
Oct 29 17:01:58 mail kernel: [  360.367611]  [<ffffffff810f6834>] ?
list_lru_add+0x64/0x100
Oct 29 17:01:58 mail kernel: [  360.367625]  [<ffffffff81152800>] ?
do_vfs_ioctl+0x2e0/0x4c0
Oct 29 17:01:58 mail kernel: [  360.367638]  [<ffffffff8105e3d4>] ?
task_work_run+0xb4/0xf0
Oct 29 17:01:58 mail kernel: [  360.367651]  [<ffffffff81152a59>] ?
SyS_ioctl+0x79/0x90
Oct 29 17:01:58 mail kernel: [  360.367662]  [<ffffffff814119e0>] ?
int_signal+0x12/0x17
Oct 29 17:01:58 mail kernel: [  360.367674]  [<ffffffff81411796>] ?
system_call_fastpath+0x16/0x1b

[  418.302083] SysRq : Show Blocked State
[  418.302096]   task                        PC stack   pid father
[  418.302127] xfsdump         D 0000000000000000     0  2549   2265
0x00000000
[  418.302144]  ffff8808110b8190 0000000000000082 ffff8807eb0e4800
ffff8807fa527fd8
[  418.302163]  ffff8808110b8190 000000000000a000 0000000000000296
000000007a9966c4
[  418.302181]  ffff8807fa557800 000000007a9966c4 ffff8807eb0e4800
7fffffffffffffff
[  418.302200] Call Trace:
[  418.302210]  [<ffffffff814106ad>] ? schedule_timeout+0x15d/0x1b0
[  418.302224]  [<ffffffff8140f835>] ? __down+0x65/0xb0
[  418.302237]  [<ffffffff8107e09d>] ? down+0x3d/0x60
[  418.302715]  [<ffffffffa03637bd>] ? xfs_buf_lock+0x1d/0x40 [xfs]
[  418.303160]  [<ffffffffa0363975>] ? _xfs_buf_find+0x195/0x270 [xfs]
[  418.303585]  [<ffffffffa0363a71>] ? xfs_buf_get_map+0x21/0x120 [xfs]
[  418.304007]  [<ffffffffa03640ce>] ? xfs_buf_read_map+0x1e/0xc0 [xfs]
[  418.304421]  [<ffffffffa038c9db>] ? xfs_trans_read_buf_map+0x10b/0x300
[xfs]
[  418.304837]  [<ffffffffa0354440>] ? xfs_read_agi+0x80/0xb0 [xfs]
[  418.305250]  [<ffffffffa0354481>] ? xfs_ialloc_read_agi+0x11/0x70 [xfs]
[  418.305664]  [<ffffffffa0376532>] ? xfs_bulkstat+0x192/0x530 [xfs]
[  418.306078]  [<ffffffffa03761e0>] ? xfs_bulkstat_one_int+0x2e0/0x2e0
[xfs]
[  418.306492]  [<ffffffffa036bda2>] ? xfs_ioc_bulkstat+0xe2/0x1c0 [xfs]
[  418.306939]  [<ffffffffa036e518>] ? xfs_file_ioctl+0x7f8/0xab0 [xfs]
[  418.307350]  [<ffffffffa037221c>] ? xfs_iunlock+0x3c/0x80 [xfs]
[  418.307754]  [<ffffffffa0360ed5>] ? xfs_free_eofblocks+0xd5/0x2a0 [xfs]
[  418.308163]  [<ffffffff810f6834>] ? list_lru_add+0x64/0x100
[  418.308567]  [<ffffffff81152800>] ? do_vfs_ioctl+0x2e0/0x4c0
[  418.308961]  [<ffffffff8105e3d4>] ? task_work_run+0xb4/0xf0
[  418.309352]  [<ffffffff81152a59>] ? SyS_ioctl+0x79/0x90
[  418.309734]  [<ffffffff814119e0>] ? int_signal+0x12/0x17
[  418.310113]  [<ffffffff81411796>] ? system_call_fastpath+0x16/0x1b



2014-10-29 15:51 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Wed, Oct 29, 2014 at 02:46:33PM +0800, Tommy Wu wrote:
> > it will hang after this message (the kernel in above git repo):
> >
> > /sbin/xfsdump: dumping non-directory files
> >
> > console show the below message every 2 minutes:
> > [  480.387308] INFO: task xfsdump:2717 blocked for more than 120 seconds.
>
> I think there might be something else wrong with your system.
>
> What's the stack trace associated with that? If there's none,
> what's the output of 'echo w > /proc/sysrq-trigger' in dmesg?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



-- 

Tommy Wu

--047d7b5d42643b891e05068c0b74
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Oct 29 17:01:58 mail kernel: [=C2=A0 360.367165] INFO: tas=
k xfsdump:2549 blocked for more than 120 seconds.<br>Oct 29 17:01:58 mail k=
ernel: [=C2=A0 360.367182]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Tainted: G=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 O=C2=A0=C2=A0 =
3.18.0-rc2-1029 #1<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367195] &quo=
t;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disables this m=
essage.<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367211] xfsdump=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 D 0000000000000000=C2=A0=C2=A0=
=C2=A0=C2=A0 0=C2=A0 2549=C2=A0=C2=A0 2265 0x00000000<br>Oct 29 17:01:58 ma=
il kernel: [=C2=A0 360.367229]=C2=A0 ffff8808110b8190 0000000000000082 ffff=
8807eb0e4800 ffff8807fa527fd8<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.3=
67248]=C2=A0 ffff8808110b8190 000000000000a000 0000000000000296 000000007a9=
966c4<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367266]=C2=A0 ffff8807fa5=
57800 000000007a9966c4 ffff8807eb0e4800 7fffffffffffffff<br>Oct 29 17:01:58=
 mail kernel: [=C2=A0 360.367285] Call Trace:<br>Oct 29 17:01:58 mail kerne=
l: [=C2=A0 360.367296]=C2=A0 [&lt;ffffffff814106ad&gt;] ? schedule_timeout+=
0x15d/0x1b0<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367310]=C2=A0 [&lt;=
ffffffff8140f835&gt;] ? __down+0x65/0xb0<br>Oct 29 17:01:58 mail kernel: [=
=C2=A0 360.367322]=C2=A0 [&lt;ffffffff8107e09d&gt;] ? down+0x3d/0x60<br>Oct=
 29 17:01:58 mail kernel: [=C2=A0 360.367359]=C2=A0 [&lt;ffffffffa03637bd&g=
t;] ? xfs_buf_lock+0x1d/0x40 [xfs]<br>Oct 29 17:01:58 mail kernel: [=C2=A0 =
360.367378]=C2=A0 [&lt;ffffffffa0363975&gt;] ? _xfs_buf_find+0x195/0x270 [x=
fs]<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367398]=C2=A0 [&lt;ffffffff=
a0363a71&gt;] ? xfs_buf_get_map+0x21/0x120 [xfs]<br>Oct 29 17:01:58 mail ke=
rnel: [=C2=A0 360.367418]=C2=A0 [&lt;ffffffffa03640ce&gt;] ? xfs_buf_read_m=
ap+0x1e/0xc0 [xfs]<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367438]=C2=
=A0 [&lt;ffffffffa038c9db&gt;] ? xfs_trans_read_buf_map+0x10b/0x300 [xfs]<b=
r>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367459]=C2=A0 [&lt;ffffffffa0354=
440&gt;] ? xfs_read_agi+0x80/0xb0 [xfs]<br>Oct 29 17:01:58 mail kernel: [=
=C2=A0 360.367478]=C2=A0 [&lt;ffffffffa0354481&gt;] ? xfs_ialloc_read_agi+0=
x11/0x70 [xfs]<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367499]=C2=A0 [&=
lt;ffffffffa0376532&gt;] ? xfs_bulkstat+0x192/0x530 [xfs]<br>Oct 29 17:01:5=
8 mail kernel: [=C2=A0 360.367517]=C2=A0 [&lt;ffffffffa03761e0&gt;] ? xfs_b=
ulkstat_one_int+0x2e0/0x2e0 [xfs]<br>Oct 29 17:01:58 mail kernel: [=C2=A0 3=
60.367538]=C2=A0 [&lt;ffffffffa036bda2&gt;] ? xfs_ioc_bulkstat+0xe2/0x1c0 [=
xfs]<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367558]=C2=A0 [&lt;fffffff=
fa036e518&gt;] ? xfs_file_ioctl+0x7f8/0xab0 [xfs]<br>Oct 29 17:01:58 mail k=
ernel: [=C2=A0 360.367577]=C2=A0 [&lt;ffffffffa037221c&gt;] ? xfs_iunlock+0=
x3c/0x80 [xfs]<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367596]=C2=A0 [&=
lt;ffffffffa0360ed5&gt;] ? xfs_free_eofblocks+0xd5/0x2a0 [xfs]<br>Oct 29 17=
:01:58 mail kernel: [=C2=A0 360.367611]=C2=A0 [&lt;ffffffff810f6834&gt;] ? =
list_lru_add+0x64/0x100<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367625]=
=C2=A0 [&lt;ffffffff81152800&gt;] ? do_vfs_ioctl+0x2e0/0x4c0<br>Oct 29 17:0=
1:58 mail kernel: [=C2=A0 360.367638]=C2=A0 [&lt;ffffffff8105e3d4&gt;] ? ta=
sk_work_run+0xb4/0xf0<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367651]=
=C2=A0 [&lt;ffffffff81152a59&gt;] ? SyS_ioctl+0x79/0x90<br>Oct 29 17:01:58 =
mail kernel: [=C2=A0 360.367662]=C2=A0 [&lt;ffffffff814119e0&gt;] ? int_sig=
nal+0x12/0x17<br>Oct 29 17:01:58 mail kernel: [=C2=A0 360.367674]=C2=A0 [&l=
t;ffffffff81411796&gt;] ? system_call_fastpath+0x16/0x1b<br><br>[=C2=A0 418=
.302083] SysRq : Show Blocked State<br>[=C2=A0 418.302096]=C2=A0=C2=A0 task=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 PC stack=C2=
=A0=C2=A0 pid father<br>[=C2=A0 418.302127] xfsdump=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 D 0000000000000000=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=
 2549=C2=A0=C2=A0 2265 0x00000000<br>[=C2=A0 418.302144]=C2=A0 ffff8808110b=
8190 0000000000000082 ffff8807eb0e4800 ffff8807fa527fd8<br>[=C2=A0 418.3021=
63]=C2=A0 ffff8808110b8190 000000000000a000 0000000000000296 000000007a9966=
c4<br>[=C2=A0 418.302181]=C2=A0 ffff8807fa557800 000000007a9966c4 ffff8807e=
b0e4800 7fffffffffffffff<br>[=C2=A0 418.302200] Call Trace:<br>[=C2=A0 418.=
302210]=C2=A0 [&lt;ffffffff814106ad&gt;] ? schedule_timeout+0x15d/0x1b0<br>=
[=C2=A0 418.302224]=C2=A0 [&lt;ffffffff8140f835&gt;] ? __down+0x65/0xb0<br>=
[=C2=A0 418.302237]=C2=A0 [&lt;ffffffff8107e09d&gt;] ? down+0x3d/0x60<br>[=
=C2=A0 418.302715]=C2=A0 [&lt;ffffffffa03637bd&gt;] ? xfs_buf_lock+0x1d/0x4=
0 [xfs]<br>[=C2=A0 418.303160]=C2=A0 [&lt;ffffffffa0363975&gt;] ? _xfs_buf_=
find+0x195/0x270 [xfs]<br>[=C2=A0 418.303585]=C2=A0 [&lt;ffffffffa0363a71&g=
t;] ? xfs_buf_get_map+0x21/0x120 [xfs]<br>[=C2=A0 418.304007]=C2=A0 [&lt;ff=
ffffffa03640ce&gt;] ? xfs_buf_read_map+0x1e/0xc0 [xfs]<br>[=C2=A0 418.30442=
1]=C2=A0 [&lt;ffffffffa038c9db&gt;] ? xfs_trans_read_buf_map+0x10b/0x300 [x=
fs]<br>[=C2=A0 418.304837]=C2=A0 [&lt;ffffffffa0354440&gt;] ? xfs_read_agi+=
0x80/0xb0 [xfs]<br>[=C2=A0 418.305250]=C2=A0 [&lt;ffffffffa0354481&gt;] ? x=
fs_ialloc_read_agi+0x11/0x70 [xfs]<br>[=C2=A0 418.305664]=C2=A0 [&lt;ffffff=
ffa0376532&gt;] ? xfs_bulkstat+0x192/0x530 [xfs]<br>[=C2=A0 418.306078]=C2=
=A0 [&lt;ffffffffa03761e0&gt;] ? xfs_bulkstat_one_int+0x2e0/0x2e0 [xfs]<br>=
[=C2=A0 418.306492]=C2=A0 [&lt;ffffffffa036bda2&gt;] ? xfs_ioc_bulkstat+0xe=
2/0x1c0 [xfs]<br>[=C2=A0 418.306939]=C2=A0 [&lt;ffffffffa036e518&gt;] ? xfs=
_file_ioctl+0x7f8/0xab0 [xfs]<br>[=C2=A0 418.307350]=C2=A0 [&lt;ffffffffa03=
7221c&gt;] ? xfs_iunlock+0x3c/0x80 [xfs]<br>[=C2=A0 418.307754]=C2=A0 [&lt;=
ffffffffa0360ed5&gt;] ? xfs_free_eofblocks+0xd5/0x2a0 [xfs]<br>[=C2=A0 418.=
308163]=C2=A0 [&lt;ffffffff810f6834&gt;] ? list_lru_add+0x64/0x100<br>[=C2=
=A0 418.308567]=C2=A0 [&lt;ffffffff81152800&gt;] ? do_vfs_ioctl+0x2e0/0x4c0=
<br>[=C2=A0 418.308961]=C2=A0 [&lt;ffffffff8105e3d4&gt;] ? task_work_run+0x=
b4/0xf0<br>[=C2=A0 418.309352]=C2=A0 [&lt;ffffffff81152a59&gt;] ? SyS_ioctl=
+0x79/0x90<br>[=C2=A0 418.309734]=C2=A0 [&lt;ffffffff814119e0&gt;] ? int_si=
gnal+0x12/0x17<br>[=C2=A0 418.310113]=C2=A0 [&lt;ffffffff81411796&gt;] ? sy=
stem_call_fastpath+0x16/0x1b<br><br><br></div><div class=3D"gmail_extra"><b=
r><div class=3D"gmail_quote">2014-10-29 15:51 GMT+08:00 Dave Chinner <span =
dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">da=
vid@fromorbit.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span c=
lass=3D"">On Wed, Oct 29, 2014 at 02:46:33PM +0800, Tommy Wu wrote:<br>
&gt; it will hang after this message (the kernel in above git repo):<br>
&gt;<br>
&gt; /sbin/xfsdump: dumping non-directory files<br>
&gt;<br>
&gt; console show the below message every 2 minutes:<br>
&gt; [=C2=A0 480.387308] INFO: task xfsdump:2717 blocked for more than 120 =
seconds.<br>
<br>
</span>I think there might be something else wrong with your system.<br>
<br>
What&#39;s the stack trace associated with that? If there&#39;s none,<br>
what&#39;s the output of &#39;echo w &gt; /proc/sysrq-trigger&#39; in dmesg=
?<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br><div class=
=3D"gmail_signature"><br>Tommy Wu</div>
</div>

--047d7b5d42643b891e05068c0b74--


--===============0940346225163895565==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0940346225163895565==--
