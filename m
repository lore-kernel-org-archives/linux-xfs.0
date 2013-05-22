Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 72A4D29DF8
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 18:12:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 510FF8F8066
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 16:12:48 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id zolCDc8HO1CJh1zO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 16:12:47 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 22 May 2013 17:12:47 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 720FA1FF001B
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 17:07:36 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r4MNCif2130964 for <xfs@oss.sgi.com>; Wed, 22 May 2013 17:12:44 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r4MNCihc024735
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 17:12:44 -0600
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r4MNCiBY024711 for <xfs@oss.sgi.com>; Wed, 22 May 2013 17:12:44 -0600
Subject: deadlock with &log->l_cilp->xc_ctx_lock semaphone
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 22 May 2013 18:12:43 -0500
Message-ID: <1369264363.10223.2994.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS mailing list <xfs@oss.sgi.com>

Hello,

While testing and rearranging my pquota/gquota code, I stumbled on a
xfs_shutdown() during a mount. But the mount just hung.

I debugged and found that it is in a code path where
&log->l_cilp->xc_ctx_lock is first acquired in read mode and some levels
down the same semaphore is being acquired in write mode causing a
deadlock.

This is the stack:
xfs_log_commit_cil -> acquires &log->l_cilp->xc_ctx_lock in read mode
  xlog_print_tic_res
    xfs_force_shutdown
      xfs_log_force_umount
        xlog_cil_force
          xlog_cil_force_lsn
            xlog_cil_push_foreground
              xlog_cil_push - tries to acquire same semaphore in write mode
-------------------------

Here is the actual stack from /var/log/messages:

-------------------------
schedule+0x29/0x70
rwsem_down_write_failed+0xf5/0x1a0
call_rwsem_down_write_failed+0x13/0x20
? down_write+0x31/0x40
xlog_cil_push+0xd6/0x3e0 [xfs]
? __cond_resched+0x2a/0x40
xlog_cil_force_lsn+0x154/0x160 [xfs]
? __xfs_printk+0x31/0x50 [xfs]
xfs_log_force_umount+0x5c/0x170 [xfs]
xfs_do_force_shutdown+0x6b/0x170 [xfs]
? xlog_print_tic_res+0x112/0x120 [xfs]
xlog_print_tic_res+0x112/0x120 [xfs]
xfs_log_commit_cil+0x336/0x4a0 [xfs]
xfs_trans_commit+0x79/0x270 [xfs]  
xfs_qm_write_sb_changes+0x61/0x90 [xfs]
xfs_qm_mount_quotas+0x82/0x180 [xfs]
xfs_mountfs+0x5f6/0x6b0 [xfs]
xfs_fs_fill_super+0x2af/0x330 [xfs]
mount_bdev+0x1be/0x200
? __free_pages+0x2d/0x40
? xfs_setup_devices+0xa0/0xa0 [xfs]
? selinux_sb_copy_data+0x14a/0x1e0 
xfs_fs_mount+0x15/0x20 [xfs]
mount_fs+0x43/0x1a0
vfs_kern_mount+0x72/0x100
do_mount+0x3e3/0x980
SyS_mount+0x90/0xe0
tracesys+0xdd/0xe2

--------------------------



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
