Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B00E329DF8
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 08:31:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 36CFAAC005
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 06:31:15 -0700 (PDT)
Received: from mail-qa0-f48.google.com (mail-qa0-f48.google.com
	[209.85.216.48]) by cuda.sgi.com with ESMTP id mB3hy7NiGfA7aS0Q
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Jun 2014 06:31:12 -0700 (PDT)
Received: by mail-qa0-f48.google.com with SMTP id x12so231678qac.21
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 06:31:12 -0700 (PDT)
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Tue, 24 Jun 2014 09:31:05 -0400 (EDT)
Subject: Re: Null pointer dereference while at ACL limit on v5 XFS
In-Reply-To: <20140624040434.GC9508@dastard>
Message-ID: <alpine.LNX.2.11.1406240919490.5954@bpserver.ds>
References: <53A8A0AF.9070009@gmail.com> <53A8A578.4070005@sgi.com>
	<53A8A676.80305@sgi.com> <53A8F1AC.90109@gmail.com>
	<20140624040434.GC9508@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Tue, 24 Jun 2014, Dave Chinner wrote:

> On Mon, Jun 23, 2014 at 11:34:04PM -0400, Michael L. Semon wrote:
> > [ 1068.431391] ------------[ cut here ]------------
> > [ 1068.431566] WARNING: CPU: 0 PID: 41 at lib/list_debug.c:59 __list_del_entry+0xce/0x110()
> > [ 1068.431596] list_del corruption. prev->next should be db5bf580, but was   (null)
> 
> Ok, so the current log item points to a log item that has
> null pointers (i.e. not on the list).
> 
> > [ 1068.431629] CPU: 0 PID: 41 Comm: kworker/0:1H Not tainted 3.16.0-rc1+ #3
> > [ 1068.431656] Hardware name: Dell Computer Corporation       L733r                          /CA810E                         , BIOS A14 09/05/2001
> > [ 1068.431697] Workqueue: xfslogd xfs_buf_iodone_work
> > [ 1068.431738]  00000000 00000000 de92fc24 c15d4e76 de92fc68 de92fc58 c103ca33 c1737648
> > [ 1068.431891]  de92fc84 00000029 c173705a 0000003b c13c3e9e 0000003b c13c3e9e 0000003b
> > [ 1068.432115]  db5bf580 00000001 de92fc70 c103cab3 00000009 de92fc68 c1737648 de92fc84
> > [ 1068.432267] Call Trace:
> > [ 1068.432329]  [<c15d4e76>] dump_stack+0x48/0x60
> > [ 1068.432386]  [<c103ca33>] warn_slowpath_common+0x83/0xa0
> > [ 1068.432433]  [<c13c3e9e>] ? __list_del_entry+0xce/0x110
> > [ 1068.432478]  [<c13c3e9e>] ? __list_del_entry+0xce/0x110
> > [ 1068.432524]  [<c103cab3>] warn_slowpath_fmt+0x33/0x40
> > [ 1068.432569]  [<c13c3e9e>] __list_del_entry+0xce/0x110
> > [ 1068.432615]  [<c13c3eeb>] list_del+0xb/0x20
> > [ 1068.432674]  [<c126eb4d>] xfs_ail_delete+0x1d/0x60
> ....
> > [ 1068.433567] ---[ end trace 60289514948e4bd7 ]---
> > [ 1068.433603] BUG: unable to handle kernel NULL pointer dereference at 0000000c
> > [ 1068.433795] IP: [<c126eac8>] xfs_ail_check+0x58/0xc0
> 
> And that's trying to dereference a pointer from an item that is not
> on the list....
> 
> So there's linked list corruption occurring here.
> 
> > I can reproduce the oops in kernel 3.15.0, perhaps with xfs-oss/for-next 
> > merged, but there's no vmlinux to go with the kernel.  Therefore, I'll have 
> > to resort to other means (rebuilt kernel with netconsole, re-attaching the 
> > serial cable, etc.) to get the full crash log.
> 
> How far back can you reproduce it? If it's a recent occurrence, can
> you bisect it?
> 
> Cheers,
> 
> Dave.

I'll attempt to bisect this issue.  3.15.0 was tried simply because it didn't 
have any noticeable 32-bit oddities.  In fact, I liked 3.15 enough to base 
glibc on its headers.  Here's hoping that I can reproduce the issue on a 
3.10-based utility partition.  [Somewhere out there is a Murphy's Law of 
glibc Upgrades that describes this situation perfectly.]

