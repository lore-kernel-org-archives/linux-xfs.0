Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8CED57F37
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 08:10:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6CE03304051
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 06:10:10 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Gcchz8tHNC5lDCwO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2015 06:10:03 -0800 (PST)
Date: Mon, 30 Nov 2015 09:10:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151130141000.GC24765@bfoster.bfoster>
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
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
To: Glauber Costa <glauber@scylladb.com>
Cc: Avi Kivity <avi@scylladb.com>, xfs@oss.sgi.com

On Fri, Nov 27, 2015 at 09:43:50PM -0500, Glauber Costa wrote:
> Hello my dear XFSers,
> 
> For those of you who don't know, we at ScyllaDB produce a modern NoSQL
> data store that, at the moment, runs on top of XFS only. We deal
> exclusively with asynchronous and direct IO, due to our
> thread-per-core architecture. Due to that, we avoid issuing any
> operation that will sleep.
> 
> While debugging an extreme case of bad performance (most likely
> related to a not-so-great disk), I have found a variety of cases in
> which XFS blocks. To find those, I have used perf record -e
> sched:sched_switch -p <pid_of_db>, and I am attaching the perf report
> as xfs-sched_switch.log. Please note that this doesn't tell me for how
> long we block, but as mentioned before, blocking operations outside
> our control are detrimental to us regardless of the elapsed time.
> 
> For those who are not acquainted to our internals, please ignore
> everything in that file but the xfs functions. For the xfs symbols,
> there are two kinds of events: the ones that are a children of
> io_submit, where we don't tolerate blocking, and the ones that are
> children of our helper IO thread, to where we push big operations that
> we know will block until we can get rid of them all. We care about the
> former and ignore the latter.
> 
> Please allow me to ask you a couple of questions about those findings.
> If we are doing anything wrong, advise on best practices is truly
> welcome.
> 
> 1) xfs_buf_lock -> xfs_log_force.
> 
> I've started wondering what would make xfs_log_force sleep. But then I
> have noticed that xfs_log_force will only be called when a buffer is
> marked stale. Most of the times a buffer is marked stale seems to be
> due to errors. Although that is not my case (more on that), it got me
> thinking that maybe the right thing to do would be to avoid hitting
> this case altogether?
> 

I'm not following where you get the "only if marked stale" part..? It
certainly looks like that's one potential purpose for the call, but this
is called in a variety of other places as well. E.g., forcing the log
via pushing on the ail when it has pinned items is another case. The ail
push itself can originate from transaction reservation, etc., when log
space is needed. In other words, I'm not sure this is something that's
easily controlled from userspace, if at all. Rather, it's a significant
part of the wider state machine the fs uses to manage logging.

> The file example-stale.txt contains a backtrace of the case where we
> are being marked as stale. It seems to be happening when we convert
> the the inode's extents from unwritten to real. Can this case be
> avoided? I won't pretend I know the intricacies of this, but couldn't
> we be keeping extents from the very beginning to avoid creating stale
> buffers?
> 

This is down in xfs_fs_evict_inode()->xfs_inactive(), which is generally
when an inode is evicted from cache. In this case, it looks like the
inode is unlinked (permanently removed), the extents are being removed
and a bmap btree block is being invalidated as part of that overall
process. I don't think this has anything to do with unwritten extents.

> 2) xfs_buf_lock -> down
> This is one I truly don't understand. What can be causing contention
> in this lock? We never have two different cores writing to the same
> buffer, nor should we have the same core doingCAP_FOWNER so.
> 

This is not one single lock. An XFS buffer is the data structure used to
modify/log/read-write metadata on-disk and each buffer has its own lock
to prevent corruption. Buffer lock contention is possible because the
filesystem has bits of "global" metadata that has to be updated via
buffers.

For example, usually one has multiple allocation groups to maximize
parallelism, but we still have per-ag metadata that has to be tracked
globally with respect to each AG (e.g., free space trees, inode
allocation trees, etc.). Any operation that affects this metadata (e.g.,
block/inode allocation) has to lock the agi/agf buffers along with any
buffers associated with the modified btree leaf/node blocks, etc.

One example in your attached perf traces has several threads looking to
acquire the AGF, which is a per-AG data structure for tracking free
space in the AG. One thread looks like the inode eviction case noted
above (freeing blocks), another looks like a file truncate (also freeing
blocks), and yet another is a block allocation due to a direct I/O
write. Were any of these operations directed to an inode in a separate
AG, they would be able to proceed in parallel (but I believe they would
still hit the same codepaths as far as perf can tell).

> 3) xfs_file_aio_write_checks -> file_update_time -> xfs_vn_update_time
> 
> You guys seem to have an interface to avoid that, by setting the
> FMODE_NOCMTIME flag. This is done by issuing the open by handle ioctl,
> which will set this flag for all regular files. That's great, but that
> ioctl required CAP_SYS_ADMIN, which is a big no for us, since we run
> our server as an unprivileged user. I don't understand, however, why
> such an strict check is needed. If we have full rights on the
> filesystem, why can't we issue this operation? In my view, CAP_FOWNER
> should already be enough.I do understand the handles have to be stable
> and a file can have its ownership changed, in which case the previous
> owner would keep the handle valid. Is that the reason you went with
> the most restrictive capability ?

I'm not familiar enough with the open-by-handle stuff to comment on the
permission constraints. Perhaps Dave or others can comment further on
this bit...

Brian

