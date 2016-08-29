Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A5467CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 05:38:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E13808F8033
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 03:37:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vCBHVzqkWfFSIGFb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 03:37:57 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id C69A9C057FA7
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 10:37:56 +0000 (UTC)
Received: from localhost (dhcp-13-153.nay.redhat.com [10.66.13.153])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7TAbsF8032227
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 06:37:55 -0400
Date: Mon, 29 Aug 2016 18:37:54 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: BUG: Internal error xfs_trans_cancel at line 984 of file
	fs/xfs/xfs_trans.c
Message-ID: <20160829103754.GH27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FN+gV9K+162wdwwF"
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--FN+gV9K+162wdwwF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I've hit an XFS internal error then filesystem shutdown with 4.8-rc3
kernel but not with 4.8-rc2

[ 8841.923617] XFS (sda6): Internal error xfs_trans_cancel at line 984 of file fs/xfs/xfs_trans.c.  Caller xfs_iomap_write_allocate+0x2d7/0x380 [xfs] 
[ 8841.938286] CPU: 3 PID: 56 Comm: kswapd0 Not tainted 4.8.0-rc3 #1 
[ 8841.945073] Hardware name: IBM IBM System x3550 M4 Server -[7914I21]-/00J6242, BIOS -[D7E120CUS-1.20]- 08/23/2012 
[ 8841.956526]  0000000000000286 00000000c8d39410 ffff88046890b7a8 ffffffff8135c53c 
[ 8841.964818]  ffff8804144e4cb0 0000000000000001 ffff88046890b7c0 ffffffffa02d99cb 
[ 8841.973116]  ffffffffa02e5537 ffff88046890b7e8 ffffffffa02f53e6 ffff8801ad37e580 
[ 8841.981402] Call Trace: 
[ 8841.984134]  [<ffffffff8135c53c>] dump_stack+0x63/0x87 
[ 8841.989900]  [<ffffffffa02d99cb>] xfs_error_report+0x3b/0x40 [xfs] 
[ 8841.996813]  [<ffffffffa02e5537>] ? xfs_iomap_write_allocate+0x2d7/0x380 [xfs] 
[ 8842.004891]  [<ffffffffa02f53e6>] xfs_trans_cancel+0xb6/0xe0 [xfs] 
[ 8842.011803]  [<ffffffffa02e5537>] xfs_iomap_write_allocate+0x2d7/0x380 [xfs] 
[ 8842.019684]  [<ffffffffa02cf949>] xfs_map_blocks+0x1a9/0x220 [xfs] 
[ 8842.026593]  [<ffffffffa02d0c5b>] xfs_do_writepage+0x16b/0x560 [xfs] 
[ 8842.033695]  [<ffffffffa02d108b>] xfs_vm_writepage+0x3b/0x70 [xfs] 
[ 8842.040584]  [<ffffffff811b00dd>] pageout.isra.41+0x18d/0x2d0 
[ 8842.046993]  [<ffffffff811b1f3a>] shrink_page_list+0x78a/0x9b0 
[ 8842.053501]  [<ffffffff811b293d>] shrink_inactive_list+0x21d/0x570 
[ 8842.060396]  [<ffffffff811b350e>] shrink_node_memcg+0x51e/0x7d0 
[ 8842.067000]  [<ffffffff810a3900>] ? workqueue_congested+0x70/0x90 
[ 8842.073799]  [<ffffffff810a4862>] ? __queue_work+0x142/0x420 
[ 8842.080112]  [<ffffffff810a4862>] ? __queue_work+0x142/0x420 
[ 8842.086425]  [<ffffffff811b38a1>] shrink_node+0xe1/0x310 
[ 8842.092351]  [<ffffffff811b48d1>] kswapd+0x301/0x6f0 
[ 8842.097889]  [<ffffffff811b45d0>] ? mem_cgroup_shrink_node+0x180/0x180 
[ 8842.105172]  [<ffffffff810aca28>] kthread+0xd8/0xf0 
[ 8842.110614]  [<ffffffff816f8dbf>] ret_from_fork+0x1f/0x40 
[ 8842.116636]  [<ffffffff810ac950>] ? kthread_park+0x60/0x60 
[ 8842.122784] XFS (sda6): xfs_do_force_shutdown(0x8) called from line 985 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa02f53ff 
[ 8842.522306] XFS (sda6): Corruption of in-memory data detected.  Shutting down filesystem 
[ 8842.531358] XFS (sda6): Please umount the filesystem and rectify the problem(s) 
[ 8842.540470] Buffer I/O error on dev sda6, logical block 56162821, lost async page write 
[ 8842.549431] audit: netlink_unicast sending to audit_pid=1123 returned error: -111 
[ 8842.549433] audit: audit_lost=1 audit_rate_limit=0 audit_backlog_limit=64 
[ 8842.549434] audit: audit_pid=1123 reset 
[ 8842.552890] audit: type=1701 audit(1472234261.632:184): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:syslogd_t:s0 pid=2064 comm="in:imjournal" exe="/usr/sbin/rsyslogd" sig=7 
[ 8842.552909] XFS (sda6): xfs_do_force_shutdown(0x1) called from line 203 of file fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffa02b5459 
[ 8842.554230] audit: type=1701 audit(1472234261.633:185): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:init_t:s0 pid=1 comm="systemd" exe="/usr/lib/systemd/systemd" sig=11 
[ 8842.555324] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b 

