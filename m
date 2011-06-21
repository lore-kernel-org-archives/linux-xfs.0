Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5L82N0b240631 for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 03:02:24 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 290D11F25C
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 01:02:20 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id SaW9kuGW3OtjtEgo for
	<xfs@oss.sgi.com>; Tue, 21 Jun 2011 01:02:20 -0700 (PDT)
Date: Tue, 21 Jun 2011 10:02:19 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110621080219.GA1684@x4.trippels.de>
References: <20110618141950.GA1685@x4.trippels.de>
	<20110619222447.GI561@dastard>
	<20110620005415.GA1730@x4.trippels.de>
	<20110620013449.GO561@dastard>
	<20110620020236.GB1730@x4.trippels.de>
	<20110620023625.GP561@dastard>
	<20110620060351.GC1730@x4.trippels.de>
	<20110620111359.GA12632@x4.trippels.de>
	<20110621042513.GN32466@dastard>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20110621042513.GN32466@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2011.06.21 at 14:25 +1000, Dave Chinner wrote:
> On Mon, Jun 20, 2011 at 01:13:59PM +0200, Markus Trippelsdorf wrote:
> > On 2011.06.20 at 08:03 +0200, Markus Trippelsdorf wrote:
> > > OK. I was able to reproduce the same hang on a conventional 512 sector drive.
> > > The partition that I've used was the predecessor to the one on the 4k drive. So
> > > it saw roughly the same usage pattern.
> > >   1  29  70   0   0   0:  1   1  98   0   0   0:  1   9  90   0   0   0:  1  53  46   0   0   0|   0  6400k|2047  1414 |0.46 0.60 0.39|   0    25 
> > >   0   4  96   0   0   0:  0   0 100   0   0   0:  1  19  80   0   0   0:  0  80  20   0   0   0|   0  2048k|1425   685 |0.46 0.60 0.39|   0     8 
> > >   2   1  97   0   0   0:  1   6  93   0   0   0:  0   5  95   0   0   0:  0  83  17   0   0   0|   0  4608k|1624   849 |0.46 0.60 0.39|   0    18 
> > >   2  45  53   0   0   0:  1  16  83   0   0   0:  3  20  77   0   0   0:  1  15  84   0   0   0|   0  6400k|2420  1984 |0.46 0.60 0.39|   0    26 
> > >   1  19  80   0   0   0:  2   8  90   0   0   0:  0  33  67   0   0   0:  0  33  67   0   0   0|   0  6400k|2694  2134 |0.59 0.63 0.40|   0    25 
> > >   2   7  91   0   0   0:  2   1  97   0   0   0:  1   0  99   0   0   0:  0  49  10  41   0   0|   0  8269k|1865  1571 |0.59 0.63 0.40|   0   363 
> > >   1   1  98   0   0   0:  1   1  98   0   0   0:  1   1  98   0   0   0:  0   1   0  99   0   0|   0  4778k|1509  1639 |0.59 0.63 0.40|   0   410 
> > >   2   0  98   0   0   0:  2   1  97   0   0   0:  1   1  98   0   0   0:  2   0   0  98   0   0|   0  5318k|1663  1809 |0.59 0.63 0.40|   0   426 
> > >   1   1  98   0   0   0:  2   7  91   0   0   0:  1   0  99   0   0   0:  1   0   0  99   0   0|   0  5446k|1659  1806 |0.59 0.63 0.40|   0   432 
> > >   0   1  99   0   0   0:  1   0  99   0   0   0:  2   0  98   0   0   0:  0   1  17  82   0   0|   0  5472k|1572  1837 |0.62 0.63 0.40|   0   439 
> > >   2   0  98   0   0   0:  2   2  96   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0|   0   397k|1058  1049 |0.62 0.63 0.40|   0    36 
> > >   1   1  98   0   0   0:  1   1  98   0   0   0:  1   1  98   0   0   0:  0   0 100   0   0   0|   0     0 | 617   689 |0.62 0.63 0.40|   0     0 
> > >   9   4  87   0   0   0:  4   0  96   0   0   0:  1   1  98   0   0   0:  8   6  87   0   0   0|   0     0 |1234  1961 |0.62 0.63 0.40|   0     0 
> > >   0   1  99   0   0   0:  1   1  98   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0|   0     0 | 391   403 |0.62 0.63 0.40|   0     0 
> > >   1   0  99   0   0   0:  1   1  98   0   0   0:  0   0 100   0   0   0:  0   0 100   0   0   0|   0     0 | 366   375 |0.57 0.62 0.40|   0     0 
> 
> What is the resolution of the samples here? Where did the hang occur
> during this output?

