Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7D9187F3F
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 15:03:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1E7FAC00A
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 13:03:22 -0800 (PST)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
	[209.85.217.175]) by cuda.sgi.com with ESMTP id
	YJCZn0H4CKvtuHk3 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 13:03:21 -0800 (PST)
Received: by mail-lb0-f175.google.com with SMTP id n15so13351181lbi.6
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 13:03:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141114052523.GB29950@dastard>
References: <CALCETrWN71T1JsSNix52+ez_Sxt4i+vL-fX_2RTNbt8Ex1p=vw@mail.gmail.com>
	<20141114052523.GB29950@dastard>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 14 Nov 2014 13:02:59 -0800
Message-ID: <CALCETrVcp1BY3cO4Y2sdgGC+eQnyOF3xUCK6qng_Z_Y7dNi2yg@mail.gmail.com>
Subject: Re: XFS locking issues in 3.18-rc3+
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 13, 2014 at 9:25 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Nov 13, 2014 at 04:57:11PM -0800, Andy Lutomirski wrote:
>> I'm running a kernel somewhere between 3.18-rc3 and 3.18-rc4.  I got
>> the warnings below.  Is this a known issue?
>
> Yup, false positive. shmem is instantiating an inode under the
> mmap_sem and in doing so taking inode locks under the mmap_sem,
> which triggers other filesystems to issue false warnings about
> mmap_sem <-> inode lock order.

I still have an enormous flood of warnings even if
CONFIG_PROVE_LOCKING=n.  This one is repeated at high frequency:

[   70.969118] ------------[ cut here ]------------
[   70.969121] WARNING: CPU: 8 PID: 653 at mm/truncate.c:758
pagecache_isize_extended+0x105/0x110()
[   70.969122] Modules linked in: x86_pkg_temp_thermal igb ioatdma
mei_me dca ipmi_si ipmi_msghandler efivarfs radeon mgag200
drm_kms_helper ttm
[   70.969128] CPU: 8 PID: 653 Comm: systemd-journal Tainted: G
W      3.18.0-rc3+ #9
[   70.969129] Hardware name: Supermicro X9DRH-iF-NV/X9DRH-iF-NV, BIOS
2.0  08/06/2013
[   70.969130]  0000000000000009 ffff88046611bd38 ffffffff819769bd
0000000000000000
[   70.969132]  0000000000000000 ffff88046611bd78 ffffffff810cf621
ffff88086402da40
[   70.969134]  0000000000001000 ffff88086402dc30 0000000003f5c000
0000000003f5d000
[   70.969136] Call Trace:
[   70.969139]  [<ffffffff819769bd>] dump_stack+0x46/0x58
[   70.969141]  [<ffffffff810cf621>] warn_slowpath_common+0x81/0xa0
[   70.969144]  [<ffffffff810cf6fa>] warn_slowpath_null+0x1a/0x20
[   70.969145]  [<ffffffff811cbec5>] pagecache_isize_extended+0x105/0x110
[   70.969147]  [<ffffffff811ccbc7>] truncate_setsize+0x27/0x40
[   70.969150]  [<ffffffff813762cf>] xfs_setattr_size+0x13f/0x3c0
[   70.969152]  [<ffffffff81383e76>] ? xfs_trans_commit+0x146/0x220
[   70.969153]  [<ffffffff8136b707>] xfs_file_fallocate+0x2e7/0x300
[   70.969155]  [<ffffffff8122f8c8>] ? __sb_start_write+0x58/0xf0
[   70.969158]  [<ffffffff8146a544>] ? selinux_file_permission+0xc4/0x120
[   70.969160]  [<ffffffff8122b31f>] do_fallocate+0x12f/0x1d0
[   70.969163]  [<ffffffff8122b408>] SyS_fallocate+0x48/0x80
[   70.969165]  [<ffffffff8197f1a9>] system_call_fastpath+0x12/0x17
[   70.969166] ---[ end trace cb00af92b6f227a7 ]---

That's WARN_ON(!mutex_is_locked(&inode->i_mutex));

--Andy


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Andy Lutomirski
AMA Capital Management, LLC

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