So it's likely a regression introduced in 4.8-rc3, and my bisect test
pointed to commit 0af32fb468b4 ("xfs: fix bogus space reservation in
xfs_iomap_write_allocate").


The test I ran is "bash-shared-mapping", it's available in
autotest(bash-shared-mapping.c from ext3-tools.tar.gz).
https://github.com/autotest/autotest-client-tests/raw/master/bash_shared_mapping/ext3-tools.tar.gz

You may have to do some modifications to make it compile. I attached an
updated version of bash-shared-mapping.c, you can downloand and compile
it directly.

I attached a script too to reproduce it. Please note that the XFS
partition needs about 40G frees space, and it may take hours to finish
based on your memory setup on your host.

I reproduced it on multiple hosts e.g. host with 64G memory & 16 cpus
and host with 16G memory & 16 cpus, but I haven't seen it on my test vm
which has 8G memory & 4 vcpus.

Detailed information of the host with 64G memory is:
[root@hp-dl360g9-15 ~]# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                16
On-line CPU(s) list:   0-15
Thread(s) per core:    1
Core(s) per socket:    8
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 63
Model name:            Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz
Stepping:              2
CPU MHz:               2400.000
BogoMIPS:              4802.86
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              20480K
NUMA node0 CPU(s):     0-3,8-11
NUMA node1 CPU(s):     4-7,12-15
[root@hp-dl360g9-15 ~]# free -m
              total        used        free      shared  buff/cache   available
Mem:          64305       38757         224           5       25323       61944
Swap:         16379          65       16314
[root@hp-dl360g9-15 ~]# xfs_info /
meta-data=/dev/mapper/systemvg-root isize=256    agcount=16, agsize=2927744 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=46843904, imaxpct=25
         =                       sunit=64     swidth=192 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=22912, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@hp-dl360g9-15 ~]# lvs
  LV   VG       Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  home systemvg -wi-ao----   2.54t
  root systemvg -wi-ao---- 178.70g
  swap systemvg -wi-ao----  16.00g

If more information is needed please let me know.

Thanks,
Eryu

--FN+gV9K+162wdwwF
Content-Type: application/x-sh
Content-Disposition: attachment; filename="bashmemory.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0A# point this to the actual bash-shared-mapping=0Abash_shar=
ed_mapping=3D/path/to/bash-shared-mapping=0A=0AITER=3D30=0ATASKS=3D10=0A=0A=
# modify as needed, make sure it has ~40G free space=0AMNT=3D/mnt/xfs=0AFIL=
ENAME=3D$MNT/foo=0A=0Amemsize=3D`free -m | grep Mem | awk '{print $2}'`=0Ae=
cho "memsize is $memsize MB"=0A=0A# Use memsize * 1.10 to put pressure on t=
he VM:=0Absmemsize=3D$((memsize * 11 / 10))=0A# limit memsize to 2 GB due t=
o 31-bit seek() and mmap()=0Aif [ $((bsmemsize)) -gt 2000 ] ; then=0A      =
  bsmemsize=3D2000=0A	echo "limited memsize =3D $bsmemsize MB"=0Afi=0A=0Aco=
pies=3D$(((memsize + 1950) / 2000))=0Aecho "using $copies copies of: bash-s=
hared-mapping"=0AFILESIZE=3D$((bsmemsize * 1000000))=0Aecho "bash-shared-ma=
pping : FILESIZE =3D $FILESIZE"=0A=0Acp=3D$copies=0Awhile [ $cp -gt 0 ] ; d=
o=0A	date=0A	prms=3D"-v -n $ITER -t $TASKS $FILENAME.$cp $FILESIZE"=0A	$bas=
h_shared_mapping $prms &=0A	cp=3D$((cp - 1))=0Adone=0Await=0A=0Adate=0Aecho=
 "done!"=0A
--FN+gV9K+162wdwwF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="console.log"