Resolution is 1 sec. I think the hang occurred when cpu3 wait switched
from 41% to 99% (but I'm not sure).

> FWIW, Can you capture the hang while running 'iostat -x -d -m 1' so
> we can see what is happening with queue depths, average Io sizes,
> etc?

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdc1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdc1              0.00     0.00    1.00  202.00     0.00     6.31    63.72     3.90   19.21   19.00   19.21   2.57  52.10
sdc1              0.00     0.00    0.00    8.00     0.00     0.25    64.00     0.15   18.50    0.00   18.50   2.50   2.00
sdc1   *hang*     0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdc1              0.00     0.00    0.00  116.00     0.00     3.78    66.76     2.25   18.66    0.00   18.66   2.45  28.40
sdc1              0.00     9.00    0.00  210.00     0.00     2.25    21.92     3.96   19.28    0.00   19.28   4.43  93.00
sdc1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00


> > Here are two more examples. The time when the hang occurs is marked with
> > "=>":
> > ------cpu0-usage--------------cpu1-usage--------------cpu2-usage--------------cpu3-usage------ --dsk/sdb-- ---system-- ---load-avg--- --dsk/sdb--
> > usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq| read  writ| int   csw | 1m   5m  15m |reads writs
> .....
> >   1  10  89   0   0   0:  2  38  61   0   0   0:  1   8  81  10   0   0:  0  64  36   0   0   0|   0  4476k|2378  2010 |1.12 0.59 0.28|   0   146 
> > =>0   0 100   0   0   0:  0   1  99   0   0   0:  0   1   0  99   0   0:  0 100   0   0   0   0|   0     0 |1237   283 |1.12 0.59 0.28|   0     0 
> >   0  27  73   0   0   0:  1   0  99   0   0   0:  0   0  47  53   0   0:  0  56  44   0   0   0|   0  5812k|1596   857 |1.12 0.59 0.28|   0   182 
> .....
> >   7  26  67   0   0   0:  4   1  95   0   0   0:  1  37  62   0   0   0:  3  38  59   0   0   0|   0   864k|2904  2806 |0.70 0.65 0.40|   0    33 
> > =>2   1  97   0   0   0:  1   0  99   0   0   0:  0   1  99   0   0   0:  0 100   0   0   0   0|   0     0 |1725   639 |0.89 0.69 0.41|   0     0 
> >   1   1  98   0   0   0:  2   1  97   0   0   0:  2   1  97   0   0   0:  0  71  29   0   0   0|   0  3968k|1793   852 |0.89 0.69 0.41|   0   123 
> .....
> 
> So in both cases here the hang occurs when there is -zero- IO
> occurring, and a CPU has pegged at 100% in system time. That's CPU
> bound doing <something>.  It is possible that the CPU is getting
> caught in a loop somewhere or has a -lot- of processing to do before
> progress is made.
> 
> I know a CIL commit can take some time to process all the
> objects in a checkpoint, but I haven't seen anything like this.
> You've only got a relatively small log (100MB) and you're only
> removing a kernel source tree, so there really shouldn't be an
> excessive number of objects built up to process per checkpoint.
> 
> FWIW, I'm pretty sure a CPU getting stuck like this in the
> filesystem code should not be causing problems with X or other
> non-filesystem workloads. There's 3 idle CPU cores and you are
> running a preemptible kernel, so I really can't see why system time
> spent in XFS would cause mouse or keyboard updates to not be
> processed in a timely manner. We really need to know what is
> consuming all that CPU time.
> 
> That is, you really need to get a profile of the rm -rf process - or
> whatever is consuming the CPU time - (e.g. via perf or ftrace)
> across the hang to so we can narrow down the potential cause of the
> latency. Speaking of which, latencytop might be helpful in
> identifying where input is getting held up....

I've recorded a profile with "perf record -g /home/markus/rm_sync"
~ % cat rm_sync
rm -fr /mnt/tmp/tmp/linux && sync

This is the output of "/perf report -g --stdio" (Just the first entries
the full report is attached).


# Events: 1K cycles
#
# Overhead  Command      Shared Object                              Symbol
# ........  .......  .................  ..................................
#
     5.32%       rm  [kernel.kallsyms]  [k] __memcpy
                 |
                 --- __memcpy
                    |          
                    |--90.77%-- _xfs_trans_commit
                    |          |          
                    |          |--62.41%-- xfs_itruncate_finish
                    |          |          xfs_inactive
                    |          |          xfs_fs_evict_inode
                    |          |          evict
                    |          |          iput
                    |          |          do_unlinkat
                    |          |          sys_unlinkat
                    |          |          system_call_fastpath
                    |          |          unlinkat
                    |          |          
                    |          |--19.50%-- xfs_remove
                    |          |          xfs_vn_unlink
                    |          |          vfs_unlink
                    |          |          do_unlinkat
                    |          |          sys_unlinkat
                    |          |          system_call_fastpath
                    |          |          unlinkat
                    |          |          
                    |          |--16.70%-- xfs_inactive
                    |          |          xfs_fs_evict_inode
                    |          |          evict
                    |          |          iput
                    |          |          do_unlinkat
                    |          |          sys_unlinkat
                    |          |          system_call_fastpath
                    |          |          unlinkat
                    |          |          
                    |           --1.39%-- xfs_bmap_finish
                    |                     xfs_itruncate_finish
                    |                     xfs_inactive
                    |                     xfs_fs_evict_inode
                    |                     evict
                    |                     iput
                    |                     do_unlinkat
                    |                     sys_unlinkat
                    |                     system_call_fastpath
                    |                     unlinkat
                    |          
                    |--5.44%-- xlog_cil_push
                    |          xfs_log_commit_cil
                    |          _xfs_trans_commit
                    |          xfs_remove
                    |          xfs_vn_unlink
                    |          vfs_unlink
                    |          do_unlinkat
                    |          sys_unlinkat
                    |          system_call_fastpath
                    |          unlinkat
                    |          
                    |--2.53%-- xfs_btree_insrec
                    |          xfs_btree_insert
                    |          xfs_free_ag_extent
                    |          xfs_free_extent
                    |          xfs_bmap_finish
                    |          xfs_itruncate_finish
                    |          xfs_inactive
                    |          xfs_fs_evict_inode
                    |          evict
                    |          iput
                    |          do_unlinkat
                    |          sys_unlinkat
                    |          system_call_fastpath
                    |          unlinkat
                    |          
                     --1.26%-- xfs_btree_update
                               xfs_inobt_update
                               xfs_difree
                               xfs_ifree
                               xfs_inactive
                               xfs_fs_evict_inode
                               evict
                               iput
                               do_unlinkat
                               sys_unlinkat
                               system_call_fastpath
                               unlinkat

     3.85%     sync  [kernel.kallsyms]  [k] xfs_inode_ag_walk.isra.7
                 |
                 --- xfs_inode_ag_walk.isra.7
                     xfs_inode_ag_iterator
                     xfs_sync_data
                     xfs_quiesce_data
                     xfs_fs_sync_fs
                     __sync_filesystem
                     sync_one_sb
                     iterate_supers
                     sync_filesystems
                     sys_sync
                     system_call_fastpath
                     __GI_sync

     2.68%     sync  [kernel.kallsyms]  [k] __rcu_read_unlock
                 |
                 --- __rcu_read_unlock
                     mapping_tagged
                     xfs_sync_inode_data
                     xfs_inode_ag_walk.isra.7
                     xfs_inode_ag_iterator
                     xfs_sync_data
                     xfs_quiesce_data
                     xfs_fs_sync_fs
                     __sync_filesystem
                     sync_one_sb
                     iterate_supers
                     sync_filesystems
                     sys_sync
                     system_call_fastpath
                     __GI_sync

     2.56%       rm  [kernel.kallsyms]  [k] xfs_next_bit
                 |
                 --- xfs_next_bit
                    |          
                    |--31.60%-- xfs_log_commit_cil
                    |          _xfs_trans_commit
                    |          |          
                    |          |--91.65%-- xfs_itruncate_finish
                    |          |          xfs_inactive
                    |          |          xfs_fs_evict_inode
                    |          |          evict
                    |          |          iput
                    |          |          do_unlinkat
                    |          |          sys_unlinkat
                    |          |          system_call_fastpath
                    |          |          unlinkat
                    |          |          
                    |           --8.35%-- xfs_remove
                    |                     xfs_vn_unlink
                    |                     vfs_unlink
                    |                     do_unlinkat
                    |                     sys_unlinkat
                    |                     system_call_fastpath
                    |                     unlinkat
                    |          
                    |--28.93%-- xfs_buf_item_size
                    |          xfs_trans_alloc_log_vecs
                    |          _xfs_trans_commit
                    |          |          
                    |          |--72.71%-- xfs_itruncate_finish
                    |          |          xfs_inactive
                    |          |          xfs_fs_evict_inode
                    |          |          evict
                    |          |          iput
                    |          |          do_unlinkat
                    |          |          sys_unlinkat
                    |          |          system_call_fastpath
                    |          |          unlinkat
                    |          |          
                    |          |--18.18%-- xfs_inactive
                    |          |          xfs_fs_evict_inode
                    |          |          evict
                    |          |          iput
                    |          |          do_unlinkat
                    |          |          sys_unlinkat
                    |          |          system_call_fastpath
                    |          |          unlinkat
                    |          |          
                    |           --9.11%-- xfs_remove
                    |                     xfs_vn_unlink
                    |                     vfs_unlink
                    |                     do_unlinkat
                    |                     sys_unlinkat
                    |                     system_call_fastpath
                    |                     unlinkat
                    |          
                    |--26.33%-- xfs_buf_item_format
                    |          xfs_log_commit_cil
                    |          _xfs_trans_commit
                    |          |          
                    |          |--70.10%-- xfs_itruncate_finish
                    |          |          xfs_inactive
                    |          |          xfs_fs_evict_inode
                    |          |          evict
                    |          |          iput
                    |          |          do_unlinkat
                    |          |          sys_unlinkat
                    |          |          system_call_fastpath
                    |          |          unlinkat
                    |          |          
                    |          |--19.91%-- xfs_inactive
                    |          |          xfs_fs_evict_inode
                    |          |          evict
                    |          |          iput
                    |          |          do_unlinkat
                    |          |          sys_unlinkat
                    |          |          system_call_fastpath
                    |          |          unlinkat
                    |          |          
                    |           --9.99%-- xfs_remove
                    |                     xfs_vn_unlink
                    |                     vfs_unlink
                    |                     do_unlinkat
                    |                     sys_unlinkat
                    |                     system_call_fastpath
                    |                     unlinkat
                    |          
                     --13.14%-- xfs_trans_alloc_log_vecs
                               _xfs_trans_commit
                               |          
                               |--60.17%-- xfs_remove
                               |          xfs_vn_unlink
                               |          vfs_unlink
                               |          do_unlinkat
                               |          sys_unlinkat
                               |          system_call_fastpath
                               |          unlinkat
                               |          
                                --39.83%-- xfs_inactive
                                          xfs_fs_evict_inode
                                          evict
                                          iput
                                          do_unlinkat
                                          sys_unlinkat
                                          system_call_fastpath
                                          unlinkat

     2.56%       rm  [kernel.kallsyms]  [k] kmem_cache_free
                 |
                 --- kmem_cache_free
                    |          
                    |--39.47%-- xfs_trans_free_item_desc
                    |          |          
                    |          |--79.98%-- xfs_trans_free_items
                    |          |          xfs_log_commit_cil
                    |          |          _xfs_trans_commit
                    |          |          |          
                    |          |          |--50.02%-- xfs_inactive
                    |          |          |          xfs_fs_evict_inode
                    |          |          |          evict
                    |          |          |          iput
                    |          |          |          do_unlinkat
                    |          |          |          sys_unlinkat
                    |          |          |          system_call_fastpath
                    |          |          |          unlinkat
                    |          |          |          
                    |          |          |--33.35%-- xfs_itruncate_finish
                    |          |          |          xfs_inactive
                    |          |          |          xfs_fs_evict_inode
                    |          |          |          evict
                    |          |          |          iput
                    |          |          |          do_unlinkat
                    |          |          |          sys_unlinkat
                    |          |          |          system_call_fastpath
                    |          |          |          unlinkat
                    |          |          |          
                    |          |           --16.63%-- xfs_bmap_finish
                    |          |                     xfs_itruncate_finish
                    |          |                     xfs_inactive
                    |          |                     xfs_fs_evict_inode
                    |          |                     evict
                    |          |                     iput
                    |          |                     do_unlinkat
                    |          |                     sys_unlinkat
                    |          |                     system_call_fastpath
                    |          |                     unlinkat
                    |          |          
                    |           --20.02%-- xfs_trans_del_item
                    |                     xfs_trans_brelse
                    |                     xfs_btree_del_cursor
                    |                     |          
                    |                     |--66.61%-- xfs_free_ag_extent
                    |                     |          xfs_free_extent
                    |                     |          xfs_bmap_finish
                    |                     |          |          
                    |                     |          |--50.15%-- xfs_remove
                    |                     |          |          xfs_vn_unlink
                    |                     |          |          vfs_unlink
                    |                     |          |          do_unlinkat
                    |                     |          |          sys_unlinkat
                    |                     |          |          system_call_fastpath
                    |                     |          |          unlinkat
                    |                     |          |          
                    |                     |           --49.85%-- xfs_itruncate_finish
                    |                     |                     xfs_inactive
                    |                     |                     xfs_fs_evict_inode
                    |                     |                     evict
                    |                     |                     iput
                    |                     |                     do_unlinkat
                    |                     |                     sys_unlinkat
                    |                     |                     system_call_fastpath
                    |                     |                     unlinkat
                    |                     |          
                    |                      --33.39%-- xfs_difree
                    |                                xfs_ifree
                    |                                xfs_inactive
                    |                                xfs_fs_evict_inode
                    |                                evict
                    |                                iput
                    |                                do_unlinkat
                    |                                sys_unlinkat
                    |                                system_call_fastpath
                    |                                unlinkat
                    |          
                    |--31.56%-- xfs_buf_get
                    |          xfs_buf_read
                    |          xfs_trans_read_buf
                    |          |          
                    |          |--49.95%-- xfs_btree_read_buf_block.constprop.22
                    |          |          xfs_btree_lookup_get_block
                    |          |          xfs_btree_lookup
                    |          |          |          
                    |          |          |--49.98%-- xfs_alloc_lookup_eq
                    |          |          |          xfs_free_ag_extent
                    |          |          |          xfs_free_extent
                    |          |          |          xfs_bmap_finish
                    |          |          |          xfs_itruncate_finish
                    |          |          |          xfs_inactive
                    |          |          |          xfs_fs_evict_inode
                    |          |          |          evict
                    |          |          |          iput
                    |          |          |          do_unlinkat
                    |          |          |          sys_unlinkat
                    |          |          |          system_call_fastpath
                    |          |          |          unlinkat
                    |          |          |          
                    |          |          |--33.29%-- xfs_free_ag_extent
                    |          |          |          xfs_free_extent
                    |          |          |          xfs_bmap_finish
                    |          |          |          xfs_itruncate_finish
                    |          |          |          xfs_inactive
                    |          |          |          xfs_fs_evict_inode
                    |          |          |          evict
                    |          |          |          iput
                    |          |          |          do_unlinkat
                    |          |          |          sys_unlinkat
                    |          |          |          system_call_fastpath
                    |          |          |          unlinkat
                    |          |          |          
                    |          |           --16.74%-- xfs_inobt_lookup
                    |          |                     xfs_difree
                    |          |                     xfs_ifree
                    |          |                     xfs_inactive
                    |          |                     xfs_fs_evict_inode
                    |          |                     evict
                    |          |                     iput
                    |          |                     do_unlinkat
                    |          |                     sys_unlinkat
                    |          |                     system_call_fastpath
                    |          |                     unlinkat
                    |          |          
                    |          |--24.99%-- xfs_imap_to_bp.isra.9
                    |          |          xfs_itobp
                    |          |          xfs_iunlink_remove
                    |          |          xfs_ifree
                    |          |          xfs_inactive
                    |          |          xfs_fs_evict_inode
                    |          |          evict
                    |          |          iput
                    |          |          |          
                    |          |          |--66.63%-- do_unlinkat
                    |          |          |          sys_unlinkat
                    |          |          |          system_call_fastpath
                    |          |          |          unlinkat
                    |          |          |          
                    |          |           --33.37%-- d_delete
                    |          |                     vfs_rmdir
                    |          |                     do_rmdir
                    |          |                     sys_unlinkat
                    |          |                     system_call_fastpath
                    |          |                     unlinkat
                    |          |          
                    |          |--16.70%-- xfs_read_agi
                    |          |          |          
                    |          |          |--50.05%-- xfs_iunlink_remove
                    |          |          |          xfs_ifree
                    |          |          |          xfs_inactive
                    |          |          |          xfs_fs_evict_inode
                    |          |          |          evict
                    |          |          |          iput
                    |          |          |          do_unlinkat
                    |          |          |          sys_unlinkat
                    |          |          |          system_call_fastpath
                    |          |          |          unlinkat
                    |          |          |          
                    |          |           --49.95%-- xfs_iunlink
                    |          |                     xfs_droplink
                    |          |                     xfs_remove
                    |          |                     xfs_vn_unlink
                    |          |                     vfs_unlink
                    |          |                     do_unlinkat
                    |          |                     sys_unlinkat
                    |          |                     system_call_fastpath
                    |          |                     unlinkat
                    |          |          
                    |           --8.36%-- xfs_read_agf
                    |                     xfs_alloc_read_agf
                    |                     xfs_alloc_fix_freelist
                    |                     xfs_free_extent
                    |                     xfs_bmap_finish
                    |                     xfs_itruncate_finish
                    |                     xfs_inactive
                    |                     xfs_fs_evict_inode
                    |                     evict
                    |                     iput
                    |                     do_unlinkat
                    |                     sys_unlinkat
                    |                     system_call_fastpath
                    |                     unlinkat
                    |          
                    |--5.27%-- xfs_trans_free
                    |          _xfs_trans_commit
                    |          |          
                    |          |--50.08%-- xfs_inactive
                    |          |          xfs_fs_evict_inode
                    |          |          evict
                    |          |          iput
                    |          |          do_unlinkat
                    |          |          sys_unlinkat
                    |          |          system_call_fastpath
                    |          |          unlinkat
                    |          |          
                    |           --49.92%-- xfs_remove
                    |                     xfs_vn_unlink
                    |                     vfs_unlink
                    |                     do_unlinkat
                    |                     sys_unlinkat
                    |                     system_call_fastpath
                    |                     unlinkat
                    |          
                    |--5.27%-- xfs_trans_free_items
                    |          xfs_log_commit_cil
                    |          _xfs_trans_commit
                    |          |          
                    |          |--50.13%-- xfs_remove
                    |          |          xfs_vn_unlink
                    |          |          vfs_unlink
                    |          |          do_unlinkat
                    |          |          sys_unlinkat
                    |          |          system_call_fastpath
                    |          |          unlinkat
                    |          |          
                    |           --49.87%-- xfs_itruncate_finish
                    |                     xfs_inactive
                    |                     xfs_fs_evict_inode
                    |                     evict
                    |                     iput
                    |                     do_unlinkat
                    |                     sys_unlinkat
                    |                     system_call_fastpath
                    |                     unlinkat
                    |          
                    |--2.64%-- xfs_trans_del_item
                    |          xfs_trans_brelse
                    |          xfs_iunlink_remove
                    |          xfs_ifree
                    |          xfs_inactive
                    |          xfs_fs_evict_inode
                    |          evict
                    |          iput
                    |          do_unlinkat
                    |          sys_unlinkat
                    |          system_call_fastpath
                    |          unlinkat
                    |          
                    |--2.64%-- __rcu_process_callbacks
                    |          rcu_process_callbacks
                    |          __do_softirq
                    |          call_softirq
                    |          do_softirq
                    |          irq_exit
                    |          smp_apic_timer_interrupt
                    |          apic_timer_interrupt
                    |          xfs_btree_lookup
                    |          xfs_inobt_lookup
                    |          xfs_difree
                    |          xfs_ifree
                    |          xfs_inactive
                    |          xfs_fs_evict_inode
                    |          evict
                    |          iput
                    |          do_unlinkat
                    |          sys_unlinkat
                    |          system_call_fastpath
                    |          unlinkat
                    |          
                    |--2.64%-- free_buffer_head
                    |          try_to_free_buffers
                    |          xfs_vm_releasepage
                    |          try_to_release_page
                    |          block_invalidatepage
                    |          xfs_vm_invalidatepage
                    |          truncate_inode_page
                    |          truncate_inode_pages_range
                    |          truncate_inode_pages
                    |          xfs_fs_evict_inode
                    |          evict
                    |          iput
                    |          do_unlinkat
                    |          sys_unlinkat
                    |          system_call_fastpath
                    |          unlinkat
                    |          
                    |--2.64%-- xfs_bmap_del_free.constprop.18
                    |          xfs_bmap_finish
                    |          xfs_itruncate_finish
                    |          xfs_inactive
                    |          xfs_fs_evict_inode
                    |          evict
                    |          iput
                    |          do_unlinkat
                    |          sys_unlinkat
                    |          system_call_fastpath
                    |          unlinkat
                    |          
                    |--2.63%-- xfs_log_done
                    |          xfs_log_commit_cil
                    |          _xfs_trans_commit
                    |          xfs_remove
                    |          xfs_vn_unlink
                    |          vfs_unlink
                    |          do_unlinkat
                    |          sys_unlinkat
                    |          system_call_fastpath
                    |          unlinkat
                    |          
                    |--2.62%-- do_unlinkat
                    |          sys_unlinkat
                    |          system_call_fastpath
                    |          unlinkat
                    |          
                     --2.62%-- xfs_difree
                               xfs_ifree
                               xfs_inactive
                               xfs_fs_evict_inode
                               evict
                               iput
                               do_unlinkat
                               sys_unlinkat
                               system_call_fastpath
                               unlinkat

-- 
Markus

--SUOF0GtieIMvvwua
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="report_hang.gz"
Content-Transfer-Encoding: base64

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
W+P/A4XzriiwbAYA

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--SUOF0GtieIMvvwua--
