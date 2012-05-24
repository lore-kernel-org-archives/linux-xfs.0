Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4O5jR66155718 for <xfs@oss.sgi.com>; Thu, 24 May 2012 00:45:27 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id 98XBcGWMrfuqN1JV
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 May 2012 22:45:06 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so12892877pbb.26
	for <xfs@oss.sgi.com>; Wed, 23 May 2012 22:45:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120521171136.GR16099@sgi.com>
References: <CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
	<CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
	<20120518171959.GQ16099@sgi.com>
	<CADLDEKssiOCVRknW3hYtxDxYHSyGr6qfepfai+UymsD6zMGopw@mail.gmail.com>
	<20120521171136.GR16099@sgi.com>
Date: Thu, 24 May 2012 07:45:05 +0200
Message-ID: <CADLDEKtVPRa-ZM_T6_-VLnCKtCtJwSNGR3VwR=qmFi1umbmTBQ@mail.gmail.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
From: Juerg Haefliger <juergh@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

Hi Ben,


> Hey Juerg,
>
> On Sat, May 19, 2012 at 09:28:55AM +0200, Juerg Haefliger wrote:
>> > On Wed, May 09, 2012 at 09:54:08AM +0200, Juerg Haefliger wrote:
>> >> > On Sat, May 05, 2012 at 09:44:35AM +0200, Juerg Haefliger wrote:
>> >> >> Did anybody have a chance to look at the data?
>> >> >
>> >> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/979498
>> >> >
>> >> > Here you indicate that you have created a reproducer. =A0Can you po=
st it to the list?
>> >>
>> >> Canonical attached them to the bug report that they filed yesterday:
>> >> http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D922
>> >
>> > I'm interested in understanding to what extent the hang you see in pro=
duction
>> > on 2.6.38 is similar to the hang of the reproducer. =A0Mark is seeing =
a situation
>> > where there is nothing on the AIL and is clogged up in the CIL, others=
 are
>> > seeing items on the AIL that don't seem to be making progress. =A0Coul=
d you
>> > provide a dump or traces from a hang on a filesystem with a normal siz=
ed log?
>> > Can the reproducer hit the hang eventually without resorting to the ti=
ny log?
>>
>> I'm not certain that the reproducer hang is identical to the
>> production hang. One difference that I've noticed is that a reproducer
>> hang can be cleared with an emergency sync while a production hang
>> can't. I'm working on trying to get a trace from a production machine.
>
> Hit this on a filesystem with a regular sized log over the weekend. =A0If=
 you see
> this again in production could you gather up task states?
>
> echo t > /proc/sysrq-trigger

Here is the log from a production hang:

May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111805] INFO:
task xfssyncd/dm-4:971 blocked for more than 120 seconds.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111864] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111951]
xfssyncd/dm-4   D 000000000000000f     0   971      2 0x00000000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111957]
ffff880325e09d00 0000000000000046 ffff880325e09fd8 ffff880325e08000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111962]
0000000000013d00 ffff880326774858 ffff880325e09fd8 0000000000013d00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111966]
ffff8803241badc0 ffff8803267744a0 0000000000000282 ffff8806265d7e00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111971] Call Trace:
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112016]
[<ffffffffa00f42d8>] xlog_grant_log_space+0x4a8/0x500 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112023]
[<ffffffff8105f6f0>] ? default_wake_function+0x0/0x20
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112046]
[<ffffffffa00f61ff>] xfs_log_reserve+0xff/0x140 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112070]
[<ffffffffa01021fc>] xfs_trans_reserve+0x9c/0x200 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112092]
[<ffffffffa00e6383>] xfs_fs_log_dummy+0x43/0x90 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112117]
[<ffffffffa01193c1>] xfs_sync_worker+0x81/0x90 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112141]
[<ffffffffa01180f3>] xfssyncd+0x183/0x230 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112164]
[<ffffffffa0117f70>] ? xfssyncd+0x0/0x230 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112170]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112176]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112180]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112183]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112241] INFO:
task ruby1.8:2734 blocked for more than 120 seconds.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112295] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112378] ruby1.8
      D 000000000000000e     0  2734      1 0x00000000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112382]
ffff88004b933c08 0000000000000086 ffff88004b933fd8 ffff88004b932000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112386]
0000000000013d00 ffff8805df2eb178 ffff88004b933fd8 0000000000013d00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112391]
ffff88032730adc0 ffff8805df2eadc0 0000000000000286 ffff8806265d7e00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112395] Call Trace:
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112419]
[<ffffffffa00f42d8>] xlog_grant_log_space+0x4a8/0x500 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112423]
[<ffffffff8105f6f0>] ? default_wake_function+0x0/0x20
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112446]
[<ffffffffa00f61ff>] xfs_log_reserve+0xff/0x140 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112470]
[<ffffffffa01021fc>] xfs_trans_reserve+0x9c/0x200 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112493]
[<ffffffffa0102071>] ? xfs_trans_alloc+0xa1/0xb0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112517]
[<ffffffffa0107162>] xfs_setattr+0x652/0x9e0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112541]
[<ffffffffa0114e4b>] xfs_vn_setattr+0x1b/0x20 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112546]
[<ffffffff8117fe69>] notify_change+0x189/0x370
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112552]
[<ffffffff811903be>] utimes_common+0xce/0x1d0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112556]
[<ffffffff811905ac>] do_utimes+0xec/0x100
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112560]
[<ffffffff811906e0>] sys_futimesat+0x30/0xb0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112565]
[<ffffffff811784a2>] ? sys_select+0x52/0x100
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112569]
[<ffffffff81190779>] sys_utimes+0x19/0x20
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112572]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112579] INFO:
task cron:32731 blocked for more than 120 seconds.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112631] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112714] cron
      D 0000000000000001     0 32731   1276 0x00000000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112718]
ffff880025753c48 0000000000000082 ffff880025753fd8 ffff880025752000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112722]
0000000000013d00 ffff88006b9c5f38 ffff880025753fd8 0000000000013d00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112727]
ffff8803270c8000 ffff88006b9c5b80 0000000000000286 ffff8806265d7e00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112731] Call Trace:
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112754]
[<ffffffffa00f42d8>] xlog_grant_log_space+0x4a8/0x500 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112758]
[<ffffffff8105f6f0>] ? default_wake_function+0x0/0x20
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112781]
[<ffffffffa00f61ff>] xfs_log_reserve+0xff/0x140 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112805]
[<ffffffffa01021fc>] xfs_trans_reserve+0x9c/0x200 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112828]
[<ffffffffa0102071>] ? xfs_trans_alloc+0xa1/0xb0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112852]
[<ffffffffa0107acd>] xfs_inactive+0x27d/0x470 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112876]
[<ffffffffa0115dde>] xfs_fs_evict_inode+0x9e/0xf0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112880]
[<ffffffff8117deb4>] evict+0x24/0xc0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112883]
[<ffffffff8117eae7>] iput_final+0x187/0x270
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112887]
[<ffffffff8117ec0b>] iput+0x3b/0x50
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112890]
[<ffffffff8117ae40>] d_kill+0x100/0x140
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112893]
[<ffffffff8117bdf2>] dput+0xd2/0x1b0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112897]
[<ffffffff811666eb>] __fput+0x13b/0x1f0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112901]
[<ffffffff811667c5>] fput+0x25/0x30
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112905]
[<ffffffff811630e0>] filp_close+0x60/0x90
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112908]
[<ffffffff811638e7>] sys_close+0xb7/0x120
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112912]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112915] INFO:
task cron:32732 blocked for more than 120 seconds.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112970] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113054] cron
      D 0000000000000001     0 32732   1276 0x00000000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113058]
ffff8800a4a9fc48 0000000000000086 ffff8800a4a9ffd8 ffff8800a4a9e000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113062]
0000000000013d00 ffff88006b9c4858 ffff8800a4a9ffd8 0000000000013d00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113066]
ffff8803270c8000 ffff88006b9c44a0 0000000000000286 ffff8806265d7e00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113071] Call Trace:
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113094]
[<ffffffffa00f42d8>] xlog_grant_log_space+0x4a8/0x500 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113098]
[<ffffffff8105f6f0>] ? default_wake_function+0x0/0x20
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113121]
[<ffffffffa00f61ff>] xfs_log_reserve+0xff/0x140 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113144]
[<ffffffffa01021fc>] xfs_trans_reserve+0x9c/0x200 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113168]
[<ffffffffa0102071>] ? xfs_trans_alloc+0xa1/0xb0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113192]
[<ffffffffa0107acd>] xfs_inactive+0x27d/0x470 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113215]
[<ffffffffa0115dde>] xfs_fs_evict_inode+0x9e/0xf0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113219]
[<ffffffff8117deb4>] evict+0x24/0xc0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113223]
[<ffffffff8117eae7>] iput_final+0x187/0x270
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113226]
[<ffffffff8117ec0b>] iput+0x3b/0x50
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113229]
[<ffffffff8117ae40>] d_kill+0x100/0x140
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113232]
[<ffffffff8117bdf2>] dput+0xd2/0x1b0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113236]
[<ffffffff811666eb>] __fput+0x13b/0x1f0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113240]
[<ffffffff811667c5>] fput+0x25/0x30
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113243]
[<ffffffff811630e0>] filp_close+0x60/0x90
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113247]
[<ffffffff811638e7>] sys_close+0xb7/0x120
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113250]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113253] INFO:
task cron:32733 blocked for more than 120 seconds.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113305] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113388] cron
      D 0000000000000006     0 32733   1276 0x00000000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113392]
ffff88003d4d3c48 0000000000000082 ffff88003d4d3fd8 ffff88003d4d2000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113397]
0000000000013d00 ffff88006b9c1a98 ffff88003d4d3fd8 0000000000013d00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113401]
ffff8805df302dc0 ffff88006b9c16e0 0000000000000286 ffff8806265d7e00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113405] Call Trace:
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113428]
[<ffffffffa00f42d8>] xlog_grant_log_space+0x4a8/0x500 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113432]
[<ffffffff8105f6f0>] ? default_wake_function+0x0/0x20
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113455]
[<ffffffffa00f61ff>] xfs_log_reserve+0xff/0x140 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113479]
[<ffffffffa01021fc>] xfs_trans_reserve+0x9c/0x200 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113502]
[<ffffffffa0102071>] ? xfs_trans_alloc+0xa1/0xb0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113526]
[<ffffffffa0107acd>] xfs_inactive+0x27d/0x470 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113550]
[<ffffffffa0115dde>] xfs_fs_evict_inode+0x9e/0xf0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113554]
[<ffffffff8117deb4>] evict+0x24/0xc0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113557]
[<ffffffff8117eae7>] iput_final+0x187/0x270
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113560]
[<ffffffff8117ec0b>] iput+0x3b/0x50
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113563]
[<ffffffff8117ae40>] d_kill+0x100/0x140
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113567]
[<ffffffff8117bdf2>] dput+0xd2/0x1b0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113570]
[<ffffffff811666eb>] __fput+0x13b/0x1f0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113574]
[<ffffffff811667c5>] fput+0x25/0x30
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113577]
[<ffffffff811630e0>] filp_close+0x60/0x90
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113580]
[<ffffffff811638e7>] sys_close+0xb7/0x120
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113584]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113587] INFO:
task cron:32734 blocked for more than 120 seconds.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113639] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113722] cron
      D 0000000000000001     0 32734   1276 0x00000000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113726]
ffff88003dddfc48 0000000000000086 ffff88003dddffd8 ffff88003ddde000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113731]
0000000000013d00 ffff88006b9c3178 ffff88003dddffd8 0000000000013d00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113735]
ffff8803270c8000 ffff88006b9c2dc0 0000000000000286 ffff8806265d7e00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113739] Call Trace:
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113762]
[<ffffffffa00f42d8>] xlog_grant_log_space+0x4a8/0x500 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113766]
[<ffffffff8105f6f0>] ? default_wake_function+0x0/0x20
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113789]
[<ffffffffa00f61ff>] xfs_log_reserve+0xff/0x140 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113813]
[<ffffffffa01021fc>] xfs_trans_reserve+0x9c/0x200 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113836]
[<ffffffffa0102071>] ? xfs_trans_alloc+0xa1/0xb0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113860]
[<ffffffffa0107acd>] xfs_inactive+0x27d/0x470 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113884]
[<ffffffffa0115dde>] xfs_fs_evict_inode+0x9e/0xf0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113887]
[<ffffffff8117deb4>] evict+0x24/0xc0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113891]
[<ffffffff8117eae7>] iput_final+0x187/0x270
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113894]
[<ffffffff8117ec0b>] iput+0x3b/0x50
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113897]
[<ffffffff8117ae40>] d_kill+0x100/0x140
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113900]
[<ffffffff8117bdf2>] dput+0xd2/0x1b0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113904]
[<ffffffff811666eb>] __fput+0x13b/0x1f0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113908]
[<ffffffff811667c5>] fput+0x25/0x30
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113911]
[<ffffffff811630e0>] filp_close+0x60/0x90
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113914]
[<ffffffff811638e7>] sys_close+0xb7/0x120
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113918]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113921] INFO:
task cron:32735 blocked for more than 120 seconds.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.113973] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114056] cron
      D 0000000000000007     0 32735   1276 0x00000000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114060]
ffff88007ab6fc48 0000000000000082 ffff88007ab6ffd8 ffff88007ab6e000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114065]
0000000000013d00 ffff88062318c858 ffff88007ab6ffd8 0000000000013d00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114069]
ffff880327255b80 ffff88062318c4a0 0000000000000286 ffff8806265d7e00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114073] Call Trace:
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114096]
[<ffffffffa00f42d8>] xlog_grant_log_space+0x4a8/0x500 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114100]
[<ffffffff8105f6f0>] ? default_wake_function+0x0/0x20
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114123]
[<ffffffffa00f61ff>] xfs_log_reserve+0xff/0x140 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114147]
[<ffffffffa01021fc>] xfs_trans_reserve+0x9c/0x200 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114170]
[<ffffffffa0102071>] ? xfs_trans_alloc+0xa1/0xb0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114194]
[<ffffffffa0107acd>] xfs_inactive+0x27d/0x470 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114218]
[<ffffffffa0115dde>] xfs_fs_evict_inode+0x9e/0xf0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114221]
[<ffffffff8117deb4>] evict+0x24/0xc0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114225]
[<ffffffff8117eae7>] iput_final+0x187/0x270
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114228]
[<ffffffff8117ec0b>] iput+0x3b/0x50
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114231]
[<ffffffff8117ae40>] d_kill+0x100/0x140
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114235]
[<ffffffff8117bdf2>] dput+0xd2/0x1b0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114238]
[<ffffffff811666eb>] __fput+0x13b/0x1f0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114242]
[<ffffffff811667c5>] fput+0x25/0x30
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114245]
[<ffffffff811630e0>] filp_close+0x60/0x90
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114249]
[<ffffffff811638e7>] sys_close+0xb7/0x120
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114252]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114255] INFO:
task cron:32736 blocked for more than 120 seconds.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114307] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114390] cron
      D 0000000000000006     0 32736   1276 0x00000000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114394]
ffff88001281bc48 0000000000000082 ffff88001281bfd8 ffff88001281a000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114399]
0000000000013d00 ffff880611094858 ffff88001281bfd8 0000000000013d00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114403]
ffff880327250000 ffff8806110944a0 0000000000000286 ffff8806265d7e00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114407] Call Trace:
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114430]
[<ffffffffa00f42d8>] xlog_grant_log_space+0x4a8/0x500 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114434]
[<ffffffff8105f6f0>] ? default_wake_function+0x0/0x20
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114457]
[<ffffffffa00f61ff>] xfs_log_reserve+0xff/0x140 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114481]
[<ffffffffa01021fc>] xfs_trans_reserve+0x9c/0x200 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114505]
[<ffffffffa0102071>] ? xfs_trans_alloc+0xa1/0xb0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114528]
[<ffffffffa0107acd>] xfs_inactive+0x27d/0x470 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114552]
[<ffffffffa0115dde>] xfs_fs_evict_inode+0x9e/0xf0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114556]
[<ffffffff8117deb4>] evict+0x24/0xc0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114559]
[<ffffffff8117eae7>] iput_final+0x187/0x270
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114562]
[<ffffffff8117ec0b>] iput+0x3b/0x50
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114565]
[<ffffffff8117ae40>] d_kill+0x100/0x140
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114569]
[<ffffffff8117bdf2>] dput+0xd2/0x1b0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114572]
[<ffffffff811666eb>] __fput+0x13b/0x1f0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114576]
[<ffffffff811667c5>] fput+0x25/0x30
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114579]
[<ffffffff811630e0>] filp_close+0x60/0x90
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114582]
[<ffffffff811638e7>] sys_close+0xb7/0x120
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114586]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114589] INFO:
task cron:32737 blocked for more than 120 seconds.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114641] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114724] cron
      D 0000000000000007     0 32737   1276 0x00000000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114728]
ffff88004173dc48 0000000000000086 ffff88004173dfd8 ffff88004173c000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114733]
0000000000013d00 ffff8805df2edf38 ffff88004173dfd8 0000000000013d00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114737]
ffff880327255b80 ffff8805df2edb80 0000000000000286 ffff8806265d7e00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114741] Call Trace:
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114764]
[<ffffffffa00f42d8>] xlog_grant_log_space+0x4a8/0x500 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114768]
[<ffffffff8105f6f0>] ? default_wake_function+0x0/0x20
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114791]
[<ffffffffa00f61ff>] xfs_log_reserve+0xff/0x140 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114818]
[<ffffffffa01021fc>] xfs_trans_reserve+0x9c/0x200 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114841]
[<ffffffffa0102071>] ? xfs_trans_alloc+0xa1/0xb0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114865]
[<ffffffffa0107acd>] xfs_inactive+0x27d/0x470 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114890]
[<ffffffffa0115dde>] xfs_fs_evict_inode+0x9e/0xf0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114894]
[<ffffffff8117deb4>] evict+0x24/0xc0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114897]
[<ffffffff8117eae7>] iput_final+0x187/0x270
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114901]
[<ffffffff8117ec0b>] iput+0x3b/0x50
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114904]
[<ffffffff8117ae40>] d_kill+0x100/0x140
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114907]
[<ffffffff8117bdf2>] dput+0xd2/0x1b0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114910]
[<ffffffff811666eb>] __fput+0x13b/0x1f0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114914]
[<ffffffff811667c5>] fput+0x25/0x30
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114917]
[<ffffffff811630e0>] filp_close+0x60/0x90
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114921]
[<ffffffff811638e7>] sys_close+0xb7/0x120
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114924]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114930] INFO:
task cron:32738 blocked for more than 120 seconds.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.114982] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115065] cron
      D 0000000000000000     0 32738   1276 0x00000000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115069]
ffff88007a7b7c48 0000000000000082 ffff88007a7b7fd8 ffff88007a7b6000
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115073]
0000000000013d00 ffff8805df2ec858 ffff88007a7b7fd8 0000000000013d00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115077]
ffffffff81a0b020 ffff8805df2ec4a0 0000000000000286 ffff8806265d7e00
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115082] Call Trace:
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115105]
[<ffffffffa00f42d8>] xlog_grant_log_space+0x4a8/0x500 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115109]
[<ffffffff8105f6f0>] ? default_wake_function+0x0/0x20
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115132]
[<ffffffffa00f61ff>] xfs_log_reserve+0xff/0x140 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115155]
[<ffffffffa01021fc>] xfs_trans_reserve+0x9c/0x200 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115179]
[<ffffffffa0102071>] ? xfs_trans_alloc+0xa1/0xb0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115203]
[<ffffffffa0107acd>] xfs_inactive+0x27d/0x470 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115226]
[<ffffffffa0115dde>] xfs_fs_evict_inode+0x9e/0xf0 [xfs]
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115230]
[<ffffffff8117deb4>] evict+0x24/0xc0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115234]
[<ffffffff8117eae7>] iput_final+0x187/0x270
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115237]
[<ffffffff8117ec0b>] iput+0x3b/0x50
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115240]
[<ffffffff8117ae40>] d_kill+0x100/0x140
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115243]
[<ffffffff8117bdf2>] dput+0xd2/0x1b0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115247]
[<ffffffff811666eb>] __fput+0x13b/0x1f0
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115250]
[<ffffffff811667c5>] fput+0x25/0x30
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115254]
[<ffffffff811630e0>] filp_close+0x60/0x90
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115257]
[<ffffffff811638e7>] sys_close+0xb7/0x120
May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.115260]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: 765.481915]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481918]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481922]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481925]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481928] cron
      D 0000000000000015     0 14448   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481932]
