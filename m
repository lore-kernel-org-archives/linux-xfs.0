Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE5797CBF
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 14:37:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9E6E68F8059
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 12:37:17 -0700 (PDT)
Received: from na3sys009aog113.obsmtp.com (na3sys009aog113.obsmtp.com
	[74.125.149.209]) by cuda.sgi.com with SMTP id 42Uc2RfWru4l7FFz
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 07 Jun 2013 12:37:16 -0700 (PDT)
Received: by mail-ob0-f176.google.com with SMTP id v19so7117040obq.35
	for <xfs@oss.sgi.com>; Fri, 07 Jun 2013 12:37:15 -0700 (PDT)
Date: Fri, 7 Jun 2013 14:37:12 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: 3.10-rc4 stalls during mmap writes
Message-ID: <20130607193712.GD2995@sbohrermbp13-local.rgmadvisors.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

I've started testing the 3.10 kernel, previously I was on 3.4, and I'm
encounting some fairly large stalls in my memory mapped writes in the
range of .01 to 1s.  I've managed to capture two of these stalls so
far and both looked like the following:

1) Writing process writes to a new page and blocks on xfs_ilock:

    <...>-21567 [009]  9435.453069: sched_switch:     prev_comm=tick_receiver_m prev_pid=21567 prev_prio=79 prev_state=D ==> next_comm=swapper/9 next_pid=0 next_prio=120
    <...>-21567 [009]  9435.453072: kernel_stack:     <stack trace>
=> schedule (ffffffff814ca379)
=> rwsem_down_write_failed (ffffffff814cb095)
=> call_rwsem_down_write_failed (ffffffff81275053)
=> xfs_ilock (ffffffff8120b25c)
=> xfs_vn_update_time (ffffffff811cf3d3)
=> update_time (ffffffff81158dd3)
=> file_update_time (ffffffff81158f0c)
=> block_page_mkwrite (ffffffff81171d23)
=> xfs_vm_page_mkwrite (ffffffff811c5375)
=> do_wp_page (ffffffff8110c27f)
=> handle_pte_fault (ffffffff8110dd24)
=> handle_mm_fault (ffffffff8110f430)
=> __do_page_fault (ffffffff814cef72)
=> do_page_fault (ffffffff814cf2e7)
=> page_fault (ffffffff814cbab2)

2) kworker calls xfs_iunlock and wakes up my process:

   kworker/u50:1-403   [013]  9436.027354: sched_wakeup:     comm=tick_receiver_m pid=21567 prio=79 success=1 target_cpu=009
   kworker/u50:1-403   [013]  9436.027359: kernel_stack:     <stack trace>
=> ttwu_do_activate.constprop.34 (ffffffff8106c556)
=> try_to_wake_up (ffffffff8106e996)
=> wake_up_process (ffffffff8106ea87)
=> __rwsem_do_wake (ffffffff8126e531)
=> rwsem_wake (ffffffff8126e62a)
=> call_rwsem_wake (ffffffff81275077)
=> xfs_iunlock (ffffffff8120b55c)
=> xfs_iomap_write_allocate (ffffffff811ce4e7)
=> xfs_map_blocks (ffffffff811bf145)
=> xfs_vm_writepage (ffffffff811bfbc2)
=> __writepage (ffffffff810f14e7)
=> write_cache_pages (ffffffff810f189e)
=> generic_writepages (ffffffff810f1b3a)
=> xfs_vm_writepages (ffffffff811bef8d)
=> do_writepages (ffffffff810f3380)
=> __writeback_single_inode (ffffffff81166ae5)
=> writeback_sb_inodes (ffffffff81167d4d)
=> __writeback_inodes_wb (ffffffff8116800e)
=> wb_writeback (ffffffff811682bb)
=> wb_check_old_data_flush (ffffffff811683ff)
=> wb_do_writeback (ffffffff81169bd1)
=> bdi_writeback_workfn (ffffffff81169cca)
=> process_one_work (ffffffff81059104)
=> worker_thread (ffffffff8105a1bc)
=> kthread (ffffffff810605f0)
=> ret_from_fork (ffffffff814d395c)

In this case my process stalled for roughly half a second:

<...>-21567 [009]  9436.027388: print:                tracing_mark_write: stall of 0.574282

So I guess my question is does anyone know why I'm now seeing these
stalls with 3.10?  Are there any suggestions for how to eliminate them?

# xfs_info /home/
meta-data=/dev/sda5              isize=256    agcount=4, agsize=67774016 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=271096064, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=132371, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# grep sda5 /proc/mounts 
/dev/sda5 /home xfs rw,noatime,nodiratime,attr2,nobarrier,inode64,noquota 0 0

Thanks,
Shawn

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
