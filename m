Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 66BE17F37
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 03:36:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EFDFFAC004
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 01:36:29 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id 2qgLf0eBB2lasASR for
	<xfs@oss.sgi.com>; Thu, 01 Oct 2015 01:36:26 -0700 (PDT)
Date: Thu, 1 Oct 2015 16:35:50 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/7] Revert "mm: take i_mmap_lock in
	unmap_mapping_range() for DAX"
Message-ID: <201510011627.eAfVmtFF%fengguang.wu@intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, willy@linux.intel.com, ross.zwisler@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com

Hi Dave,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/dax.c:626:50: sparse: incorrect type in argument 1 (different address spaces)
   fs/dax.c:626:50:    expected void *page
   fs/dax.c:626:50:    got void [noderef] <asn:5>*

vim +626 fs/dax.c

   610			result = VM_FAULT_NOPAGE;
   611			spin_unlock(ptl);
   612		} else {
   613			sector = bh.b_blocknr << (blkbits - 9);
   614			length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
   615							bh.b_size);
   616			if (length < 0) {
   617				result = VM_FAULT_SIGBUS;
   618				goto out;
   619			}
   620			if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
   621				goto fallback;
   622	
   623			if (buffer_unwritten(&bh) || buffer_new(&bh)) {
   624				int i;
   625				for (i = 0; i < PTRS_PER_PMD; i++)
 > 626					clear_page(kaddr + i * PAGE_SIZE);
   627				count_vm_event(PGMAJFAULT);
   628				mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
   629				result |= VM_FAULT_MAJOR;
   630			}
   631	
   632			result |= vmf_insert_pfn_pmd(vma, address, pmd, pfn, write);
   633		}
   634	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