ffff8803a2007cb8 0000000000000082 ffff8803a2007fd8 ffff8803a2006000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481936]
0000000000013d00 ffff8800a99b5f38 ffff8803a2007fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481941]
ffff8803273b0000 ffff8800a99b5b80 ffff8803a2007cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481945] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481948]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481952]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481956]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481959]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481963]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481967]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481971]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481975]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481978]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481981]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481984] cron
      D 000000000000000e     0 14449   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481988]
ffff88059d3dfcb8 0000000000000086 ffff88059d3dffd8 ffff88059d3de000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481993]
0000000000013d00 ffff88002a974858 ffff88059d3dffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.481997]
ffff88032730adc0 ffff88002a9744a0 ffff88059d3dfcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482001] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482005]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482008]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482012]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482016]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482019]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482023]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482027]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482031]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482034]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482038]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482040] cron
      D 000000000000000d     0 14450   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482045]
ffff8803a4af5cb8 0000000000000082 ffff8803a4af5fd8 ffff8803a4af4000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482049]
0000000000013d00 ffff88002a975f38 ffff8803a4af5fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482053]
ffff8803272d44a0 ffff88002a975b80 ffff8803a4af5cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482057] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482061]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482065]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482068]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482072]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482076]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482079]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482083]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482087]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482091]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482094]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482097] cron
      D 000000000000000f     0 14451   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482101]
ffff8803a9c57cb8 0000000000000086 ffff8803a9c57fd8 ffff8803a9c56000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482105]
0000000000013d00 ffff88008898c858 ffff8803a9c57fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482109]
ffff8803273396e0 ffff88008898c4a0 ffff8803a9c57cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482113] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482117]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482121]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482124]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482128]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482132]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482135]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482140]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482143]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482147]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482150]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482153] cron
      D 0000000000000010     0 14452   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482157]
ffff8804b6779cb8 0000000000000082 ffff8804b6779fd8 ffff8804b6778000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482161]
0000000000013d00 ffff88008898b178 ffff8804b6779fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482165]
ffff880327350000 ffff88008898adc0 ffff8804b6779cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482170] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482173]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482177]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482180]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482184]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482188]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482191]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482196]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482199]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482203]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482206]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482209] cron
      D 000000000000000d     0 14453   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482213]
ffff880423ec9cb8 0000000000000086 ffff880423ec9fd8 ffff880423ec8000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482218]
0000000000013d00 ffff880059245f38 ffff880423ec9fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482222]
ffff8803272d44a0 ffff880059245b80 ffff880423ec9cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482226] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482230]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482233]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482237]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482241]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482244]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482248]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482252]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482256]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482259]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482263]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482265] cron
      D 000000000000000e     0 14454   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482270]
ffff880486261cb8 0000000000000082 ffff880486261fd8 ffff880486260000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482274]
0000000000013d00 ffff88003eb25f38 ffff880486261fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482278]
ffff88032730adc0 ffff88003eb25b80 ffff880486261cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482282] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482286]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482289]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482293]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482297]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482300]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482304]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482308]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482312]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482316]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482319]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482322] cron
      D 000000000000000f     0 14455   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482326]
ffff8803f266fcb8 0000000000000086 ffff8803f266ffd8 ffff8803f266e000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482330]
0000000000013d00 ffff88003eb23178 ffff8803f266ffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482334]
ffff8803273396e0 ffff88003eb22dc0 ffff8803f266fcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482338] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482342]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482345]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482349]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482353]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482357]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482360]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482364]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482368]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482372]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482375]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482378] cron
      D 000000000000000d     0 14456   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482382]
ffff8803ef555cb8 0000000000000082 ffff8803ef555fd8 ffff8803ef554000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482386]
0000000000013d00 ffff88003eb24858 ffff8803ef555fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482390]
ffff8803272d44a0 ffff88003eb244a0 ffff8803ef555cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482394] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482398]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482402]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482405]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482409]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482413]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482416]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482420]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482424]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482428]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482431]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482434] cron
      D 000000000000000e     0 14457   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482438]
ffff880495453cb8 0000000000000086 ffff880495453fd8 ffff880495452000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482442]
0000000000013d00 ffff880033551a98 ffff880495453fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482446]
ffff88032730adc0 ffff8800335516e0 ffff880495453cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482451] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482454]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482458]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482461]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482465]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482469]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482472]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482477]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482480]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482484]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482487]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482490] cron
      D 0000000000000010     0 14458   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482494]
ffff88046f919cb8 0000000000000082 ffff88046f919fd8 ffff88046f918000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482498]
0000000000013d00 ffff880087f49a98 ffff88046f919fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482503]
ffff880327350000 ffff880087f496e0 ffff88046f919cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482507] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482510]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482514]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482518]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482521]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482525]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482528]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482533]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482536]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482540]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482543]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482546] cron
      D 000000000000000d     0 14464   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482550]
ffff88048cff1cb8 0000000000000086 ffff88048cff1fd8 ffff88048cff0000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482554]
0000000000013d00 ffff880087f4c858 ffff88048cff1fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482558]
ffff8803272d44a0 ffff880087f4c4a0 ffff88048cff1cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482563] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482566]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482570]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482573]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482577]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482581]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482584]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482589]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482592]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482596]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482599]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482602] cron
      D 0000000000000015     0 14466   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482606]
ffff8803ee087cb8 0000000000000082 ffff8803ee087fd8 ffff8803ee086000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482610]
0000000000013d00 ffff88007b4603b8 ffff8803ee087fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482614]
ffff8803273b0000 ffff88007b460000 ffff8803ee087cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482619] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482622]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482626]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482630]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482633]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482637]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482640]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482645]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482649]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482652]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482655]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482658] cron
      D 000000000000000d     0 14467   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482662]
ffff880437fb9cb8 0000000000000086 ffff880437fb9fd8 ffff880437fb8000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482667]
0000000000013d00 ffff88007b461a98 ffff880437fb9fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482671]
ffff8803272d44a0 ffff88007b4616e0 ffff880437fb9cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482675] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482678]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482682]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482686]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482689]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482693]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482696]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482701]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482705]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482708]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482711]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482714] mktemp
      D 0000000000000007     0 14490      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482718]
ffff8800abdefdd8 0000000000000082 ffff8800abdeffd8 ffff8800abdee000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482723]
0000000000013d00 ffff8800a185b178 ffff8800abdeffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482727]
ffff880327255b80 ffff8800a185adc0 ffff8800abdefdb8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482731] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482734]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482738]
[<ffffffff811729b7>] ? do_path_lookup+0x87/0x160
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482742]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482745]
[<ffffffff8116f6dd>] lookup_create+0x2d/0xd0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482749]
[<ffffffff81174741>] sys_mkdirat+0x61/0x140
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482753]
[<ffffffff81174838>] sys_mkdir+0x18/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482756]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482759] cron
      D 000000000000000d     0 14491   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482763]
ffff8800345b9cb8 0000000000000086 ffff8800345b9fd8 ffff8800345b8000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482768]
0000000000013d00 ffff88009bee83b8 ffff8800345b9fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482772]
ffff8805dabc2dc0 ffff88009bee8000 ffff8800345b9cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482776] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482779]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482783]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482787]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482791]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482794]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482798]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482802]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482806]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482810]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482813]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482816] if_eth0
      D 0000000000000001     0 14496      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482820]
ffff880007203cb8 0000000000000082 ffff880007203fd8 ffff880007202000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482824]
0000000000013d00 ffff880051b583b8 ffff880007203fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482828]
ffff8803270c8000 ffff880051b58000 ffff880007203cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482832] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482836]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482840]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482843]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482847]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482851]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482854]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482859]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482863]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482867]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482870]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482874]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482877]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482880] if_eth0
      D 0000000000000002     0 14499      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482884]
ffff8800aa88dcb8 0000000000000086 ffff8800aa88dfd8 ffff8800aa88c000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482889]
0000000000013d00 ffff880051b5b178 ffff8800aa88dfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482893]
ffff8803270cdb80 ffff880051b5adc0 ffff8800aa88dcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482897] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482901]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482904]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482908]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482912]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482915]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482919]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482923]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482927]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482931]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482935]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482938]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482942]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482945]
fw_conntrack    D 0000000000000000     0 14562      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482949]
ffff880075443cb8 0000000000000086 ffff880075443fd8 ffff880075442000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482953]
0000000000013d00 ffff88005fc73178 ffff880075443fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482957]
ffffffff81a0b020 ffff88005fc72dc0 ffff880075443cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482961] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482965]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482969]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482972]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482976]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482980]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482983]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482988]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482992]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482995]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.482999]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483003]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483006]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483009]
fw_conntrack    D 0000000000000000     0 14563      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483013]
ffff8800676e9cb8 0000000000000086 ffff8800676e9fd8 ffff8800676e8000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483017]
0000000000013d00 ffff88005fc71a98 ffff8800676e9fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483022]
ffff8806231f5b80 ffff88005fc716e0 ffff8800676e9cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483026] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483029]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483033]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483037]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483040]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483044]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483048]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483052]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483056]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483060]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483064]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483067]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483071]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483074] cron
      D 0000000000000015     0 14634   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483078]
ffff8800677d5cb8 0000000000000086 ffff8800677d5fd8 ffff8800677d4000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483082]
0000000000013d00 ffff88009beedf38 ffff8800677d5fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483087]
ffff8803273b0000 ffff88009beedb80 ffff8800677d5cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483091] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483094]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483098]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483102]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483105]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483109]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483112]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483117]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483121]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483124]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483127]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483130] ipmi_temp
      D 0000000000000001     0 14674      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483135]
ffff88008b0c7cb8 0000000000000082 ffff88008b0c7fd8 ffff88008b0c6000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483139]
0000000000013d00 ffff8800825c03b8 ffff88008b0c7fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483143]
ffff8803270c8000 ffff8800825c0000 ffff88008b0c7cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483147] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483151]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483154]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483158]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483162]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483165]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483169]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483173]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483177]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483181]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483185]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483188]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483192]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483194] ipmi_temp
      D 0000000000000000     0 14676      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483198]
ffff88008485dcb8 0000000000000086 ffff88008485dfd8 ffff88008485c000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483203]
0000000000013d00 ffff8800825c1a98 ffff88008485dfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483207]
ffffffff81a0b020 ffff8800825c16e0 ffff88008485dcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483211] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483215]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483218]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483222]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483226]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483230]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483233]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483237]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483242]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483245]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483249]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483253]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483256]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483259] cron
      D 0000000000000015     0 15139   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483263]
ffff8800692fbcb8 0000000000000086 ffff8800692fbfd8 ffff8800692fa000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483267]
0000000000013d00 ffff88005f1dc858 ffff8800692fbfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483271]
ffff8803273b0000 ffff88005f1dc4a0 ffff8800692fbcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483276] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483279]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483283]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483286]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483290]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483294]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483297]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483302]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483306]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483309]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483312]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483315] cron
      D 000000000000000e     0 15140   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483319]
ffff880062e71cb8 0000000000000082 ffff880062e71fd8 ffff880062e70000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483324]
0000000000013d00 ffff88005f1ddf38 ffff880062e71fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483328]
ffff88032730adc0 ffff88005f1ddb80 ffff880062e71cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483332] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483336]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483339]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483343]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483347]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483350]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483354]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483358]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483362]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483365]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483369]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483371] cron
      D 0000000000000016     0 15141   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483376]
ffff880067db5cb8 0000000000000086 ffff880067db5fd8 ffff880067db4000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483380]
0000000000013d00 ffff88005f1db178 ffff880067db5fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483384]
ffff8803273b5b80 ffff88005f1dadc0 ffff880067db5cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483388] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483392]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483396]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483399]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483403]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483407]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483410]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483414]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483418]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483422]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483425]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483428] cron
      D 000000000000000f     0 15142   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483432]
ffff88001a93bcb8 0000000000000082 ffff88001a93bfd8 ffff88001a93a000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483436]
0000000000013d00 ffff88005f1d9a98 ffff88001a93bfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483440]
ffff8803273396e0 ffff88005f1d96e0 ffff88001a93bcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483444] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483448]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483452]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483455]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483459]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483463]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483466]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483471]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483474]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483478]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483481]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483484] cron
      D 0000000000000015     0 15143   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483488]
ffff8800a71e9cb8 0000000000000086 ffff8800a71e9fd8 ffff8800a71e8000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483492]
0000000000013d00 ffff88005f1d83b8 ffff8800a71e9fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483497]
ffff8803273b0000 ffff88005f1d8000 ffff8800a71e9cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483501] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483504]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483508]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483512]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483515]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483519]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483523]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483527]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483531]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483534]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483537]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483540] cron
      D 000000000000000e     0 15144   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483544]
ffff8800767b9cb8 0000000000000082 ffff8800767b9fd8 ffff8800767b8000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483549]
0000000000013d00 ffff880003303178 ffff8800767b9fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483553]
ffff88032730adc0 ffff880003302dc0 ffff8800767b9cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483557] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483560]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483564]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483568]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483571]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483575]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483579]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483583]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483587]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483590]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483593]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483596] cron
      D 0000000000000016     0 15145   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483600]
ffff88005399dcb8 0000000000000082 ffff88005399dfd8 ffff88005399c000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483605]
0000000000013d00 ffff88009f64c858 ffff88005399dfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483609]
ffff8803273b5b80 ffff88009f64c4a0 ffff88005399dcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483613] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483617]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483620]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483624]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483628]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483631]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483635]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483639]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483643]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483646]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483650]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483652] cron
      D 000000000000000f     0 15146   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483656]
ffff880025ab3cb8 0000000000000086 ffff880025ab3fd8 ffff880025ab2000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483661]
0000000000013d00 ffff88009f649a98 ffff880025ab3fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483665]
ffff8803273396e0 ffff88009f6496e0 ffff880025ab3cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483669] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483673]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483676]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483680]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483684]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483687]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483691]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483695]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483699]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483703]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483706]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483709] cron
      D 000000000000000d     0 15161   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483713]
ffff880098757cb8 0000000000000082 ffff880098757fd8 ffff880098756000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483717]
0000000000013d00 ffff8800a18583b8 ffff880098757fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483721]
ffff8803272d44a0 ffff8800a1858000 ffff880098757cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483725] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483729]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483733]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483736]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483740]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483744]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483747]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483752]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483755]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483759]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483762]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483765] cron
      D 000000000000000e     0 15163   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483769]
ffff880512ef9cb8 0000000000000082 ffff880512ef9fd8 ffff880512ef8000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483773]
0000000000013d00 ffff8800a1859a98 ffff880512ef9fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483777]
ffff88032730adc0 ffff8800a18596e0 ffff880512ef9cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483781] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483785]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483789]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483792]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483796]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483800]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483803]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483808]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483811]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483815]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483818]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483821] cron
      D 0000000000000016     0 15164   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483825]
ffff88035a101cb8 0000000000000086 ffff88035a101fd8 ffff88035a100000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483829]
0000000000013d00 ffff880025465f38 ffff88035a101fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483833]
ffff8803273b5b80 ffff880025465b80 ffff88035a101cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483838] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483841]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483845]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483848]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483852]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483856]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483859]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483864]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483867]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483871]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483874]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483877] cron
      D 000000000000000d     0 15165   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483881]
ffff8800abc29cb8 0000000000000086 ffff8800abc29fd8 ffff8800abc28000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483885]
0000000000013d00 ffff88005fc703b8 ffff8800abc29fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483889]
ffff8803272d44a0 ffff88005fc70000 ffff8800abc29cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483894] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483897]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483901]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483904]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483908]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483912]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483915]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483920]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483923]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483927]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483930]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483933] cron
      D 000000000000000f     0 15166   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483937]
ffff8800776c7cb8 0000000000000086 ffff8800776c7fd8 ffff8800776c6000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483941]
0000000000013d00 ffff8800433583b8 ffff8800776c7fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483946]
ffff8803273396e0 ffff880043358000 ffff8800776c7cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483950] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483953]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483957]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483961]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483964]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483968]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483972]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483976]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483980]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483983]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483986]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483989] cron
      D 000000000000000e     0 15168   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483993]
ffff8800a5ebbcb8 0000000000000082 ffff8800a5ebbfd8 ffff8800a5eba000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.483997]
0000000000013d00 ffff880043359a98 ffff8800a5ebbfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484002]
ffff88032730adc0 ffff8800433596e0 ffff8800a5ebbcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484006] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484009]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484013]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484017]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484020]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484024]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484027]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484032]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484036]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484039]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484042]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484045] cron
      D 000000000000000d     0 15174   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484049]
ffff880098651cb8 0000000000000082 ffff880098651fd8 ffff880098650000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484054]
0000000000013d00 ffff88004335b178 ffff880098651fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484058]
ffff8803272d44a0 ffff88004335adc0 ffff880098651cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484062] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484066]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484069]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484073]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484076]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484080]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484084]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484088]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484092]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484095]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484098]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484101] cron
      D 0000000000000015     0 15175   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484105]
ffff8800651f3cb8 0000000000000082 ffff8800651f3fd8 ffff8800651f2000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484110]
0000000000013d00 ffff88004335c858 ffff8800651f3fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484114]
ffff8803273b0000 ffff88004335c4a0 ffff8800651f3cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484118] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484122]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484126]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484129]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484133]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484137]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484140]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484144]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484148]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484152]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484155]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484158] cron
      D 000000000000000e     0 15176   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484162]
ffff88001d367cb8 0000000000000082 ffff88001d367fd8 ffff88001d366000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484167]
0000000000013d00 ffff88004335df38 ffff88001d367fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484171]
ffff88032730adc0 ffff88004335db80 ffff88001d367cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484175] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484178]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484182]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484186]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484189]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484193]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484197]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484201]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484205]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484208]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484211]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484214] cron
      D 0000000000000016     0 15177   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484218]
ffff8800aa9f9cb8 0000000000000086 ffff8800aa9f9fd8 ffff8800aa9f8000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484223]
0000000000013d00 ffff880090fdc858 ffff8800aa9f9fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484227]
ffff8803273b5b80 ffff880090fdc4a0 ffff8800aa9f9cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484231] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484235]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484238]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484242]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484245]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484249]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484253]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484257]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484261]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484264]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484267]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484270] cron
      D 000000000000000d     0 15178   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484274]
ffff880089ebdcb8 0000000000000082 ffff880089ebdfd8 ffff880089ebc000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484279]
0000000000013d00 ffff880090fd83b8 ffff880089ebdfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484283]
ffff8800327d16e0 ffff880090fd8000 ffff880089ebdcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484287] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484291]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484294]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484298]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484302]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484305]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484309]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484313]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484317]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484321]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484324]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484327] cron
      D 0000000000000015     0 15179   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484331]
ffff880019455cb8 0000000000000086 ffff880019455fd8 ffff880019454000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484335]
0000000000013d00 ffff880090fddf38 ffff880019455fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484339]
ffff8803273b0000 ffff880090fddb80 ffff880019455cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484343] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484347]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484351]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484354]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484358]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484362]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484365]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484370]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484373]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484377]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484380]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484383] cron
      D 000000000000000e     0 15183   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484387]
