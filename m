Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39529 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdJLNva (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Oct 2017 09:51:30 -0400
Date: Thu, 12 Oct 2017 15:51:27 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v9 1/6] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Message-ID: <20171012135127.GG29293@quack2.suse.cz>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150776923320.9144.6119113178052262946.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150776923320.9144.6119113178052262946.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>

Hi,

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 680506faceae..2649c00581a0 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1389,6 +1389,18 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  		struct inode *inode = file_inode(file);
>  
>  		switch (flags & MAP_TYPE) {
> +		case MAP_SHARED_VALIDATE:
> +			if ((flags & ~LEGACY_MAP_MASK) == 0) {
> +				/*
> +				 * If all legacy mmap flags, downgrade
> +				 * to MAP_SHARED, i.e. invoke ->mmap()
> +				 * instead of ->mmap_validate()
> +				 */
> +				flags &= ~MAP_TYPE;
> +				flags |= MAP_SHARED;
> +			} else if (!file->f_op->mmap_validate)
> +				return -EOPNOTSUPP;
> +			/* fall through */
>  		case MAP_SHARED:
>  			if ((prot&PROT_WRITE) && !(file->f_mode&FMODE_WRITE))
>  				return -EACCES;

When thinking a bit more about this I've realized one problem: Currently
user can call mmap() with MAP_SHARED type and MAP_SYNC or MAP_DIRECT flags
and he will get the new semantics (if the kernel happens to support it).  I
think that is undesirable and we should force usage of MAP_SHARED_VALIDATE
when you want to use flags outside of LEGACY_MAP_MASK. So I'd just mask off
non-legacy flags for MAP_SHARED mappings (so they would be silently ignored
as they used to be until now).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
