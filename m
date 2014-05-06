Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5B1477F37
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 16:18:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DCA7F8F8035
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 14:18:53 -0700 (PDT)
Received: from mail-ve0-f176.google.com (mail-ve0-f176.google.com
	[209.85.128.176]) by cuda.sgi.com with ESMTP id
	GYdQB80OzEm54oIb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 14:18:47 -0700 (PDT)
Received: by mail-ve0-f176.google.com with SMTP id jz11so99491veb.7
	for <xfs@oss.sgi.com>; Tue, 06 May 2014 14:18:47 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 7 May 2014 09:18:46 +1200
Message-ID: <CAJzjPK=YF3=xx5dSGzw4S44Nf01o6d1tcqiiofE4m-nuWdOKTQ@mail.gmail.com>
Subject: xf kernel trace , what is the cause ?
From: Gregory Machin <gdm@linuxpro.co.za>
Reply-To: gdm@linuxpro.co.za
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5075482754944216390=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5075482754944216390==
Content-Type: multipart/alternative; boundary=047d7b6743a21eb78104f8c1cb9a

--047d7b6743a21eb78104f8c1cb9a
Content-Type: text/plain; charset=UTF-8

Hi.

I have a file server that has had 2 xfs Kernel trace dumps about 2 weeks
apart.

The RAID 60 data store is mounted as /home with xfs as the file system. The
/home space is shares via NFS export and CIFS share.  At the time of
the Trace dumps NFS access hangs and crashed users sessions on the client
side.  The output of the last traces is below.

Can you advise as to the cause of this dump and possible resolution ?

System information:

CentOS release 6.5 (Final)

Physical
24 GB Ram
Intel(R) Xeon(R) CPU  X5560  @ 2.80GHz
2 x RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev
04)
RAID configured in RAID 6 with software RAID 0 providing final RAID 60

Kernel 2.6.32-431.5.1.el6.x86_64
xfsdump-3.0.4-3.el6.x86_64
xfsprogs-3.1.1-14.el6.x86_64
nfs-utils-1.2.3-39.el6.x86_64
nfs4-acl-tools-0.3.3-6.el6.x86_64
nfs-utils-lib-1.1.5-6.el6.x86_64
samba-common-3.6.9-168.el6_5.x86_64
samba4-libs-4.0.0-61.el6_5.rc4.x86_64
samba-3.6.9-168.el6_5.x86_64
samba-winbind-clients-3.6.9-168.el6_5.x86_64
samba-client-3.6.9-168.el6_5.x86_64
samba-winbind-3.6.9-168.el6_5.x86_64