ffff8800327e7cb8 0000000000000086 ffff8800327e7fd8 ffff8800327e6000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484391]
0000000000013d00 ffff8800327d03b8 ffff8800327e7fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484396]
ffff88032730adc0 ffff8800327d0000 ffff8800327e7cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484400] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484403]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484407]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484411]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484414]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484418]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484421]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484426]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484429]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484433]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484436]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484439] cron
      D 000000000000000d     0 15184   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484443]
ffff880032799cb8 0000000000000086 ffff880032799fd8 ffff880032798000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484447]
0000000000013d00 ffff8800327d1a98 ffff880032799fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484452]
ffff8803272d44a0 ffff8800327d16e0 ffff880032799cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484456] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484459]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484463]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484467]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484470]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484474]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484477]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484482]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484485]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484489]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484492]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484495] cron
      D 000000000000000f     0 15185   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484499]
ffff880032783cb8 0000000000000086 ffff880032783fd8 ffff880032782000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484503]
0000000000013d00 ffff8800327d3178 ffff880032783fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484508]
ffff880027148000 ffff8800327d2dc0 ffff880032783cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484512] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484515]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484519]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484523]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484526]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484530]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484533]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484538]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484541]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484545]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484548]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484551] cron
      D 000000000000000e     0 15186   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484555]
ffff880032729cb8 0000000000000082 ffff880032729fd8 ffff880032728000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484560]
0000000000013d00 ffff8800327d4858 ffff880032729fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484564]
ffff88032730adc0 ffff8800327d44a0 ffff880032729cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484568] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484571]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484575]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484579]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484582]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484586]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484590]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484594]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484598]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484601]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484605]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484607] cron
      D 000000000000000d     0 15187   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484612]
ffff880032709cb8 0000000000000086 ffff880032709fd8 ffff880032708000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484616]
0000000000013d00 ffff8800327d5f38 ffff880032709fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484620]
ffff8803272d44a0 ffff8800327d5b80 ffff880032709cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484624] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484628]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484632]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484635]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484639]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484642]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484646]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484650]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484654]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484658]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484661]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484664] cron
      D 000000000000000f     0 15188   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484668]
ffff8800326abcb8 0000000000000082 ffff8800326abfd8 ffff8800326aa000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484672]
0000000000013d00 ffff8800271483b8 ffff8800326abfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484676]
ffff8803273396e0 ffff880027148000 ffff8800326abcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484680] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484684]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484688]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484691]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484695]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484699]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484702]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484706]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484710]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484714]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484717]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484720] cron
      D 000000000000000e     0 15205   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484724]
ffff880032663cb8 0000000000000086 ffff880032663fd8 ffff880032662000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484728]
0000000000013d00 ffff880027149a98 ffff880032663fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484732]
ffff88032730adc0 ffff8800271496e0 ffff880032663cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484736] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484740]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484743]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484747]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484751]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484754]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484758]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484762]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484766]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484770]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484773]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484776] cron
      D 000000000000000d     0 15206   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484780]
ffff88003264bcb8 0000000000000082 ffff88003264bfd8 ffff88003264a000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484784]
0000000000013d00 ffff88002714b178 ffff88003264bfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484788]
ffff8803272d44a0 ffff88002714adc0 ffff88003264bcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484792] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484796]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484800]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484803]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484807]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484811]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484814]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484818]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484822]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484826]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484829]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484832] cron
      D 000000000000000f     0 15207   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484836]
ffff880032615cb8 0000000000000086 ffff880032615fd8 ffff880032614000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484840]
0000000000013d00 ffff88002714c858 ffff880032615fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484844]
ffff8803273396e0 ffff88002714c4a0 ffff880032615cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484848] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484852]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484856]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484859]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484863]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484867]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484870]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484875]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484878]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484882]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484885]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484888] cron
      D 000000000000000d     0 15216   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484892]
ffff88006bfcfcb8 0000000000000082 ffff88006bfcffd8 ffff88006bfce000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484896]
0000000000013d00 ffff88002714df38 ffff88006bfcffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484901]
ffff8803272d44a0 ffff88002714db80 ffff88006bfcfcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484905] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484908]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484912]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484916]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484919]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484923]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484926]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484931]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484934]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484938]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484941]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484944] cron
      D 0000000000000015     0 15217   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484948]
ffff88007b2ebcb8 0000000000000086 ffff88007b2ebfd8 ffff88007b2ea000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484953]
0000000000013d00 ffff88005d2c03b8 ffff88007b2ebfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484957]
ffff8803273b0000 ffff88005d2c0000 ffff88007b2ebcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484961] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484964]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484968]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484972]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484975]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484979]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484983]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484987]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484991]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484994]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.484997]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485000] mktemp
      D 0000000000000007     0 15243      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485005]
ffff880038b4fdd8 0000000000000082 ffff880038b4ffd8 ffff880038b4e000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485009]
0000000000013d00 ffff88009beeb178 ffff880038b4ffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485013]
ffff880327255b80 ffff88009beeadc0 ffff880038b4fdb8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485017] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485021]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485025]
[<ffffffff811729b7>] ? do_path_lookup+0x87/0x160
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485028]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485032]
[<ffffffff8116f6dd>] lookup_create+0x2d/0xd0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485035]
[<ffffffff81174741>] sys_mkdirat+0x61/0x140
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485040]
[<ffffffff81174838>] sys_mkdir+0x18/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485043]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485046] if_eth0
      D 0000000000000006     0 15253      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485050]
ffff88004b43dcb8 0000000000000082 ffff88004b43dfd8 ffff88004b43c000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485054]
0000000000013d00 ffff88000e82b178 ffff88004b43dfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485058]
ffff880327250000 ffff88000e82adc0 ffff88004b43dcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485063] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485066]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485070]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485073]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485077]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485081]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485084]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485089]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485093]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485097]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485100]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485104]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485107]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485110] cron
      D 0000000000000015     0 15255   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485114]
ffff88001765fcb8 0000000000000082 ffff88001765ffd8 ffff88001765e000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485119]
0000000000013d00 ffff88005d2c1a98 ffff88001765ffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485123]
ffff8805dabc2dc0 ffff88005d2c16e0 ffff88001765fcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485127] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485130]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485134]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485138]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485141]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485145]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485149]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485153]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485157]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485160]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485163]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485166] if_eth0
      D 0000000000000000     0 15256      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485170]
ffff88000bf7fcb8 0000000000000082 ffff88000bf7ffd8 ffff88000bf7e000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485175]
0000000000013d00 ffff88000e82c858 ffff88000bf7ffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485179]
ffffffff81a0b020 ffff88000e82c4a0 ffff88000bf7fcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485183] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485187]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485190]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485194]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485197]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485201]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485205]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485209]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485213]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485217]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485221]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485224]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485228]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485231]
fw_conntrack    D 0000000000000006     0 15311      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485235]
ffff8800195cdcb8 0000000000000082 ffff8800195cdfd8 ffff8800195cc000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485239]
0000000000013d00 ffff88006c1a83b8 ffff8800195cdfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485243]
ffff880087f48000 ffff88006c1a8000 ffff8800195cdcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485247] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485251]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485255]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485258]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485262]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485266]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485269]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485274]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485278]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485282]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485285]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485289]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485292]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485295]
fw_conntrack    D 0000000000000000     0 15314      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485299]
ffff880098ff3cb8 0000000000000086 ffff880098ff3fd8 ffff880098ff2000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485303]
0000000000013d00 ffff88006c1ab178 ffff880098ff3fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485308]
ffffffff81a0b020 ffff88006c1aadc0 ffff880098ff3cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485312] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485315]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485319]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485323]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485326]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485330]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485333]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485338]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485342]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485346]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485349]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485353]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485356]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485359] ipmi_temp
      D 0000000000000007     0 15425      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485363]
ffff8800070d3cb8 0000000000000082 ffff8800070d3fd8 ffff8800070d2000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485368]
0000000000013d00 ffff88009ca65f38 ffff8800070d3fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485372]
ffff880327255b80 ffff88009ca65b80 ffff8800070d3cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485376] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485380]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485383]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485387]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485391]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485394]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485398]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485402]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485406]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485410]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485414]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485417]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485421]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485424] cron
      D 000000000000000d     0 15426   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485428]
ffff88008050bcb8 0000000000000082 ffff88008050bfd8 ffff88008050a000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485432]
0000000000013d00 ffff88005b5f03b8 ffff88008050bfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485436]
ffff8803272d44a0 ffff88005b5f0000 ffff88008050bcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485440] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485444]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485448]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485451]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485455]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485459]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485462]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485467]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485470]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485474]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485477]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485480] ipmi_temp
      D 0000000000000000     0 15427      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485484]
ffff88001a8c7cb8 0000000000000082 ffff88001a8c7fd8 ffff88001a8c6000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485488]
0000000000013d00 ffff88009ca64858 ffff88001a8c7fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485493]
ffffffff81a0b020 ffff88009ca644a0 ffff88001a8c7cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485497] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485500]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485504]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485508]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485511]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485515]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485518]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485523]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485527]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485531]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485534]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485538]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485541]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485544] cron
      D 000000000000000d     0 15889   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485548]
ffff88006936bcb8 0000000000000086 ffff88006936bfd8 ffff88006936a000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485553]
0000000000013d00 ffff88006d8ddf38 ffff88006936bfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485557]
ffff8803272d44a0 ffff88006d8ddb80 ffff88006936bcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485561] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485564]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485568]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485572]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485575]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485579]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485583]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485587]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485591]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485594]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485598]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485601] cron
      D 000000000000000e     0 15890   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485605]
ffff880048603cb8 0000000000000082 ffff880048603fd8 ffff880048602000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485609]
0000000000013d00 ffff88006d8d9a98 ffff880048603fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485613]
ffff88032730adc0 ffff88006d8d96e0 ffff880048603cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485617] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485621]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485624]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485628]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485632]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485635]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485639]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485643]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485647]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485651]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485654]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485657] cron
      D 000000000000000d     0 15896   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485661]
ffff880055683cb8 0000000000000086 ffff880055683fd8 ffff880055682000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485665]
0000000000013d00 ffff88006d8d83b8 ffff880055683fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485669]
ffff8803272d44a0 ffff88006d8d8000 ffff880055683cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485674] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485677]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485681]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485684]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485688]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485692]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485695]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485700]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485703]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485707]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485710]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485713] cron
      D 000000000000000e     0 15897   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485717]
ffff8800a5f53cb8 0000000000000082 ffff8800a5f53fd8 ffff8800a5f52000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485721]
0000000000013d00 ffff88006d8db178 ffff8800a5f53fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485726]
ffff88032730adc0 ffff88006d8dadc0 ffff8800a5f53cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485730] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485733]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485737]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485740]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485744]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485748]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485751]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485756]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485760]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485763]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485766]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485769] cron
      D 0000000000000015     0 15898   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485773]
ffff88001d173cb8 0000000000000086 ffff88001d173fd8 ffff88001d172000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485778]
0000000000013d00 ffff88006d8dc858 ffff88001d173fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485782]
ffff8803273b0000 ffff88006d8dc4a0 ffff88001d173cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485786] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485790]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485793]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485797]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485801]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485804]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485808]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485812]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485816]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485819]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485823]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485825] cron
      D 000000000000000f     0 15899   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485829]
ffff8800ab2dbcb8 0000000000000082 ffff8800ab2dbfd8 ffff8800ab2da000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485834]
0000000000013d00 ffff8800b67303b8 ffff8800ab2dbfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485838]
ffff8803273396e0 ffff8800b6730000 ffff8800ab2dbcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485842] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485846]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485849]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485853]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485857]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485860]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485864]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485868]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485872]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485876]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485879]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485882] cron
      D 000000000000000d     0 15900   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485886]
ffff88004b66bcb8 0000000000000082 ffff88004b66bfd8 ffff88004b66a000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485890]
0000000000013d00 ffff8800b6734858 ffff88004b66bfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485894]
ffff8803272d44a0 ffff8800b67344a0 ffff88004b66bcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485898] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485902]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485906]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485909]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485913]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485917]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485920]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485924]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485928]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485932]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485935]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485938] cron
      D 000000000000000e     0 15901   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485942]
ffff8800a5b17cb8 0000000000000086 ffff8800a5b17fd8 ffff8800a5b16000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485946]
0000000000013d00 ffff8800b6733178 ffff8800a5b17fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485950]
ffff88032730adc0 ffff8800b6732dc0 ffff8800a5b17cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485954] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485958]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485962]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485965]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485969]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485973]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485976]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485981]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485984]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485988]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485991]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485994] nscd
      S 000000000000000c     0 15910      1 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.485998]
ffff88000de21da8 0000000000000086 ffff88000de21fd8 ffff88000de20000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486002]
0000000000013d00 ffff880076564858 ffff88000de21fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486006]
ffff8803272bdb80 ffff8800765644a0 0000000000000000 ffff88000de21ef8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486010] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486014]
[<ffffffff815d685c>] schedule_hrtimeout_range_clock+0x12c/0x170
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486019]
[<ffffffff8108b380>] ? hrtimer_wakeup+0x0/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486023]
[<ffffffff8108beb4>] ? hrtimer_start_range_ns+0x14/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486027]
[<ffffffff815d68b3>] schedule_hrtimeout_range+0x13/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486031]
[<ffffffff811a37c9>] ep_poll+0x1d9/0x320
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486034]
[<ffffffff8105f6f0>] ? default_wake_function+0x0/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486038]
[<ffffffff811a42b5>] sys_epoll_wait+0xc5/0xe0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486042]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486044] nscd
      S 0000000000000002     0 15911      1 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486049]
ffff88002585fcf8 0000000000000086 ffff88002585ffd8 ffff88002585e000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486053]
0000000000013d00 ffff8804ec77df38 ffff88002585ffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486057]
ffff8803270cdb80 ffff8804ec77db80 ffff88002585fe18 ffff88002585fd98
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486061] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486066]
[<ffffffff81099e29>] futex_wait_queue_me+0xc9/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486069]
[<ffffffff8109abb7>] futex_wait+0x1d7/0x300
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486074]
[<ffffffff8108b380>] ? hrtimer_wakeup+0x0/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486078]
[<ffffffff8108beb4>] ? hrtimer_start_range_ns+0x14/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486082]
[<ffffffff8109c747>] do_futex+0xd7/0x210
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486085]
[<ffffffff8109c8fb>] sys_futex+0x7b/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486090]
[<ffffffff815d8aee>] ? do_device_not_available+0xe/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486094]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486097] nscd
      S 0000000000000002     0 15912      1 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486101]
ffff880030fafcf8 0000000000000086 ffff880030faffd8 ffff880030fae000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486105]
0000000000013d00 ffff8804ec77b178 ffff880030faffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486109]
ffff8803270cdb80 ffff8804ec77adc0 ffff880030fafe18 ffff880030fafd98
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486113] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486117]
[<ffffffff81099e29>] futex_wait_queue_me+0xc9/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486120]
[<ffffffff8109abb7>] futex_wait+0x1d7/0x300
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486125]
[<ffffffff8108b380>] ? hrtimer_wakeup+0x0/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486129]
[<ffffffff8108beb4>] ? hrtimer_start_range_ns+0x14/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486133]
[<ffffffff8109c747>] do_futex+0xd7/0x210
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486136]
[<ffffffff8109c8fb>] sys_futex+0x7b/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486140]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486142] nscd
      S 0000000000000001     0 15914      1 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486146]
ffff8800071c9cf8 0000000000000086 ffff8800071c9fd8 ffff8800071c8000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486151]
0000000000013d00 ffff8804ec779a98 ffff8800071c9fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486155]
ffff8803270c8000 ffff8804ec7796e0 ffffffff81099588 ffff8800071c9d98
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486159] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486163]
[<ffffffff81099588>] ? get_futex_value_locked+0x28/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486166]
[<ffffffff81099e29>] futex_wait_queue_me+0xc9/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486170]
[<ffffffff8109abb7>] futex_wait+0x1d7/0x300
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486175]
[<ffffffff81178f6f>] ? __d_free+0x4f/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486179]
[<ffffffff81178ff4>] ? d_free+0x64/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486183]
[<ffffffff811820c8>] ? vfsmount_lock_global_unlock_online+0x58/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486187]
[<ffffffff8109c747>] do_futex+0xd7/0x210
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486190]
[<ffffffff8109c8fb>] sys_futex+0x7b/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486193]
[<ffffffff811667c5>] ? fput+0x25/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486197]
[<ffffffff811630e0>] ? filp_close+0x60/0x90
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486200]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486203] nscd
      S 0000000000000012     0 15918      1 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486207]
ffff880005bf5cf8 0000000000000086 ffff880005bf5fd8 ffff880005bf4000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486212]
0000000000013d00 ffff880088989a98 ffff880005bf5fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486216]
ffff88032736c4a0 ffff8800889896e0 ffffffff81099588 ffff880005bf5d98
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486220] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486223]
[<ffffffff81099588>] ? get_futex_value_locked+0x28/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486227]
[<ffffffff81099e29>] futex_wait_queue_me+0xc9/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486230]
[<ffffffff8109abb7>] futex_wait+0x1d7/0x300
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486235]
[<ffffffff81178f6f>] ? __d_free+0x4f/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486239]
[<ffffffff81178ff4>] ? d_free+0x64/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486243]
[<ffffffff811820c8>] ? vfsmount_lock_global_unlock_online+0x58/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486247]
[<ffffffff8109c747>] do_futex+0xd7/0x210
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486250]
[<ffffffff8109c8fb>] sys_futex+0x7b/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486254]
[<ffffffff811667c5>] ? fput+0x25/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486257]
[<ffffffff811630e0>] ? filp_close+0x60/0x90
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486260]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486263] nscd
      S 0000000000000006     0 15919      1 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486267]
ffff880062ec7cf8 0000000000000086 ffff880062ec7fd8 ffff880062ec6000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486272]
0000000000013d00 ffff88009f64df38 ffff880062ec7fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486276]
ffff880327250000 ffff88009f64db80 ffffffff81099588 ffff880062ec7d98
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486280] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486283]
[<ffffffff81099588>] ? get_futex_value_locked+0x28/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486287]
[<ffffffff81099e29>] futex_wait_queue_me+0xc9/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486291]
[<ffffffff8109abb7>] futex_wait+0x1d7/0x300
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486295]
[<ffffffff81178f6f>] ? __d_free+0x4f/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486299]
[<ffffffff81178ff4>] ? d_free+0x64/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486303]
[<ffffffff811820c8>] ? vfsmount_lock_global_unlock_online+0x58/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486307]
[<ffffffff8109c747>] do_futex+0xd7/0x210
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486310]
[<ffffffff8109c8fb>] sys_futex+0x7b/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486314]
[<ffffffff811667c5>] ? fput+0x25/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486317]
[<ffffffff811630e0>] ? filp_close+0x60/0x90
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486321]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486324] nscd
      S 0000000000000006     0 15920      1 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486328]
ffff88002e25bcf8 0000000000000086 ffff88002e25bfd8 ffff88002e25a000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486332]
0000000000013d00 ffff88009f6483b8 ffff88002e25bfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486336]
ffff880327250000 ffff88009f648000 ffffffff81099588 ffff88002e25bd98
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486340] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486344]
[<ffffffff81099588>] ? get_futex_value_locked+0x28/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486347]
[<ffffffff81099e29>] futex_wait_queue_me+0xc9/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486351]
[<ffffffff8109abb7>] futex_wait+0x1d7/0x300
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486355]
[<ffffffff81178f6f>] ? __d_free+0x4f/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486359]
[<ffffffff81178ff4>] ? d_free+0x64/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486363]
[<ffffffff811820c8>] ? vfsmount_lock_global_unlock_online+0x58/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486367]
[<ffffffff8109c747>] do_futex+0xd7/0x210
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486370]
[<ffffffff8109c8fb>] sys_futex+0x7b/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486374]
[<ffffffff811667c5>] ? fput+0x25/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486377]
[<ffffffff811630e0>] ? filp_close+0x60/0x90
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486381]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486384] cron
      D 000000000000000e     0 15921   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486388]
