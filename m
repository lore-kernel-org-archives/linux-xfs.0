Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0BB2F7F58
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 22:34:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A4CFAC002
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 20:34:12 -0700 (PDT)
Received: from mail-qa0-f46.google.com (mail-qa0-f46.google.com
	[209.85.216.46]) by cuda.sgi.com with ESMTP id fMOfH4HkZS6pEsQP
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 Jun 2014 20:34:10 -0700 (PDT)
Received: by mail-qa0-f46.google.com with SMTP id i13so6506114qae.33
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 20:34:10 -0700 (PDT)
Message-ID: <53A8F1AC.90109@gmail.com>
Date: Mon, 23 Jun 2014 23:34:04 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: Null pointer dereference while at ACL limit on v5 XFS
References: <53A8A0AF.9070009@gmail.com> <53A8A578.4070005@sgi.com>
	<53A8A676.80305@sgi.com>
In-Reply-To: <53A8A676.80305@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 06/23/2014 06:13 PM, Mark Tinguely wrote:
> On 06/23/14 17:08, Mark Tinguely wrote:
>> On 06/23/14 16:48, Michael L. Semon wrote:
>>> At the ACL limit of v5-superblock XFS--with a directory filled with
>>> both default
>>> and access ACL entries--I'm getting a null pointer dereference on x86
>>> after
>>> creating the directory successfully.
>>>
>>> Disclaimer: There's some current issues on 32-bit x86 that, for
>>> instance, can
>>> make badblocks see phantom bad blocks on a read test. My apologies in
>>> advance
>>> if this turns out to be a false alarm bug report.
>>>
>>> My first encounter with this issue involved fsstress. Here's part of a
>>> `crash`
>>> session from the fsstress run.
>>>
>>> root@oldsvrhw:/mnt/crashdump/xfs-fsstress-max-acl-2# crash vmlinux
>>> System.map vmcore
>>> crash 7.0.4
> ...
>>> Thanks!
>>>
>>> Michael
>>>
>>
>> Michael, do you have the vmcore dump for this or was this just from the
>> messages.
>>
>> Thanks.
>>
>> --Mark.
> 
> ummm, duh me. you were running crash ...
> 
> Can I look at the core?
> 
> --Mark.

Sure!  I've uploaded two sets of core dumps (vmcore, vmlinux, System.map, 
config, sample crash session) and put them here for a short time:

https://drive.google.com/folderview?id=0B41268QKoNjtUGFpcTlCbEdkQXM

xfs-fsstress-max-acl-2.tar.xz has the dmesg that was originally posted.

xfs-fsstress-max-acl-3.tar.xz came from the simple mkdir/rm test.  I got 
lucky with this simple test because the message looks like it came from 
the kernel linked list diagnostic:

