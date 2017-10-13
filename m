Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:58381 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbdJMToq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 15:44:46 -0400
Date: Fri, 13 Oct 2017 13:44:44 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 12/19] mm: Define MAP_SYNC and VM_SYNC flags
Message-ID: <20171013194444.GB29081@linux.intel.com>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-13-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011200603.27442-13-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Oct 11, 2017 at 10:05:56PM +0200, Jan Kara wrote:
> Define new MAP_SYNC flag and corresponding VMA VM_SYNC flag. As the
> MAP_SYNC flag is not part of LEGACY_MAP_MASK, currently it will be
> refused by all MAP_SHARED_VALIDATE map attempts and silently ignored for
> everything else.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  arch/xtensa/include/uapi/asm/mman.h | 1 +
>  fs/proc/task_mmu.c                  | 1 +
>  include/linux/mm.h                  | 1 +
>  include/linux/mman.h                | 3 ++-
>  include/uapi/asm-generic/mman.h     | 1 +
>  5 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/xtensa/include/uapi/asm/mman.h b/arch/xtensa/include/uapi/asm/mman.h
> index ec597900eec7..b62a7ce166fb 100644
> --- a/arch/xtensa/include/uapi/asm/mman.h
> +++ b/arch/xtensa/include/uapi/asm/mman.h
> @@ -56,6 +56,7 @@
>  #define MAP_NONBLOCK	0x20000		/* do not block on IO */
>  #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
>  #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
> +#define MAP_SYNC	0x100000	/* perform synchronous page faults for the mapping */

Why define MAP_SYNC for this one architecture, but not for the rest that have
their own arch/*/include/uapi/asm/mman.h?  AFAIK xtensa doesn't support DAX,
so has no need for MAP_SYNC?

Other than this one question, this patch looks fine:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
