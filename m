Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8G0HsmP218809 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 19:17:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 993121D89409
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 17:18:41 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	DxpBaaYmcQJlmKdh for <xfs@oss.sgi.com>;
	Wed, 15 Sep 2010 17:18:41 -0700 (PDT)
Date: Thu, 16 Sep 2010 10:18:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Latencies writing to memory mapped files
Message-ID: <20100916001837.GF24409@dastard>
References: <20100915152633.GA2585@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100915152633.GA2585@BohrerMBP.rgmadvisors.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 15, 2010 at 10:26:33AM -0500, Shawn Bohrer wrote:
> Hello,
> 
> A little while ago I asked about ways to solve the occasional spikes in
> latency that I see when writing to a shared memory mapped file.
> 
> http://oss.sgi.com/pipermail/xfs/2010-July/046311.html
> 
> With Dave's suggestions I enabled lazy-count=1 which did help a little:
> 
> # xfs_info /home/
> meta-data=/dev/sda5              isize=256    agcount=32, agsize=8472969 blks
>          =                       sectsz=512   attr=1
> data     =                       bsize=4096   blocks=271135008, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> I'm also mounting the partition with "noatime,nobarrier,logbufs=8".

You really should add logbsize=262144 there - it won't prevent the
latencies, but with less log writes the incidence should decrease
significantly.

> The other change I made which helped the most was to use fallocate()
> to grow the file instead of lseek() and a write().

Ok, so now you are doing unwritten extent conversion at IO
completion, which is where this new latency issue has come from.

> The latencies look
> acceptable at lower data rates but once I reach 2-3 MB/s I start
> seeing spikes when writeback occurs.  Perhaps my expectations are
> unreasonable, but I would like to keep my latencies under 0.01s and
> the lower the better.  I don't have hard real-time requirements, but
> latencies are important.  These systems also only need to log data for
> about 7-8 hours, so while I don't exactly know how much data I will
> get I can make some guesses and preallocate the files or perform other
> tricks if it would help.

I think doing that is a good idea from a layout persepctive, but it
won't help this particular latency cause because it is a result of
using prealocation.

