Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1DC5B7F50
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2013 02:32:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E57ED8F8040
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2013 00:32:17 -0800 (PST)
Received: from USMAMAIL.TILERA.COM (usmamail.tilera.com [12.216.194.151]) by
	cuda.sgi.com with ESMTP id bWWJPOMeXRAAlGtu (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Feb 2013 00:32:16 -0800 (PST)
From: Tony Lu <zlu@tilera.com>
Subject: RE: [PATCH] xfs: Fix possible truncation of log data in
	xlog_bread_noalign()
Date: Sat, 23 Feb 2013 08:32:09 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C47C48715@USMAExch1.tad.internal.tilera.com>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
	<20130222191426.GW22182@sgi.com>
In-Reply-To: <20130222191426.GW22182@sgi.com>
Content-Language: zh-CN
MIME-Version: 1.0
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
To: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

>-----Original Message-----
>From: Ben Myers [mailto:bpm@sgi.com]
>
>Hi Tony,
>
>On Fri, Feb 22, 2013 at 08:12:52AM +0000, Tony Lu wrote:
>> I encountered the following panic when using xfs partitions as rootfs, which
>> is due to the truncated log data read by xlog_bread_noalign(). We should
>> extend the buffer by one extra log sector to ensure there's enough space to
>> accommodate requested log data, which we indeed did in xlog_get_bp(), but we
>> forgot to do in xlog_bread_noalign().
>>
>> XFS mounting filesystem sda2
>> Starting XFS recovery on filesystem: sda2 (logdev: internal)
>> XFS: xlog_recover_process_data: bad clientid
>> XFS: log mount/recovery failed: error 5
>> XFS: log mount failedVFS: Cannot open root device "sda2" or unknown-block(8,)
>> Please append a correct "root=" boot option; here are the available partitio:
>> 0800       156290904 sda  driver: sd
>>   0801        31463271 sda1 00000000-0000-0000-0000-000000000000
>>   0802        31463302 sda2 00000000-0000-0000-0000-000000000000
>>   0803        31463302 sda3 00000000-0000-0000-0000-000000000000
>>   0804               1 sda4 00000000-0000-0000-0000-000000000000
>>   0805        10490413 sda5 00000000-0000-0000-0000-000000000000
>>   0806        51407968 sda6 00000000-0000-0000-0000-000000000000
>> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,)
>>
>> Starting stack dump of tid 1, pid 1 (swapper) on cpu 35 at cycle 42273138234
>>   frame 0: 0xfffffff70016e5a0 dump_stack+0x0/0x20 (sp 0xfffffe03fbedfe88)
>>   frame 1: 0xfffffff7004af470 panic+0x150/0x3a0 (sp 0xfffffe03fbedfe88)
>>   frame 2: 0xfffffff700881e88 mount_block_root+0x2c0/0x4c8 (sp
>0xfffffe03fbe)
>>   frame 3: 0xfffffff700882390 prepare_namespace+0x250/0x358 (sp
>0xfffffe03fb)
>>   frame 4: 0xfffffff700880778 kernel_init+0x4c8/0x520 (sp
>0xfffffe03fbedffb0)
>>   frame 5: 0xfffffff70011ecb8 start_kernel_thread+0x18/0x20 (sp
>0xfffffe03fb)
>> Stack dump complete
>>
>> Signed-off-by: Zhigang Lu <zlu@tilera.com>
>> Reviewed-by: Chris Metcalf <cmetcalf@tilera.com>
>
>Looks fine to me.  I'll pull it in after some testing.
>
>Do you happen to have a metadump of this filesystem?
>
>Reviewed-by: Ben Myers <bpm@sgi.com>

Sorry I did not keep the metadump of it. But I kept some debugging info when I debugged and fixed it a year ago.