[root@nzhmlfpr010 ~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdc2              97G  3.2G   89G   4% /
tmpfs                  12G     0   12G   0% /dev/shm
/dev/sdc1             504M  100M  379M  21% /boot
/dev/md0               11T  1.7T  9.3T  15% /home

[root@nzhmlfpr010 ~]# cat /proc/mdstat
Personalities : [raid0]
md0 : active raid0 sdb1[1] sda1[0]
      11707018240 blocks super 1.1 512k chunks
unused devices: <none>

Kernel traces:

May  2 17:49:39 nzhmlfpr010 kernel: INFO: task nfsd:2529 blocked for more
than 120 seconds.
May  2 17:49:39 nzhmlfpr010 kernel:      Not tainted
2.6.32-431.5.1.el6.x86_64 #1
May  2 17:49:39 nzhmlfpr010 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May  2 17:49:39 nzhmlfpr010 kernel: nfsd          D 0000000000000008     0
2529      2 0x00000080
May  2 17:49:39 nzhmlfpr010 kernel: ffff8806384c95e0 0000000000000046
0000000000001000 0000000000000000
May  2 17:49:39 nzhmlfpr010 kernel: 000000000026b000 000000000026c000
0000000000000100 ffffffffffffffff
May  2 17:49:39 nzhmlfpr010 kernel: ffff880623df3ab8 ffff8806384c9fd8
000000000000fbc8 ffff880623df3ab8
May  2 17:49:39 nzhmlfpr010 kernel: Call Trace:
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff81528ac5>]
schedule_timeout+0x215/0x2e0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff81086036>] ?
mod_timer_pending+0x126/0x200
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa03cea95>] ?
__nf_ct_refresh_acct+0xe5/0x100 [nf_conntrack]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff81529ac2>] __down+0x72/0xb0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>] ?
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff810a1381>] down+0x41/0x50
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0284901>]
xfs_buf_lock+0x51/0x100 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>]
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0284c14>]
xfs_buf_get+0x34/0x1b0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa028529c>]
xfs_buf_read+0x2c/0x100 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa027ac87>]
xfs_trans_read_buf+0x1f7/0x410 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa025d164>]
xfs_read_agi+0x74/0x100 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa025d21e>]
xfs_ialloc_read_agi+0x2e/0x90 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa025d503>]
xfs_ialloc_ag_select+0x133/0x270 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa025ebc7>]
xfs_dialloc+0x3d7/0x850 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8144b4d4>] ?
release_sock+0xe4/0xf0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff814a4aa1>] ?
tcp_recvmsg+0x821/0xe80
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0262980>]
xfs_ialloc+0x60/0x6e0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa028006a>] ?
kmem_zone_zalloc+0x3a/0x50 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa027b814>]
xfs_dir_ialloc+0x74/0x2b0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa027d8f0>]
xfs_create+0x440/0x640 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa028aa3d>]
xfs_vn_mknod+0xad/0x1c0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa028ab80>]
xfs_vn_create+0x10/0x20 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff811983b6>]
vfs_create+0xe6/0x110
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa055f3d5>]
nfsd_create_v3+0x3d5/0x530 [nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0566c13>]
nfsd3_proc_create+0x123/0x1b0 [nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0557425>]
nfsd_dispatch+0xe5/0x230 [nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa043a844>]
svc_process_common+0x344/0x640 [sunrpc]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff81065df0>] ?
default_wake_function+0x0/0x20
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa043ae80>]
svc_process+0x110/0x160 [sunrpc]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0557b52>] nfsd+0xc2/0x160
[nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0557a90>] ? nfsd+0x0/0x160
[nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8109aee6>] kthread+0x96/0xa0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8100c20a>] child_rip+0xa/0x20
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8109ae50>] ? kthread+0x0/0xa0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8100c200>] ?
child_rip+0x0/0x20
May  2 17:49:39 nzhmlfpr010 kernel: INFO: task nfsd:2532 blocked for more
than 120 seconds.
May  2 17:49:39 nzhmlfpr010 kernel:      Not tainted
2.6.32-431.5.1.el6.x86_64 #1
May  2 17:49:39 nzhmlfpr010 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May  2 17:49:39 nzhmlfpr010 kernel: nfsd          D 0000000000000008     0
2532      2 0x00000080
May  2 17:49:39 nzhmlfpr010 kernel: ffff88063a073430 0000000000000046
0000000000000000 ffff88063a0735d8
May  2 17:49:39 nzhmlfpr010 kernel: 000000043a0735e4 ffff880638681000
ffff88015a9ed838 00ff88063a073580
May  2 17:49:39 nzhmlfpr010 kernel: ffff8806386fbaf8 ffff88063a073fd8
000000000000fbc8 ffff8806386fbaf8
May  2 17:49:39 nzhmlfpr010 kernel: Call Trace:
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff81528ac5>]
schedule_timeout+0x215/0x2e0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff81529ac2>] __down+0x72/0xb0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>] ?
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff810a1381>] down+0x41/0x50
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0284901>]
xfs_buf_lock+0x51/0x100 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>]
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0284c14>]
xfs_buf_get+0x34/0x1b0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa028529c>]
xfs_buf_read+0x2c/0x100 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa027ac87>]
xfs_trans_read_buf+0x1f7/0x410 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa022faa6>]
xfs_read_agf+0x66/0x1a0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa022fc19>]
xfs_alloc_read_agf+0x39/0xd0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0232642>]
xfs_alloc_fix_freelist+0x432/0x4a0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0278187>] ?
xfs_trans_add_item+0x57/0x70 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0274938>] ?
xfs_perag_get+0x38/0xb0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0232bb6>]
xfs_alloc_vextent+0x3d6/0x610 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa025e453>]
xfs_ialloc_ag_alloc+0x143/0x4e0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa025e8cf>]
xfs_dialloc+0xdf/0x850 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8144b4d4>] ?
release_sock+0xe4/0xf0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff814a4aa1>] ?
tcp_recvmsg+0x821/0xe80
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0262980>]
xfs_ialloc+0x60/0x6e0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa028006a>] ?
kmem_zone_zalloc+0x3a/0x50 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa027b814>]
xfs_dir_ialloc+0x74/0x2b0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa027d8f0>]
xfs_create+0x440/0x640 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa028aa3d>]
xfs_vn_mknod+0xad/0x1c0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa028ab80>]
xfs_vn_create+0x10/0x20 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff811983b6>]
vfs_create+0xe6/0x110
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa055f3d5>]
nfsd_create_v3+0x3d5/0x530 [nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0566c13>]
nfsd3_proc_create+0x123/0x1b0 [nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0557425>]
nfsd_dispatch+0xe5/0x230 [nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa043a844>]
svc_process_common+0x344/0x640 [sunrpc]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff81065df0>] ?
default_wake_function+0x0/0x20
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa043ae80>]
svc_process+0x110/0x160 [sunrpc]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0557b52>] nfsd+0xc2/0x160
[nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0557a90>] ? nfsd+0x0/0x160
[nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8109aee6>] kthread+0x96/0xa0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8100c20a>] child_rip+0xa/0x20
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8109ae50>] ? kthread+0x0/0xa0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8100c200>] ?
child_rip+0x0/0x20
May  2 17:49:39 nzhmlfpr010 kernel: INFO: task nfsd:2533 blocked for more
than 120 seconds.
May  2 17:49:39 nzhmlfpr010 kernel:      Not tainted
2.6.32-431.5.1.el6.x86_64 #1
May  2 17:49:39 nzhmlfpr010 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May  2 17:49:39 nzhmlfpr010 kernel: nfsd          D 0000000000000008     0
2533      2 0x00000080
May  2 17:49:39 nzhmlfpr010 kernel: ffff880623f7d8d0 0000000000000046
0000000000000000 ffff880623f7d894
May  2 17:49:39 nzhmlfpr010 kernel: ffff880200000000 ffff88033fc25300
ffff880028276840 0000000000000400
May  2 17:49:39 nzhmlfpr010 kernel: ffff88063875bab8 ffff880623f7dfd8
000000000000fbc8 ffff88063875bab8
May  2 17:49:39 nzhmlfpr010 kernel: Call Trace:
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff81528ac5>]
schedule_timeout+0x215/0x2e0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0245208>] ?
xfs_bmbt_get_all+0x18/0x20 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa023b42d>] ?
xfs_bmap_search_multi_extents+0xad/0x120 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff81529ac2>] __down+0x72/0xb0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>] ?
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff810a1381>] down+0x41/0x50
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0284901>]
xfs_buf_lock+0x51/0x100 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>]
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0284c14>]
xfs_buf_get+0x34/0x1b0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa028529c>]
xfs_buf_read+0x2c/0x100 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa027ac87>]
xfs_trans_read_buf+0x1f7/0x410 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa025d164>]
xfs_read_agi+0x74/0x100 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa026342b>]
xfs_iunlink+0x4b/0x170 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff810792c7>] ?
current_fs_time+0x27/0x30
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa027b427>] ?
xfs_trans_ichgtime+0x27/0xb0 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa027b78b>]
xfs_droplink+0x5b/0x70 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa027d1ce>]
xfs_remove+0x27e/0x390 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff811a3767>] ?
__d_lookup+0xa7/0x150
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff81196203>] ?
generic_permission+0x23/0xb0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa028aca8>]
xfs_vn_unlink+0x48/0x90 [xfs]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff811979a2>]
vfs_unlink+0xa2/0xf0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa055ef5f>]
nfsd_unlink+0x1af/0x250 [nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa056369f>] ?
nfsd_cache_lookup+0x59f/0x700 [nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa05665d3>]
nfsd3_proc_remove+0x83/0x120 [nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0557425>]
nfsd_dispatch+0xe5/0x230 [nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa043a844>]
svc_process_common+0x344/0x640 [sunrpc]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff81065df0>] ?
default_wake_function+0x0/0x20
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa043ae80>]
svc_process+0x110/0x160 [sunrpc]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0557b52>] nfsd+0xc2/0x160
[nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffffa0557a90>] ? nfsd+0x0/0x160
[nfsd]
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8109aee6>] kthread+0x96/0xa0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8100c20a>] child_rip+0xa/0x20
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8109ae50>] ? kthread+0x0/0xa0
May  2 17:49:39 nzhmlfpr010 kernel: [<ffffffff8100c200>] ?
child_rip+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:2527 blocked for more
than 120 seconds.
May  2 17:51:39 nzhmlfpr010 kernel:      Not tainted
2.6.32-431.5.1.el6.x86_64 #1
May  2 17:51:39 nzhmlfpr010 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May  2 17:51:39 nzhmlfpr010 kernel: nfsd          D 0000000000000000     0
2527      2 0x00000080
May  2 17:51:39 nzhmlfpr010 kernel: ffff880623ea1600 0000000000000046
0000000000000000 ffffffff8105afee
May  2 17:51:39 nzhmlfpr010 kernel: ffff880623ea1670 ffff880623ea15e0
ffff880623ea1748 0000000200001000
May  2 17:51:39 nzhmlfpr010 kernel: ffff880623e43098 ffff880623ea1fd8
000000000000fbc8 ffff880623e43098
May  2 17:51:39 nzhmlfpr010 kernel: Call Trace:
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8105afee>] ?
find_busiest_group+0x90e/0x9f0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81528ac5>]
schedule_timeout+0x215/0x2e0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa03cea95>] ?
__nf_ct_refresh_acct+0xe5/0x100 [nf_conntrack]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81529ac2>] __down+0x72/0xb0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>] ?
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff810a1381>] down+0x41/0x50
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284901>]
xfs_buf_lock+0x51/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>]
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284c14>]
xfs_buf_get+0x34/0x1b0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028529c>]
xfs_buf_read+0x2c/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027ac27>]
xfs_trans_read_buf+0x197/0x410 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d164>]
xfs_read_agi+0x74/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d21e>]
xfs_ialloc_read_agi+0x2e/0x90 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d8fe>]
xfs_imap_lookup+0x3e/0x170 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8116ecf0>] ?
cache_alloc_refill+0x1c0/0x240
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025dbfe>]
xfs_imap+0x1ce/0x280 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa02650f0>]
xfs_iread+0x40/0x1b0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff811a59de>] ?
inode_init_always+0x11e/0x1c0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025fc8e>]
xfs_iget+0x27e/0x6e0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff814b121f>] ?
tcp_event_new_data_sent+0x4f/0x110
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa02860a6>]
xfs_nfs_get_inode+0x46/0xe0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0444860>] ?
cache_check+0x60/0x360 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028621b>]
xfs_fs_fh_to_dentry+0x8b/0x90 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa015271c>]
exportfs_decode_fh+0x5c/0x2bc [exportfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa055a800>] ?
nfsd_acceptable+0x0/0x120 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0444860>] ?
cache_check+0x60/0x360 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0560712>] ?
exp_find_key+0x62/0xb0 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff810ec17e>] ?
rcu_start_gp+0x1be/0x230
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa055acfa>]
fh_verify+0x32a/0x640 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa056a7c0>]
nfsd4_putfh+0x50/0x60 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa056a458>]
nfsd4_proc_compound+0x3d8/0x490 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557425>]
nfsd_dispatch+0xe5/0x230 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043a844>]
svc_process_common+0x344/0x640 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81065df0>] ?
default_wake_function+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043ae80>]
svc_process+0x110/0x160 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557b52>] nfsd+0xc2/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557a90>] ? nfsd+0x0/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109aee6>] kthread+0x96/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c20a>] child_rip+0xa/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109ae50>] ? kthread+0x0/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c200>] ?
child_rip+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:2528 blocked for more
than 120 seconds.
May  2 17:51:39 nzhmlfpr010 kernel:      Not tainted
2.6.32-431.5.1.el6.x86_64 #1
May  2 17:51:39 nzhmlfpr010 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May  2 17:51:39 nzhmlfpr010 kernel: nfsd          D 0000000000000008     0
2528      2 0x00000080
May  2 17:51:39 nzhmlfpr010 kernel: ffff880623ed75e0 0000000000000046
ffff88033745c0f0 0000000019bfcc00
May  2 17:51:39 nzhmlfpr010 kernel: ffff880623ed7690 ffffffffa03d4b5b
0007fffffffff07f ffffffff00000000
May  2 17:51:39 nzhmlfpr010 kernel: ffff880623d6daf8 ffff880623ed7fd8
000000000000fbc8 ffff880623d6daf8
May  2 17:51:39 nzhmlfpr010 kernel: Call Trace:
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa03d4b5b>] ?
tcp_packet+0x68b/0x1750 [nf_conntrack]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81528ac5>]
schedule_timeout+0x215/0x2e0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81086036>] ?
mod_timer_pending+0x126/0x200
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81297e28>] ?
swiotlb_dma_mapping_error+0x18/0x30
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81529ac2>] __down+0x72/0xb0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>] ?
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff810a1381>] down+0x41/0x50
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284901>]
xfs_buf_lock+0x51/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>]
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284c14>]
xfs_buf_get+0x34/0x1b0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028529c>]
xfs_buf_read+0x2c/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027ac87>]
xfs_trans_read_buf+0x1f7/0x410 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d164>]
xfs_read_agi+0x74/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d21e>]
xfs_ialloc_read_agi+0x2e/0x90 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d503>]
xfs_ialloc_ag_select+0x133/0x270 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025ebc7>]
xfs_dialloc+0x3d7/0x850 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8116ec8b>] ?
cache_alloc_refill+0x15b/0x240
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0262980>]
xfs_ialloc+0x60/0x6e0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028006a>] ?
kmem_zone_zalloc+0x3a/0x50 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027b814>]
xfs_dir_ialloc+0x74/0x2b0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027d8f0>]
xfs_create+0x440/0x640 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028aa3d>]
xfs_vn_mknod+0xad/0x1c0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028ab80>]
xfs_vn_create+0x10/0x20 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff811983b6>]
vfs_create+0xe6/0x110
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa055f3d5>]
nfsd_create_v3+0x3d5/0x530 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0566c13>]
nfsd3_proc_create+0x123/0x1b0 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557425>]
nfsd_dispatch+0xe5/0x230 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043a844>]
svc_process_common+0x344/0x640 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81065df0>] ?
default_wake_function+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043ae80>]
svc_process+0x110/0x160 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557b52>] nfsd+0xc2/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557a90>] ? nfsd+0x0/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109aee6>] kthread+0x96/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c20a>] child_rip+0xa/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109ae50>] ? kthread+0x0/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c200>] ?
child_rip+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:2529 blocked for more
than 120 seconds.
May  2 17:51:39 nzhmlfpr010 kernel:      Not tainted
2.6.32-431.5.1.el6.x86_64 #1
May  2 17:51:39 nzhmlfpr010 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May  2 17:51:39 nzhmlfpr010 kernel: nfsd          D 0000000000000008     0
2529      2 0x00000080
May  2 17:51:39 nzhmlfpr010 kernel: ffff8806384c95e0 0000000000000046
0000000000001000 0000000000000000
May  2 17:51:39 nzhmlfpr010 kernel: 000000000026b000 000000000026c000
0000000000000100 ffffffffffffffff
May  2 17:51:39 nzhmlfpr010 kernel: ffff880623df3ab8 ffff8806384c9fd8
000000000000fbc8 ffff880623df3ab8
May  2 17:51:39 nzhmlfpr010 kernel: Call Trace:
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81528ac5>]
schedule_timeout+0x215/0x2e0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81086036>] ?
mod_timer_pending+0x126/0x200
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa03cea95>] ?
__nf_ct_refresh_acct+0xe5/0x100 [nf_conntrack]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81529ac2>] __down+0x72/0xb0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>] ?
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff810a1381>] down+0x41/0x50
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284901>]
xfs_buf_lock+0x51/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>]
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284c14>]
xfs_buf_get+0x34/0x1b0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028529c>]
xfs_buf_read+0x2c/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027ac87>]
xfs_trans_read_buf+0x1f7/0x410 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d164>]
xfs_read_agi+0x74/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d21e>]
xfs_ialloc_read_agi+0x2e/0x90 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d503>]
xfs_ialloc_ag_select+0x133/0x270 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025ebc7>]
xfs_dialloc+0x3d7/0x850 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8144b4d4>] ?
release_sock+0xe4/0xf0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff814a4aa1>] ?
tcp_recvmsg+0x821/0xe80
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0262980>]
xfs_ialloc+0x60/0x6e0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028006a>] ?
kmem_zone_zalloc+0x3a/0x50 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027b814>]
xfs_dir_ialloc+0x74/0x2b0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027d8f0>]
xfs_create+0x440/0x640 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028aa3d>]
xfs_vn_mknod+0xad/0x1c0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028ab80>]
xfs_vn_create+0x10/0x20 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff811983b6>]
vfs_create+0xe6/0x110
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa055f3d5>]
nfsd_create_v3+0x3d5/0x530 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0566c13>]
nfsd3_proc_create+0x123/0x1b0 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557425>]
nfsd_dispatch+0xe5/0x230 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043a844>]
svc_process_common+0x344/0x640 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81065df0>] ?
default_wake_function+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043ae80>]
svc_process+0x110/0x160 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557b52>] nfsd+0xc2/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557a90>] ? nfsd+0x0/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109aee6>] kthread+0x96/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c20a>] child_rip+0xa/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109ae50>] ? kthread+0x0/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c200>] ?
child_rip+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:2530 blocked for more
than 120 seconds.
May  2 17:51:39 nzhmlfpr010 kernel:      Not tainted
2.6.32-431.5.1.el6.x86_64 #1
May  2 17:51:39 nzhmlfpr010 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May  2 17:51:39 nzhmlfpr010 kernel: nfsd          D 0000000000000000     0
2530      2 0x00000080
May  2 17:51:39 nzhmlfpr010 kernel: ffff880623fbd600 0000000000000046
0000000000000000 ffffffffa0260e6c
May  2 17:51:39 nzhmlfpr010 kernel: 0000000000800000 0002005a00000004
0000000000000003 0000000000000286
May  2 17:51:39 nzhmlfpr010 kernel: ffff880626601058 ffff880623fbdfd8
000000000000fbc8 ffff880626601058
May  2 17:51:39 nzhmlfpr010 kernel: Call Trace:
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0260e6c>] ?
xfs_iext_bno_to_ext+0x8c/0x170 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81528ac5>]
schedule_timeout+0x215/0x2e0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81529ac2>] __down+0x72/0xb0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>] ?
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff810a1381>] down+0x41/0x50
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284901>]
xfs_buf_lock+0x51/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>]
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284c14>]
xfs_buf_get+0x34/0x1b0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028529c>]
xfs_buf_read+0x2c/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027ac27>]
xfs_trans_read_buf+0x197/0x410 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d164>]
xfs_read_agi+0x74/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d21e>]
xfs_ialloc_read_agi+0x2e/0x90 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d8fe>]
xfs_imap_lookup+0x3e/0x170 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8149a3e8>] ?
ip_finish_output+0x148/0x310
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025dbfe>]
xfs_imap+0x1ce/0x280 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa02650f0>]
xfs_iread+0x40/0x1b0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff811a59de>] ?
inode_init_always+0x11e/0x1c0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025fc8e>]
xfs_iget+0x27e/0x6e0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff814b121f>] ?
tcp_event_new_data_sent+0x4f/0x110
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa02860a6>]
xfs_nfs_get_inode+0x46/0xe0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0444860>] ?
cache_check+0x60/0x360 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028621b>]
xfs_fs_fh_to_dentry+0x8b/0x90 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa015271c>]
exportfs_decode_fh+0x5c/0x2bc [exportfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa055a800>] ?
nfsd_acceptable+0x0/0x120 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0444860>] ?
cache_check+0x60/0x360 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0560712>] ?
exp_find_key+0x62/0xb0 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81068a53>] ?
dequeue_entity+0x113/0x2e0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa055acfa>]
fh_verify+0x32a/0x640 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa044392d>] ?
cache_revisit_request+0x2d/0x120 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa056a7c0>]
nfsd4_putfh+0x50/0x60 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa056a458>]
nfsd4_proc_compound+0x3d8/0x490 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557425>]
nfsd_dispatch+0xe5/0x230 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043a844>]
svc_process_common+0x344/0x640 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81065df0>] ?
default_wake_function+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043ae80>]
svc_process+0x110/0x160 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557b52>] nfsd+0xc2/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557a90>] ? nfsd+0x0/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109aee6>] kthread+0x96/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c20a>] child_rip+0xa/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109ae50>] ? kthread+0x0/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c200>] ?
child_rip+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:2531 blocked for more
than 120 seconds.
May  2 17:51:39 nzhmlfpr010 kernel:      Not tainted
2.6.32-431.5.1.el6.x86_64 #1
May  2 17:51:39 nzhmlfpr010 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May  2 17:51:39 nzhmlfpr010 kernel: nfsd          D 0000000000000008     0
2531      2 0x00000080
May  2 17:51:39 nzhmlfpr010 kernel: ffff880623131c80 0000000000000046
0000000000000000 00000000329ac000
May  2 17:51:39 nzhmlfpr010 kernel: ffff880338a05200 0000000000000001
ffff8803330c3d88 ffff8803330c3d88
May  2 17:51:39 nzhmlfpr010 kernel: ffff880623d91ab8 ffff880623131fd8
000000000000fbc8 ffff880623d91ab8
May  2 17:51:39 nzhmlfpr010 kernel: Call Trace:
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8152938e>]
__mutex_lock_slowpath+0x13e/0x180
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8152922b>]
mutex_lock+0x2b/0x50
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa055f102>]
nfsd_create_v3+0x102/0x530 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0566c13>]
nfsd3_proc_create+0x123/0x1b0 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557425>]
nfsd_dispatch+0xe5/0x230 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043a844>]
svc_process_common+0x344/0x640 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81065df0>] ?
default_wake_function+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043ae80>]
svc_process+0x110/0x160 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557b52>] nfsd+0xc2/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557a90>] ? nfsd+0x0/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109aee6>] kthread+0x96/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c20a>] child_rip+0xa/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109ae50>] ? kthread+0x0/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c200>] ?
child_rip+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:2532 blocked for more
than 120 seconds.
May  2 17:51:39 nzhmlfpr010 kernel:      Not tainted
2.6.32-431.5.1.el6.x86_64 #1
May  2 17:51:39 nzhmlfpr010 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May  2 17:51:39 nzhmlfpr010 kernel: nfsd          D 0000000000000008     0
2532      2 0x00000080
May  2 17:51:39 nzhmlfpr010 kernel: ffff88063a073430 0000000000000046
0000000000000000 ffff88063a0735d8
May  2 17:51:39 nzhmlfpr010 kernel: 000000043a0735e4 ffff880638681000
ffff88015a9ed838 00ff88063a073580
May  2 17:51:39 nzhmlfpr010 kernel: ffff8806386fbaf8 ffff88063a073fd8
000000000000fbc8 ffff8806386fbaf8
May  2 17:51:39 nzhmlfpr010 kernel: Call Trace:
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81528ac5>]
schedule_timeout+0x215/0x2e0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81529ac2>] __down+0x72/0xb0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>] ?
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff810a1381>] down+0x41/0x50
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284901>]
xfs_buf_lock+0x51/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>]
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284c14>]
xfs_buf_get+0x34/0x1b0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028529c>]
xfs_buf_read+0x2c/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027ac87>]
xfs_trans_read_buf+0x1f7/0x410 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa022faa6>]
xfs_read_agf+0x66/0x1a0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa022fc19>]
xfs_alloc_read_agf+0x39/0xd0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0232642>]
xfs_alloc_fix_freelist+0x432/0x4a0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0278187>] ?
xfs_trans_add_item+0x57/0x70 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0274938>] ?
xfs_perag_get+0x38/0xb0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0232bb6>]
xfs_alloc_vextent+0x3d6/0x610 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025e453>]
xfs_ialloc_ag_alloc+0x143/0x4e0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025e8cf>]
xfs_dialloc+0xdf/0x850 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8144b4d4>] ?
release_sock+0xe4/0xf0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff814a4aa1>] ?
tcp_recvmsg+0x821/0xe80
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0262980>]
xfs_ialloc+0x60/0x6e0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028006a>] ?
kmem_zone_zalloc+0x3a/0x50 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027b814>]
xfs_dir_ialloc+0x74/0x2b0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027d8f0>]
xfs_create+0x440/0x640 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028aa3d>]
xfs_vn_mknod+0xad/0x1c0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028ab80>]
xfs_vn_create+0x10/0x20 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff811983b6>]
vfs_create+0xe6/0x110
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa055f3d5>]
nfsd_create_v3+0x3d5/0x530 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0566c13>]
nfsd3_proc_create+0x123/0x1b0 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557425>]
nfsd_dispatch+0xe5/0x230 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043a844>]
svc_process_common+0x344/0x640 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81065df0>] ?
default_wake_function+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043ae80>]
svc_process+0x110/0x160 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557b52>] nfsd+0xc2/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557a90>] ? nfsd+0x0/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109aee6>] kthread+0x96/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c20a>] child_rip+0xa/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109ae50>] ? kthread+0x0/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c200>] ?
child_rip+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:2533 blocked for more
than 120 seconds.
May  2 17:51:39 nzhmlfpr010 kernel:      Not tainted
2.6.32-431.5.1.el6.x86_64 #1
May  2 17:51:39 nzhmlfpr010 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May  2 17:51:39 nzhmlfpr010 kernel: nfsd          D 0000000000000008     0
2533      2 0x00000080
May  2 17:51:39 nzhmlfpr010 kernel: ffff880623f7d8d0 0000000000000046
0000000000000000 ffff880623f7d894
May  2 17:51:39 nzhmlfpr010 kernel: ffff880200000000 ffff88033fc25300
ffff880028276840 0000000000000400
May  2 17:51:39 nzhmlfpr010 kernel: ffff88063875bab8 ffff880623f7dfd8
000000000000fbc8 ffff88063875bab8
May  2 17:51:39 nzhmlfpr010 kernel: Call Trace:
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81528ac5>]
schedule_timeout+0x215/0x2e0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0245208>] ?
xfs_bmbt_get_all+0x18/0x20 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa023b42d>] ?
xfs_bmap_search_multi_extents+0xad/0x120 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81529ac2>] __down+0x72/0xb0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>] ?
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff810a1381>] down+0x41/0x50
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284901>]
xfs_buf_lock+0x51/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284a95>]
_xfs_buf_find+0xe5/0x230 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0284c14>]
xfs_buf_get+0x34/0x1b0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028529c>]
xfs_buf_read+0x2c/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027ac87>]
xfs_trans_read_buf+0x1f7/0x410 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa025d164>]
xfs_read_agi+0x74/0x100 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa026342b>]
xfs_iunlink+0x4b/0x170 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff810792c7>] ?
current_fs_time+0x27/0x30
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027b427>] ?
xfs_trans_ichgtime+0x27/0xb0 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027b78b>]
xfs_droplink+0x5b/0x70 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa027d1ce>]
xfs_remove+0x27e/0x390 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff811a3767>] ?
__d_lookup+0xa7/0x150
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81196203>] ?
generic_permission+0x23/0xb0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa028aca8>]
xfs_vn_unlink+0x48/0x90 [xfs]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff811979a2>]
vfs_unlink+0xa2/0xf0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa055ef5f>]
nfsd_unlink+0x1af/0x250 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa056369f>] ?
nfsd_cache_lookup+0x59f/0x700 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa05665d3>]
nfsd3_proc_remove+0x83/0x120 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557425>]
nfsd_dispatch+0xe5/0x230 [nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043a844>]
svc_process_common+0x344/0x640 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff81065df0>] ?
default_wake_function+0x0/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa043ae80>]
svc_process+0x110/0x160 [sunrpc]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557b52>] nfsd+0xc2/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffffa0557a90>] ? nfsd+0x0/0x160
[nfsd]
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109aee6>] kthread+0x96/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c20a>] child_rip+0xa/0x20
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8109ae50>] ? kthread+0x0/0xa0
May  2 17:51:39 nzhmlfpr010 kernel: [<ffffffff8100c200>] ?
child_rip+0x0/0x20