ffff8800331a1cb8 0000000000000082 ffff8800331a1fd8 ffff8800331a0000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486392]
0000000000013d00 ffff8800b6735f38 ffff8800331a1fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486396]
ffff88032730adc0 ffff8800b6735b80 ffff8800331a1cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486401] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486404]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486408]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486412]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486415]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486419]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486422]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486427]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486431]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486434]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486437]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486440] mktemp
      D 0000000000000001     0 15945      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486445]
ffff8800314f9dd8 0000000000000082 ffff8800314f9fd8 ffff8800314f8000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486449]
0000000000013d00 ffff880050bb5f38 ffff8800314f9fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486453]
ffff8803270c8000 ffff880050bb5b80 ffff8800314f9db8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486457] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486461]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486465]
[<ffffffff811729b7>] ? do_path_lookup+0x87/0x160
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486468]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486472]
[<ffffffff8116f6dd>] lookup_create+0x2d/0xd0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486475]
[<ffffffff81174741>] sys_mkdirat+0x61/0x140
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486480]
[<ffffffff81174838>] sys_mkdir+0x18/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486483]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486486] if_eth0
      D 0000000000000000     0 15950      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486490]
ffff8800a3305cb8 0000000000000086 ffff8800a3305fd8 ffff8800a3304000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486494]
0000000000013d00 ffff880070563178 ffff8800a3305fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486498]
ffffffff81a0b020 ffff880070562dc0 ffff8800a3305cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486503] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486506]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486510]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486514]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486517]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486521]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486525]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486529]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486533]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486537]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486541]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486544]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486548]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486550] cron
      D 0000000000000015     0 15951   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486555]
ffff880099b0bcb8 0000000000000082 ffff880099b0bfd8 ffff880099b0a000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486559]
0000000000013d00 ffff880025463178 ffff880099b0bfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486563]
ffff8803273b0000 ffff880025462dc0 ffff880099b0bcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486567] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486571]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486575]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486578]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486582]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486586]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486589]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486594]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486597]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486601]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486604]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486607] cron
      D 0000000000000016     0 15952   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486611]
ffff8800140d7cb8 0000000000000086 ffff8800140d7fd8 ffff8800140d6000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486615]
0000000000013d00 ffff880025461a98 ffff8800140d7fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486619]
ffff8806232a16e0 ffff8800254616e0 ffff8800140d7cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486624] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486627]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486631]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486634]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486638]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486642]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486645]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486650]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486653]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486657]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486660]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486663] if_eth0
      D 0000000000000000     0 15953      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486667]
ffff88001c485cb8 0000000000000082 ffff88001c485fd8 ffff88001c484000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486672]
0000000000013d00 ffff880070565f38 ffff88001c485fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486676]
ffff880603f32dc0 ffff880070565b80 ffff88001c485cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486680] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486683]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486687]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486691]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486694]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486698]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486702]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486706]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486710]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486714]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486718]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486721]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486724]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486728]
fw_conntrack    D 0000000000000000     0 16003      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486732]
ffff880036cebcb8 0000000000000086 ffff880036cebfd8 ffff880036cea000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486736]
0000000000013d00 ffff88009bee9a98 ffff880036cebfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486740]
ffffffff81a0b020 ffff88009bee96e0 ffff880036cebcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486745] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486748]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486752]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486756]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486759]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486763]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486766]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486771]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486775]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486779]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486782]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486786]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486789]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486792]
fw_conntrack    D 0000000000000006     0 16004      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486796]
ffff88004b91dcb8 0000000000000086 ffff88004b91dfd8 ffff88004b91c000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486801]
0000000000013d00 ffff88009beec858 ffff88004b91dfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486805]
ffff880327250000 ffff88009beec4a0 ffff88004b91dcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486809] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486813]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486816]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486820]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486824]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486827]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486831]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486835]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486839]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486843]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486847]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486850]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486854]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486857] ipmi_temp
      D 0000000000000000     0 16113      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486861]
ffff88002fac7cb8 0000000000000082 ffff88002fac7fd8 ffff88002fac6000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486865]
0000000000013d00 ffff8800765603b8 ffff88002fac7fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486869]
ffff8806210044a0 ffff880076560000 ffff88002fac7cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486873] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486877]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486880]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486884]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486888]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486892]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486895]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486899]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486904]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486907]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486911]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486915]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486918]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486921] cron
      D 000000000000000e     0 16114   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486925]
ffff8800b7753cb8 0000000000000082 ffff8800b7753fd8 ffff8800b7752000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486929]
0000000000013d00 ffff88007618df38 ffff8800b7753fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486934]
ffff88032730adc0 ffff88007618db80 ffff8800b7753cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486938] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486941]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486945]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486949]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486952]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486956]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486960]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486964]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486968]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486971]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486975]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486977] ipmi_temp
      D 0000000000000001     0 16115      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486982]
ffff880010c2fcb8 0000000000000082 ffff880010c2ffd8 ffff880010c2e000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486986]
0000000000013d00 ffff880076563178 ffff880010c2ffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486990]
ffff8803270c8000 ffff880076562dc0 ffff880010c2fcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486994] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.486998]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487001]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487005]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487009]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487012]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487016]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487020]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487024]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487028]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487032]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487035]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487039]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487042]
flush-8:144     S 0000000000000000     0 16585      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487046]
ffff88004b7b3e70 0000000000000046 ffff88004b7b3fd8 ffff88004b7b2000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487050]
0000000000013d00 ffff880063eb9a98 ffff88004b7b3fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487054]
ffff88006d762dc0 ffff880063eb96e0 0000000000000282 ffff880063eb96e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487058] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487063]
[<ffffffff8118c6c9>] bdi_writeback_thread+0x179/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487067]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487070]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487074]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487078]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487081]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487084] cron
      D 000000000000000d     0 16586   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487088]
ffff88006cefdcb8 0000000000000082 ffff88006cefdfd8 ffff88006cefc000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487092]
0000000000013d00 ffff880076189a98 ffff88006cefdfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487097]
ffff8803272d44a0 ffff8800761896e0 ffff88006cefdcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487101] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487104]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487108]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487112]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487115]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487119]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487122]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487127]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487131]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487134]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487137]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487140]
flush-8:16      S 0000000000000009     0 16588      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487144]
ffff88001bf5ddc0 0000000000000046 ffff88001bf5dfd8 ffff88001bf5c000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487149]
0000000000013d00 ffff880063ebc858 ffff88001bf5dfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487153]
ffff880323eeadc0 ffff880063ebc4a0 ffff88001bf5ddc0 ffff88001bf5dde0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487157] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487161]
[<ffffffff815d5ac3>] schedule_timeout+0x173/0x2e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487166]
[<ffffffff81074b10>] ? process_timeout+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487170]
[<ffffffff8118c775>] bdi_writeback_thread+0x225/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487174]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487178]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487181]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487185]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487189]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487191]
flush-8:160     S 000000000000000c     0 16589      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487195]
ffff8800ab3f9dc0 0000000000000046 ffff8800ab3f9fd8 ffff8800ab3f8000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487200]
0000000000013d00 ffff880063ebdf38 ffff8800ab3f9fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487204]
ffff8803272bdb80 ffff880063ebdb80 ffff8800ab3f9dc0 ffff8800ab3f9de0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487208] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487211]
[<ffffffff815d5ac3>] schedule_timeout+0x173/0x2e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487215]
[<ffffffff81074b10>] ? process_timeout+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487220]
[<ffffffff8118c775>] bdi_writeback_thread+0x225/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487224]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487227]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487231]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487234]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487238]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487240]
flush-8:32      S 0000000000000012     0 16591      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487244]
ffff880010d53dc0 0000000000000046 ffff880010d53fd8 ffff880010d52000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487249]
0000000000013d00 ffff88000f979a98 ffff880010d53fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487253]
ffff88032736c4a0 ffff88000f9796e0 ffff880010d53dc0 ffff880010d53de0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487257] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487260]
[<ffffffff815d5ac3>] schedule_timeout+0x173/0x2e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487264]
[<ffffffff81074b10>] ? process_timeout+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487269]
[<ffffffff8118c775>] bdi_writeback_thread+0x225/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487272]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487276]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487279]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487283]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487287]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487289]
flush-8:64      S 0000000000000013     0 16596      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487293]
ffff8801ea13fdc0 0000000000000046 ffff8801ea13ffd8 ffff8801ea13e000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487298]
0000000000013d00 ffff880035654858 ffff8801ea13ffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487302]
ffff880323ef8000 ffff8800356544a0 ffff8801ea13fdc0 ffff8801ea13fde0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487306] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487309]
[<ffffffff815d5ac3>] schedule_timeout+0x173/0x2e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487313]
[<ffffffff81074b10>] ? process_timeout+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487317]
[<ffffffff8118c775>] bdi_writeback_thread+0x225/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487321]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487325]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487328]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487332]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487335]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487338]
flush-8:80      S 0000000000000014     0 16597      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487342]
ffff880110d61e70 0000000000000046 ffff880110d61fd8 ffff880110d60000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487346]
0000000000013d00 ffff880035651a98 ffff880110d61fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487351]
ffff88032738db80 ffff8800356516e0 ffff8800bf4f3d00 ffff8800356516e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487355] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487358]
[<ffffffff8118c6c9>] bdi_writeback_thread+0x179/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487362]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487366]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487370]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487373]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487377]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487379]
flush-251:0     S 0000000000000012     0 16598      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487384]
ffff8801e719ddc0 0000000000000046 ffff8801e719dfd8 ffff8801e719c000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487388]
0000000000013d00 ffff880035655f38 ffff8801e719dfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487392]
ffff880323eec4a0 ffff880035655b80 ffff8801e719ddc0 ffff8801e719dde0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487396] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487400]
[<ffffffff815d5ac3>] schedule_timeout+0x173/0x2e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487404]
[<ffffffff81074b10>] ? process_timeout+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487408]
[<ffffffff8118c775>] bdi_writeback_thread+0x225/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487412]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487415]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487419]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487423]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487426]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487429] cron
      D 000000000000000d     0 16604   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487433]
ffff880185255cb8 0000000000000086 ffff880185255fd8 ffff880185254000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487437]
0000000000013d00 ffff88007618b178 ffff880185255fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487442]
ffff8803272d44a0 ffff88007618adc0 ffff880185255cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487446] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487449]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487453]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487457]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487460]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487464]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487468]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487472]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487476]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487479]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487483]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487486] cron
      D 0000000000000015     0 16605   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487490]
ffff8802b0ee9cb8 0000000000000086 ffff8802b0ee9fd8 ffff8802b0ee8000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487494]
0000000000013d00 ffff88007618c858 ffff8802b0ee9fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487498]
ffff8803273b0000 ffff88007618c4a0 ffff8802b0ee9cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487502] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487506]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487510]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487513]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487517]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487521]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487524]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487529]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487532]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487536]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487539]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487542] cron
      D 000000000000000e     0 16606   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487546]
ffff88011b21dcb8 0000000000000086 ffff88011b21dfd8 ffff88011b21c000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487551]
0000000000013d00 ffff8800761883b8 ffff88011b21dfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487555]
ffff88032730adc0 ffff880076188000 ffff88011b21dcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487559] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487562]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487566]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487570]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487573]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487577]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487581]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487585]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487589]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487592]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487596]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487598] cron
      D 000000000000000d     0 16607   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487603]
ffff88012fed1cb8 0000000000000082 ffff88012fed1fd8 ffff88012fed0000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487607]
0000000000013d00 ffff8800254603b8 ffff88012fed1fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487611]
ffff8803272d44a0 ffff880025460000 ffff88012fed1cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487615] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487619]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487623]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487626]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487630]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487634]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487637]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487644]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487649]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487654]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487659]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487663] cron
      D 0000000000000016     0 16608   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487667]
ffff8802bc651cb8 0000000000000086 ffff8802bc651fd8 ffff8802bc650000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487672]
0000000000013d00 ffff880050bb1a98 ffff8802bc651fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487676]
ffff8803273b5b80 ffff880050bb16e0 ffff8802bc651cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487680] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487684]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487688]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487691]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487695]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487699]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487702]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487707]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487710]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487714]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487717]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487720] cron
      D 000000000000000e     0 16609   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487724]
ffff8802031ddcb8 0000000000000082 ffff8802031ddfd8 ffff8802031dc000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487729]
0000000000013d00 ffff880050bb3178 ffff8802031ddfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487733]
ffff88032730adc0 ffff880050bb2dc0 ffff8802031ddcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487737] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487740]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487744]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487748]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487751]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487755]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487759]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487763]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487767]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487770]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487773]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487776] cron
      D 000000000000000d     0 16610   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487780]
ffff88014caadcb8 0000000000000086 ffff88014caadfd8 ffff88014caac000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487785]
0000000000013d00 ffff880050bb4858 ffff88014caadfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487789]
ffff880326cedb80 ffff880050bb44a0 ffff88014caadcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487793] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487797]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487800]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487804]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487808]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487811]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487815]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487819]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487823]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487827]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487830]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487833] cron
      D 000000000000000f     0 16611   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487837]
ffff88012a41fcb8 0000000000000082 ffff88012a41ffd8 ffff88012a41e000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487841]
0000000000013d00 ffff880050bb03b8 ffff88012a41ffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487846]
ffff8803241badc0 ffff880050bb0000 ffff88012a41fcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487850] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487853]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487857]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487861]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487864]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487868]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487871]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487876]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487879]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487883]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487886]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487889] cron
      D 0000000000000015     0 16612   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487893]
ffff880227201cb8 0000000000000086 ffff880227201fd8 ffff880227200000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487897]
0000000000013d00 ffff88000c8a3178 ffff880227201fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487902]
ffff8803273b0000 ffff88000c8a2dc0 ffff880227201cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487906] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487909]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487913]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487917]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487920]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487924]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487927]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487932]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487936]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487939]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487942]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487945] cron
      D 000000000000000d     0 16613   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487949]
ffff880228513cb8 0000000000000086 ffff880228513fd8 ffff880228512000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487954]
0000000000013d00 ffff880003301a98 ffff880228513fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487958]
ffff8803272d44a0 ffff8800033016e0 ffff880228513cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487962] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487966]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487969]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487973]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487977]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487980]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487984]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487988]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487992]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487996]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.487999]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488002] cron
      D 000000000000000e     0 16614   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488006]
ffff88011b105cb8 0000000000000082 ffff88011b105fd8 ffff88011b104000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488010]
0000000000013d00 ffff88009c595f38 ffff88011b105fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488014]
ffff88032730adc0 ffff88009c595b80 ffff88011b105cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488018] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488022]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488026]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488029]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488033]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488037]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488040]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488045]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488048]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488052]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488055]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488058] cron
      D 000000000000000f     0 16615   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488062]
ffff8801e0725cb8 0000000000000086 ffff8801e0725fd8 ffff8801e0724000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488066]
0000000000013d00 ffff880051b59a98 ffff8801e0725fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488070]
ffff8803273396e0 ffff880051b596e0 ffff8801e0725cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488075] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488078]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488082]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488085]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488089]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488093]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488096]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488101]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488104]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488108]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488111]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488114] cron
      D 0000000000000015     0 16616   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488118]
ffff8802019a5cb8 0000000000000086 ffff8802019a5fd8 ffff8802019a4000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488122]
0000000000013d00 ffff880051b5c858 ffff8802019a5fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488127]
ffff8803273b0000 ffff880051b5c4a0 ffff8802019a5cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488131] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488134]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488138]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488142]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488145]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488149]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488152]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488157]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488161]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488164]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488167]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488170] cron
      D 000000000000000e     0 16617   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488174]
ffff8802dc519cb8 0000000000000082 ffff8802dc519fd8 ffff8802dc518000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488179]
0000000000013d00 ffff880051b5df38 ffff8802dc519fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488183]
ffff88032730adc0 ffff880051b5db80 ffff8802dc519cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488187] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488190]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488194]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488198]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488201]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488205]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488209]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488213]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488217]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488220]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488223]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488226] cron
      D 000000000000000f     0 16618   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488230]
ffff8802fa9c1cb8 0000000000000086 ffff8802fa9c1fd8 ffff8802fa9c0000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488235]
0000000000013d00 ffff880008bec858 ffff8802fa9c1fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488239]
ffff8803273396e0 ffff880008bec4a0 ffff8802fa9c1cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488243] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488247]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488250]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488254]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488258]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488261]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488265]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488269]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488273]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488277]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488280]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488283] cron
      D 0000000000000016     0 16619   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488287]
ffff88011bd1fcb8 0000000000000082 ffff88011bd1ffd8 ffff88011bd1e000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488291]
0000000000013d00 ffff88029bf703b8 ffff88011bd1ffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488295]
ffff8803273b5b80 ffff88029bf70000 ffff88011bd1fcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488300] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488303]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488307]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488310]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488314]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488318]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488321]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488326]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488329]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488333]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488336]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488339]
flush-8:96      S 0000000000000002     0 16621      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488343]
ffff88028a73fe70 0000000000000046 ffff88028a73ffd8 ffff88028a73e000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488347]
0000000000013d00 ffff880035653178 ffff88028a73ffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488352]
ffff8803270cdb80 ffff880035652dc0 0000000000000282 ffff880035652dc0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488356] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488360]
[<ffffffff8118c6c9>] bdi_writeback_thread+0x179/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488364]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488367]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488371]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488375]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488378]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488381]
flush-8:128     S 000000000000000a     0 16624      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488385]
ffff8801bbe61dc0 0000000000000046 ffff8801bbe61fd8 ffff8801bbe60000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488390]
0000000000013d00 ffff88006c1adf38 ffff8801bbe61fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488394]
ffff88043d4d0000 ffff88006c1adb80 ffff8801bbe61dc0 ffff8801bbe61de0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488398] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488401]
[<ffffffff815d5ac3>] schedule_timeout+0x173/0x2e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488406]
[<ffffffff81074b10>] ? process_timeout+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488410]
[<ffffffff8118c775>] bdi_writeback_thread+0x225/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488414]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488417]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488421]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488424]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488428]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488430]
flush-8:176     S 0000000000000006     0 16625      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488434]
ffff8802f4a5de70 0000000000000046 ffff8802f4a5dfd8 ffff8802f4a5c000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488439]
0000000000013d00 ffff88006c1a9a98 ffff8802f4a5dfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488443]
ffff880327250000 ffff88006c1a96e0 ffff88063fd73d00 ffff88006c1a96e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488447] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488451]
[<ffffffff8118c6c9>] bdi_writeback_thread+0x179/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488455]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488458]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488462]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488466]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488469]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488472] cron
      D 000000000000000d     0 16628   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488476]
ffff8802c4f49cb8 0000000000000086 ffff8802c4f49fd8 ffff8802c4f48000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488480]
0000000000013d00 ffff88029bf71a98 ffff8802c4f49fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488484]
ffff8803272d44a0 ffff88029bf716e0 ffff8802c4f49cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488489] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488492]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488496]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488500]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488503]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488507]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488510]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488515]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488519]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488522]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488525]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488528] flush-8:0
      S 000000000000000e     0 16630      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488532]
ffff8802e064ddc0 0000000000000046 ffff8802e064dfd8 ffff8802e064c000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488537]
0000000000013d00 ffff88006c1ac858 ffff8802e064dfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488541]
ffff88032730adc0 ffff88006c1ac4a0 ffff8802e064ddc0 ffff8802e064dde0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488545] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488548]
[<ffffffff815d5ac3>] schedule_timeout+0x173/0x2e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488552]
[<ffffffff81074b10>] ? process_timeout+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488557]
[<ffffffff8118c775>] bdi_writeback_thread+0x225/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488561]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488564]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488568]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488571]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488575]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488577]
flush-8:48      S 0000000000000004     0 16631      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488582]
ffff8801e7cb5dc0 0000000000000046 ffff8801e7cb5fd8 ffff8801e7cb4000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488586]
0000000000013d00 ffff8801001b03b8 ffff8801e7cb5fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488590]
ffff880327220000 ffff8801001b0000 ffff8801e7cb5dc0 ffff8801e7cb5de0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488594] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488598]
[<ffffffff815d5ac3>] schedule_timeout+0x173/0x2e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488602]
[<ffffffff81074b10>] ? process_timeout+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488606]
[<ffffffff8118c775>] bdi_writeback_thread+0x225/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488610]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488613]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488617]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488621]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488624]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488627]
flush-8:112     S 000000000000000e     0 16632      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488631]
ffff880109453e70 0000000000000046 ffff880109453fd8 ffff880109452000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488635]
0000000000013d00 ffff8801001b1a98 ffff880109453fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488639]
ffff8803241bdb80 ffff8801001b16e0 000000000000000e ffff8801001b16e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488644] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488647]
[<ffffffff8118c6c9>] bdi_writeback_thread+0x179/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488651]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488655]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488658]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488662]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488666]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488668] sshd
      S 0000000000000006     0 16633  29861 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488673]