Should it shed any extra light, here's the ftrace-dump-enabled dmesg from the 
most recent crash (mkdir/rm test), after my closing.

Thanks!  A Pentium III can bisect kernels only so quickly, so this will take 
some time.

Michael

[ 1739.697955] XFS (hdc4): Mounting V5 Filesystem
[ 1739.866245] XFS (hdc4): Ending clean mount
[ 1752.763551] mkdir (406) used greatest stack depth: 4876 bytes left
[ 1762.611092] ------------[ cut here ]------------
[ 1762.611259] WARNING: CPU: 0 PID: 41 at lib/list_debug.c:59 __list_del_entry+0xce/0x110()
[ 1762.611288] list_del corruption. prev->next should be ddf46000, but was   (null)
[ 1762.611320] CPU: 0 PID: 41 Comm: kworker/0:1H Not tainted 3.16.0-rc1+ #3
[ 1762.611348] Hardware name: Dell Computer Corporation       L733r                          /CA810E                         , BIOS A14 09/05/2001
[ 1762.611389] Workqueue: xfslogd xfs_buf_iodone_work
[ 1762.611432]  00000000 00000000 de92fc24 c15d4e76 de92fc68 de92fc58 c103ca33 c1737648
[ 1762.611584]  de92fc84 00000029 c173705a 0000003b c13c3e9e 0000003b c13c3e9e 0000003b
[ 1762.611734]  ddf46000 00000001 de92fc70 c103cab3 00000009 de92fc68 c1737648 de92fc84
[ 1762.611886] Call Trace:
[ 1762.611947]  [<c15d4e76>] dump_stack+0x48/0x60
[ 1762.611999]  [<c103ca33>] warn_slowpath_common+0x83/0xa0
[ 1762.612121]  [<c13c3e9e>] ? __list_del_entry+0xce/0x110
[ 1762.612166]  [<c13c3e9e>] ? __list_del_entry+0xce/0x110
[ 1762.612212]  [<c103cab3>] warn_slowpath_fmt+0x33/0x40
[ 1762.612257]  [<c13c3e9e>] __list_del_entry+0xce/0x110
[ 1762.612303]  [<c13c3eeb>] list_del+0xb/0x20
[ 1762.612361]  [<c126eb4d>] xfs_ail_delete+0x1d/0x60
[ 1762.612407]  [<c126f945>] xfs_trans_ail_update_bulk+0x1a5/0x410
[ 1762.612468]  [<c12070ab>] xfs_trans_committed_bulk+0x2eb/0x320
[ 1762.612515]  [<c126957a>] xlog_cil_committed+0x3a/0x150
[ 1762.612561]  [<c12655ba>] xlog_state_do_callback+0x18a/0x390
[ 1762.612606]  [<c1265883>] xlog_state_done_syncing+0xc3/0xe0
[ 1762.612651]  [<c126590e>] xlog_iodone+0x6e/0x100
[ 1762.612697]  [<c11e821b>] xfs_buf_iodone_work+0x5b/0xe0
[ 1762.612753]  [<c1058557>] process_one_work+0x1b7/0x5d0
[ 1762.612798]  [<c10584da>] ? process_one_work+0x13a/0x5d0
[ 1762.612843]  [<c1058a1b>] ? worker_thread+0xab/0x4b0
[ 1762.612888]  [<c10589a9>] worker_thread+0x39/0x4b0
[ 1762.612940]  [<c108909b>] ? trace_hardirqs_on+0xb/0x10
[ 1762.612986]  [<c1058970>] ? process_one_work+0x5d0/0x5d0
[ 1762.613086]  [<c105fb58>] kthread+0xa8/0xc0
[ 1762.613132]  [<c108909b>] ? trace_hardirqs_on+0xb/0x10
[ 1762.613184]  [<c15dc781>] ret_from_kernel_thread+0x21/0x30
[ 1762.613229]  [<c105fab0>] ? insert_kthread_work+0x80/0x80
[ 1762.613256] ---[ end trace cf8e7727f1e1a1b6 ]---
[ 1762.613295] BUG: unable to handle kernel NULL pointer dereference at 0000000c
[ 1762.613486] IP: [<c126eac8>] xfs_ail_check+0x58/0xc0
[ 1762.613615] *pde = 00000000 
[ 1762.613728] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[ 1762.613926] Dumping ftrace buffer:
[ 1762.614009] ---------------------------------
[ 1762.614028]    mount-319     0...2 1715290597us : xfs_ail_insert: dev 22:4 lip 0xd582c000 old lsn 0/0 new lsn 1/51 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715290617us : xfs_ail_delete: dev 22:4 lip 0xd582c000 old lsn 1/51 new lsn 1/51 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715290853us : xfs_ail_insert: dev 22:4 lip 0xd582c000 old lsn 0/0 new lsn 1/51 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715290860us : xfs_ail_delete: dev 22:4 lip 0xd582c000 old lsn 1/51 new lsn 1/51 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715290872us : xfs_ail_insert: dev 22:4 lip 0xd582c000 old lsn 0/0 new lsn 1/51 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715290877us : xfs_ail_delete: dev 22:4 lip 0xd582c000 old lsn 1/51 new lsn 1/51 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715290890us : xfs_ail_insert: dev 22:4 lip 0xd582c000 old lsn 0/0 new lsn 1/51 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715290896us : xfs_ail_delete: dev 22:4 lip 0xd582c000 old lsn 1/51 new lsn 1/51 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715293594us : xfs_ail_insert: dev 22:4 lip 0xd582c000 old lsn 0/0 new lsn 1/51 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715293602us : xfs_ail_delete: dev 22:4 lip 0xd582c000 old lsn 1/51 new lsn 1/51 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715293617us : xfs_ail_insert: dev 22:4 lip 0xd582c000 old lsn 0/0 new lsn 1/51 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715293623us : xfs_ail_delete: dev 22:4 lip 0xd582c000 old lsn 1/51 new lsn 1/51 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715340811us : xfs_ail_insert: dev 22:4 lip 0xd582c000 old lsn 0/0 new lsn 1/97 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715340826us : xfs_ail_delete: dev 22:4 lip 0xd582c000 old lsn 1/97 new lsn 1/97 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715340870us : xfs_ail_insert: dev 22:4 lip 0xd582c000 old lsn 0/0 new lsn 1/97 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715340876us : xfs_ail_delete: dev 22:4 lip 0xd582c000 old lsn 1/97 new lsn 1/97 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715340889us : xfs_ail_insert: dev 22:4 lip 0xd582c000 old lsn 0/0 new lsn 1/97 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715340894us : xfs_ail_delete: dev 22:4 lip 0xd582c000 old lsn 1/97 new lsn 1/97 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715340923us : xfs_ail_insert: dev 22:4 lip 0xd582c000 old lsn 0/0 new lsn 1/97 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715340929us : xfs_ail_delete: dev 22:4 lip 0xd582c000 old lsn 1/97 new lsn 1/97 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715340941us : xfs_ail_insert: dev 22:4 lip 0xd582c000 old lsn 0/0 new lsn 1/97 type XFS_LI_EFI flags IN_AIL
[ 1762.614028]    mount-319     0...2 1715340947us : xfs_ail_delete: dev 22:4 lip 0xd582c000 old lsn 1/97 new lsn 1/97 type XFS_LI_EFI flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1725605607us : xfs_ail_insert: dev 22:4 lip 0xddf46160 old lsn 0/0 new lsn 1/108 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] xfsaild/-323     0...2 1725606791us : xfs_ail_push: dev 22:4 lip 0xddf46160 lsn 1/108 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1725607137us : xfs_ail_delete: dev 22:4 lip 0xddf46160 old lsn 1/108 new lsn 1/108 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030171us : xfs_ail_insert: dev 22:4 lip 0xddf46000 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030182us : xfs_ail_insert: dev 22:4 lip 0xddf46210 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030184us : xfs_ail_insert: dev 22:4 lip 0xddf462c0 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030185us : xfs_ail_insert: dev 22:4 lip 0xddf46370 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030187us : xfs_ail_insert: dev 22:4 lip 0xddf46420 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030188us : xfs_ail_insert: dev 22:4 lip 0xddf464d0 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030189us : xfs_ail_insert: dev 22:4 lip 0xddc5b068 old lsn 0/0 new lsn 1/2 type XFS_LI_INODE flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030190us : xfs_ail_insert: dev 22:4 lip 0xddf46840 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030191us : xfs_ail_insert: dev 22:4 lip 0xddf468f0 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030193us : xfs_ail_insert: dev 22:4 lip 0xddf46580 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030194us : xfs_ail_insert: dev 22:4 lip 0xddf469a0 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030195us : xfs_ail_insert: dev 22:4 lip 0xddf46630 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030196us : xfs_ail_insert: dev 22:4 lip 0xddf466e0 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030198us : xfs_ail_insert: dev 22:4 lip 0xddf46790 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030199us : xfs_ail_insert: dev 22:4 lip 0xddf46a50 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030200us : xfs_ail_insert: dev 22:4 lip 0xddc5b138 old lsn 0/0 new lsn 1/2 type XFS_LI_INODE flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030201us : xfs_ail_insert: dev 22:4 lip 0xddf46dc0 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030202us : xfs_ail_insert: dev 22:4 lip 0xddf46e70 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030204us : xfs_ail_insert: dev 22:4 lip 0xddf46b00 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030205us : xfs_ail_insert: dev 22:4 lip 0xddf46f20 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030206us : xfs_ail_insert: dev 22:4 lip 0xddc5b0d0 old lsn 0/0 new lsn 1/2 type XFS_LI_INODE flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030207us : xfs_ail_insert: dev 22:4 lip 0xddf46bb0 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030209us : xfs_ail_insert: dev 22:4 lip 0xddf46c60 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030210us : xfs_ail_insert: dev 22:4 lip 0xddf46d10 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030211us : xfs_ail_insert: dev 22:4 lip 0xd7d3c000 old lsn 0/0 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1755030213us : xfs_ail_insert: dev 22:4 lip 0xddc5b1a0 old lsn 0/0 new lsn 1/2 type XFS_LI_INODE flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767248us : xfs_ail_delete: dev 22:4 lip 0xddf46840 old lsn 1/2 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767266us : xfs_ail_delete: dev 22:4 lip 0xddc5b138 old lsn 1/2 new lsn 1/2 type XFS_LI_INODE flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767386us : xfs_ail_delete: dev 22:4 lip 0xddf468f0 old lsn 1/2 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767444us : xfs_ail_delete: dev 22:4 lip 0xddf46dc0 old lsn 1/2 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767450us : xfs_ail_delete: dev 22:4 lip 0xddc5b1a0 old lsn 1/2 new lsn 1/2 type XFS_LI_INODE flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767490us : xfs_ail_delete: dev 22:4 lip 0xddf46e70 old lsn 1/2 new lsn 1/2 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767524us : xfs_ail_insert: dev 22:4 lip 0xd7d3c210 old lsn 0/0 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767525us : xfs_ail_insert: dev 22:4 lip 0xd7d3c2c0 old lsn 0/0 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767529us : xfs_ail_move: dev 22:4 lip 0xddf46a50 old lsn 1/2 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767531us : xfs_ail_insert: dev 22:4 lip 0xd582c000 old lsn 0/0 new lsn 1/36 type XFS_LI_EFI flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767532us : xfs_ail_move: dev 22:4 lip 0xddf46580 old lsn 1/2 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767534us : xfs_ail_move: dev 22:4 lip 0xddf469a0 old lsn 1/2 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767535us : xfs_ail_insert: dev 22:4 lip 0xd582c240 old lsn 0/0 new lsn 1/36 type XFS_LI_EFI flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767536us : xfs_ail_move: dev 22:4 lip 0xddf46630 old lsn 1/2 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767538us : xfs_ail_move: dev 22:4 lip 0xddf46790 old lsn 1/2 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767539us : xfs_ail_move: dev 22:4 lip 0xddf466e0 old lsn 1/2 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767541us : xfs_ail_insert: dev 22:4 lip 0xddf46160 old lsn 0/0 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767542us : xfs_ail_insert: dev 22:4 lip 0xd7d3c160 old lsn 0/0 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767543us : xfs_ail_move: dev 22:4 lip 0xddf464d0 old lsn 1/2 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767611us : xfs_ail_insert: dev 22:4 lip 0xd582c480 old lsn 0/0 new lsn 1/36 type XFS_LI_EFI flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767613us : xfs_ail_move: dev 22:4 lip 0xddf462c0 old lsn 1/2 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767614us : xfs_ail_move: dev 22:4 lip 0xddf46420 old lsn 1/2 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767616us : xfs_ail_move: dev 22:4 lip 0xddf46370 old lsn 1/2 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767617us : xfs_ail_move: dev 22:4 lip 0xddc5b068 old lsn 1/2 new lsn 1/36 type XFS_LI_INODE flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762767618us : xfs_ail_move: dev 22:4 lip 0xddf46000 old lsn 1/2 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] kworker/-41      0...2 1762769825us : xfs_ail_move: dev 22:4 lip 0xddf46210 old lsn 1/2 new lsn 1/36 type XFS_LI_BUF flags IN_AIL
[ 1762.614028] ---------------------------------
[ 1762.614028] CPU: 0 PID: 41 Comm: kworker/0:1H Tainted: G        W     3.16.0-rc1+ #3
[ 1762.614028] Hardware name: Dell Computer Corporation       L733r                          /CA810E                         , BIOS A14 09/05/2001
[ 1762.614028] Workqueue: xfslogd xfs_buf_iodone_work
[ 1762.614028] task: de8faac0 ti: de92e000 task.ti: de92e000
[ 1762.614028] EIP: 0060:[<c126eac8>] EFLAGS: 00010282 CPU: 0
[ 1762.614028] EIP is at xfs_ail_check+0x58/0xc0
[ 1762.614028] EAX: 00000000 EBX: ddf46210 ECX: 00000002 EDX: 00000002
[ 1762.614028] ESI: 00000001 EDI: 00000001 EBP: de92fc9c ESP: de92fc90
[ 1762.614028]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 1762.614028] CR0: 8005003b CR2: 0000000c CR3: 1df09000 CR4: 000007d0
[ 1762.614028] Stack:
[ 1762.614028]  ddc9af00 ddf46210 00000001 de92fcac c126eb43 ddf46210 ddf91310 de92fd04
[ 1762.614028]  c126f945 00000002 00000001 00000024 00000001 ddc9af08 de92fd38 d7d3c000
[ 1762.614028]  ddc9af00 00000000 00000002 de92fd44 ddf46210 00000001 00000024 00000013
[ 1762.614028] Call Trace:
[ 1762.614028]  [<c126eb43>] xfs_ail_delete+0x13/0x60
[ 1762.614028]  [<c126f945>] xfs_trans_ail_update_bulk+0x1a5/0x410
[ 1762.614028]  [<c12070ab>] xfs_trans_committed_bulk+0x2eb/0x320
[ 1762.614028]  [<c126957a>] xlog_cil_committed+0x3a/0x150
[ 1762.614028]  [<c12655ba>] xlog_state_do_callback+0x18a/0x390
[ 1762.614028]  [<c1265883>] xlog_state_done_syncing+0xc3/0xe0
[ 1762.614028]  [<c126590e>] xlog_iodone+0x6e/0x100
[ 1762.614028]  [<c11e821b>] xfs_buf_iodone_work+0x5b/0xe0
[ 1762.614028]  [<c1058557>] process_one_work+0x1b7/0x5d0
[ 1762.614028]  [<c10584da>] ? process_one_work+0x13a/0x5d0
[ 1762.614028]  [<c1058a1b>] ? worker_thread+0xab/0x4b0
[ 1762.614028]  [<c10589a9>] worker_thread+0x39/0x4b0
[ 1762.614028]  [<c108909b>] ? trace_hardirqs_on+0xb/0x10
[ 1762.614028]  [<c1058970>] ? process_one_work+0x5d0/0x5d0
[ 1762.614028]  [<c105fb58>] kthread+0xa8/0xc0
[ 1762.614028]  [<c108909b>] ? trace_hardirqs_on+0xb/0x10
[ 1762.614028]  [<c15dc781>] ret_from_kernel_thread+0x21/0x30
[ 1762.614028]  [<c105fab0>] ? insert_kthread_work+0x80/0x80
[ 1762.614028] Code: c1 b8 50 be 72 c1 e8 38 f7 f8 ff 8b 43 04 39 c6 74 10 8b 7b 0c 39 78 0c 8b 53 08 8b 48 08 74 43 73 45 8b 03 39 c6 74 24 8b 73 0c <39> 70 0c 8b 53 08 8b 48 08 74 4d 73 14 b9 38 00 00 00 ba 83 a3
[ 1762.614028] EIP: [<c126eac8>] xfs_ail_check+0x58/0xc0 SS:ESP 0068:de92fc90
[ 1762.614028] CR2: 000000000000000c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
