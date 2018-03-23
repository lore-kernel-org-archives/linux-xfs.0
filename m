Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:44965 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbeCWOYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 10:24:05 -0400
Received: by mail-oi0-f50.google.com with SMTP id j143-v6so1525191oih.11
        for <linux-xfs@vger.kernel.org>; Fri, 23 Mar 2018 07:24:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
References: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
From: =?UTF-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>
Date: Fri, 23 Mar 2018 22:24:03 +0800
Message-ID: <CAJDdQW29Vjs9=PqREJZa_xHyA33Qdjf6NN95yGyan3ENwDfGZw@mail.gmail.com>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shaohua Li <shli@kernel.org>
Cc: linux-xfs@vger.kernel.org

Hi Shaohua and XFS,

May I ask how are we gonna handle REQ_META issued from XFS? As you
mentioned about charging to root cgroup (also in an earlier email
discussion), and seems the 4.16.0-rc6 code is not handling it
separately.

In our case to support XFS cgroup writeback control, which was ported
and slightly adapted to 3.10.0, ignoring xfs log bios resulted in
trouble. Threads from throttled docker might submit_bio in following
path by its own identity, this docker blkcg accumulated large amounts
of data (e.g., 20GB), thus such log gets blocked.
------------------------------------------------------------------------------------------------------------------------------------------------
xxx-agent 22825 [001] 78772.391023: probe:submit_bio:
(ffffffff812f70c0) bio=ffff880fb6e1f300 bi_css=0
                  4f70c1 submit_bio
(/usr/lib/debug/lib/modules/3.10.0-514.16.1.el7.cgwb.rdt.x86_64/vmlinux)
                   4e440 xfs_buf_submit ([xfs])
                   6e59b xlog_bdstrat ([xfs])
                   704c5 xlog_sync ([xfs])
                   70683 xlog_state_release_iclog ([xfs])
                   71917 _xfs_log_force_lsn ([xfs])
                   5249e xfs_file_fsync ([xfs])
                  4374d5 do_fsync
(/usr/lib/debug/lib/modules/3.10.0-514.16.1.el7.cgwb.rdt.x86_64/vmlinux)
                  4377a0 sys_fsync
(/usr/lib/debug/lib/modules/3.10.0-514.16.1.el7.cgwb.rdt.x86_64/vmlinux)
                  8a0ac9 system_call
