Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751312AbeAWQbf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jan 2018 11:31:35 -0500
Date: Tue, 23 Jan 2018 11:31:34 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: aio/dio write vs. file_update_time
Message-ID: <20180123163133.GD32478@bfoster.bfoster>
References: <52c2b3db-26cb-df95-2a77-866d27ce146c@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52c2b3db-26cb-df95-2a77-866d27ce146c@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 06:10:51PM +0200, Avi Kivity wrote:
> I'm seeing the following lock contention in io_submit() (unfortunately,
> older kernel again)
> 
> 
>  0xffffffff816ab231 : __schedule+0x531/0x9b0 [kernel]
>  0xffffffff816ab6d9 : schedule+0x29/0x70 [kernel]
>  0xffffffff816acfc5 : rwsem_down_write_failed+0x225/0x3a0 [kernel]
>  0xffffffff81333ca7 : call_rwsem_down_write_failed+0x17/0x30 [kernel]
>  0xffff8819bc3f3bf8 : 0xffff8819bc3f3bf8
>  0xffffffff816aa8bd : down_write+0x2d/0x3d [kernel]
>  0xffffffffc00ca1d1 : xfs_ilock+0xc1/0x120 [xfs]
>  0xffffffffc00c7c8d : xfs_vn_update_time+0xcd/0x150 [xfs]
>  0xffffffff8121eda5 : update_time+0x25/0xd0 [kernel]
>  0xffffffff8121eef0 : file_update_time+0xa0/0xf0 [kernel]
>  0xffffffffc00be3a5 : xfs_file_aio_write_checks+0x185/0x1f0 [xfs]
>  0xffffffffc00be6c9 : xfs_file_dio_aio_write+0xd9/0x390 [xfs]
>  0xffffffffc00bed42 : xfs_file_aio_write+0x102/0x1b0 [xfs]
>  0xffffffffc00bec40 : xfs_file_aio_write+0x0/0x1b0 [xfs]
>  0xffffffff81255ff8 : do_io_submit+0x3b8/0x870 [kernel]
> 
> 
> There is only one thread issuing those writes, and nobody is reading the
> file. Who could possibly be contending on this lock?
> 

That looks like XFS_ILOCK_EXCL, which is a low level lock and thus not
necessarily restricted to user-driven operations. One possible example
of a background user is xfsaild, which acquires XFS_ILOCK_SHARED (and
thus locks out exclusive waiters) via xfs_inode_item_push() in order to
flush the dirty inode to disk (i.e., metadata writeback).

I'm not exactly sure that's what is going on in your particular case,
but I think tracepoints are your friend here. ;) E.g., 'trace-cmd record
-e xfs:xfs_ilock' for the ilock, perhaps others for more context if
necessary..

> 
> I'm seeing 200ms stalls, so my guess is a log flush is involved.
> 
> 
> Is this lock contention covered by RWF_NOWAIT?
> 

I don't think so. It looked to me that RWF_NOWAIT basically just skips
allocations..

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
