Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 19F6729DF8
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 11:17:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E05418F8033
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 09:17:53 -0700 (PDT)
Received: from mail-qa0-f41.google.com (mail-qa0-f41.google.com
	[209.85.216.41]) by cuda.sgi.com with ESMTP id Vj25GKVx7LCSvBv3
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 10 May 2013 09:17:52 -0700 (PDT)
Received: by mail-qa0-f41.google.com with SMTP id bv4so413211qab.14
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 09:17:52 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 May 2013 21:47:51 +0530
Message-ID: <CAEUQcejFPKDqqwbT_BNFJEVkUeAY=mgYGv-kUvLX6Ys7YQkqfg@mail.gmail.com>
Subject: Error during bulk removal of files
From: Subranshu Patel <spatel.ml@gmail.com>
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

I am using mdtest benchmarking tool to remove 7 million files of 1KB.
After some time, the mdtest process gets blocked.

Dmesg shows the following

--------------------->8------------

May 10 18:49:00 machine1 kernel: INFO: task xfssyncd/dm-3:8156 blocked
for more than 120 seconds.

May 10 18:49:00 machine1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.

May 10 18:49:00 machine1 kernel: xfssyncd/dm-3 D 0000000000000002 0
8156 2 0x00000080

May 10 18:49:00 machine1 kernel: ffff88185932bc70 0000000000000046
ffff88185e58a400 ffff8800282566e8

May 10 18:49:00 machine1 kernel: 00000000000176f6 ffff88185fb44080
ffff880c6100aaa0 ffffffff8160b400

May 10 18:49:00 machine1 kernel: ffff88185fb44638 ffff88185932bfd8
000000000000fb88 ffff88185fb44638

May 10 18:49:00 machine1 kernel: Call Trace:

May 10 18:49:00 machine1 kernel: [<ffffffffa056c492>] xlog_wait+0x72/0x90 [xfs]

May 10 18:49:00 machine1 kernel: [<ffffffff81060250>] ?
default_wake_function+0x0/0x20

May 10 18:49:00 machine1 kernel: [<ffffffffa056e08b>]
xlog_grant_log_space+0x3ab/0x520 [xfs]

May 10 18:49:00 machine1 kernel: [<ffffffffa0582d1a>] ?
kmem_zone_zalloc+0x3a/0x50 [xfs]

May 10 18:49:00 machine1 kernel: [<ffffffff8127f3ac>] ? random32+0x1c/0x20

May 10 18:49:00 machine1 kernel: [<ffffffffa057d201>] ?
xfs_trans_ail_push+0x21/0x80 [xfs]

May 10 18:49:00 machine1 kernel: [<ffffffffa056e2e6>]
xfs_log_reserve+0xe6/0x140 [xfs]

May 10 18:49:00 machine1 kernel: [<ffffffffa057bad0>]
xfs_trans_reserve+0xa0/0x210 [xfs]

May 10 18:49:00 machine1 kernel: [<ffffffffa055f0a3>]
xfs_fs_log_dummy+0x43/0x90 [xfs]

May 10 18:49:00 machine1 kernel: [<ffffffffa056c9c4>] ?
xfs_log_need_covered+0x94/0xd0 [xfs]

May 10 18:49:00 machine1 kernel: [<ffffffffa0591831>]
xfs_sync_worker+0x81/0x90 [xfs]

May 10 18:49:00 machine1 kernel: [<ffffffffa059171e>] xfssyncd+0x17e/0x210 [xfs]

May 10 18:49:00 machine1 kernel: [<ffffffffa05915a0>] ? xfssyncd+0x0/0x210 [xfs]

May 10 18:49:00 machine1 kernel: [<ffffffff81091d66>] kthread+0x96/0xa0

May 10 18:49:00 machine1 kernel: [<ffffffff8100c14a>] child_rip+0xa/0x20

May 10 18:49:00 machine1 kernel: [<ffffffff81091cd0>] ? kthread+0x0/0xa0

May 10 18:49:00 machine1 kernel: [<ffffffff8100c140>] ? child_rip+0x0/0x20

--------------------->8------------

The XFS filesystem size is 14TB (LVM), kernel version 2.6.32

Machine has a memory of 96GB

Please let me know if this is a known issue and have been already
fixed in higher kernel version.

--
Subranshu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
