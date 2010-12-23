Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN5HhU5099491 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 23:17:44 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C46114794C4
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 21:19:41 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	Z7MqqXUnF6pZLitu for <xfs@oss.sgi.com>;
	Wed, 22 Dec 2010 21:19:41 -0800 (PST)
Received: by qyk12 with SMTP id 12so6336304qyk.5
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 21:19:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik-jaSVDYjf-+-U5TXBTAP_JzB-woNwQ7JHWd8H@mail.gmail.com>
References: <AANLkTim8VD2NQ1a2t47jOA+MyyVGWejymoJh41jfrRkA@mail.gmail.com>
	<AANLkTimqrY4z_Xk-8evw88NYshMPnUxcGE2T-WxQyL1o@mail.gmail.com>
	<20101221213101.GA4907@dastard>
	<AANLkTik3batsHu57QDUWmspf7C8As75t3mUO6QG_i040@mail.gmail.com>
	<20101222053730.GG4907@dastard>
	<AANLkTik-jaSVDYjf-+-U5TXBTAP_JzB-woNwQ7JHWd8H@mail.gmail.com>
Date: Thu, 23 Dec 2010 10:49:40 +0530
Message-ID: <AANLkTimv+h=JxFMQ6ApoRmr2yk_P==-FzDYsZaDRyf9A@mail.gmail.com>
Subject: Re: Issue on kernel 2.6.35.9 vanilla
From: naveen yadav <yad.naveen@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

Hi Dave,

The question you ask about log difference, the reason is I just reboot
my PC and
again reconnect my corrupted disk again,

FYI, I already send rest of info in my previous mail, If you need more
info, i will provide

Thanks

On Wed, Dec 22, 2010 at 12:30 PM, naveen yadav <yad.naveen@gmail.com> wrote:
> Thanks a lot Dave,
>
> Please find attached log for command xfs_repair -n.
>
> Thanks a lot
>
> On Wed, Dec 22, 2010 at 11:07 AM, Dave Chinner <david@fromorbit.com> wrot=
e:
>> On Wed, Dec 22, 2010 at 10:27:16AM +0530, naveen yadav wrote:
>>> Hi Dave,
>>>
>>> Please find attached log as suggested by you.
>>>
>>> Kind regards
>>> Naveen
>>>
>>> On Wed, Dec 22, 2010 at 3:01 AM, Dave Chinner <david@fromorbit.com> wro=
te:
>>> > On Tue, Dec 21, 2010 at 07:41:51PM +0530, naveen yadav wrote:
>>> >> Hi all,
>>> >>
>>> >> We have one disk that got corrupted, when I connect to my PC, haveing
>>> >> kernel version(2.6.35.9).
>>> >> The Disk mount well, but when i do 'ls; command it hangs.
>>> >
>>> > ls shouldn't hang. This should return:
>>> >
>>> >> Please find the dmesg.
>>> >> /0x22 [xfs]
>>> >> =A0[<e0dfd2c2>] xfs_da_do_buf+0x582/0x628 [xfs]
>>> >> =A0[<e0dfd3ce>] ? xfs_da_read_buf+0x1d/0x22 [xfs]
>>> >> =A0[<e0dfe0d3>] ? xfs_da_node_lookup_int+0x52/0x207 [xfs]
>>> >> =A0[<e0dfd3ce>] ? xfs_da_read_buf+0x1d/0x22 [xfs]
>>> >> =A0[<e0dfd3ce>] xfs_da_read_buf+0x1d/0x22 [xfs]
>>> >> =A0[<e0dfe0d3>] ? xfs_da_node_lookup_int+0x52/0x207 [xfs]
>>> >> =A0[<e0dfe0d3>] xfs_da_node_lookup_int+0x52/0x207 [xfs]
>> .....
>>> >> c2d9d000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =A0.......=
.........
>>> >> Filesystem "sdb2": XFS internal error xfs_da_do_buf(2) at line 2113 =
of
>>> >> file fs/xfs/xfs_da_btree.c. =A0Caller 0xe0dfd3ce
>>
>> This is not in your dmesg log. When did it actually happen? Before
>> the hung task timer started to trip? From your log:
>>
>> scsi 5:0:0:0: Direct-Access =A0 =A0 SanDisk =A0Cruzer Blade =A0 =A0 1.00=
 PQ: 0 ANSI: 2
