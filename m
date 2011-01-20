Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0K6a4k0038379 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 00:36:04 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1294419F30EA
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 22:38:22 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id 0FPiDq1TkKNLnWkp
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 22:38:22 -0800 (PST)
Received: by qwe5 with SMTP id 5so256153qwe.26
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 22:38:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik0KUQaRzLeBNR8M=u+ijO6gAZu601zyCp2zmDS@mail.gmail.com>
References: <AANLkTin22efc0cHSmM+2rNQpE2aJoobQCnMwbNUjw617@mail.gmail.com>
	<20110120051720.GR16267@dastard>
	<AANLkTik0KUQaRzLeBNR8M=u+ijO6gAZu601zyCp2zmDS@mail.gmail.com>
Date: Thu, 20 Jan 2011 12:08:21 +0530
Message-ID: <AANLkTi=yvf0ww4_C+H8xz6-5UWHKYSV2amCC9p-0tXrr@mail.gmail.com>
Subject: Re: XFS - issues with writes using sync
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2990142065826235252=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============2990142065826235252==
Content-Type: multipart/alternative; boundary=0016364ede483f7377049a41617d

--0016364ede483f7377049a41617d
Content-Type: text/plain; charset=ISO-8859-1

Hi,
I tried with the same test case - just removed 'sync' command from the
script(please check script below) to check the behaviour.

Please find the logs:
#> ./createsetup.sh
------------[ cut here ]------------
WARNING: at lib/list_debug.c:30 __list_add+0x6c/0x90()
list_add corruption. prev->next should be next (c78699c0), but was c78299c0.
(prev=c78699c0).
Modules linked in:
Backtrace:
[<c04486ac>] (dump_backtrace+0x0/0x110) from [<c06ee0e0>]
(dump_stack+0x18/0x1c)
 r6:c07bc5e1 r5:0000001e r4:c7c01d38 r3:00000000
[<c06ee0c8>] (dump_stack+0x0/0x1c) from [<c046b5fc>]
(warn_slowpath_common+0x54/0x6c)
[<c046b5a8>] (warn_slowpath_common+0x0/0x6c) from [<c046b6b8>]
(warn_slowpath_fmt+0x38/0x40)
 r8:00000000 r7:c05cabd8 r6:c7c01d80 r5:c78699c0 r4:c78699c0
r3:00000009
[<c046b680>] (warn_slowpath_fmt+0x0/0x40) from [<c060b89c>]
(__list_add+0x6c/0x90)
 r3:c78699c0 r2:c07bc6b3
[<c060b830>] (__list_add+0x0/0x90) from [<c06f0710>]
(__down_write_nested+0xbc/0x10c)
 r6:c78699bc r5:60000013 r4:c302d820
[<c06f0654>] (__down_write_nested+0x0/0x10c) from [<c06f0774>]
(__down_write+0x14/0x18)
 r6:c31324a0 r5:00000005 r4:c78699bc
[<c06f0760>] (__down_write+0x0/0x18) from [<c06efd50>]
(down_write+0x28/0x30)
[<c06efd28>] (down_write+0x0/0x30) from [<c05a21ac>] (xfs_ilock+0x28/0xe8)
 r4:c7869940 r3:00000000
[<c05a2184>] (xfs_ilock+0x0/0xe8) from [<c05cabd8>]
(xfs_file_aio_write+0x1d4/0x8cc)
 r7:00000001 r6:c31324a0 r5:00000001 r4:c7869940
[<c05caa04>] (xfs_file_aio_write+0x0/0x8cc) from [<c04eb404>]
(do_sync_write+0xa0/0xe0)
[<c04eb364>] (do_sync_write+0x0/0xe0) from [<c04ec028>]
(vfs_write+0xbc/0x178)
 r6:bee925a0 r5:c31324a0 r4:00000f38
[<c04ebf6c>] (vfs_write+0x0/0x178) from [<c04ec1ac>] (sys_write+0x44/0x70)
 r7:00000004 r6:00000f38 r5:bee925a0 r4:c31324a0
[<c04ec168>] (sys_write+0x0/0x70) from [<c04449a0>]
(ret_fast_syscall+0x0/0x30)
 r9:c7c00000 r8:c0444b48 r6:bee925a0 r5:00000f38 r4:001854e0
---[ end trace 8124d49a241e0763 ]---
INFO: task cp:5445 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
cp            D c06ee75c     0  5445   2173 0x00000000
Backtrace:
[<c06ee398>] (schedule+0x0/0x454) from [<c06f0748>]
(__down_write_nested+0xf4/0x10c)
 r9:c7869a60 r8:00000000 r7:c05cabd8 r6:c78699bc r5:60000013
