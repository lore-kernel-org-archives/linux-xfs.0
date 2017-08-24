Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40091 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751285AbdHXMgR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 08:36:17 -0400
Date: Thu, 24 Aug 2017 14:36:15 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 13/13] ext4: Support for synchronous DAX faults
Message-ID: <20170824123615.GB6187@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-14-jack@suse.cz>
 <20170824123126.GA21282@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824123126.GA21282@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Thu 24-08-17 05:31:26, Christoph Hellwig wrote:
> On Thu, Aug 17, 2017 at 06:08:15PM +0200, Jan Kara wrote:
> > We return IOMAP_F_NEEDDSYNC flag from ext4_iomap_begin() for a
> > synchronous write fault when inode has some uncommitted metadata
> > changes. In the fault handler ext4_dax_fault() we then detect this case,
> > call vfs_fsync_range() to make sure all metadata is committed, and call
> > dax_pfn_mkwrite() to mark PTE as writeable. Note that this will also
> > dirty corresponding radix tree entry which is what we want - fsync(2)
> > will still provide data integrity guarantees for applications not using
> > userspace flushing. And applications using userspace flushing can avoid
> > calling fsync(2) and thus avoid the performance overhead.
> 
> Why is this only wiered up for the huge_fault handler and not the
> regular?

We do handle both. Just ext4 naming is a bit confusing and ext4_dax_fault()
uses ext4_dax_huge_fault() for handling.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