Thank you

--047d7b6743a21eb78104f8c1cb9a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi. </div><div>=C2=A0</div><div>I have a file server =
that has had 2 xfs Kernel trace dumps about 2 weeks apart.=C2=A0=C2=A0</div=
><div>=C2=A0</div><div>The RAID 60 data store is mounted as /home with xfs =
as the file system. The /home space is=C2=A0shares via=C2=A0NFS export=C2=
=A0and=C2=A0CIFS share.=C2=A0 At the time of the=C2=A0Trace dumps=C2=A0NFS =
access hangs and crashed users sessions on the client side.=C2=A0=C2=A0The=
=C2=A0output=C2=A0of the last traces is below.=C2=A0</div>
<div>=C2=A0</div><div>Can you advise as to the cause=C2=A0of this dump and =
possible resolution ?=C2=A0=C2=A0=C2=A0</div><div>=C2=A0</div><div>System i=
nformation: </div><div><br>CentOS release 6.5 (Final)</div><div>=C2=A0</div=
><div>Physical </div><div>24 GB Ram</div>
<div>Intel(R) Xeon(R) CPU=C2=A0=C2=A0X5560=C2=A0 @ 2.80GHz</div><div>2 x RA=
ID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04) </d=
iv><div>RAID configured in RAID 6 with software RAID 0 providing final RAID=
 60</div><div>
