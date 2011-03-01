Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p21114TD167057 for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 19:01:04 -0600
Received: from mail.mnsu.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E8EA30577B
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 17:03:52 -0800 (PST)
Received: from mail.mnsu.edu (Mail.MNSU.EDU [134.29.1.12]) by cuda.sgi.com
	with ESMTP id DtiCzlpFvAze7le6 for <xfs@oss.sgi.com>;
	Mon, 28 Feb 2011 17:03:52 -0800 (PST)
Message-ID: <4D6C45EE.80203@mnsu.edu>
Date: Mon, 28 Feb 2011 19:03:42 -0600
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
MIME-Version: 1.0
Subject: Re: kernel panic - stack-protector: kernel stack is corrupted in:
	f87aca93
References: <4D6C28A5.60905@mnsu.edu> <4D6C372E.6030105@sandeen.net>
In-Reply-To: <4D6C372E.6030105@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com



On 02/28/2011 06:00 PM, Eric Sandeen wrote:
> On 2/28/11 4:58 PM, Jeffrey Hundstad wrote:
>    
>> Hello,
>>
>> I'm compiling the main Linux branch commit 493f3358cb289ccf716c5a14fa5bb52ab75943e5 with no other patches.  It boots and seems to operate fine.  When I do an xfs_fsr it Kernel panics.  I can easily reproduce it
>>
>> Kernel Panic: (hand copied, photo available)
>>
>> Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: f87aca93
>>
>> Pid: 262, comm: xfs_fsr Not tainted 2.6.38-rc6-493f3358cb2+ #1
>> Call Trace:
>>
>> [<c12991ac>] ? panic+0x50/0x150
>> [<c102ed71>] ? __stack_chk_fail+0x10/0x18
>> [<f87aca93>] ? xfs_ioc_fsgeometry_v1+0x56/0x5d [xfs]
>> [<f87aca93>] ? xfs_ioc_fsgeometry_v1+0x56/0x5d [xfs]
>> [<f87ae062>] ? xfs_file_ioctl+0x33c/0x6fe [xfs]
>> [<c1047f1a>] ? sched_clock_cpu+0x130/0x140
>> [<c1050f41>] ? trace_hardirqs_off+0xb/0xd
>> [<c1047f57>] ? local_clock+0x2d/0x4e
>> [<c1050f6e>] ? lock_release_holdtime+0x2b/0xcd
>> [<c10a925a>] ? check_valid_pointer+0x1c/0x48
>> [<c10a99c8>] ? check_object+0x122/0x156
>> [<f87add26>] ? xfs_file_ioctl+0x0/0x6fe [xfs]
>> [<c10bf5c9>] ? do_vfs_ioctl+0x483/0x4c8
>> [<c10aab72>] ? kmeme_chache_free+0x8f/0x9b
>> [<c10b41b4>] ? fcheck_files+0xa1/0xd0
>> [<c10bf64f>] ? sys_ioctl+0x41/0x61
>> [<c1002893>] ? sysenter_do_call+0x12/0x32
>>
>>
>>
>> You can find the config, initrd.img, vmlinuz and crash screen at:
>> http://krypton.mnsu.edu/~j3gum/linux-error-20110228/
>>
>> - gcc (Debian 4.4.5-13) 4.4.5
>> - xfs_fsr version 3.1.4
>>
>>
>> Please let know if you'd like more info.
>>
>>      
> I tried to extract your vmlinuz to a vmlinux to disassemble and look at stack usage of functions, but that was painful and did not seem to work out in the end.  :)
>
> Can you do:
>
> objdump -d vmlinux | scripts/checkstack.pl
>
> and similar for xfs if it's a module:
>
> objdump -d xfs.ko | scripts/checkstack.pl
>
> and see how big each of the functions on the above backtrace is, in your kernel?
>
>    

Sadly, I didn't have the vmlinux file around anymore.  I'll be glad to 
recreate it when I get in tomorrow.  However, I have revered commit 
3a3675b7f23f83ca8c67c9c2b6edf707fd28d1ba and the problem seems to have 
vanished.  I'm guessing the stack at this point is a little to fragile 
for a memset.  The patch is:


commit 3a3675b7f23f83ca8c67c9c2b6edf707fd28d1ba
Author: Dan Rosenberg <drosenberg@vsecurity.com>
Date:   Mon Feb 14 13:45:28 2011 +0000

     xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1

     The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
     xfs_fs_geometry() with a version number of 3.  This code path does not
     fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
     the leaking of four bytes of uninitialized stack data to potentially
     unprivileged callers.

     v2 switches to memset() to avoid future issues if structure members
     change, on suggestion of Dave Chinner.

     Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
     Reviewed-by: Eugene Teo <eugeneteo@kernel.org>
     Signed-off-by: Alex Elder <aelder@sgi.com>

diff --git b/fs/xfs/xfs_fsops.c a/fs/xfs/xfs_fsops.c
index cec89dd..85668ef 100644
--- b/fs/xfs/xfs_fsops.c
+++ a/fs/xfs/xfs_fsops.c
@@ -53,6 +53,9 @@ xfs_fs_geometry(
         xfs_fsop_geom_t         *geo,
         int                     new_version)
  {
+
+       memset(geo, 0, sizeof(*geo));
+
         geo->blocksize = mp->m_sb.sb_blocksize;
         geo->rtextsize = mp->m_sb.sb_rextsize;
         geo->agblocks = mp->m_sb.sb_agblocks;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