[ 1068.431391] ------------[ cut here ]------------
[ 1068.431566] WARNING: CPU: 0 PID: 41 at lib/list_debug.c:59 __list_del_entry+0xce/0x110()
[ 1068.431596] list_del corruption. prev->next should be db5bf580, but was   (null)
[ 1068.431629] CPU: 0 PID: 41 Comm: kworker/0:1H Not tainted 3.16.0-rc1+ #3
[ 1068.431656] Hardware name: Dell Computer Corporation       L733r                          /CA810E                         , BIOS A14 09/05/2001
[ 1068.431697] Workqueue: xfslogd xfs_buf_iodone_work
[ 1068.431738]  00000000 00000000 de92fc24 c15d4e76 de92fc68 de92fc58 c103ca33 c1737648
[ 1068.431891]  de92fc84 00000029 c173705a 0000003b c13c3e9e 0000003b c13c3e9e 0000003b
[ 1068.432115]  db5bf580 00000001 de92fc70 c103cab3 00000009 de92fc68 c1737648 de92fc84
[ 1068.432267] Call Trace:
[ 1068.432329]  [<c15d4e76>] dump_stack+0x48/0x60
[ 1068.432386]  [<c103ca33>] warn_slowpath_common+0x83/0xa0
[ 1068.432433]  [<c13c3e9e>] ? __list_del_entry+0xce/0x110
[ 1068.432478]  [<c13c3e9e>] ? __list_del_entry+0xce/0x110
[ 1068.432524]  [<c103cab3>] warn_slowpath_fmt+0x33/0x40
[ 1068.432569]  [<c13c3e9e>] __list_del_entry+0xce/0x110
[ 1068.432615]  [<c13c3eeb>] list_del+0xb/0x20
[ 1068.432674]  [<c126eb4d>] xfs_ail_delete+0x1d/0x60
[ 1068.432721]  [<c126f945>] xfs_trans_ail_update_bulk+0x1a5/0x410
[ 1068.432780]  [<c12070ab>] xfs_trans_committed_bulk+0x2eb/0x320
[ 1068.432827]  [<c126957a>] xlog_cil_committed+0x3a/0x150
[ 1068.432874]  [<c12655ba>] xlog_state_do_callback+0x18a/0x390
[ 1068.432919]  [<c1265883>] xlog_state_done_syncing+0xc3/0xe0
[ 1068.432964]  [<c126590e>] xlog_iodone+0x6e/0x100
[ 1068.433055]  [<c11e821b>] xfs_buf_iodone_work+0x5b/0xe0
[ 1068.433114]  [<c1058557>] process_one_work+0x1b7/0x5d0
[ 1068.433160]  [<c10584da>] ? process_one_work+0x13a/0x5d0
[ 1068.433205]  [<c1058a1b>] ? worker_thread+0xab/0x4b0
[ 1068.433250]  [<c10589a9>] worker_thread+0x39/0x4b0
[ 1068.433304]  [<c108909b>] ? trace_hardirqs_on+0xb/0x10
[ 1068.433350]  [<c1058970>] ? process_one_work+0x5d0/0x5d0
[ 1068.433398]  [<c105fb58>] kthread+0xa8/0xc0
[ 1068.433444]  [<c108909b>] ? trace_hardirqs_on+0xb/0x10
[ 1068.433495]  [<c15dc781>] ret_from_kernel_thread+0x21/0x30
[ 1068.433540]  [<c105fab0>] ? insert_kthread_work+0x80/0x80
[ 1068.433567] ---[ end trace 60289514948e4bd7 ]---
[ 1068.433603] BUG: unable to handle kernel NULL pointer dereference at 0000000c
[ 1068.433795] IP: [<c126eac8>] xfs_ail_check+0x58/0xc0
[ 1068.433925] *pde = 00000000 
[ 1068.434027] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[ 1068.434027] CPU: 0 PID: 41 Comm: kworker/0:1H Tainted: G        W     3.16.0-rc1+ #3
[ 1068.434027] Hardware name: Dell Computer Corporation       L733r                          /CA810E                         , BIOS A14 09/05/2001
[ 1068.434027] Workqueue: xfslogd xfs_buf_iodone_work
[ 1068.434027] task: de8faac0 ti: de92e000 task.ti: de92e000
[ 1068.434027] EIP: 0060:[<c126eac8>] EFLAGS: 00010286 CPU: 0
[ 1068.434027] EIP is at xfs_ail_check+0x58/0xc0
[ 1068.434027] EAX: 00000000 EBX: db5bf0b0 ECX: 00000015 EDX: 00000015
[ 1068.434027] ESI: 00000001 EDI: 00000001 EBP: de92fc9c ESP: de92fc90
[ 1068.434027]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 1068.434027] CR0: 8005003b CR2: 0000000c CR3: 00ab9000 CR4: 000007d0
[ 1068.434027] Stack:
[ 1068.434027]  ddc81d80 db5bf0b0 00000001 de92fcac c126eb43 db5bf0b0 00000005 de92fd04
[ 1068.434027]  c126f945 00000000 00000001 00000000 00000000 ddc81d88 de92fd38 db04b210
[ 1068.434027]  ddc81d80 00000000 00000015 de92fd44 ddc81d80 00000001 00000037 00000005
[ 1068.434027] Call Trace:
[ 1068.434027]  [<c126eb43>] xfs_ail_delete+0x13/0x60
[ 1068.434027]  [<c126f945>] xfs_trans_ail_update_bulk+0x1a5/0x410
[ 1068.434027]  [<c12070ab>] xfs_trans_committed_bulk+0x2eb/0x320
[ 1068.434027]  [<c126957a>] xlog_cil_committed+0x3a/0x150
[ 1068.434027]  [<c12655ba>] xlog_state_do_callback+0x18a/0x390
[ 1068.434027]  [<c1265883>] xlog_state_done_syncing+0xc3/0xe0
[ 1068.434027]  [<c126590e>] xlog_iodone+0x6e/0x100
[ 1068.434027]  [<c11e821b>] xfs_buf_iodone_work+0x5b/0xe0
[ 1068.434027]  [<c1058557>] process_one_work+0x1b7/0x5d0
[ 1068.434027]  [<c10584da>] ? process_one_work+0x13a/0x5d0
[ 1068.434027]  [<c1058a1b>] ? worker_thread+0xab/0x4b0
[ 1068.434027]  [<c10589a9>] worker_thread+0x39/0x4b0
[ 1068.434027]  [<c108909b>] ? trace_hardirqs_on+0xb/0x10
[ 1068.434027]  [<c1058970>] ? process_one_work+0x5d0/0x5d0
[ 1068.434027]  [<c105fb58>] kthread+0xa8/0xc0
[ 1068.434027]  [<c108909b>] ? trace_hardirqs_on+0xb/0x10
[ 1068.434027]  [<c15dc781>] ret_from_kernel_thread+0x21/0x30
[ 1068.434027]  [<c105fab0>] ? insert_kthread_work+0x80/0x80
[ 1068.434027] Code: c1 b8 50 be 72 c1 e8 38 f7 f8 ff 8b 43 04 39 c6 74 10 8b 7b 0c 39 78 0c 8b 53 08 8b 48 08 74 43 73 45 8b 03 39 c6 74 24 8b 73 0c <39> 70 0c 8b 53 08 8b 48 08 74 4d 73 14 b9 38 00 00 00 ba 83 a3
[ 1068.434027] EIP: [<c126eac8>] xfs_ail_check+0x58/0xc0 SS:ESP 0068:de92fc90
[ 1068.434027] CR2: 000000000000000c

I can reproduce the oops in kernel 3.15.0, perhaps with xfs-oss/for-next 
merged, but there's no vmlinux to go with the kernel.  Therefore, I'll have 
to resort to other means (rebuilt kernel with netconsole, re-attaching the 
serial cable, etc.) to get the full crash log.

Thanks for looking into this!  I'll take Dave's advice on tracing, too, but 
it will be morning before I can collect the results.

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