Starting XFS recovery on filesystem: ram0 (logdev: internal)
xlog_bread_noalign--before round down/up: blk_no=0xf4d,nbblks=0x1
xlog_bread_noalign--after round down/up: blk_no=0xf4c,nbblks=0x4
xlog_bread_noalign--before round down/up: blk_no=0xf4d,nbblks=0x1
xlog_bread_noalign--after round down/up: blk_no=0xf4c,nbblks=0x4
xlog_bread_noalign--before round down/up: blk_no=0xf4e,nbblks=0x3f
xlog_bread_noalign--after round down/up: blk_no=0xf4c,nbblks=0x40
XFS: xlog_recover_process_data: bad clientid
Assertion failed: 0, file: /home/scratch/zlu/zlu-main/sys/linux/source/fs/xfs/xfs_log_recover.c, line: 2852
BUG: failure at /home/scratch/zlu/zlu-main/sys/linux/source/fs/xfs/support/debug.c:100/assfail()!
Kernel panic - not syncing: BUG!

Starting stack dump of tid 843, pid 843 (mount) on cpu 1 at cycle 345934778384
  frame 0: 0xfffffff7001380a0 dump_stack+0x0/0x20 (sp 0xfffffe43e55df7b0)
  frame 1: 0xfffffff7003b5470 panic+0x150/0x3a0 (sp 0xfffffe43e55df7b0)
  frame 2: 0xfffffff700824cf0 assfail+0x80/0x80 (sp 0xfffffe43e55df858)
  frame 3: 0xfffffff70037c7c0 xlog_recover_process_data+0x598/0x698 (sp 0xfffffe43e55df868)
  frame 4: 0xfffffff7002c55e8 xlog_do_recovery_pass+0x810/0x908 (sp 0xfffffe43e55df8e8)
  frame 5: 0xfffffff70068f0d8 xlog_do_log_recovery+0xc8/0x1d8 (sp 0xfffffe43e55dfa48)
  frame 6: 0xfffffff70054cf60 xlog_do_recover+0x48/0x380 (sp 0xfffffe43e55dfa88)
  frame 7: 0xfffffff7006fdbf0 xlog_recover+0x138/0x170 (sp 0xfffffe43e55dfac0)
  frame 8: 0xfffffff7005b2d70 xfs_log_mount+0x150/0x2e8 (sp 0xfffffe43e55dfb00)
  frame 9: 0xfffffff700269830 xfs_mountfs+0x510/0xb20 (sp 0xfffffe43e55dfb38)
  frame 10: 0xfffffff700486930 xfs_fs_fill_super+0x2e0/0x3f0 (sp 0xfffffe43e55dfba8)
  frame 11: 0xfffffff7000950c8 mount_bdev+0x168/0x2d0 (sp 0xfffffe43e55dfbe0)
  frame 12: 0xfffffff700071e08 vfs_kern_mount+0x110/0x408 (sp 0xfffffe43e55dfc50)
  frame 13: 0xfffffff7000badf8 do_kern_mount+0x68/0x1e0 (sp 0xfffffe43e55dfc98)
  frame 14: 0xfffffff700046470 do_mount+0x200/0x878 (sp 0xfffffe43e55dfcd8)
  frame 15: 0xfffffff7000c8050 sys_mount+0xd0/0x1a0 (sp 0xfffffe43e55dfd60)
  frame 16: 0xfffffff7001a2c30 handle_syscall+0x280/0x340 (sp 0xfffffe43e55dfdc0)
  <syscall while in user mode>
  frame 17: 0xaaaad46688 libc-2.12.so[aaaac20000+1d0000] (sp 0x1ffffddf4b0)
  frame 18: 0x15555555560 mount[15555550000+20000] (sp 0x1ffffddf4b0)
  frame 19: 0x15555557dc0 mount[15555550000+20000] (sp 0x1ffffddf500)
  frame 20: 0x15555558a80 mount[15555550000+20000] (sp 0x1ffffddf858)
  frame 21: 0x15555559a60 mount[15555550000+20000] (sp 0x1ffffddf930)
  frame 22: 0xaaaac3e5e8 libc-2.12.so[aaaac20000+1d0000] (sp 0x1ffffddfaf8)
Stack dump complete
Client requested halt.

Thanks
-Tony

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