[ 2872.431497] run test /mnt/tests/kernel/filesystems/ext4/576202-bashmemory 
[-- MARK -- Fri Aug 26 16:20:00 2016] 
[ 3073.429520] INFO: task bash-shared-map:9527 blocked for more than 120 seconds. 
[ 3073.437589]       Not tainted 4.8.0-rc3 #1 
[ 3073.442163] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3073.450903] bash-shared-map D ffff88036e207c30     0  9527   9522 0x00000080 
[ 3073.458795]  ffff88036e207c30 ffff880150f34000 ffff880457f55a00 ffff880457f55a00 
[ 3073.467090]  ffff88036e208000 ffff8801ad37e790 ffff8801ad37e790 ffffffff00000000 
[ 3073.475386]  ffff8801ad37e7a8 ffff88036e207c48 ffffffff816f49e5 ffff880457f55a00 
[ 3073.483683] Call Trace: 
[ 3073.486419]  [<ffffffff816f49e5>] schedule+0x35/0x80 
[ 3073.491961]  [<ffffffff816f7468>] rwsem_down_write_failed+0x218/0x390 
[ 3073.499157]  [<ffffffff8136b4d7>] call_rwsem_down_write_failed+0x17/0x30 
[ 3073.506654]  [<ffffffff816f6add>] down_write+0x2d/0x40 
[ 3073.512459]  [<ffffffffa02dc974>] xfs_file_buffered_aio_write+0x64/0x260 [xfs] 
[ 3073.520578]  [<ffffffffa02dcc5d>] xfs_file_write_iter+0xed/0x130 [xfs] 
[ 3073.527883]  [<ffffffff8122a433>] __vfs_write+0xe3/0x160 
[ 3073.533829]  [<ffffffff8122b682>] vfs_write+0xb2/0x1b0 
[ 3073.539578]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0 
[ 3073.546593]  [<ffffffff8122cc77>] SyS_pwrite64+0x87/0xb0 
[ 3073.552540]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160 
[ 3073.558671]  [<ffffffff816f8c61>] entry_SYSCALL64_slow_path+0x25/0x25 
[ 3073.565880] INFO: task bash-shared-map:9532 blocked for more than 120 seconds. 
[ 3073.573950]       Not tainted 4.8.0-rc3 #1 
[ 3073.578531] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3073.587282] bash-shared-map D ffff88037663fc30     0  9532   9516 0x00000080 
[ 3073.595190]  ffff88037663fc30 ffff88037663fc40 ffff880459ff0000 ffff88037663fc30 
[ 3073.603520]  ffff880376640000 ffff8802a0f514d0 ffff8802a0f514d0 ffffffff00000000 
[ 3073.611820]  ffff8802a0f514e8 ffff88037663fc48 ffffffff816f49e5 ffff880459ff0000 
[ 3073.620112] Call Trace: 
[ 3073.622848]  [<ffffffff816f49e5>] schedule+0x35/0x80 
[ 3073.628390]  [<ffffffff816f7468>] rwsem_down_write_failed+0x218/0x390 
[ 3073.635580]  [<ffffffff816f71fe>] ? rwsem_down_read_failed+0x10e/0x160 
[ 3073.642869]  [<ffffffff8136b4d7>] call_rwsem_down_write_failed+0x17/0x30 
[ 3073.650352]  [<ffffffff816f6add>] down_write+0x2d/0x40 
[ 3073.656122]  [<ffffffffa02dc974>] xfs_file_buffered_aio_write+0x64/0x260 [xfs] 
[ 3073.664201]  [<ffffffffa02dcc5d>] xfs_file_write_iter+0xed/0x130 [xfs] 
[ 3073.671490]  [<ffffffff8122a433>] __vfs_write+0xe3/0x160 
[ 3073.677420]  [<ffffffff8122b682>] vfs_write+0xb2/0x1b0 
[ 3073.683149]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0 
[ 3073.690151]  [<ffffffff8122cc77>] SyS_pwrite64+0x87/0xb0 
[ 3073.696080]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160 
[ 3073.702204]  [<ffffffff816f8c61>] entry_SYSCALL64_slow_path+0x25/0x25 
[ 3073.709414] INFO: task bash-shared-map:9535 blocked for more than 120 seconds. 
[ 3073.717492]       Not tainted 4.8.0-rc3 #1 
[ 3073.722077] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3073.730822] bash-shared-map D ffff8801ca7dfc30     0  9535   9531 0x00000080 
[ 3073.738702]  ffff8801ca7dfc30 ffff8801536ca000 ffff880468985a00 ffff880468985a00 
[ 3073.746998]  ffff8801ca7e0000 ffff8801ad37e3d0 ffff8801ad37e3d0 ffffffff00000000 
[ 3073.755295]  ffff8801ad37e3e8 ffff8801ca7dfc48 ffffffff816f49e5 ffff880468985a00 
[ 3073.763593] Call Trace: 
[ 3073.766326]  [<ffffffff816f49e5>] schedule+0x35/0x80 
[ 3073.771871]  [<ffffffff816f7468>] rwsem_down_write_failed+0x218/0x390 
[ 3073.779062]  [<ffffffff8136b4d7>] call_rwsem_down_write_failed+0x17/0x30 
[ 3073.786543]  [<ffffffff816f6add>] down_write+0x2d/0x40 
[ 3073.792311]  [<ffffffffa02dc974>] xfs_file_buffered_aio_write+0x64/0x260 [xfs] 
[ 3073.800391]  [<ffffffffa02dcc5d>] xfs_file_write_iter+0xed/0x130 [xfs] 
[ 3073.807680]  [<ffffffff8122a433>] __vfs_write+0xe3/0x160 
[ 3073.813630]  [<ffffffff8122b682>] vfs_write+0xb2/0x1b0 
[ 3073.819389]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0 
[ 3073.826390]  [<ffffffff8122cc77>] SyS_pwrite64+0x87/0xb0 
[ 3073.832321]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160 
[ 3073.838449]  [<ffffffff816f8c61>] entry_SYSCALL64_slow_path+0x25/0x25 
[ 3073.845643] INFO: task bash-shared-map:9538 blocked for more than 120 seconds. 
[ 3073.853706]       Not tainted 4.8.0-rc3 #1 
[ 3073.858277] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3073.867018] bash-shared-map D ffff88037338fc30     0  9538   9531 0x00000080 
[ 3073.874909]  ffff88037338fc30 ffff8801536ca000 ffff88045a3fc380 ffff88045a3fc380 
[ 3073.883206]  ffff880373390000 ffff8801ad37e3d0 ffff8801ad37e3d0 ffffffff00000000 
[ 3073.891502]  ffff8801ad37e3e8 ffff88037338fc48 ffffffff816f49e5 ffff88045a3fc380 
[ 3073.899798] Call Trace: 
[ 3073.902529]  [<ffffffff816f49e5>] schedule+0x35/0x80 
[ 3073.908073]  [<ffffffff816f7468>] rwsem_down_write_failed+0x218/0x390 
[ 3073.915266]  [<ffffffff8136b4d7>] call_rwsem_down_write_failed+0x17/0x30 
[ 3073.922768]  [<ffffffff816f6add>] down_write+0x2d/0x40 
[ 3073.928556]  [<ffffffffa02dc974>] xfs_file_buffered_aio_write+0x64/0x260 [xfs] 
[ 3073.936668]  [<ffffffffa02dcc5d>] xfs_file_write_iter+0xed/0x130 [xfs] 
[ 3073.943969]  [<ffffffff8122a433>] __vfs_write+0xe3/0x160 
[ 3073.949904]  [<ffffffff8122b682>] vfs_write+0xb2/0x1b0 
[ 3073.955640]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0 
[ 3073.962634]  [<ffffffff8122cc77>] SyS_pwrite64+0x87/0xb0 
[ 3073.968564]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160 
[ 3073.974689]  [<ffffffff816f8c61>] entry_SYSCALL64_slow_path+0x25/0x25 
[ 3073.981884] INFO: task bash-shared-map:9539 blocked for more than 120 seconds. 
[ 3073.989947]       Not tainted 4.8.0-rc3 #1 
[ 3073.994516] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3074.003256] bash-shared-map D ffff880386eefc30     0  9539   9532 0x00000080 
[ 3074.011160]  ffff880386eefc30 ffff880386eefc40 ffff8803baed5a00 ffff880386eefc30 
[ 3074.019457]  ffff880386ef0000 ffff8802a0f514d0 ffff8802a0f514d0 ffffffff00000000 
[ 3074.027752]  ffff8802a0f514e8 ffff880386eefc48 ffffffff816f49e5 ffff8803baed5a00 
[ 3074.036047] Call Trace: 
[ 3074.038783]  [<ffffffff816f49e5>] schedule+0x35/0x80 
[ 3074.044325]  [<ffffffff816f7468>] rwsem_down_write_failed+0x218/0x390 
[ 3074.051516]  [<ffffffff816f71fe>] ? rwsem_down_read_failed+0x10e/0x160 
[ 3074.058806]  [<ffffffff8136b4d7>] call_rwsem_down_write_failed+0x17/0x30 
[ 3074.066293]  [<ffffffff816f6add>] down_write+0x2d/0x40 
[ 3074.072066]  [<ffffffffa02dc974>] xfs_file_buffered_aio_write+0x64/0x260 [xfs] 
[ 3074.080146]  [<ffffffffa02dcc5d>] xfs_file_write_iter+0xed/0x130 [xfs] 
[ 3074.087437]  [<ffffffff8122a433>] __vfs_write+0xe3/0x160 
[ 3074.093366]  [<ffffffff8122b682>] vfs_write+0xb2/0x1b0 
[ 3074.099103]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0 
[ 3074.106099]  [<ffffffff8122cc77>] SyS_pwrite64+0x87/0xb0 
[ 3074.112028]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160 
[ 3074.118154]  [<ffffffff816f8c61>] entry_SYSCALL64_slow_path+0x25/0x25 
[ 3074.125348] INFO: task bash-shared-map:9546 blocked for more than 120 seconds. 
[ 3074.133411]       Not tainted 4.8.0-rc3 #1 
[ 3074.137985] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3074.146724] bash-shared-map D ffff8801b9e2bc30     0  9546   9531 0x00000080 
[ 3074.154615]  ffff8801b9e2bc30 ffff8801536ca000 ffff88045aa30000 ffff88045aa30000 
[ 3074.162912]  ffff8801b9e2c000 ffff8801ad37e3d0 ffff8801ad37e3d0 ffffffff00000000 
[ 3074.171207]  ffff8801ad37e3e8 ffff8801b9e2bc48 ffffffff816f49e5 ffff88045aa30000 
[ 3074.179505] Call Trace: 
[ 3074.182236]  [<ffffffff816f49e5>] schedule+0x35/0x80 
[ 3074.187778]  [<ffffffff816f7468>] rwsem_down_write_failed+0x218/0x390 
[ 3074.194968]  [<ffffffff8136b4d7>] call_rwsem_down_write_failed+0x17/0x30 
[ 3074.202441]  [<ffffffff816f6add>] down_write+0x2d/0x40 
[ 3074.208194]  [<ffffffffa02dc974>] xfs_file_buffered_aio_write+0x64/0x260 [xfs] 
[ 3074.216273]  [<ffffffffa02dcc5d>] xfs_file_write_iter+0xed/0x130 [xfs] 
[ 3074.223563]  [<ffffffff8122a433>] __vfs_write+0xe3/0x160 
[ 3074.229494]  [<ffffffff8122b682>] vfs_write+0xb2/0x1b0 
[ 3074.235231]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0 
[ 3074.242227]  [<ffffffff8122cc77>] SyS_pwrite64+0x87/0xb0 
[ 3074.248165]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160 
[ 3074.254292]  [<ffffffff816f8c61>] entry_SYSCALL64_slow_path+0x25/0x25 
[ 3074.261484] INFO: task bash-shared-map:9550 blocked for more than 120 seconds. 
[ 3074.269545]       Not tainted 4.8.0-rc3 #1 
[ 3074.274116] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3074.282855] bash-shared-map D ffff8801c962bc30     0  9550   9531 0x00000080 
[ 3074.290745]  ffff8801c962bc30 ffff8801536ca000 ffff88045aa35a00 ffff88045aa35a00 
[ 3074.299040]  ffff8801c962c000 ffff8801ad37e3d0 ffff8801ad37e3d0 ffffffff00000000 
[ 3074.307335]  ffff8801ad37e3e8 ffff8801c962bc48 ffffffff816f49e5 ffff88045aa35a00 
[ 3074.315632] Call Trace: 
[ 3074.318362]  [<ffffffff816f49e5>] schedule+0x35/0x80 
[ 3074.323904]  [<ffffffff816f7468>] rwsem_down_write_failed+0x218/0x390 
[ 3074.331095]  [<ffffffff8136b4d7>] call_rwsem_down_write_failed+0x17/0x30 
[ 3074.338577]  [<ffffffff816f6add>] down_write+0x2d/0x40 
[ 3074.344346]  [<ffffffffa02dc974>] xfs_file_buffered_aio_write+0x64/0x260 [xfs] 
[ 3074.352424]  [<ffffffffa02dcc5d>] xfs_file_write_iter+0xed/0x130 [xfs] 
[ 3074.359713]  [<ffffffff8122a433>] __vfs_write+0xe3/0x160 
[ 3074.365660]  [<ffffffff8122b682>] vfs_write+0xb2/0x1b0 
[ 3074.371417]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0 
[ 3074.378438]  [<ffffffff8122cc77>] SyS_pwrite64+0x87/0xb0 
[ 3074.384374]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160 
[ 3074.390503]  [<ffffffff816f8c61>] entry_SYSCALL64_slow_path+0x25/0x25 
[ 3074.397698] INFO: task bash-shared-map:9562 blocked for more than 120 seconds. 
[ 3074.405759]       Not tainted 4.8.0-rc3 #1 
[ 3074.410331] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3074.419071] bash-shared-map D ffff880198ab3c30     0  9562   9527 0x00000080 
[ 3074.426960]  ffff880198ab3c30 ffff880150f34000 ffff88038d37ad00 ffff88038d37ad00 
[ 3074.435256]  ffff880198ab4000 ffff8801ad37e790 ffff8801ad37e790 ffffffff00000000 
[ 3074.443554]  ffff8801ad37e7a8 ffff880198ab3c48 ffffffff816f49e5 ffff88038d37ad00 
[ 3074.451849] Call Trace: 
[ 3074.454581]  [<ffffffff816f49e5>] schedule+0x35/0x80 
[ 3074.460141]  [<ffffffff816f7468>] rwsem_down_write_failed+0x218/0x390 
[ 3074.467339]  [<ffffffff8136b4d7>] call_rwsem_down_write_failed+0x17/0x30 
[ 3074.474818]  [<ffffffff816f6add>] down_write+0x2d/0x40 
[ 3074.480586]  [<ffffffffa02dc974>] xfs_file_buffered_aio_write+0x64/0x260 [xfs] 
[ 3074.488665]  [<ffffffffa02dcc5d>] xfs_file_write_iter+0xed/0x130 [xfs] 
[ 3074.495955]  [<ffffffff8122a433>] __vfs_write+0xe3/0x160 
[ 3074.501884]  [<ffffffff8122b682>] vfs_write+0xb2/0x1b0 
[ 3074.507623]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0 
[ 3074.514618]  [<ffffffff8122cc77>] SyS_pwrite64+0x87/0xb0 
[ 3074.520549]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160 
[ 3074.526674]  [<ffffffff816f8c61>] entry_SYSCALL64_slow_path+0x25/0x25 
[ 3074.533866] INFO: task bash-shared-map:9563 blocked for more than 120 seconds. 
[ 3074.541928]       Not tainted 4.8.0-rc3 #1 
[ 3074.546500] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3074.555241] bash-shared-map D ffff880198a33c30     0  9563   9527 0x00000080 
[ 3074.563133]  ffff880198a33c30 ffff880150f34000 ffff88038d37c380 ffff88038d37c380 
[ 3074.571428]  ffff880198a34000 ffff8801ad37e790 ffff8801ad37e790 ffffffff00000000 
[ 3074.579738]  ffff8801ad37e7a8 ffff880198a33c48 ffffffff816f49e5 ffff88038d37c380 
[ 3074.588039] Call Trace: 
[ 3074.590774]  [<ffffffff816f49e5>] schedule+0x35/0x80 
[ 3074.596317]  [<ffffffff816f7468>] rwsem_down_write_failed+0x218/0x390 
[ 3074.603507]  [<ffffffff8136b4d7>] call_rwsem_down_write_failed+0x17/0x30 
[ 3074.610989]  [<ffffffff816f6add>] down_write+0x2d/0x40 
[ 3074.616754]  [<ffffffffa02dc974>] xfs_file_buffered_aio_write+0x64/0x260 [xfs] 
[ 3074.624833]  [<ffffffffa02dcc5d>] xfs_file_write_iter+0xed/0x130 [xfs] 
[ 3074.632122]  [<ffffffff8122a433>] __vfs_write+0xe3/0x160 
[ 3074.638054]  [<ffffffff8122b682>] vfs_write+0xb2/0x1b0 
[ 3074.643792]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0 
[ 3074.650789]  [<ffffffff8122cc77>] SyS_pwrite64+0x87/0xb0 
[ 3074.656710]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160 
[ 3074.662825]  [<ffffffff816f8c61>] entry_SYSCALL64_slow_path+0x25/0x25 
[ 3074.670016] INFO: task bash-shared-map:9576 blocked for more than 120 seconds. 
[ 3074.678079]       Not tainted 4.8.0-rc3 #1 
[ 3074.682648] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3074.691389] bash-shared-map D ffff88037066bc30     0  9576   9534 0x00000080 
[ 3074.699279]  ffff88037066bc30 ffff8801a0df7000 ffff88032eaf8000 ffff88032eaf8000 
[ 3074.707577]  ffff88037066c000 ffff8802a0f51890 ffff8802a0f51890 ffffffff00000000 
[ 3074.715874]  ffff8802a0f518a8 ffff88037066bc48 ffffffff816f49e5 ffff88032eaf8000 
[ 3074.724165] Call Trace: 
[ 3074.726895]  [<ffffffff816f49e5>] schedule+0x35/0x80 
[ 3074.732437]  [<ffffffff816f7468>] rwsem_down_write_failed+0x218/0x390 
[ 3074.739628]  [<ffffffff8126298e>] ? block_commit_write+0xe/0x20 
[ 3074.746237]  [<ffffffff8136b4d7>] call_rwsem_down_write_failed+0x17/0x30 
[ 3074.753719]  [<ffffffff816f6add>] down_write+0x2d/0x40 
[ 3074.759472]  [<ffffffffa02dc974>] xfs_file_buffered_aio_write+0x64/0x260 [xfs] 
[ 3074.767552]  [<ffffffffa02dcc5d>] xfs_file_write_iter+0xed/0x130 [xfs] 
[ 3074.774833]  [<ffffffff8122a433>] __vfs_write+0xe3/0x160 
[ 3074.780762]  [<ffffffff8122b682>] vfs_write+0xb2/0x1b0 
[ 3074.786499]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0 
[ 3074.793514]  [<ffffffff8122cc77>] SyS_pwrite64+0x87/0xb0 
[ 3074.799460]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160 
[ 3074.805589]  [<ffffffff816f8c61>] entry_SYSCALL64_slow_path+0x25/0x25 
[-- MARK -- Fri Aug 26 16:25:00 2016] 
[-- MARK -- Fri Aug 26 16:30:00 2016] 
[-- MARK -- Fri Aug 26 16:35:00 2016] 
[ 3909.818209] perf: interrupt took too long (2511 > 2500), lowering kernel.perf_event_max_sample_rate to 79000 
[-- MARK -- Fri Aug 26 16:40:00 2016] 
[-- MARK -- Fri Aug 26 16:45:00 2016] 
[-- MARK -- Fri Aug 26 16:50:00 2016] 
[-- MARK -- Fri Aug 26 16:55:00 2016] 
[-- MARK -- Fri Aug 26 17:00:00 2016] 
[-- MARK -- Fri Aug 26 17:05:00 2016] 
[-- MARK -- Fri Aug 26 17:10:00 2016] 
[-- MARK -- Fri Aug 26 17:15:00 2016] 
[-- MARK -- Fri Aug 26 17:20:00 2016] 
[-- MARK -- Fri Aug 26 17:25:00 2016] 
[-- MARK -- Fri Aug 26 17:30:00 2016] 
[-- MARK -- Fri Aug 26 17:35:00 2016] 
[-- MARK -- Fri Aug 26 17:40:00 2016] 
[-- MARK -- Fri Aug 26 17:45:00 2016] 
[ 8179.104300] perf: interrupt took too long (3151 > 3138), lowering kernel.perf_event_max_sample_rate to 63000 
[-- MARK -- Fri Aug 26 17:50:00 2016] 
[-- MARK -- Fri Aug 26 17:55:00 2016] 
[ 8841.923617] XFS (sda6): Internal error xfs_trans_cancel at line 984 of file fs/xfs/xfs_trans.c.  Caller xfs_iomap_write_allocate+0x2d7/0x380 [xfs] 
[ 8841.938286] CPU: 3 PID: 56 Comm: kswapd0 Not tainted 4.8.0-rc3 #1 
[ 8841.945073] Hardware name: IBM IBM System x3550 M4 Server -[7914I21]-/00J6242, BIOS -[D7E120CUS-1.20]- 08/23/2012 
[ 8841.956526]  0000000000000286 00000000c8d39410 ffff88046890b7a8 ffffffff8135c53c 
[ 8841.964818]  ffff8804144e4cb0 0000000000000001 ffff88046890b7c0 ffffffffa02d99cb 
[ 8841.973116]  ffffffffa02e5537 ffff88046890b7e8 ffffffffa02f53e6 ffff8801ad37e580 
[ 8841.981402] Call Trace: 
[ 8841.984134]  [<ffffffff8135c53c>] dump_stack+0x63/0x87 
[ 8841.989900]  [<ffffffffa02d99cb>] xfs_error_report+0x3b/0x40 [xfs] 
[ 8841.996813]  [<ffffffffa02e5537>] ? xfs_iomap_write_allocate+0x2d7/0x380 [xfs] 
[ 8842.004891]  [<ffffffffa02f53e6>] xfs_trans_cancel+0xb6/0xe0 [xfs] 
[ 8842.011803]  [<ffffffffa02e5537>] xfs_iomap_write_allocate+0x2d7/0x380 [xfs] 
[ 8842.019684]  [<ffffffffa02cf949>] xfs_map_blocks+0x1a9/0x220 [xfs] 
[ 8842.026593]  [<ffffffffa02d0c5b>] xfs_do_writepage+0x16b/0x560 [xfs] 
[ 8842.033695]  [<ffffffffa02d108b>] xfs_vm_writepage+0x3b/0x70 [xfs] 
[ 8842.040584]  [<ffffffff811b00dd>] pageout.isra.41+0x18d/0x2d0 
[ 8842.046993]  [<ffffffff811b1f3a>] shrink_page_list+0x78a/0x9b0 
[ 8842.053501]  [<ffffffff811b293d>] shrink_inactive_list+0x21d/0x570 
[ 8842.060396]  [<ffffffff811b350e>] shrink_node_memcg+0x51e/0x7d0 
[ 8842.067000]  [<ffffffff810a3900>] ? workqueue_congested+0x70/0x90 
[ 8842.073799]  [<ffffffff810a4862>] ? __queue_work+0x142/0x420 
[ 8842.080112]  [<ffffffff810a4862>] ? __queue_work+0x142/0x420 
[ 8842.086425]  [<ffffffff811b38a1>] shrink_node+0xe1/0x310 
[ 8842.092351]  [<ffffffff811b48d1>] kswapd+0x301/0x6f0 
[ 8842.097889]  [<ffffffff811b45d0>] ? mem_cgroup_shrink_node+0x180/0x180 
[ 8842.105172]  [<ffffffff810aca28>] kthread+0xd8/0xf0 
[ 8842.110614]  [<ffffffff816f8dbf>] ret_from_fork+0x1f/0x40 
[ 8842.116636]  [<ffffffff810ac950>] ? kthread_park+0x60/0x60 
[ 8842.122784] XFS (sda6): xfs_do_force_shutdown(0x8) called from line 985 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa02f53ff 
[ 8842.522306] XFS (sda6): Corruption of in-memory data detected.  Shutting down filesystem 
[ 8842.531358] XFS (sda6): Please umount the filesystem and rectify the problem(s) 
[ 8842.540470] Buffer I/O error on dev sda6, logical block 56162821, lost async page write 
[ 8842.549431] audit: netlink_unicast sending to audit_pid=1123 returned error: -111 
[ 8842.549433] audit: audit_lost=1 audit_rate_limit=0 audit_backlog_limit=64 
[ 8842.549434] audit: audit_pid=1123 reset 
[ 8842.552890] audit: type=1701 audit(1472234261.632:184): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:syslogd_t:s0 pid=2064 comm="in:imjournal" exe="/usr/sbin/rsyslogd" sig=7 
[ 8842.552909] XFS (sda6): xfs_do_force_shutdown(0x1) called from line 203 of file fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffa02b5459 
[ 8842.554230] audit: type=1701 audit(1472234261.633:185): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:init_t:s0 pid=1 comm="systemd" exe="/usr/lib/systemd/systemd" sig=11 
[ 8842.555324] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b 
[ 8842.555324]  
[ 8842.555327] CPU: 2 PID: 1 Comm: systemd Not tainted 4.8.0-rc3 #1 
[ 8842.555327] Hardware name: IBM IBM System x3550 M4 Server -[7914I21]-/00J6242, BIOS -[D7E120CUS-1.20]- 08/23/2012 
[ 8842.555331]  0000000000000086 0000000061573c1d ffff88017e223c28 ffffffff8135c53c 
[ 8842.555332]  ffff88017e1b8b00 ffffffff81a28e80 ffff88017e223ca8 ffffffff81198014 
[ 8842.555334]  ffffffff00000010 ffff88017e223cb8 ffff88017e223c58 0000000061573c1d 
[ 8842.555334] Call Trace: 
[ 8842.555342]  [<ffffffff8135c53c>] dump_stack+0x63/0x87 
[ 8842.555346]  [<ffffffff81198014>] panic+0xeb/0x232 
[ 8842.555349]  [<ffffffff81091b0b>] do_exit+0xa1b/0xb30 
[ 8842.555350]  [<ffffffff81091c9f>] do_group_exit+0x3f/0xb0 
[ 8842.555352]  [<ffffffff8109cb8c>] get_signal+0x1cc/0x600 
[ 8842.555356]  [<ffffffff8102d1b7>] do_signal+0x37/0x6d0 
[ 8842.555359]  [<ffffffff811d3a24>] ? handle_mm_fault+0xee4/0x1300 
[ 8842.555361]  [<ffffffff81089236>] ? mm_fault_error+0x11a/0x157 
[ 8842.555365]  [<ffffffff8106b2b0>] ? __do_page_fault+0x430/0x4a0 
[ 8842.555367]  [<ffffffff810878e3>] exit_to_usermode_loop+0x59/0xa2 
[ 8842.555370]  [<ffffffff81003938>] prepare_exit_to_usermode+0x38/0x40 
[ 8842.555374]  [<ffffffff816f952f>] retint_user+0x8/0x13 
[ 8842.557801] Kernel Offset: disabled 
[ 8842.759432] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b 
[ 8842.759432]  
[-- MARK -- Fri Aug 26 18:00:00 2016] 
[-- MARK -- Fri Aug 26 18:05:00 2016] 