=C2=A0</div><div>Kernel 2.6.32-431.5.1.el6.x86_64<br>xfsdump-3.0.4-3.el6.x8=
6_64<br>xfsprogs-3.1.1-14.el6.x86_64</div><div>nfs-utils-1.2.3-39.el6.x86_6=
4<br>nfs4-acl-tools-0.3.3-6.el6.x86_64<br>nfs-utils-lib-1.1.5-6.el6.x86_64<=
br>
 samba-common-3.6.9-168.el6_5.x86_64<br>samba4-libs-4.0.0-61.el6_5.rc4.x86_=
64<br>samba-3.6.9-168.el6_5.x86_64<br>samba-winbind-clients-3.6.9-168.el6_5=
.x86_64<br>samba-client-3.6.9-168.el6_5.x86_64<br>samba-winbind-3.6.9-168.e=
l6_5.x86_64<br>
</div><div>=C2=A0</div><div>[root@nzhmlfpr010 ~]# df -h<br>Filesystem=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=C2=A0 Use=
d Avail Use% Mounted on<br>/dev/sdc2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 97G=C2=A0 3.2G=C2=A0=C2=A0 89G=C2=
=A0=C2=A0 4% /<br>tmpfs=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 12G=C2=A0=C2=A0=C2=A0=
=C2=A0 0=C2=A0=C2=A0 12G=C2=A0=C2=A0 0% /dev/shm<br>/dev/sdc1=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 504M=C2=A0 100=
M=C2=A0 379M=C2=A0 21% /boot<br>
 /dev/md0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 11T=C2=A0 1.7T=C2=A0 9.3T=C2=A0 15% /home</div><div>=C2=
=A0</div><div>[root@nzhmlfpr010 ~]# cat /proc/mdstat<br>Personalities : [ra=
id0]<br>md0 : active raid0 sdb1[1] sda1[0]<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 11707018240 blocks super 1.1 512k chunks</div>
<div>unused devices: &lt;none&gt;<br></div><div>=C2=A0</div><div>Kernel tra=
ces:</div><div>=C2=A0</div><div>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: IN=
FO: task nfsd:2529 blocked for more than 120 seconds.<br>May=C2=A0 2 17:49:=
39 nzhmlfpr010 kernel:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Not tainted 2.6.32-431=
.5.1.el6.x86_64 #1<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: &quot;echo 0 &gt; /proc/sys/kerne=
l/hung_task_timeout_secs&quot; disables this message.<br>May=C2=A0 2 17:49:=
39 nzhmlfpr010 kernel: nfsd=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 D 0000000000000008=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0 2529=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 2 0x00000080<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: ffff8806384c95e0 0000000000000046=
 0000000000001000 0000000000000000<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kern=
el: 000000000026b000 000000000026c000 0000000000000100 ffffffffffffffff<br>=
May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: ffff880623df3ab8 ffff8806384c9fd8 =
000000000000fbc8 ffff880623df3ab8<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: Call Trace:<br>May=C2=A0 2 17:49:=
39 nzhmlfpr010 kernel: [&lt;ffffffff81528ac5&gt;] schedule_timeout+0x215/0x=
2e0<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff81086036&gt;] =
? mod_timer_pending+0x126/0x200<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa03cea95&gt;] ? __nf=
_ct_refresh_acct+0xe5/0x100 [nf_conntrack]<br>May=C2=A0 2 17:49:39 nzhmlfpr=
010 kernel: [&lt;ffffffff81529ac2&gt;] __down+0x72/0xb0<br>May=C2=A0 2 17:4=
9:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] ? _xfs_buf_find+0xe5/0x=
230 [xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff810a1381&gt;] down+0=
x41/0x50<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284901&=
gt;] xfs_buf_lock+0x51/0x100 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kern=
el: [&lt;ffffffffa0284a95&gt;] _xfs_buf_find+0xe5/0x230 [xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284c14&gt;] xfs_bu=
f_get+0x34/0x1b0 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;fff=
fffffa028529c&gt;] xfs_buf_read+0x2c/0x100 [xfs]<br>May=C2=A0 2 17:49:39 nz=
hmlfpr010 kernel: [&lt;ffffffffa027ac87&gt;] xfs_trans_read_buf+0x1f7/0x410=
 [xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa025d164&gt;] xfs_re=
ad_agi+0x74/0x100 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ff=
ffffffa025d21e&gt;] xfs_ialloc_read_agi+0x2e/0x90 [xfs]<br>May=C2=A0 2 17:4=
9:39 nzhmlfpr010 kernel: [&lt;ffffffffa025d503&gt;] xfs_ialloc_ag_select+0x=
133/0x270 [xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa025ebc7&gt;] xfs_di=
alloc+0x3d7/0x850 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ff=
ffffff8144b4d4&gt;] ? release_sock+0xe4/0xf0<br>May=C2=A0 2 17:49:39 nzhmlf=
pr010 kernel: [&lt;ffffffff814a4aa1&gt;] ? tcp_recvmsg+0x821/0xe80<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0262980&gt;] xfs_ia=
lloc+0x60/0x6e0 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffff=
ffffa028006a&gt;] ? kmem_zone_zalloc+0x3a/0x50 [xfs]<br>May=C2=A0 2 17:49:3=
9 nzhmlfpr010 kernel: [&lt;ffffffffa027b814&gt;] xfs_dir_ialloc+0x74/0x2b0 =
[xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa027d8f0&gt;] xfs_cr=
eate+0x440/0x640 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;fff=
fffffa028aa3d&gt;] xfs_vn_mknod+0xad/0x1c0 [xfs]<br>May=C2=A0 2 17:49:39 nz=
hmlfpr010 kernel: [&lt;ffffffffa028ab80&gt;] xfs_vn_create+0x10/0x20 [xfs]<=
br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff811983b6&gt;] vfs_cr=
eate+0xe6/0x110<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0=
55f3d5&gt;] nfsd_create_v3+0x3d5/0x530 [nfsd]<br>May=C2=A0 2 17:49:39 nzhml=
fpr010 kernel: [&lt;ffffffffa0566c13&gt;] nfsd3_proc_create+0x123/0x1b0 [nf=
sd]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557425&gt;] nfsd_d=
ispatch+0xe5/0x230 [nfsd]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;=
ffffffffa043a844&gt;] svc_process_common+0x344/0x640 [sunrpc]<br>May=C2=A0 =
2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff81065df0&gt;] ? default_wake_fu=
nction+0x0/0x20<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa043ae80&gt;] svc_pr=
ocess+0x110/0x160 [sunrpc]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt=
;ffffffffa0557b52&gt;] nfsd+0xc2/0x160 [nfsd]<br>May=C2=A0 2 17:49:39 nzhml=
fpr010 kernel: [&lt;ffffffffa0557a90&gt;] ? nfsd+0x0/0x160 [nfsd]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff8109aee6&gt;] kthrea=
d+0x96/0xa0<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c2=
0a&gt;] child_rip+0xa/0x20<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt=
;ffffffff8109ae50&gt;] ? kthread+0x0/0xa0<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c200&gt;] ? chil=
d_rip+0x0/0x20<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: INFO: task nfsd:=
2532 blocked for more than 120 seconds.<br>May=C2=A0 2 17:49:39 nzhmlfpr010=
 kernel:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Not tainted 2.6.32-431.5.1.el6.x86_6=
