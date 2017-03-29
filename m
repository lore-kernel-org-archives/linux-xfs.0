Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60531 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755165AbdC2Kl3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Mar 2017 06:41:29 -0400
Date: Wed, 29 Mar 2017 12:41:26 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Message-ID: <20170329104126.GF27994@dhcp22.suse.cz>
References: <20170328122559.966310440@linuxfoundation.org>
 <20170328122601.905696872@linuxfoundation.org>
 <20170328124312.GE18241@dhcp22.suse.cz>
 <CAOi1vP-TeEwNM8n=Z5b6yx1epMDVJ4f7+S1poubA7zfT7L0hQQ@mail.gmail.com>
 <20170328133040.GJ18241@dhcp22.suse.cz>
 <CAOi1vP-doHSj8epQ1zLBnEi8QM4Eb7nFb5uo-XeUquZUkhacsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP-doHSj8epQ1zLBnEi8QM4Eb7nFb5uo-XeUquZUkhacsg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

[CC xfs guys]

On Wed 29-03-17 11:21:44, Ilya Dryomov wrote:
[...]
> This is a set of stack traces from http://tracker.ceph.com/issues/19309
> (linked in the changelog):
> 
> Workqueue: ceph-msgr con_work [libceph]
> ffff8810871cb018 0000000000000046 0000000000000000 ffff881085d40000
> 0000000000012b00 ffff881025cad428 ffff8810871cbfd8 0000000000012b00
> ffff880102fc1000 ffff881085d40000 ffff8810871cb038 ffff8810871cb148
> Call Trace:
> [<ffffffff816dd629>] schedule+0x29/0x70
> [<ffffffff816e066d>] schedule_timeout+0x1bd/0x200
> [<ffffffff81093ffc>] ? ttwu_do_wakeup+0x2c/0x120
> [<ffffffff81094266>] ? ttwu_do_activate.constprop.135+0x66/0x70
> [<ffffffff816deb5f>] wait_for_completion+0xbf/0x180
> [<ffffffff81097cd0>] ? try_to_wake_up+0x390/0x390
> [<ffffffff81086335>] flush_work+0x165/0x250

I suspect this is xlog_cil_push_now -> flush_work(&cil->xc_push_work)
right? I kind of got lost where this waits on an IO.

> [<ffffffff81082940>] ? worker_detach_from_pool+0xd0/0xd0
> [<ffffffffa03b65b1>] xlog_cil_force_lsn+0x81/0x200 [xfs]
> [<ffffffff816d6b42>] ? __slab_free+0xee/0x234
> [<ffffffffa03b4b1d>] _xfs_log_force_lsn+0x4d/0x2c0 [xfs]
> [<ffffffff811adc1e>] ? lookup_page_cgroup_used+0xe/0x30
> [<ffffffffa039a723>] ? xfs_reclaim_inode+0xa3/0x330 [xfs]
> [<ffffffffa03b4dcf>] xfs_log_force_lsn+0x3f/0xf0 [xfs]
> [<ffffffffa039a723>] ? xfs_reclaim_inode+0xa3/0x330 [xfs]
> [<ffffffffa03a62c6>] xfs_iunpin_wait+0xc6/0x1a0 [xfs]
> [<ffffffff810aa250>] ? wake_atomic_t_function+0x40/0x40
> [<ffffffffa039a723>] xfs_reclaim_inode+0xa3/0x330 [xfs]
[...]
> [<ffffffff815b933e>] sock_alloc+0x1e/0x80
> [<ffffffff815ba855>] __sock_create+0x95/0x220
> [<ffffffff815baa04>] sock_create_kern+0x24/0x30
> [<ffffffffa04794d9>] con_work+0xef9/0x2050 [libceph]
> [<ffffffffa04aa9ec>] ? rbd_img_request_submit+0x4c/0x60 [rbd]
> [<ffffffff81084c19>] process_one_work+0x159/0x4f0
> [<ffffffff8108561b>] worker_thread+0x11b/0x530
> [<ffffffff81085500>] ? create_worker+0x1d0/0x1d0
> [<ffffffff8108b6f9>] kthread+0xc9/0xe0
> [<ffffffff8108b630>] ? flush_kthread_worker+0x90/0x90
> [<ffffffff816e1b98>] ret_from_fork+0x58/0x90
> [<ffffffff8108b630>] ? flush_kthread_worker+0x90/0x90
>
> We are writing out data on ceph_connection X:
> 
> ceph_con_workfn
>   mutex_lock(&con->mutex)  # ceph_connection::mutex
>   try_write
>     ceph_tcp_connect
>       sock_create_kern
>         GFP_KERNEL allocation
>           allocator recurses into XFS, more I/O is issued