r4:c302d820
[<c06f0654>] (__down_write_nested+0x0/0x10c) from [<c06f0774>]
(__down_write+0x14/0x18)
 r6:c31324a0 r5:00000005 r4:c78699bc
[<c06f0760>] (__down_write+0x0/0x18) from [<c06efd50>]
(down_write+0x28/0x30)
[<c06efd28>] (down_write+0x0/0x30) from [<c05a21ac>] (xfs_ilock+0x28/0xe8)
 r4:c7869940 r3:00000000
[<c05a2184>] (xfs_ilock+0x0/0xe8) from [<c05cabd8>]
(xfs_file_aio_write+0x1d4/0x8cc)
 r7:00000001 r6:c31324a0 r5:00000001 r4:c7869940
[<c05caa04>] (xfs_file_aio_write+0x0/0x8cc) from [<c04eb404>]
(do_sync_write+0xa0/0xe0)
[<c04eb364>] (do_sync_write+0x0/0xe0) from [<c04ec028>]
(vfs_write+0xbc/0x178)
 r6:bee925a0 r5:c31324a0 r4:00000f38
[<c04ebf6c>] (vfs_write+0x0/0x178) from [<c04ec1ac>] (sys_write+0x44/0x70)
 r7:00000004 r6:00000f38 r5:bee925a0 r4:c31324a0
[<c04ec168>] (sys_write+0x0/0x70) from [<c04449a0>]
(ret_fast_syscall+0x0/0x30)
 r9:c7c00000 r8:c0444b48 r6:bee925a0 r5:00000f38 r4:001854e0
^C^Z[1] + Stopped                    ./createsetup.sh
I really doubt about the stability of 2.6.35.9, it is not passing our basic
tests. Checking few more things, before deciding about the patches which got
introduced between 2.6.34 ~ 2.6.35.9(around 102).

Thanks,
Amit Sahrawat
On Thu, Jan 20, 2011 at 11:37 AM, Amit Sahrawat
<amit.sahrawat83@gmail.com>wrote:

> Hi,
>
> I will try to find out the cause for this.
> Meanwhile, just a small request/suggestion - in the past this type of
> testcases have helped us in finding many problems in XFS.
> Can something like this be added to xfstests? This might help.
>
> Thanks,
> Amit Sahrawat
>   On Thu, Jan 20, 2011 at 10:47 AM, Dave Chinner <david@fromorbit.com>wrote:
>
>> On Thu, Jan 20, 2011 at 10:34:30AM +0530, Amit Sahrawat wrote:
>> > Hi,
>> >
>> > I am facing issues in XFS for a simple test case.
>> > *Target:* ARM
>> > *Kernel version:* 2.6.35.9
>> >
>> > *Test case:*
>> > mkfs.xfs -f /dev/sda2
>> > mount -t xfs /dev/sda2 /mnt/usb/sda2
>> > (Run script - trying to fragment the XFS formatted partition)
>> > #!/bin/sh
>> > index=0
>> > while [ "$?" == 0 ]
>> > do
>> > index=$((index+1))
>> > sync
>> > cp /mnt/usb/sda1/setupfile /mnt/usb/sda2/setupfile.$index
>> > done
>> >
>> > Partition Size on which files are being created - 1GB(I need to fragment
>> > this first to run other cases)
>> > Size of *'setupfile'*  - 16K
>> >
>> > There used be no such issues till *2.6.34*(last XFS version where we
>> tried
>> > to create setup). There is no reset involved this time, just simple
>> running
>> > the script caused this issue.
>>
>> You have a known good version, a known bad version and a
>> reproducable test case. i.e. everything you need to run a git bisect
>> and find the commit introduced the regression. Can you do this and
>> tell us what that commit is?
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