--FN+gV9K+162wdwwF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bash-shared-mapping.c"

/*
 * bash-shared-mapping.c - Andrew Morton <andrewm@uow.edu.au>
 *
 * Create a huge and holey shared mapping, then conduct multithreaded
 * write() I/O on some of it, while truncating and expanding it.  General
 * idea is to try to force pageout activity into the file while the kernel
 * is writing to and truncating the file.  We also perform pageout of areas
 * which are subject to write() and vice versa.  All sorts of stuff.
 *
 * It is good to run a concurrent task which uses heaps of memory, to force
 * pageouts.
 *
 * A good combination on a 1gigabyte machine is:
 *
 *	bash-shared-mapping -t5 foo 1000000000 &
 *	while true
 *	do
 *		usemem 1000
 *	done
 */

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <sys/signal.h>
#include <sys/stat.h>

//ssize_t pwrite(unsigned int fd, const char * buf, size_t count, loff_t pos);
long ftruncate64(unsigned int fd, loff_t length);


#ifndef O_LARGEFILE
#define O_LARGEFILE	0100000
#endif

int verbose;
char *progname;
loff_t size;
int fd;
char *filename;
void *mapped_mem;
int got_sigbus;
loff_t sigbus_offset;
int ntasks = 1;
int niters = -1;