(/usr/lib/debug/lib/modules/3.10.0-514.16.1.el7.cgwb.rdt.x86_64/vmlinux
                  1df9c4 [unknown]
(/home/xxx/xxx-agent/data/install/xxx-agent/16/xxx-agent)

Meanwhile some other container without bps limits, or kworkers from
root cgroup, might get stuck from:
----------------------------------------------------------------------------------------------------------------------------------------------
[79183.692355] INFO: task xxx:33434 blocked for more than 120 seconds.
[79183.730997] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[79183.778095] consul          D ffff880169958000     0 33434  24659 0x00000000
[79183.820478]  ffff880bce3e7e38 0000000000000082 ffff880c7af8bec0
ffff880bce3e7fd8
[79183.865232]  ffff880bce3e7fd8 ffff880bce3e7fd8 ffff880c7af8bec0
ffff880c7af8bec0
[79183.909997]  ffff880169bfa928 ffff880bce3e7ef4 0000000000000000
ffff880c7af8bec0
[79183.954738] Call Trace:
[79183.969516]  [<ffffffff81695ac9>] schedule+0x29/0x70
[79183.999357]  [<ffffffffa073497a>] _xfs_log_force_lsn+0x2fa/0x350 [xfs]
[79184.038497]  [<ffffffff810c84c0>] ? wake_up_state+0x20/0x20
[79184.071941]  [<ffffffffa071542e>] xfs_file_fsync+0x10e/0x1e0 [xfs]
[79184.109010]  [<ffffffff812374d5>] do_fsync+0x65/0xa0
[79184.138826]  [<ffffffff8120368f>] ? SyS_write+0x9f/0xe0
[79184.170182]  [<ffffffff812377a0>] SyS_fsync+0x10/0x20
[79184.200514]  [<ffffffff816a0ac9>] system_call_fastpath+0x16/0x1b
[79184.236613] INFO: task xxx:38778 blocked for more than 120 seconds.
[79184.275238] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[79184.322329] consul          D ffff880fe728af10     0 38778  32505 0x00000000
[79184.364694]  ffff881a18fe7c10 0000000000000082 ffff88196a74bec0
ffff881a18fe7fd8
[79184.409424]  ffff881a18fe7fd8 ffff881a18fe7fd8 ffff88196a74bec0
ffff881a18fe7d60
[79184.454167]  ffff881a18fe7d68 7fffffffffffffff ffff88196a74bec0
ffffffffffffffff
[79184.498909] Call Trace:
[79184.513673]  [<ffffffff81695ac9>] schedule+0x29/0x70
[79184.543475]  [<ffffffff81693529>] schedule_timeout+0x239/0x2c0
[79184.578468]  [<ffffffff810c4f99>] ? ttwu_do_wakeup+0x19/0xd0
[79184.612419]  [<ffffffff810c512d>] ? ttwu_do_activate.constprop.91+0x5d/0x70
[79184.654148]  [<ffffffff810c8308>] ? try_to_wake_up+0x1c8/0x320
[79184.689141]  [<ffffffff81695ea6>] wait_for_completion+0x116/0x170
[79184.725688]  [<ffffffff810c84c0>] ? wake_up_state+0x20/0x20
[79184.759126]  [<ffffffff810ac67c>] flush_work+0xfc/0x1c0
[79184.790481]  [<ffffffff810a85f0>] ? move_linked_works+0x90/0x90
[79184.826020]  [<ffffffffa073622a>] xlog_cil_force_lsn+0x8a/0x210 [xfs]
[79184.864644]  [<ffffffff811850df>] ? __filemap_fdatawrite_range+0xbf/0xe0
[79184.904838]  [<ffffffffa073470f>] _xfs_log_force_lsn+0x8f/0x350 [xfs]
[79184.943467]  [<ffffffff8118531f>] ? filemap_fdatawait_range+0x1f/0x30
[79184.982086]  [<ffffffff81694c42>] ? down_read+0x12/0x30
[79185.013466]  [<ffffffffa071542e>] xfs_file_fsync+0x10e/0x1e0 [xfs]
[79185.050533]  [<ffffffff812374d5>] do_fsync+0x65/0xa0
[79185.080335]  [<ffffffff8120368f>] ? SyS_write+0x9f/0xe0
[79185.111691]  [<ffffffff812377a0>] SyS_fsync+0x10/0x20
[79185.141986]  [<ffffffff816a0ac9>] system_call_fastpath+0x16/0x1b
[79185.178051] INFO: task kworker/1:0:12593 blocked for more than 120 seconds.
[79185.219258] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[79185.266353] kworker/1:0     D ffff8801698caf10     0 12593      2 0x00000000
[79185.308743] Workqueue: xfs-cil/sdb1 xlog_cil_push_work [xfs]
[79185.342757]  ffff880d00e3bbe8 0000000000000046 ffff880169732f10
ffff880d00e3bfd8
[79185.387475]  ffff880d00e3bfd8 ffff880d00e3bfd8 ffff880169732f10
ffff880169bfa800
[79185.432197]  ffff880169bfa928 ffff880bd3b4a5c0 ffff880169732f10
ffff880169bfa900
[79185.476946] Call Trace:
[79185.491725]  [<ffffffff81695ac9>] schedule+0x29/0x70
[79185.521548]  [<ffffffffa073377a>]
xlog_state_get_iclog_space+0x10a/0x310 [xfs]
[79185.565010]  [<ffffffff810c84c0>] ? wake_up_state+0x20/0x20
[79185.598476]  [<ffffffffa0733c99>] xlog_write+0x1a9/0x720 [xfs]
[79185.633477]  [<ffffffffa07359c9>] xlog_cil_push+0x239/0x420 [xfs]
[79185.670037]  [<ffffffffa0735bc5>] xlog_cil_push_work+0x15/0x20 [xfs]
[79185.708138]  [<ffffffff810ab45b>] process_one_work+0x17b/0x470
[79185.743124]  [<ffffffff810ac413>] worker_thread+0x2a3/0x410
[79185.776542]  [<ffffffff810ac170>] ? rescuer_thread+0x460/0x460
[79185.811546]  [<ffffffff810b3a4f>] kthread+0xcf/0xe0
[79185.840835]  [<ffffffff810b3980>] ? kthread_create_on_node+0x140/0x140
[79185.879982]  [<ffffffff816a0a18>] ret_from_fork+0x58/0x90
[79185.912391]  [<ffffffff810b3980>] ? kthread_create_on_node+0x140/0x140

Not familiar with XFS, but seems log bios are partially stuck in
throttled cgroups, leaving other innocent groups waiting for
completion. To cope with this we bypassed REQ_META log bios in
blk_throtl_bio().

So just writing to ensure we know about the issue. Absolutely great if
your other patch already fixed this!

Thanks,
Benlong


2018-03-23 5:11 GMT+08:00 Shaohua Li <shli@kernel.org>:
> From: Shaohua Li <shli@fb.com>
>
> Basically this is a copy of commit 001e4a8775f6(ext4: implement cgroup
> writeback support). Tested with a fio test, verified writeback is
> throttled against cgroup io.max write bandwidth, also verified moving
> the fio test to another cgroup and the writeback is throttled against
> new cgroup setting.
>
> This only controls the file data write for cgroup. For metadata, since
> xfs dispatches the metadata write in specific threads, it's possible low
> prio app's metadata could harm high prio app's metadata. A while back,
> Tejun has a patch to force metadata belonging to root cgroup for btrfs.
> I had a similiar patch for xfs too. But Since Tejun's patch isn't in
> upstream, I'll delay post the xfs patch.
>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  fs/xfs/xfs_aops.c  | 13 +++++++++++--
>  fs/xfs/xfs_super.c |  1 +
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 19eadc8..5f70584 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -589,7 +589,8 @@ xfs_alloc_ioend(
>         struct inode            *inode,
>         unsigned int            type,
>         xfs_off_t               offset,
> -       struct buffer_head      *bh)
> +       struct buffer_head      *bh,
> +       struct writeback_control *wbc)
>  {
>         struct xfs_ioend        *ioend;
>         struct bio              *bio;
> @@ -606,6 +607,8 @@ xfs_alloc_ioend(
>         INIT_WORK(&ioend->io_work, xfs_end_io);
>         ioend->io_append_trans = NULL;
>         ioend->io_bio = bio;
> +       /* attach new bio to its cgroup */
> +       wbc_init_bio(wbc, bio);
>         return ioend;
>  }
>
> @@ -633,6 +636,8 @@ xfs_chain_bio(
>         ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
>         submit_bio(ioend->io_bio);
>         ioend->io_bio = new;
> +       /* attach new bio to its cgroup */
> +       wbc_init_bio(wbc, new);
>  }
>
>  /*
> @@ -656,7 +661,8 @@ xfs_add_to_ioend(
>             offset != wpc->ioend->io_offset + wpc->ioend->io_size) {
>                 if (wpc->ioend)
>                         list_add(&wpc->ioend->io_list, iolist);
> -               wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type, offset, bh);
> +               wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type, offset,
> +                                            bh, wbc);
>         }
>
>         /*
> @@ -666,6 +672,9 @@ xfs_add_to_ioend(
>         while (xfs_bio_add_buffer(wpc->ioend->io_bio, bh) != bh->b_size)
>                 xfs_chain_bio(wpc->ioend, wbc, bh);
>
> +       /* Charge write size to its cgroup for cgroup switching track */
> +       wbc_account_io(wbc, bh->b_page, bh->b_size);
> +
>         wpc->ioend->io_size += bh->b_size;
>         wpc->last_block = bh->b_blocknr;
>         xfs_start_buffer_writeback(bh);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 951271f..95c2d3d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1666,6 +1666,7 @@ xfs_fs_fill_super(
>         sb->s_max_links = XFS_MAXLINK;
>         sb->s_time_gran = 1;
>         set_posix_acl_flag(sb);
> +       sb->s_iflags |= SB_I_CGROUPWB;
>
>         /* version 5 superblocks support inode version counters. */
>         if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
> --
> 2.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
