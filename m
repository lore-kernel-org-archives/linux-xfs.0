Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 001F87F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 22:09:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E13EF8F8033
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 20:09:18 -0700 (PDT)
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166]) by
	cuda.sgi.com with ESMTP id byMMoWwfackGC0A4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 20:09:15 -0700 (PDT)
Message-ID: <559F3750.5040002@unitedstack.com>
Date: Fri, 10 Jul 2015 11:09:04 +0800
From: juncheng bai <baijuncheng@unitedstack.com>
MIME-Version: 1.0
Subject: [xfs puzzle] kmem_alloc hang in xlog_cil_insert_format_items
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, bfoster@redhat.com, sandeen@sandeen.net
Cc: xfs@oss.sgi.com

Hi,All.

Recently, I test xfs to verify kmem_alloc hang in xfs_dir2_block_to_sf 
in kernel-3.14, for patch b3f03bac8132207a20286d5602eda64500c19724.

My test case:
I use three ssd disks to build three xfs filesystems.

My mount options:
rw,noexec,nodev,noatime,nodiratime,barrier=0,discard,inode64,logbsize=256k,delaylog

Each xfs filesystem run a postmark and two fio.

postmark parameter:
set size 100000 100000000
set location /var/xfs-0/
set seed 900
set number 100000
set subdirectories 5000
set read 40960 65536000
set write 40960 65536000
set transactions 10000
set bias create 40
set bias read 60
run xfs-0-result.txt
show

fio parameter:
fio -directory /var/${1} -rw=randrw -ioengine=libaio -iodepth=128 
-size=128M -name=stress_test -numjobs=256

After running for five hours , the output of warning all the time:
2015-07-07T23:32:18.230120+00:00 server-69 kernel: XFS: possible memory 
allocation deadlock in kmem_alloc (mode:0x8250 size:32832)
2015-07-07T23:32:18.230131+00:00 server-69 kernel: CPU: 1 PID: 15954 
Comm: postmark Tainted: G O 3.12.21-1.el6.x86_64 #1
2015-07-07T23:32:18.230134+00:00 server-69 kernel: Hardware name: Dell 
Inc. PowerEdge R630/0CNCJW, BIOS 1.2.10 03/09/2015
2015-07-07T23:32:18.230147+00:00 server-69 kernel: 0000000000000000 
ffff880481c99bb8 ffffffff8162562a 0000000000008040
2015-07-07T23:32:18.230148+00:00 server-69 kernel: 000000000000044c 
ffff880481c99bf8 ffffffffa06c457c ffff880481c99bf8
2015-07-07T23:32:18.230149+00:00 server-69 kernel: ffff88086936bcf0 
ffff8804a17ecd00 ffff880066a48000 ffff880044158000
2015-07-07T23:32:18.230150+00:00 server-69 kernel: Call Trace:
2015-07-07T23:32:18.230152+00:00 server-69 kernel: [<ffffffff8162562a>] 
dump_stack+0x49/0x5f
2015-07-07T23:32:18.230153+00:00 server-69 kernel: [<ffffffffa06c457c>] 
kmem_alloc+0xec/0x100 [xfs]
2015-07-07T23:32:18.230186+00:00 server-69 kernel: [<ffffffffa0709b6f>] 
xlog_cil_insert_format_items+0x11f/0x1f0 [xfs]
2015-07-07T23:32:18.230205+00:00 server-69 kernel: [<ffffffffa06d0d00>] 
? xfs_bmap_last_offset+0x30/0xc0 [xfs]
2015-07-07T23:32:18.230211+00:00 server-69 kernel: [<ffffffffa0709d8d>] 
xlog_cil_insert_items+0x3d/0x1b0 [xfs]
2015-07-07T23:32:18.230212+00:00 server-69 kernel: [<ffffffffa070a484>] 
xfs_log_commit_cil+0x54/0x150 [xfs]
2015-07-07T23:32:18.230228+00:00 server-69 kernel: [<ffffffffa06c3cb9>] 
xfs_trans_commit+0x79/0x270 [xfs]
2015-07-07T23:32:18.230230+00:00 server-69 kernel: [<ffffffffa06f78c2>] 
xfs_remove+0x2d2/0x350 [xfs]
2015-07-07T23:32:18.230235+00:00 server-69 kernel: [<ffffffff811c882f>] 
? d_walk+0x5f/0x260
2015-07-07T23:32:18.230236+00:00 server-69 kernel: [<ffffffffa06b9782>] 
xfs_vn_unlink+0x52/0xa0 [xfs]
2015-07-07T23:32:18.230237+00:00 server-69 kernel: [<ffffffff811be22b>] 
vfs_rmdir+0xbb/0x110
2015-07-07T23:32:18.230238+00:00 server-69 kernel: [<ffffffff811c14a3>] 
do_rmdir+0x203/0x220
2015-07-07T23:32:18.230239+00:00 server-69 kernel: [<ffffffff811c1516>] 
SyS_rmdir+0x16/0x20
2015-07-07T23:32:18.230240+00:00 server-69 kernel: [<ffffffff81632729>] 
system_call_fastpath+0x16/0x1b

In function kmem_alloc, I modify code to get more info:
57c57
<         if (!(++retries % 100))
---
 >         if (!(++retries % 100)) {
59,60c59,62
<         "possible memory allocation deadlock in %s (mode:0x%x)",
<                     __func__, lflags);
---
 >         "possible memory allocation deadlock in %s (mode:0x%x,
size:%zu)",
 >                     __func__, lflags, size);
 >             dump_stack();
 >         }

The patch b3f03bac8132207a20286d5602eda64500c19724 solves the problem of 
the big directroy size, more than 64k.
Now, the 'struct txfs_log_vec' need 32k, but fail when the physical 
memory fragmentation is very serious; In the later, kmalloc may fail 
when process 16k.

So, I think can we provide a unified solution? And I think why can't we
use vmalloc when kmalloc fails?

Thanks
----------------
juncheng bai




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
