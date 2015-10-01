Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ACFF97F55
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 15:27:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49247AC00A
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 13:27:36 -0700 (PDT)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	CroeL30IvRD1phWN for <xfs@oss.sgi.com>;
	Thu, 01 Oct 2015 13:27:32 -0700 (PDT)
Date: Thu, 1 Oct 2015 14:27:29 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] Revert "mm: take i_mmap_lock in
	unmap_mapping_range() for DAX"
Message-ID: <20151001202729.GA23495@linux.intel.com>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
	<1443685599-4843-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1443685599-4843-2-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, willy@linux.intel.com, ross.zwisler@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com

On Thu, Oct 01, 2015 at 05:46:33PM +1000, Dave Chinner wrote:
> This reverts commit 46c043ede4711e8d598b9d63c5616c1fedb0605e.
> ---
>  fs/dax.c    | 36 ++++++++++++++++--------------------
>  mm/memory.c | 11 +++++++++--
>  2 files changed, 25 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 7ae6df7..400fe95 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -569,26 +569,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
>  		goto fallback;
>  
> -	if (buffer_unwritten(&bh) || buffer_new(&bh)) {
> -		int i;
> -		for (i = 0; i < PTRS_PER_PMD; i++)
> -			clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
> -		wmb_pmem();

The above two lines were updated to use the PMEM API with this commit:

commit d77e92e270ed ("dax: update PMD fault handler with PMEM API")

but they aren't updated in the reverted version here: 

> @@ -633,6 +620,15 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
>  			goto fallback;
>  
> +		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
> +			int i;
> +			for (i = 0; i < PTRS_PER_PMD; i++)
> +				clear_page(kaddr + i * PAGE_SIZE);
> +			count_vm_event(PGMAJFAULT);
> +			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
> +			result |= VM_FAULT_MAJOR;
> +		}
> +
>  		result |= vmf_insert_pfn_pmd(vma, address, pmd, pfn, write);
>  	}

This is the source of the follow-up sparse warning from the kbuild robot.


Also, if I understood your previous mails correctly you were targeting the
first two revert patches for v4.3 so we get back to v4.2 level locking, and
the rest of the series will target v4.4, correct?  How does this work?  Do the
patches need to be split into two series and tested separately?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