> # To display the perf.data header info, please use --header/--header-only options.
> #
> #
> # Total Lost Samples: 0
> #
> # Samples: 2K of event 'sched:sched_switch'
> # Event count (approx.): 2669
> #
> # Overhead  Command  Shared Object      Symbol        
> # ........  .......  .................  ..............
> #
>    100.00%  scylla   [kernel.kallsyms]  [k] __schedule
>              |
>              ---__schedule
>                 |          
>                 |--96.18%-- schedule
>                 |          |          
>                 |          |--56.14%-- schedule_user
>                 |          |          |          
>                 |          |          |--53.30%-- int_careful
>                 |          |          |          |          
>                 |          |          |          |--45.05%-- 0x7f4ade6f74ed
>                 |          |          |          |          reactor_backend_epoll::make_reactor_notifier
>                 |          |          |          |          |          
>                 |          |          |          |          |--67.63%-- syscall_work_queue::submit_item
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--32.05%-- posix_file_impl::truncate
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--65.33%-- _ZN12continuationIZN6futureIJEE4thenIZN19file_data_sink_impl5flushEvEUlvE_S1_EET0_OT_EUlS7_E_JEE3runEv
>                 |          |          |          |          |          |          |          reactor::del_timer
>                 |          |          |          |          |          |          |          0x60b0000e2040
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--20.00%-- db::commitlog::segment::flush(unsigned long)::{lambda()#1}::operator()
>                 |          |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |          |--73.33%-- future<>::then<db::commitlog::segment::flush(unsigned long)::{lambda()#1}, future<lw_shared_ptr<db::commitlog::segment> > >
>                 |          |          |          |          |          |          |          |          _ZN12continuationIZN6futureIJ13lw_shared_ptrIN2db9commitlog7segmentEEEE4thenIZNS4_4syncEvEUlT_E_S6_EET0_OS8_EUlSB_E_JS5_EE3runEv
>                 |          |          |          |          |          |          |          |          reactor::del_timer
>                 |          |          |          |          |          |          |          |          0x60e0000e2040
>                 |          |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |           --26.67%-- _ZN12continuationIZN6futureIJEE4thenIZN2db9commitlog7segment5flushEmEUlvE_S0_IJ13lw_shared_ptrIS5_EEEEET0_OT_EUlSC_E_JEE3runEv
>                 |          |          |          |          |          |          |                     reactor::del_timer
>                 |          |          |          |          |          |          |                     0x6090000e2040
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--10.67%-- sstables::sstable::seal_sstable
>                 |          |          |          |          |          |          |          std::_Function_handler<void (), futurize<std::result_of<std::decay<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>::type ()>::type>::type seastar::async<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>(std::decay&&, (std::decay<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>::type&&)...)::{lambda(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type> seastar::async<{lambda()#1}>(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type>::type, std::decay<{lambda()#1}>::type&&)::work&)#1}::operator()(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type> seastar::async<{lambda()#1}>(futurize<std::result_of<std::decay<{lambd
 a()#1}>::type ()>::type>::type, std::decay<{lambda()#1}>::type&&)::work)::{lambda()#1}>::_M_invoke
>                 |          |          |          |          |          |          |          _GLOBAL__sub_I__ZN12app_templateC2Ev
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |           --4.00%-- sstables::sstable::write_toc
>                 |          |          |          |          |          |                     sstables::sstable::prepare_write_components
>                 |          |          |          |          |          |                     |          
>                 |          |          |          |          |          |                     |--50.00%-- 0x4d3a4f6ec4e8cd75
>                 |          |          |          |          |          |                     |          
>                 |          |          |          |          |          |                      --50.00%-- 0x3ebf3dd80e3b174d
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--23.93%-- posix_file_impl::discard
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--82.14%-- _ZN12continuationIZN6futureIImEE4thenIZN19file_data_sink_impl6do_putEm16temporary_bufferIcEEUlmE_S0_IIEEEET0_OT_EUlSA_E_ImEE3runEv
>                 |          |          |          |          |          |          |          reactor::del_timer
>                 |          |          |          |          |          |          |          0x6080000e2040
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |           --17.86%-- futurize<future<lw_shared_ptr<db::commitlog::segment> > >::apply<db::commitlog::segment_manager::allocate_segment(bool)::{lambda(file)#1}, file>
>                 |          |          |          |          |          |                     _ZN12continuationIZN6futureIJ4fileEE4thenIZN2db9commitlog15segment_manager16allocate_segmentEbEUlS1_E_S0_IJ13lw_shared_ptrINS5_7segmentEEEEEET0_OT_EUlSE_E_JS1_EE3runEv
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--20.94%-- reactor::open_file_dma
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--20.41%-- db::commitlog::segment_manager::allocate_segment
>                 |          |          |          |          |          |          |          db::commitlog::segment_manager::on_timer()::{lambda()#1}::operator()
>                 |          |          |          |          |          |          |          0xb8c264
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--14.29%-- sstables::sstable::write_simple<(sstables::sstable::component_type)8, sstables::statistics>
>                 |          |          |          |          |          |          |          std::_Function_handler<void (), futurize<std::result_of<std::decay<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>::type ()>::type>::type seastar::async<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>(std::decay&&, (std::decay<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>::type&&)...)::{lambda(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type> seastar::async<{lambda()#1}>(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type>::type, std::decay<{lambda()#1}>::type&&)::work&)#1}::operator()(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type> seastar::async<{lambda()#1}>(futurize<std::result_of<std::decay<{lambd
 a()#1}>::type ()>::type>::type, std::decay<{lambda()#1}>::type&&)::work)::{lambda()#1}>::_M_invoke
>                 |          |          |          |          |          |          |          _GLOBAL__sub_I__ZN12app_templateC2Ev
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--12.24%-- sstables::write_crc
>                 |          |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |          |--16.67%-- 0x313532343536002f
>                 |          |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |          |--16.67%-- 0x373633323533002f
>                 |          |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |          |--16.67%-- 0x363139333232002f
>                 |          |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |          |--16.67%-- 0x353933303330002f
>                 |          |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |          |--16.67%-- 0x383930383133002f
>                 |          |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |           --16.67%-- 0x323338303037002f
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--12.24%-- sstables::write_digest
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--10.20%-- sstables::sstable::write_simple<(sstables::sstable::component_type)7, sstables::filter>
>                 |          |          |          |          |          |          |          sstables::sstable::write_filter
>                 |          |          |          |          |          |          |          std::_Function_handler<void (), futurize<std::result_of<std::decay<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>::type ()>::type>::type seastar::async<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>(std::decay&&, (std::decay<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>::type&&)...)::{lambda(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type> seastar::async<{lambda()#1}>(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type>::type, std::decay<{lambda()#1}>::type&&)::work&)#1}::operator()(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type> seastar::async<{lambda()#1}>(futurize<std::result_of<std::decay<{lambd
 a()#1}>::type ()>::type>::type, std::decay<{lambda()#1}>::type&&)::work)::{lambda()#1}>::_M_invoke
>                 |          |          |          |          |          |          |          _GLOBAL__sub_I__ZN12app_templateC2Ev
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--10.20%-- sstables::sstable::write_simple<(sstables::sstable::component_type)4, sstables::summary_ka>
>                 |          |          |          |          |          |          |          std::_Function_handler<void (), futurize<std::result_of<std::decay<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>::type ()>::type>::type seastar::async<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>(std::decay&&, (std::decay<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>::type&&)...)::{lambda(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type> seastar::async<{lambda()#1}>(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type>::type, std::decay<{lambda()#1}>::type&&)::work&)#1}::operator()(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type> seastar::async<{lambda()#1}>(futurize<std::result_of<std::decay<{lambd
 a()#1}>::type ()>::type>::type, std::decay<{lambda()#1}>::type&&)::work)::{lambda()#1}>::_M_invoke
>                 |          |          |          |          |          |          |          _GLOBAL__sub_I__ZN12app_templateC2Ev
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--10.20%-- 0x78d93b
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--6.12%-- sstables::sstable::open_data
>                 |          |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |           --100.00%-- 0x8000000004000000
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |           --4.08%-- sstables::sstable::write_toc
>                 |          |          |          |          |          |                     sstables::sstable::prepare_write_components
>                 |          |          |          |          |          |                     |          
>                 |          |          |          |          |          |                      --100.00%-- 0x6100206690ef
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--18.38%-- syscall_work_queue::submit_item
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--10.00%-- 0x7f4ad89f8fe0
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--7.50%-- 0x7f4ad83f8fe0
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--7.50%-- 0x7f4ad6bf8fe0
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--7.50%-- 0x7f4ad65f8fe0
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--5.00%-- 0x60b015e8cd90
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--5.00%-- 0x60100acaed90
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--5.00%-- 0x607006f04d90
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--5.00%-- 0xffffffffffffa5d0
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x60e01acbed90
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x60e01acbec60
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x60a018d7ad90
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x60a018d7ac60
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x60b015e8cc60
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x60900bb8ad60
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x60100acaec60
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x60800951dd90
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x60800951dc60
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x60d009089d90
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x60d009089c60
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x607006f04c60
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x60f005984d60
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x7f4ad77f8fe0
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x7f4adb9f8fe0
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x7f4ad9bf8fe0
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x7f4ad7df8fe0
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.50%-- 0x7f4ad77f8fe0
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |           --2.50%-- 0x7f4ad5ff8fe0
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--2.99%-- reactor::open_directory
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--57.14%-- sstables::sstable::filename
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |           --42.86%-- sstables::sstable::write_toc
>                 |          |          |          |          |          |                     sstables::sstable::prepare_write_components
>                 |          |          |          |          |          |                     |          
>                 |          |          |          |          |          |                     |--50.00%-- 0x4d3a4f6ec4e8cd75
>                 |          |          |          |          |          |                     |          
>                 |          |          |          |          |          |                      --50.00%-- 0x3ebf3dd80e3b174d
>                 |          |          |          |          |          |          
>                 |          |          |          |          |           --1.71%-- reactor::rename_file
>                 |          |          |          |          |                     sstables::sstable::seal_sstable
>                 |          |          |          |          |                     std::_Function_handler<void (), futurize<std::result_of<std::decay<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>::type ()>::type>::type seastar::async<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>(std::decay&&, (std::decay<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>::type&&)...)::{lambda(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type> seastar::async<{lambda()#1}>(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type>::type, std::decay<{lambda()#1}>::type&&)::work&)#1}::operator()(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type> seastar::async<{lambda()#1}>(futurize<std::result_of<std::decay<{lambda()#1}>::ty
 pe ()>::type>::type, std::decay<{lambda()#1}>::type&&)::work)::{lambda()#1}>::_M_invoke
>                 |          |          |          |          |                     _GLOBAL__sub_I__ZN12app_templateC2Ev
>                 |          |          |          |          |          
>                 |          |          |          |           --32.37%-- _ZN12continuationIZN6futureIJEE4thenIZN18syscall_work_queue11submit_itemEPNS3_9work_itemEEUlvE_S1_EET0_OT_EUlS9_E_JEE3runEv
>                 |          |          |          |                     reactor::del_timer
>                 |          |          |          |                     0x60d0000e2040
>                 |          |          |          |          
>                 |          |          |          |--29.04%-- __vdso_clock_gettime
>                 |          |          |          |          
>                 |          |          |          |--19.66%-- 0x7f4ade42b193
>                 |          |          |          |          reactor_backend_epoll::complete_epoll_event
>                 |          |          |          |          |          
>                 |          |          |          |          |--41.61%-- smp_message_queue::async_work_item<future<> seastar::sharded<database>::invoke_on<service::storage_proxy::mutate_locally(frozen_mutation const&)::{lambda(database&)#1}, future<> >(unsigned int, service::storage_proxy::mutate_locally(frozen_mutation const&)::{lambda(database&)#1}&&)::{lambda()#1}>::process
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--79.03%-- smp_message_queue::process_queue<2ul, smp_message_queue::process_incoming()::{lambda(smp_message_queue::work_item*)#1}>
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--95.92%-- 0x6070000c3000
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |          |--2.04%-- 0x61d0000c1000
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |           --2.04%-- 0x61d0000c1000
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--3.23%-- 0x14dd51
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--1.61%-- 0x162a54
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--1.61%-- 0x161dca
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--1.61%-- 0x159c8b
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--1.61%-- 0x1598b5
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--1.61%-- 0x14dd3e
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--1.61%-- 0x14bad8
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--1.61%-- 0x14a880
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--1.61%-- 0x127105
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--1.61%-- 0x6070000e2040
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--1.61%-- smp_message_queue::process_queue<2ul, smp_message_queue::process_incoming()::{lambda(smp_message_queue::work_item*)#1}>
>                 |          |          |          |          |          |          0x60d0000c3000
>                 |          |          |          |          |          |          
>                 |          |          |          |          |           --1.61%-- __vdso_clock_gettime
>                 |          |          |          |          |                     0x7f4ad77f9160
>                 |          |          |          |          |          
>                 |          |          |          |          |--30.20%-- __restore_rt
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--57.14%-- __vdso_clock_gettime
>                 |          |          |          |          |          |          0x1d
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--9.52%-- smp_message_queue::smp_message_queue
>                 |          |          |          |          |          |          0x6070000c3000
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--4.76%-- 0x600000357240
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--4.76%-- 0x60000031a640
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--2.38%-- posix_file_impl::list_directory
>                 |          |          |          |          |          |          0x609000044730
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--2.38%-- 0x46efbf
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--2.38%-- 0x600000442e40
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--2.38%-- 0x600000376440
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--2.38%-- 0x6000002bac40
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--2.38%-- 0x600000295640
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--2.38%-- 0x600000289e40
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--2.38%-- 0x60000031a640
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--2.38%-- 0x7f4ade6f74ed
>                 |          |          |          |          |          |          __libc_siglongjmp
>                 |          |          |          |          |          |          0x60000047be40
>                 |          |          |          |          |          |          
>                 |          |          |          |          |           --2.38%-- 0x7f4adb3f7fd0
>                 |          |          |          |          |          
>                 |          |          |          |          |--14.09%-- 0x33
>                 |          |          |          |          |          
>                 |          |          |          |          |--12.08%-- promise<temporary_buffer<char> >::promise
>                 |          |          |          |          |          _ZN6futureIJ16temporary_bufferIcEEE4thenIZN12input_streamIcE12read_exactlyEmEUlT_E_S2_EET0_OS6_
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--44.44%-- input_stream<char>::read_exactly
>                 |          |          |          |          |          |          0x8
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--11.11%-- 0x7f4adb3f8ea0
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--11.11%-- 0x7f4ad9bf8ea0
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--11.11%-- 0x7f4ad89f8ea0
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--11.11%-- 0x7f4ad83f8ea0
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--5.56%-- 0x7f4ad77f8ea0
>                 |          |          |          |          |          |          
>                 |          |          |          |          |           --5.56%-- 0x7f4ad7df8ea0
>                 |          |          |          |          |          
>                 |          |          |          |          |--1.34%-- 0x7f4ad6bf8d80
>                 |          |          |          |          |          
>                 |          |          |          |           --0.67%-- 0x7f4adadf8d80
>                 |          |          |          |          
>                 |          |          |          |--4.43%-- __libc_send
>                 |          |          |          |          _ZN12continuationIZN6futureIJmEE4thenIZN7reactor14write_all_partER17pollable_fd_statePKvmmEUlmE_S0_IJEEEET0_OT_EUlSC_E_JmEE3runEv
>                 |          |          |          |          |          
>                 |          |          |          |          |--14.71%-- 0x4
>                 |          |          |          |          |          
>                 |          |          |          |          |--11.76%-- 0x7f4ad89f8de0
>                 |          |          |          |          |          
>                 |          |          |          |          |--8.82%-- 0x7f4adb3f8de0
>                 |          |          |          |          |          
>                 |          |          |          |          |--8.82%-- 0x7f4ad9bf8de0
>                 |          |          |          |          |          
>                 |          |          |          |          |--8.82%-- 0x7f4ad77f8de0
>                 |          |          |          |          |          
>                 |          |          |          |          |--8.82%-- 0x7f4ad6bf8de0
>                 |          |          |          |          |          
>                 |          |          |          |          |--5.88%-- 0x7f4ad83f8de0
>                 |          |          |          |          |          
>                 |          |          |          |          |--5.88%-- 0x7f4ad7df8de0
>                 |          |          |          |          |          
>                 |          |          |          |          |--5.88%-- 0x7f4ad53f8de0
>                 |          |          |          |          |          
>                 |          |          |          |          |--2.94%-- 0x7f4acc9f8de0
>                 |          |          |          |          |          
>                 |          |          |          |          |--2.94%-- continuation<future<file>::wait()::{lambda(future_state<file>&&)#1}, file>::~continuation
>                 |          |          |          |          |          0x611003c8e9b8
>                 |          |          |          |          |          
>                 |          |          |          |          |--2.94%-- 0x7f4adb9f8de0
>                 |          |          |          |          |          
>                 |          |          |          |          |--2.94%-- 0x7f4ad71f8de0
>                 |          |          |          |          |          
>                 |          |          |          |          |--2.94%-- 0x7f4ad65f8de0
>                 |          |          |          |          |          
>                 |          |          |          |          |--2.94%-- 0x7f4ad59f8de0
>                 |          |          |          |          |          
>                 |          |          |          |           --2.94%-- 0x7f4ad35f8de0
>                 |          |          |          |          
>                 |          |          |          |--1.56%-- 0x7f4ade6f754d
>                 |          |          |          |          reactor::read_some
>                 |          |          |          |          |          
>                 |          |          |          |          |--66.67%-- _ZN12continuationIZN6futureIJEE4thenIZZN7service13storage_proxy22send_to_live_endpointsEmENKUlRSt4pairIK13basic_sstringIcjLj15EESt6vectorIN3gms12inet_addressESaISB_EEEE_clESF_EUlvE_S1_EET0_OT_EUlSK_E_JEE3runEv
>                 |          |          |          |          |          reactor::del_timer
>                 |          |          |          |          |          0x6070000e2040
>                 |          |          |          |          |          
>                 |          |          |          |          |--8.33%-- _ZN12continuationIZN6futureIIEE4thenIZ5sleepINSt6chrono3_V212system_clockEmSt5ratioILl1ELl1000000EEES1_NS4_8durationIT0_T1_EEEUlvE_S1_EESA_OT_EUlSF_E_IEE3runEv
>                 |          |          |          |          |          reactor::del_timer
>                 |          |          |          |          |          0x6080000e2040
>                 |          |          |          |          |          
>                 |          |          |          |          |--8.33%-- 0x600000483640
>                 |          |          |          |          |          
>                 |          |          |          |          |--8.33%-- 0x600000480440
>                 |          |          |          |          |          
>                 |          |          |          |           --8.33%-- 0x36
>                 |          |          |           --0.26%-- [...]
>                 |          |          |          
>                 |          |           --46.70%-- retint_careful
>                 |          |                     |          
>                 |          |                     |--6.24%-- posix_file_impl::list_directory
>                 |          |                     |          |          
>                 |          |                     |          |--80.00%-- 0x60f0000e2020
>                 |          |                     |          |          
>                 |          |                     |          |--5.00%-- 0x601000044730
>                 |          |                     |          |          
>                 |          |                     |          |--5.00%-- 0x60e000044720
>                 |          |                     |          |          
>                 |          |                     |          |--2.50%-- 0x60f000135500
>                 |          |                     |          |          
>                 |          |                     |          |--2.50%-- 0x6190000e2098
>                 |          |                     |          |          
>                 |          |                     |          |--2.50%-- 0x60d0000c3000
>                 |          |                     |          |          
>                 |          |                     |           --2.50%-- 0x1
>                 |          |                     |          
>                 |          |                     |--3.42%-- boost::lockfree::detail::ringbuffer_base<smp_message_queue::work_item*>::pop
>                 |          |                     |          |          
>                 |          |                     |          |--95.65%-- boost::program_options::variables_map::get
>                 |          |                     |          |          
>                 |          |                     |           --4.35%-- 0x618000044680
>                 |          |                     |          
>                 |          |                     |--3.12%-- memory::small_pool::add_more_objects
>                 |          |                     |          |          
>                 |          |                     |          |--10.53%-- managed_vector<atomic_cell_or_collection, 5u, unsigned int>::clear_and_release
>                 |          |                     |          |          mutation_partition::clustered_row
>                 |          |                     |          |          mutation::set_clustered_cell
>                 |          |                     |          |          cql3::constants::setter::execute
>                 |          |                     |          |          cql3::statements::update_statement::add_update_for_key
>                 |          |                     |          |          _ZN8futurizeI6futureIJSt6vectorI8mutationSaIS2_EEEEE5applyIZN4cql310statements22modification_statement13get_mutationsERN7seastar7shardedIN7service13storage_proxyEEERKNS8_13query_optionsEblEUlT_E_JSt10unique_ptrINS8_17update_parametersESt14default_deleteISN_EEEEES5_OSK_OSt5tupleIJDpT0_EE
>                 |          |                     |          |          cql3::statements::modification_statement::get_mutations
>                 |          |                     |          |          cql3::statements::modification_statement::execute_without_condition
>                 |          |                     |          |          cql3::query_options::query_options
>                 |          |                     |          |          |          
>                 |          |                     |          |          |--50.00%-- 0x7f4ad77f80e0
>                 |          |                     |          |          |          
>                 |          |                     |          |           --50.00%-- 0x7f4ad6bf80e0
>                 |          |                     |          |          
>                 |          |                     |          |--10.53%-- memory::small_pool::add_more_objects
>                 |          |                     |          |          |          
>                 |          |                     |          |          |--50.00%-- 0x60e00015d000
>                 |          |                     |          |          |          
>                 |          |                     |          |           --50.00%-- 0x60b00af6c758
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- 0x60a018ee3867
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- 0x60d00d41f680
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- 0x61400c6bb4d0
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- 0x60e007c918d6
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- 0x60e0078294ce
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- 0x607006ee4da0
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- _ZN12continuationIZN6futureIJEE12then_wrappedIZNS1_16handle_exceptionIZN7service13storage_proxy22send_to_live_endpointsEmEUlNSt15__exception_ptr13exception_ptrEE0_EES1_OT_EUlSA_E_S1_EET0_SA_EUlSA_E_JEE3runEv
>                 |          |                     |          |          reactor::del_timer
>                 |          |                     |          |          0x6030000e2040
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- service::storage_proxy::mutate_locally
>                 |          |                     |          |          service::storage_proxy::send_to_live_endpoints
>                 |          |                     |          |          parallel_for_each<__gnu_cxx::__normal_iterator<unsigned long*, std::vector<unsigned long, std::allocator<unsigned long> > >, service::storage_proxy::mutate_begin(std::vector<unsigned long, std::allocator<unsigned long> >, db::consistency_level)::{lambda(unsigned long)#1}>
>                 |          |                     |          |          0x601000136d00
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- 0x60a0001900e0
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- 0x60e00015d040
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- 0x61300015d000
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- 0x60e00013bde0
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- 0x60b00010f308
>                 |          |                     |          |          
>                 |          |                     |          |--5.26%-- 0x6010000e4808
>                 |          |                     |          |          
>                 |          |                     |           --5.26%-- 0x7f4ad65f7f50
>                 |          |                     |          
>                 |          |                     |--2.82%-- std::unique_ptr<reactor::pollfn, std::default_delete<std::unique_ptr> > reactor::make_pollfn<reactor::run()::{lambda()#3}>(reactor::run()::{lambda()#3}&&)::the_pollfn::poll_and_check_more_work
>                 |          |                     |          |          
>                 |          |                     |          |--25.00%-- boost::lockfree::detail::ringbuffer_base<smp_message_queue::work_item*>::pop
>                 |          |                     |          |          boost::program_options::variables_map::get
>                 |          |                     |          |          
>                 |          |                     |          |--25.00%-- 0x1
>                 |          |                     |          |          
>                 |          |                     |          |--12.50%-- 0x53
>                 |          |                     |          |          
>                 |          |                     |          |--12.50%-- 0x3e
>                 |          |                     |          |          
>                 |          |                     |          |--12.50%-- 0x24
>                 |          |                     |          |          
>                 |          |                     |           --12.50%-- 0xb958000000000000
>                 |          |                     |          
>                 |          |                     |--2.67%-- std::_Function_handler<partition_presence_checker_result (partition_key const&), column_family::make_partition_presence_checker(lw_shared_ptr<std::map<long, lw_shared_ptr<sstables::sstable>, std::less<long>, std::allocator<std::pair<long const, lw_shared_ptr<sstables::sstable> > > > >)::{lambda(partition_key const&)#1}>::_M_invoke
>                 |          |                     |          |          
>                 |          |                     |          |--66.67%-- 0x1b5c280
>                 |          |                     |          |          
>                 |          |                     |          |--27.78%-- managed_vector<atomic_cell_or_collection, 5u, unsigned int>::resize
>                 |          |                     |          |          row::apply
>                 |          |                     |          |          mutation_partition_applier::accept_row_cell
>                 |          |                     |          |          mutation_partition_view::accept
>                 |          |                     |          |          
>                 |          |                     |           --5.56%-- 0x2a4399
>                 |          |                     |          
>                 |          |                     |--2.08%-- smp_message_queue::smp_message_queue
>                 |          |                     |          |          
>                 |          |                     |          |--60.00%-- 0x60f0000c3000
>                 |          |                     |          |          
>                 |          |                     |          |--10.00%-- 0x6000002d7240
>                 |          |                     |          |          
>                 |          |                     |          |--10.00%-- 0x19
>                 |          |                     |          |          
>                 |          |                     |          |--10.00%-- 0xb
>                 |          |                     |          |          
>                 |          |                     |           --10.00%-- 0x7
>                 |          |                     |          
>                 |          |                     |--1.93%-- smp_message_queue::process_queue<4ul, smp_message_queue::process_completions()::{lambda(smp_message_queue::work_item*)#1}>
>                 |          |                     |          
>                 |          |                     |--1.63%-- __vdso_clock_gettime
>                 |          |                     |          |          
>                 |          |                     |           --100.00%-- __clock_gettime
>                 |          |                     |                     std::chrono::_V2::system_clock::now
>                 |          |                     |                     0xa63209
>                 |          |                     |          
>                 |          |                     |--1.49%-- memory::small_pool::deallocate
>                 |          |                     |          |          
>                 |          |                     |          |--40.00%-- managed_vector<atomic_cell_or_collection, 5u, unsigned int>::emplace_back<atomic_cell_or_collection>
>                 |          |                     |          |          
>                 |          |                     |          |--20.00%-- std::_Hashtable<unsigned long, std::pair<unsigned long const, service::storage_proxy::rh_entry>, std::allocator<std::pair<unsigned long const, service::storage_proxy::rh_entry> >, std::__detail::_Select1st, std::equal_to<unsigned long>, std::hash<unsigned long>, std::__detail::_Mod_range_hashing, std::__detail::_Default_ranged_hash, std::__detail::_Prime_rehash_policy, std::__detail::_Hashtable_traits<false, false, true> >::_M_erase
>                 |          |                     |          |          service::storage_proxy::got_response
>                 |          |                     |          |          _ZN12continuationIZN6futureIJEE4thenIZZN7service13storage_proxy22send_to_live_endpointsEmENKUlRSt4pairIK13basic_sstringIcjLj15EESt6vectorIN3gms12inet_addressESaISB_EEEE_clESF_EUlvE_S1_EET0_OT_EUlSK_E_JEE3runEv
>                 |          |                     |          |          reactor::del_timer
>                 |          |                     |          |          0x6100000e2040
>                 |          |                     |          |          
>                 |          |                     |          |--10.00%-- cql3::statements::modification_statement::get_mutations
>                 |          |                     |          |          
>                 |          |                     |          |--10.00%-- cql3::statements::modification_statement::build_partition_keys
>                 |          |                     |          |          cql3::statements::modification_statement::create_exploded_clustering_prefix
>                 |          |                     |          |          0x60c014be0b00
>                 |          |                     |          |          
>                 |          |                     |          |--10.00%-- mutation_partition::~mutation_partition
>                 |          |                     |          |          std::vector<mutation, std::allocator<mutation> >::~vector
>                 |          |                     |          |          service::storage_proxy::mutate_with_triggers
>                 |          |                     |          |          cql3::statements::modification_statement::execute_without_condition
>                 |          |                     |          |          cql3::statements::modification_statement::execute
>                 |          |                     |          |          cql3::query_processor::process_statement
>                 |          |                     |          |          transport::cql_server::connection::process_execute
>                 |          |                     |          |          transport::cql_server::connection::process_request_one
>                 |          |                     |          |          futurize<future<std::pair<foreign_ptr<shared_ptr<transport::cql_server::response> >, service::client_state> > >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}::operator()(temporary_buffer) const::{lambda()#1}::operator()()::{lambda()#1}&>
>                 |          |                     |          |          futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}, temporary_buffer>
>                 |          |                     |          |          futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}, future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> > >
>                 |          |                     |          |          0x8961de
>                 |          |                     |          |          
>                 |          |                     |           --10.00%-- object_deleter_impl<deleter>::~object_deleter_impl
>                 |          |                     |                     _ZN12continuationIZN6futureIJEE12then_wrappedIZZNS1_7finallyIZ7do_withI11foreign_ptrI10shared_ptrIN9transport10cql_server8responseEEEZZNS8_10connection14write_responseEOSB_ENUlvE_clEvEUlRT_E_EDaOSF_OT0_EUlvE_EES1_SI_ENUlS1_E_clES1_EUlSF_E_S1_EESJ_SI_EUlSI_E_JEED0Ev
>                 |          |                     |                     0x61a0000c3db0
>                 |          |                     |          
>                 |          |                     |--1.34%-- dht::decorated_key::equal
>                 |          |                     |          |          
>                 |          |                     |          |--83.33%-- 0x607000138f00
>                 |          |                     |          |          
>                 |          |                     |           --16.67%-- 0x60a0000e0f40
>                 |          |                     |          
>                 |          |                     |--1.34%-- service::storage_proxy::send_to_live_endpoints
>                 |          |                     |          
>                 |          |                     |--1.19%-- transport::cql_server::connection::process_execute
>                 |          |                     |          transport::cql_server::connection::process_request_one
>                 |          |                     |          futurize<future<std::pair<foreign_ptr<shared_ptr<transport::cql_server::response> >, service::client_state> > >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}::operator()(temporary_buffer) const::{lambda()#1}::operator()()::{lambda()#1}&>
>                 |          |                     |          futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}, temporary_buffer>
>                 |          |                     |          futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}, future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> > >
>                 |          |                     |          |          
>                 |          |                     |          |--87.50%-- transport::cql_server::connection::process_request
>                 |          |                     |          |          do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>
>                 |          |                     |          |          do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |          |          do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |          |          0x60e0000c3000
>                 |          |                     |          |          
>                 |          |                     |           --12.50%-- 0x8961de
>                 |          |                     |          
>                 |          |                     |--1.19%-- reactor::run
>                 |          |                     |          |          
>                 |          |                     |          |--87.50%-- smp::configure(boost::program_options::variables_map)::{lambda()#1}::operator()
>                 |          |                     |          |          continuation<future<temporary_buffer<char> > future<>::then<future<temporary_buffer<char> > file::dma_read_bulk<char>(unsigned long, unsigned long)::{lambda(unsigned long)#1}::operator()(unsigned long)::{lambda()#3}, future<temporary_buffer<char> > >(future<temporary_buffer<char> > file::dma_read_bulk<char>(unsigned long, unsigned long)::{lambda(unsigned long)#1}::operator()(unsigned long)::{lambda()#3}&&)::{lambda(future<temporary_buffer<char> >)#1}>::run
>                 |          |                     |          |          0x600000043d00
>                 |          |                     |          |          
>                 |          |                     |           --12.50%-- app_template::run_deprecated
>                 |          |                     |                     main
>                 |          |                     |                     __libc_start_main
>                 |          |                     |                     _GLOBAL__sub_I__ZN3org6apache9cassandra21g_cassandra_constantsE
>                 |          |                     |                     0x7f4ae20c9fa0
>                 |          |                     |          
>                 |          |                     |--1.04%-- __clock_gettime
>                 |          |                     |          std::chrono::_V2::system_clock::now
>                 |          |                     |          |          
>                 |          |                     |          |--42.86%-- reactor::run
>                 |          |                     |          |          smp::configure(boost::program_options::variables_map)::{lambda()#1}::operator()
>                 |          |                     |          |          continuation<future<temporary_buffer<char> > future<>::then<future<temporary_buffer<char> > file::dma_read_bulk<char>(unsigned long, unsigned long)::{lambda(unsigned long)#1}::operator()(unsigned long)::{lambda()#3}, future<temporary_buffer<char> > >(future<temporary_buffer<char> > file::dma_read_bulk<char>(unsigned long, unsigned long)::{lambda(unsigned long)#1}::operator()(unsigned long)::{lambda()#3}&&)::{lambda(future<temporary_buffer<char> >)#1}>::run
>                 |          |                     |          |          0x600000043d00
>                 |          |                     |          |          
>                 |          |                     |          |--14.29%-- 0xa63209
>                 |          |                     |          |          
>                 |          |                     |          |--14.29%-- continuation<future<> future<>::finally<auto do_with<std::vector<frozen_mutation, std::allocator<frozen_mutation> >, shared_ptr<service::storage_proxy>, service::storage_proxy::init_messaging_service()::{lambda(std::vector<frozen_mutation, std::allocator<frozen_mutation> >)#1}::operator()(std::vector<frozen_mutation, std::allocator<frozen_mutation> >) const::{lambda(std::vector<frozen_mutation, std::allocator<frozen_mutation> > const&, shared_ptr<service::storage_proxy>&)#1}>(std::vector<frozen_mutation, std::allocator<frozen_mutation> >&&, shared_ptr<service::storage_proxy>&&, service::storage_proxy::init_messaging_service()::{lambda(std::vector<frozen_mutation, std::allocator<frozen_mutation> >)#1}::operator()(std::vector<frozen_mutation, std::allocator<frozen_mutation> >) const::{lambda(std::vector<frozen_mutation, std::allocator<frozen_mutation> > const&, shared_ptr<service::storage_proxy>&)#1}&&)::
 {lambda()#1}>(service::storage_proxy::init_messaging_service()::{lambda(std::vector<frozen_mutation, std::a
>                 |          |                     |          |          0x2b7434
>                 |          |                     |          |          
>                 |          |                     |          |--14.29%-- _ZN8futurizeI6futureIJSt10unique_ptrIN4cql317update_parametersESt14default_deleteIS3_EEEEE5applyIZNS2_10statements22modification_statement22make_update_parametersERN7seastar7shardedIN7service13storage_proxyEEE13lw_shared_ptrISt6vectorI13partition_keySaISK_EEESI_I26exploded_clustering_prefixERKNS2_13query_optionsEblEUlT_E_JNSt12experimental15fundamentals_v18optionalINS3_13prefetch_dataEEEEEES7_OST_OSt5tupleIJDpT0_EE
>                 |          |                     |          |          cql3::statements::modification_statement::make_update_parameters
>                 |          |                     |          |          cql3::statements::modification_statement::get_mutations
>                 |          |                     |          |          cql3::statements::modification_statement::execute_without_condition
>                 |          |                     |          |          cql3::query_options::query_options
>                 |          |                     |          |          0x7f4ad6bf80e0
>                 |          |                     |          |          
>                 |          |                     |           --14.29%-- database::apply_in_memory
>                 |          |                     |                     database::do_apply
>                 |          |                     |                     _ZN12continuationIZN6futureIJEE4thenIZN8database5applyERK15frozen_mutationEUlvE_S1_EET0_OT_EUlSA_E_JEE3runEv
>                 |          |                     |                     reactor::del_timer
>                 |          |                     |                     0x6090000e2040
>                 |          |                     |          
>                 |          |                     |--1.04%-- memory::small_pool::allocate
>                 |          |                     |          |          
>                 |          |                     |          |--14.29%-- 0x5257c379469d9
>                 |          |                     |          |          
>                 |          |                     |          |--14.29%-- 0x609002b9fe98
>                 |          |                     |          |          
>                 |          |                     |          |--14.29%-- 0x13c8b90
>                 |          |                     |          |          
>                 |          |                     |          |--14.29%-- 0x60f000190710
>                 |          |                     |          |          
>                 |          |                     |          |--14.29%-- 0x25
>                 |          |                     |          |          
>                 |          |                     |          |--14.29%-- 0x7f4ad6bf84c0
>                 |          |                     |          |          
>                 |          |                     |           --14.29%-- 0x7f4ad53f81f0
>                 |          |                     |          
>                 |          |                     |--0.89%-- db::serializer<atomic_cell_view>::serializer
>                 |          |                     |          mutation_partition_serializer::write_without_framing
>                 |          |                     |          frozen_mutation::frozen_mutation
>                 |          |                     |          frozen_mutation::frozen_mutation
>                 |          |                     |          
>                 |          |                     |--0.89%-- do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>
>                 |          |                     |          do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |          do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |          0x60f0000c3000
>                 |          |                     |          
>                 |          |                     |--0.89%-- futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}, temporary_buffer>
>                 |          |                     |          futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}, future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> > >
>                 |          |                     |          transport::cql_server::connection::process_request
>                 |          |                     |          do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>
>                 |          |                     |          do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |          do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |          |          
>                 |          |                     |          |--83.33%-- 0x6090000c3000
>                 |          |                     |          |          
>                 |          |                     |           --16.67%-- 0x600000044400
>                 |          |                     |          
>                 |          |                     |--0.89%-- std::_Function_handler<void (), reactor::run()::{lambda()#8}>::_M_invoke
>                 |          |                     |          |          
>                 |          |                     |          |--50.00%-- reactor::run
>                 |          |                     |          |          smp::configure(boost::program_options::variables_map)::{lambda()#1}::operator()
>                 |          |                     |          |          continuation<future<temporary_buffer<char> > future<>::then<future<temporary_buffer<char> > file::dma_read_bulk<char>(unsigned long, unsigned long)::{lambda(unsigned long)#1}::operator()(unsigned long)::{lambda()#3}, future<temporary_buffer<char> > >(future<temporary_buffer<char> > file::dma_read_bulk<char>(unsigned long, unsigned long)::{lambda(unsigned long)#1}::operator()(unsigned long)::{lambda()#3}&&)::{lambda(future<temporary_buffer<char> >)#1}>::run
>                 |          |                     |          |          0x600000043d00
>                 |          |                     |          |          
>                 |          |                     |           --50.00%-- reactor::signals::signal_handler::signal_handler
>                 |          |                     |                     0x3e8
>                 |          |                     |          
>                 |          |                     |--0.74%-- db::commitlog::segment::allocate
>                 |          |                     |          |          
>                 |          |                     |           --100.00%-- db::commitlog::add
>                 |          |                     |                     database::do_apply
>                 |          |                     |                     |          
>                 |          |                     |                     |--75.00%-- database::apply
>                 |          |                     |                     |          smp_message_queue::async_work_item<future<> seastar::sharded<database>::invoke_on<service::storage_proxy::mutate_locally(mutation const&)::{lambda(database&)#1}, future<> >(unsigned int, service::storage_proxy::mutate_locally(mutation const&)::{lambda(database&)#1}&&)::{lambda()#1}>::process
>                 |          |                     |                     |          smp_message_queue::process_queue<2ul, smp_message_queue::process_incoming()::{lambda(smp_message_queue::work_item*)#1}>
>                 |          |                     |                     |          boost::lockfree::detail::ringbuffer_base<smp_message_queue::work_item*>::pop
>                 |          |                     |                     |          boost::program_options::variables_map::get
>                 |          |                     |                     |          
>                 |          |                     |                      --25.00%-- _ZN12continuationIZN6futureIJEE4thenIZN8database5applyERK15frozen_mutationEUlvE_S1_EET0_OT_EUlSA_E_JEE3runEv
>                 |          |                     |                                reactor::del_timer
>                 |          |                     |                                0x60b0000e2040
>                 |          |                     |          
>                 |          |                     |--0.74%-- service::storage_proxy::create_write_response_handler
>                 |          |                     |          
>                 |          |                     |--0.74%-- transport::cql_server::connection::process_request_one
>                 |          |                     |          futurize<future<std::pair<foreign_ptr<shared_ptr<transport::cql_server::response> >, service::client_state> > >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}::operator()(temporary_buffer) const::{lambda()#1}::operator()()::{lambda()#1}&>
>                 |          |                     |          futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}, temporary_buffer>
>                 |          |                     |          futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}, future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> > >
>                 |          |                     |          |          
>                 |          |                     |          |--80.00%-- transport::cql_server::connection::process_request
>                 |          |                     |          |          do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>
>                 |          |                     |          |          do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |          |          do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |          |          0x60a0000c3000
>                 |          |                     |          |          
>                 |          |                     |           --20.00%-- 0x8961de
>                 |          |                     |          
>                 |          |                     |--0.74%-- compound_type<(allow_prefixes)0>::compare
>                 |          |                     |          |          
>                 |          |                     |          |--20.00%-- 0x6030056c0f20
>                 |          |                     |          |          
>                 |          |                     |          |--20.00%-- boost::intrusive::bstbase2<boost::intrusive::mhtraits<rows_entry, boost::intrusive::set_member_hook<void, void, void, void>, &rows_entry::_link>, rows_entry::compare, (boost::intrusive::algo_types)5, boost::intrusive::detail::default_header_holder<boost::intrusive::rbtree_node_traits<void*, false> > >::find
>                 |          |                     |          |          mutation_partition::clustered_row
>                 |          |                     |          |          mutation::set_clustered_cell
>                 |          |                     |          |          cql3::constants::setter::execute
>                 |          |                     |          |          cql3::statements::update_statement::add_update_for_key
>                 |          |                     |          |          _ZN8futurizeI6futureIJSt6vectorI8mutationSaIS2_EEEEE5applyIZN4cql310statements22modification_statement13get_mutationsERN7seastar7shardedIN7service13storage_proxyEEERKNS8_13query_optionsEblEUlT_E_JSt10unique_ptrINS8_17update_parametersESt14default_deleteISN_EEEEES5_OSK_OSt5tupleIJDpT0_EE
>                 |          |                     |          |          cql3::statements::modification_statement::get_mutations
>                 |          |                     |          |          cql3::statements::modification_statement::execute_without_condition
>                 |          |                     |          |          cql3::query_options::query_options
>                 |          |                     |          |          0x7f4adb3f80e0
>                 |          |                     |          |          
>                 |          |                     |          |--20.00%-- compound_type<(allow_prefixes)0>::compare
>                 |          |                     |          |          
>                 |          |                     |          |--20.00%-- mutation_partition::clustered_row
>                 |          |                     |          |          boost::intrusive::bstree_impl<boost::intrusive::mhtraits<rows_entry, boost::intrusive::set_member_hook<void, void, void, void>, &rows_entry::_link>, rows_entry::compare, unsigned long, true, (boost::intrusive::algo_types)5, boost::intrusive::detail::default_header_holder<boost::intrusive::rbtree_node_traits<void*, false> > >::insert_unique
>                 |          |                     |          |          boost::intrusive::bstree_algorithms<boost::intrusive::rbtree_node_traits<void*, false> >::prev_node
>                 |          |                     |          |          0x12d
>                 |          |                     |          |          
>                 |          |                     |           --20.00%-- 0x60f00052daf0
>                 |          |                     |          
>                 |          |                     |--0.74%-- __memmove_ssse3_back
>                 |          |                     |          |          
>                 |          |                     |          |--40.00%-- output_stream<char>::write
>                 |          |                     |          |          |          
>                 |          |                     |          |          |--50.00%-- transport::cql_server::response::output
>                 |          |                     |          |          |          futurize<future<> >::apply<transport::cql_server::connection::write_response(foreign_ptr<shared_ptr<transport::cql_server::response> >&&)::{lambda()#1}>
>                 |          |                     |          |          |          
>                 |          |                     |          |           --50.00%-- 0x7c7fb2
>                 |          |                     |          |                     0x5257c37847fa0
>                 |          |                     |          |          
>                 |          |                     |          |--20.00%-- transport::cql_server::connection::read_short_bytes
>                 |          |                     |          |          transport::cql_server::connection::process_query
>                 |          |                     |          |          0x7f4ada7f86f0
>                 |          |                     |          |          
>                 |          |                     |          |--20.00%-- transport::cql_server::response::output
>                 |          |                     |          |          futurize<future<> >::apply<transport::cql_server::connection::write_response(foreign_ptr<shared_ptr<transport::cql_server::response> >&&)::{lambda()#1}>
>                 |          |                     |          |          0x2
>                 |          |                     |          |          
>                 |          |                     |           --20.00%-- smp_message_queue::flush_response_batch
>                 |          |                     |                     boost::lockfree::detail::ringbuffer_base<smp_message_queue::work_item*>::pop
>                 |          |                     |                     boost::program_options::variables_map::get
>                 |          |                     |          
>                 |          |                     |--0.74%-- syscall_work_queue::work_item_returning<syscall_result_extra<stat>, reactor::file_size(basic_sstring<char, unsigned int, 15u>)::{lambda()#1}>::~work_item_returning
>                 |          |                     |          |          
>                 |          |                     |          |--60.00%-- 0x6130000c3000
>                 |          |                     |          |          
>                 |          |                     |          |--20.00%-- 0x608001fe59a0
>                 |          |                     |          |          
>                 |          |                     |           --20.00%-- 0x16
>                 |          |                     |          
>                 |          |                     |--0.74%-- __memset_sse2
>                 |          |                     |          |          
>                 |          |                     |          |--40.00%-- std::_Hashtable<range<dht::token>, std::pair<range<dht::token> const, std::unordered_set<gms::inet_address, std::hash<gms::inet_address>, std::equal_to<gms::inet_address>, std::allocator<gms::inet_address> > >, std::allocator<std::pair<range<dht::token> const, std::unordered_set<gms::inet_address, std::hash<gms::inet_address>, std::equal_to<gms::inet_address>, std::allocator<gms::inet_address> > > >, std::__detail::_Select1st, std::equal_to<range<dht::token> >, std::hash<range<dht::token> >, std::__detail::_Mod_range_hashing, std::__detail::_Default_ranged_hash, std::__detail::_Prime_rehash_policy, std::__detail::_Hashtable_traits<true, false, true> >::~_Hashtable
>                 |          |                     |          |          locator::token_metadata::pending_endpoints_for
>                 |          |                     |          |          service::storage_proxy::create_write_response_handler
>                 |          |                     |          |          service::storage_proxy::mutate_prepare<std::vector<mutation, std::allocator<mutation> >, service::storage_proxy::mutate_prepare(std::vector<mutation, std::allocator<mutation> >&, db::consistency_level, db::write_type)::{lambda(mutation const&, db::consistency_level, db::write_type)#1}>
>                 |          |                     |          |          service::storage_proxy::mutate
>                 |          |                     |          |          service::storage_proxy::mutate_with_triggers
>                 |          |                     |          |          cql3::statements::modification_statement::execute_without_condition
>                 |          |                     |          |          cql3::statements::modification_statement::execute
>                 |          |                     |          |          cql3::query_processor::process_statement
>                 |          |                     |          |          transport::cql_server::connection::process_execute
>                 |          |                     |          |          transport::cql_server::connection::process_request_one
>                 |          |                     |          |          futurize<future<std::pair<foreign_ptr<shared_ptr<transport::cql_server::response> >, service::client_state> > >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}::operator()(temporary_buffer) const::{lambda()#1}::operator()()::{lambda()#1}&>
>                 |          |                     |          |          futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}, temporary_buffer>
>                 |          |                     |          |          futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}, future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> > >
>                 |          |                     |          |          transport::cql_server::connection::process_request
>                 |          |                     |          |          do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>
>                 |          |                     |          |          do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |          |          do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |          |          0x6020000c3000
>                 |          |                     |          |          
>                 |          |                     |          |--40.00%-- service::digest_read_resolver::~digest_read_resolver
>                 |          |                     |          |          |          
>                 |          |                     |          |           --100.00%-- 0x610002612b50
>                 |          |                     |          |          
>                 |          |                     |           --20.00%-- std::_Hashtable<basic_sstring<char, unsigned int, 15u>, std::pair<basic_sstring<char, unsigned int, 15u> const, std::vector<gms::inet_address, std::allocator<gms::inet_address> > >, std::allocator<std::pair<basic_sstring<char, unsigned int, 15u> const, std::vector<gms::inet_address, std::allocator<gms::inet_address> > > >, std::__detail::_Select1st, std::equal_to<basic_sstring<char, unsigned int, 15u> >, std::hash<basic_sstring<char, unsigned int, 15u> >, std::__detail::_Mod_range_hashing, std::__detail::_Default_ranged_hash, std::__detail::_Prime_rehash_policy, std::__detail::_Hashtable_traits<true, false, true> >::~_Hashtable
>                 |          |                     |                     service::storage_proxy::send_to_live_endpoints
>                 |          |                     |                     parallel_for_each<__gnu_cxx::__normal_iterator<unsigned long*, std::vector<unsigned long, std::allocator<unsigned long> > >, service::storage_proxy::mutate_begin(std::vector<unsigned long, std::allocator<unsigned long> >, db::consistency_level)::{lambda(unsigned long)#1}>
>                 |          |                     |                     service::storage_proxy::mutate
>                 |          |                     |                     service::storage_proxy::mutate_with_triggers
>                 |          |                     |                     cql3::statements::modification_statement::execute_without_condition
>                 |          |                     |                     cql3::statements::modification_statement::execute
>                 |          |                     |                     cql3::query_processor::process_statement
>                 |          |                     |                     transport::cql_server::connection::process_execute
>                 |          |                     |                     transport::cql_server::connection::process_request_one
>                 |          |                     |                     futurize<future<std::pair<foreign_ptr<shared_ptr<transport::cql_server::response> >, service::client_state> > >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}::operator()(temporary_buffer) const::{lambda()#1}::operator()()::{lambda()#1}&>
>                 |          |                     |                     futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}, temporary_buffer>
>                 |          |                     |                     futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}, future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> > >
>                 |          |                     |                     transport::cql_server::connection::process_request
>                 |          |                     |                     do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>
>                 |          |                     |                     do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |                     do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |                     0x6070000c3000
>                 |          |                     |          
>                 |          |                     |--0.74%-- reactor::del_timer
>                 |          |                     |          |          
>                 |          |                     |          |--80.00%-- 0x60a0000e2040
>                 |          |                     |          |          
>                 |          |                     |           --20.00%-- 0x6080000c3db0
>                 |          |                     |          
>                 |          |                     |--0.59%-- unimplemented::operator<<
>                 |          |                     |          |          
>                 |          |                     |          |--25.00%-- _ZN12continuationIZN6futureIJ10shared_ptrIN9transport8messages14result_messageEEEE4thenIZN4cql315query_processor17process_statementES1_INS8_13cql_statementEERN7service11query_stateERKNS8_13query_optionsEEUlT_E_S6_EET0_OSI_EUlSL_E_JS5_EED2Ev
>                 |          |                     |          |          0x600100000008
>                 |          |                     |          |          
>                 |          |                     |          |--25.00%-- floating_type_impl<float>::from_string
>                 |          |                     |          |          
>                 |          |                     |          |--25.00%-- 0x60e0000e4c10
>                 |          |                     |          |          
>                 |          |                     |           --25.00%-- _ZN12continuationIZN6futureIJ10shared_ptrIN9transport8messages14result_messageEEEE4thenIZN4cql315query_processor17process_statementES1_INS8_13cql_statementEERN7service11query_stateERKNS8_13query_optionsEEUlT_E_S6_EET0_OSI_EUlSL_E_JS5_EED2Ev
>                 |          |                     |                     0x600100000008
>                 |          |                     |          
>                 |          |                     |--0.59%-- std::_Hashtable<unsigned long, std::pair<unsigned long const, service::storage_proxy::rh_entry>, std::allocator<std::pair<unsigned long const, service::storage_proxy::rh_entry> >, std::__detail::_Select1st, std::equal_to<unsigned long>, std::hash<unsigned long>, std::__detail::_Mod_range_hashing, std::__detail::_Default_ranged_hash, std::__detail::_Prime_rehash_policy, std::__detail::_Hashtable_traits<false, false, true> >::_M_insert_unique_node
>                 |          |                     |          service::storage_proxy::register_response_handler
>                 |          |                     |          service::storage_proxy::create_write_response_handler
>                 |          |                     |          service::storage_proxy::create_write_response_handler
>                 |          |                     |          service::storage_proxy::mutate_prepare<std::vector<mutation, std::allocator<mutation> >, service::storage_proxy::mutate_prepare(std::vector<mutation, std::allocator<mutation> >&, db::consistency_level, db::write_type)::{lambda(mutation const&, db::consistency_level, db::write_type)#1}>
>                 |          |                     |          service::storage_proxy::mutate
>                 |          |                     |          service::storage_proxy::mutate_with_triggers
>                 |          |                     |          cql3::statements::modification_statement::execute_without_condition
>                 |          |                     |          cql3::statements::modification_statement::execute
>                 |          |                     |          cql3::query_processor::process_statement
>                 |          |                     |          transport::cql_server::connection::process_execute
>                 |          |                     |          transport::cql_server::connection::process_request_one
>                 |          |                     |          futurize<future<std::pair<foreign_ptr<shared_ptr<transport::cql_server::response> >, service::client_state> > >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}::operator()(temporary_buffer) const::{lambda()#1}::operator()()::{lambda()#1}&>
>                 |          |                     |          futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}, temporary_buffer>
>                 |          |                     |          futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}, future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> > >
>                 |          |                     |          transport::cql_server::connection::process_request
>                 |          |                     |          do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>
>                 |          |                     |          do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |          do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |                     |          0x60b0000c3000
>                 |          |                     |          
>                 |          |                     |--0.59%-- mutation::set_clustered_cell
>                 |          |                     |          |          
>                 |          |                     |          |--75.00%-- 0xa
>                 |          |                     |          |          
>                 |          |                     |           --25.00%-- cql3::constants::setter::execute
>                 |          |                     |                     cql3::statements::update_statement::add_update_for_key
>                 |          |                     |                     _ZN8futurizeI6futureIJSt6vectorI8mutationSaIS2_EEEEE5applyIZN4cql310statements22modification_statement13get_mutationsERN7seastar7shardedIN7service13storage_proxyEEERKNS8_13query_optionsEblEUlT_E_JSt10unique_ptrINS8_17update_parametersESt14default_deleteISN_EEEEES5_OSK_OSt5tupleIJDpT0_EE
>                 |          |                     |                     cql3::statements::modification_statement::get_mutations
>                 |          |                     |                     cql3::statements::modification_statement::execute_without_condition
>                 |          |                     |                     cql3::query_options::query_options
>                 |          |                     |                     0x7f4ad89f80e0
>                 |          |                     |          
>                 |          |                     |--0.59%-- memory::small_pool::small_pool
>                 |          |                     |          |          
>                 |          |                     |          |--25.00%-- memory::stats
>                 |          |                     |          |          boost::program_options::variables_map::get
>                 |          |                     |          |          
>                 |          |                     |          |--25.00%-- memory::reclaimer::~reclaimer
>                 |          |                     |          |          0x1e
>                 |          |                     |          |          
>                 |          |                     |          |--25.00%-- memory::allocate_aligned
>                 |          |                     |          |          
>                 |          |                     |           --25.00%-- memory::small_pool::add_more_objects
>                 |          |                     |                     memory::small_pool::add_more_objects
>                 |          |                     |                     0x6100000e0310
>                 |          |                     |          
>                 |          |                     |--0.59%-- __memcpy_sse2_unaligned
>                 |          |                     |          |          
>                 |          |                     |          |--50.00%-- mutation_partition_applier::accept_row_cell
>                 |          |                     |          |          mutation_partition_view::accept
>                 |          |                     |          |          boost::intrusive::bstree_algorithms<boost::intrusive::rbtree_node_traits<void*, false> >::prev_node
>                 |          |                     |          |          0x12d
>                 |          |                     |          |          
>                 |          |                     |          |--25.00%-- scanning_reader::operator()
>                 |          |                     |          |          sstables::sstable::do_write_components
>                 |          |                     |          |          sstables::sstable::prepare_write_components
>                 |          |                     |          |          std::_Function_handler<void (), futurize<std::result_of<std::decay<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>::type ()>::type>::type seastar::async<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>(std::decay&&, (std::decay<sstables::sstable::write_components(mutation_reader, unsigned long, lw_shared_ptr<schema const>, unsigned long)::{lambda()#1}>::type&&)...)::{lambda(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type> seastar::async<{lambda()#1}>(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type>::type, std::decay<{lambda()#1}>::type&&)::work&)#1}::operator()(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::type> seastar::async<{lambda()#1}>(futurize<std::result_of<std::decay<{lambda()#1}>::type ()>::typ
 e>::type, std::decay<{lambda()#1}>::type&&)::work)::{lambda()#1}>::_M_invoke
>                 |          |                     |          |          _GLOBAL__sub_I__ZN12app_templateC2Ev
>                 |          |                     |          |          
>                 |          |                     |           --25.00%-- memtable::find_or_create_partition_slow
>                 |          |                     |                     memtable::apply
>                 |          |                     |                     database::apply_in_memory
>                 |          |                     |                     database::do_apply
>                 |          |                     |                     database::apply
>                 |          |                     |                     smp_message_queue::async_work_item<future<> seastar::sharded<database>::invoke_on<service::storage_proxy::mutate_locally(mutation const&)::{lambda(database&)#1}, future<> >(unsigned int, service::storage_proxy::mutate_locally(mutation const&)::{lambda(database&)#1}&&)::{lambda()#1}>::process
>                 |          |                     |                     smp_message_queue::process_queue<2ul, smp_message_queue::process_incoming()::{lambda(smp_message_queue::work_item*)#1}>
>                 |          |                     |                     boost::lockfree::detail::ringbuffer_base<smp_message_queue::work_item*>::pop
>                 |          |                     |                     boost::program_options::variables_map::get
>                 |          |                     |          
>                 |          |                     |--0.59%-- smp_message_queue::flush_response_batch
>                 |          |                     |          |          
>                 |          |                     |          |--25.00%-- boost::lockfree::detail::ringbuffer_base<smp_message_queue::work_item*>::pop
>                 |          |                     |          |          boost::program_options::variables_map::get
>                 |          |                     |          |          
>                 |          |                     |          |--25.00%-- 0x13
>                 |          |                     |          |          
>                 |          |                     |          |--25.00%-- 0x7f4ad5ff8f40
>                 |          |                     |          |          
>                 |          |                     |           --25.00%-- reactor::run
>                 |          |                     |                     smp::configure(boost::program_options::variables_map)::{lambda()#1}::operator()
>                 |          |                     |                     continuation<future<temporary_buffer<char> > future<>::then<future<temporary_buffer<char> > file::dma_read_bulk<char>(unsigned long, unsigned long)::{lambda(unsigned long)#1}::operator()(unsigned long)::{lambda()#3}, future<temporary_buffer<char> > >(future<temporary_buffer<char> > file::dma_read_bulk<char>(unsigned long, unsigned long)::{lambda(unsigned long)#1}::operator()(unsigned long)::{lambda()#3}&&)::{lambda(future<temporary_buffer<char> >)#1}>::run
>                 |          |                     |                     0x600000043d00
>                 |          |                      --54.38%-- [...]
>                 |          |          
>                 |          |--14.26%-- schedule_timeout
>                 |          |          |          
>                 |          |          |--38.52%-- wait_for_completion
>                 |          |          |          |          
>                 |          |          |          |--90.07%-- flush_work
>                 |          |          |          |          xlog_cil_force_lsn
>                 |          |          |          |          |          
>                 |          |          |          |          |--96.85%-- _xfs_log_force_lsn
>                 |          |          |          |          |          |          
>                 |          |          |          |          |          |--79.67%-- xfs_file_fsync
>                 |          |          |          |          |          |          vfs_fsync_range
>                 |          |          |          |          |          |          do_fsync
>                 |          |          |          |          |          |          sys_fdatasync
>                 |          |          |          |          |          |          entry_SYSCALL_64_fastpath
>                 |          |          |          |          |          |          |          
>                 |          |          |          |          |          |           --100.00%-- 0x7f4ade4212ad
>                 |          |          |          |          |          |                     syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                 |          |          |          |          |          |                     0x6030000c3ec0
>                 |          |          |          |          |          |          
>                 |          |          |          |          |           --20.33%-- xfs_dir_fsync
>                 |          |          |          |          |                     vfs_fsync_range
>                 |          |          |          |          |                     do_fsync
>                 |          |          |          |          |                     sys_fdatasync
>                 |          |          |          |          |                     entry_SYSCALL_64_fastpath
>                 |          |          |          |          |                     |          
>                 |          |          |          |          |                      --100.00%-- 0x7f4ade4212ad
>                 |          |          |          |          |                                syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                 |          |          |          |          |                                0x6040000c3ec0
>                 |          |          |          |          |          
>                 |          |          |          |           --3.15%-- _xfs_log_force
>                 |          |          |          |                     xfs_log_force
>                 |          |          |          |                     xfs_buf_lock
>                 |          |          |          |                     _xfs_buf_find
>                 |          |          |          |                     xfs_buf_get_map
>                 |          |          |          |                     xfs_trans_get_buf_map
>                 |          |          |          |                     xfs_btree_get_bufl
>                 |          |          |          |                     xfs_bmap_extents_to_btree
>                 |          |          |          |                     xfs_bmap_add_extent_hole_real
>                 |          |          |          |                     xfs_bmapi_write
>                 |          |          |          |                     xfs_iomap_write_direct
>                 |          |          |          |                     __xfs_get_blocks
>                 |          |          |          |                     xfs_get_blocks_direct
>                 |          |          |          |                     do_blockdev_direct_IO
>                 |          |          |          |                     __blockdev_direct_IO
>                 |          |          |          |                     xfs_vm_direct_IO
>                 |          |          |          |                     xfs_file_dio_aio_write
>                 |          |          |          |                     xfs_file_write_iter
>                 |          |          |          |                     aio_run_iocb
>                 |          |          |          |                     do_io_submit
>                 |          |          |          |                     sys_io_submit
>                 |          |          |          |                     entry_SYSCALL_64_fastpath
>                 |          |          |          |                     io_submit
>                 |          |          |          |                     0x46d98a
>                 |          |          |          |          
>                 |          |          |           --9.93%-- submit_bio_wait
>                 |          |          |                     blkdev_issue_flush
>                 |          |          |                     xfs_blkdev_issue_flush
>                 |          |          |                     xfs_file_fsync
>                 |          |          |                     vfs_fsync_range
>                 |          |          |                     do_fsync
>                 |          |          |                     sys_fdatasync
>                 |          |          |                     entry_SYSCALL_64_fastpath
>                 |          |          |                     |          
>                 |          |          |                      --100.00%-- 0x7f4ade4212ad
>                 |          |          |                                syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                 |          |          |                                0x6030000c3ec0
>                 |          |          |          
>                 |          |          |--32.79%-- io_schedule_timeout
>                 |          |          |          bit_wait_io
>                 |          |          |          __wait_on_bit
>                 |          |          |          |          
>                 |          |          |          |--51.67%-- wait_on_page_bit
>                 |          |          |          |          |          
>                 |          |          |          |          |--95.16%-- filemap_fdatawait_range
>                 |          |          |          |          |          filemap_write_and_wait_range
>                 |          |          |          |          |          xfs_file_fsync
>                 |          |          |          |          |          vfs_fsync_range
>                 |          |          |          |          |          do_fsync
>                 |          |          |          |          |          sys_fdatasync
>                 |          |          |          |          |          entry_SYSCALL_64_fastpath
>                 |          |          |          |          |          0x7f4ade4212ad
>                 |          |          |          |          |          syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                 |          |          |          |          |          0x60b0000c3ec0
>                 |          |          |          |          |          
>                 |          |          |          |           --4.84%-- __migration_entry_wait
>                 |          |          |          |                     migration_entry_wait
>                 |          |          |          |                     handle_mm_fault
>                 |          |          |          |                     __do_page_fault
>                 |          |          |          |                     do_page_fault
>                 |          |          |          |                     page_fault
>                 |          |          |          |                     std::_Function_handler<void (), httpd::http_server::_date_format_timer::{lambda()#1}>::_M_invoke
>                 |          |          |          |                     |          
>                 |          |          |          |                      --100.00%-- service::storage_proxy::mutate_prepare<std::vector<mutation, std::allocator<mutation> >, service::storage_proxy::mutate_prepare(std::vector<mutation, std::allocator<mutation> >&, db::consistency_level, db::write_type)::{lambda(mutation const&, db::consistency_level, db::write_type)#1}>
>                 |          |          |          |                                service::storage_proxy::mutate
>                 |          |          |          |                                service::storage_proxy::mutate_with_triggers
>                 |          |          |          |                                cql3::statements::modification_statement::execute_without_condition
>                 |          |          |          |                                cql3::statements::modification_statement::execute
>                 |          |          |          |                                cql3::query_processor::process_statement
>                 |          |          |          |                                transport::cql_server::connection::process_execute
>                 |          |          |          |                                transport::cql_server::connection::process_request_one
>                 |          |          |          |                                futurize<future<std::pair<foreign_ptr<shared_ptr<transport::cql_server::response> >, service::client_state> > >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}::operator()(temporary_buffer) const::{lambda()#1}::operator()()::{lambda()#1}&>
>                 |          |          |          |                                futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}::operator()(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&) const::{lambda(temporary_buffer<char>)#1}, temporary_buffer>
>                 |          |          |          |                                futurize<future<> >::apply<transport::cql_server::connection::process_request()::{lambda(future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> >&&)#1}, future<std::experimental::fundamentals_v1::optional<transport::cql_binary_frame_v3> > >
>                 |          |          |          |                                transport::cql_server::connection::process_request
>                 |          |          |          |                                do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>
>                 |          |          |          |                                do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |          |          |                                do_void_futurize_apply<void do_until_continued<transport::cql_server::connection::process()::{lambda()#2}, transport::cql_server::connection::process()::{lambda()#1}&>(transport::cql_server::connection::process()::{lambda()#1}&, transport::cql_server::connection::process()::{lambda()#2}&&, promise<>)::{lambda(future<>)#1}, promise<> >
>                 |          |          |          |                                0x6140000c3000
>                 |          |          |          |          
>                 |          |          |           --48.33%-- out_of_line_wait_on_bit
>                 |          |          |                     block_truncate_page
>                 |          |          |                     xfs_setattr_size
>                 |          |          |                     xfs_vn_setattr
>                 |          |          |                     notify_change
>                 |          |          |                     do_truncate
>                 |          |          |                     do_sys_ftruncate.constprop.15
>                 |          |          |                     sys_ftruncate
>                 |          |          |                     entry_SYSCALL_64_fastpath
>                 |          |          |                     __GI___ftruncate64
>                 |          |          |                     syscall_work_queue::work_item_returning<syscall_result_extra<stat>, posix_file_impl::stat()::{lambda()#1}>::process
>                 |          |          |                     |          
>                 |          |          |                     |--13.79%-- 0x7f4ad29ff700
>                 |          |          |                     |          
>                 |          |          |                     |--13.79%-- 0x7f4acdbff700
>                 |          |          |                     |          
>                 |          |          |                     |--12.07%-- 0x7f4ad05ff700
>                 |          |          |                     |          
>                 |          |          |                     |--12.07%-- 0x7f4acedff700
>                 |          |          |                     |          
>                 |          |          |                     |--10.34%-- 0x7f4ad0bff700
>                 |          |          |                     |          
>                 |          |          |                     |--6.90%-- 0x7f4ad2fff700
>                 |          |          |                     |          
>                 |          |          |                     |--6.90%-- 0x7f4ad11ff700
>                 |          |          |                     |          
>                 |          |          |                     |--6.90%-- 0x7f4acf9ff700
>                 |          |          |                     |          
>                 |          |          |                     |--6.90%-- 0x7f4acf3ff700
>                 |          |          |                     |          
>                 |          |          |                     |--6.90%-- 0x7f4ace7ff700
>                 |          |          |                     |          
>                 |          |          |                     |--1.72%-- 0x7f4ad17ff700
>                 |          |          |                     |          
>                 |          |          |                      --1.72%-- 0x7f4aca5ff700
>                 |          |          |          
>                 |          |           --28.69%-- __down
>                 |          |                     down
>                 |          |                     xfs_buf_lock
>                 |          |                     _xfs_buf_find
>                 |          |                     xfs_buf_get_map
>                 |          |                     |          
>                 |          |                     |--97.14%-- xfs_buf_read_map
>                 |          |                     |          xfs_trans_read_buf_map
>                 |          |                     |          |          
>                 |          |                     |          |--98.04%-- xfs_read_agf
>                 |          |                     |          |          xfs_alloc_read_agf
>                 |          |                     |          |          xfs_alloc_fix_freelist
>                 |          |                     |          |          |          
>                 |          |                     |          |          |--93.00%-- xfs_free_extent
>                 |          |                     |          |          |          xfs_bmap_finish
>                 |          |                     |          |          |          xfs_itruncate_extents
>                 |          |                     |          |          |          |          
>                 |          |                     |          |          |          |--87.10%-- xfs_inactive_truncate
>                 |          |                     |          |          |          |          xfs_inactive
>                 |          |                     |          |          |          |          xfs_fs_evict_inode
>                 |          |                     |          |          |          |          evict
>                 |          |                     |          |          |          |          iput
>                 |          |                     |          |          |          |          __dentry_kill
>                 |          |                     |          |          |          |          dput
>                 |          |                     |          |          |          |          __fput
>                 |          |                     |          |          |          |          ____fput
>                 |          |                     |          |          |          |          task_work_run
>                 |          |                     |          |          |          |          do_notify_resume
>                 |          |                     |          |          |          |          int_signal
>                 |          |                     |          |          |          |          __libc_close
>                 |          |                     |          |          |          |          std::experimental::fundamentals_v1::bad_optional_access::~bad_optional_access
>                 |          |                     |          |          |          |          
>                 |          |                     |          |          |           --12.90%-- xfs_setattr_size
>                 |          |                     |          |          |                     xfs_vn_setattr
>                 |          |                     |          |          |                     notify_change
>                 |          |                     |          |          |                     do_truncate
>                 |          |                     |          |          |                     do_sys_ftruncate.constprop.15
>                 |          |                     |          |          |                     sys_ftruncate
>                 |          |                     |          |          |                     entry_SYSCALL_64_fastpath
>                 |          |                     |          |          |                     |          
>                 |          |                     |          |          |                      --100.00%-- __GI___ftruncate64
>                 |          |                     |          |          |                                syscall_work_queue::work_item_returning<syscall_result_extra<stat>, posix_file_impl::stat()::{lambda()#1}>::process
>                 |          |                     |          |          |                                |          
>                 |          |                     |          |          |                                |--20.00%-- 0x7f4ad0bff700
>                 |          |                     |          |          |                                |          
>                 |          |                     |          |          |                                |--20.00%-- 0x7f4acedff700
>                 |          |                     |          |          |                                |          
>                 |          |                     |          |          |                                |--10.00%-- 0x7f4ad2fff700
>                 |          |                     |          |          |                                |          
>                 |          |                     |          |          |                                |--10.00%-- 0x7f4ad17ff700
>                 |          |                     |          |          |                                |          
>                 |          |                     |          |          |                                |--10.00%-- 0x7f4ad11ff700
>                 |          |                     |          |          |                                |          
>                 |          |                     |          |          |                                |--10.00%-- 0x7f4ad05ff700
>                 |          |                     |          |          |                                |          
>                 |          |                     |          |          |                                |--10.00%-- 0x7f4acf3ff700
>                 |          |                     |          |          |                                |          
>                 |          |                     |          |          |                                 --10.00%-- 0x7f4acdbff700
>                 |          |                     |          |          |          
>                 |          |                     |          |           --7.00%-- xfs_alloc_vextent
>                 |          |                     |          |                     xfs_bmap_btalloc
>                 |          |                     |          |                     xfs_bmap_alloc
>                 |          |                     |          |                     xfs_bmapi_write
>                 |          |                     |          |                     xfs_iomap_write_direct
>                 |          |                     |          |                     __xfs_get_blocks
>                 |          |                     |          |                     xfs_get_blocks_direct
>                 |          |                     |          |                     do_blockdev_direct_IO
>                 |          |                     |          |                     __blockdev_direct_IO
>                 |          |                     |          |                     xfs_vm_direct_IO
>                 |          |                     |          |                     xfs_file_dio_aio_write
>                 |          |                     |          |                     xfs_file_write_iter
>                 |          |                     |          |                     aio_run_iocb
>                 |          |                     |          |                     do_io_submit
>                 |          |                     |          |                     sys_io_submit
>                 |          |                     |          |                     entry_SYSCALL_64_fastpath
>                 |          |                     |          |                     io_submit
>                 |          |                     |          |                     0x46d98a
>                 |          |                     |          |          
>                 |          |                     |           --1.96%-- xfs_read_agi
>                 |          |                     |                     xfs_iunlink_remove
>                 |          |                     |                     xfs_ifree
>                 |          |                     |                     xfs_inactive_ifree
>                 |          |                     |                     xfs_inactive
>                 |          |                     |                     xfs_fs_evict_inode
>                 |          |                     |                     evict
>                 |          |                     |                     iput
>                 |          |                     |                     __dentry_kill
>                 |          |                     |                     dput
>                 |          |                     |                     __fput
>                 |          |                     |                     ____fput
>                 |          |                     |                     task_work_run
>                 |          |                     |                     do_notify_resume
>                 |          |                     |                     int_signal
>                 |          |                     |                     __libc_close
>                 |          |                     |                     std::experimental::fundamentals_v1::bad_optional_access::~bad_optional_access
>                 |          |                     |          
>                 |          |                      --2.86%-- xfs_trans_get_buf_map
>                 |          |                                xfs_btree_get_bufl
>                 |          |                                xfs_bmap_extents_to_btree
>                 |          |                                xfs_bmap_add_extent_hole_real
>                 |          |                                xfs_bmapi_write
>                 |          |                                xfs_iomap_write_direct
>                 |          |                                __xfs_get_blocks
>                 |          |                                xfs_get_blocks_direct
>                 |          |                                do_blockdev_direct_IO
>                 |          |                                __blockdev_direct_IO
>                 |          |                                xfs_vm_direct_IO
>                 |          |                                xfs_file_dio_aio_write
>                 |          |                                xfs_file_write_iter
>                 |          |                                aio_run_iocb
>                 |          |                                do_io_submit
>                 |          |                                sys_io_submit
>                 |          |                                entry_SYSCALL_64_fastpath
>                 |          |                                io_submit
>                 |          |                                0x46d98a
>                 |          |          
>                 |          |--13.48%-- eventfd_ctx_read
>                 |          |          eventfd_read
>                 |          |          __vfs_read
>                 |          |          vfs_read
>                 |          |          sys_read
>                 |          |          entry_SYSCALL_64_fastpath
>                 |          |          0x7f4ade6f754d
>                 |          |          smp_message_queue::respond
>                 |          |          0xffffffffffffffff
>                 |          |          
>                 |          |--7.83%-- md_flush_request
>                 |          |          raid0_make_request
>                 |          |          md_make_request
>                 |          |          generic_make_request
>                 |          |          submit_bio
>                 |          |          |          
>                 |          |          |--92.54%-- submit_bio_wait
>                 |          |          |          blkdev_issue_flush
>                 |          |          |          xfs_blkdev_issue_flush
>                 |          |          |          xfs_file_fsync
>                 |          |          |          vfs_fsync_range
>                 |          |          |          do_fsync
>                 |          |          |          sys_fdatasync
>                 |          |          |          entry_SYSCALL_64_fastpath
>                 |          |          |          |          
>                 |          |          |           --100.00%-- 0x7f4ade4212ad
>                 |          |          |                     syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                 |          |          |                     0x6010000c3ec0
>                 |          |          |          
>                 |          |           --7.46%-- _xfs_buf_ioapply
>                 |          |                     xfs_buf_submit
>                 |          |                     xlog_bdstrat
>                 |          |                     xlog_sync
>                 |          |                     xlog_state_release_iclog
>                 |          |                     |          
>                 |          |                     |--73.33%-- _xfs_log_force_lsn
>                 |          |                     |          xfs_file_fsync
>                 |          |                     |          vfs_fsync_range
>                 |          |                     |          do_fsync
>                 |          |                     |          sys_fdatasync
>                 |          |                     |          entry_SYSCALL_64_fastpath
>                 |          |                     |          |          
>                 |          |                     |           --100.00%-- 0x7f4ade4212ad
>                 |          |                     |                     syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                 |          |                     |                     0x6080000c3ec0
>                 |          |                     |          
>                 |          |                      --26.67%-- _xfs_log_force
>                 |          |                                xfs_log_force
>                 |          |                                xfs_buf_lock
>                 |          |                                _xfs_buf_find
>                 |          |                                xfs_buf_get_map
>                 |          |                                xfs_trans_get_buf_map
>                 |          |                                xfs_btree_get_bufl
>                 |          |                                xfs_bmap_extents_to_btree
>                 |          |                                xfs_bmap_add_extent_hole_real
>                 |          |                                xfs_bmapi_write
>                 |          |                                xfs_iomap_write_direct
>                 |          |                                __xfs_get_blocks
>                 |          |                                xfs_get_blocks_direct
>                 |          |                                do_blockdev_direct_IO
>                 |          |                                __blockdev_direct_IO
>                 |          |                                xfs_vm_direct_IO
>                 |          |                                xfs_file_dio_aio_write
>                 |          |                                xfs_file_write_iter
>                 |          |                                aio_run_iocb
>                 |          |                                do_io_submit
>                 |          |                                sys_io_submit
>                 |          |                                entry_SYSCALL_64_fastpath
>                 |          |                                io_submit
>                 |          |                                0x46d98a
>                 |          |          
>                 |          |--5.53%-- _xfs_log_force_lsn
>                 |          |          |          
>                 |          |          |--80.28%-- xfs_file_fsync
>                 |          |          |          vfs_fsync_range
>                 |          |          |          do_fsync
>                 |          |          |          sys_fdatasync
>                 |          |          |          entry_SYSCALL_64_fastpath
>                 |          |          |          |          
>                 |          |          |           --100.00%-- 0x7f4ade4212ad
>                 |          |          |                     syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                 |          |          |                     |          
>                 |          |          |                     |--97.92%-- 0x60d0000c3ec0
>                 |          |          |                     |          
>                 |          |          |                     |--1.04%-- 0x6020000c3ec0
>                 |          |          |                     |          
>                 |          |          |                      --1.04%-- 0x600000557ec0
>                 |          |          |          
>                 |          |           --19.72%-- xfs_dir_fsync
>                 |          |                     vfs_fsync_range
>                 |          |                     do_fsync
>                 |          |                     sys_fdatasync
>                 |          |                     entry_SYSCALL_64_fastpath
>                 |          |                     |          
>                 |          |                      --100.00%-- 0x7f4ade4212ad
>                 |          |                                syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                 |          |                                0x6040000c3ec0
>                 |          |          
>                 |          |--1.25%-- rwsem_down_read_failed
>                 |          |          call_rwsem_down_read_failed
>                 |          |          |          
>                 |          |          |--90.62%-- xfs_ilock
>                 |          |          |          |          
>                 |          |          |          |--86.21%-- xfs_ilock_data_map_shared
>                 |          |          |          |          __xfs_get_blocks
>                 |          |          |          |          xfs_get_blocks_direct
>                 |          |          |          |          do_blockdev_direct_IO
>                 |          |          |          |          __blockdev_direct_IO
>                 |          |          |          |          xfs_vm_direct_IO
>                 |          |          |          |          xfs_file_dio_aio_write
>                 |          |          |          |          xfs_file_write_iter
>                 |          |          |          |          aio_run_iocb
>                 |          |          |          |          do_io_submit
>                 |          |          |          |          sys_io_submit
>                 |          |          |          |          entry_SYSCALL_64_fastpath
>                 |          |          |          |          |          
>                 |          |          |          |           --100.00%-- io_submit
>                 |          |          |          |                     0x46d98a
>                 |          |          |          |          
>                 |          |          |          |--6.90%-- xfs_file_fsync
>                 |          |          |          |          vfs_fsync_range
>                 |          |          |          |          do_fsync
>                 |          |          |          |          sys_fdatasync
>                 |          |          |          |          entry_SYSCALL_64_fastpath
>                 |          |          |          |          0x7f4ade4212ad
>                 |          |          |          |          syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                 |          |          |          |          0x6090000c3ec0
>                 |          |          |          |          
>                 |          |          |           --6.90%-- xfs_dir_fsync
>                 |          |          |                     vfs_fsync_range
>                 |          |          |                     do_fsync
>                 |          |          |                     sys_fdatasync
>                 |          |          |                     entry_SYSCALL_64_fastpath
>                 |          |          |                     0x7f4ade4212ad
>                 |          |          |                     syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                 |          |          |                     0x6070000c3ec0
>                 |          |          |          
>                 |          |           --9.38%-- xfs_log_commit_cil
>                 |          |                     __xfs_trans_commit
>                 |          |                     xfs_trans_commit
>                 |          |                     |          
>                 |          |                     |--33.33%-- xfs_setattr_size
>                 |          |                     |          xfs_vn_setattr
>                 |          |                     |          notify_change
>                 |          |                     |          do_truncate
>                 |          |                     |          do_sys_ftruncate.constprop.15
>                 |          |                     |          sys_ftruncate
>                 |          |                     |          entry_SYSCALL_64_fastpath
>                 |          |                     |          __GI___ftruncate64
>                 |          |                     |          syscall_work_queue::work_item_returning<syscall_result_extra<stat>, posix_file_impl::stat()::{lambda()#1}>::process
>                 |          |                     |          0x7f4acedff700
>                 |          |                     |          
>                 |          |                     |--33.33%-- xfs_vn_update_time
>                 |          |                     |          file_update_time
>                 |          |                     |          xfs_file_aio_write_checks
>                 |          |                     |          xfs_file_dio_aio_write
>                 |          |                     |          xfs_file_write_iter
>                 |          |                     |          aio_run_iocb
>                 |          |                     |          do_io_submit
>                 |          |                     |          sys_io_submit
>                 |          |                     |          entry_SYSCALL_64_fastpath
>                 |          |                     |          io_submit
>                 |          |                     |          0x46d98a
>                 |          |                     |          
>                 |          |                      --33.33%-- xfs_bmap_add_attrfork
>                 |          |                                xfs_attr_set
>                 |          |                                xfs_initxattrs
>                 |          |                                security_inode_init_security
>                 |          |                                xfs_init_security
>                 |          |                                xfs_generic_create
>                 |          |                                xfs_vn_mknod
>                 |          |                                xfs_vn_create
>                 |          |                                vfs_create
>                 |          |                                path_openat
>                 |          |                                do_filp_open
>                 |          |                                do_sys_open
>                 |          |                                sys_open
>                 |          |                                entry_SYSCALL_64_fastpath
>                 |          |                                0x7f4ade6f7cdd
>                 |          |                                syscall_work_queue::work_item_returning<syscall_result<int>, reactor::open_file_dma(basic_sstring<char, unsigned int, 15u>, open_flags, file_open_options)::{lambda()#1}>::process
>                 |          |                                0xffffffffffffffff
>                 |          |          
>                 |          |--0.97%-- rwsem_down_write_failed
>                 |          |          call_rwsem_down_write_failed
>                 |          |          xfs_ilock
>                 |          |          xfs_vn_update_time
>                 |          |          file_update_time
>                 |          |          xfs_file_aio_write_checks
>                 |          |          xfs_file_dio_aio_write
>                 |          |          xfs_file_write_iter
>                 |          |          aio_run_iocb
>                 |          |          do_io_submit
>                 |          |          sys_io_submit
>                 |          |          entry_SYSCALL_64_fastpath
>                 |          |          io_submit
>                 |          |          0x46d98a
>                 |          |          
>                 |          |--0.51%-- xlog_cil_force_lsn
>                 |          |          |          
>                 |          |          |--92.31%-- _xfs_log_force_lsn
>                 |          |          |          |          
>                 |          |          |          |--91.67%-- xfs_file_fsync
>                 |          |          |          |          vfs_fsync_range
>                 |          |          |          |          do_fsync
>                 |          |          |          |          sys_fdatasync
>                 |          |          |          |          entry_SYSCALL_64_fastpath
>                 |          |          |          |          0x7f4ade4212ad
>                 |          |          |          |          syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                 |          |          |          |          0x60b0000c3ec0
>                 |          |          |          |          
>                 |          |          |           --8.33%-- xfs_dir_fsync
>                 |          |          |                     vfs_fsync_range
>                 |          |          |                     do_fsync
>                 |          |          |                     sys_fdatasync
>                 |          |          |                     entry_SYSCALL_64_fastpath
>                 |          |          |                     0x7f4ade4212ad
>                 |          |          |                     syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                 |          |          |                     0x60d0000c3ec0
>                 |          |          |          
>                 |          |           --7.69%-- _xfs_log_force
>                 |          |                     xfs_log_force
>                 |          |                     xfs_buf_lock
>                 |          |                     _xfs_buf_find
>                 |          |                     xfs_buf_get_map
>                 |          |                     xfs_trans_get_buf_map
>                 |          |                     xfs_btree_get_bufl
>                 |          |                     xfs_bmap_extents_to_btree
>                 |          |                     xfs_bmap_add_extent_hole_real
>                 |          |                     xfs_bmapi_write
>                 |          |                     xfs_iomap_write_direct
>                 |          |                     __xfs_get_blocks
>                 |          |                     xfs_get_blocks_direct
>                 |          |                     do_blockdev_direct_IO
>                 |          |                     __blockdev_direct_IO
>                 |          |                     xfs_vm_direct_IO
>                 |          |                     xfs_file_dio_aio_write
>                 |          |                     xfs_file_write_iter
>                 |          |                     aio_run_iocb
>                 |          |                     do_io_submit
>                 |          |                     sys_io_submit
>                 |          |                     entry_SYSCALL_64_fastpath
>                 |          |                     io_submit
>                 |          |                     0x46d98a
>                 |           --0.04%-- [...]
>                 |          
>                  --3.82%-- preempt_schedule_common
>                            |          
>                            |--99.02%-- _cond_resched
>                            |          |          
>                            |          |--41.58%-- wait_for_completion
>                            |          |          |          
>                            |          |          |--66.67%-- flush_work
>                            |          |          |          xlog_cil_force_lsn
>                            |          |          |          |          
>                            |          |          |          |--96.43%-- _xfs_log_force_lsn
>                            |          |          |          |          |          
>                            |          |          |          |          |--77.78%-- xfs_file_fsync
>                            |          |          |          |          |          vfs_fsync_range
>                            |          |          |          |          |          do_fsync
>                            |          |          |          |          |          sys_fdatasync
>                            |          |          |          |          |          entry_SYSCALL_64_fastpath
>                            |          |          |          |          |          0x7f4ade4212ad
>                            |          |          |          |          |          syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                            |          |          |          |          |          0x6030000c3ec0
>                            |          |          |          |          |          
>                            |          |          |          |           --22.22%-- xfs_dir_fsync
>                            |          |          |          |                     vfs_fsync_range
>                            |          |          |          |                     do_fsync
>                            |          |          |          |                     sys_fdatasync
>                            |          |          |          |                     entry_SYSCALL_64_fastpath
>                            |          |          |          |                     |          
>                            |          |          |          |                      --100.00%-- 0x7f4ade4212ad
>                            |          |          |          |                                syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                            |          |          |          |                                0x6030000c3ec0
>                            |          |          |          |          
>                            |          |          |           --3.57%-- _xfs_log_force
>                            |          |          |                     xfs_log_force
>                            |          |          |                     xfs_buf_lock
>                            |          |          |                     _xfs_buf_find
>                            |          |          |                     xfs_buf_get_map
>                            |          |          |                     xfs_trans_get_buf_map
>                            |          |          |                     xfs_btree_get_bufl
>                            |          |          |                     xfs_bmap_extents_to_btree
>                            |          |          |                     xfs_bmap_add_extent_hole_real
>                            |          |          |                     xfs_bmapi_write
>                            |          |          |                     xfs_iomap_write_direct
>                            |          |          |                     __xfs_get_blocks
>                            |          |          |                     xfs_get_blocks_direct
>                            |          |          |                     do_blockdev_direct_IO
>                            |          |          |                     __blockdev_direct_IO
>                            |          |          |                     xfs_vm_direct_IO
>                            |          |          |                     xfs_file_dio_aio_write
>                            |          |          |                     xfs_file_write_iter
>                            |          |          |                     aio_run_iocb
>                            |          |          |                     do_io_submit
>                            |          |          |                     sys_io_submit
>                            |          |          |                     entry_SYSCALL_64_fastpath
>                            |          |          |                     io_submit
>                            |          |          |                     0x46d98a
>                            |          |          |          
>                            |          |           --33.33%-- submit_bio_wait
>                            |          |                     blkdev_issue_flush
>                            |          |                     xfs_blkdev_issue_flush
>                            |          |                     xfs_file_fsync
>                            |          |                     vfs_fsync_range
>                            |          |                     do_fsync
>                            |          |                     sys_fdatasync
>                            |          |                     entry_SYSCALL_64_fastpath
>                            |          |                     |          
>                            |          |                      --100.00%-- 0x7f4ade4212ad
>                            |          |                                syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                            |          |                                0x6030000c3ec0
>                            |          |          
>                            |          |--33.66%-- flush_work
>                            |          |          xlog_cil_force_lsn
>                            |          |          |          
>                            |          |          |--97.06%-- _xfs_log_force_lsn
>                            |          |          |          |          
>                            |          |          |          |--78.79%-- xfs_file_fsync
>                            |          |          |          |          vfs_fsync_range
>                            |          |          |          |          do_fsync
>                            |          |          |          |          sys_fdatasync
>                            |          |          |          |          entry_SYSCALL_64_fastpath
>                            |          |          |          |          0x7f4ade4212ad
>                            |          |          |          |          syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                            |          |          |          |          0x6030000c3ec0
>                            |          |          |          |          
>                            |          |          |           --21.21%-- xfs_dir_fsync
>                            |          |          |                     vfs_fsync_range
>                            |          |          |                     do_fsync
>                            |          |          |                     sys_fdatasync
>                            |          |          |                     entry_SYSCALL_64_fastpath
>                            |          |          |                     |          
>                            |          |          |                      --100.00%-- 0x7f4ade4212ad
>                            |          |          |                                syscall_work_queue::work_item_returning<syscall_result<int>, posix_file_impl::flush()::{lambda()#1}>::process
>                            |          |          |                                0x6030000c3ec0
>                            |          |          |          
>                            |          |           --2.94%-- _xfs_log_force
>                            |          |                     xfs_log_force
>                            |          |                     xfs_buf_lock
>                            |          |                     _xfs_buf_find
>                            |          |                     xfs_buf_get_map
>                            |          |                     xfs_trans_get_buf_map
>                            |          |                     xfs_btree_get_bufl
>                            |          |                     xfs_bmap_extents_to_btree
>                            |          |                     xfs_bmap_add_extent_hole_real
>                            |          |                     xfs_bmapi_write
>                            |          |                     xfs_iomap_write_direct
>                            |          |                     __xfs_get_blocks
>                            |          |                     xfs_get_blocks_direct
>                            |          |                     do_blockdev_direct_IO
>                            |          |                     __blockdev_direct_IO
>                            |          |                     xfs_vm_direct_IO
>                            |          |                     xfs_file_dio_aio_write
>                            |          |                     xfs_file_write_iter
>                            |          |                     aio_run_iocb
>                            |          |                     do_io_submit
>                            |          |                     sys_io_submit
>                            |          |                     entry_SYSCALL_64_fastpath
>                            |          |                     io_submit
>                            |          |                     0x46d98a
>                            |          |          
>                            |          |--13.86%-- lock_sock_nested
>                            |          |          |          
>                            |          |          |--78.57%-- tcp_sendmsg
>                            |          |          |          inet_sendmsg
>                            |          |          |          sock_sendmsg
>                            |          |          |          SYSC_sendto
>                            |          |          |          sys_sendto
>                            |          |          |          entry_SYSCALL_64_fastpath
>                            |          |          |          __libc_send
>                            |          |          |          _ZN12continuationIZN6futureIJmEE4thenIZN7reactor14write_all_partER17pollable_fd_statePKvmmEUlmE_S0_IJEEEET0_OT_EUlSC_E_JmEE3runEv
>                            |          |          |          |          
>                            |          |          |          |--36.36%-- 0x7f4ad6bf8de0
>                            |          |          |          |          
>                            |          |          |          |--9.09%-- 0x4
>                            |          |          |          |          
>                            |          |          |          |--9.09%-- 0x7f4adadf8de0
>                            |          |          |          |          
>                            |          |          |          |--9.09%-- 0x7f4ada1f8de0
>                            |          |          |          |          
>                            |          |          |          |--9.09%-- 0x7f4ad89f8de0
>                            |          |          |          |          
>                            |          |          |          |--9.09%-- 0x7f4ad83f8de0
>                            |          |          |          |          
>                            |          |          |          |--9.09%-- 0x7f4ad4df8de0
>                            |          |          |          |          
>                            |          |          |           --9.09%-- 0x7f4ad35f8de0
>                            |          |          |          
>                            |          |           --21.43%-- tcp_recvmsg
>                            |          |                     inet_recvmsg
>                            |          |                     sock_recvmsg
>                            |          |                     sock_read_iter
>                            |          |                     __vfs_read
>                            |          |                     vfs_read
>                            |          |                     sys_read
>                            |          |                     entry_SYSCALL_64_fastpath
>                            |          |                     0x7f4ade6f754d
>                            |          |                     reactor::read_some
>                            |          |                     |          
>                            |          |                     |--66.67%-- _ZN12continuationIZN6futureIJEE4thenIZZN7service13storage_proxy22send_to_live_endpointsEmENKUlRSt4pairIK13basic_sstringIcjLj15EESt6vectorIN3gms12inet_addressESaISB_EEEE_clESF_EUlvE_S1_EET0_OT_EUlSK_E_JEE3runEv
>                            |          |                     |          reactor::del_timer
>                            |          |                     |          0x6160000e2040
>                            |          |                     |          
>                            |          |                      --33.33%-- continuation<future<> future<>::then_wrapped<future<> future<>::finally<auto seastar::with_gate<transport::cql_server::connection::process()::{lambda()#2}::operator()() const::{lambda()#1}>(seastar::gate&, transport::cql_server::connection::process()::{lambda()#2}::operator()() const::{lambda()#1}&&)::{lambda()#1}>(seastar::gate&)::{lambda(future<>)#1}::operator()(future<>)::{lambda(seastar::gate)#1}, future<> >(seastar::gate&)::{lambda(seastar::gate&)#1}>::run
>                            |          |                                reactor::del_timer
>                            |          |                                0x6030000e2040
>                            |          |          
>                            |          |--3.96%-- generic_make_request_checks
>                            |          |          generic_make_request
>                            |          |          submit_bio
>                            |          |          do_blockdev_direct_IO
>                            |          |          __blockdev_direct_IO
>                            |          |          xfs_vm_direct_IO
>                            |          |          xfs_file_dio_aio_write
>                            |          |          xfs_file_write_iter
>                            |          |          aio_run_iocb
>                            |          |          do_io_submit
>                            |          |          sys_io_submit
>                            |          |          entry_SYSCALL_64_fastpath
>                            |          |          io_submit
>                            |          |          0x46d98a
>                            |          |          
>                            |          |--3.96%-- kmem_cache_alloc_node
>                            |          |          __alloc_skb
>                            |          |          sk_stream_alloc_skb
>                            |          |          tcp_sendmsg
>                            |          |          inet_sendmsg
>                            |          |          sock_sendmsg
>                            |          |          SYSC_sendto
>                            |          |          sys_sendto
>                            |          |          entry_SYSCALL_64_fastpath
>                            |          |          __libc_send
>                            |          |          _ZN12continuationIZN6futureIJmEE4thenIZN7reactor14write_all_partER17pollable_fd_statePKvmmEUlmE_S0_IJEEEET0_OT_EUlSC_E_JmEE3runEv
>                            |          |          |          
>                            |          |          |--25.00%-- 0x7f4ad9bf8de0
>                            |          |          |          
>                            |          |          |--25.00%-- 0x7f4ad7df8de0
>                            |          |          |          
>                            |          |          |--25.00%-- 0x7f4ad77f8de0
>                            |          |          |          
>                            |          |           --25.00%-- 0x7f4ad59f8de0
>                            |          |          
>                            |          |--0.99%-- unmap_underlying_metadata
>                            |          |          do_blockdev_direct_IO
>                            |          |          __blockdev_direct_IO
>                            |          |          xfs_vm_direct_IO
>                            |          |          xfs_file_dio_aio_write
>                            |          |          xfs_file_write_iter
>                            |          |          aio_run_iocb
>                            |          |          do_io_submit
>                            |          |          sys_io_submit
>                            |          |          entry_SYSCALL_64_fastpath
>                            |          |          io_submit
>                            |          |          0x46d98a
>                            |          |          
>                            |          |--0.99%-- __kmalloc_node_track_caller
>                            |          |          __kmalloc_reserve.isra.32
>                            |          |          __alloc_skb
>                            |          |          sk_stream_alloc_skb
>                            |          |          tcp_sendmsg
>                            |          |          inet_sendmsg
>                            |          |          sock_sendmsg
>                            |          |          SYSC_sendto
>                            |          |          sys_sendto
>                            |          |          entry_SYSCALL_64_fastpath
>                            |          |          __libc_send
>                            |          |          _ZN12continuationIZN6futureIJmEE4thenIZN7reactor14write_all_partER17pollable_fd_statePKvmmEUlmE_S0_IJEEEET0_OT_EUlSC_E_JmEE3runEv
>                            |          |          0x7f4ad6bf8de0
>                            |          |          
>                            |           --0.99%-- task_work_run
>                            |                     do_notify_resume
>                            |                     int_signal
>                            |                     __libc_close
>                            |                     std::experimental::fundamentals_v1::bad_optional_access::~bad_optional_access
>                            |          
>                             --0.98%-- __cond_resched_softirq
>                                       release_sock
>                                       tcp_sendmsg
>                                       inet_sendmsg
>                                       sock_sendmsg
>                                       SYSC_sendto
>                                       sys_sendto
>                                       entry_SYSCALL_64_fastpath
>                                       __libc_send
>                                       _ZN12continuationIZN6futureIJmEE4thenIZN7reactor14write_all_partER17pollable_fd_statePKvmmEUlmE_S0_IJEEEET0_OT_EUlSC_E_JmEE3runEv
>                                       0x7f4ada1f8de0
> 
> 
> 
> #
> # (For a higher level overview, try: perf report --sort comm,dso)
> #

> [164814.835933] CPU: 22 PID: 48042 Comm: scylla Tainted: G            E   4.2.6-200.fc22.x86_64 #1
> [164814.835936] Hardware name: Xen HVM domU, BIOS 4.2.amazon 05/06/2015
> [164814.835937]  0000000000000000 00000000a8713b7a ffff8802fb977ab8 ffffffff817729ea
> [164814.835941]  0000000000000000 ffff88076a69f780 ffff8802fb977ad8 ffffffffa03217a6
> [164814.835946]  ffff88077119bcb0 0000000000000000 ffff8802fb977b08 ffffffffa034e749
> [164814.835951] Call Trace:
> [164814.835954]  [<ffffffff817729ea>] dump_stack+0x45/0x57
> [164814.835971]  [<ffffffffa03217a6>] xfs_buf_stale+0x26/0x80 [xfs]
> [164814.835989]  [<ffffffffa034e749>] xfs_trans_binval+0x79/0x100 [xfs]
> [164814.836001]  [<ffffffffa02f479b>] xfs_bmap_btree_to_extents+0x12b/0x1a0 [xfs]
> [164814.836012]  [<ffffffffa02f8977>] xfs_bunmapi+0x967/0x9f0 [xfs]
> [164814.836027]  [<ffffffffa0334b9e>] xfs_itruncate_extents+0x10e/0x220 [xfs]
> [164814.836044]  [<ffffffffa033f75a>] ? kmem_zone_alloc+0x5a/0xe0 [xfs]
> [164814.836084]  [<ffffffffa0334d49>] xfs_inactive_truncate+0x99/0x110 [xfs]
> [164814.836120]  [<ffffffffa0335aa2>] xfs_inactive+0x102/0x120 [xfs]
> [164814.836135]  [<ffffffffa033a6cf>] xfs_fs_evict_inode+0x6f/0xa0 [xfs]
> [164814.836138]  [<ffffffff81238d76>] evict+0xa6/0x170
> [164814.836140]  [<ffffffff81239026>] iput+0x196/0x220
> [164814.836147]  [<ffffffff81234fe4>] __dentry_kill+0x174/0x1c0
> [164814.836150]  [<ffffffff8123514b>] dput+0x11b/0x200
> [164814.836155]  [<ffffffff8121fe02>] __fput+0x172/0x1e0
> [164814.836158]  [<ffffffff8121febe>] ____fput+0xe/0x10
> [164814.836161]  [<ffffffff810bab75>] task_work_run+0x85/0xb0
> [164814.836164]  [<ffffffff81014a4d>] do_notify_resume+0x8d/0x90
> [164814.836167]  [<ffffffff817795bc>] int_signal+0x12/0x17

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
