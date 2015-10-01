Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6735E7F55
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 17:14:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5FFBB304059
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 15:14:25 -0700 (PDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id lmai3302bAPUhGTi for
	<xfs@oss.sgi.com>; Thu, 01 Oct 2015 15:14:23 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/7] Revert "mm: take i_mmap_lock in
	unmap_mapping_range() for DAX"
Date: Thu, 1 Oct 2015 22:14:22 +0000
Message-ID: <1443737659.4886.3.camel@intel.com>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
	<1443685599-4843-2-git-send-email-david@fromorbit.com>
	<20151001202729.GA23495@linux.intel.com>
In-Reply-To: <20151001202729.GA23495@linux.intel.com>
Content-Language: en-US
Content-ID: <A5132391DC19E24381F398375B96AC8D@intel.com>
MIME-Version: 1.0
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
To: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>

On Thu, 2015-10-01 at 14:27 -0600, Ross Zwisler wrote:
> On Thu, Oct 01, 2015 at 05:46:33PM +1000, Dave Chinner wrote:
> > This reverts commit 46c043ede4711e8d598b9d63c5616c1fedb0605e.
> > ---
> >  fs/dax.c    | 36 ++++++++++++++++--------------------
> >  mm/memory.c | 11 +++++++++--
> >  2 files changed, 25 insertions(+), 22 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 7ae6df7..400fe95 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -569,26 +569,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> >  	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
> >  		goto fallback;
> >  
> > -	if (buffer_unwritten(&bh) || buffer_new(&bh)) {
> > -		int i;
> > -		for (i = 0; i < PTRS_PER_PMD; i++)
> > -			clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
> > -		wmb_pmem();
> 
> The above two lines were updated to use the PMEM API with this commit:
> 
> commit d77e92e270ed ("dax: update PMD fault handler with PMEM API")
> 
> but they aren't updated in the reverted version here: 
> 
> > @@ -633,6 +620,15 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> >  		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
> >  			goto fallback;
> >  
> > +		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
> > +			int i;
> > +			for (i = 0; i < PTRS_PER_PMD; i++)
> > +				clear_page(kaddr + i * PAGE_SIZE);
> > +			count_vm_event(PGMAJFAULT);
> > +			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
> > +			result |= VM_FAULT_MAJOR;
> > +		}
> > +
> >  		result |= vmf_insert_pfn_pmd(vma, address, pmd, pfn, write);
> >  	}
> 
> This is the source of the follow-up sparse warning from the kbuild robot.
> 

To that end Dave Hansen had also noticed that PTRS_PER_PMD should not be
used in this context.  Here's an incremental cleanup:

8<---
Subject: pmem, dax: clean up clear_pmem()

From: Dan Williams <dan.j.williams@intel.com>

Both, __dax_pmd_fault, and clear_pmem() were taking special steps to
clear memory a page at a time to take advantage of non-temporal
clear_page() implementations.  However, x86_64 does not use
non-temporal instructions for clear_page(), and arch_clear_pmem() was
always incurring the cost of __arch_wb_cache_pmem().

Clean up the assumption that doing clear_pmem() a page at a time is more
performant.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pmem.h |    7 +------
 fs/dax.c                    |    4 +---
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index d8ce3ec816ab..1544fabcd7f9 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -132,12 +132,7 @@ static inline void arch_clear_pmem(void __pmem *addr, size_t size)
 {
 	void *vaddr = (void __force *)addr;
 
-	/* TODO: implement the zeroing via non-temporal writes */
-	if (size == PAGE_SIZE && ((unsigned long)vaddr & ~PAGE_MASK) == 0)
-		clear_page(vaddr);
-	else
-		memset(vaddr, 0, size);
-
+	memset(vaddr, 0, size);
 	__arch_wb_cache_pmem(vaddr, size);
 }
 
diff --git a/fs/dax.c b/fs/dax.c
index b36d6d2e7f87..3faff9227135 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -625,9 +625,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 			goto fallback;
 
 		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
-			int i;
-			for (i = 0; i < PTRS_PER_PMD; i++)
-				clear_page(kaddr + i * PAGE_SIZE);
+			clear_pmem(kaddr, HPAGE_SIZE);
 			count_vm_event(PGMAJFAULT);
 			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 			result |= VM_FAULT_MAJOR;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
