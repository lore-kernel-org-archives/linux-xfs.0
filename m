Return-Path: <SRS0=R26v=BK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4701C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 15:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 972112245C
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 15:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HTRc6CD+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387556AbgGaPtK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 11:49:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47084 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgGaPtJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Jul 2020 11:49:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06VFgwu2035954;
        Fri, 31 Jul 2020 15:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=On+BzGeOR2yMW4zvGzCC2uWxwMvejHiClbYpyQUHATw=;
 b=HTRc6CD+3yYw74qW/Ox7AsDMYk0RaB4bn4KsBd93eNfre/xCTkdLQuG8WVaWigShg0zJ
 Ot3dRuSNTejvwdq+VFBlpoT5f3z2dVygv4OCcZVMDGEIvmKD7V+Pabd0ZAU23O6QHDOj
 4NKlHV8t9bpDgRZsEzkusbYyIy9Q27lomnv+NXnepHQ0FodmpSYpUFL7WIk5aUUWGIX9
 UiL7g/ywzqalk/pUPZL3uEUYOhMYWrlW4MKMI2mGXXAMeUA1lJl6bKACgvkzQwK8bQvh
 ewjkP0W0RLpx/Q7V1vk2F0qgaVy0LbkHMZx0W5NrwfFdiHtbRXutnDhA2nssCTam8WLt Mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32hu1jsrqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jul 2020 15:48:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06VFmjKl090358;
        Fri, 31 Jul 2020 15:48:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32mf70nyvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 15:48:49 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06VFmjCa028599;
        Fri, 31 Jul 2020 15:48:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 31 Jul 2020 08:48:45 -0700
Date:   Fri, 31 Jul 2020 08:48:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Donald Buczek <buczek@molgen.mpg.de>
Cc:     linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfs_reclaim_inodes_ag taking several seconds
Message-ID: <20200731154844.GC67827@magnolia>
References: <8284912e-b99a-31af-1901-a38ea03b8648@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8284912e-b99a-31af-1901-a38ea03b8648@molgen.mpg.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9699 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007310117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9699 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007310116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 31, 2020 at 01:27:31PM +0200, Donald Buczek wrote:
> Dear Linux people,
> 
> we have a backup server with two xfs filesystems on 101.9TB md-raid6 devices (16 * 7.3 T disks) each, Current Linux version is 5.4.54.
> 
> The server is doing lot of metadata i/o to these filesystems (two rsync of complete client filesystems with --link-dest to the previous backup, so lots of hard links, and two `rm -rf` of directory trees expiring old backups). Lots and lots of inodes on the filesystem and in the cache.
> 
> While these backup tasks seem to perform okay, often the system seems to be stalled for minutes, e.g. when a mount is required.
> 
> I figured out, that xfs_reclaim_inodes_ag can take several tens of seconds. These add up to minutes while the system is running the shrinkers. Other processes (e.g. those which require mounts) block on shrinker_rwsem when they try to register/deregister their shrinkers.
> 
> Is this expected behavior? Any ideas?

On any kernel through 5.8?  Yes.

5.9 will have this patchset[1] that changes xfs to throttle frontend
processes that are trying to modify inodes instead of using dirty inode
writeback to throtte memory reclaim.

I'd be curious to see how the new code handles everyone else's
workloads, but we haven't even finished 5.8 yet so it's still early
days...

--D

[1] https://lore.kernel.org/linux-xfs/20200622081605.1818434-1-david@fromorbit.com/