--0016364ede483f7377049a41617d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi,</div>
<div>I tried with the same test case - just removed &#39;sync&#39; command =
from the script(please check script=A0below)=A0to check the behaviour.</div=
>
<div>=A0</div>
<div>Please find the logs:</div>
<div>#&gt; ./createsetup.sh <br>------------[ cut here ]------------<br>WAR=
NING: at lib/list_debug.c:30 __list_add+0x6c/0x90()<br>list_add corruption.=
 prev-&gt;next should be next (c78699c0), but was c78299c0. (prev=3Dc78699c=
0).<br>
Modules linked in:<br>Backtrace: <br>[&lt;c04486ac&gt;] (dump_backtrace+0x0=
/0x110) from [&lt;c06ee0e0&gt;] (dump_stack+0x18/0x1c)<br>=A0r6:c07bc5e1 r5=
:0000001e r4:c7c01d38 r3:00000000<br>[&lt;c06ee0c8&gt;] (dump_stack+0x0/0x1=
c) from [&lt;c046b5fc&gt;] (warn_slowpath_common+0x54/0x6c)<br>
[&lt;c046b5a8&gt;] (warn_slowpath_common+0x0/0x6c) from [&lt;c046b6b8&gt;] =
(warn_slowpath_fmt+0x38/0x40)<br>=A0r8:00000000 r7:c05cabd8 r6:c7c01d80 r5:=
c78699c0 r4:c78699c0<br>r3:00000009<br>[&lt;c046b680&gt;] (warn_slowpath_fm=
t+0x0/0x40) from [&lt;c060b89c&gt;] (__list_add+0x6c/0x90)<br>
=A0r3:c78699c0 r2:c07bc6b3<br>[&lt;c060b830&gt;] (__list_add+0x0/0x90) from=
 [&lt;c06f0710&gt;] (__down_write_nested+0xbc/0x10c)<br>=A0r6:c78699bc r5:6=
0000013 r4:c302d820<br>[&lt;c06f0654&gt;] (__down_write_nested+0x0/0x10c) f=
rom [&lt;c06f0774&gt;] (__down_write+0x14/0x18)<br>
=A0r6:c31324a0 r5:00000005 r4:c78699bc<br>[&lt;c06f0760&gt;] (__down_write+=
0x0/0x18) from [&lt;c06efd50&gt;] (down_write+0x28/0x30)<br>[&lt;c06efd28&g=
t;] (down_write+0x0/0x30) from [&lt;c05a21ac&gt;] (xfs_ilock+0x28/0xe8)<br>
=A0r4:c7869940 r3:00000000<br>[&lt;c05a2184&gt;] (xfs_ilock+0x0/0xe8) from =
[&lt;c05cabd8&gt;] (xfs_file_aio_write+0x1d4/0x8cc)<br>=A0r7:00000001 r6:c3=
1324a0 r5:00000001 r4:c7869940<br>[&lt;c05caa04&gt;] (xfs_file_aio_write+0x=
0/0x8cc) from [&lt;c04eb404&gt;] (do_sync_write+0xa0/0xe0)<br>
[&lt;c04eb364&gt;] (do_sync_write+0x0/0xe0) from [&lt;c04ec028&gt;] (vfs_wr=
ite+0xbc/0x178)<br>=A0r6:bee925a0 r5:c31324a0 r4:00000f38<br>[&lt;c04ebf6c&=
gt;] (vfs_write+0x0/0x178) from [&lt;c04ec1ac&gt;] (sys_write+0x44/0x70)<br=
>
=A0r7:00000004 r6:00000f38 r5:bee925a0 r4:c31324a0<br>[&lt;c04ec168&gt;] (s=
ys_write+0x0/0x70) from [&lt;c04449a0&gt;] (ret_fast_syscall+0x0/0x30)<br>=
=A0r9:c7c00000 r8:c0444b48 r6:bee925a0 r5:00000f38 r4:001854e0<br>---[ end =
trace 8124d49a241e0763 ]---<br>
INFO: task cp:5445 blocked for more than 120 seconds.<br>&quot;echo 0 &gt; =
/proc/sys/kernel/hung_task_timeout_secs&quot; disables this message.<br>cp=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 D c06ee75c=A0=A0=A0=A0 0=A0 5445=A0=A0 21=
73 0x00000000<br>Backtrace: <br>[&lt;c06ee398&gt;] (schedule+0x0/0x454) fro=
m [&lt;c06f0748&gt;] (__down_write_nested+0xf4/0x10c)<br>
=A0r9:c7869a60 r8:00000000 r7:c05cabd8 r6:c78699bc r5:60000013<br>r4:c302d8=
20<br>[&lt;c06f0654&gt;] (__down_write_nested+0x0/0x10c) from [&lt;c06f0774=
&gt;] (__down_write+0x14/0x18)<br>=A0r6:c31324a0 r5:00000005 r4:c78699bc<br=
>
[&lt;c06f0760&gt;] (__down_write+0x0/0x18) from [&lt;c06efd50&gt;] (down_wr=
ite+0x28/0x30)<br>[&lt;c06efd28&gt;] (down_write+0x0/0x30) from [&lt;c05a21=
ac&gt;] (xfs_ilock+0x28/0xe8)<br>=A0r4:c7869940 r3:00000000<br>[&lt;c05a218=
4&gt;] (xfs_ilock+0x0/0xe8) from [&lt;c05cabd8&gt;] (xfs_file_aio_write+0x1=
d4/0x8cc)<br>
=A0r7:00000001 r6:c31324a0 r5:00000001 r4:c7869940<br>[&lt;c05caa04&gt;] (x=
fs_file_aio_write+0x0/0x8cc) from [&lt;c04eb404&gt;] (do_sync_write+0xa0/0x=
e0)<br>[&lt;c04eb364&gt;] (do_sync_write+0x0/0xe0) from [&lt;c04ec028&gt;] =
(vfs_write+0xbc/0x178)<br>
=A0r6:bee925a0 r5:c31324a0 r4:00000f38<br>[&lt;c04ebf6c&gt;] (vfs_write+0x0=
/0x178) from [&lt;c04ec1ac&gt;] (sys_write+0x44/0x70)<br>=A0r7:00000004 r6:=
00000f38 r5:bee925a0 r4:c31324a0<br>[&lt;c04ec168&gt;] (sys_write+0x0/0x70)=
 from [&lt;c04449a0&gt;] (ret_fast_syscall+0x0/0x30)<br>
