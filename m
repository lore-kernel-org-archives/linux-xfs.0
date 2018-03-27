Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751092AbeC0Lup (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Mar 2018 07:50:45 -0400
Date: Tue, 27 Mar 2018 07:50:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Message-ID: <20180327115044.GB3498@bfoster.bfoster>
References: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
 <CAJDdQW29Vjs9=PqREJZa_xHyA33Qdjf6NN95yGyan3ENwDfGZw@mail.gmail.com>
 <20180325215904.GH18129@dastard>
 <20180326162830.GF34912@bfoster.bfoster>
 <CAJDdQW3gOa8ry_XVkcCMf2QT7wC7MvU4b94hMhwJsg9MjYoKgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJDdQW3gOa8ry_XVkcCMf2QT7wC7MvU4b94hMhwJsg9MjYoKgQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Shaohua Li <shli@kernel.org>, linux-xfs@vger.kernel.org

On Tue, Mar 27, 2018 at 06:54:27PM +0800, 张本龙 wrote:
> 2018-03-27 0:28 GMT+08:00 Brian Foster <bfoster@redhat.com>:
> 
> > On Mon, Mar 26, 2018 at 08:59:04AM +1100, Dave Chinner wrote:
> > > On Fri, Mar 23, 2018 at 10:24:03PM +0800, 张本龙 wrote:
> > > > Hi Shaohua and XFS,
> > > >
> > > > May I ask how are we gonna handle REQ_META issued from XFS? As you
> > > > mentioned about charging to root cgroup (also in an earlier email
> > > > discussion), and seems the 4.16.0-rc6 code is not handling it
> > > > separately.
> > > >
> > > > In our case to support XFS cgroup writeback control, which was ported
> > > > and slightly adapted to 3.10.0, ignoring xfs log bios resulted in
> > > > trouble. Threads from throttled docker might submit_bio in following
> > > > path by its own identity, this docker blkcg accumulated large amounts
> > > > of data (e.g., 20GB), thus such log gets blocked.
> > >
> > > And thus displaying the reason why I originally refused to merge
> > > this code until regression tests were added to fstests to exercise
> > > these sorts of issues. This stuff adds new internal filesystem IO
> > > ordering constraints, so we need tests that exercise it and ensure
> > > we don't accidentally break it in future.
> > >
> >
> > Hmm, but if the user issues fsync from the throttled cgroup then won't
> > that throttling occur today, regardless of cgroup aware writeback? My
> > understanding is that cgawb just accurately accounts writeback I/Os to
> > the owner of the cached pages. IOW, if the buffered writer and fsync
> > call are in the same throttled cgroup, then the throttling works just as
> > it would with cgawb and the writer being in a throttled cgroup.
> >
> > So ISTM that this is an independent problem. What am I missing?
> 
> 
> Yeah throttling would work for fsync traffic even without cgwb, but that's
> because the way bio_blkcg() is implemented: charging to bio->bi_css when
> set but submitter blkcg when not. So without cgwb normal traffic from
> writeback kworkers are attributed to blkcg_root, which is normally
> unlimited.
> 

Ok, that's what I thought. Your report shows everything backed up on an
fsync call, however, so I didn't really see how it related to this
patch. So unless Shaohua explains otherwise, my understanding is that
this is not necessarily caused by cgawb, but rather this is a separate
but similar gap in the broader block I/O throttling mechanism that also
needs to be addressed before throttling is usable (in practice) by
filesystems. You presumably deal with this by filtering out metadata
bios, while the patch Shaohua mentions deals with it by promoting
metadata bios to the root cgroup.

Brian

> And fsync might yield kernel INFO messages when bps * 120 < dirty data,
> giving something like below. That's Ok though, since throttling and all
> types
> of sync calls are contradictory in nature.
> ------------------------------------------------------------
> ---------------------------------
> [Mar 2 14:27] INFO: task dd:40794 blocked for more than 120 seconds.
> [  +0.000747]       Not tainted 4.15.7 #1
> [  +0.000610] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [  +0.000614] dd              D    0 40794  40793 0x10000000
> [  +0.000610] Call Trace:
> [  +0.000619]  ? __schedule+0x28d/0x870
> [  +0.000611]  schedule+0x32/0x80
> [  +0.000615]  io_schedule+0x12/0x40
> [  +0.000612]  wait_on_page_bit_common+0xff/0x1a0
> [  +0.000609]  ? page_cache_tree_insert+0xd0/0xd0
> [  +0.000614]  __filemap_fdatawait_range+0xe2/0x150
> [  +0.000614]  file_write_and_wait_range+0x62/0xa0
> [  +0.000664]  xfs_file_fsync+0x65/0x1d0 [xfs]
> [  +0.000621]  do_fsync+0x38/0x60
> [  +0.000610]  SyS_fsync+0xc/0x10
> [  +0.000616]  do_syscall_64+0x6e/0x1a0
> [  +0.000612]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [  +0.000610] RIP: 0033:0x7f8131231020
> [  +0.000604] RSP: 002b:00007fff81c04f48 EFLAGS: 00000246 ORIG_RAX:
> 000000000000004a
> [  +0.000610] RAX: ffffffffffffffda RBX: 00007f8131af9690 RCX:
> 00007f8131231020
> [  +0.000619] RDX: 0000000004000000 RSI: 0000000000000000 RDI:
> 0000000000000001
> [  +0.000626] RBP: 0000000000000020 R08: 00000000ffffffff R09:
> 0000000000000000
> [  +0.000618] R10: 00007fff81c04d10 R11: 0000000000000246 R12:
> 0000000000000020
> [  +0.000620] R13: 0000000000000000 R14: 00007fff81c054cf R15:
> 00007fff81c05198
> 
> 
> > Shaohua,
> >
> > Do you have a reference to the older metadata related patch mentioned in
> > the commit log that presumably addressed this?
> >
> > Brian
> >
> > >
> > > > Not familiar with XFS, but seems log bios are partially stuck in
> > > > throttled cgroups, leaving other innocent groups waiting for
> > > > completion. To cope with this we bypassed REQ_META log bios in
> > > > blk_throtl_bio().
> > >
> > > Yup, the log is global and should not be throttled. Metadata is less
> > > obvious as to what the correct thing to do is, because writes are
> > > always done from internal kernel threads but reads are done from a
> > > mix of kernel threads, user cgroup contexts and user data IO
> > > completions. Hence there are situations where metadata reads may
> > > need to be throttled because they are cgroup context only (e.g.
> > > filesystem directory traversal) but others where reads should not
> > > be throttled because they have global context (e.g. inside a
> > > transaction when other buffers are already locked).
> > >
> 
> 
> Thanks for the explanation Dave. So there are both read and write xfs_buf,
> and reads really seem to be complex then.
> 
> 
> > > Getting this right and keeping it working requires regression tests
> > > that get run on every release, whether it be upstream or distro
> > > kernels, and that means we need tests in fstests to cover cgroup IO
> > > control....
> > >
> > > Cheers,
> > >
> > > Dave.
> > > --
> > > Dave Chinner
> > > david@fromorbit.com
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
