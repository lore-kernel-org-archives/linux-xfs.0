Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752457AbeADJjJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 04:39:09 -0500
Date: Thu, 4 Jan 2018 10:39:06 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 15/18] mm, fs, dax: use page->mapping to warn if dma
 collides with truncate
Message-ID: <20180104093906.GC29010@quack2.suse.cz>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407704063.38751.15403501871756055025.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151407704063.38751.15403501871756055025.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de

On Sat 23-12-17 16:57:20, Dan Williams wrote:
> Catch cases where truncate encounters pages that are still under active
> dma. This warning is a canary for potential data corruption as truncated
> blocks could be allocated to a new file while the device is still
> perform i/o.
> 
> Here is an example of a collision that this implementation catches:
> 
>  WARNING: CPU: 2 PID: 1286 at fs/dax.c:343 dax_disassociate_entry+0x55/0x80
>  [..]
>  Call Trace:
>   __dax_invalidate_mapping_entry+0x6c/0xf0
>   dax_delete_mapping_entry+0xf/0x20
>   truncate_exceptional_pvec_entries.part.12+0x1af/0x200
>   truncate_inode_pages_range+0x268/0x970
>   ? tlb_gather_mmu+0x10/0x20
>   ? up_write+0x1c/0x40
>   ? unmap_mapping_range+0x73/0x140
>   xfs_free_file_space+0x1b6/0x5b0 [xfs]
>   ? xfs_file_fallocate+0x7f/0x320 [xfs]
>   ? down_write_nested+0x40/0x70
>   ? xfs_ilock+0x21d/0x2f0 [xfs]
>   xfs_file_fallocate+0x162/0x320 [xfs]
>   ? rcu_read_lock_sched_held+0x3f/0x70
>   ? rcu_sync_lockdep_assert+0x2a/0x50
>   ? __sb_start_write+0xd0/0x1b0
>   ? vfs_fallocate+0x20c/0x270
>   vfs_fallocate+0x154/0x270
>   SyS_fallocate+0x43/0x80
>   entry_SYSCALL_64_fastpath+0x1f/0x96
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
