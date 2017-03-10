Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933046AbdCJOGB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Mar 2017 09:06:01 -0500
Date: Fri, 10 Mar 2017 09:05:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS race on umount
Message-ID: <20170310140535.GB27272@bfoster.bfoster>
References: <20170310120406.GU16870@chrystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170310120406.GU16870@chrystal>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Mar 10, 2017 at 01:04:06PM +0100, Quentin Casasnovas wrote:
> Hi Guys,
> 
> We've been using XFS recently on our build system because we found that it
> scales pretty well and we have good use for the reflink feature :)
> 
> I think our setup is relivatively unique in that on every one of our build
> server, we mount hundreds of XFS filesystem from NBD devices in parallel,
> where our build environment are stored on qcow2 images and connected with
> qemu-nbd, then umount them when the build is finished.  Those qcow2 images
> are stored on a NFS mount, which leads to some (expected) hickups when
> reading/writing blocks where sometimes the NBD layer will return some
> errors to the block layer, which in turn will pass them on to XFS.  It
> could be due to network contention, very high load on the server, or any
> transcient error really, and in those cases, XFS will normally force shut
> down the filesystem and wait for a umount.
> 
> All of this is fine and is exactly the behaviour we'd expect, though it
> turns out that we keep hiting what I think is a race condition between
> umount and a force shutdown from XFS itself, where I have a umount process
> completely stuck in xfs_ail_push_all_sync():
> 
>   [<ffffffff813d987e>] xfs_ail_push_all_sync+0x9e/0xe0
>   [<ffffffff813c20c7>] xfs_unmountfs+0x67/0x150
>   [<ffffffff813c5540>] xfs_fs_put_super+0x20/0x70
>   [<ffffffff811cba7a>] generic_shutdown_super+0x6a/0xf0
>   [<ffffffff811cbb2b>] kill_block_super+0x2b/0x80
>   [<ffffffff811cc067>] deactivate_locked_super+0x47/0x80
>   [<ffffffff811ccc19>] deactivate_super+0x49/0x70
>   [<ffffffff811e7b3e>] cleanup_mnt+0x3e/0x90
>   [<ffffffff811e7bdd>] __cleanup_mnt+0xd/0x10
>   [<ffffffff810e1b39>] task_work_run+0x79/0xa0
>   [<ffffffff810c2df7>] exit_to_usermode_loop+0x4f/0x75
>   [<ffffffff8100134b>] syscall_return_slowpath+0x5b/0x70
>   [<ffffffff81a2cbe3>] entry_SYSCALL_64_fastpath+0x96/0x98
>   [<ffffffffffffffff>] 0xffffffffffffffff
> 
> This is on a v4.10.1 kernel.  I've had a look at xfs_ail_push_all_sync()
> and I wonder if there isn't a potential lost wake up problem, where I can't
> see that we retest the condition after setting the current process to
> TASK_UNINTERRUPTIBLE and before calling schedule() (though I know nothing
> about XFS internals...).
> 
> Here's an exerpt of relevant dmesg messages that very likely happened at
> the same time the unmount process was started:
> 
>   [29961.767707] block nbd74: Other side returned error (22)
>   [29961.837518] XFS (nbd74): metadata I/O error: block 0x6471ba0 ("xfs_tra=
> ns_read_buf_map") error 5 numblks 32
>   [29961.838172] block nbd74: Other side returned error (22)
>   [29961.838179] block nbd74: Other side returned error (22)
>   [29961.838184] block nbd74: Other side returned error (22)
>   [29961.838203] block nbd74: Other side returned error (22)
>   [29961.838208] block nbd74: Other side returned error (22)
>   [29962.259551] XFS (nbd74): xfs_imap_to_bp: xfs_trans_read_buf() returned=
>  error -5.
>   [29962.356376] XFS (nbd74): xfs_do_force_shutdown(0x8) called from line 3=
> 454 of file fs/xfs/xfs_inode.c.  Return address =3D 0xffffffff813bf471
>   [29962.503003] XFS (nbd74): Corruption of in-memory data detected.  Shutt=
> ing down filesystem
>   [29963.166314] XFS (nbd74): Please umount the filesystem and rectify the =
> problem(s)
> 
> I'm pretty sure the process isn't deadlocking on the spinlock because it
> doesn't burn any CPU and is really out of the scheduler pool.  It should be
> noted that when I noticed the hung umount process, I've manually tried to
> unmount the corresponding XFS mountpoint and that was fine, though it
> obviously didn't "unhang" the stuck umount process.
> 

I'm not parsing the last bit here.. you were able to manually unmount
the hung unmount..?

That aside, could you post a snippet of the tracepoint output
('trace-cmd start -e "xfs:*"; cat /sys/kernel/debug/tracing/trace_pipe')
when the problem occurs? Also, how about the stack of the xfsaild thread
for that specific mount ('ps aux | grep xfsaild; cat
/proc/<pid>/stack').

Brian

> Any help would be appreciated :)
> 
> Thanks,
> Quentin