4 #1<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: &quot;echo 0 &gt; /proc/sys/kerne=
l/hung_task_timeout_secs&quot; disables this message.<br>May=C2=A0 2 17:49:=
39 nzhmlfpr010 kernel: nfsd=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 D 0000000000000008=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0 2532=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 2 0x00000080<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: ffff88063a073430 0000000000000046=
 0000000000000000 ffff88063a0735d8<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kern=
el: 000000043a0735e4 ffff880638681000 ffff88015a9ed838 00ff88063a073580<br>=
May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: ffff8806386fbaf8 ffff88063a073fd8 =
000000000000fbc8 ffff8806386fbaf8<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: Call Trace:<br>May=C2=A0 2 17:49:=
39 nzhmlfpr010 kernel: [&lt;ffffffff81528ac5&gt;] schedule_timeout+0x215/0x=
2e0<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff81529ac2&gt;] =
__down+0x72/0xb0<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] ? _xfs=
_buf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt=
;ffffffff810a1381&gt;] down+0x41/0x50<br>May=C2=A0 2 17:49:39 nzhmlfpr010 k=
ernel: [&lt;ffffffffa0284901&gt;] xfs_buf_lock+0x51/0x100 [xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] _xfs_b=
uf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;f=
fffffffa0284c14&gt;] xfs_buf_get+0x34/0x1b0 [xfs]<br>May=C2=A0 2 17:49:39 n=
zhmlfpr010 kernel: [&lt;ffffffffa028529c&gt;] xfs_buf_read+0x2c/0x100 [xfs]=
<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa027ac87&gt;] xfs_tr=
ans_read_buf+0x1f7/0x410 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: =
[&lt;ffffffffa022faa6&gt;] xfs_read_agf+0x66/0x1a0 [xfs]<br>May=C2=A0 2 17:=
49:39 nzhmlfpr010 kernel: [&lt;ffffffffa022fc19&gt;] xfs_alloc_read_agf+0x3=
9/0xd0 [xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0232642&gt;] xfs_al=
loc_fix_freelist+0x432/0x4a0 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kern=
el: [&lt;ffffffffa0278187&gt;] ? xfs_trans_add_item+0x57/0x70 [xfs]<br>May=
=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0274938&gt;] ? xfs_pera=
g_get+0x38/0xb0 [xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0232bb6&gt;] xfs_al=
loc_vextent+0x3d6/0x610 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [=
&lt;ffffffffa025e453&gt;] xfs_ialloc_ag_alloc+0x143/0x4e0 [xfs]<br>May=C2=
=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa025e8cf&gt;] xfs_dialloc+0=
xdf/0x850 [xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff8144b4d4&gt;] ? rele=
ase_sock+0xe4/0xf0<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;fffffff=
f814a4aa1&gt;] ? tcp_recvmsg+0x821/0xe80<br>May=C2=A0 2 17:49:39 nzhmlfpr01=
0 kernel: [&lt;ffffffffa0262980&gt;] xfs_ialloc+0x60/0x6e0 [xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa028006a&gt;] ? kmem=
_zone_zalloc+0x3a/0x50 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&=
lt;ffffffffa027b814&gt;] xfs_dir_ialloc+0x74/0x2b0 [xfs]<br>May=C2=A0 2 17:=
49:39 nzhmlfpr010 kernel: [&lt;ffffffffa027d8f0&gt;] xfs_create+0x440/0x640=
 [xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa028aa3d&gt;] xfs_vn=
_mknod+0xad/0x1c0 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ff=
ffffffa028ab80&gt;] xfs_vn_create+0x10/0x20 [xfs]<br>May=C2=A0 2 17:49:39 n=
zhmlfpr010 kernel: [&lt;ffffffff811983b6&gt;] vfs_create+0xe6/0x110<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa055f3d5&gt;] nfsd_c=
reate_v3+0x3d5/0x530 [nfsd]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&l=
t;ffffffffa0566c13&gt;] nfsd3_proc_create+0x123/0x1b0 [nfsd]<br>May=C2=A0 2=
 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557425&gt;] nfsd_dispatch+0xe5=
/0x230 [nfsd]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa043a844&gt;] svc_pr=
ocess_common+0x344/0x640 [sunrpc]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kerne=
l: [&lt;ffffffff81065df0&gt;] ? default_wake_function+0x0/0x20<br>May=C2=A0=
 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa043ae80&gt;] svc_process+0x11=
0/0x160 [sunrpc]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557b52&gt;] nfsd+0=
xc2/0x160 [nfsd]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa=
0557a90&gt;] ? nfsd+0x0/0x160 [nfsd]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 ke=
rnel: [&lt;ffffffff8109aee6&gt;] kthread+0x96/0xa0<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c20a&gt;] child_=
rip+0xa/0x20<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff8109a=
e50&gt;] ? kthread+0x0/0xa0<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&l=
t;ffffffff8100c200&gt;] ? child_rip+0x0/0x20<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: INFO: task nfsd:2533 blocked for =
more than 120 seconds.<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel:=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 Not tainted 2.6.32-431.5.1.el6.x86_64 #1<br>May=C2=A0=
 2 17:49:39 nzhmlfpr010 kernel: &quot;echo 0 &gt; /proc/sys/kernel/hung_tas=
k_timeout_secs&quot; disables this message.<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: nfsd=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 D 0000000000000008=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=
=A0 2533=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2 0x00000080<br>May=C2=A0 2 17:49:39=
 nzhmlfpr010 kernel: ffff880623f7d8d0 0000000000000046 0000000000000000 fff=
f880623f7d894<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: ffff880200000000 =
ffff88033fc25300 ffff880028276840 0000000000000400<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: ffff88063875bab8 ffff880623f7dfd8=
 000000000000fbc8 ffff88063875bab8<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kern=
el: Call Trace:<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff81=
528ac5&gt;] schedule_timeout+0x215/0x2e0<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0245208&gt;] ? xfs_=
bmbt_get_all+0x18/0x20 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&=
lt;ffffffffa023b42d&gt;] ? xfs_bmap_search_multi_extents+0xad/0x120 [xfs]<b=
r>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff81529ac2&gt;] __dow=
n+0x72/0xb0<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] ? _xfs=
_buf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt=
;ffffffff810a1381&gt;] down+0x41/0x50<br>May=C2=A0 2 17:49:39 nzhmlfpr010 k=
ernel: [&lt;ffffffffa0284901&gt;] xfs_buf_lock+0x51/0x100 [xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] _xfs_b=
uf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;f=
fffffffa0284c14&gt;] xfs_buf_get+0x34/0x1b0 [xfs]<br>May=C2=A0 2 17:49:39 n=
zhmlfpr010 kernel: [&lt;ffffffffa028529c&gt;] xfs_buf_read+0x2c/0x100 [xfs]=
<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa027ac87&gt;] xfs_tr=
ans_read_buf+0x1f7/0x410 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: =
[&lt;ffffffffa025d164&gt;] xfs_read_agi+0x74/0x100 [xfs]<br>May=C2=A0 2 17:=
49:39 nzhmlfpr010 kernel: [&lt;ffffffffa026342b&gt;] xfs_iunlink+0x4b/0x170=
 [xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff810792c7&gt;] ? curr=
ent_fs_time+0x27/0x30<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffff=
ffffa027b427&gt;] ? xfs_trans_ichgtime+0x27/0xb0 [xfs]<br>May=C2=A0 2 17:49=
:39 nzhmlfpr010 kernel: [&lt;ffffffffa027b78b&gt;] xfs_droplink+0x5b/0x70 [=
xfs]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa027d1ce&gt;] xfs_re=
move+0x27e/0x390 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;fff=
fffff811a3767&gt;] ? __d_lookup+0xa7/0x150<br>May=C2=A0 2 17:49:39 nzhmlfpr=
010 kernel: [&lt;ffffffff81196203&gt;] ? generic_permission+0x23/0xb0<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa028aca8&gt;] xfs_vn=
_unlink+0x48/0x90 [xfs]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ff=
ffffff811979a2&gt;] vfs_unlink+0xa2/0xf0<br>May=C2=A0 2 17:49:39 nzhmlfpr01=
0 kernel: [&lt;ffffffffa055ef5f&gt;] nfsd_unlink+0x1af/0x250 [nfsd]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa056369f&gt;] ? nfsd=
_cache_lookup+0x59f/0x700 [nfsd]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel=
: [&lt;ffffffffa05665d3&gt;] nfsd3_proc_remove+0x83/0x120 [nfsd]<br>May=C2=
=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557425&gt;] nfsd_dispatch=
+0xe5/0x230 [nfsd]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa043a844&gt;] svc_pr=
ocess_common+0x344/0x640 [sunrpc]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kerne=
l: [&lt;ffffffff81065df0&gt;] ? default_wake_function+0x0/0x20<br>May=C2=A0=
 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa043ae80&gt;] svc_process+0x11=
0/0x160 [sunrpc]<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557b52&gt;] nfsd+0=
xc2/0x160 [nfsd]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffffa=
0557a90&gt;] ? nfsd+0x0/0x160 [nfsd]<br>May=C2=A0 2 17:49:39 nzhmlfpr010 ke=
rnel: [&lt;ffffffff8109aee6&gt;] kthread+0x96/0xa0<br>
 May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c20a&gt;] child_=
rip+0xa/0x20<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&lt;ffffffff8109a=
e50&gt;] ? kthread+0x0/0xa0<br>May=C2=A0 2 17:49:39 nzhmlfpr010 kernel: [&l=
t;ffffffff8100c200&gt;] ? child_rip+0x0/0x20<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:2527 blocked for =
more than 120 seconds.<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel:=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 Not tainted 2.6.32-431.5.1.el6.x86_64 #1<br>May=C2=A0=
 2 17:51:39 nzhmlfpr010 kernel: &quot;echo 0 &gt; /proc/sys/kernel/hung_tas=
k_timeout_secs&quot; disables this message.<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: nfsd=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 D 0000000000000000=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=
=A0 2527=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2 0x00000080<br>May=C2=A0 2 17:51:39=
 nzhmlfpr010 kernel: ffff880623ea1600 0000000000000046 0000000000000000 fff=
fffff8105afee<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff880623ea1670 =
ffff880623ea15e0 ffff880623ea1748 0000000200001000<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff880623e43098 ffff880623ea1fd8=
 000000000000fbc8 ffff880623e43098<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kern=
