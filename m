Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:39544 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754035AbdHUVhF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Aug 2017 17:37:05 -0400
Date: Mon, 21 Aug 2017 15:37:04 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 10/13] mm: Wire up MAP_SYNC
Message-ID: <20170821213704.GG26220@linux.intel.com>
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
>  	return 0;
>  }
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index fa036093e76c..d0fb385414a4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -188,6 +188,7 @@ extern unsigned int kobjsize(const void *objp);
>  #define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
>  #define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
>  #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
> +#define VM_SYNC		0x00800000	/* Synchronous page faults */
>  #define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
>  #define VM_ARCH_2	0x02000000
>  #define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
> diff --git a/include/linux/mman.h b/include/linux/mman.h
> index c8367041fafd..c38279b651e5 100644
> --- a/include/linux/mman.h
> +++ b/include/linux/mman.h
> @@ -86,7 +86,8 @@ calc_vm_flag_bits(unsigned long flags)
>  {
>  	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
>  	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
> -	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
> +	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
> +	       _calc_vm_trans(flags, MAP_SYNC,	     VM_SYNC      );
>  }
>  
>  unsigned long vm_commit_limit(void);
> diff --git a/include/uapi/asm-generic/mman.h b/include/uapi/asm-generic/mman.h
> index 7162cd4cca73..00e55627d2df 100644
> --- a/include/uapi/asm-generic/mman.h
> +++ b/include/uapi/asm-generic/mman.h
> @@ -12,6 +12,7 @@
>  #define MAP_NONBLOCK	0x10000		/* do not block on IO */
>  #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
>  #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
> +#define MAP_SYNC	0x80000		/* perform synchronous page faults for the mapping */
>  
>  /* Bits [26:31] are reserved, see mman-common.h for MAP_HUGETLB usage */
>  
> diff --git a/mm/mmap.c b/mm/mmap.c
> index f19efcf75418..18453c04b09f 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1423,12 +1423,17 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  				return -ENODEV;
>  			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
>  				return -EINVAL;
> +			if (!(vm_flags & VM_SHARED) && (vm_flags & VM_SYNC))
> +				return -EINVAL;

I know this will be reworked with Dan's new mmap() interface, but I was
curious what the !(vm_flags & VM_SHARED) check here was for.  We're in a
MAP_PRIVATE case, so is it ever possible for VM_SHARED to be set in vm_flags?
I tried to make this happen with some various test scenarios, but wasn't able.

>  			break;
>  
>  		default:
>  			return -EINVAL;
>  		}
>  	} else {
> +		if (vm_flags & VM_SYNC)
> +			return -EINVAL;
> +
>  		switch (flags & MAP_TYPE) {
>  		case MAP_SHARED:
>  			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
> -- 
> 2.12.3
> 
