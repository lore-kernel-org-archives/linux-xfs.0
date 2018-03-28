Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:46295 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbeC1JzL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Mar 2018 05:55:11 -0400
Received: by mail-oi0-f45.google.com with SMTP id e123-v6so1589285oih.13
        for <linux-xfs@vger.kernel.org>; Wed, 28 Mar 2018 02:55:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180327115044.GB3498@bfoster.bfoster>
References: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
 <CAJDdQW29Vjs9=PqREJZa_xHyA33Qdjf6NN95yGyan3ENwDfGZw@mail.gmail.com>
 <20180325215904.GH18129@dastard> <20180326162830.GF34912@bfoster.bfoster>
 <CAJDdQW3gOa8ry_XVkcCMf2QT7wC7MvU4b94hMhwJsg9MjYoKgQ@mail.gmail.com> <20180327115044.GB3498@bfoster.bfoster>
From: =?UTF-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>
Date: Wed, 28 Mar 2018 17:55:09 +0800
Message-ID: <CAJDdQW2UwSOV3aUSjHjuY-iyQ_eNVTA+sPaiFXGNhWJjGizT5w@mail.gmail.com>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Shaohua Li <shli@kernel.org>, linux-xfs@vger.kernel.org

2018-03-27 19:50 GMT+08:00 Brian Foster <bfoster@redhat.com>:
> On Tue, Mar 27, 2018 at 06:54:27PM +0800, =E5=BC=A0=E6=9C=AC=E9=BE=99 wro=
te:
>> 2018-03-27 0:28 GMT+08:00 Brian Foster <bfoster@redhat.com>:
>>
>> > On Mon, Mar 26, 2018 at 08:59:04AM +1100, Dave Chinner wrote:
>> > > On Fri, Mar 23, 2018 at 10:24:03PM +0800, =E5=BC=A0=E6=9C=AC=E9=BE=
=99 wrote:
>> > > > Hi Shaohua and XFS,
>> > > >
>> > > > May I ask how are we gonna handle REQ_META issued from XFS? As you
>> > > > mentioned about charging to root cgroup (also in an earlier email
>> > > > discussion), and seems the 4.16.0-rc6 code is not handling it
>> > > > separately.
>> > > >
>> > > > In our case to support XFS cgroup writeback control, which was por=
ted
>> > > > and slightly adapted to 3.10.0, ignoring xfs log bios resulted in
>> > > > trouble. Threads from throttled docker might submit_bio in followi=
ng
>> > > > path by its own identity, this docker blkcg accumulated large amou=
nts
>> > > > of data (e.g., 20GB), thus such log gets blocked.
>> > >
>> > > And thus displaying the reason why I originally refused to merge
>> > > this code until regression tests were added to fstests to exercise
>> > > these sorts of issues. This stuff adds new internal filesystem IO
>> > > ordering constraints, so we need tests that exercise it and ensure
>> > > we don't accidentally break it in future.
>> > >
>> >
>> > Hmm, but if the user issues fsync from the throttled cgroup then won't
>> > that throttling occur today, regardless of cgroup aware writeback? My
>> > understanding is that cgawb just accurately accounts writeback I/Os to
>> > the owner of the cached pages. IOW, if the buffered writer and fsync
>> > call are in the same throttled cgroup, then the throttling works just =
as
>> > it would with cgawb and the writer being in a throttled cgroup.
>> >
>> > So ISTM that this is an independent problem. What am I missing?
>>
>>
>> Yeah throttling would work for fsync traffic even without cgwb, but that=
's
>> because the way bio_blkcg() is implemented: charging to bio->bi_css when
>> set but submitter blkcg when not. So without cgwb normal traffic from
>> writeback kworkers are attributed to blkcg_root, which is normally
>> unlimited.
>>
>
> Ok, that's what I thought. Your report shows everything backed up on an
> fsync call, however, so I didn't really see how it related to this

Sorry for misleading but the original report is not showing things
backed up on fsync. It shows fsync MIGHT submit the log.
--------------------------------------------------------------------------
xxx-agent 22825 [001] 78772.391023: probe:submit_bio:
                  4f70c1 submit_bio
                   4e440 xfs_buf_submit ([xfs])
                   6e59b xlog_bdstrat ([xfs])
                   704c5 xlog_sync ([xfs])
                   70683 xlog_state_release_iclog ([xfs])
                   71917 _xfs_log_force_lsn ([xfs])
                   5249e xfs_file_fsync ([xfs])
                  4374d5 do_fsync
                  4377a0 sys_fsync
                  8a0ac9 system_call
                  1df9c4 [unknown]
Please note this is NOT a kernel INFO, it's a dynamic perf probe trace
to see who is submitting log. As the agent's docker is now blocked by
other fio threads, the log would be stuck from this path.

The following trace is kernel INFO, it shows another docker waits for
log integrity and timeout, similar is the 3rd other trace via
flush_work(). Again not completely sure about XFS, but the traces and
code diving seems to suggest it.
---------------------------------------------------------------------------=
----------------------
[79183.692355] INFO: task xxx:33434 blocked for more than 120 seconds.
[79183.730997] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
......
[79183.954738] Call Trace:
[79183.969516]  [<ffffffff81695ac9>] schedule+0x29/0x70
                                          /*    inline xlog_wait here */