void open_file()
{
	fd = open(filename, O_RDWR|O_LARGEFILE|O_TRUNC|O_CREAT, 0666);
	if (fd < 0) {
		fprintf(stderr, "%s: Cannot open `%s': %s\n",
			progname, filename, strerror(errno));
		exit(1);
	}
}

ssize_t my_pwrite(unsigned int fd, const char * buf, size_t count, loff_t pos)
{
	if (pos > 2000000000)
		printf("DRAT\n");
	return pwrite(fd, buf, count, pos);
}

void mmap_file(void)
{
	mapped_mem = mmap(0, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if (mapped_mem == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}
}

void stretch_file(loff_t size)
{
	long c = 1;
	int ret;

	if (verbose)
		printf("stretch file to %Ld\n", size);
	if ((ret = my_pwrite(fd, (const char *)&c,
				sizeof(c), size - sizeof(c))) != sizeof(c)) {
		fprintf(stderr, "%s: my_pwrite returned %d\n", __FUNCTION__, ret);
		perror("my_pwrite");
		exit(1);
	}
}	

/*
 * If another thread truncates the file, we get SIGBUS.
 * Who cares :)
 */
void sigbus(int sig)
{
	long c = 1;
	struct stat statbuf;
	int ret;
	loff_t new_len = sigbus_offset + sizeof(c);

	if (verbose)
		printf("sigbus - stretch to %Ld\n", new_len);
	got_sigbus = 1;
	/* Instantiate the file up to the sigbus address */
	if ((ret = my_pwrite(fd, (const char *)&c, sizeof(c), sigbus_offset)) != sizeof(c)) {
		fprintf(stderr, "%s: my_pwrite returned %d\n",__FUNCTION__,  ret);
		perror("sigbus my_pwrite");
	}
	if (fstat(fd, &statbuf)) {
		perror("fstat");
	}
	if (verbose)
		printf("length is now %ld\n", statbuf.st_size);
}

void set_sigbus_offset(loff_t offset)
{
	sigbus_offset = offset;
}

void install_signal_handler()
{
	signal(SIGBUS, sigbus);
}

void dirty_pages(loff_t offset, loff_t amount)
{
	long *p, val;
	loff_t idx;

	if (offset + amount > size)
		amount = size - offset;

	if (verbose)
		printf("dirty %Ld bytes at %Ld\n", amount, offset);

	val = 0;
	p = mapped_mem;
	amount /= sizeof(*p);
	offset /= sizeof(*p);
	got_sigbus = 0;
	for (idx = 0; idx < amount; idx++) {
		set_sigbus_offset((idx + offset) * sizeof(*p));
		p[idx + offset] = val++;
		if (got_sigbus) {
			if (verbose)
				printf("dirty_pages: sigbus\n");
			break;
		}
	}
}	

void write_stuff(loff_t from, loff_t to, loff_t amount)
{
	int ret;

	if (from + amount > size)
		amount = size - from;
	if (to + amount > size)
		amount = size - to;

	if (verbose)
		printf("my_pwrite %Ld bytes from %Ld to %Ld\n", amount, from, to);

	if ((ret = my_pwrite(fd, (char *)mapped_mem + from, amount, to)) != amount) {
		if (verbose)
			printf("%s: my_pwrite returned %d, not %Ld\n",__FUNCTION__, 
					ret, amount);
		if (errno == EFAULT) {
			/*
			 * It was unmapped under us
			 */
			if (verbose)
				printf("my_pwrite: EFAULT\n");
		} else if (ret < 0) {
			perror("my_pwrite");
			exit(1);
		}
	}
}

#if 1
loff_t rand_of(loff_t arg)
{
	double dret = arg;
	loff_t ret;

	dret *= drand48();
	ret = dret;
#if 0
	if (ret < 0 || ret > 0x40000000)
		printf("I goofed: %Ld\n", ret);
#endif
	return ret;
}
#else
loff_t rand_of(loff_t arg)
{
	return rand() % arg;
}
#endif

void usage(void)
{
	fprintf(stderr, "Usage: %s [-v] [-nN] [-tN] filename size-in-bytes\n", progname);
	fprintf(stderr, "      -v:         Verbose\n"); 
	fprintf(stderr, "     -nN:         Run N iterations\n"); 
	fprintf(stderr, "     -tN:         Run N tasks\n"); 
	exit(1);
}

int main(int argc, char *argv[])
{
	int c;
	int i;
	int niters = -1;

	progname = argv[0];
	while ((c = getopt(argc, argv, "vn:t:")) != -1) {
		switch (c) {
		case 'n':
			niters = strtol(optarg, NULL, 10);
			break;
		case 't':
			ntasks = strtol(optarg, NULL, 10);
			break;
		case 'v':
			verbose++;
			break;
		}
	}

	if (optind == argc)
		usage();
	filename = argv[optind++];
	if (optind == argc)
		usage();
	sscanf(argv[optind++], "%Ld", &size);
	if (optind != argc)
		usage();
	if (size < 10)
		size = 10;
	open_file();

	for (i = 1; i < ntasks; i++) {
		if (fork() == 0)
			break;
	}

	stretch_file(size);
	mmap_file();
	install_signal_handler();
	srand48(time(0) * getpid());
	srand(10 * getpid());

	while (niters--) {
		dirty_pages(rand_of(size), rand_of(size));
		write_stuff(rand_of(size), rand_of(size), rand_of(size));
		ftruncate64(fd, rand_of(size));
		stretch_file(rand_of(size) + 10);
	}
	exit(0);
}

--FN+gV9K+162wdwwF
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--FN+gV9K+162wdwwF--