ffff88006be9bae8 0000000000000086 ffff88006be9bfd8 ffff88006be9a000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488677]
0000000000013d00 ffff8800249a5f38 ffff88006be9bfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488681]
ffff880327250000 ffff8800249a5b80 ffff88006be9bae8 ffff8800357071c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488685] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488689]
[<ffffffff815d5bbd>] schedule_timeout+0x26d/0x2e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488694]
[<ffffffff814dc5aa>] ? __scm_destroy+0xda/0x110
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488697]
[<ffffffff81038c79>] ? default_spin_lock_flags+0x9/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488703]
[<ffffffff8156d142>] unix_stream_data_wait+0xa2/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488707]
[<ffffffff81087940>] ? autoremove_wake_function+0x0/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488711]
[<ffffffff8156fe65>] unix_stream_recvmsg+0x3c5/0x650
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488715]
[<ffffffff81168a7d>] ? cdev_get+0x2d/0xb0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488719]
[<ffffffff8116f333>] ? generic_permission+0x23/0xc0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488724]
[<ffffffff814cd904>] sock_aio_read+0x164/0x170
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488728]
[<ffffffff81164c82>] do_sync_read+0xd2/0x110
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488733]
[<ffffffff81279083>] ? security_file_permission+0x93/0xb0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488737]
[<ffffffff81164fa1>] ? rw_verify_area+0x61/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488741]
[<ffffffff81165507>] vfs_read+0x167/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488744]
[<ffffffff81165571>] sys_read+0x51/0x90
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488748]
[<ffffffff815d8aee>] ? do_device_not_available+0xe/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488752]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488754] sshd
      S 0000000000000014     0 16648  16633 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488758]
ffff88000de438f8 0000000000000082 ffff88000de43fd8 ffff88000de42000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488763]
0000000000013d00 ffff88006a50c858 ffff88000de43fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488767]
ffff8803273996e0 ffff88006a50c4a0 ffff88000de43ac8 0000000000000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488771] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488775]
[<ffffffff815d687d>] schedule_hrtimeout_range_clock+0x14d/0x170
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488779]
[<ffffffff8104e4c3>] ? __wake_up+0x53/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488783]
[<ffffffff815d68b3>] schedule_hrtimeout_range+0x13/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488787]
[<ffffffff81177389>] poll_schedule_timeout+0x49/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488791]
[<ffffffff81177e8e>] do_select+0x4ae/0x5f0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488796]
[<ffffffff8151b1c7>] ? ip_finish_output+0x157/0x320
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488801]
[<ffffffff81177460>] ? __pollwait+0x0/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488804]
[<ffffffff81177550>] ? pollwake+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488808]
[<ffffffff81177550>] ? pollwake+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488812]
[<ffffffff81177550>] ? pollwake+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488816]
[<ffffffff81177550>] ? pollwake+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488819]
[<ffffffff815d76b9>] ? _raw_spin_unlock_bh+0x19/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488823]
[<ffffffff814d3aca>] ? release_sock+0xfa/0x120
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488827]
[<ffffffff8152744f>] ? tcp_recvmsg+0x5ff/0xbb0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488831]
[<ffffffff8105f554>] ? try_to_wake_up+0x244/0x3e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488834]
[<ffffffff8105f702>] ? default_wake_function+0x12/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488839]
[<ffffffff8104bb39>] ? __wake_up_common+0x59/0x90
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488843]
[<ffffffff8117817c>] core_sys_select+0x1ac/0x2f0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488847]
[<ffffffff8104e4c3>] ? __wake_up+0x53/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488851]
[<ffffffff8119e10d>] ? fsnotify+0x1cd/0x2e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488858]
[<ffffffff813893fb>] ? put_ldisc+0x5b/0xc0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488862]
[<ffffffff8117848f>] sys_select+0x3f/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488866]
[<ffffffff81165601>] ? sys_write+0x51/0x90
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488869]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488872] bash
      S 0000000000000014     0 16649  16648 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488876]
ffff880067683e68 0000000000000086 ffff880067683fd8 ffff880067682000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488881]
0000000000013d00 ffff880022013178 ffff880067683fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488885]
ffff8803273996e0 ffff880022012dc0 ffff880067683e68 0000000000000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488889] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488893]
[<ffffffff81069705>] do_wait+0x1d5/0x270
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488897]
[<ffffffff81064e9a>] ? do_fork+0xca/0x330
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488901]
[<ffffffff8106aac3>] sys_wait4+0xa3/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488905]
[<ffffffff81067f30>] ? child_wait_callback+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488909]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488912] cron
      D 0000000000000016     0 16700   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488916]
ffff8802ccc1fcb8 0000000000000082 ffff8802ccc1ffd8 ffff8802ccc1e000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488920]
0000000000013d00 ffff88029bf75f38 ffff8802ccc1ffd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488925]
ffff8803273b5b80 ffff88029bf75b80 ffff8802ccc1fcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488929] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488932]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488936]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488940]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488943]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488947]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488951]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488955]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488959]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488962]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488966]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488969]
flush-251:3     S 0000000000000002     0 16702      2 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488973]
ffff88010ce87e70 0000000000000046 ffff88010ce87fd8 ffff88010ce86000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488977]
0000000000013d00 ffff8801001b3178 ffff88010ce87fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488981]
ffff8800191c96e0 ffff8801001b2dc0 000000000000000f ffff8801001b2dc0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488985] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488989]
[<ffffffff8118c6c9>] bdi_writeback_thread+0x179/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488993]
[<ffffffff8118c550>] ? bdi_writeback_thread+0x0/0x260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.488997]
[<ffffffff810871f6>] kthread+0x96/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489000]
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489004]
[<ffffffff81087160>] ? kthread+0x0/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489008]
[<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489010] mktemp
      D 0000000000000003     0 16725      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489014]
ffff8801ec269dd8 0000000000000086 ffff8801ec269fd8 ffff8801ec268000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489019]
0000000000013d00 ffff880023f94858 ffff8801ec269fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489023]
ffff880603f316e0 ffff880023f944a0 ffff8801ec269db8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489027] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489030]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489034]
[<ffffffff811729b7>] ? do_path_lookup+0x87/0x160
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489038]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489041]
[<ffffffff8116f6dd>] lookup_create+0x2d/0xd0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489045]
[<ffffffff81174741>] sys_mkdirat+0x61/0x140
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489049]
[<ffffffff81174838>] sys_mkdir+0x18/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489052]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489055] if_eth0
      D 0000000000000006     0 16732      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489060]
ffff8802aec51cb8 0000000000000082 ffff8802aec51fd8 ffff8802aec50000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489064]
0000000000013d00 ffff8800705603b8 ffff8802aec51fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489068]
ffff880327250000 ffff880070560000 ffff8802aec51cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489072] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489076]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489079]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489083]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489087]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489090]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489094]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489098]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489103]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489106]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489110]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489114]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489117]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489120] if_eth0
      D 0000000000000006     0 16733      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489124]
ffff880224d9bcb8 0000000000000086 ffff880224d9bfd8 ffff880224d9a000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489128]
0000000000013d00 ffff880070564858 ffff880224d9bfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489133]
ffff880327250000 ffff8800705644a0 ffff880224d9bcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489137] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489140]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489144]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489148]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489151]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489155]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489159]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489163]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489167]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489171]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489175]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489178]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489181]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489184] sshd
      S 0000000000000006     0 16734  29861 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489189]
ffff880136d57ae8 0000000000000082 ffff880136d57fd8 ffff880136d56000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489193]
0000000000013d00 ffff88008094df38 ffff880136d57fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489197]
ffff880327250000 ffff88008094db80 ffff880136d57ae8 ffff8803238c4780
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489201] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489205]
[<ffffffff815d5bbd>] schedule_timeout+0x26d/0x2e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489208]
[<ffffffff814dc5aa>] ? __scm_destroy+0xda/0x110
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489212]
[<ffffffff81038c79>] ? default_spin_lock_flags+0x9/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489216]
[<ffffffff8156d142>] unix_stream_data_wait+0xa2/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489220]
[<ffffffff81087940>] ? autoremove_wake_function+0x0/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489225]
[<ffffffff8156fe65>] unix_stream_recvmsg+0x3c5/0x650
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489228]
[<ffffffff81168a7d>] ? cdev_get+0x2d/0xb0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489233]
[<ffffffff8116f333>] ? generic_permission+0x23/0xc0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489236]
[<ffffffff814cd904>] sock_aio_read+0x164/0x170
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489241]
[<ffffffff81164c82>] do_sync_read+0xd2/0x110
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489245]
[<ffffffff81279083>] ? security_file_permission+0x93/0xb0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489249]
[<ffffffff81164fa1>] ? rw_verify_area+0x61/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489253]
[<ffffffff81165507>] vfs_read+0x167/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489256]
[<ffffffff81165571>] sys_read+0x51/0x90
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489260]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489263] sshd
      S 0000000000000013     0 16749  16734 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489267]
ffff8802b0e598f8 0000000000000086 ffff8802b0e59fd8 ffff8802b0e58000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489271]
0000000000013d00 ffff88002335b178 ffff8802b0e59fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489275]
ffff88032738adc0 ffff88002335adc0 ffff8802b0e59ac8 0000000000000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489279] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489283]
[<ffffffff815d687d>] schedule_hrtimeout_range_clock+0x14d/0x170
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489287]
[<ffffffff8104e4c3>] ? __wake_up+0x53/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489291]
[<ffffffff815d68b3>] schedule_hrtimeout_range+0x13/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489295]
[<ffffffff81177389>] poll_schedule_timeout+0x49/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489299]
[<ffffffff81177e8e>] do_select+0x4ae/0x5f0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489303]
[<ffffffff8151b1c7>] ? ip_finish_output+0x157/0x320
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489307]
[<ffffffff81177460>] ? __pollwait+0x0/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489311]
[<ffffffff81177550>] ? pollwake+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489315]
[<ffffffff81177550>] ? pollwake+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489318]
[<ffffffff81177550>] ? pollwake+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489322]
[<ffffffff81177550>] ? pollwake+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489326]
[<ffffffff815d76b9>] ? _raw_spin_unlock_bh+0x19/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489330]
[<ffffffff814d3aca>] ? release_sock+0xfa/0x120
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489333]
[<ffffffff815259cc>] ? tcp_sendmsg+0x7fc/0xc50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489338]
[<ffffffff8154a904>] ? inet_sendmsg+0x64/0xb0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489345]
[<ffffffff812accd7>] ? apparmor_socket_sendmsg+0x17/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489348]
[<ffffffff814cd78e>] ? sock_aio_write+0x14e/0x160
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489353]
[<ffffffff8117817c>] core_sys_select+0x1ac/0x2f0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489357]
[<ffffffff81164b72>] ? do_sync_write+0xd2/0x110
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489361]
[<ffffffff8119e10d>] ? fsnotify+0x1cd/0x2e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489365]
[<ffffffff8117848f>] sys_select+0x3f/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489369]
[<ffffffff81165601>] ? sys_write+0x51/0x90
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489372]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489375] bash
      S 0000000000000002     0 16750  16749 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489379]
ffff8802301d1e68 0000000000000086 ffff8802301d1fd8 ffff8802301d0000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489384]
0000000000013d00 ffff880022011a98 ffff8802301d1fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489388]
ffff8803270cdb80 ffff8800220116e0 ffff8802301d1e68 0000000000000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489392] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489396]
[<ffffffff81069705>] do_wait+0x1d5/0x270
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489400]
[<ffffffff81064e9a>] ? do_fork+0xca/0x330
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489404]
[<ffffffff8106aac3>] sys_wait4+0xa3/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489408]
[<ffffffff81067f30>] ? child_wait_callback+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489411]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489414]
fw_conntrack    D 0000000000000012     0 16849      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489418]
ffff880221125cb8 0000000000000086 ffff880221125fd8 ffff880221124000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489423]
0000000000013d00 ffff880066501a98 ffff880221125fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489427]
ffff88032736c4a0 ffff8800665016e0 ffff880221125cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489431] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489435]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489438]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489442]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489446]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489449]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489453]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489457]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489461]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489465]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489469]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489473]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489476]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489479]
fw_conntrack    D 0000000000000007     0 16850      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489483]
ffff8801efd29cb8 0000000000000086 ffff8801efd29fd8 ffff8801efd28000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489488]
0000000000013d00 ffff880066503178 ffff8801efd29fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489492]
ffff880327255b80 ffff880066502dc0 ffff8801efd29cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489496] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489499]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489503]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489507]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489510]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489514]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489518]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489522]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489526]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489530]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489534]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489537]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489540]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489544] cron
      D 0000000000000015     0 16851   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489548]
ffff88042558bcb8 0000000000000082 ffff88042558bfd8 ffff88042558a000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489552]
0000000000013d00 ffff88029bf74858 ffff88042558bfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489556]
ffff8803273b0000 ffff88029bf744a0 ffff88042558bcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489560] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489564]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489568]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489571]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489575]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489579]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489582]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489587]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489590]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489594]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489597]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489600] cron
      D 000000000000000e     0 16852   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489604]
ffff880567523cb8 0000000000000086 ffff880567523fd8 ffff880567522000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489608]
0000000000013d00 ffff88029bf73178 ffff880567523fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489613]
ffff88032730adc0 ffff88029bf72dc0 ffff880567523cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489617] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489620]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489624]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489627]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489631]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489635]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489638]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489643]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489646]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489650]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489653]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489656] sudo
      S 0000000000000008     0 16858  16750 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489660]
ffff88011f2238f8 0000000000000086 ffff88011f223fd8 ffff88011f222000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489665]
0000000000013d00 ffff880023f95f38 ffff88011f223fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489669]
ffff88032727c4a0 ffff880023f95b80 ffff88063fc56f20 0000000000000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489673] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489677]
[<ffffffff815d687d>] schedule_hrtimeout_range_clock+0x14d/0x170
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489681]
[<ffffffff81087d3e>] ? add_wait_queue+0x4e/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489685]
[<ffffffff811774d5>] ? __pollwait+0x75/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489688]
[<ffffffff815d68b3>] schedule_hrtimeout_range+0x13/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489692]
[<ffffffff81177389>] poll_schedule_timeout+0x49/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489696]
[<ffffffff81177e8e>] do_select+0x4ae/0x5f0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489701]
[<ffffffff81177460>] ? __pollwait+0x0/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489705]
[<ffffffff81177550>] ? pollwake+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489709]
[<ffffffff81113958>] ? __alloc_pages_nodemask+0x118/0x830
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489715]
[<ffffffff812da0ed>] ? cpumask_any_but+0x2d/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489718]
[<ffffffff81045a18>] ? flush_tlb_page+0x48/0xb0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489722]
[<ffffffff81117ffd>] ? lru_cache_add_lru+0x2d/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489727]
[<ffffffff81139c5d>] ? page_add_new_anon_rmap+0x8d/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489730]
[<ffffffff8112dd58>] ? do_wp_page+0x408/0x770
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489735]
[<ffffffff8117817c>] core_sys_select+0x1ac/0x2f0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489739]
[<ffffffff8104dea6>] ? enqueue_task+0x66/0x80
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489743]
[<ffffffff815db5b8>] ? do_page_fault+0x258/0x540
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489747]
[<ffffffff81064e9a>] ? do_fork+0xca/0x330
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489751]
[<ffffffff8117848f>] sys_select+0x3f/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489754]
[<ffffffff815d7f95>] ? page_fault+0x25/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489758]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489761] tail
      S 0000000000000000     0 16859  16858 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489765]
ffff880593473e58 0000000000000082 ffff880593473fd8 ffff880593472000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489769]
0000000000013d00 ffff88007b465f38 ffff880593473fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489774]
ffffffff81a0b020 ffff88007b465b80 ffff880323aa4310 ffff880060365800
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489778] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489782]
[<ffffffff811a0e37>] inotify_read+0xc7/0x1e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489786]
[<ffffffff81087940>] ? autoremove_wake_function+0x0/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489790]
[<ffffffff81165463>] vfs_read+0xc3/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489793]
[<ffffffff81165571>] sys_read+0x51/0x90
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489796]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489799] ipmi_temp
      D 0000000000000000     0 16964      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489804]
ffff8802bea3dcb8 0000000000000082 ffff8802bea3dfd8 ffff8802bea3c000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489808]
0000000000013d00 ffff88002335df38 ffff8802bea3dfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489812]
ffffffff81a0b020 ffff88002335db80 ffff8802bea3dcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489816] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489820]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489824]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489828]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489831]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489835]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489838]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489843]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489847]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489851]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489854]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489858]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489861]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489864] ipmi_temp
      D 0000000000000007     0 16966      1 0x00000004
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489868]
ffff8802a0abbcb8 0000000000000086 ffff8802a0abbfd8 ffff8802a0aba000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489873]
0000000000013d00 ffff8800233583b8 ffff8802a0abbfd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489877]
ffff880327255b80 ffff880023358000 ffff8802a0abbcf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489881] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489884]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489888]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489892]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489895]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489899]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489903]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489907]
[<ffffffff8118183e>] ? vfsmount_lock_local_unlock+0x1e/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489911]
[<ffffffff81183436>] ? mntput_no_expire+0x36/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489915]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489919]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489922]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489926]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489928] cron
      D 000000000000000d     0 17481   1276 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489932]
ffff88055a633cb8 0000000000000082 ffff88055a633fd8 ffff88055a632000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489937]
0000000000013d00 ffff88007b464858 ffff88055a633fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489941]
ffff8803272d44a0 ffff88007b4644a0 ffff88055a633cf8 ffff88033f7d71b8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489945] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489949]
[<ffffffff815d6537>] __mutex_lock_slowpath+0xf7/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489952]
[<ffffffff812797d0>] ? security_inode_exec_permission+0x30/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489956]
[<ffffffff815d5f23>] mutex_lock+0x23/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489960]
[<ffffffff811739a8>] do_last+0x118/0x410
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489963]
[<ffffffff81174032>] do_filp_open+0x392/0x7c0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489967]
[<ffffffff8113135d>] ? handle_mm_fault+0x16d/0x250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489971]
[<ffffffff811810f7>] ? alloc_fd+0xf7/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489975]
[<ffffffff8116474a>] do_sys_open+0x6a/0x150
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489979]
[<ffffffff81164850>] sys_open+0x20/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489982]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489985] sudo
      S 0000000000000007     0 17486  16649 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489989]
