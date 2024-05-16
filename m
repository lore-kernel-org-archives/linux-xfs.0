Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DFF146D51;
	Thu, 16 May 2024 13:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715865608; cv=none; b=g3Qhy56pQKSDcG2HuSAnaBG3hawGWzvJPkBtEvMA4ZE9g/+3IB0cFZxGrRT5mzE34+6NB+jhbt7dgq8H1ZULaZPOm4Chd0GtrW4zqr+raq7Ghi7rlzmYhwo4FYSvD/GXMk45aR7DO4MYefXnhIfAupqnXbGVIgepFxCHCLiibXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715865608; c=relaxed/simple;
	bh=S/7bv2DW/RD5v55OFxWspAXUnoxf9fnBX1m+bUjyDos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bgz+Vom69i4IizO2rcf55K9do3Lmq2xCNUMjLGithqrr0f+gzKGj5k1TJ2fu7gEaxb2+DXFqUSz4+WlbP25bIAaLyyBZ0ER8muXa2hYlYzdN0247wYRk5VEktuackV9lhfGP6ibAiEwlppfS5Sydny6e+I6EFyZz3zFT5/D1B6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CW7Q2VcR; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CW7Q2VcR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715865606; x=1747401606;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S/7bv2DW/RD5v55OFxWspAXUnoxf9fnBX1m+bUjyDos=;
  b=CW7Q2VcRWOAmRN5zWEQk7DQbJ0ZRptJzozkBEo4FXA50iNCTTo18qno7
   RTpU/cf2NXug4uz8oC1zssN3pAuTqLod1g+t5KUwc2GRrDBK/5h3aUbqn
   hulSBCX20SwzrjctP5jMag56cKeWUvsE7WWs/PcxI46UjuICloSK1ZSSI
   n2wxThwtmlVtIiOiwCvR7VjSD4nhO87qOZz8G34YCPcBzhvsOnM7NatSd
   RwrpsODVBRQRMRPq6bmW1vVB33fgbSrgMf3Kz+LwZJzXvI8K5X6At2rOk
   njqIaLfSXNlee7iCrXTYMjqVcWlRVuNXnOGa9myTQ8momAlqc/UmwYiwt
   g==;
X-CSE-ConnectionGUID: PY9VC51VTZKd614LcFWCpw==
X-CSE-MsgGUID: V0k4P9EiRQWEpPX9e5t8xw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12087061"
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="12087061"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 06:20:05 -0700
X-CSE-ConnectionGUID: GYJLNoBZRE2e5mjP1Y+xtg==
X-CSE-MsgGUID: eLjji0ibTOy19GYkWIHYbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="35975470"
Received: from lkp-server01.sh.intel.com (HELO f8b243fe6e68) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 16 May 2024 06:20:00 -0700
Received: from kbuild by f8b243fe6e68 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s7b1Z-000EGh-2R;
	Thu, 16 May 2024 13:19:57 +0000
Date: Thu, 16 May 2024 21:19:40 +0800
From: kernel test robot <lkp@intel.com>
To: Daniel Gomez <da.gomez@samsung.com>,
	"hughd@google.com" <hughd@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"jack@suse.cz" <jack@suse.cz>,
	"mcgrof@kernel.org" <mcgrof@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"djwong@kernel.org" <djwong@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	"dagmcr@gmail.com" <dagmcr@gmail.com>,
	"yosryahmed@google.com" <yosryahmed@google.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"ritesh.list@gmail.com" <ritesh.list@gmail.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>,
	"chandan.babu@oracle.com" <chandan.babu@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"brauner@kernel.org" <brauner@kernel.org>,
	Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [PATCH 07/12] shmem: check if a block is uptodate before splice
 into pipe
Message-ID: <202405162045.kaXgB2n3-lkp@intel.com>
References: <20240515055719.32577-8-da.gomez@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515055719.32577-8-da.gomez@samsung.com>