> 
> Best
>   Donald
> 
> Some data:
> 
> root:done:~/# ps -f -p 20379
> UID        PID  PPID  C STIME TTY          TIME CMD
> root     20379 20378  0 11:42 ?        00:00:00 /sbin/mount.nfs handsomejack:/amd/handsomejack/2/home/abt_srv/klages /home/klages -s -o rw,nosuid
> root:done:~/# cat /proc/20379/stack
> [<0>] rwsem_down_write_slowpath+0x21b/0x470
> [<0>] unregister_memcg_shrinker.isra.55+0x18/0x40
> [<0>] unregister_shrinker+0x6e/0x80
> [<0>] deactivate_locked_super+0x2e/0x70
> [<0>] cleanup_mnt+0xb8/0x150
> [<0>] task_work_run+0x7e/0xa0
> [<0>] exit_to_usermode_loop+0xbf/0xd0
> [<0>] do_syscall_64+0xfe/0x130
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> 
> # echo "vmscan:*" > /sys/kernel/debug/tracing/set_event
> # cat /sys/kernel/debug/tracing/trace > trace.001
> # grep kswapd1-137 trace.001
> # # only lines with noteable time gaps ( > 1sec) pasted here :
> 
> kswapd1-137   [011] .... 66671.873532: mm_vmscan_kswapd_wake: nid=1 order=3
> kswapd1-137   [011] .... 66671.878236: mm_shrink_slab_start: super_cache_scan+0x0/0x1a0 000000003e89d20a: nid: 1 objects to shrink 824 gfp_flags GFP_KERNEL cache items 1065515 delta 520 total_scan 1344 priority 12
> 
> kswapd1-137   [007] .... 66707.247798: mm_shrink_slab_end: super_cache_scan+0x0/0x1a0 000000003e89d20a: nid: 1 unused scan count 824 new scan count 320 total_scan 320 last shrinker return val 1021
> kswapd1-137   [007] .... 66707.255750: mm_shrink_slab_start: super_cache_scan+0x0/0x1a0 000000003e89d20a: nid: 1 objects to shrink 726 gfp_flags GFP_KERNEL cache items 1064232 delta 1038 total_scan 1764 priority 11
> 
> kswapd1-137   [003] .... 66712.718536: mm_shrink_slab_end: super_cache_scan+0x0/0x1a0 000000003e89d20a: nid: 1 unused scan count 726 new scan count 740 total_scan 740 last shrinker return val 1022
> kswapd1-137   [001] .... 66712.984923: mm_vmscan_kswapd_sleep: nid=1
> 
> # true > /sys/kernel/debug/tracing/set_event
> # true > /sys/kernel/debug/tracing/trace
> # echo super_cache_scan > /sys/kernel/debug/tracing/set_graph_function
> # echo function_graph > /sys/kernel/debug/tracing/current_tracer
> # cat /sys/kernel/debug/tracing/trace > trace.002
> # fgrep \$ trace.002 | tail -20
> 
>  13) $ 1918769 us  |          }
>   9) $ 1952622 us  |          }
>   8) $ 2503877 us  |        } /* xfs_reclaim_inodes_ag */
>   8) $ 2503888 us  |      } /* xfs_reclaim_inodes_nr */
>   8) $ 2503889 us  |    } /* xfs_fs_free_cached_objects */
>   8) $ 2503939 us  |  } /* super_cache_scan */
>   5) $ 2119727 us  |                            }
>   5) $ 2119727 us  |                          }
>   5) $ 2119729 us  |                        }
>   5) $ 2119732 us  |                      }
>   5) $ 2119732 us  |                    }
>   5) $ 2119744 us  |                  }
>   5) $ 2178135 us  |                }
>   5) $ 2228517 us  |              }
>   5) $ 2228518 us  |            }
>   5) $ 2229533 us  |          }
>  14) $ 18086849 us |        } /* xfs_reclaim_inodes_ag */
>  14) $ 18086858 us |      } /* xfs_reclaim_inodes_nr */
>  14) $ 18086858 us |    } /* xfs_fs_free_cached_objects */
>  14) $ 18086907 us |  } /* super_cache_scan */
> 
> root:done:/home/buczek/linux_problems/shrinker_semaphore/# cat /proc/meminfo
> MemTotal:       263572332 kB
> MemFree:         2872368 kB
> MemAvailable:   204193824 kB
> Buffers:            2568 kB
> Cached:         164931356 kB
> SwapCached:            0 kB
> Active:         50608440 kB
> Inactive:       114468364 kB
> Active(anon):     143724 kB
> Inactive(anon):     1484 kB
> Active(file):   50464716 kB
> Inactive(file): 114466880 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:             0 kB
> SwapFree:              0 kB
> Dirty:            685232 kB
> Writeback:             0 kB
> AnonPages:        140452 kB
> Mapped:            36220 kB
> Shmem:              1956 kB
> KReclaimable:   40079660 kB
> Slab:           49988268 kB
> SReclaimable:   40079660 kB
> SUnreclaim:      9908608 kB
> KernelStack:        6368 kB
> PageTables:         4912 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    263572332 kB
> Committed_AS:     507052 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:      228600 kB
> VmallocChunk:          0 kB
> Percpu:            40512 kB
> AnonHugePages:     32768 kB
> ShmemHugePages:        0 kB
> ShmemPmdMapped:        0 kB
> FileHugePages:         0 kB
> FilePmdMapped:         0 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> Hugetlb:               0 kB
> DirectMap4k:      578220 kB
> DirectMap2M:    83974144 kB
> DirectMap1G:    185597952 kB
> 
> root:done:/home/buczek/linux_problems/shrinker_semaphore/# cat /proc/slabinfo
> slabinfo - version: 2.1
> # name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
> nfs_direct_cache       0      0    224   18    1 : tunables  120   60    8 : slabdata      0      0      0
> nfs_read_data         32     32    896    4    1 : tunables   54   27    8 : slabdata      8      8      0
> nfs_inode_cache     1846   1893   1064    3    1 : tunables   24   12    8 : slabdata    631    631      0
> ext4_groupinfo_4k   7453   7476    144   28    1 : tunables  120   60    8 : slabdata    267    267      0
> ext4_inode_cache       4      6   1072    3    1 : tunables   24   12    8 : slabdata      2      2      0
> ext4_allocation_context      0      0    128   32    1 : tunables  120   60    8 : slabdata      0      0      0
> ext4_io_end            0      0     64   64    1 : tunables  120   60    8 : slabdata      0      0      0
> ext4_extent_status      2     99     40   99    1 : tunables  120   60    8 : slabdata      1      1      0
> mbcache                0      0     56   71    1 : tunables  120   60    8 : slabdata      0      0      0
> jbd2_journal_handle      0      0     48   83    1 : tunables  120   60    8 : slabdata      0      0      0
> jbd2_journal_head      0      0    112   36    1 : tunables  120   60    8 : slabdata      0      0      0
> jbd2_revoke_table_s      2    240     16  240    1 : tunables  120   60    8 : slabdata      1      1      0
> jbd2_revoke_record_s      0      0     32  124    1 : tunables  120   60    8 : slabdata      0      0      0
> raid6-md0          15982  15982   5984    1    2 : tunables    8    4    0 : slabdata  15982  15982      0
> kvm_vcpu               0      0  16192    1    4 : tunables    8    4    0 : slabdata      0      0      0
> kvm_mmu_page_header      0      0    168   24    1 : tunables  120   60    8 : slabdata      0      0      0
> x86_fpu                0      0   4160    1    2 : tunables    8    4    0 : slabdata      0      0      0
> nfsd4_odstate        486    495     40   99    1 : tunables  120   60    8 : slabdata      5      5      0
> nfsd4_stateids         0      0    168   24    1 : tunables  120   60    8 : slabdata      0      0      0
> nfsd4_files            0      0    264   15    1 : tunables   54   27    8 : slabdata      0      0      0
> nfsd4_lockowners       0      0    392   10    1 : tunables   54   27    8 : slabdata      0      0      0
> nfsd4_openowners       0      0    432    9    1 : tunables   54   27    8 : slabdata      0      0      0
> nfsd4_clients          0      0   1280    3    1 : tunables   24   12    8 : slabdata      0      0      0
> rpc_inode_cache       18     30    640    6    1 : tunables   54   27    8 : slabdata      5      5      0
> UNIX                 113    232   1024    4    1 : tunables   54   27    8 : slabdata     58     58      0
> PINGv6                 0      0   1216    3    1 : tunables   24   12    8 : slabdata      0      0      0
> RAWv6                 20     21   1216    3    1 : tunables   24   12    8 : slabdata      7      7      0
> UDPv6                  6     12   1280    3    1 : tunables   24   12    8 : slabdata      4      4      0
> tw_sock_TCPv6          0      0    240   17    1 : tunables  120   60    8 : slabdata      0      0      0
> request_sock_TCPv6      0      0    296   13    1 : tunables   54   27    8 : slabdata      0      0      0
> TCPv6                  6      9   2368    3    2 : tunables   24   12    8 : slabdata      3      3      0
> scsi_sense_cache   33602  33632    128   32    1 : tunables  120   60    8 : slabdata   1051   1051      0
> drbd_ee             8192   8220    136   30    1 : tunables  120   60    8 : slabdata    274    274      0
> mqueue_inode_cache      1      4    960    4    1 : tunables   54   27    8 : slabdata      1      1      0
> xfs_dquot              0      0    496    8    1 : tunables   54   27    8 : slabdata      0      0      0
> xfs_buf           3523341 3550020    384   10    1 : tunables   54   27    8 : slabdata 355002 355002      0
> xfs_rui_item           0      0    696   11    2 : tunables   54   27    8 : slabdata      0      0      0
> xfs_rud_item           0      0    176   23    1 : tunables  120   60    8 : slabdata      0      0      0
> xfs_inode         30978282 31196832    960    4    1 : tunables   54   27    8 : slabdata 7799208 7799208    434
> xfs_efd_item          82    126    440    9    1 : tunables   54   27    8 : slabdata     13     14      2
> xfs_buf_item         895   2415    272   15    1 : tunables   54   27    8 : slabdata    161    161    108
> xfs_trans            340    493    232   17    1 : tunables  120   60    8 : slabdata     29     29     11
> xfs_da_state          74     88    480    8    1 : tunables   54   27    8 : slabdata     11     11      0
> xfs_btree_cur       8402   8478    224   18    1 : tunables  120   60    8 : slabdata    471    471      0
> xfs_log_ticket       259    484    184   22    1 : tunables  120   60    8 : slabdata     22     22     16
> ext2_inode_cache       0      0    768    5    1 : tunables   54   27    8 : slabdata      0      0      0
> reiser_inode_cache      0      0    760    5    1 : tunables   54   27    8 : slabdata      0      0      0
> dnotify_struct         0      0     32  124    1 : tunables  120   60    8 : slabdata      0      0      0
> dio                    0      0    640    6    1 : tunables   54   27    8 : slabdata      0      0      0
> pid_namespace          0      0    208   19    1 : tunables  120   60    8 : slabdata      0      0      0
> iommu_domain         143    144   2816    2    2 : tunables   24   12    8 : slabdata     72     72      0
> iommu_iova         79743  80010     64   63    1 : tunables  120   60    8 : slabdata   1270   1270      7
> ip4-frags              0      0    200   20    1 : tunables  120   60    8 : slabdata      0      0      0
> xfrm_state             4     11    704   11    2 : tunables   54   27    8 : slabdata      1      1      0
> PING                   0      0    960    4    1 : tunables   54   27    8 : slabdata      0      0      0
> RAW                   32     32   1024    4    1 : tunables   54   27    8 : slabdata      8      8      0
> tw_sock_TCP            0      0    240   17    1 : tunables  120   60    8 : slabdata      0      0      0
> request_sock_TCP       0      0    296   13    1 : tunables   54   27    8 : slabdata      0      0      0
> TCP                   24     39   2240    3    2 : tunables   24   12    8 : slabdata     13     13      0
> cachefiles_object_jar      0      0    320   12    1 : tunables   54   27    8 : slabdata      0      0      0
> hugetlbfs_inode_cache      2      6    608    6    1 : tunables   54   27    8 : slabdata      1      1      0
> dquot                  0      0    256   16    1 : tunables  120   60    8 : slabdata      0      0      0
> eventpoll_pwq        120    840     72   56    1 : tunables  120   60    8 : slabdata     15     15      0
> request_queue        104    108   2080    3    2 : tunables   24   12    8 : slabdata     36     36      0
> blkdev_ioc           104    273    104   39    1 : tunables  120   60    8 : slabdata      7      7      0
> biovec-max           543    573   4096    1    1 : tunables   24   12    8 : slabdata    543    573     92
> biovec-128            17     22   2048    2    1 : tunables   24   12    8 : slabdata      9     11      0
> biovec-64              4     12   1024    4    1 : tunables   54   27    8 : slabdata      3      3      0
> bio_integrity_payload 29644966 30203481    192   21    1 : tunables  120   60    8 : slabdata 1438261 1438261    480
> khugepaged_mm_slot     18    108    112   36    1 : tunables  120   60    8 : slabdata      3      3      0
> user_namespace         0      0    528    7    1 : tunables   54   27    8 : slabdata      0      0      0
> sock_inode_cache     228    460    768    5    1 : tunables   54   27    8 : slabdata     92     92      0
> skbuff_ext_cache     311    448    128   32    1 : tunables  120   60    8 : slabdata     14     14      0
> skbuff_fclone_cache    134    152    512    8    1 : tunables   54   27    8 : slabdata     19     19      0
> skbuff_head_cache    656   1008    256   16    1 : tunables  120   60    8 : slabdata     63     63    120
> file_lock_cache       47    144    216   18    1 : tunables  120   60    8 : slabdata      8      8      0
> fsnotify_mark_connector    103    372     32  124    1 : tunables  120   60    8 : slabdata      3      3      0
> net_namespace          0      0   4544    1    2 : tunables    8    4    0 : slabdata      0      0      0
> task_delay_info      522   2448     80   51    1 : tunables  120   60    8 : slabdata     48     48      0
> taskstats              4     22    344   11    1 : tunables   54   27    8 : slabdata      2      2      0
> proc_dir_entry      1240   1302    192   21    1 : tunables  120   60    8 : slabdata     62     62      0
> pde_opener            58    891     40   99    1 : tunables  120   60    8 : slabdata      9      9      0
> proc_inode_cache     408    510    656    6    1 : tunables   54   27    8 : slabdata     84     85      0
> bdev_cache            64    104    832    4    1 : tunables   54   27    8 : slabdata     26     26      0
> shmem_inode_cache   2076   2629    696   11    2 : tunables   54   27    8 : slabdata    239    239      0
> kernfs_node_cache  63686  64224    128   32    1 : tunables  120   60    8 : slabdata   2007   2007      0
> mnt_cache            269    336    320   12    1 : tunables   54   27    8 : slabdata     28     28      0
> filp                1950   5008    256   16    1 : tunables  120   60    8 : slabdata    312    313      0
> inode_cache        28528  29022    584    7    1 : tunables   54   27    8 : slabdata   4146   4146      0
> dentry            35011852 35447601    192   21    1 : tunables  120   60    8 : slabdata 1687981 1687981    480
> names_cache           90    100   4096    1    1 : tunables   24   12    8 : slabdata     90    100      0
> iint_cache             0      0    112   36    1 : tunables  120   60    8 : slabdata      0      0      0
> buffer_head          121    234    104   39    1 : tunables  120   60    8 : slabdata      6      6      0
> uts_namespace          2      9    440    9    1 : tunables   54   27    8 : slabdata      1      1      0
> mm_struct             70    308   1088    7    2 : tunables   24   12    8 : slabdata     44     44      0
> fs_cache             155   1386     64   63    1 : tunables  120   60    8 : slabdata     22     22      0
> files_cache           86    308    704   11    2 : tunables   54   27    8 : slabdata     28     28      0
> signal_cache         405    630   1088    7    2 : tunables   24   12    8 : slabdata     90     90      0
> sighand_cache        387    462   2112    3    2 : tunables   24   12    8 : slabdata    154    154      0
> task_struct          400    400   5312    1    2 : tunables    8    4    0 : slabdata    400    400      0
> cred_jar            4901   8484    192   21    1 : tunables  120   60    8 : slabdata    402    404     12
> anon_vma_chain      2913   8384     64   64    1 : tunables  120   60    8 : slabdata    131    131     15
> anon_vma            1811   5600     80   50    1 : tunables  120   60    8 : slabdata    112    112      0
> pid                  569   2016    128   32    1 : tunables  120   60    8 : slabdata     62     63      0
> Acpi-Operand      128690 129528     72   56    1 : tunables  120   60    8 : slabdata   2313   2313      0
> Acpi-Parse            85    568     56   71    1 : tunables  120   60    8 : slabdata      8      8      0
> Acpi-State           110    612     80   51    1 : tunables  120   60    8 : slabdata     12     12      0
> numa_policy           15    326     24  163    1 : tunables  120   60    8 : slabdata      2      2      0
> trace_event_file    2267   2300     88   46    1 : tunables  120   60    8 : slabdata     50     50      0
> ftrace_event_field  25634  25730     48   83    1 : tunables  120   60    8 : slabdata    310    310      0
> pool_workqueue      1445   2560    256   16    1 : tunables  120   60    8 : slabdata    160    160    470
> radix_tree_node   3320651 3367581    576    7    1 : tunables   54   27    8 : slabdata 481083 481083    216
> task_group             0      0    768    5    1 : tunables   54   27    8 : slabdata      0      0      0
> vmap_area           1331   2240     64   64    1 : tunables  120   60    8 : slabdata     35     35      0
> dma-kmalloc-4M         0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
> dma-kmalloc-2M         0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
> dma-kmalloc-1M         0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
> dma-kmalloc-512k       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
> dma-kmalloc-256k       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
> dma-kmalloc-128k       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
> dma-kmalloc-64k        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
> dma-kmalloc-32k        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
> dma-kmalloc-16k        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
> dma-kmalloc-8k         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
> dma-kmalloc-4k         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
> dma-kmalloc-2k         0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
> dma-kmalloc-1k         0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
> dma-kmalloc-512        0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
> dma-kmalloc-256        0      0    256   16    1 : tunables  120   60    8 : slabdata      0      0      0
> dma-kmalloc-128        0      0    128   32    1 : tunables  120   60    8 : slabdata      0      0      0
> dma-kmalloc-64         0      0     64   64    1 : tunables  120   60    8 : slabdata      0      0      0
> dma-kmalloc-32         0      0     32  124    1 : tunables  120   60    8 : slabdata      0      0      0
> dma-kmalloc-192        0      0    192   21    1 : tunables  120   60    8 : slabdata      0      0      0
> dma-kmalloc-96         0      0    128   32    1 : tunables  120   60    8 : slabdata      0      0      0
> kmalloc-rcl-4M         0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
> kmalloc-rcl-2M         0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
> kmalloc-rcl-1M         0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
> kmalloc-rcl-512k       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
> kmalloc-rcl-256k       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
> kmalloc-rcl-128k       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
> kmalloc-rcl-64k        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
> kmalloc-rcl-32k        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
> kmalloc-rcl-16k        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
> kmalloc-rcl-8k         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
> kmalloc-rcl-4k         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
> kmalloc-rcl-2k         0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
> kmalloc-rcl-1k         0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
> kmalloc-rcl-512        0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
> kmalloc-rcl-256        2     16    256   16    1 : tunables  120   60    8 : slabdata      1      1      0
> kmalloc-rcl-192      321    924    192   21    1 : tunables  120   60    8 : slabdata     44     44      0
> kmalloc-rcl-128     9801  17344    128   32    1 : tunables  120   60    8 : slabdata    542    542      0
> kmalloc-rcl-96    300370 395392    128   32    1 : tunables  120   60    8 : slabdata  12356  12356      0
> kmalloc-rcl-64    1655932 1754880     64   64    1 : tunables  120   60    8 : slabdata  27420  27420      0
> kmalloc-rcl-32         0      0     32  124    1 : tunables  120   60    8 : slabdata      0      0      0
> kmalloc-4M             0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
> kmalloc-2M             0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
> kmalloc-1M             0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
> kmalloc-512k         212    212 524288    1  128 : tunables    1    1    0 : slabdata    212    212      0
> kmalloc-256k           2      2 262144    1   64 : tunables    1    1    0 : slabdata      2      2      0
> kmalloc-128k           5      5 131072    1   32 : tunables    8    4    0 : slabdata      5      5      0
> kmalloc-64k           34     34  65536    1   16 : tunables    8    4    0 : slabdata     34     34      0
> kmalloc-32k           42     42  32768    1    8 : tunables    8    4    0 : slabdata     42     42      0
> kmalloc-16k           38     38  16384    1    4 : tunables    8    4    0 : slabdata     38     38      0
> kmalloc-8k           471    482   8192    1    2 : tunables    8    4    0 : slabdata    471    482      0
> kmalloc-4k          2266   2380   4096    1    1 : tunables   24   12    8 : slabdata   2266   2380     12
> kmalloc-2k         32456  32890   2048    2    1 : tunables   24   12    8 : slabdata  16436  16445      0
> kmalloc-1k         85482  94528   1024    4    1 : tunables   54   27    8 : slabdata  23632  23632      0
> kmalloc-512       1369048 1559536    512    8    1 : tunables   54   27    8 : slabdata 194941 194942    254
> kmalloc-256       192061 257232    256   16    1 : tunables  120   60    8 : slabdata  16077  16077    411
> kmalloc-192       346779 406938    192   21    1 : tunables  120   60    8 : slabdata  19378  19378    105
> kmalloc-96        511550 569216    128   32    1 : tunables  120   60    8 : slabdata  17788  17788    199
> kmalloc-64        1272055 1363968     64   64    1 : tunables  120   60    8 : slabdata  21312  21312    480
> kmalloc-32        30713972 35358972     32  124    1 : tunables  120   60    8 : slabdata 285153 285153    480
> kmalloc-128       321370 410560    128   32    1 : tunables  120   60    8 : slabdata  12830  12830      0
> kmem_cache          1128   1284    320   12    1 : tunables   54   27    8 : slabdata    107    107      0
> 
> root:done:/home/buczek/linux_problems/shrinker_semaphore/# xfs_info /amd/done/C/C8024
> meta-data=/dev/md0               isize=512    agcount=102, agsize=268435328 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=27348629504, imaxpct=1
>          =                       sunit=128    swidth=1792 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> root:done:/home/buczek/linux_problems/shrinker_semaphore/# xfs_info /amd/done/C/C8025
> meta-data=/dev/md1               isize=512    agcount=102, agsize=268435328 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=27348629504, imaxpct=1
>          =                       sunit=128    swidth=1792 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> root:done:/home/buczek/linux_problems/shrinker_semaphore/# uname -a
> Linux done.molgen.mpg.de 5.4.54.mx64.339 #1 SMP Wed Jul 29 16:24:46 CEST 2020 x86_64 GNU/Linux
> 
> 
> 
> -- 
> Donald Buczek
> buczek@molgen.mpg.de
> Tel: +49 30 8413 1433