ffff880552dd18f8 0000000000000086 ffff880552dd1fd8 ffff880552dd0000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489993]
0000000000013d00 ffff88001ec49a98 ffff880552dd1fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.489997]
ffff880327255b80 ffff88001ec496e0 ffff88063fc36f20 0000000000000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490001] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490005]
[<ffffffff815d687d>] schedule_hrtimeout_range_clock+0x14d/0x170
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490009]
[<ffffffff81087d3e>] ? add_wait_queue+0x4e/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490013]
[<ffffffff811774d5>] ? __pollwait+0x75/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490017]
[<ffffffff815d68b3>] schedule_hrtimeout_range+0x13/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490021]
[<ffffffff81177389>] poll_schedule_timeout+0x49/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490025]
[<ffffffff81177e8e>] do_select+0x4ae/0x5f0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490029]
[<ffffffff81177460>] ? __pollwait+0x0/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490033]
[<ffffffff81177550>] ? pollwake+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490037]
[<ffffffff81113958>] ? __alloc_pages_nodemask+0x118/0x830
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490042]
[<ffffffff812da0ed>] ? cpumask_any_but+0x2d/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490045]
[<ffffffff81045a18>] ? flush_tlb_page+0x48/0xb0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490049]
[<ffffffff81117ffd>] ? lru_cache_add_lru+0x2d/0x50
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490053]
[<ffffffff81139c5d>] ? page_add_new_anon_rmap+0x8d/0xa0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490056]
[<ffffffff8112dd58>] ? do_wp_page+0x408/0x770
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490061]
[<ffffffff8117817c>] core_sys_select+0x1ac/0x2f0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490064]
[<ffffffff8104dea6>] ? enqueue_task+0x66/0x80
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490068]
[<ffffffff815db5b8>] ? do_page_fault+0x258/0x540
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490072]
[<ffffffff81064e9a>] ? do_fork+0xca/0x330
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490076]
[<ffffffff8117848f>] sys_select+0x3f/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490080]
[<ffffffff815d7f95>] ? page_fault+0x25/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490083]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490086] bash
      R  running task        0 17487  17486 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490090]
ffff88059e7efcd8 ffff88059e7efca9 353637393832365b 5d3039303039342e
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490095]
0000000000000020 0000000000000021 0000000000000001 ffff88059e7efd08
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490099]
0000000000000034 00000000d5bd0400 ffff88059e7efd78 ffff88009f798000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490103] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490106]
[<ffffffff8100ec30>] ? dump_trace+0x1f0/0x3a0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490111]
[<ffffffff8100ffc5>] show_trace_log_lvl+0x55/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490115]
[<ffffffff8100ee7a>] show_stack_log_lvl+0x9a/0x160
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490118]
[<ffffffff8101001a>] show_stack+0x1a/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490122]
[<ffffffff810615a8>] sched_show_task+0x98/0x100
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490125]
[<ffffffff8106168e>] show_state_filter+0x7e/0xc0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490130]
[<ffffffff8138d020>] sysrq_handle_showstate+0x10/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490134]
[<ffffffff8138d509>] __handle_sysrq+0x129/0x190
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490138]
[<ffffffff8138d570>] ? write_sysrq_trigger+0x0/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490141]
[<ffffffff8138d5ad>] write_sysrq_trigger+0x3d/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490146]
[<ffffffff811bfcbf>] proc_reg_write+0x7f/0xc0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490150]
[<ffffffff811652e6>] vfs_write+0xc6/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490153]
[<ffffffff81165601>] sys_write+0x51/0x90
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490157]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490160]
swift-object-up S 0000000000000009     0 17544  11858 0x00000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490163]
ffff8801e44c59f8 0000000000000082 ffff8801e44c5fd8 ffff8801e44c4000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490168]
0000000000013d00 ffff8800377f9a98 ffff8801e44c5fd8 0000000000013d00
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490172]
ffff88032728adc0 ffff8800377f96e0 0000000000000000 ffff8801e44c5b38
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490176] Call Trace:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490180]
[<ffffffff815d685c>] schedule_hrtimeout_range_clock+0x12c/0x170
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490184]
[<ffffffff8108b380>] ? hrtimer_wakeup+0x0/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490188]
[<ffffffff8108beb4>] ? hrtimer_start_range_ns+0x14/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490192]
[<ffffffff815d68b3>] schedule_hrtimeout_range+0x13/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490196]
[<ffffffff81177389>] poll_schedule_timeout+0x49/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490201]
[<ffffffff8117788a>] do_poll.clone.2+0x1ca/0x290
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490205]
[<ffffffff81178789>] do_sys_poll+0x1b9/0x230
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490209]
[<ffffffff81177460>] ? __pollwait+0x0/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490213]
[<ffffffff81177550>] ? pollwake+0x0/0x60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490216]
[<ffffffff8151b469>] ? ip_local_out+0x29/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490220]
[<ffffffff8151b5e9>] ? ip_queue_xmit+0x179/0x3f0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490224]
[<ffffffff8151fe21>] ? __inet_hash_nolisten+0x131/0x180
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490230]
[<ffffffff81536780>] ? tcp_v4_md5_lookup+0x10/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490233]
[<ffffffff81038c79>] ? default_spin_lock_flags+0x9/0x10
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490237]
[<ffffffff815d794f>] ? _raw_spin_lock_irqsave+0x2f/0x40
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490241]
[<ffffffff81074ceb>] ? lock_timer_base.clone.20+0x3b/0x70
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490246]
[<ffffffff81076624>] ? mod_timer+0x144/0x2b0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490250]
[<ffffffff814d250c>] ? sk_reset_timer+0x1c/0x30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490254]
[<ffffffff81533e6f>] ? tcp_connect+0x1bf/0x200
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490258]
[<ffffffff81538e61>] ? tcp_v4_connect+0x451/0x560
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490263]
[<ffffffff815d76b9>] ? _raw_spin_unlock_bh+0x19/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490266]
[<ffffffff814d3aca>] ? release_sock+0xfa/0x120
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490270]
[<ffffffff8154a4ca>] ? inet_stream_connect+0x7a/0x1e0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490275]
[<ffffffff810137e9>] ? read_tsc+0x9/0x20
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490280]
[<ffffffff810927e1>] ? ktime_get_ts+0xb1/0xf0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490284]
[<ffffffff811779d2>] ? poll_select_set_timeout+0x82/0x90
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490288]
[<ffffffff811788e6>] sys_poll+0x76/0x110
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490292]
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490296] Sched
Debug Version: v0.10, 2.6.38-8-server #42-Ubuntu
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490299] ktime
                              : 6306067582.666011
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490301] sched_clk
                              : 6289765490.294713
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490304] cpu_clk
                              : 6289765490.294802
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490306] jiffies
                              : 4925544054
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490308]
sched_clock_stable                      : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490310]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490311] sysctl_sched
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490313]
.sysctl_sched_latency                    : 24.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490315]
.sysctl_sched_min_granularity            : 3.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490317]
.sysctl_sched_wakeup_granularity         : 4.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490320]
.sysctl_sched_child_runs_first           : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490322]
.sysctl_sched_features                   : 7279
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490324]
.sysctl_sched_tunable_scaling            : 1 (logaritmic)
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490328]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490328] cpu#0, 2666.66=
9 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490330]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490332]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490334]
.nr_switches                   : 13269177245
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490336]
.nr_load_updates               : 630550527
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490338]
.nr_uninterruptible            : 123
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490341]
.next_balance                  : 4925.544055
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490343]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490345]   .clock
                       : 6289765487.703822
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490347]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490349]
.cpu_load[1]                   : 6
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490351]
.cpu_load[2]                   : 48
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490352]
.cpu_load[3]                   : 76
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490354]
.cpu_load[4]                   : 74
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490356]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490358]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490360]
.sched_count                   : 653616048
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490362]
.sched_goidle                  : -82094772
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490364]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490366]
.ttwu_count                    : 1414739666
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490368]
.ttwu_local                    : -1969906404
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490370]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490374]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490374]
cfs_rq[0]:/autogroup-414266
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490376]
.exec_clock                    : 50383101.638139
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490379]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490381]
.min_vruntime                  : 43883530.906718
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490384]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490386]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490388]
.spread0                       : -5231875277.660282
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490390]
.nr_spread_over                : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490392]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490394]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490396]
.load_avg                      : 12.118707
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490399]
.load_period                   : 9.069581
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490401]
.load_contrib                  : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490403]
.load_tg                       : 5
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490405]
.se->exec_start                : 6289765436.243793
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490408]
.se->vruntime                  : 5275758784.716051
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490410]
.se->sum_exec_runtime          : 50367570.709334
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490413]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490415]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490417]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490419]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490421]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490424]
.se->statistics.exec_max       : 32.017135
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490426]
.se->statistics.slice_max      : 11.398645
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490428]
.se->statistics.wait_max       : 34.226799
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490430]
.se->statistics.wait_sum       : 1617848.631238
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490432]
.se->statistics.wait_count     : 104229844
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490435]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490437]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490438]
cfs_rq[0]:/autogroup-414268
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490440]
.exec_clock                    : 775955772.742699
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490443]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490445]
.min_vruntime                  : 448560870.484090
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490447]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490449]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490451]
.spread0                       : -4827197938.082910
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490454]
.nr_spread_over                : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490456]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490458]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490460]
.load_avg                      : 384.499191
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490462]
.load_period                   : 9.106361
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490464]
.load_contrib                  : 42
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490466]
.load_tg                       : 4879
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490469]
.se->exec_start                : 6289765486.357642
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490471]
.se->vruntime                  : 5275758797.951477
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490473]
.se->sum_exec_runtime          : 775925136.170860
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490476]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490478]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490480]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490482]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490484]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490486]
.se->statistics.exec_max       : 45.560735
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490489]
.se->statistics.slice_max      : 13.265967
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490491]
.se->statistics.wait_max       : 49.549283
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490493]
.se->statistics.wait_sum       : 33100642.218701
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490495]
.se->statistics.wait_count     : 2153050423
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490498]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490500]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490501]
cfs_rq[0]:/autogroup-414269
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490503]
.exec_clock                    : 271299383.906867
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490505]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490507]
.min_vruntime                  : 87857192.784002
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490510]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490512]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490514]
.spread0                       : -5187901615.782998
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490516]
.nr_spread_over                : 15
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490518]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490520]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490522]
.load_avg                      : 3327.502438
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490525]
.load_period                   : 9.150364
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490527]
.load_contrib                  : 363
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490529]
.load_tg                       : 5662
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490531]
.se->exec_start                : 6289765484.601400
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490534]
.se->vruntime                  : 5275758808.567000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490536]
.se->sum_exec_runtime          : 271274806.232030
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490538]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490540]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490543]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490545]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490547]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490549]
.se->statistics.exec_max       : 89.063097
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490552]
.se->statistics.slice_max      : 9.634280
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490554]
.se->statistics.wait_max       : 62.823183
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490556]
.se->statistics.wait_sum       : 17149411.365687
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490558]
.se->statistics.wait_count     : 1956847769
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490560]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490563]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490563]
cfs_rq[0]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490565]
.exec_clock                    : 2654329998.061406
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490568]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490570]
.min_vruntime                  : 5275758808.567000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490572]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490574]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490576]
.spread0                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490579]
.nr_spread_over                : 6279
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490580]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490582]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490584]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490587]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490588]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490590]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490593]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490593] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490594]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.490596]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491051]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491051] cpu#1, 2666.66=
9 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491053]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491055]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491057]
.nr_switches                   : 8273569831
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491060]
.nr_load_updates               : 626375158
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491062]
.nr_uninterruptible            : 73
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491064]
.next_balance                  : 4925.544055
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491066]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491068]   .clock
                       : 6289765487.728713
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491070]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491072]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491074]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491075]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491077]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491079]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491081]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491083]
.sched_count                   : 45212876
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491085]
.sched_goidle                  : -979747614
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491087]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491089]
.ttwu_count                    : 395251045
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491091]
.ttwu_local                    : 613608772
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491093]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491096]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491096]
cfs_rq[1]:/autogroup-414269
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491099]
.exec_clock                    : 137793543.715387
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491101]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491103]
.min_vruntime                  : 56229285.572333
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491105]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491108]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491110]
.spread0                       : -5219529523.874906
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491112]
.nr_spread_over                : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491114]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491116]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491118]
.load_avg                      : 720.890368
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491120]
.load_period                   : 8.895212
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491122]
.load_contrib                  : 81
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491124]
.load_tg                       : 5589
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491127]
.se->exec_start                : 6289765463.038064
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491129]
.se->vruntime                  : 3790335530.548519
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491132]
.se->sum_exec_runtime          : 137786656.089908
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491134]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491136]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491138]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491140]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491142]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491145]
.se->statistics.exec_max       : 13.720668
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491147]
.se->statistics.slice_max      : 6.589942
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491149]
.se->statistics.wait_max       : 18.785882
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491152]
.se->statistics.wait_sum       : 2443247.106339
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491154]
.se->statistics.wait_count     : 1151412388
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491156]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491158]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491159]
cfs_rq[1]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491161]
.exec_clock                    : 1303085478.810990
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491163]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491166]
.min_vruntime                  : 3790335530.548519
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491168]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491170]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491172]
.spread0                       : -1485423278.898720
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491174]
.nr_spread_over                : 7869
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491176]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491178]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491180]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491182]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491184]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491186]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491188]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491189] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491190]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491191]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491504]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491505] cpu#2, 2666.66=
9 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491507]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491509]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491511]
.nr_switches                   : 6889445027
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491513]
.nr_load_updates               : 611379029
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491515]
.nr_uninterruptible            : 14
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491517]
.next_balance                  : 4925.544055
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491519]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491521]   .clock
                       : 6289765487.729349
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491523]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491525]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491527]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491529]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491531]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491533]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491534]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491536]
.sched_count                   : -1273998515
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491538]
.sched_goidle                  : -1411803272
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491541]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491543]
.ttwu_count                    : -572524616
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491545]
.ttwu_local                    : 591573297
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491547]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491549]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491550]
cfs_rq[2]:/autogroup-1343927
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491552]
.exec_clock                    : 63555.175046
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491555]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491557]
.min_vruntime                  : 63654.032536
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491559]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491561]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491563]
.spread0                       : -5275695155.414703
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491566]
.nr_spread_over                : 8881
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491568]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491569]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491572]
.load_avg                      : 59.119616
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491574]
.load_period                   : 2.316679
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491576]
.load_contrib                  : 25
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491578]
.load_tg                       : 25
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491580]
.se->exec_start                : 6289765485.470404
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491583]
.se->vruntime                  : 3082370740.515635
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491585]
.se->sum_exec_runtime          : 63527.270556
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491587]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491590]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491592]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491594]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491596]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491598]
.se->statistics.exec_max       : 9.976826
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491601]
.se->statistics.slice_max      : 18.380990
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491603]
.se->statistics.wait_max       : 9.590159
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491605]
.se->statistics.wait_sum       : 1626.960757
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491607]
.se->statistics.wait_count     : 377142
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491609]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491612]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491612]
cfs_rq[2]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491615]
.exec_clock                    : 983717920.859277
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491617]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491619]
.min_vruntime                  : 3082370752.457901
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491621]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491624]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491626]
.spread0                       : -2193388056.989338
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491628]
.nr_spread_over                : 4336
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491630]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491632]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491634]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491636]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491638]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491640]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491642]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491643] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491644]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491645]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491938]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491938] cpu#3, 2666.66=
9 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491940]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491942]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491944]
.nr_switches                   : 6403859186
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491946]
.nr_load_updates               : 568113726
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491948]
.nr_uninterruptible            : 5
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491950]
.next_balance                  : 4925.544025
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491952]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491954]   .clock
                       : 6289765467.818555
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491957]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491958]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491960]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491962]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491964]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491966]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491968]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491970]
.sched_count                   : -1743444661
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491972]
.sched_goidle                  : -1599054336
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491974]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491976]
.ttwu_count                    : -815691714
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491978]
.ttwu_local                    : 552071322
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491980]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491982]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491983]
cfs_rq[3]:/autogroup-414261
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491985]
.exec_clock                    : 66010196.680942
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491988]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491990]
.min_vruntime                  : 65185812.473969
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491992]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491994]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491997]
.spread0                       : -5210572999.838724
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.491999]
.nr_spread_over                : 281868
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492001]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492003]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492005]
.load_avg                      : 72.545280
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492007]
.load_period                   : 0.072483
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492009]
.load_contrib                  : 1000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492011]
.load_tg                       : 1000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492014]
.se->exec_start                : 6289765467.816917
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492016]
.se->vruntime                  : 1311664958.678780
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492018]
.se->sum_exec_runtime          : 66010159.924905
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492021]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492023]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492025]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492027]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492029]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492032]
.se->statistics.exec_max       : 19.027862
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492034]
.se->statistics.slice_max      : 19.941796
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492036]
.se->statistics.wait_max       : 20.023231
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492038]
.se->statistics.wait_sum       : 240560.263176
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492041]
.se->statistics.wait_count     : 6984964
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492043]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492045]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492046]
cfs_rq[3]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492048]
.exec_clock                    : 464974138.541177
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492050]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492052]
.min_vruntime                  : 1311664969.134367
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492055]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492057]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492059]
.spread0                       : -3964093843.178326
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492061]
.nr_spread_over                : 2429
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492063]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492065]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492067]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492069]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492071]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492073]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492075]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492076] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492076]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492078]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492362]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492362] cpu#4, 2666.66=
9 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492364]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492366]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492368]
.nr_switches                   : 4835528789
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492370]
.nr_load_updates               : 491423226
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492372]
.nr_uninterruptible            : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492374]
.next_balance                  : 4925.544025
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492377]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492379]   .clock
                       : 6289765008.957932
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492381]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492383]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492384]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492386]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492388]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492390]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492392]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492394]
.sched_count                   : 954966696
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492396]
.sched_goidle                  : 2116137063
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492398]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492400]
.ttwu_count                    : -1790023253
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492402]
.ttwu_local                    : 480380309
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492404]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492406]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492407]
cfs_rq[4]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492409]
.exec_clock                    : 327123880.841111
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492412]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492414]
.min_vruntime                  : 835940500.943709
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492416]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492418]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492421]
.spread0                       : -4439818311.368984
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492423]
.nr_spread_over                : 3241
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492425]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492426]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492428]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492431]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492433]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492435]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492436]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492437] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492438]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492440]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492719]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492720] cpu#5, 2666.66=
9 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492722]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492724]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492726]
.nr_switches                   : 3294281116
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492728]
.nr_load_updates               : 378987536
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492730]
.nr_uninterruptible            : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492732]
.next_balance                  : 4925.544040
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492734]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492736]   .clock
                       : 6289765338.357122
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492738]
.cpu_load[0]                   : 1024
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492740]
.cpu_load[1]                   : 512
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492742]
.cpu_load[2]                   : 256
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492744]
.cpu_load[3]                   : 128
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492746]
.cpu_load[4]                   : 64
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492748]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492750]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492752]
.sched_count                   : -695239207
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492754]
.sched_goidle                  : 1495821089
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492756]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492758]
.ttwu_count                    : 1637517949
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492760]
.ttwu_local                    : 357881361
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492762]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492764]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492765]
cfs_rq[5]:/autogroup-1344172
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492767]
.exec_clock                    : 1080.391262
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492770]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492772]
.min_vruntime                  : 1079.342686
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492774]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492776]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492778]
.spread0                       : -5275757732.970007
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492781]
.nr_spread_over                : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492782]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492784]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492786]
.load_avg                      : 135.440505
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492789]
.load_period                   : 9.688498
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492791]
.load_contrib                  : 13
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492793]
.load_tg                       : 15
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492795]
.se->exec_start                : 6289765328.077289
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492797]
.se->vruntime                  : 712495920.041799
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492800]
.se->sum_exec_runtime          : 1076.136845
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492802]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492804]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492806]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492808]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492811]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492813]
.se->statistics.exec_max       : 2.928119
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492815]
.se->statistics.slice_max      : 0.989146
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492817]
.se->statistics.wait_max       : 3.533611
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492819]
.se->statistics.wait_sum       : 14.705974
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492822]
.se->statistics.wait_count     : 63411
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492824]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492826]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492827]
cfs_rq[5]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492829]
.exec_clock                    : 320306614.362258
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492831]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492833]
.min_vruntime                  : 712495920.041799
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492835]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492838]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492840]
.spread0                       : -4563262892.270894
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492842]
.nr_spread_over                : 4796
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492844]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492846]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492848]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492850]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492852]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492854]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492856]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492856] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492857]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.492859]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493134]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493135] cpu#6, 2666.66=
9 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493137]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493138]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493140]
.nr_switches                   : 11537883767
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493143]
.nr_load_updates               : 630391301
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493145]
.nr_uninterruptible            : 92
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493147]
.next_balance                  : 4925.544054
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493149]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493151]   .clock
                       : 6289765487.670789
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493153]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493155]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493157]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493158]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493160]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493162]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493164]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493166]
.sched_count                   : -996222699
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493168]
.sched_goidle                  : -40688227
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493170]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493172]
.ttwu_count                    : -2138146965
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493174]
.ttwu_local                    : 1505718348
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493176]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493178]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493179]
cfs_rq[6]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493181]
.exec_clock                    : 1421711390.657324
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493184]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493186]
.min_vruntime                  : 2916845843.938185
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493188]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493190]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493192]
.spread0                       : -2358912968.374508
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493195]
.nr_spread_over                : 5348
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493196]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493198]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493200]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493202]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493204]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493206]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493208]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493209] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493210]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493211]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493484]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493485] cpu#7, 2666.66=
9 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493487]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493489]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493491]
.nr_switches                   : 6695645899
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493493]
.nr_load_updates               : 612738698
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493495]
.nr_uninterruptible            : 62
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493497]
.next_balance                  : 4925.544054
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493499]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493501]   .clock
                       : 6289765487.670362
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493503]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493505]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493507]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493509]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493510]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493512]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493514]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493516]
.sched_count                   : -1525818244
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493518]
.sched_goidle                  : -1432775573
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493520]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493522]
.ttwu_count                    : -797764508
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493524]
.ttwu_local                    : 585220017
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493526]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493529]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493529]
cfs_rq[7]:/autogroup-414268
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493532]
.exec_clock                    : 137935906.157835
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493534]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493536]
.min_vruntime                  : 93463977.406881
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493538]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493541]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493543]
.spread0                       : -5182294834.905812
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493545]
.nr_spread_over                : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493547]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493549]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493551]
.load_avg                      : 78.385152
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493553]
.load_period                   : 8.153831
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493555]
.load_contrib                  : 9
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493557]
.load_tg                       : 4864
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493559]
.se->exec_start                : 6289765484.052588
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493562]
.se->vruntime                  : 3478818192.764154
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493564]
.se->sum_exec_runtime          : 137927608.900390
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493566]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493568]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493571]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493573]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493575]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493577]
.se->statistics.exec_max       : 19.297779
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493579]
.se->statistics.slice_max      : 15.079650
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493582]
.se->statistics.wait_max       : 32.862905
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493584]
.se->statistics.wait_sum       : 1018357.880256
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493586]
.se->statistics.wait_count     : 396458522
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493588]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493590]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493591]
cfs_rq[7]:/autogroup-414269
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493593]
.exec_clock                    : 91523168.906140
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493596]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493598]
.min_vruntime                  : 37610542.680748
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493600]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493602]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493604]
.spread0                       : -5238148269.631945
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493607]
.nr_spread_over                : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493608]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493610]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493612]
.load_avg                      : 101.347657
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493615]
.load_period                   : 6.499393
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493617]
.load_contrib                  : 15
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493619]
.load_tg                       : 5617
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493621]
.se->exec_start                : 6289765473.695056
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493623]
.se->vruntime                  : 3478818161.842403
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493626]
.se->sum_exec_runtime          : 91518291.507576
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493628]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493630]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493632]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493634]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493637]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493639]
.se->statistics.exec_max       : 20.074031
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493641]
.se->statistics.slice_max      : 9.955814
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493643]
.se->statistics.wait_max       : 32.797921
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493646]
.se->statistics.wait_sum       : 1338794.767813
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493648]
.se->statistics.wait_count     : 785736373
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493650]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493652]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493653]
cfs_rq[7]:/autogroup-380665
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493655]
.exec_clock                    : 9307263.927915
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493657]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493660]
.min_vruntime                  : 9207981.799574
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493662]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493664]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493666]
.spread0                       : -5266550830.513119
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493668]
.nr_spread_over                : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493670]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493672]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493674]
.load_avg                      : 326.181094
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493677]
.load_period                   : 6.561932
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493679]
.load_contrib                  : 49
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493681]
.load_tg                       : 95
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493683]
.se->exec_start                : 6289765484.036593
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493685]
.se->vruntime                  : 3478818204.694603
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493688]
.se->sum_exec_runtime          : 9294825.282405
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493690]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493692]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493694]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493696]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493698]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493700]
.se->statistics.exec_max       : 9.790313
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493703]
.se->statistics.slice_max      : 1.652869
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493705]
.se->statistics.wait_max       : 15.692025
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493707]
.se->statistics.wait_sum       : 363105.130211
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493709]
.se->statistics.wait_count     : 177718052
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493711]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493714]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493714]
cfs_rq[7]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493716]
.exec_clock                    : 1107910908.880324
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493719]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493721]
.min_vruntime                  : 3478818204.694603
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493723]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493725]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493727]
.spread0                       : -1796940607.618090
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493730]
.nr_spread_over                : 5958
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493731]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493733]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493735]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493737]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493739]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493741]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493743]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493744] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493745]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.493746]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494017]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494018] cpu#8, 2666.66=
9 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494020]
.nr_running                    : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494022]   .load
                       : 1024
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494024]
.nr_switches                   : 5416915121
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494026]
.nr_load_updates               : 579675220
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494028]
.nr_uninterruptible            : 12
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494030]
.next_balance                  : 4925.544035
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494032]
.curr->pid                     : 17487
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494034]   .clock
                       : 6289765358.070164
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494036]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494038]
.cpu_load[1]                   : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494040]
.cpu_load[2]                   : 13
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494042]
.cpu_load[3]                   : 16
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494044]
.cpu_load[4]                   : 12
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494046]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494048]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494050]
.sched_count                   : 1588920241
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494052]
.sched_goidle                  : -1957322198
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494054]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494056]
.ttwu_count                    : -1513781286
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494058]
.ttwu_local                    : 549479165
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494060]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494062]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494063]
cfs_rq[8]:/autogroup-1408130
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494065]
.exec_clock                    : 13.405400
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494068]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494070]
.min_vruntime                  : 11.603859
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494072]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494074]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494076]
.spread0                       : -5275758800.708834
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494078]
.nr_spread_over                : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494080]
.nr_running                    : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494082]   .load
                       : 1024
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494084]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494087]
.load_period                   : 5.026042
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494089]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494091]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494093]
.se->exec_start                : 6289765358.070164
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494095]
.se->vruntime                  : 2776129442.665810
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494098]
.se->sum_exec_runtime          : 13.405400
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494100]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494102]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494104]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494106]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494108]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494111]
.se->statistics.exec_max       : 3.415769
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494113]
.se->statistics.slice_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494115]
.se->statistics.wait_max       : 0.002060
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494117]
.se->statistics.wait_sum       : 0.003596
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494119]
.se->statistics.wait_count     : 38
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494121]
.se->load.weight               : 1024
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494123]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494124]
cfs_rq[8]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494126]
.exec_clock                    : 841892747.542919
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494129]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494131]
.min_vruntime                  : 2776129454.665810
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494133]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494135]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494137]
.spread0                       : -2499629357.646883
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494140]
.nr_spread_over                : 3209
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494141]
.nr_running                    : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494143]   .load
                       : 1024
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494145]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494147]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494149]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494151]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494153]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494154] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494155]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494157]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494425] R
  bash 17487        11.603859        59   120        11.603859
