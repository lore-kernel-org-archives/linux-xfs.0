Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56207 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752139AbdJ0JNE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 05:13:04 -0400
Date: Fri, 27 Oct 2017 11:13:01 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 17/17] xfs: support for synchronous DAX faults
Message-ID: <20171027091301.GG31161@quack2.suse.cz>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-18-jack@suse.cz>
 <20171024222322.GX3666@dastard>
 <20171026154804.GF31161@quack2.suse.cz>
 <20171027064301.GC22931@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027064301.GC22931@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org

On Fri 27-10-17 08:43:01, Christoph Hellwig wrote:
> On Thu, Oct 26, 2017 at 05:48:04PM +0200, Jan Kara wrote:
> > But now that I look at XFS implementation again, it misses handling
> > of VM_FAULT_NEEDSYNC in xfs_filemap_pfn_mkwrite() (ext4 gets this right).
> > I'll fix this by using __xfs_filemap_fault() for xfs_filemap_pfn_mkwrite()
> > as well since it mostly duplicates it anyway... Thanks for inquiring!
> 
> My first patches move xfs_filemap_pfn_mkwrite to use __xfs_filemap_fault,
> but that didn't work.  Wish I'd remember why, though.

Maybe due to the additional check on IS_DAX(inode) in __xfs_filemap_fault()
which could do the wrong thing if per-inode DAX flag is switched? Because
otherwise __xfs_filemap_fault(vmf, PE_SIZE_PTE, true) does exactly the same
thing as xfs_filemap_pfn_mkwrite() did.

If we do care about per-inode DAX flag switching, I can just fixup
xfs_filemap_pfn_mkwrite() but my understanding was that we ditched the idea
at least until someone comes up with a reliable way to implement that...

							Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
