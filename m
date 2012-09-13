Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8DKBOZT211901 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 15:11:24 -0500
Message-ID: <50523E20.5000508@sgi.com>
Date: Thu, 13 Sep 2012 15:12:16 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 020/102] xfs: warn if direct reclaim tries to writeback
	pages
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
	<1345698180-13612-21-git-send-email-david@fromorbit.com>
	<20120827181742.GA13970@infradead.org>
	<20120905113242.GL11266@suse.de>
In-Reply-To: <20120905113242.GL11266@suse.de>
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
To: Mel Gorman <mgorman@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 09/05/12 06:32, Mel Gorman wrote:
> On Mon, Aug 27, 2012 at 02:17:42PM -0400, Christoph Hellwig wrote:
>> On Thu, Aug 23, 2012 at 03:01:38PM +1000, Dave Chinner wrote:
>>> From: Mel Gorman<mgorman@suse.de>
>>>
>>> Upstream commit: 94054fa3fca1fd78db02cb3d68d5627120f0a1d4
>>>
>>> Direct reclaim should never writeback pages.  For now, handle the
>>> situation and warn about it.  Ultimately, this will be a BUG_ON.
>>
>> Is this actually the case on 3.0-stable?
>>
>
> No, it is not. AFAIK, 3.0-stable does not contain [ee72886d: mm: vmscan:
> do not writeback filesystem pages in direct reclaim] which is the absolute
> minimum required for commit [94054fa3: xfs: warn if direct reclaim tries
> to writeback pages] to make sense.
>

I hit this warning testing on a linux-30.42 with a x86_64.

WARNING: at fs/xfs/linux-2.6/xfs_aops.c:961 xfs_vm_writepage+0x63c/0x6a0()
Hardware name: S2721-533 Thunder i7501 Pro
Modules linked in: ext4 jbd2 crc16
Pid: 12122, comm: cp Not tainted 3.0.42 #2
Call Trace:
  [<c1688bca>] ? printk+0x18/0x1a
  [<c103a3ad>] warn_slowpath_common+0x6d/0xa0
  [<c122afdc>] ? xfs_vm_writepage+0x63c/0x6a0
  [<c122afdc>] ? xfs_vm_writepage+0x63c/0x6a0
  [<c103a3fd>] warn_slowpath_null+0x1d/0x20
  [<c122afdc>] xfs_vm_writepage+0x63c/0x6a0
  [<c10901fd>] ? call_rcu_sched+0xd/0x10
  [<c128ac8c>] ? radix_tree_delete+0x1cc/0x280
  [<c110eb43>] ? free_buffer_head+0x23/0x30
  [<c110ebaa>] ? try_to_free_buffers+0x5a/0x90
  [<c10c2a82>] shrink_page_list+0x542/0x750
  [<c10ca984>] ? __mod_zone_page_state+0x54/0x60
  [<c10c3000>] shrink_inactive_list+0x190/0x360
  [<c10c35e0>] shrink_zone+0x410/0x580
  [<c10c40b0>] do_try_to_free_pages+0x100/0x360
  [<c10c4439>] try_to_free_pages+0x89/0x120
  [<c10baadb>] __alloc_pages_nodemask+0x3eb/0x650
  [<c10e423c>] new_slab+0x4c/0x1a0
  [<c168ad23>] __slab_alloc.constprop.65+0xed/0x1d5
  [<c10f21f6>] ? getname_flags+0x26/0x150
  [<c10e4f6b>] kmem_cache_alloc+0x11b/0x130
  [<c10675bf>] ? tick_dev_program_event+0x3f/0x160
  [<c10f21f6>] ? getname_flags+0x26/0x150
  [<c10f21f6>] getname_flags+0x26/0x150
  [<c10676fc>] ? tick_program_event+0x1c/0x30
  [<c10f60bf>] user_path_at_empty+0x1f/0x80
  [<c1090c98>] ? rcu_irq_exit+0x8/0x10
  [<c1040a07>] ? irq_exit+0x37/0x90
  [<c101a834>] ? smp_apic_timer_interrupt+0x54/0x90
  [<c10f613a>] user_path_at+0x1a/0x20
  [<c10ed12e>] vfs_fstatat+0x4e/0x80
  [<c10ed17b>] vfs_lstat+0x1b/0x20
  [<c10ed431>] sys_lstat64+0x11/0x30
  [<c10e74ff>] ? filp_close+0x4f/0x70
  [<c10e7577>] ? sys_close+0x57/0xa0
  [<c1690f25>] syscall_call+0x7/0xb

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
