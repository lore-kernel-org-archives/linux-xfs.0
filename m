Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49864 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932458AbdHWSnt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 14:43:49 -0400
Date: Wed, 23 Aug 2017 11:43:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/13] mm: Wire up MAP_SYNC
Message-ID: <20170823184349.GA12660@infradead.org>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-11-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-11-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Thu, Aug 17, 2017 at 06:08:12PM +0200, Jan Kara wrote:
> Pretty crude for now...
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c                  | 2 ++
>  include/linux/mm.h              | 1 +
>  include/linux/mman.h            | 3 ++-
>  include/uapi/asm-generic/mman.h | 1 +
>  mm/mmap.c                       | 5 +++++
>  5 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index f84bb29e941e..850037e140d7 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -340,6 +340,8 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
>  		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
>  	} else {
>  		vma->vm_ops = &ext4_file_vm_ops;
> +		if (vma->vm_flags & VM_SYNC)
> +			return -EOPNOTSUPP;
>  	}

So each mmap instance would need to reject the flag explicitly?

Or do I misunderstand this VM_SYNC flag?
