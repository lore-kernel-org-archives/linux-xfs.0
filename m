Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59009 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752306AbcJJPuX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Oct 2016 11:50:23 -0400
Date: Mon, 10 Oct 2016 17:50:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 13/17] dax: dax_iomap_fault() needs to call
        iomap_end()
Message-ID: <20161010155004.GD19343@lst.de>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com> <1475874544-24842-14-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475874544-24842-14-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Fri, Oct 07, 2016 at 03:09:00PM -0600, Ross Zwisler wrote:
> Currently iomap_end() doesn't do anything for DAX page faults for both ext2
> and XFS.  ext2_iomap_end() just checks for a write underrun, and
> xfs_file_iomap_end() checks to see if it needs to finish a delayed
> allocation.  However, in the future iomap_end() calls might be needed to
> make sure we have balanced allocations, locks, etc.  So, add calls to
> iomap_end() with appropriate error handling to dax_iomap_fault().

Is there a way to just have a single call to iomap_end at the end of
the function, after which we just return a previosuly setup return
value?

e.g.

out:
	if (ops->iomap_end) {
		error = ops->iomap_end(inode, pos, PAGE_SIZE,
				PAGE_SIZE, flags, &iomap);
	}

	if (error == -ENOMEM)
		return VM_FAULT_OOM | major;
	if (error < 0 && error != -EBUSY)
		return VM_FAULT_SIGBUS | major;
	return ret;