>> sd 5:0:0:0: Attached scsi generic sg1 type 0
>> sd 5:0:0:0: [sdb] 15625216 512-byte logical blocks: (8.00 GB/7.45 GiB)
>> sd 5:0:0:0: [sdb] Write Protect is off
>> sd 5:0:0:0: [sdb] Mode Sense: 03 00 00 00
>> sd 5:0:0:0: [sdb] Assuming drive cache: write through
>> sd 5:0:0:0: [sdb] Assuming drive cache: write through
>> =A0sdb: sdb1 sdb2
>> sd 5:0:0:0: [sdb] Assuming drive cache: write through
>> sd 5:0:0:0: [sdb] Attached SCSI removable disk
>> SELinux: initialized (dev sdb1, type vfat), uses genfs_contexts
>> XFS mounting filesystem sdb2
>> Starting XFS recovery on filesystem: sdb2 (logdev: internal)
>> Ending XFS recovery on filesystem: sdb2 (logdev: internal)
>> SELinux: initialized (dev sdb2, type xfs), uses xattr
>> INFO: task gvfs-gdu-volume:2311 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> gvfs-gdu-volu D 00000026 =A0 =A0 0 =A02311 =A0 =A0 =A01 0x00000080
>> =A0c6cf9b2c 00000086 a41cc623 00000026 c0a25e00 c0a25e00 c0a25e00 c0a25e=
00
>> =A0d1290f54 c0a25e00 c0a25e00 000336ad 00000000 cd871c00 00000026 d1290c=
d0
>> =A000000000 cd8d2a08 cd8d2a00 7fffffff 7fffffff c6cf9b70 c0781c43 000000=
00
>> Call Trace:
>> =A0[<c0781c43>] schedule_timeout+0x1b/0x95
>> =A0[<c07824d1>] __down_common+0x82/0xb9
>> =A0[<e0e28ae8>] ? _xfs_buf_find+0x122/0x1b8 [xfs]
>> =A0[<c0782567>] __down+0x17/0x19
>> =A0[<c045827c>] down+0x27/0x37
>> =A0[<e0e278da>] xfs_buf_lock+0x67/0x93 [xfs]
>> =A0[<e0e28ae8>] _xfs_buf_find+0x122/0x1b8 [xfs]
>> =A0[<e0e28bde>] xfs_buf_get+0x60/0x149 [xfs]
>> =A0[<e0e28ce9>] xfs_buf_read+0x22/0xb0 [xfs]
>> =A0[<e0e1ffa9>] xfs_trans_read_buf+0x53/0x2e9 [xfs]
>> =A0[<e0dfd151>] xfs_da_do_buf+0x411/0x628 [xfs]
>> =A0[<e0dfe0d3>] ? xfs_da_node_lookup_int+0x52/0x207 [xfs]
>> =A0[<e0dfd3ce>] xfs_da_read_buf+0x1d/0x22 [xfs]
>> =A0[<e0dfe0d3>] ? xfs_da_node_lookup_int+0x52/0x207 [xfs]
>> =A0[<e0dfe0d3>] xfs_da_node_lookup_int+0x52/0x207 [xfs]
>> =A0[<e0e03888>] xfs_dir2_node_lookup+0x5f/0xee [xfs]
>> =A0[<e0dff26a>] xfs_dir_lookup+0xde/0x110 [xfs]
>> =A0[<e0e22c0a>] xfs_lookup+0x50/0x9f [xfs]
>> =A0[<e0e2c5a6>] xfs_vn_lookup+0x3e/0x76 [xfs]
>> =A0[<c04da3b2>] do_lookup+0xc9/0x139
>> =A0[<c04dbd59>] do_last+0x186/0x49f
>> =A0[<c04dc415>] do_filp_open+0x1bd/0x459
>> =A0[<c045b191>] ? timekeeping_get_ns+0x16/0x54
>> =A0[<c05a9170>] ? might_fault+0x1e/0x20
>> =A0[<c04e479a>] ? alloc_fd+0x58/0xbe
>> =A0[<c04d1941>] do_sys_open+0x4d/0xe4
>> =A0[<c047d0f4>] ? audit_syscall_entry+0x12a/0x14c
>> =A0[<c04d1a24>] sys_open+0x23/0x2b
>> =A0[<c0407fd8>] sysenter_do_call+0x12/0x2d
>>
>> You've got a gvfs (gnome-vfs?) process stuck waiting on a buffer
>> lock. The onyl way I can see it getting stuck here is if it the
>> buffer has not been unlocked somewhere. It's possible that it is
>> stuck on the same buffer that the corruption error came from,
>> but the corrupted buffer is unlocked in the error handling path.
>> what does `xfs_repair -n` tell about the filesytsem?
>>
>> FWIW, later on:
>>
>> ......
>> INFO: task gvfsd-trash:1891 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> gvfsd-trash =A0 D 00000026 =A0 =A0 0 =A01891 =A0 =A0 =A01 0x00000080
>>
>> gvfs-trashd gets stuck on a mutex during a path walk which is
>> probably held by the above directory read.
>>
>> ....
>> INFO: task gvfs-gdu-volume:2321 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> gvfs-gdu-volu D 00000026 =A0 =A0 0 =A02321 =A0 =A0 =A01 0x00000088
>>
>> As does this one.
>>
>> ....
>>
>> gvfs-gdu-volu D 00000026 =A0 =A0 0 =A01889 =A0 =A0 =A01 0x00000080
>> =A0cda3df10 00000086 a422923c 00000026 c0a25e00 c0a25e00 c0a25e00 c0a25e=
00
>> =A0cd936904 c0a25e00 c0a25e00 000b9ea1 00000000 cda24400 00000026 cd9366=
80
>> =A000ae3000 c34c01a4 c34c019c cd936680 c34c01a0 cda3df44 c0782093 c34c01=
ac
>> Call Trace:
>> =A0[<c0782093>] __mutex_lock_common+0xe8/0x137
>> =A0[<c0782113>] __mutex_lock_killable_slowpath+0x17/0x19
>> =A0[<c0782160>] ? mutex_lock_killable+0x32/0x45
>> =A0[<c0782160>] mutex_lock_killable+0x32/0x45
>> =A0[<c04deb0a>] vfs_readdir+0x46/0x94
>> =A0[<c04de814>] ? filldir64+0x0/0xf5
>> =A0[<c04debca>] sys_getdents64+0x72/0xb2
>> =A0[<c0407fd8>] sysenter_do_call+0x12/0x2d
>>
>> And this one, too.
>>
>> .....
>> ls =A0 =A0 =A0 =A0 =A0 =A0D 00000000 =A0 =A0 0 =A02325 =A0 2044 0x000000=
80
>> =A0c6d03f10 00200086 00000000 00000000 c0a25e00 c0a25e00 c0a25e00 c0a25e=
00
>> =A0cdacb5c4 c0a25e00 c0a25e00 d6779fa1 00000029 00000000 00000029 cdacb3=
40
>> =A000000001 c34c01a4 c34c019c cdacb340 c34c01a0 c6d03f44 c0782093 c34c01=
ac
>> Call Trace:
>> =A0[<c0782093>] __mutex_lock_common+0xe8/0x137
>> =A0[<c0782113>] __mutex_lock_killable_slowpath+0x17/0x19
>> =A0[<c0782160>] ? mutex_lock_killable+0x32/0x45
>> =A0[<c0782160>] mutex_lock_killable+0x32/0x45
>> =A0[<c04deb0a>] vfs_readdir+0x46/0x94
>> =A0[<c04de814>] ? filldir64+0x0/0xf5
>> =A0[<c04debca>] sys_getdents64+0x72/0xb2
>> =A0[<c0407fd8>] sysenter_do_call+0x12/0x2d
>>
>> And finally, there is an ls process that is hung, stuck on a
>> directory mutex. Is this the one you were seeing hang rather than
>> whatever generated the corrupion report?
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