el: Call Trace:<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81=
05afee&gt;] ? find_busiest_group+0x90e/0x9f0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81528ac5&gt;] schedu=
le_timeout+0x215/0x2e0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;fff=
fffffa03cea95&gt;] ? __nf_ct_refresh_acct+0xe5/0x100 [nf_conntrack]<br>May=
=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81529ac2&gt;] __down+0x7=
2/0xb0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] ? _xfs=
_buf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffff810a1381&gt;] down+0x41/0x50<br>May=C2=A0 2 17:51:39 nzhmlfpr010 k=
ernel: [&lt;ffffffffa0284901&gt;] xfs_buf_lock+0x51/0x100 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] _xfs_b=
uf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;f=
fffffffa0284c14&gt;] xfs_buf_get+0x34/0x1b0 [xfs]<br>May=C2=A0 2 17:51:39 n=
zhmlfpr010 kernel: [&lt;ffffffffa028529c&gt;] xfs_buf_read+0x2c/0x100 [xfs]=
<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa027ac27&gt;] xfs_tr=
ans_read_buf+0x197/0x410 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: =
[&lt;ffffffffa025d164&gt;] xfs_read_agi+0x74/0x100 [xfs]<br>May=C2=A0 2 17:=
51:39 nzhmlfpr010 kernel: [&lt;ffffffffa025d21e&gt;] xfs_ialloc_read_agi+0x=
2e/0x90 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa025d8fe&gt;] xfs_im=
ap_lookup+0x3e/0x170 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffff8116ecf0&gt;] ? cache_alloc_refill+0x1c0/0x240<br>May=C2=A0 2 17:5=
1:39 nzhmlfpr010 kernel: [&lt;ffffffffa025dbfe&gt;] xfs_imap+0x1ce/0x280 [x=
fs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa02650f0&gt;] xfs_ir=
ead+0x40/0x1b0 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;fffff=
fff811a59de&gt;] ? inode_init_always+0x11e/0x1c0<br>May=C2=A0 2 17:51:39 nz=
hmlfpr010 kernel: [&lt;ffffffffa025fc8e&gt;] xfs_iget+0x27e/0x6e0 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff814b121f&gt;] ? tcp_=
event_new_data_sent+0x4f/0x110<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: =
[&lt;ffffffffa02860a6&gt;] xfs_nfs_get_inode+0x46/0xe0 [xfs]<br>May=C2=A0 2=
 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0444860&gt;] ? cache_check+0x60=
/0x360 [sunrpc]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa028621b&gt;] xfs_fs=
_fh_to_dentry+0x8b/0x90 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [=
&lt;ffffffffa015271c&gt;] exportfs_decode_fh+0x5c/0x2bc [exportfs]<br>May=
=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa055a800&gt;] ? nfsd_acc=
eptable+0x0/0x120 [nfsd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0444860&gt;] ? cach=
e_check+0x60/0x360 [sunrpc]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&l=
t;ffffffffa0560712&gt;] ? exp_find_key+0x62/0xb0 [nfsd]<br>May=C2=A0 2 17:5=
1:39 nzhmlfpr010 kernel: [&lt;ffffffff810ec17e&gt;] ? rcu_start_gp+0x1be/0x=
230<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa055acfa&gt;] fh_ver=
ify+0x32a/0x640 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;fff=
fffffa056a7c0&gt;] nfsd4_putfh+0x50/0x60 [nfsd]<br>May=C2=A0 2 17:51:39 nzh=
mlfpr010 kernel: [&lt;ffffffffa056a458&gt;] nfsd4_proc_compound+0x3d8/0x490=
 [nfsd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557425&gt;] nfsd_d=
ispatch+0xe5/0x230 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;=
ffffffffa043a844&gt;] svc_process_common+0x344/0x640 [sunrpc]<br>May=C2=A0 =
2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81065df0&gt;] ? default_wake_fu=
nction+0x0/0x20<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa043ae80&gt;] svc_pr=
ocess+0x110/0x160 [sunrpc]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffffa0557b52&gt;] nfsd+0xc2/0x160 [nfsd]<br>May=C2=A0 2 17:51:39 nzhml=
fpr010 kernel: [&lt;ffffffffa0557a90&gt;] ? nfsd+0x0/0x160 [nfsd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8109aee6&gt;] kthrea=
d+0x96/0xa0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c2=
0a&gt;] child_rip+0xa/0x20<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffff8109ae50&gt;] ? kthread+0x0/0xa0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c200&gt;] ? chil=
d_rip+0x0/0x20<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:=
2528 blocked for more than 120 seconds.<br>May=C2=A0 2 17:51:39 nzhmlfpr010=
 kernel:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Not tainted 2.6.32-431.5.1.el6.x86_6=
4 #1<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: &quot;echo 0 &gt; /proc/sys/kerne=
l/hung_task_timeout_secs&quot; disables this message.<br>May=C2=A0 2 17:51:=
39 nzhmlfpr010 kernel: nfsd=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 D 0000000000000008=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0 2528=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 2 0x00000080<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff880623ed75e0 0000000000000046=
 ffff88033745c0f0 0000000019bfcc00<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kern=
el: ffff880623ed7690 ffffffffa03d4b5b 0007fffffffff07f ffffffff00000000<br>=
May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff880623d6daf8 ffff880623ed7fd8 =
000000000000fbc8 ffff880623d6daf8<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: Call Trace:<br>May=C2=A0 2 17:51:=
39 nzhmlfpr010 kernel: [&lt;ffffffffa03d4b5b&gt;] ? tcp_packet+0x68b/0x1750=
 [nf_conntrack]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81=
528ac5&gt;] schedule_timeout+0x215/0x2e0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81086036&gt;] ? mod_=
timer_pending+0x126/0x200<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;=
ffffffff81297e28&gt;] ? swiotlb_dma_mapping_error+0x18/0x30<br>May=C2=A0 2 =
17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81529ac2&gt;] __down+0x72/0xb0<br=
>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] ? _xfs=
_buf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffff810a1381&gt;] down+0x41/0x50<br>May=C2=A0 2 17:51:39 nzhmlfpr010 k=
ernel: [&lt;ffffffffa0284901&gt;] xfs_buf_lock+0x51/0x100 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] _xfs_b=
uf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;f=
fffffffa0284c14&gt;] xfs_buf_get+0x34/0x1b0 [xfs]<br>May=C2=A0 2 17:51:39 n=
zhmlfpr010 kernel: [&lt;ffffffffa028529c&gt;] xfs_buf_read+0x2c/0x100 [xfs]=
<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa027ac87&gt;] xfs_tr=
ans_read_buf+0x1f7/0x410 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: =
[&lt;ffffffffa025d164&gt;] xfs_read_agi+0x74/0x100 [xfs]<br>May=C2=A0 2 17:=
51:39 nzhmlfpr010 kernel: [&lt;ffffffffa025d21e&gt;] xfs_ialloc_read_agi+0x=
2e/0x90 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa025d503&gt;] xfs_ia=
lloc_ag_select+0x133/0x270 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel=
: [&lt;ffffffffa025ebc7&gt;] xfs_dialloc+0x3d7/0x850 [xfs]<br>May=C2=A0 2 1=
7:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8116ec8b&gt;] ? cache_alloc_refill=
+0x15b/0x240<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0262980&gt;] xfs_ia=
lloc+0x60/0x6e0 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffff=
ffffa028006a&gt;] ? kmem_zone_zalloc+0x3a/0x50 [xfs]<br>May=C2=A0 2 17:51:3=
9 nzhmlfpr010 kernel: [&lt;ffffffffa027b814&gt;] xfs_dir_ialloc+0x74/0x2b0 =
[xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa027d8f0&gt;] xfs_cr=
eate+0x440/0x640 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;fff=
fffffa028aa3d&gt;] xfs_vn_mknod+0xad/0x1c0 [xfs]<br>May=C2=A0 2 17:51:39 nz=
hmlfpr010 kernel: [&lt;ffffffffa028ab80&gt;] xfs_vn_create+0x10/0x20 [xfs]<=
br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff811983b6&gt;] vfs_cr=
eate+0xe6/0x110<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0=
55f3d5&gt;] nfsd_create_v3+0x3d5/0x530 [nfsd]<br>May=C2=A0 2 17:51:39 nzhml=
fpr010 kernel: [&lt;ffffffffa0566c13&gt;] nfsd3_proc_create+0x123/0x1b0 [nf=
sd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557425&gt;] nfsd_d=
ispatch+0xe5/0x230 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;=
ffffffffa043a844&gt;] svc_process_common+0x344/0x640 [sunrpc]<br>May=C2=A0 =
2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81065df0&gt;] ? default_wake_fu=
nction+0x0/0x20<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa043ae80&gt;] svc_pr=
ocess+0x110/0x160 [sunrpc]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffffa0557b52&gt;] nfsd+0xc2/0x160 [nfsd]<br>May=C2=A0 2 17:51:39 nzhml=
fpr010 kernel: [&lt;ffffffffa0557a90&gt;] ? nfsd+0x0/0x160 [nfsd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8109aee6&gt;] kthrea=
d+0x96/0xa0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c2=
0a&gt;] child_rip+0xa/0x20<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffff8109ae50&gt;] ? kthread+0x0/0xa0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c200&gt;] ? chil=
d_rip+0x0/0x20<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:=
2529 blocked for more than 120 seconds.<br>May=C2=A0 2 17:51:39 nzhmlfpr010=
 kernel:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Not tainted 2.6.32-431.5.1.el6.x86_6=
4 #1<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: &quot;echo 0 &gt; /proc/sys/kerne=
l/hung_task_timeout_secs&quot; disables this message.<br>May=C2=A0 2 17:51:=
39 nzhmlfpr010 kernel: nfsd=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 D 0000000000000008=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0 2529=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 2 0x00000080<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff8806384c95e0 0000000000000046=
 0000000000001000 0000000000000000<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kern=