Hi Daniel,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on xfs-linux/for-next brauner-vfs/vfs.all linus/master v6.9 next-20240516]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniel-Gomez/splice-don-t-check-for-uptodate-if-partially-uptodate-is-impl/20240515-135925
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20240515055719.32577-8-da.gomez%40samsung.com
patch subject: [PATCH 07/12] shmem: check if a block is uptodate before splice into pipe
config: arm-s5pv210_defconfig (https://download.01.org/0day-ci/archive/20240516/202405162045.kaXgB2n3-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240516/202405162045.kaXgB2n3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405162045.kaXgB2n3-lkp@intel.com/

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: mm/shmem.o: in function `shmem_file_splice_read':
>> mm/shmem.c:3240:(.text+0x5224): undefined reference to `__aeabi_ldivmod'


vim +3240 mm/shmem.c

  3174	
  3175	static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
  3176					      struct pipe_inode_info *pipe,
  3177					      size_t len, unsigned int flags)
  3178	{
  3179		struct inode *inode = file_inode(in);
  3180		struct address_space *mapping = inode->i_mapping;
  3181		struct folio *folio = NULL;
  3182		size_t total_spliced = 0, used, npages, n, part;
  3183		loff_t isize;
  3184		int error = 0;
  3185	
  3186		/* Work out how much data we can actually add into the pipe */
  3187		used = pipe_occupancy(pipe->head, pipe->tail);
  3188		npages = max_t(ssize_t, pipe->max_usage - used, 0);
  3189		len = min_t(size_t, len, npages * PAGE_SIZE);
  3190	
  3191		do {
  3192			if (*ppos >= i_size_read(inode))
  3193				break;
  3194	
  3195			error = shmem_get_folio(inode, *ppos / PAGE_SIZE, &folio,
  3196						SGP_READ);
  3197			if (error) {
  3198				if (error == -EINVAL)
  3199					error = 0;
  3200				break;
  3201			}
  3202			if (folio) {
  3203				folio_unlock(folio);
  3204	
  3205				if (folio_test_hwpoison(folio) ||
  3206				    (folio_test_large(folio) &&
  3207				     folio_test_has_hwpoisoned(folio))) {
  3208					error = -EIO;
  3209					break;
  3210				}
  3211			}
  3212	
  3213			/*
  3214			 * i_size must be checked after we know the pages are Uptodate.
  3215			 *
  3216			 * Checking i_size after the check allows us to calculate
  3217			 * the correct value for "nr", which means the zero-filled
  3218			 * part of the page is not copied back to userspace (unless
  3219			 * another truncate extends the file - this is desired though).
  3220			 */
  3221			isize = i_size_read(inode);
  3222			if (unlikely(*ppos >= isize))
  3223				break;
  3224			part = min_t(loff_t, isize - *ppos, len);
  3225			if (folio && folio_test_large(folio) &&
  3226			    folio_test_private(folio)) {
  3227				unsigned long from = offset_in_folio(folio, *ppos);
  3228				unsigned int bfirst = from >> inode->i_blkbits;
  3229				unsigned int blast, blast_upd;
  3230	
  3231				len = min(folio_size(folio) - from, len);
  3232				blast = (from + len - 1) >> inode->i_blkbits;
  3233	
  3234				blast_upd = sfs_get_last_block_uptodate(folio, bfirst,
  3235									blast);
  3236				if (blast_upd <= blast) {
  3237					unsigned int bsize = 1 << inode->i_blkbits;
  3238					unsigned int blks = blast_upd - bfirst + 1;
  3239					unsigned int bbytes = blks << inode->i_blkbits;
> 3240					unsigned int boff = (*ppos % bsize);
  3241	
  3242					part = min_t(loff_t, bbytes - boff, len);
  3243				}
  3244			}
  3245	
  3246			if (folio && shmem_is_block_uptodate(
  3247					     folio, offset_in_folio(folio, *ppos) >>
  3248							    inode->i_blkbits)) {
  3249				/*
  3250				 * If users can be writing to this page using arbitrary
  3251				 * virtual addresses, take care about potential aliasing
  3252				 * before reading the page on the kernel side.
  3253				 */
  3254				if (mapping_writably_mapped(mapping))
  3255					flush_dcache_folio(folio);
  3256				folio_mark_accessed(folio);
  3257				/*
  3258				 * Ok, we have the page, and it's up-to-date, so we can
  3259				 * now splice it into the pipe.
  3260				 */
  3261				n = splice_folio_into_pipe(pipe, folio, *ppos, part);
  3262				folio_put(folio);
  3263				folio = NULL;
  3264			} else {
  3265				n = splice_zeropage_into_pipe(pipe, *ppos, part);
  3266			}
  3267	
  3268			if (!n)
  3269				break;
  3270			len -= n;
  3271			total_spliced += n;
  3272			*ppos += n;
  3273			in->f_ra.prev_pos = *ppos;
  3274			if (pipe_full(pipe->head, pipe->tail, pipe->max_usage))
  3275				break;
  3276	
  3277			cond_resched();
  3278		} while (len);
  3279	
  3280		if (folio)
  3281			folio_put(folio);
  3282	
  3283		file_accessed(in);
  3284		return total_spliced ? total_spliced : error;
  3285	}
  3286	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
