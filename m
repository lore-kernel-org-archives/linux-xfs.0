Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FFPtkj195231 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 10:25:55 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F7E0134B8A6
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 08:38:33 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id qYB0zMeOXXnfrN8n
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 08:38:33 -0700 (PDT)
Received: by vws15 with SMTP id 15so198693vws.26
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 08:26:41 -0700 (PDT)
Date: Wed, 15 Sep 2010 10:26:33 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: Latencies writing to memory mapped files
Message-ID: <20100915152633.GA2585@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hello,

A little while ago I asked about ways to solve the occasional spikes in
latency that I see when writing to a shared memory mapped file.

http://oss.sgi.com/pipermail/xfs/2010-July/046311.html

With Dave's suggestions I enabled lazy-count=1 which did help a little:

# xfs_info /home/
meta-data=/dev/sda5              isize=256    agcount=32, agsize=8472969 blks
         =                       sectsz=512   attr=1
data     =                       bsize=4096   blocks=271135008, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

I'm also mounting the partition with "noatime,nobarrier,logbufs=8".

The other change I made which helped the most was to use fallocate()
to grow the file instead of lseek() and a write().  The latencies look
acceptable at lower data rates but once I reach 2-3 MB/s I start
seeing spikes when writeback occurs.  Perhaps my expectations are
unreasonable, but I would like to keep my latencies under 0.01s and
the lower the better.  I don't have hard real-time requirements, but
latencies are important.  These systems also only need to log data for
about 7-8 hours, so while I don't exactly know how much data I will
get I can make some guesses and preallocate the files or perform other
tricks if it would help.

Below are some snippets of a trace of a 0.3 second delay I captured
with ftrace on 2.6.32.21.  I haven't done enough sampling to know if
all of the delays happen for the same reason, or if there are multiple
code paths that lead to a large delay.

First I see xfsconvertd/7 acquire the xfs_ilock() then try to acquire
the xfs_buf_lock() and block:


xfsconvertd/7-251   [007] 358613.942101: funcgraph_entry:                   |  xfs_end_bio_unwritten() {
xfsconvertd/7-251   [007] 358613.942101: funcgraph_entry:                   |    xfs_iomap_write_unwritten() {
xfsconvertd/7-251   [007] 358613.942102: funcgraph_entry:                   |      _xfs_trans_alloc() {
xfsconvertd/7-251   [007] 358613.942104: funcgraph_exit:         2.582 us   |      }
xfsconvertd/7-251   [007] 358613.942104: funcgraph_entry:                   |      xfs_trans_reserve() {
xfsconvertd/7-251   [007] 358613.942546: funcgraph_exit:       ! 441.449 us |      }
xfsconvertd/7-251   [007] 358613.942546: funcgraph_entry:                   |      xfs_ilock() {
xfsconvertd/7-251   [007] 358613.942547: funcgraph_exit:         0.895 us   |      }
xfsconvertd/7-251   [007] 358613.942547: funcgraph_entry:                   |      xfs_trans_ijoin() {
xfsconvertd/7-251   [007] 358613.942548: funcgraph_exit:         0.667 us   |      }
xfsconvertd/7-251   [007] 358613.942548: funcgraph_entry:        0.138 us   |      xfs_trans_ihold();
xfsconvertd/7-251   [007] 358613.942549: funcgraph_entry:                   |      xfs_bmapi() {
xfsconvertd/7-251   [007] 358613.942549: funcgraph_entry:                   |        xfs_bmap_search_extents() {
xfsconvertd/7-251   [007] 358613.942564: funcgraph_exit:       + 14.764 us  |        }
xfsconvertd/7-251   [007] 358613.942565: funcgraph_entry:                   |        xfs_bmbt_init_cursor() {
xfsconvertd/7-251   [007] 358613.942567: funcgraph_exit:         2.740 us   |        }
xfsconvertd/7-251   [007] 358613.942568: funcgraph_entry:                   |        xfs_bmap_add_extent() {
xfsconvertd/7-251   [007] 358613.942568: funcgraph_entry:                   |          xfs_iext_get_ext() {
xfsconvertd/7-251   [007] 358613.942569: funcgraph_exit:         0.702 us   |          }
xfsconvertd/7-251   [007] 358613.942569: funcgraph_entry:        0.215 us   |          xfs_bmbt_get_all();
xfsconvertd/7-251   [007] 358613.942569: funcgraph_entry:                   |          xfs_bmap_add_extent_unwritten_real() {
xfsconvertd/7-251   [007] 358613.942570: funcgraph_entry:                   |            xfs_iext_get_ext() {
xfsconvertd/7-251   [007] 358613.942570: funcgraph_exit:         0.677 us   |            }
xfsconvertd/7-251   [007] 358613.942571: funcgraph_entry:        0.218 us   |            xfs_bmbt_get_all();
xfsconvertd/7-251   [007] 358613.942571: funcgraph_entry:                   |            xfs_iext_get_ext() {
xfsconvertd/7-251   [007] 358613.942572: funcgraph_exit:         0.844 us   |            }
xfsconvertd/7-251   [007] 358613.942572: funcgraph_entry:        0.216 us   |            xfs_bmbt_get_all();
xfsconvertd/7-251   [007] 358613.942573: funcgraph_entry:                   |            xfs_iext_get_ext() {
xfsconvertd/7-251   [007] 358613.942573: funcgraph_exit:         0.708 us   |            }
xfsconvertd/7-251   [007] 358613.942574: funcgraph_entry:        0.175 us   |            xfs_bmbt_get_all();
xfsconvertd/7-251   [007] 358613.942574: funcgraph_entry:                   |            xfs_iext_get_ext() {
xfsconvertd/7-251   [007] 358613.942575: funcgraph_exit:         1.079 us   |            }
xfsconvertd/7-251   [007] 358613.942575: funcgraph_entry:        0.220 us   |            xfs_bmbt_set_blockcount();
xfsconvertd/7-251   [007] 358613.942576: funcgraph_entry:        0.303 us   |            xfs_bmbt_set_startoff();
xfsconvertd/7-251   [007] 358613.942577: funcgraph_entry:        0.216 us   |            xfs_bmbt_set_startblock();
xfsconvertd/7-251   [007] 358613.942577: funcgraph_entry:        0.423 us   |            xfs_bmbt_set_blockcount();
xfsconvertd/7-251   [007] 358613.942578: funcgraph_entry:                   |            xfs_bmbt_lookup_eq() {
xfsconvertd/7-251   [007] 358613.942578: funcgraph_entry:                   |              xfs_btree_lookup() {
xfsconvertd/7-251   [007] 358613.942579: funcgraph_entry:        0.212 us   |                xfs_bmbt_init_ptr_from_cur();
xfsconvertd/7-251   [007] 358613.942579: funcgraph_entry:                   |                xfs_btree_lookup_get_block() {
xfsconvertd/7-251   [007] 358613.942721: funcgraph_exit:       ! 141.594 us |                }
xfsconvertd/7-251   [007] 358613.942721: funcgraph_entry:                   |                xfs_lookup_get_search_key() {
xfsconvertd/7-251   [007] 358613.942723: funcgraph_exit:         1.205 us   |                }
xfsconvertd/7-251   [007] 358613.942723: funcgraph_entry:        0.208 us   |                xfs_bmbt_key_diff();
xfsconvertd/7-251   [007] 358613.942723: funcgraph_entry:                   |                xfs_btree_ptr_addr() {
xfsconvertd/7-251   [007] 358613.942725: funcgraph_exit:         1.686 us   |                }
xfsconvertd/7-251   [007] 358613.942725: funcgraph_entry:                   |                xfs_btree_lookup_get_block() {
xfsconvertd/7-251   [007] 358613.942726: funcgraph_entry:                   |                  xfs_btree_read_buf_block() {
xfsconvertd/7-251   [007] 358613.942726: funcgraph_entry:        0.252 us   |                    xfs_btree_ptr_to_daddr();
xfsconvertd/7-251   [007] 358613.942726: funcgraph_entry:                   |                    xfs_trans_read_buf() {
xfsconvertd/7-251   [007] 358613.942727: funcgraph_entry:        0.330 us   |                      xfs_trans_buf_item_match();
xfsconvertd/7-251   [007] 358613.942728: funcgraph_entry:                   |                      xfs_buf_read_flags() {
xfsconvertd/7-251   [007] 358613.942728: funcgraph_entry:                   |                        xfs_buf_get_flags() {
xfsconvertd/7-251   [007] 358613.942728: funcgraph_entry:                   |                          kmem_zone_alloc() {
xfsconvertd/7-251   [007] 358613.942885: funcgraph_exit:       ! 156.328 us |                          }
xfsconvertd/7-251   [007] 358613.942885: funcgraph_entry:                   |                          _xfs_buf_find() {
xfsconvertd/7-251   [007] 358613.942885: funcgraph_entry:        0.150 us   |                            _spin_lock();
xfsconvertd/7-251   [007] 358613.942885: funcgraph_entry:                   |                            down_trylock() {
xfsconvertd/7-251   [007] 358613.942886: funcgraph_exit:         0.818 us   |                            }
xfsconvertd/7-251   [007] 358613.942886: funcgraph_entry:                   |                            xfs_buf_lock() {
xfsconvertd/7-251   [007] 358613.942886: funcgraph_entry:                   |                              down() {
xfsconvertd/7-251   [007] 358613.942887: funcgraph_entry:        0.137 us   |                                _spin_lock_irqsave();
xfsconvertd/7-251   [007] 358613.942887: funcgraph_entry:                   |                                __down() {
xfsconvertd/7-251   [007] 358613.942887: funcgraph_entry:                   |                                  schedule_timeout() {
xfsconvertd/7-251   [007] 358613.942887: funcgraph_entry:                   |                                    schedule() {
xfsconvertd/7-251   [007] 358613.942888: funcgraph_entry:        0.136 us   |                                      rcu_sched_qs();
xfsconvertd/7-251   [007] 358613.942888: funcgraph_entry:        0.137 us   |                                      _spin_lock_irq();
xfsconvertd/7-251   [007] 358613.942888: funcgraph_entry:                   |                                      deactivate_task() {
xfsconvertd/7-251   [007] 358613.942891: funcgraph_exit:         3.263 us   |                                      }
xfsconvertd/7-251   [007] 358613.942892: funcgraph_entry:        0.140 us   |                                      put_prev_task_fair();
xfsconvertd/7-251   [007] 358613.942892: funcgraph_entry:        0.159 us   |                                      pick_next_task_fair();
xfsconvertd/7-251   [007] 358613.942892: funcgraph_entry:        0.139 us   |                                      pick_next_task_rt();
xfsconvertd/7-251   [007] 358613.942893: funcgraph_entry:        0.151 us   |                                      pick_next_task_fair();
xfsconvertd/7-251   [007] 358613.942893: funcgraph_entry:        0.249 us   |                                      pick_next_task_idle();
xfsconvertd/7-251   [007] 358613.942893: funcgraph_entry:        0.142 us   |                                      perf_event_task_sched_out();
xfsconvertd/7-251   [007] 358613.942894: funcgraph_entry:                   |                                      ftrace_raw_event_sched_switch() {
xfsconvertd/7-251   [007] 358613.942894: sched_switch:         task xfsconvertd/7:251 [120] (D) ==> swapper:0 [120]


Next the flush-8:0 thread tries to aquire the xfs_ilock() and blocks:


flush-8:0-505   [011] 358613.964686: funcgraph_entry:                   |              __writepage() {
flush-8:0-505   [011] 358613.964687: funcgraph_entry:                   |                xfs_vm_writepage() {
flush-8:0-505   [011] 358613.964687: funcgraph_entry:        0.467 us   |                  xfs_count_page_state();
flush-8:0-505   [011] 358613.964688: funcgraph_entry:                   |                  xfs_page_state_convert() {
flush-8:0-505   [011] 358613.964688: funcgraph_entry:                   |                    xfs_probe_cluster() {
flush-8:0-505   [011] 358613.964694: funcgraph_exit:         6.002 us   |                    }
flush-8:0-505   [011] 358613.964694: funcgraph_entry:                   |                    xfs_map_blocks() {
flush-8:0-505   [011] 358613.964695: funcgraph_entry:                   |                      xfs_iomap() {
flush-8:0-505   [011] 358613.964695: funcgraph_entry:                   |                        xfs_ilock_map_shared() {
flush-8:0-505   [011] 358613.964695: funcgraph_entry:                   |                          xfs_ilock() {
flush-8:0-505   [011] 358613.964695: funcgraph_entry:                   |                            down_read() {
flush-8:0-505   [011] 358613.964695: funcgraph_entry:        0.139 us   |                              _cond_resched();
flush-8:0-505   [011] 358613.964696: funcgraph_entry:        0.136 us   |                              _spin_lock_irq();
flush-8:0-505   [011] 358613.964696: funcgraph_entry:                   |                              schedule() {
flush-8:0-505   [011] 358613.964696: funcgraph_entry:        0.136 us   |                                rcu_sched_qs();
flush-8:0-505   [011] 358613.964697: funcgraph_entry:        0.202 us   |                                _spin_lock_irq();
flush-8:0-505   [011] 358613.964697: funcgraph_entry:                   |                                deactivate_task() {
flush-8:0-505   [011] 358613.964700: funcgraph_exit:         2.713 us   |                                }
flush-8:0-505   [011] 358613.964700: funcgraph_entry:        0.140 us   |                                update_shares_locked();
flush-8:0-505   [011] 358613.964700: funcgraph_entry:                   |                                find_busiest_group() {
flush-8:0-505   [011] 358613.964702: funcgraph_exit:         1.571 us   |                                }
flush-8:0-505   [011] 358613.964702: funcgraph_entry:        0.136 us   |                                msecs_to_jiffies();
flush-8:0-505   [011] 358613.964702: funcgraph_entry:        0.138 us   |                                update_shares_locked();
flush-8:0-505   [011] 358613.964703: funcgraph_entry:                   |                                find_busiest_group() {
flush-8:0-505   [011] 358613.964704: funcgraph_exit:         0.948 us   |                                }
flush-8:0-505   [011] 358613.964704: funcgraph_entry:        0.347 us   |                                find_busiest_queue();
flush-8:0-505   [011] 358613.964704: funcgraph_entry:        0.139 us   |                                msecs_to_jiffies();
flush-8:0-505   [011] 358613.964705: funcgraph_entry:        0.152 us   |                                put_prev_task_fair();
flush-8:0-505   [011] 358613.964705: funcgraph_entry:        0.163 us   |                                pick_next_task_fair();
flush-8:0-505   [011] 358613.964705: funcgraph_entry:        0.139 us   |                                pick_next_task_rt();
flush-8:0-505   [011] 358613.964705: funcgraph_entry:        0.142 us   |                                pick_next_task_fair();
flush-8:0-505   [011] 358613.964706: funcgraph_entry:        0.144 us   |                                pick_next_task_idle();
flush-8:0-505   [011] 358613.964706: funcgraph_entry:        0.159 us   |                                perf_event_task_sched_out();
flush-8:0-505   [011] 358613.964707: funcgraph_entry:                   |                                ftrace_raw_event_sched_switch() {
flush-8:0-505   [011] 358613.964707: sched_switch:         task flush-8:0:505 [120] (D) ==> swapper:0 [120]


Then my process writes to the file generates a page fault which tries
to acquire the xfs_ilock() and blocks:


file_writer-30495 [013] 358613.968909: print:                00000000 delay start
file_writer-30495 [013] 358613.968913: funcgraph_entry:        0.151 us   |  down_read_trylock();
file_writer-30495 [013] 358613.968913: funcgraph_entry:        0.152 us   |  _cond_resched();
file_writer-30495 [013] 358613.968913: funcgraph_entry:        0.520 us   |  find_vma();
file_writer-30495 [013] 358613.968914: funcgraph_entry:                   |  handle_mm_fault() {
file_writer-30495 [013] 358613.968914: funcgraph_entry:                   |    __do_fault() {
file_writer-30495 [013] 358613.968914: funcgraph_entry:                   |      filemap_fault() {
file_writer-30495 [013] 358613.968915: funcgraph_exit:         1.171 us   |      }
file_writer-30495 [013] 358613.968916: funcgraph_entry:                   |      unlock_page() {
file_writer-30495 [013] 358613.968916: funcgraph_exit:         0.814 us   |      }
file_writer-30495 [013] 358613.968917: funcgraph_entry:                   |      xfs_vm_page_mkwrite() {
file_writer-30495 [013] 358613.968917: funcgraph_entry:                   |        block_page_mkwrite() {
file_writer-30495 [013] 358613.968917: funcgraph_entry:        0.137 us   |          _cond_resched();
file_writer-30495 [013] 358613.968917: funcgraph_entry:                   |          block_prepare_write() {
file_writer-30495 [013] 358613.968917: funcgraph_entry:                   |            __block_prepare_write() {
file_writer-30495 [013] 358613.968918: funcgraph_entry:                   |              create_empty_buffers() {
file_writer-30495 [013] 358613.968920: funcgraph_exit:         2.760 us   |              }
file_writer-30495 [013] 358613.968921: funcgraph_entry:                   |              xfs_get_blocks() {
file_writer-30495 [013] 358613.968921: funcgraph_entry:                   |                __xfs_get_blocks() {
file_writer-30495 [013] 358613.968921: funcgraph_entry:                   |                  xfs_iomap() {
file_writer-30495 [013] 358613.968921: funcgraph_entry:                   |                    xfs_ilock() {
file_writer-30495 [013] 358613.968921: funcgraph_entry:                   |                      down_write() {
file_writer-30495 [013] 358613.968921: funcgraph_entry:        0.139 us   |                        _cond_resched();
file_writer-30495 [013] 358613.968922: funcgraph_entry:        0.155 us   |                        _spin_lock_irq();
file_writer-30495 [013] 358613.968922: funcgraph_entry:                   |                        schedule() {
file_writer-30495 [013] 358613.968922: funcgraph_entry:        0.141 us   |                          rcu_sched_qs();
file_writer-30495 [013] 358613.968923: funcgraph_entry:        0.213 us   |                          _spin_lock_irq();
file_writer-30495 [013] 358613.968923: funcgraph_entry:                   |                          deactivate_task() {
file_writer-30495 [013] 358613.968929: funcgraph_exit:         6.462 us   |                          }
file_writer-30495 [013] 358613.968930: funcgraph_entry:                   |                          pre_schedule_rt() {
file_writer-30495 [013] 358613.968930: funcgraph_exit:         0.445 us   |                          }
file_writer-30495 [013] 358613.968930: funcgraph_entry:        0.139 us   |                          update_shares_locked();
file_writer-30495 [013] 358613.968931: funcgraph_entry:                   |                          find_busiest_group() {
file_writer-30495 [013] 358613.968932: funcgraph_exit:         1.358 us   |                          }
file_writer-30495 [013] 358613.968932: funcgraph_entry:        0.140 us   |                          msecs_to_jiffies();
file_writer-30495 [013] 358613.968932: funcgraph_entry:        0.140 us   |                          update_shares_locked();
file_writer-30495 [013] 358613.968933: funcgraph_entry:        0.491 us   |                          find_busiest_group();
file_writer-30495 [013] 358613.968933: funcgraph_entry:        0.137 us   |                          msecs_to_jiffies();
file_writer-30495 [013] 358613.968934: funcgraph_entry:        0.137 us   |                          update_shares_locked();
file_writer-30495 [013] 358613.968934: funcgraph_entry:        0.677 us   |                          find_busiest_group();
file_writer-30495 [013] 358613.968935: funcgraph_entry:        0.528 us   |                          find_busiest_queue();
file_writer-30495 [013] 358613.968936: funcgraph_entry:        0.137 us   |                          msecs_to_jiffies();
file_writer-30495 [013] 358613.968936: funcgraph_entry:                   |                          put_prev_task_rt() {
file_writer-30495 [013] 358613.968937: funcgraph_exit:         1.309 us   |                          }
file_writer-30495 [013] 358613.968937: funcgraph_entry:        0.168 us   |                          pick_next_task_fair();
file_writer-30495 [013] 358613.968938: funcgraph_entry:        0.137 us   |                          pick_next_task_rt();
file_writer-30495 [013] 358613.968938: funcgraph_entry:        0.226 us   |                          pick_next_task_fair();
file_writer-30495 [013] 358613.968938: funcgraph_entry:        0.208 us   |                          pick_next_task_idle();
file_writer-30495 [013] 358613.968939: funcgraph_entry:        0.237 us   |                          perf_event_task_sched_out();
file_writer-30495 [013] 358613.968939: funcgraph_entry:                   |                          ftrace_raw_event_sched_switch() {
file_writer-30495 [013] 358613.968940: sched_switch:         task file_writer:30495 [79] (D) ==> swapper:0 [120]


Next I see xfslogd/7 release the xfs_buf_lock which wakes up
xfsconvertd/7:


file_reader-31161 [007] 358614.285351: sched_switch:         task file_reader:31161 [89] (S) ==> xfslogd/7:219 [120]
xfslogd/7-219   [007] 358614.285352: funcgraph_entry:                   |    finish_task_switch() {
xfslogd/7-219   [007] 358614.285353: funcgraph_exit:         1.327 us   |    }
xfslogd/7-219   [007] 358614.285353: funcgraph_exit:       ! 385801.165 us |  }
xfslogd/7-219   [007] 358614.285354: funcgraph_entry:        0.403 us   |  finish_wait();
xfslogd/7-219   [007] 358614.285355: funcgraph_entry:        0.518 us   |  kthread_should_stop();
xfslogd/7-219   [007] 358614.285355: funcgraph_entry:        0.336 us   |  _spin_lock_irq();
xfslogd/7-219   [007] 358614.285356: funcgraph_entry:        0.362 us   |  _spin_lock_irqsave();
xfslogd/7-219   [007] 358614.285357: funcgraph_entry:        0.331 us   |  _spin_unlock_irqrestore();
xfslogd/7-219   [007] 358614.285358: funcgraph_entry:                   |  xfs_buf_iodone_work() {
xfslogd/7-219   [007] 358614.285358: funcgraph_entry:                   |    xfs_buf_iodone_callbacks() {
xfslogd/7-219   [007] 358614.285359: funcgraph_entry:                   |      xfs_buf_do_callbacks() {
xfslogd/7-219   [007] 358614.285367: funcgraph_exit:         7.849 us   |      }
xfslogd/7-219   [007] 358614.285367: funcgraph_entry:                   |      xfs_buf_ioend() {
xfslogd/7-219   [007] 358614.285367: funcgraph_entry:                   |        xfs_buf_iodone_work() {
xfslogd/7-219   [007] 358614.285367: funcgraph_entry:                   |          xfs_buf_unlock() {
xfslogd/7-219   [007] 358614.285368: funcgraph_entry:                   |            up() {
xfslogd/7-219   [007] 358614.285368: funcgraph_entry:        0.229 us   |              _spin_lock_irqsave();
xfslogd/7-219   [007] 358614.285369: funcgraph_entry:                   |              __up() {
xfslogd/7-219   [007] 358614.285369: funcgraph_entry:                   |                wake_up_process() {
xfslogd/7-219   [007] 358614.285370: funcgraph_entry:                   |                  try_to_wake_up() {
xfslogd/7-219   [007] 358614.285370: funcgraph_entry:                   |                    task_rq_lock() {
xfslogd/7-219   [007] 358614.285371: funcgraph_exit:         1.087 us   |                    }
xfslogd/7-219   [007] 358614.285372: funcgraph_entry:        0.308 us   |                    _spin_unlock_irqrestore();
xfslogd/7-219   [007] 358614.285372: funcgraph_entry:                   |                    select_task_rq_fair() {
xfslogd/7-219   [007] 358614.285375: funcgraph_exit:         2.519 us   |                    }
xfslogd/7-219   [007] 358614.285375: funcgraph_entry:                   |                    task_rq_lock() {
xfslogd/7-219   [007] 358614.285376: funcgraph_exit:         0.697 us   |                    }
xfslogd/7-219   [007] 358614.285376: funcgraph_entry:                   |                    activate_task() {
xfslogd/7-219   [007] 358614.285380: funcgraph_exit:         4.485 us   |                    }
xfslogd/7-219   [007] 358614.285381: funcgraph_entry:                   |                    ftrace_raw_event_sched_wakeup() {
xfslogd/7-219   [007] 358614.285381: sched_wakeup:         task xfsconvertd/7:251 [120] success=1 [007]


xfsconvertd/7 releases the xfs_ilock() waking up flush-8:0:


xfsconvertd/7-251   [007] 358614.285468: funcgraph_entry:        0.171 us   |      xfs_bmap_finish();
xfsconvertd/7-251   [007] 358614.285468: funcgraph_entry:                   |      _xfs_trans_commit() {
xfsconvertd/7-251   [007] 358614.285551: funcgraph_exit:       + 82.436 us  |      }
xfsconvertd/7-251   [007] 358614.285551: funcgraph_entry:                   |      xfs_iunlock() {
xfsconvertd/7-251   [007] 358614.285551: funcgraph_entry:                   |        up_write() {
xfsconvertd/7-251   [007] 358614.285551: funcgraph_entry:        0.137 us   |          _spin_lock_irqsave();
xfsconvertd/7-251   [007] 358614.285552: funcgraph_entry:                   |          wake_up_process() {
xfsconvertd/7-251   [007] 358614.285552: funcgraph_entry:                   |            try_to_wake_up() {
xfsconvertd/7-251   [007] 358614.285552: funcgraph_entry:                   |              task_rq_lock() {
xfsconvertd/7-251   [007] 358614.285553: funcgraph_exit:         0.690 us   |              }
xfsconvertd/7-251   [007] 358614.285553: funcgraph_entry:        0.141 us   |              _spin_unlock_irqrestore();
xfsconvertd/7-251   [007] 358614.285553: funcgraph_entry:                   |              select_task_rq_fair() {
xfsconvertd/7-251   [007] 358614.285555: funcgraph_exit:         1.358 us   |              }
xfsconvertd/7-251   [007] 358614.285555: funcgraph_entry:                   |              task_rq_lock() {
xfsconvertd/7-251   [007] 358614.285555: funcgraph_exit:         0.418 us   |              }
xfsconvertd/7-251   [007] 358614.285556: funcgraph_entry:                   |              activate_task() {
xfsconvertd/7-251   [007] 358614.285558: funcgraph_exit:         2.524 us   |              }
xfsconvertd/7-251   [007] 358614.285558: funcgraph_entry:                   |              ftrace_raw_event_sched_wakeup() {
xfsconvertd/7-251   [007] 358614.285558: sched_wakeup:         task flush-8:0:505 [120] success=1 [011]


flush-8:0 releases the xfs_ilock() waking up my process:


flush-8:0-505   [011] 358613.584354: funcgraph_entry:                   |              clear_page_dirty_for_io() {
flush-8:0-505   [011] 358613.584361: funcgraph_exit:         7.365 us   |              }
flush-8:0-505   [011] 358613.584362: funcgraph_entry:                   |              __writepage() {
flush-8:0-505   [011] 358613.584362: funcgraph_entry:                   |                xfs_vm_writepage() {
flush-8:0-505   [011] 358613.584362: funcgraph_entry:        0.144 us   |                  xfs_count_page_state();
flush-8:0-505   [011] 358613.584362: funcgraph_entry:                   |                  xfs_page_state_convert() {
flush-8:0-505   [011] 358613.584362: funcgraph_entry:                   |                    xfs_probe_cluster() {
flush-8:0-505   [011] 358613.584367: funcgraph_exit:         4.710 us   |                    }
flush-8:0-505   [011] 358613.584367: funcgraph_entry:                   |                    xfs_map_blocks() {
flush-8:0-505   [011] 358613.584367: funcgraph_entry:                   |                      xfs_iomap() {
flush-8:0-505   [011] 358613.584367: funcgraph_entry:                   |                        xfs_ilock_map_shared() {
flush-8:0-505   [011] 358613.584368: funcgraph_exit:         0.973 us   |                        }
flush-8:0-505   [011] 358613.584369: funcgraph_entry:                   |                        xfs_bmapi() {
flush-8:0-505   [011] 358613.584379: funcgraph_exit:       + 10.524 us  |                        }
flush-8:0-505   [011] 358613.584379: funcgraph_entry:        0.149 us   |                        xfs_imap_to_bmap();
flush-8:0-505   [011] 358613.584380: funcgraph_entry:                   |                        xfs_iunlock() {
flush-8:0-505   [011] 358613.584380: funcgraph_entry:                   |                          up_read() {
flush-8:0-505   [011] 358613.584380: funcgraph_entry:        0.138 us   |                            _spin_lock_irqsave();
flush-8:0-505   [011] 358613.584380: funcgraph_entry:                   |                            wake_up_process() {
flush-8:0-505   [011] 358613.584380: funcgraph_entry:                   |                              try_to_wake_up() {
flush-8:0-505   [011] 358613.584381: funcgraph_entry:                   |                                task_rq_lock() {
flush-8:0-505   [011] 358613.584394: funcgraph_exit:       + 13.023 us  |                                }
flush-8:0-505   [011] 358613.584394: funcgraph_entry:        0.143 us   |                                _spin_unlock_irqrestore();
flush-8:0-505   [011] 358613.584394: funcgraph_entry:        0.157 us   |                                select_task_rq_rt();
flush-8:0-505   [011] 358613.584394: funcgraph_entry:                   |                                task_rq_lock() {
flush-8:0-505   [011] 358613.584395: funcgraph_exit:         0.412 us   |                                }
flush-8:0-505   [011] 358613.584395: funcgraph_entry:                   |                                activate_task() {
flush-8:0-505   [011] 358613.584400: funcgraph_exit:         4.642 us   |                                }
flush-8:0-505   [011] 358613.584400: funcgraph_entry:                   |                                ftrace_raw_event_sched_wakeup() {
flush-8:0-505   [011] 358613.584401: sched_wakeup:         task file_writer:30495 [79] success=1 [015]


And finally my process finishes the write ending the delay:


     <idle>-0     [013] 358614.285593: sched_switch:         task swapper:0 [120] (R) ==> file_writer:30495 [79]
file_writer-30495 [013] 358614.285594: funcgraph_entry:        0.575 us   |                          __math_state_restore();
file_writer-30495 [013] 358614.285595: funcgraph_entry:                   |                          finish_task_switch() {
file_writer-30495 [013] 358614.285596: funcgraph_exit:         0.698 us   |                          }
file_writer-30495 [013] 358614.285596: funcgraph_exit:    ! 316673.836 us |                        }
file_writer-30495 [013] 358614.285596: funcgraph_exit:    ! 316675.180 us |                      }
file_writer-30495 [013] 358614.285597: funcgraph_exit:    ! 316675.750 us |                    }
file_writer-30495 [013] 358614.285597: funcgraph_entry:                   |                    xfs_bmapi() {
file_writer-30495 [013] 358614.285607: funcgraph_exit:       + 10.271 us  |                    }
file_writer-30495 [013] 358614.285608: funcgraph_entry:        0.159 us   |                    xfs_imap_to_bmap();
file_writer-30495 [013] 358614.285608: funcgraph_entry:                   |                    xfs_iunlock() {
file_writer-30495 [013] 358614.285609: funcgraph_exit:         1.155 us   |                    }
file_writer-30495 [013] 358614.285609: funcgraph_exit:    ! 316688.329 us |                  }
file_writer-30495 [013] 358614.285610: funcgraph_entry:        0.283 us   |                  xfs_map_buffer();
file_writer-30495 [013] 358614.285610: funcgraph_exit:    ! 316689.328 us |                }
file_writer-30495 [013] 358614.285610: funcgraph_exit:    ! 316689.619 us |              }
file_writer-30495 [013] 358614.285611: funcgraph_entry:                   |              unmap_underlying_metadata() {
file_writer-30495 [013] 358614.285612: funcgraph_exit:         1.429 us   |              }
file_writer-30495 [013] 358614.285612: funcgraph_entry:                   |              mark_buffer_dirty() {
file_writer-30495 [013] 358614.285616: funcgraph_exit:         3.770 us   |              }
file_writer-30495 [013] 358614.285617: funcgraph_exit:    ! 316699.234 us |            }
file_writer-30495 [013] 358614.285617: funcgraph_exit:    ! 316699.649 us |          }
file_writer-30495 [013] 358614.285617: funcgraph_entry:                   |          block_commit_write() {
file_writer-30495 [013] 358614.285618: funcgraph_exit:         0.822 us   |          }
file_writer-30495 [013] 358614.285618: funcgraph_exit:    ! 316701.509 us |        }
file_writer-30495 [013] 358614.285619: funcgraph_exit:    ! 316701.950 us |      }
file_writer-30495 [013] 358614.285619: funcgraph_entry:        0.228 us   |      _spin_lock();
file_writer-30495 [013] 358614.285620: funcgraph_entry:                   |      page_add_file_rmap() {
file_writer-30495 [013] 358614.285621: funcgraph_exit:         1.957 us   |      }
file_writer-30495 [013] 358614.285622: funcgraph_entry:                   |      set_page_dirty() {
file_writer-30495 [013] 358614.285623: funcgraph_exit:         0.919 us   |      }
file_writer-30495 [013] 358614.285623: funcgraph_entry:                   |      unlock_page() {
file_writer-30495 [013] 358614.285624: funcgraph_exit:         0.858 us   |      }
file_writer-30495 [013] 358614.285624: funcgraph_entry:        0.151 us   |      put_page();
file_writer-30495 [013] 358614.285624: funcgraph_entry:        0.197 us   |      balance_dirty_pages_ratelimited_nr();
file_writer-30495 [013] 358614.285625: funcgraph_entry:                   |      file_update_time() {
file_writer-30495 [013] 358614.285628: funcgraph_exit:         3.053 us   |      }
file_writer-30495 [013] 358614.285628: funcgraph_exit:    ! 316713.745 us |    }
file_writer-30495 [013] 358614.285628: funcgraph_exit:    ! 316714.374 us |  }
file_writer-30495 [013] 358614.285628: funcgraph_entry:        0.174 us   |  up_read();
file_writer-30495 [013] 358614.285635: print:                00000000 delay stop


Any suggestions on how to improve things are welcome.

Thanks,
Shawn

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