> Below are some snippets of a trace of a 0.3 second delay I captured
> with ftrace on 2.6.32.21.  I haven't done enough sampling to know if
> all of the delays happen for the same reason, or if there are multiple
> code paths that lead to a large delay.
> 
> First I see xfsconvertd/7 acquire the xfs_ilock() then try to acquire
> the xfs_buf_lock() and block:
> 
> 
> xfsconvertd/7-251   [007] 358613.942101: funcgraph_entry:                   |  xfs_end_bio_unwritten() {
> xfsconvertd/7-251   [007] 358613.942101: funcgraph_entry:                   |    xfs_iomap_write_unwritten() {
> xfsconvertd/7-251   [007] 358613.942102: funcgraph_entry:                   |      _xfs_trans_alloc() {
> xfsconvertd/7-251   [007] 358613.942104: funcgraph_exit:         2.582 us   |      }
> xfsconvertd/7-251   [007] 358613.942104: funcgraph_entry:                   |      xfs_trans_reserve() {
> xfsconvertd/7-251   [007] 358613.942546: funcgraph_exit:       ! 441.449 us |      }
> xfsconvertd/7-251   [007] 358613.942546: funcgraph_entry:                   |      xfs_ilock() {
> xfsconvertd/7-251   [007] 358613.942547: funcgraph_exit:         0.895 us   |      }
> xfsconvertd/7-251   [007] 358613.942547: funcgraph_entry:                   |      xfs_trans_ijoin() {
> xfsconvertd/7-251   [007] 358613.942548: funcgraph_exit:         0.667 us   |      }
> xfsconvertd/7-251   [007] 358613.942548: funcgraph_entry:        0.138 us   |      xfs_trans_ihold();
> xfsconvertd/7-251   [007] 358613.942549: funcgraph_entry:                   |      xfs_bmapi() {
> xfsconvertd/7-251   [007] 358613.942549: funcgraph_entry:                   |        xfs_bmap_search_extents() {
> xfsconvertd/7-251   [007] 358613.942564: funcgraph_exit:       + 14.764 us  |        }
> xfsconvertd/7-251   [007] 358613.942565: funcgraph_entry:                   |        xfs_bmbt_init_cursor() {
> xfsconvertd/7-251   [007] 358613.942567: funcgraph_exit:         2.740 us   |        }
> xfsconvertd/7-251   [007] 358613.942568: funcgraph_entry:                   |        xfs_bmap_add_extent() {
> xfsconvertd/7-251   [007] 358613.942568: funcgraph_entry:                   |          xfs_iext_get_ext() {
> xfsconvertd/7-251   [007] 358613.942569: funcgraph_exit:         0.702 us   |          }
> xfsconvertd/7-251   [007] 358613.942569: funcgraph_entry:        0.215 us   |          xfs_bmbt_get_all();
> xfsconvertd/7-251   [007] 358613.942569: funcgraph_entry:                   |          xfs_bmap_add_extent_unwritten_real() {
> xfsconvertd/7-251   [007] 358613.942570: funcgraph_entry:                   |            xfs_iext_get_ext() {
> xfsconvertd/7-251   [007] 358613.942570: funcgraph_exit:         0.677 us   |            }
> xfsconvertd/7-251   [007] 358613.942571: funcgraph_entry:        0.218 us   |            xfs_bmbt_get_all();
> xfsconvertd/7-251   [007] 358613.942571: funcgraph_entry:                   |            xfs_iext_get_ext() {
> xfsconvertd/7-251   [007] 358613.942572: funcgraph_exit:         0.844 us   |            }
> xfsconvertd/7-251   [007] 358613.942572: funcgraph_entry:        0.216 us   |            xfs_bmbt_get_all();
> xfsconvertd/7-251   [007] 358613.942573: funcgraph_entry:                   |            xfs_iext_get_ext() {
> xfsconvertd/7-251   [007] 358613.942573: funcgraph_exit:         0.708 us   |            }
> xfsconvertd/7-251   [007] 358613.942574: funcgraph_entry:        0.175 us   |            xfs_bmbt_get_all();
> xfsconvertd/7-251   [007] 358613.942574: funcgraph_entry:                   |            xfs_iext_get_ext() {
> xfsconvertd/7-251   [007] 358613.942575: funcgraph_exit:         1.079 us   |            }
> xfsconvertd/7-251   [007] 358613.942575: funcgraph_entry:        0.220 us   |            xfs_bmbt_set_blockcount();
> xfsconvertd/7-251   [007] 358613.942576: funcgraph_entry:        0.303 us   |            xfs_bmbt_set_startoff();
> xfsconvertd/7-251   [007] 358613.942577: funcgraph_entry:        0.216 us   |            xfs_bmbt_set_startblock();
> xfsconvertd/7-251   [007] 358613.942577: funcgraph_entry:        0.423 us   |            xfs_bmbt_set_blockcount();
> xfsconvertd/7-251   [007] 358613.942578: funcgraph_entry:                   |            xfs_bmbt_lookup_eq() {
> xfsconvertd/7-251   [007] 358613.942578: funcgraph_entry:                   |              xfs_btree_lookup() {
> xfsconvertd/7-251   [007] 358613.942579: funcgraph_entry:        0.212 us   |                xfs_bmbt_init_ptr_from_cur();
> xfsconvertd/7-251   [007] 358613.942579: funcgraph_entry:                   |                xfs_btree_lookup_get_block() {
> xfsconvertd/7-251   [007] 358613.942721: funcgraph_exit:       ! 141.594 us |                }
> xfsconvertd/7-251   [007] 358613.942721: funcgraph_entry:                   |                xfs_lookup_get_search_key() {
> xfsconvertd/7-251   [007] 358613.942723: funcgraph_exit:         1.205 us   |                }
> xfsconvertd/7-251   [007] 358613.942723: funcgraph_entry:        0.208 us   |                xfs_bmbt_key_diff();
> xfsconvertd/7-251   [007] 358613.942723: funcgraph_entry:                   |                xfs_btree_ptr_addr() {
> xfsconvertd/7-251   [007] 358613.942725: funcgraph_exit:         1.686 us   |                }
> xfsconvertd/7-251   [007] 358613.942725: funcgraph_entry:                   |                xfs_btree_lookup_get_block() {
> xfsconvertd/7-251   [007] 358613.942726: funcgraph_entry:                   |                  xfs_btree_read_buf_block() {
> xfsconvertd/7-251   [007] 358613.942726: funcgraph_entry:        0.252 us   |                    xfs_btree_ptr_to_daddr();
> xfsconvertd/7-251   [007] 358613.942726: funcgraph_entry:                   |                    xfs_trans_read_buf() {
> xfsconvertd/7-251   [007] 358613.942727: funcgraph_entry:        0.330 us   |                      xfs_trans_buf_item_match();
> xfsconvertd/7-251   [007] 358613.942728: funcgraph_entry:                   |                      xfs_buf_read_flags() {
> xfsconvertd/7-251   [007] 358613.942728: funcgraph_entry:                   |                        xfs_buf_get_flags() {
> xfsconvertd/7-251   [007] 358613.942728: funcgraph_entry:                   |                          kmem_zone_alloc() {
> xfsconvertd/7-251   [007] 358613.942885: funcgraph_exit:       ! 156.328 us |                          }
> xfsconvertd/7-251   [007] 358613.942885: funcgraph_entry:                   |                          _xfs_buf_find() {
> xfsconvertd/7-251   [007] 358613.942885: funcgraph_entry:        0.150 us   |                            _spin_lock();
> xfsconvertd/7-251   [007] 358613.942885: funcgraph_entry:                   |                            down_trylock() {
> xfsconvertd/7-251   [007] 358613.942886: funcgraph_exit:         0.818 us   |                            }
> xfsconvertd/7-251   [007] 358613.942886: funcgraph_entry:                   |                            xfs_buf_lock() {
> xfsconvertd/7-251   [007] 358613.942886: funcgraph_entry:                   |                              down() {
....

Ok, so we need access to a buffer to complete the unwritten extent
conversion.


> Next the flush-8:0 thread tries to aquire the xfs_ilock() and blocks:
> 
> 
> flush-8:0-505   [011] 358613.964686: funcgraph_entry:                   |              __writepage() {
> flush-8:0-505   [011] 358613.964687: funcgraph_entry:                   |                xfs_vm_writepage() {
> flush-8:0-505   [011] 358613.964687: funcgraph_entry:        0.467 us   |                  xfs_count_page_state();
> flush-8:0-505   [011] 358613.964688: funcgraph_entry:                   |                  xfs_page_state_convert() {
> flush-8:0-505   [011] 358613.964688: funcgraph_entry:                   |                    xfs_probe_cluster() {
> flush-8:0-505   [011] 358613.964694: funcgraph_exit:         6.002 us   |                    }
> flush-8:0-505   [011] 358613.964694: funcgraph_entry:                   |                    xfs_map_blocks() {
> flush-8:0-505   [011] 358613.964695: funcgraph_entry:                   |                      xfs_iomap() {
> flush-8:0-505   [011] 358613.964695: funcgraph_entry:                   |                        xfs_ilock_map_shared() {
> flush-8:0-505   [011] 358613.964695: funcgraph_entry:                   |                          xfs_ilock() {
> flush-8:0-505   [011] 358613.964695: funcgraph_entry:                   |                            down_read() {
....

Yes, that's normal.

> Then my process writes to the file generates a page fault which tries
> to acquire the xfs_ilock() and blocks:
> 
> 
> file_writer-30495 [013] 358613.968909: print:                00000000 delay start
> file_writer-30495 [013] 358613.968913: funcgraph_entry:        0.151 us   |  down_read_trylock();
> file_writer-30495 [013] 358613.968913: funcgraph_entry:        0.152 us   |  _cond_resched();
> file_writer-30495 [013] 358613.968913: funcgraph_entry:        0.520 us   |  find_vma();
> file_writer-30495 [013] 358613.968914: funcgraph_entry:                   |  handle_mm_fault() {
> file_writer-30495 [013] 358613.968914: funcgraph_entry:                   |    __do_fault() {
> file_writer-30495 [013] 358613.968914: funcgraph_entry:                   |      filemap_fault() {
> file_writer-30495 [013] 358613.968915: funcgraph_exit:         1.171 us   |      }
> file_writer-30495 [013] 358613.968916: funcgraph_entry:                   |      unlock_page() {
> file_writer-30495 [013] 358613.968916: funcgraph_exit:         0.814 us   |      }
> file_writer-30495 [013] 358613.968917: funcgraph_entry:                   |      xfs_vm_page_mkwrite() {
> file_writer-30495 [013] 358613.968917: funcgraph_entry:                   |        block_page_mkwrite() {
> file_writer-30495 [013] 358613.968917: funcgraph_entry:        0.137 us   |          _cond_resched();
> file_writer-30495 [013] 358613.968917: funcgraph_entry:                   |          block_prepare_write() {
> file_writer-30495 [013] 358613.968917: funcgraph_entry:                   |            __block_prepare_write() {
> file_writer-30495 [013] 358613.968918: funcgraph_entry:                   |              create_empty_buffers() {
> file_writer-30495 [013] 358613.968920: funcgraph_exit:         2.760 us   |              }
> file_writer-30495 [013] 358613.968921: funcgraph_entry:                   |              xfs_get_blocks() {
> file_writer-30495 [013] 358613.968921: funcgraph_entry:                   |                __xfs_get_blocks() {
> file_writer-30495 [013] 358613.968921: funcgraph_entry:                   |                  xfs_iomap() {
> file_writer-30495 [013] 358613.968921: funcgraph_entry:                   |                    xfs_ilock() {
> file_writer-30495 [013] 358613.968921: funcgraph_entry:                   |                      down_write() {
.....

Yes, I'd expect that to happen, too.


> Next I see xfslogd/7 release the xfs_buf_lock which wakes up
> xfsconvertd/7:
> 
> 
> file_reader-31161 [007] 358614.285351: sched_switch:         task file_reader:31161 [89] (S) ==> xfslogd/7:219 [120]
> xfslogd/7-219   [007] 358614.285352: funcgraph_entry:                   |    finish_task_switch() {
> xfslogd/7-219   [007] 358614.285353: funcgraph_exit:         1.327 us   |    }
> xfslogd/7-219   [007] 358614.285353: funcgraph_exit:       ! 385801.165 us |  }
> xfslogd/7-219   [007] 358614.285354: funcgraph_entry:        0.403 us   |  finish_wait();
> xfslogd/7-219   [007] 358614.285355: funcgraph_entry:        0.518 us   |  kthread_should_stop();
> xfslogd/7-219   [007] 358614.285355: funcgraph_entry:        0.336 us   |  _spin_lock_irq();
> xfslogd/7-219   [007] 358614.285356: funcgraph_entry:        0.362 us   |  _spin_lock_irqsave();
> xfslogd/7-219   [007] 358614.285357: funcgraph_entry:        0.331 us   |  _spin_unlock_irqrestore();
> xfslogd/7-219   [007] 358614.285358: funcgraph_entry:                   |  xfs_buf_iodone_work() {
> xfslogd/7-219   [007] 358614.285358: funcgraph_entry:                   |    xfs_buf_iodone_callbacks() {
> xfslogd/7-219   [007] 358614.285359: funcgraph_entry:                   |      xfs_buf_do_callbacks() {
> xfslogd/7-219   [007] 358614.285367: funcgraph_exit:         7.849 us   |      }
> xfslogd/7-219   [007] 358614.285367: funcgraph_entry:                   |      xfs_buf_ioend() {
> xfslogd/7-219   [007] 358614.285367: funcgraph_entry:                   |        xfs_buf_iodone_work() {
> xfslogd/7-219   [007] 358614.285367: funcgraph_entry:                   |          xfs_buf_unlock() {
> xfslogd/7-219   [007] 358614.285368: funcgraph_entry:                   |            up() {
.....
> xfslogd/7-219   [007] 358614.285381: sched_wakeup:         task xfsconvertd/7:251 [120] success=1 [007]

Ok, the transaction was blocked on a buffer that had it's IO
completion queued to the xfslogd. But this happened some
320ms after the above page fault occurred, and 340ms after the
xfsconvertd got stuck waiting for it. In other words, it looks
like it it took at least 340ms for the buffer IO to complete after
it was issued.


> xfsconvertd/7 releases the xfs_ilock() waking up flush-8:0:
....
> flush-8:0 releases the xfs_ilock() waking up my process:
....
> And finally my process finishes the write ending the delay:
> 
> 
>      <idle>-0     [013] 358614.285593: sched_switch:         task swapper:0 [120] (R) ==> file_writer:30495 [79]
> file_writer-30495 [013] 358614.285594: funcgraph_entry:        0.575 us   |                          __math_state_restore();
> file_writer-30495 [013] 358614.285595: funcgraph_entry:                   |                          finish_task_switch() {
> file_writer-30495 [013] 358614.285596: funcgraph_exit:         0.698 us   |                          }
> file_writer-30495 [013] 358614.285596: funcgraph_exit:    ! 316673.836 us |                        }
> file_writer-30495 [013] 358614.285596: funcgraph_exit:    ! 316675.180 us |                      }
> file_writer-30495 [013] 358614.285597: funcgraph_exit:    ! 316675.750 us |                    }
> file_writer-30495 [013] 358614.285597: funcgraph_entry:                   |                    xfs_bmapi() {

And so the delay you app saw was ~320ms. Basically, it blocked
waiting for an IO to complete. I don't think there is anything we ca
really do from a filesystem point of view to avoid that - we cannot
avoid metadata buffer writeback indefinitely.

Fundamentally you are seeing the reason why filesystems cannot
easily guarantee maximum bound latencies - if we have to wait for IO
for anything, then the latency is effectively uncontrollable. XFS
does as much as possible to avoid such latencies for data IO, but
even then it's not always possible. Even using the RT device in XFS
won't avoid these latencies - it's caused by latencies in metadata
modification, not data....

Effectively, the only way you can minimise this is to design your
storage layout for minimal IO latency under writes (e.g. use mirrors
instead of RAID5, etc) or use faster drives. Also using the deadline
scheduler (if you aren't already) might help....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