=A0r9:c7c00000 r8:c0444b48 r6:bee925a0 r5:00000f38 r4:001854e0=A0<br>^C^Z[1=
] + Stopped=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ./crea=
tesetup.sh<br></div>
<div>I really doubt about the stability of 2.6.35.9, it is not passing our =
basic tests. Checking few more things, before deciding about the patches wh=
ich got introduced between 2.6.34 ~ 2.6.35.9(around 102).</div>
<div>=A0</div>
<div>Thanks,</div>
<div>Amit Sahrawat<br></div>
<div class=3D"gmail_quote">On Thu, Jan 20, 2011 at 11:37 AM, Amit Sahrawat =
<span dir=3D"ltr">&lt;<a href=3D"mailto:amit.sahrawat83@gmail.com">amit.sah=
rawat83@gmail.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>Hi,</div>
<div>=A0</div>
<div>I will try to find out the cause for this.</div>
<div>Meanwhile, just a small request/suggestion - in the past this=A0type o=
f testcases have helped us in finding many problems in XFS. </div>
<div>Can something like this be added to xfstests? This might help. </div>
<div><br>Thanks,</div>
<div>Amit Sahrawat<font color=3D"#888888"><br></font></div>
<div>
<div></div>
<div class=3D"h5">
<div class=3D"gmail_quote">On Thu, Jan 20, 2011 at 10:47 AM, Dave Chinner <=
span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blan=
k">david@fromorbit.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>On Thu, Jan 20, 2011 at 10:34:30AM +0530, Amit Sahrawat wrote:<br>&gt;=
 Hi,<br>&gt;<br>&gt; I am facing issues in XFS for a simple test case.<br>&=
gt; *Target:* ARM<br>&gt; *Kernel version:* 2.6.35.9<br>&gt;<br>&gt; *Test =
case:*<br>
&gt; mkfs.xfs -f /dev/sda2<br>&gt; mount -t xfs /dev/sda2 /mnt/usb/sda2<br>=
&gt; (Run script - trying to fragment the XFS formatted partition)<br>&gt; =
#!/bin/sh<br>&gt; index=3D0<br>&gt; while [ &quot;$?&quot; =3D=3D 0 ]<br>&g=
t; do<br>
&gt; index=3D$((index+1))<br>&gt; sync<br>&gt; cp /mnt/usb/sda1/setupfile /=
mnt/usb/sda2/setupfile.$index<br>&gt; done<br>&gt;<br>&gt; Partition Size o=
n which files are being created - 1GB(I need to fragment<br>&gt; this first=
 to run other cases)<br>
&gt; Size of *&#39;setupfile&#39;* =A0- 16K<br>&gt;<br>&gt; There used be n=
o such issues till *2.6.34*(last XFS version where we tried<br>&gt; to crea=
te setup). There is no reset involved this time, just simple running<br>&gt=
; the script caused this issue.<br>
<br></div>You have a known good version, a known bad version and a<br>repro=
ducable test case. i.e. everything you need to run a git bisect<br>and find=
 the commit introduced the regression. Can you do this and<br>tell us what =
that commit is?<br>
<br>Cheers,<br><br>Dave.<br><font color=3D"#888888">--<br>Dave Chinner<br><=
a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com=
</a><br></font></blockquote></div><br></div></div></blockquote></div><br>

--0016364ede483f7377049a41617d--


--===============2990142065826235252==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2990142065826235252==--