169.359973      5319.278309 /autogroup-1408130
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494435]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494436] cpu#9, 2666.66=
9 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494438]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494440]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494442]
.nr_switches                   : 4721596264
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494444]
.nr_load_updates               : 498681368
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494446]
.nr_uninterruptible            : 7
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494448]
.next_balance                  : 4925.544055
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494450]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494452]   .clock
                       : 6289765487.712458
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494454]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494456]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494458]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494460]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494461]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494463]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494465]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494467]
.sched_count                   : 839097613
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494469]
.sched_goidle                  : 2048386623
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494471]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494473]
.ttwu_count                    : -1870865388
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494475]
.ttwu_local                    : 474982552
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494477]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494480]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494480]
cfs_rq[9]:/autogroup-414265
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494483]
.exec_clock                    : 689840.876722
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494485]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494487]
.min_vruntime                  : 689556.834122
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494489]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494491]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494494]
.spread0                       : -5275069255.478571
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494496]
.nr_spread_over                : 2729
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494498]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494500]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494502]
.load_avg                      : 166.652416
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494504]
.load_period                   : 9.619815
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494506]
.load_contrib                  : 17
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494508]
.load_tg                       : 17
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494511]
.se->exec_start                : 6289765457.231051
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494513]
.se->vruntime                  : 1135181035.439371
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494515]
.se->sum_exec_runtime          : 689806.619188
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494518]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494520]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494522]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494524]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494526]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494528]
.se->statistics.exec_max       : 16.246839
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494531]
.se->statistics.slice_max      : 19.573915
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494533]
.se->statistics.wait_max       : 10.035338
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494535]
.se->statistics.wait_sum       : 2598.461167
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494537]
.se->statistics.wait_count     : 340653
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494539]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494541]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494542]
cfs_rq[9]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494544]
.exec_clock                    : 393469668.059550
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494547]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494549]
.min_vruntime                  : 1135181043.479470
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494551]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494553]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494555]
.spread0                       : -4140577768.833223
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494558]
.nr_spread_over                : 2234
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494560]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494561]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494563]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494566]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494568]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494570]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494572]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494572] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494573]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494575]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494844]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494845] cpu#10,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494847]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494849]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494850]
.nr_switches                   : 3281330776
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494853]
.nr_load_updates               : 403094355
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494855]
.nr_uninterruptible            : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494857]
.next_balance                  : 4925.544025
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494859]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494861]   .clock
                       : 6289765467.799841
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494863]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494865]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494867]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494868]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494870]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494872]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494874]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494876]
.sched_count                   : -707466222
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494878]
.sched_goidle                  : 1446069866
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494880]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494882]
.ttwu_count                    : 1629261485
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494884]
.ttwu_local                    : 382180163
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494886]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494888]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494889]
cfs_rq[10]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494891]
.exec_clock                    : 333160694.802754
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494893]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494896]
.min_vruntime                  : 807462066.912896
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494898]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494900]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494902]
.spread0                       : -4468296745.399797
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494904]
.nr_spread_over                : 3771
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494906]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494908]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494910]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494912]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494914]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494916]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494918]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494919] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494920]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.494921]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495193]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495193] cpu#11,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495195]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495197]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495199]
.nr_switches                   : 2099517291
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495201]
.nr_load_updates               : 297786759
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495203]
.nr_uninterruptible            : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495205]
.next_balance                  : 4925.544025
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495207]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495210]   .clock
                       : 6289765009.367969
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495212]
.cpu_load[0]                   : 1246
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495214]
.cpu_load[1]                   : 623
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495216]
.cpu_load[2]                   : 312
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495217]
.cpu_load[3]                   : 156
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495219]
.cpu_load[4]                   : 78
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495221]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495223]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495225]
.sched_count                   : -2005818197
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495227]
.sched_goidle                  : 941510736
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495229]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495231]
.ttwu_count                    : 1020560516
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495233]
.ttwu_local                    : 265240453
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495235]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495237]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495238]
cfs_rq[11]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495240]
.exec_clock                    : 353560715.715641
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495243]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495245]
.min_vruntime                  : 781077937.648733
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495247]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495249]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495251]
.spread0                       : -4494680874.663960
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495254]
.nr_spread_over                : 5553
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495255]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495257]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495259]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495261]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495263]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495265]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495267]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495268] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495269]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495270]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495566]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495566] cpu#12,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495568]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495570]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495572]
.nr_switches                   : 8519047582
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495574]
.nr_load_updates               : 630156685
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495576]
.nr_uninterruptible            : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495579]
.next_balance                  : 4925.544055
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495581]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495583]   .clock
                       : 6289765487.699010
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495585]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495587]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495588]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495590]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495592]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495594]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495596]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495598]
.sched_count                   : 175035727
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495600]
.sched_goidle                  : -1478549509
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495602]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495604]
.ttwu_count                    : 1427272944
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495606]
.ttwu_local                    : -419453012
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495608]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495610]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495611]
cfs_rq[12]:/autogroup-414269
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495613]
.exec_clock                    : 184328681.282203
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495616]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495618]
.min_vruntime                  : 73634526.631563
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495620]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495622]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495625]
.spread0                       : -5202124285.681130
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495627]
.nr_spread_over                : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495629]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495630]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495633]
.load_avg                      : 24378.268672
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495635]
.load_period                   : 5.037714
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495637]
.load_contrib                  : 4839
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495639]
.load_tg                       : 19536
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495641]
.se->exec_start                : 6289765484.448479
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495644]
.se->vruntime                  : 3952581873.738911
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495646]
.se->sum_exec_runtime          : 184316825.917328
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495649]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495651]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495653]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495655]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495657]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495660]
.se->statistics.exec_max       : 42.239391
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495662]
.se->statistics.slice_max      : 7.615074
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495664]
.se->statistics.wait_max       : 103.603720
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495667]
.se->statistics.wait_sum       : 9012855.733623
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495669]
.se->statistics.wait_count     : 1208901194
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495671]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495673]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495674]
cfs_rq[12]:/autogroup-414268
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495676]
.exec_clock                    : 566521319.262718
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495678]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495681]
.min_vruntime                  : 345842837.495971
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495683]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495685]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495687]
.spread0                       : -4929915974.816722
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495690]
.nr_spread_over                : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495692]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495693]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495696]
.load_avg                      : 328.033792
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495698]
.load_period                   : 5.408881
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495700]
.load_contrib                  : 60
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495702]
.load_tg                       : 4745
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495704]
.se->exec_start                : 6289765463.877819
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495707]
.se->vruntime                  : 3952581883.252696
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495709]
.se->sum_exec_runtime          : 566505865.251723
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495711]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495714]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495716]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495718]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495720]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495722]
.se->statistics.exec_max       : 35.901087
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495725]
.se->statistics.slice_max      : 14.592761
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495727]
.se->statistics.wait_max       : 103.632083
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495729]
.se->statistics.wait_sum       : 16743407.627504
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495731]
.se->statistics.wait_count     : 1350461873
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495733]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495736]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495736]
cfs_rq[12]:/autogroup-414266
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495739]
.exec_clock                    : 30445649.407088
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495741]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495743]
.min_vruntime                  : 26511357.108827
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495745]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495747]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495750]
.spread0                       : -5249247455.203866
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495752]
.nr_spread_over                : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495754]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495756]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495758]
.load_avg                      : 24.308360
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495760]
.load_period                   : 5.136436
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495762]
.load_contrib                  : 4
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495764]
.load_tg                       : 4
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495767]
.se->exec_start                : 6289765458.722339
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495769]
.se->vruntime                  : 3952581862.767688
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495771]
.se->sum_exec_runtime          : 30441084.954135
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495773]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495776]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495778]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495780]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495782]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495784]
.se->statistics.exec_max       : 16.560905
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495787]
.se->statistics.slice_max      : 12.834884
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495789]
.se->statistics.wait_max       : 18.165292
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495791]
.se->statistics.wait_sum       : 756171.449715
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495793]
.se->statistics.wait_count     : 56915362
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495795]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495798]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495798]
cfs_rq[12]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495801]
.exec_clock                    : 1784805334.393486
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495803]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495805]
.min_vruntime                  : 3952581883.252696
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495807]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495809]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495812]
.spread0                       : -1323176929.059997
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495814]
.nr_spread_over                : 4236
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495816]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495818]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495820]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495822]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495824]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495826]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495828]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495829] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495829]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.495831]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496132]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496133] cpu#13,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496135]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496137]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496139]
.nr_switches                   : 4184433988
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496141]
.nr_load_updates               : 630212765
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496143]
.nr_uninterruptible            : 300
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496145]
.next_balance                  : 4925.544055
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496147]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496149]   .clock
                       : 6289765487.729069
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496151]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496153]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496155]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496157]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496158]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496160]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496162]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496164]
.sched_count                   : -16799295
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496166]
.sched_goidle                  : 1182579038
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496168]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496170]
.ttwu_count                    : -1414612398
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496172]
.ttwu_local                    : -1920524038
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496174]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496177]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496178]
cfs_rq[13]:/autogroup-414268
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496180]
.exec_clock                    : 223468277.375189
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496182]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496184]
.min_vruntime                  : 127219422.061603
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496187]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496189]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496191]
.spread0                       : -5148539390.251090
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496193]
.nr_spread_over                : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496195]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496197]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496199]
.load_avg                      : 39215.367168
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496201]
.load_period                   : 8.671612
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496204]
.load_contrib                  : 4522
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496205]
.load_tg                       : 4739
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496208]
.se->exec_start                : 6289765483.936444
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496210]
.se->vruntime                  : 13613423591.181610
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496213]
.se->sum_exec_runtime          : 223458340.855636
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496215]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496217]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496219]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496221]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496223]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496226]
.se->statistics.exec_max       : 14.564073
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496228]
.se->statistics.slice_max      : 13.917641
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496231]
.se->statistics.wait_max       : 24.606594
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496233]
.se->statistics.wait_sum       : 6717302.850682
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496235]
.se->statistics.wait_count     : 634746830
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496237]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496239]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496240]
cfs_rq[13]:/autogroup-414269
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496242]
.exec_clock                    : 73980356.257668
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496245]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496247]
.min_vruntime                  : 24552765.323576
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496249]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496251]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496254]
.spread0                       : -5251206046.989117
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496256]
.nr_spread_over                : 6
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496258]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496260]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496262]
.load_avg                      : 773.157896
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496264]
.load_period                   : 5.579626
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496266]
.load_contrib                  : 138
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496268]
.load_tg                       : 20277
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496271]
.se->exec_start                : 6289765463.564514
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496273]
.se->vruntime                  : 13613423595.274174
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496275]
.se->sum_exec_runtime          : 73972294.848174
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496278]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496280]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496282]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496284]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496286]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496289]
.se->statistics.exec_max       : 9.980478
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496291]
.se->statistics.slice_max      : 8.921369
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496293]
.se->statistics.wait_max       : 15.957078
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496295]
.se->statistics.wait_sum       : 3381020.091853
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496297]
.se->statistics.wait_count     : 532967632
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496300]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496302]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496303]
cfs_rq[13]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496305]
.exec_clock                    : 3774089192.117876
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496307]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496309]
.min_vruntime                  : 13613423595.274174
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496312]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496314]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496316]
.spread0                       : 8337664782.961481
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496318]
.nr_spread_over                : 1861
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496320]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496322]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496324]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496326]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496328]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496330]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496332]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496333] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496333]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496335]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496621]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496621] cpu#14,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496623]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496625]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496627]
.nr_switches                   : 3892117971
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496629]
.nr_load_updates               : 630088542
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496631]
.nr_uninterruptible            : 223
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496634]
.next_balance                  : 4925.544055
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496636]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496638]   .clock
                       : 6289765496.321709
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496640]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496642]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496643]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496645]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496647]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496649]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496651]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496653]
.sched_count                   : -312842858
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496655]
.sched_goidle                  : 1059622121
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496657]
.avg_idle                      : 962065
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496659]
.ttwu_count                    : -1607558487
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496661]
.ttwu_local                    : -2010395759
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496663]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496666]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496666]
cfs_rq[14]:/autogroup-414269
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496669]
.exec_clock                    : 66484034.534015
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496671]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496673]
.min_vruntime                  : 21335708.745506
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496675]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496678]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496680]
.spread0                       : -5254423103.567187
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496682]
.nr_spread_over                : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496684]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496686]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496688]
.load_avg                      : 19769.290752
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496690]
.load_period                   : 2.250877
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496692]
.load_contrib                  : 8782
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496694]
.load_tg                       : 15050
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496697]
.se->exec_start                : 6289765496.319632
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496699]
.se->vruntime                  : 14056822292.007774
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496702]
.se->sum_exec_runtime          : 66475774.854974
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496704]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496706]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496708]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496710]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496713]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496715]
.se->statistics.exec_max       : 11.878564
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496717]
.se->statistics.slice_max      : 9.104942
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496719]
.se->statistics.wait_max       : 27.274247
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496722]
.se->statistics.wait_sum       : 2956791.364711
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496724]
.se->statistics.wait_count     : 488823698
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496726]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496728]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496729]
cfs_rq[14]:/autogroup-414268
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496731]
.exec_clock                    : 204354942.893983
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496734]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496736]
.min_vruntime                  : 113839275.970511
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496738]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496740]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496742]
.spread0                       : -5161919536.342182
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496745]
.nr_spread_over                : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496746]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496748]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496750]
.load_avg                      : 588.242944
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496753]
.load_period                   : 9.138982
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496755]
.load_contrib                  : 64
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496757]
.load_tg                       : 4733
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496759]
.se->exec_start                : 6289765466.857242
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496762]
.se->vruntime                  : 14056822300.077635
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496764]
.se->sum_exec_runtime          : 204344836.797040
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496766]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496769]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496771]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496773]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496775]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496777]
.se->statistics.exec_max       : 27.068387
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496779]
.se->statistics.slice_max      : 12.783886
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496782]
.se->statistics.wait_max       : 36.970361
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496784]
.se->statistics.wait_sum       : 5448784.630161
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496786]
.se->statistics.wait_count     : 595551250
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496788]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496791]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496791]
cfs_rq[14]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496793]
.exec_clock                    : 3846732330.563615
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496796]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496798]
.min_vruntime                  : 14056822300.077635
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496800]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496803]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496805]
.spread0                       : 8781063487.764942
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496807]
.nr_spread_over                : 1820
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496809]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496811]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496813]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496815]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496817]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496819]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496821]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496822] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496823]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.496824]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497099]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497100] cpu#15,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497102]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497104]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497106]
.nr_switches                   : 1467542746
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497108]
.nr_load_updates               : 464694592
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497110]
.nr_uninterruptible            : 104
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497112]
.next_balance                  : 4925.544025
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497114]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497116]   .clock
                       : 6289763992.407670
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497118]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497120]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497122]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497124]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497125]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497127]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497129]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497131]
.sched_count                   : 1556567199
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497133]
.sched_goidle                  : 458060158
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497135]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497137]
.ttwu_count                    : 683663534
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497139]
.ttwu_local                    : 426308738
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497141]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497144]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497144]
cfs_rq[15]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497146]
.exec_clock                    : 2653889018.895324
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497149]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497151]
.min_vruntime                  : 10732446381.128018
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497153]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497155]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497158]
.spread0                       : 5456687568.815325
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497160]
.nr_spread_over                : 750
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497162]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497163]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497165]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497168]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497170]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497171]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497174]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497174] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497175]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497177]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497453]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497453] cpu#16,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497455]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497457]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497459]
.nr_switches                   : 1155838223
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497461]
.nr_load_updates               : 317997352
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497463]
.nr_uninterruptible            : 30
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497465]
.next_balance                  : 4925.544025
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497467]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497469]   .clock
                       : 6289764181.122562
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497472]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497473]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497475]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497477]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497479]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497481]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497483]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497485]
.sched_count                   : 1250894599
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497487]
.sched_goidle                  : 440132106
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497489]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497491]
.ttwu_count                    : 544070964
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497493]
.ttwu_local                    : 256880520
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497495]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497497]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497498]
cfs_rq[16]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497500]
.exec_clock                    : 1177959715.168901
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497502]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497505]
.min_vruntime                  : 4720610373.307036
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497507]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497509]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497511]
.spread0                       : -555148439.005657
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497513]
.nr_spread_over                : 850
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497515]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497517]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497519]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497521]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497523]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497525]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497527]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497528] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497529]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497530]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497812]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497813] cpu#17,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497815]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497817]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497819]
.nr_switches                   : 913555408
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497821]
.nr_load_updates               : 240875821
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497823]
.nr_uninterruptible            : 3
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497825]
.next_balance                  : 4925.544057
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497827]
.curr->pid                     : 121
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497829]   .clock
                       : 6289765497.681411
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497831]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497833]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497835]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497837]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497839]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497840]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497842]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497844]
.sched_count                   : 994956076
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497846]
.sched_goidle                  : 401551103
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497848]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497850]
.ttwu_count                    : 436793404
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497852]
.ttwu_local                    : 147593319
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497854]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497857]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497858]
cfs_rq[17]:/autogroup-1344172
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497860]
.exec_clock                    : 464.785804
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497862]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497864]
.min_vruntime                  : 1214.362053
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497867]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497869]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497871]
.spread0                       : -5275757597.950640
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497873]
.nr_spread_over                : 57
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497875]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497877]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497879]
.load_avg                      : 10.422461
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497881]
.load_period                   : 8.443211
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497883]
.load_contrib                  : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497885]
.load_tg                       : 14
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497888]
.se->exec_start                : 6289765489.312148
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497890]
.se->vruntime                  : 1302304750.857467
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497893]
.se->sum_exec_runtime          : 461.013420
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497895]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497897]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497899]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497901]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497903]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497906]
.se->statistics.exec_max       : 0.678118
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497908]
.se->statistics.slice_max      : 0.101983
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497910]
.se->statistics.wait_max       : 2.871402
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497913]
.se->statistics.wait_sum       : 9.541349
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497915]
.se->statistics.wait_count     : 28221
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497917]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497919]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497920]
cfs_rq[17]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497922]
.exec_clock                    : 344700585.164511
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497925]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497927]
.min_vruntime                  : 1302304750.857467
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497929]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497931]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497933]
.spread0                       : -3973454061.455226
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497936]
.nr_spread_over                : 741
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497937]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497939]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497941]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497943]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497945]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497947]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497949]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497950] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497951]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.497953]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498262]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498263] cpu#18,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498265]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498267]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498269]
.nr_switches                   : 7455211219
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498271]
.nr_load_updates               : 629643232
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498273]
.nr_uninterruptible            : 5
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498275]
.next_balance                  : 4925.544056
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498277]
.curr->pid                     : 128
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498279]   .clock
                       : 6289765497.662428
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498281]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498283]
.cpu_load[1]                   : 3
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498285]
.cpu_load[2]                   : 31
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498287]
.cpu_load[3]                   : 45
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498289]
.cpu_load[4]                   : 38
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498291]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498292]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498294]
.sched_count                   : -926556508
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498296]
.sched_goidle                  : -1762212123
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498299]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498301]
.ttwu_count                    : 914760691
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498303]
.ttwu_local                    : -462604583
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498305]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498307]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498308]
cfs_rq[18]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498310]
.exec_clock                    : 1571207744.312799
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498312]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498314]
.min_vruntime                  : 3243800040.632366
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498317]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498319]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498321]
.spread0                       : -2031958771.680327
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498323]
.nr_spread_over                : 3557
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498325]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498327]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498329]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498331]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498333]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498335]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498337]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498337] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498338]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498340]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498650]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498650] cpu#19,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498652]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498654]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498656]
.nr_switches                   : 3599158570
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498658]
.nr_load_updates               : 630310079
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498660]
.nr_uninterruptible            : 4
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498663]
.next_balance                  : 4925.544056
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498665]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498667]   .clock
                       : 6289765497.663226
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498669]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498671]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498672]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498674]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498676]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498678]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498680]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498682]
.sched_count                   : -626732989
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498684]
.sched_goidle                  : 925306809
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498686]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498688]
.ttwu_count                    : -1881628315
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498690]
.ttwu_local                    : 2056592174
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498692]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498694]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498695]
cfs_rq[19]:/autogroup-414268
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498697]
.exec_clock                    : 187276180.861557
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498699]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498702]
.min_vruntime                  : 107070865.507918
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498704]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498706]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498708]
.spread0                       : -5168687946.804775
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498710]
.nr_spread_over                : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498712]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498714]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498716]
.load_avg                      : 266.655968
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498718]
.load_period                   : 5.487920
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498720]
.load_contrib                  : 48
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498722]
.load_tg                       : 4108
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498725]
.se->exec_start                : 6289765484.041362
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498727]
.se->vruntime                  : 15661065321.278192
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498730]
.se->sum_exec_runtime          : 187262750.605687
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498732]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498734]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498736]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498738]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498740]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498743]
.se->statistics.exec_max       : 36.909326
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498745]
.se->statistics.slice_max      : 13.179646
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498747]
.se->statistics.wait_max       : 41.208130
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498749]
.se->statistics.wait_sum       : 5204021.250094
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498751]
.se->statistics.wait_count     : 527137673
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498754]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498756]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498757]
cfs_rq[19]:/autogroup-414269
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498759]
.exec_clock                    : 59843445.225623
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498761]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498763]
.min_vruntime                  : 20073189.589512
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498766]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498768]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498770]
.spread0                       : -5255685622.723181
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498772]
.nr_spread_over                : 3
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498774]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498776]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498778]
.load_avg                      : 3820.784938
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498781]
.load_period                   : 5.487139
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498783]
.load_contrib                  : 696
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498785]
.load_tg                       : 7668
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498787]
.se->exec_start                : 6289765495.957959
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498789]
.se->vruntime                  : 15661065384.435444
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498792]
.se->sum_exec_runtime          : 59832687.678389
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498794]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498796]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498798]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498800]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498802]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498805]
.se->statistics.exec_max       : 29.020704
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498807]
.se->statistics.slice_max      : 9.931935
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498809]
.se->statistics.wait_max       : 25.102393
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498811]
.se->statistics.wait_sum       : 2624183.942429
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498814]
.se->statistics.wait_count     : 454604568
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498816]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498818]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498819]
cfs_rq[19]:/autogroup-380665
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498821]
.exec_clock                    : 426289.002659
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498823]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498825]
.min_vruntime                  : 420765.051585
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498828]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498830]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498832]
.spread0                       : -5275338047.261108
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498834]
.nr_spread_over                : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498836]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498838]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498840]
.load_avg                      : 463.236238
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498842]
.load_period                   : 5.508837
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498844]
.load_contrib                  : 84
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498846]
.load_tg                       : 117
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498849]
.se->exec_start                : 6289765495.990524
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498851]
.se->vruntime                  : 15661065393.313986
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498853]
.se->sum_exec_runtime          : 424876.084046
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498856]
.se->statistics.wait_start     : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498858]
.se->statistics.sleep_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498860]
.se->statistics.block_start    : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498862]
.se->statistics.sleep_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498864]
.se->statistics.block_max      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498866]
.se->statistics.exec_max       : 15.468820
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498869]
.se->statistics.slice_max      : 0.475659
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498871]
.se->statistics.wait_max       : 10.716355
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498873]
.se->statistics.wait_sum       : 71022.014160
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498875]
.se->statistics.wait_count     : 8343865
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498877]
.se->load.weight               : 2
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498879]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498880]
cfs_rq[19]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498882]
.exec_clock                    : 4215924969.755784
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498885]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498887]
.min_vruntime                  : 15661065393.313986
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498889]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498891]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498894]
.spread0                       : 10385306581.001293
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498896]
.nr_spread_over                : 1829
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498898]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498900]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498902]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498904]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498906]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498908]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498910]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498910] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498911]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.498913]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499222]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499223] cpu#20,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499225]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499227]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499229]
.nr_switches                   : 3749833550
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499231]
.nr_load_updates               : 630207833
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499233]
.nr_uninterruptible            : 1
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499235]
.next_balance                  : 4925.544056
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499237]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499239]   .clock
                       : 6289765497.638808
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499241]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499243]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499245]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499246]
.cpu_load[3]                   : 4
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499248]
.cpu_load[4]                   : 13
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499250]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499252]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499254]
.sched_count                   : -459811351
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499256]
.sched_goidle                  : 958418073
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499258]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499260]
.ttwu_count                    : -1774778034
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499262]
.ttwu_local                    : -2118748955
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499264]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499266]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499267]
cfs_rq[20]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499269]
.exec_clock                    : 3996571456.743069
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499272]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499274]
.min_vruntime                  : 14750607378.337856
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499276]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499278]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499280]
.spread0                       : 9474848566.025163
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499283]
.nr_spread_over                : 2171
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499284]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499286]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499288]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499290]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499292]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499294]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499296]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499297] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499298]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499299]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499581]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499581] cpu#21,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499583]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499585]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499587]
.nr_switches                   : 1308651072
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499589]
.nr_load_updates               : 475751684
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499591]
.nr_uninterruptible            : 244
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499593]
.next_balance                  : 4925.544025
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499595]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499597]   .clock
                       : 6289765159.382731
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499600]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499601]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499603]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499605]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499607]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499609]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499611]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499612]
.sched_count                   : 1380080260
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499615]
.sched_goidle                  : 356371413
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499617]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499619]
.ttwu_count                    : 599844058
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499621]
.ttwu_local                    : 445633764
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499623]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499625]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499626]
cfs_rq[21]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499628]
.exec_clock                    : 2876469290.611337
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499630]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499632]
.min_vruntime                  : 11669871489.209297
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499635]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499637]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499639]
.spread0                       : 6394112676.896604
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499641]
.nr_spread_over                : 721
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499643]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499645]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499647]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499649]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499651]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499653]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499655]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499655] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499656]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499658]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499934]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499934] cpu#22,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499936]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499938]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499940]
.nr_switches                   : 921036293
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499942]
.nr_load_updates               : 307484206
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499944]
.nr_uninterruptible            : 87
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499946]
.next_balance                  : 4925.544025
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499948]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499950]   .clock
                       : 6289760061.775448
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499952]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499954]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499956]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499958]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499960]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499962]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499963]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499965]
.sched_count                   : 996726076
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499967]
.sched_goidle                  : 309899535
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499969]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499971]
.ttwu_count                    : 426376939
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499973]
.ttwu_local                    : 260067611
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499975]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499978]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499978]
cfs_rq[22]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499980]
.exec_clock                    : 1328986846.313153
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499983]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499985]
.min_vruntime                  : 5369334204.419083
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499987]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499989]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499991]
.spread0                       : 93575392.106390
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499994]
.nr_spread_over                : 679
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499995]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499997]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.499999]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500001]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500003]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500005]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500007]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500008] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500009]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500010]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500287]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500288] cpu#23,
2666.669 MHz
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500290]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500292]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500294]
.nr_switches                   : 667040928
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500296]
.nr_load_updates               : 307495912
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500298]
.nr_uninterruptible            : 8
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500300]
.next_balance                  : 4925.544051
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500302]
.curr->pid                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500304]   .clock
                       : 6289765447.848449
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500306]
.cpu_load[0]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500308]
.cpu_load[1]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500310]
.cpu_load[2]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500312]
.cpu_load[3]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500313]
.cpu_load[4]                   : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500315]
.yld_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500317]
.sched_switch                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500319]
.sched_count                   : 726298719
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500321]
.sched_goidle                  : 281320969
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500323]
.avg_idle                      : 1000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500325]
.ttwu_count                    : 314935927
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500327]
.ttwu_local                    : 141561027
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500329]
.bkl_count                     : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500331]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500332]
cfs_rq[23]:/autogroup-0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500334]
.exec_clock                    : 342971209.878743
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500336]
.MIN_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500339]
.min_vruntime                  : 1302398037.550836
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500341]
.max_vruntime                  : 0.000001
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500343]   .spread
                       : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500345]
