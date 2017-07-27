Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751503AbdG0NMt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 09:12:49 -0400
From: Jan Kara <jack@suse.cz>
Subject: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Date: Thu, 27 Jul 2017 15:12:38 +0200
Message-Id: <20170727131245.28279-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>

Hello,

after last discussions about whether / how to make flushing of DAX mappings
possible from userspace so that they can be flushed on finer than page
granularity and also avoid the overhead of a syscall, I've decided to give
a stab at implementing "synchronous page faults" idea for ext4 so that
we can see whether that is reasonably possible to implement and how would
such implementation look like. This patch set is the result.

So the functionality this patches implement: We have an inode flag (currently
I abuse S_SYNC inode flag for this and IMHO it kind of makes sense but if
people hate that I'm certainly open to using new flag in the final
implementation) that marks inode as requiring synchronous page faults.
The guarantee provided by this flag on inode is: While a block is writeably
mapped into page tables, it is guaranteed to be visible in the file at that
offset also after a crash.

How I implement this is that ->iomap_begin() indicates by a flag that inode
block mapping metadata is unstable and may need flushing (use the same test as
whether fdatasync() has metadata to write). If yes, DAX maps page table entries
read-only and returns special flag VM_FAULT_RO to the filesystem fault handler.
The handler then calls fdatasync() (vfs_fsync_range()) for the affected range
and after that calls DAX code to write-enable the page table entries.

>From my (fairly limited) knowledge of XFS it seems XFS should be able to do the
same and it should be even possible for filesystem to implement safe remapping
of a file offset to a different block (i.e. break reflink, do defrag, or
similar stuff) like:

1) Block page faults
2) fdatasync() remapped range (there can be outstanding data modifications
   not yet flushed)
3) unmap_mapping_range()
4) Now remap blocks
5) Unblock page faults

Basically we do the same on events like punch hole so there is not much new
there.

There are couple of open questions with this implementation:

1) Is it worth the hassle?
2) Is S_SYNC good flag to use or should we use a new inode flag?
3) VM_FAULT_RO and especially passing of resulting 'pfn' from
   dax_iomap_fault() through filesystem fault handler to dax_pfn_mkwrite() in
   vmf->orig_pte is a bit of a hack. So far I'm not sure how to refactor
   things to make this cleaner.

Anyway, here are the patches, comments are welcome.

								Honza
