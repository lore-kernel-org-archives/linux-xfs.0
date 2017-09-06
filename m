Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57929 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752257AbdIFJrF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 05:47:05 -0400
Date: Wed, 6 Sep 2017 11:47:00 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/9] ext4: safely transition S_DAX on journaling changes
Message-ID: <20170906094700.GC27916@quack2.suse.cz>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <20170905223541.20594-7-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170905223541.20594-7-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org

On Tue 05-09-17 16:35:38, Ross Zwisler wrote:
> The IOCTL path which switches the journaling mode for an inode is currently
> unsafe because it doesn't properly do a writeback and invalidation on the
> inode.  In XFS, for example, safe transitions of S_DAX are handled by
> xfs_ioctl_setattr_dax_invalidate() which locks out page faults and I/O,
> does a writeback via filemap_write_and_wait() and an invalidation via
> invalidate_inode_pages2().
> 
> Without this in place we can see the following kernel warning when we try
> and insert a DAX exceptional entry but find that a dirty page cache page is
> still in the mapping->radix_tree:
> 
>  WARNING: CPU: 4 PID: 1052 at mm/filemap.c:262 __delete_from_page_cache+0x375/0x550
>  Modules linked in: dax_pmem nd_pmem device_dax nd_btt nfit libnvdimm
>  CPU: 4 PID: 1052 Comm: small Not tainted 4.13.0-rc6-00055-gac26931 #3
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc25 04/01/2014
>  task: ffff88020ccd0000 task.stack: ffffc900021d4000
>  RIP: 0010:__delete_from_page_cache+0x375/0x550
>  RSP: 0000:ffffc900021d7b90 EFLAGS: 00010002
>  RAX: 002fffc00001123d RBX: ffffffffffffffff RCX: ffff8801d9440d68
>  RDX: 0000000000000000 RSI: ffffffff81fd5b84 RDI: ffffffff81f6f0e5
>  RBP: ffffc900021d7be0 R08: 0000000000000000 R09: ffff8801f9938c70
>  R10: 0000000000000021 R11: ffff8801f9938c91 R12: ffff8801d9440d70
>  R13: ffffea0007fdda80 R14: 0000000000000001 R15: ffff8801d9440d68
>  FS:  00007feacc041700(0000) GS:ffff880211800000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000010420000 CR3: 000000020cfd8000 CR4: 00000000000006e0
>  Call Trace:
>   dax_insert_mapping_entry+0x158/0x2c0
>   dax_iomap_fault+0x1020/0x1bb0
>   ext4_dax_huge_fault+0xc8/0x160
>   ext4_dax_fault+0x10/0x20
>   __do_fault+0x20/0x110
>   __handle_mm_fault+0x97d/0x1120
>   handle_mm_fault+0x188/0x2f0
>   __do_page_fault+0x28f/0x590
>   trace_do_page_fault+0x58/0x2c0
>   do_async_page_fault+0x2c/0x90
>   async_page_fault+0x28/0x30
> 
> I'm pretty sure we could make a test that shows userspace visible data
> corruption as well in this scenario.
> 
> Make it safe to change the journaling mode and turn on or off S_DAX by
> adding locking to properly lock out page faults (i_mmap_sem) and then doing
> the writeback and invalidate.  I/O is already held off because all callers
> of ext4_ioctl_setflags() hold the inode lock.

Yeah, this is a good point. It is just that this is not enough as I
discovered in [1]. You also need to tear down & recreate VMAs when changing
DAX flag which is a bit tricky. So for now I think returning EBUSY when
file is mmaped and we'd like to flip DAX flag is the best solution. Hmm?

[1] https://www.spinics.net/lists/linux-xfs/msg09859.html

> The locking for this new code is complex because of the following:
> 
> 1) filemap_write_and_wait() eventually calls ext4_writepages(), which
> acquires the sbi->s_journal_flag_rwsem.  This lock ranks above the
> jbdw_handle which is eventually taken by ext4_journal_start().  This
> essentially means that the writeback has to happen outside of the context
> of an active journal handle (outside of ext4_journal_start() to
> ext4_journal_stop().)
> 
> 2) To lock out page faults we take a write lock on the ei->i_mmap_sem, and
> this lock again ranks above the jbd2_handle taken by ext4_journal_start().
> So, as with the writeback code in 1) above we have to take ei->i_mmap_sem
> outside of the context of an active journal handle.

Welcome to the joy of fs locking ;)

> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> CC: stable@vger.kernel.org

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