.spread0                       : -3973360774.761857
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500347]
.nr_spread_over                : 652
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500349]
.nr_running                    : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500351]   .load
                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500353]
.load_avg                      : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500355]
.load_period                   : 0.000000
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500357]
.load_contrib                  : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500359]
.load_tg                       : 0
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500361]
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500362] runnable tasks:
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500362]
  task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500364]
---------------------------------------------------------------------------=
-------------------------------
May 23 16:34:51 sw-aw2az1-object062 kernel: [6289765.500636]



> Mark and I have been looking at the dump. =A0There are few interesting it=
ems to point out.
>
> 1) xfs_sync_worker is blocked trying to get log reservation:
>
> PID: 25374 =A0TASK: ffff88013481c6c0 =A0CPU: 3 =A0 COMMAND: "kworker/3:83"
> =A0#0 [ffff88013481fb50] __schedule at ffffffff813aacac
> =A0#1 [ffff88013481fc98] schedule at ffffffff813ab0c4
> =A0#2 [ffff88013481fca8] xlog_grant_head_wait at ffffffffa0347b78 [xfs]
> =A0#3 [ffff88013481fcf8] xlog_grant_head_check at ffffffffa03483e6 [xfs]
> =A0#4 [ffff88013481fd38] xfs_log_reserve at ffffffffa034852c [xfs]
> =A0#5 [ffff88013481fd88] xfs_trans_reserve at ffffffffa0344e64 [xfs]
> =A0#6 [ffff88013481fdd8] xfs_fs_log_dummy at ffffffffa02ec138 [xfs]
> =A0#7 [ffff88013481fdf8] xfs_sync_worker at ffffffffa02f7be4 [xfs]
> =A0#8 [ffff88013481fe18] process_one_work at ffffffff8104c53b
> =A0#9 [ffff88013481fe68] worker_thread at ffffffff8104f0e3
> #10 [ffff88013481fee8] kthread at ffffffff8105395e
> #11 [ffff88013481ff48] kernel_thread_helper at ffffffff813b3ae4
>
> This means that it is not in a position to push the AIL. =A0It is clear t=
hat the
> AIL has plenty of entries which can be pushed.
>
> crash> xfs_ail 0xffff88022112b7c0,
> struct xfs_ail {
> ...
> =A0xa_ail =3D {
> =A0 =A0next =3D 0xffff880144d1c318,
> =A0 =A0prev =3D 0xffff880170a02078
> =A0},
> =A0xa_target =3D 0x1f00003063,
>
> Here's the first item on the AIL:
>
> ffff880144d1c318
> struct xfs_log_item_t {
> =A0li_ail =3D {
> =A0 =A0next =3D 0xffff880196ea0858,
> =A0 =A0prev =3D 0xffff88022112b7d0
> =A0},
> =A0li_lsn =3D 0x1f00001c63, =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0<--- less than=
 xa_target
> =A0li_desc =3D 0x0,
> =A0li_mountp =3D 0xffff88016adee000,
> =A0li_ailp =3D 0xffff88022112b7c0,
> =A0li_type =3D 0x123b,
> =A0li_flags =3D 0x1,
> =A0li_bio_list =3D 0xffff88016afa5cb8,
> =A0li_cb =3D 0xffffffffa034de00 <xfs_istale_done>,
> =A0li_ops =3D 0xffffffffa035f620,
> =A0li_cil =3D {
> =A0 =A0next =3D 0xffff880144d1c368,
> =A0 =A0prev =3D 0xffff880144d1c368
> =A0},
> =A0li_lv =3D 0x0,
> =A0li_seq =3D 0x3b
> }
>
> So if xfs_sync_worker were not blocked on log reservation it would push t=
hese
> items.
>
> 2) The CIL is waiting around too:
>
> crash> xfs_cil_ctx 0xffff880144d1a9c0,
> struct xfs_cil_ctx {
> ...
> =A0space_used =3D 0x135f68,
>
> struct log {
> ...
> =A0l_logsize =3D 0xa00000,
>
> A00000/8
> 140000 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0<--- XLOG_CIL_SPACE_LIMIT
>
> 140000 - 135F68
> A098
>
> Looks like xlog_cil_push_background will not push the CIL while space use=
d is
> less than XLOG_CIL_SPACE_LIMIT, so that's not going anywhere either.
>
> 3) It may be unrelated to this bug, but we do have a race in the log
> reservation code that hasn't been resolved... between when log_space_left
> samples the grant heads and when the space is actually granted a bit late=
r.
> Maybe we can grant more space than intended.
>
> If you can provide output of 'echo t > /proc/sysrq-trigger' it may be eno=
ugh
> information to determine if you're seeing the same problem we hit on Satu=
rday.
>
> Thanks,
>
> Ben & Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
