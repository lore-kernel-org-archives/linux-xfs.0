Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39274 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdHXMb1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 08:31:27 -0400
Date: Thu, 24 Aug 2017 05:31:26 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/13] ext4: Support for synchronous DAX faults
Message-ID: <20170824123126.GA21282@infradead.org>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-14-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-14-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Thu, Aug 17, 2017 at 06:08:15PM +0200, Jan Kara wrote:
> We return IOMAP_F_NEEDDSYNC flag from ext4_iomap_begin() for a
> synchronous write fault when inode has some uncommitted metadata
> changes. In the fault handler ext4_dax_fault() we then detect this case,
> call vfs_fsync_range() to make sure all metadata is committed, and call
> dax_pfn_mkwrite() to mark PTE as writeable. Note that this will also
> dirty corresponding radix tree entry which is what we want - fsync(2)
> will still provide data integrity guarantees for applications not using
> userspace flushing. And applications using userspace flushing can avoid
> calling fsync(2) and thus avoid the performance overhead.

Why is this only wiered up for the huge_fault handler and not the
regular?
