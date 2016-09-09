Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:62467 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754738AbcIIW4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Sep 2016 18:56:18 -0400
Date: Sat, 10 Sep 2016 08:55:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Message-ID: <20160909225557.GF30056@dastard>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473438884-674-7-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

On Fri, Sep 09, 2016 at 06:34:40PM +0200, Christoph Hellwig wrote:
> Very similar to the existing dax_fault function, but instead of using
> the get_block callback we rely on the iomap_ops vector from iomap.c.
> That also avoids having to do two calls into the file system for write
> faults.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Just noticed this on a quick initial browse...

> +	if (vmf->cow_page) {
> +		switch (iomap.type) {
> +		case IOMAP_HOLE:
> +		case IOMAP_UNWRITTEN:
> +			clear_user_highpage(vmf->cow_page, vaddr);
> +			break;
> +		case IOMAP_MAPPED:
> +			error = copy_user_dax(iomap.bdev, sector, PAGE_SIZE,
> +					vmf->cow_page, vaddr);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			error = -EIO;
> +			break;
> +		}
> +
> +		if (error)
> +			goto unlock_entry;
> +		if (!radix_tree_exceptional_entry(entry)) {
> +			vmf->page = entry;
> +			return VM_FAULT_LOCKED;
> +		}
> +		vmf->entry = entry;
> +		return VM_FAULT_DAX_LOCKED;
> +	}
> +
> +	switch (iomap.type) {
> +	case IOMAP_MAPPED:
> +		if (iomap.flags & IOMAP_F_NEW) {
> +			count_vm_event(PGMAJFAULT);
> +			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
> +			major = VM_FAULT_MAJOR;
> +		}
> +		break;
> +	case IOMAP_UNWRITTEN:
> +	case IOMAP_HOLE:
> +		if (!(vmf->flags & FAULT_FLAG_WRITE))
> +			return dax_load_hole(mapping, entry, vmf);
> +	default:
> +		WARN_ON_ONCE(1);
> +		error = -EIO;
> +	}

THe errors from the above two cases are not acted on. they are
immediately overwritten by:

> +
> +	/* Filesystem should not return unwritten buffers to us! */
> +	error = dax_insert_mapping(mapping, iomap.bdev, sector, PAGE_SIZE,
> +			&entry, vma, vmf);
> +unlock_entry:
> +	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
> +out:
> +	if (error == -ENOMEM)
> +		return VM_FAULT_OOM | major;
> +	/* -EBUSY is fine, somebody else faulted on the same PTE */
> +	if (error < 0 && error != -EBUSY)
> +		return VM_FAULT_SIGBUS | major;
> +	return VM_FAULT_NOPAGE | major;
> +}

Is there a missing "if (error) goto out;" check somewhere here?

I'm also wondering if you've looked at supporting the PMD fault case
with iomap?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