[79183.999357]  [<ffffffffa073497a>] _xfs_log_force_lsn+0x2fa/0x350 [xfs]
[79184.038497]  [<ffffffff810c84c0>] ? wake_up_state+0x20/0x20
[79184.071941]  [<ffffffffa071542e>] xfs_file_fsync+0x10e/0x1e0 [xfs]
[79184.109010]  [<ffffffff812374d5>] do_fsync+0x65/0xa0
[79184.138826]  [<ffffffff8120368f>] ? SyS_write+0x9f/0xe0
[79184.170182]  [<ffffffff812377a0>] SyS_fsync+0x10/0x20
[79184.200514]  [<ffffffff816a0ac9>] system_call_fastpath+0x16/0x1b

> patch. So unless Shaohua explains otherwise, my understanding is that
> this is not necessarily caused by cgawb, but rather this is a separate
> but similar gap in the broader block I/O throttling mechanism that also
> needs to be addressed before throttling is usable (in practice) by
> filesystems. You presumably deal with this by filtering out metadata
> bios, while the patch Shaohua mentions deals with it by promoting
> metadata bios to the root cgroup.

Either way would work, agreed. Though I wouldn't call it 'priority
inversion', as Dave explained it's more like 'global log mistakenly
throttled'. The report is to provide some evidence that this single
patch is not enough for xfs writeback. And we should wait for the
other patch from Shaohua.

>
> Brian
>
>> And fsync might yield kernel INFO messages when bps * 120 < dirty data,
>> giving something like below. That's Ok though, since throttling and all
>> types
>> of sync calls are contradictory in nature.
>> ------------------------------------------------------------
>> ---------------------------------
>> [Mar 2 14:27] INFO: task dd:40794 blocked for more than 120 seconds.
>> [  +0.000747]       Not tainted 4.15.7 #1
>> [  +0.000610] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s
>> this message.
>> [  +0.000614] dd              D    0 40794  40793 0x10000000
>> [  +0.000610] Call Trace:
>> [  +0.000619]  ? __schedule+0x28d/0x870
>> [  +0.000611]  schedule+0x32/0x80
>> [  +0.000615]  io_schedule+0x12/0x40
>> [  +0.000612]  wait_on_page_bit_common+0xff/0x1a0
>> [  +0.000609]  ? page_cache_tree_insert+0xd0/0xd0
>> [  +0.000614]  __filemap_fdatawait_range+0xe2/0x150
>> [  +0.000614]  file_write_and_wait_range+0x62/0xa0
>> [  +0.000664]  xfs_file_fsync+0x65/0x1d0 [xfs]
>> [  +0.000621]  do_fsync+0x38/0x60
>> [  +0.000610]  SyS_fsync+0xc/0x10
>> [  +0.000616]  do_syscall_64+0x6e/0x1a0
>> [  +0.000612]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>> [  +0.000610] RIP: 0033:0x7f8131231020
>> [  +0.000604] RSP: 002b:00007fff81c04f48 EFLAGS: 00000246 ORIG_RAX:
>> 000000000000004a
>> [  +0.000610] RAX: ffffffffffffffda RBX: 00007f8131af9690 RCX:
>> 00007f8131231020
>> [  +0.000619] RDX: 0000000004000000 RSI: 0000000000000000 RDI:
>> 0000000000000001
>> [  +0.000626] RBP: 0000000000000020 R08: 00000000ffffffff R09:
>> 0000000000000000
>> [  +0.000618] R10: 00007fff81c04d10 R11: 0000000000000246 R12:
>> 0000000000000020
>> [  +0.000620] R13: 0000000000000000 R14: 00007fff81c054cf R15:
>> 00007fff81c05198
>>
>>
>> > Shaohua,
>> >
>> > Do you have a reference to the older metadata related patch mentioned =
in
>> > the commit log that presumably addressed this?
>> >
>> > Brian
>> >
>> > >
>> > > > Not familiar with XFS, but seems log bios are partially stuck in
>> > > > throttled cgroups, leaving other innocent groups waiting for
>> > > > completion. To cope with this we bypassed REQ_META log bios in
>> > > > blk_throtl_bio().
>> > >
>> > > Yup, the log is global and should not be throttled. Metadata is less
>> > > obvious as to what the correct thing to do is, because writes are
>> > > always done from internal kernel threads but reads are done from a
>> > > mix of kernel threads, user cgroup contexts and user data IO
>> > > completions. Hence there are situations where metadata reads may
>> > > need to be throttled because they are cgroup context only (e.g.
>> > > filesystem directory traversal) but others where reads should not
>> > > be throttled because they have global context (e.g. inside a
>> > > transaction when other buffers are already locked).
>> > >
>>
>>
>> Thanks for the explanation Dave. So there are both read and write xfs_bu=
f,
>> and reads really seem to be complex then.
>>
>>
>> > > Getting this right and keeping it working requires regression tests
>> > > that get run on every release, whether it be upstream or distro
>> > > kernels, and that means we need tests in fstests to cover cgroup IO
>> > > control....
>> > >
>> > > Cheers,
>> > >
>> > > Dave.
>> > > --
>> > > Dave Chinner
>> > > david@fromorbit.com
>> > > --
>> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs"=
 in
>> > > the body of a message to majordomo@vger.kernel.org
>> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
