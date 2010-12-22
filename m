Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBM4tkee170008 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 22:55:47 -0600
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8DDD14721F8
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 20:57:44 -0800 (PST)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	xbt6urthUQ1VRuGt for <xfs@oss.sgi.com>;
	Tue, 21 Dec 2010 20:57:44 -0800 (PST)
Received: by qyj19 with SMTP id 19so5965194qyj.5
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 20:57:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik3batsHu57QDUWmspf7C8As75t3mUO6QG_i040@mail.gmail.com>
References: <AANLkTim8VD2NQ1a2t47jOA+MyyVGWejymoJh41jfrRkA@mail.gmail.com>
	<AANLkTimqrY4z_Xk-8evw88NYshMPnUxcGE2T-WxQyL1o@mail.gmail.com>
	<20101221213101.GA4907@dastard>
	<AANLkTik3batsHu57QDUWmspf7C8As75t3mUO6QG_i040@mail.gmail.com>
Date: Wed, 22 Dec 2010 10:27:43 +0530
Message-ID: <AANLkTimpGdEm9W82Y_CfiyeX+8KDic8tjTi95vKka0O3@mail.gmail.com>
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

On Wed, Dec 22, 2010 at 10:27 AM, naveen yadav <yad.naveen@gmail.com> wrote:
> Hi Dave,
>
> Please find attached log as suggested by you.
>
> Kind regards
> Naveen
>
> On Wed, Dec 22, 2010 at 3:01 AM, Dave Chinner <david@fromorbit.com> wrote:
>> On Tue, Dec 21, 2010 at 07:41:51PM +0530, naveen yadav wrote:
>>> Hi all,
>>>
>>> We have one disk that got corrupted, when I connect to my PC, haveing
>>> kernel version(2.6.35.9).
>>> The Disk mount well, but when i do 'ls; command it hangs.
>>
>> ls shouldn't hang. This should return:
>>
>>> Please find the dmesg.
>>> /0x22 [xfs]
>>> =A0[<e0dfd2c2>] xfs_da_do_buf+0x582/0x628 [xfs]
>>> =A0[<e0dfd3ce>] ? xfs_da_read_buf+0x1d/0x22 [xfs]
>>> =A0[<e0dfe0d3>] ? xfs_da_node_lookup_int+0x52/0x207 [xfs]
>>> =A0[<e0dfd3ce>] ? xfs_da_read_buf+0x1d/0x22 [xfs]
>>> =A0[<e0dfd3ce>] xfs_da_read_buf+0x1d/0x22 [xfs]
>>> =A0[<e0dfe0d3>] ? xfs_da_node_lookup_int+0x52/0x207 [xfs]
>>> =A0[<e0dfe0d3>] xfs_da_node_lookup_int+0x52/0x207 [xfs]
>>> =A0[<e0e03888>] xfs_dir2_node_lookup+0x5f/0xee [xfs]
>>> =A0[<e0dff26a>] xfs_dir_lookup+0xde/0x110 [xfs]
>>> =A0[<e0e22c0a>] xfs_lookup+0x50/0x9f [xfs]
>>> =A0[<e0e2c5a6>] xfs_vn_lookup+0x3e/0x76 [xfs]
>>> =A0[<c04da3b2>] do_lookup+0xc9/0x139
>>> =A0[<c04daabd>] link_path_walk+0x326/0x44d
>>> =A0[<c043b145>] ? default_wake_function+0x10/0x12
>>> =A0[<c04daca2>] path_walk+0x3f/0x89
>>> =A0[<c04dc125>] ? path_init+0x9e/0x10c
>>> =A0[<c04dc1b9>] do_path_lookup+0x26/0x74
>>> =A0[<c04dcf95>] user_path_at+0x46/0x6c
>>> =A0[<c0454687>] ? remove_wait_queue+0x27/0x2c
>>> =A0[<c0430e9f>] ? spin_unlock_irqrestore+0xd/0xf
>>> =A0[<c0431016>] ? __wake_up+0x37/0x40
>>> =A0[<c04d645a>] vfs_fstatat+0x32/0x59
>>> =A0[<c04d2bc4>] ? fsnotify_modify+0x54/0x5f
>>> =A0[<c04d64cf>] vfs_lstat+0x1b/0x1d
>>> =A0[<c04d64ea>] sys_lstat64+0x19/0x2d
>>> =A0[<c04d3308>] ? vfs_write+0xb5/0xf4
>>> =A0[<c047d0f4>] ? audit_syscall_entry+0x12a/0x14c
>>> =A0[<c05a8cb8>] ? trace_hardirqs_on_thunk+0xc/0x10
>>> =A0[<c0407fd8>] sysenter_do_call+0x12/0x2d
>>> c2d9d000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =A0..........=
......
>>> Filesystem "sdb2": XFS internal error xfs_da_do_buf(2) at line 2113 of
>>> file fs/xfs/xfs_da_btree.c. =A0Caller 0xe0dfd3ce
>>
>> an EIO or EUCLEAN error to ls as it encountered a corrupted
>> directory block. Can you post the output of:
>>
>> # echo w > /proc/sysrq-trigger
>>
>> to show us where it has hung?
>>
>> Cheers,
>>
>> Dave.
>>
>>
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