el: 000000000026b000 000000000026c000 0000000000000100 ffffffffffffffff<br>=
May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff880623df3ab8 ffff8806384c9fd8 =
000000000000fbc8 ffff880623df3ab8<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: Call Trace:<br>May=C2=A0 2 17:51:=
39 nzhmlfpr010 kernel: [&lt;ffffffff81528ac5&gt;] schedule_timeout+0x215/0x=
2e0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81086036&gt;] =
? mod_timer_pending+0x126/0x200<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa03cea95&gt;] ? __nf=
_ct_refresh_acct+0xe5/0x100 [nf_conntrack]<br>May=C2=A0 2 17:51:39 nzhmlfpr=
010 kernel: [&lt;ffffffff81529ac2&gt;] __down+0x72/0xb0<br>May=C2=A0 2 17:5=
1:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] ? _xfs_buf_find+0xe5/0x=
230 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff810a1381&gt;] down+0=
x41/0x50<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284901&=
gt;] xfs_buf_lock+0x51/0x100 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kern=
el: [&lt;ffffffffa0284a95&gt;] _xfs_buf_find+0xe5/0x230 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284c14&gt;] xfs_bu=
f_get+0x34/0x1b0 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;fff=
fffffa028529c&gt;] xfs_buf_read+0x2c/0x100 [xfs]<br>May=C2=A0 2 17:51:39 nz=
hmlfpr010 kernel: [&lt;ffffffffa027ac87&gt;] xfs_trans_read_buf+0x1f7/0x410=
 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa025d164&gt;] xfs_re=
ad_agi+0x74/0x100 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ff=
ffffffa025d21e&gt;] xfs_ialloc_read_agi+0x2e/0x90 [xfs]<br>May=C2=A0 2 17:5=
1:39 nzhmlfpr010 kernel: [&lt;ffffffffa025d503&gt;] xfs_ialloc_ag_select+0x=
133/0x270 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa025ebc7&gt;] xfs_di=
alloc+0x3d7/0x850 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ff=
ffffff8144b4d4&gt;] ? release_sock+0xe4/0xf0<br>May=C2=A0 2 17:51:39 nzhmlf=
pr010 kernel: [&lt;ffffffff814a4aa1&gt;] ? tcp_recvmsg+0x821/0xe80<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0262980&gt;] xfs_ia=
lloc+0x60/0x6e0 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffff=
ffffa028006a&gt;] ? kmem_zone_zalloc+0x3a/0x50 [xfs]<br>May=C2=A0 2 17:51:3=
9 nzhmlfpr010 kernel: [&lt;ffffffffa027b814&gt;] xfs_dir_ialloc+0x74/0x2b0 =
[xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa027d8f0&gt;] xfs_cr=
eate+0x440/0x640 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;fff=
fffffa028aa3d&gt;] xfs_vn_mknod+0xad/0x1c0 [xfs]<br>May=C2=A0 2 17:51:39 nz=
hmlfpr010 kernel: [&lt;ffffffffa028ab80&gt;] xfs_vn_create+0x10/0x20 [xfs]<=
br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff811983b6&gt;] vfs_cr=
eate+0xe6/0x110<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0=
55f3d5&gt;] nfsd_create_v3+0x3d5/0x530 [nfsd]<br>May=C2=A0 2 17:51:39 nzhml=
fpr010 kernel: [&lt;ffffffffa0566c13&gt;] nfsd3_proc_create+0x123/0x1b0 [nf=
sd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557425&gt;] nfsd_d=
ispatch+0xe5/0x230 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;=
ffffffffa043a844&gt;] svc_process_common+0x344/0x640 [sunrpc]<br>May=C2=A0 =
2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81065df0&gt;] ? default_wake_fu=
nction+0x0/0x20<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa043ae80&gt;] svc_pr=
ocess+0x110/0x160 [sunrpc]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffffa0557b52&gt;] nfsd+0xc2/0x160 [nfsd]<br>May=C2=A0 2 17:51:39 nzhml=
fpr010 kernel: [&lt;ffffffffa0557a90&gt;] ? nfsd+0x0/0x160 [nfsd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8109aee6&gt;] kthrea=
d+0x96/0xa0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c2=
0a&gt;] child_rip+0xa/0x20<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffff8109ae50&gt;] ? kthread+0x0/0xa0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c200&gt;] ? chil=
d_rip+0x0/0x20<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:=
2530 blocked for more than 120 seconds.<br>May=C2=A0 2 17:51:39 nzhmlfpr010=
 kernel:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Not tainted 2.6.32-431.5.1.el6.x86_6=
4 #1<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: &quot;echo 0 &gt; /proc/sys/kerne=
l/hung_task_timeout_secs&quot; disables this message.<br>May=C2=A0 2 17:51:=
39 nzhmlfpr010 kernel: nfsd=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 D 0000000000000000=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0 2530=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 2 0x00000080<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff880623fbd600 0000000000000046=
 0000000000000000 ffffffffa0260e6c<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kern=
el: 0000000000800000 0002005a00000004 0000000000000003 0000000000000286<br>=
May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff880626601058 ffff880623fbdfd8 =
000000000000fbc8 ffff880626601058<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: Call Trace:<br>May=C2=A0 2 17:51:=
39 nzhmlfpr010 kernel: [&lt;ffffffffa0260e6c&gt;] ? xfs_iext_bno_to_ext+0x8=
c/0x170 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8152=
8ac5&gt;] schedule_timeout+0x215/0x2e0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81529ac2&gt;] __down=
+0x72/0xb0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a9=
5&gt;] ? _xfs_buf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010=
 kernel: [&lt;ffffffff810a1381&gt;] down+0x41/0x50<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284901&gt;] xfs_bu=
f_lock+0x51/0x100 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ff=
ffffffa0284a95&gt;] _xfs_buf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:51:39 =
nzhmlfpr010 kernel: [&lt;ffffffffa0284c14&gt;] xfs_buf_get+0x34/0x1b0 [xfs]=
<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa028529c&gt;] xfs_bu=
f_read+0x2c/0x100 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ff=
ffffffa027ac27&gt;] xfs_trans_read_buf+0x197/0x410 [xfs]<br>May=C2=A0 2 17:=
51:39 nzhmlfpr010 kernel: [&lt;ffffffffa025d164&gt;] xfs_read_agi+0x74/0x10=
0 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa025d21e&gt;] xfs_ia=
lloc_read_agi+0x2e/0x90 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [=
&lt;ffffffffa025d8fe&gt;] xfs_imap_lookup+0x3e/0x170 [xfs]<br>May=C2=A0 2 1=
7:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8149a3e8&gt;] ? ip_finish_output+0=
x148/0x310<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa025dbfe&gt;] xfs_im=
ap+0x1ce/0x280 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;fffff=
fffa02650f0&gt;] xfs_iread+0x40/0x1b0 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfp=
r010 kernel: [&lt;ffffffff811a59de&gt;] ? inode_init_always+0x11e/0x1c0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa025fc8e&gt;] xfs_ig=
et+0x27e/0x6e0 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;fffff=
fff814b121f&gt;] ? tcp_event_new_data_sent+0x4f/0x110<br>May=C2=A0 2 17:51:=
39 nzhmlfpr010 kernel: [&lt;ffffffffa02860a6&gt;] xfs_nfs_get_inode+0x46/0x=
e0 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0444860&gt;] ? cach=
e_check+0x60/0x360 [sunrpc]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&l=
t;ffffffffa028621b&gt;] xfs_fs_fh_to_dentry+0x8b/0x90 [xfs]<br>May=C2=A0 2 =
17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa015271c&gt;] exportfs_decode_fh+=
0x5c/0x2bc [exportfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa055a800&gt;] ? nfsd=
_acceptable+0x0/0x120 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&=
lt;ffffffffa0444860&gt;] ? cache_check+0x60/0x360 [sunrpc]<br>May=C2=A0 2 1=
7:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0560712&gt;] ? exp_find_key+0x62/=
0xb0 [nfsd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81068a53&gt;] ? dequ=
eue_entity+0x113/0x2e0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;fff=
fffffa055acfa&gt;] fh_verify+0x32a/0x640 [nfsd]<br>May=C2=A0 2 17:51:39 nzh=
mlfpr010 kernel: [&lt;ffffffffa044392d&gt;] ? cache_revisit_request+0x2d/0x=
120 [sunrpc]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa056a7c0&gt;] nfsd4_=
putfh+0x50/0x60 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;fff=
fffffa056a458&gt;] nfsd4_proc_compound+0x3d8/0x490 [nfsd]<br>May=C2=A0 2 17=
:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557425&gt;] nfsd_dispatch+0xe5/0x=
230 [nfsd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa043a844&gt;] svc_pr=
ocess_common+0x344/0x640 [sunrpc]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kerne=
l: [&lt;ffffffff81065df0&gt;] ? default_wake_function+0x0/0x20<br>May=C2=A0=
 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa043ae80&gt;] svc_process+0x11=
0/0x160 [sunrpc]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557b52&gt;] nfsd+0=
xc2/0x160 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa=
0557a90&gt;] ? nfsd+0x0/0x160 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 ke=
rnel: [&lt;ffffffff8109aee6&gt;] kthread+0x96/0xa0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c20a&gt;] child_=
rip+0xa/0x20<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8109a=
e50&gt;] ? kthread+0x0/0xa0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&l=
t;ffffffff8100c200&gt;] ? child_rip+0x0/0x20<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:2531 blocked for =
more than 120 seconds.<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel:=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 Not tainted 2.6.32-431.5.1.el6.x86_64 #1<br>May=C2=A0=
 2 17:51:39 nzhmlfpr010 kernel: &quot;echo 0 &gt; /proc/sys/kernel/hung_tas=
k_timeout_secs&quot; disables this message.<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: nfsd=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 D 0000000000000008=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=
=A0 2531=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2 0x00000080<br>May=C2=A0 2 17:51:39=
 nzhmlfpr010 kernel: ffff880623131c80 0000000000000046 0000000000000000 000=
00000329ac000<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff880338a05200 =
0000000000000001 ffff8803330c3d88 ffff8803330c3d88<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff880623d91ab8 ffff880623131fd8=
 000000000000fbc8 ffff880623d91ab8<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kern=