I am not sure this is true actually. XFS tends to do an IO from a
separate kworkers rather than the direct reclaim context.

> Workqueue: rbd rbd_request_workfn [rbd]
> ffff880047a83b38 0000000000000046 ffff881025350c00 ffff8800383fa9e0
> 0000000000012b00 0000000000000000 ffff880047a83fd8 0000000000012b00
> ffff88014b638860 ffff8800383fa9e0 ffff880047a83b38 ffff8810878dc1b8
> Call Trace:
> [<ffffffff816dd629>] schedule+0x29/0x70
> [<ffffffff816dd906>] schedule_preempt_disabled+0x16/0x20
> [<ffffffff816df755>] __mutex_lock_slowpath+0xa5/0x110
> [<ffffffffa048ad66>] ? ceph_str_hash+0x26/0x80 [libceph]
> [<ffffffff816df7f6>] mutex_lock+0x36/0x4a
> [<ffffffffa04784fd>] ceph_con_send+0x4d/0x130 [libceph]
> [<ffffffffa047d3f0>] __send_queued+0x120/0x150 [libceph]
> [<ffffffffa047fe7b>] __ceph_osdc_start_request+0x5b/0xd0 [libceph]
> [<ffffffffa047ff41>] ceph_osdc_start_request+0x51/0x80 [libceph]
> [<ffffffffa04a8050>] rbd_obj_request_submit.isra.27+0x10/0x20 [rbd]
> [<ffffffffa04aa6de>] rbd_img_obj_request_submit+0x23e/0x500 [rbd]
> [<ffffffffa04aa9ec>] rbd_img_request_submit+0x4c/0x60 [rbd]
> [<ffffffffa04ab3d5>] rbd_request_workfn+0x305/0x410 [rbd]
> [<ffffffff81084c19>] process_one_work+0x159/0x4f0
> [<ffffffff8108561b>] worker_thread+0x11b/0x530
> [<ffffffff81085500>] ? create_worker+0x1d0/0x1d0
> [<ffffffff8108b6f9>] kthread+0xc9/0xe0
> [<ffffffff8108b630>] ? flush_kthread_worker+0x90/0x90
> [<ffffffff816e1b98>] ret_from_fork+0x58/0x90
> [<ffffffff8108b630>] ? flush_kthread_worker+0x90/0x90
> 
> Here is that I/O.  We grab ceph_osd_client::request_mutex, but
> ceph_connection::mutex is being held by the worker that recursed into
> XFS:
> 
> rbd_queue_workfn
>   ceph_osdc_start_request
>     mutex_lock(&osdc->request_mutex);
>     ceph_con_send
>       mutex_lock(&con->mutex)  # deadlock
> 
> 
> Workqueue: ceph-msgr con_work [libceph]
> ffff88014a89fc08 0000000000000046 ffff88014a89fc18 ffff88013a2d90c0
> 0000000000012b00 0000000000000000 ffff88014a89ffd8 0000000000012b00
> ffff880015a210c0 ffff88013a2d90c0 0000000000000000 ffff882028a84798
> Call Trace:
> [<ffffffff816dd629>] schedule+0x29/0x70
> [<ffffffff816dd906>] schedule_preempt_disabled+0x16/0x20
> [<ffffffff816df755>] __mutex_lock_slowpath+0xa5/0x110
> [<ffffffff816df7f6>] mutex_lock+0x36/0x4a
> [<ffffffffa047ec1f>] alloc_msg+0xcf/0x210 [libceph]
> [<ffffffffa0479c55>] con_work+0x1675/0x2050 [libceph]
> [<ffffffff81093ffc>] ? ttwu_do_wakeup+0x2c/0x120
> [<ffffffff81094266>] ? ttwu_do_activate.constprop.135+0x66/0x70
> [<ffffffff81084c19>] process_one_work+0x159/0x4f0
> [<ffffffff8108561b>] worker_thread+0x11b/0x530
> [<ffffffff81085500>] ? create_worker+0x1d0/0x1d0
> [<ffffffff8108b6f9>] kthread+0xc9/0xe0
> [<ffffffff8108b630>] ? flush_kthread_worker+0x90/0x90
> [<ffffffff816e1b98>] ret_from_fork+0x58/0x90
> [<ffffffff8108b630>] ? flush_kthread_worker+0x90/0x90
> 
> Workqueue: ceph-msgr con_work [libceph]
> ffff88014c10fc08 0000000000000046 ffff88013a2d9988 ffff88013a2d9920
> 0000000000012b00 0000000000000000 ffff88014c10ffd8 0000000000012b00
> ffffffff81c1b4a0 ffff88013a2d9920 0000000000000000 ffff882028a84798
> Call Trace:
> [<ffffffff816dd629>] schedule+0x29/0x70
> [<ffffffff816dd906>] schedule_preempt_disabled+0x16/0x20
> [<ffffffff816df755>] __mutex_lock_slowpath+0xa5/0x110
> [<ffffffff816df7f6>] mutex_lock+0x36/0x4a
> [<ffffffffa047ec1f>] alloc_msg+0xcf/0x210 [libceph]
> [<ffffffffa0479c55>] con_work+0x1675/0x2050 [libceph]
> [<ffffffff810a076c>] ? put_prev_entity+0x3c/0x2e0
> [<ffffffff8109b315>] ? sched_clock_cpu+0x95/0xd0
> [<ffffffff81084c19>] process_one_work+0x159/0x4f0
> [<ffffffff8108561b>] worker_thread+0x11b/0x530
> [<ffffffff81085500>] ? create_worker+0x1d0/0x1d0
> [<ffffffff8108b6f9>] kthread+0xc9/0xe0
> [<ffffffff8108b630>] ? flush_kthread_worker+0x90/0x90
> [<ffffffff816e1b98>] ret_from_fork+0x58/0x90
> [<ffffffff8108b630>] ? flush_kthread_worker+0x90/0x90
> 
> These two are replies on ceph_connections Y and Z, which need
> ceph_osd_client::request_mutex to figure out which requests can be
> completed:
> 
> alloc_msg
>   get_reply
>     mutex_lock(&osdc->request_mutex);
> 
> Eventually everything else blocks on ceph_osd_client::request_mutex,
> since it's used for both submitting requests and handling replies.
> 
> This really is a straightforward "using GFP_KERNEL on the writeback
> path isn't allowed" case.  I'm not sure what made you worried here.

I am still not sure there is the dependency there. But if anything and
the con->mutex is the lock which is dangerous to recurse back to the FS
then please wrap the whole scope which takes the lock with the
memalloc_noio_save (or memalloc_nofs_save currently sitting in the mmotm
tree, if you can wait until that API gets merged) with a big fat comment
explaining why that is needed. Sticking the scope protection down the
path is just hard to understand later on. And as already mentioned
NOFS/NOIO context are (ab)used way too much without a clear/good reason.
-- 
Michal Hocko
SUSE Labs