el: Call Trace:<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81=
52938e&gt;] __mutex_lock_slowpath+0x13e/0x180<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8152922b&gt;] mutex_=
lock+0x2b/0x50<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa05=
5f102&gt;] nfsd_create_v3+0x102/0x530 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlf=
pr010 kernel: [&lt;ffffffffa0566c13&gt;] nfsd3_proc_create+0x123/0x1b0 [nfs=
d]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557425&gt;] nfsd_d=
ispatch+0xe5/0x230 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;=
ffffffffa043a844&gt;] svc_process_common+0x344/0x640 [sunrpc]<br>May=C2=A0 =
2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81065df0&gt;] ? default_wake_fu=
nction+0x0/0x20<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa043ae80&gt;] svc_pr=
ocess+0x110/0x160 [sunrpc]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffffa0557b52&gt;] nfsd+0xc2/0x160 [nfsd]<br>May=C2=A0 2 17:51:39 nzhml=
fpr010 kernel: [&lt;ffffffffa0557a90&gt;] ? nfsd+0x0/0x160 [nfsd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8109aee6&gt;] kthrea=
d+0x96/0xa0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c2=
0a&gt;] child_rip+0xa/0x20<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffff8109ae50&gt;] ? kthread+0x0/0xa0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c200&gt;] ? chil=
d_rip+0x0/0x20<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:=
2532 blocked for more than 120 seconds.<br>May=C2=A0 2 17:51:39 nzhmlfpr010=
 kernel:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Not tainted 2.6.32-431.5.1.el6.x86_6=
4 #1<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: &quot;echo 0 &gt; /proc/sys/kerne=
l/hung_task_timeout_secs&quot; disables this message.<br>May=C2=A0 2 17:51:=
39 nzhmlfpr010 kernel: nfsd=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 D 0000000000000008=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0 2532=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 2 0x00000080<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff88063a073430 0000000000000046=
 0000000000000000 ffff88063a0735d8<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kern=
el: 000000043a0735e4 ffff880638681000 ffff88015a9ed838 00ff88063a073580<br>=
May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff8806386fbaf8 ffff88063a073fd8 =
000000000000fbc8 ffff8806386fbaf8<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: Call Trace:<br>May=C2=A0 2 17:51:=
39 nzhmlfpr010 kernel: [&lt;ffffffff81528ac5&gt;] schedule_timeout+0x215/0x=
2e0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81529ac2&gt;] =
__down+0x72/0xb0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] ? _xfs=
_buf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffff810a1381&gt;] down+0x41/0x50<br>May=C2=A0 2 17:51:39 nzhmlfpr010 k=
ernel: [&lt;ffffffffa0284901&gt;] xfs_buf_lock+0x51/0x100 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] _xfs_b=
uf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;f=
fffffffa0284c14&gt;] xfs_buf_get+0x34/0x1b0 [xfs]<br>May=C2=A0 2 17:51:39 n=
zhmlfpr010 kernel: [&lt;ffffffffa028529c&gt;] xfs_buf_read+0x2c/0x100 [xfs]=
<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa027ac87&gt;] xfs_tr=
ans_read_buf+0x1f7/0x410 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: =
[&lt;ffffffffa022faa6&gt;] xfs_read_agf+0x66/0x1a0 [xfs]<br>May=C2=A0 2 17:=
51:39 nzhmlfpr010 kernel: [&lt;ffffffffa022fc19&gt;] xfs_alloc_read_agf+0x3=
9/0xd0 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0232642&gt;] xfs_al=
loc_fix_freelist+0x432/0x4a0 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kern=
el: [&lt;ffffffffa0278187&gt;] ? xfs_trans_add_item+0x57/0x70 [xfs]<br>May=
=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0274938&gt;] ? xfs_pera=
g_get+0x38/0xb0 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0232bb6&gt;] xfs_al=
loc_vextent+0x3d6/0x610 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [=
&lt;ffffffffa025e453&gt;] xfs_ialloc_ag_alloc+0x143/0x4e0 [xfs]<br>May=C2=
=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa025e8cf&gt;] xfs_dialloc+0=
xdf/0x850 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8144b4d4&gt;] ? rele=
ase_sock+0xe4/0xf0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;fffffff=
f814a4aa1&gt;] ? tcp_recvmsg+0x821/0xe80<br>May=C2=A0 2 17:51:39 nzhmlfpr01=
0 kernel: [&lt;ffffffffa0262980&gt;] xfs_ialloc+0x60/0x6e0 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa028006a&gt;] ? kmem=
_zone_zalloc+0x3a/0x50 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&=
lt;ffffffffa027b814&gt;] xfs_dir_ialloc+0x74/0x2b0 [xfs]<br>May=C2=A0 2 17:=
51:39 nzhmlfpr010 kernel: [&lt;ffffffffa027d8f0&gt;] xfs_create+0x440/0x640=
 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa028aa3d&gt;] xfs_vn=
_mknod+0xad/0x1c0 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ff=
ffffffa028ab80&gt;] xfs_vn_create+0x10/0x20 [xfs]<br>May=C2=A0 2 17:51:39 n=
zhmlfpr010 kernel: [&lt;ffffffff811983b6&gt;] vfs_create+0xe6/0x110<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa055f3d5&gt;] nfsd_c=
reate_v3+0x3d5/0x530 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&l=
t;ffffffffa0566c13&gt;] nfsd3_proc_create+0x123/0x1b0 [nfsd]<br>May=C2=A0 2=
 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557425&gt;] nfsd_dispatch+0xe5=
/0x230 [nfsd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa043a844&gt;] svc_pr=
ocess_common+0x344/0x640 [sunrpc]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kerne=
l: [&lt;ffffffff81065df0&gt;] ? default_wake_function+0x0/0x20<br>May=C2=A0=
 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa043ae80&gt;] svc_process+0x11=
0/0x160 [sunrpc]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557b52&gt;] nfsd+0=
xc2/0x160 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa=
0557a90&gt;] ? nfsd+0x0/0x160 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 ke=
rnel: [&lt;ffffffff8109aee6&gt;] kthread+0x96/0xa0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c20a&gt;] child_=
rip+0xa/0x20<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8109a=
e50&gt;] ? kthread+0x0/0xa0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&l=
t;ffffffff8100c200&gt;] ? child_rip+0x0/0x20<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: INFO: task nfsd:2533 blocked for =
more than 120 seconds.<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel:=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 Not tainted 2.6.32-431.5.1.el6.x86_64 #1<br>May=C2=A0=
 2 17:51:39 nzhmlfpr010 kernel: &quot;echo 0 &gt; /proc/sys/kernel/hung_tas=
k_timeout_secs&quot; disables this message.<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: nfsd=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 D 0000000000000008=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=
=A0 2533=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2 0x00000080<br>May=C2=A0 2 17:51:39=
 nzhmlfpr010 kernel: ffff880623f7d8d0 0000000000000046 0000000000000000 fff=
f880623f7d894<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff880200000000 =
ffff88033fc25300 ffff880028276840 0000000000000400<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: ffff88063875bab8 ffff880623f7dfd8=
 000000000000fbc8 ffff88063875bab8<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kern=
el: Call Trace:<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81=
528ac5&gt;] schedule_timeout+0x215/0x2e0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0245208&gt;] ? xfs_=
bmbt_get_all+0x18/0x20 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&=
lt;ffffffffa023b42d&gt;] ? xfs_bmap_search_multi_extents+0xad/0x120 [xfs]<b=
r>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff81529ac2&gt;] __dow=
n+0x72/0xb0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] ? _xfs=
_buf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt=
;ffffffff810a1381&gt;] down+0x41/0x50<br>May=C2=A0 2 17:51:39 nzhmlfpr010 k=
ernel: [&lt;ffffffffa0284901&gt;] xfs_buf_lock+0x51/0x100 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0284a95&gt;] _xfs_b=
uf_find+0xe5/0x230 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;f=
fffffffa0284c14&gt;] xfs_buf_get+0x34/0x1b0 [xfs]<br>May=C2=A0 2 17:51:39 n=
zhmlfpr010 kernel: [&lt;ffffffffa028529c&gt;] xfs_buf_read+0x2c/0x100 [xfs]=
<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa027ac87&gt;] xfs_tr=
ans_read_buf+0x1f7/0x410 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: =
[&lt;ffffffffa025d164&gt;] xfs_read_agi+0x74/0x100 [xfs]<br>May=C2=A0 2 17:=
51:39 nzhmlfpr010 kernel: [&lt;ffffffffa026342b&gt;] xfs_iunlink+0x4b/0x170=
 [xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff810792c7&gt;] ? curr=
ent_fs_time+0x27/0x30<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffff=
ffffa027b427&gt;] ? xfs_trans_ichgtime+0x27/0xb0 [xfs]<br>May=C2=A0 2 17:51=
:39 nzhmlfpr010 kernel: [&lt;ffffffffa027b78b&gt;] xfs_droplink+0x5b/0x70 [=
xfs]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa027d1ce&gt;] xfs_re=
move+0x27e/0x390 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;fff=
fffff811a3767&gt;] ? __d_lookup+0xa7/0x150<br>May=C2=A0 2 17:51:39 nzhmlfpr=
010 kernel: [&lt;ffffffff81196203&gt;] ? generic_permission+0x23/0xb0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa028aca8&gt;] xfs_vn=
_unlink+0x48/0x90 [xfs]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ff=
ffffff811979a2&gt;] vfs_unlink+0xa2/0xf0<br>May=C2=A0 2 17:51:39 nzhmlfpr01=
0 kernel: [&lt;ffffffffa055ef5f&gt;] nfsd_unlink+0x1af/0x250 [nfsd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa056369f&gt;] ? nfsd=
_cache_lookup+0x59f/0x700 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel=
: [&lt;ffffffffa05665d3&gt;] nfsd3_proc_remove+0x83/0x120 [nfsd]<br>May=C2=
=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557425&gt;] nfsd_dispatch=
+0xe5/0x230 [nfsd]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa043a844&gt;] svc_pr=
ocess_common+0x344/0x640 [sunrpc]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kerne=
l: [&lt;ffffffff81065df0&gt;] ? default_wake_function+0x0/0x20<br>May=C2=A0=
 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa043ae80&gt;] svc_process+0x11=
0/0x160 [sunrpc]<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa0557b52&gt;] nfsd+0=
xc2/0x160 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffffa=
0557a90&gt;] ? nfsd+0x0/0x160 [nfsd]<br>May=C2=A0 2 17:51:39 nzhmlfpr010 ke=
rnel: [&lt;ffffffff8109aee6&gt;] kthread+0x96/0xa0<br>
 May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8100c20a&gt;] child_=
rip+0xa/0x20<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&lt;ffffffff8109a=
e50&gt;] ? kthread+0x0/0xa0<br>May=C2=A0 2 17:51:39 nzhmlfpr010 kernel: [&l=
t;ffffffff8100c200&gt;] ? child_rip+0x0/0x20</div>
<div>=C2=A0</div><div>=C2=A0</div><div>Thank you</div></div>

--047d7b6743a21eb78104f8c1cb9a--


--===============5075482754944216390==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5075482754944216390==--
