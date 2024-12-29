Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725AE259497
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 17:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735494938; cv=none; b=N85Cg4+1/fR5bc38U4oQ4mo4w/ug66l0PgfVjhWRks/SqdspUMI8oBbF3GM7LMiu1+tchaY2PX8ERUp54n402nlzn7cBp0rGc4idRdthYWuHUnVbjBbFi88dGmJ4sRCs/zLRiR+u7SeCtA/jAsiF7FP5tnGVRXDD+OIcJdVuyWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735494938; c=relaxed/simple;
	bh=68EfKJS4tDBUgfuIRkH7FwfLZsp1BWHarTWhcDMOd4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TG+lSCTRV70VafBGLsxGWIQDrhoVeAIkz/MrJ/nmDX3qZ4PGQXKpyabexjkzmlzotoATupufADQn1xEFMtzTcCgOzQ9Hs3ldN7KI7BMAzH5abDZjEYC+8E10HkMBrP6i5hbGbZaIOXWDHWZpUn2YhRz3ZSGPi6hE51pWEDj2aQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixlMJSGH; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixlMJSGH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735494936; x=1767030936;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=68EfKJS4tDBUgfuIRkH7FwfLZsp1BWHarTWhcDMOd4U=;
  b=ixlMJSGH5lRuMAelK60WyLseVPg6Ek10f24kb1QswK/327He9jWr8QXM
   8dNoMhmQVe0xktHii+B9Gaw5FAhULHBRn1oZ4N/fTUsB1ECLJv2OFkwh0
   ncDxmejwUrb35zCmR50Gd1JBYpkaYHP14nqju4/hiN/4TPgAj2rZv9YmB
   vDIkOz3tnPxzNjikus/SOikdnIyjbVXBU65y5xSHMHgPFV3Lq2tEX8pZs
   ccjGpWHDe7vvOAlGk5VeyhLk85v+rn0zp+xdi6n7lwLiKGEPEo9y0scTz
   xtO5eYFbTrGsRzLerqFw0P40KSRxVGeHZZqz3U7InDipnLSSiZZV2vIh5
   g==;
X-CSE-ConnectionGUID: WONFAbjyTNm9EKMxNhnBjA==
X-CSE-MsgGUID: AeLCo6HGSQ+QtqD0cPj1Tg==
X-IronPort-AV: E=McAfee;i="6700,10204,11299"; a="39734349"
X-IronPort-AV: E=Sophos;i="6.12,274,1728975600"; 
   d="scan'208";a="39734349"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2024 09:55:36 -0800
X-CSE-ConnectionGUID: Ufv39eOWSwW2s1o4viu9mw==
X-CSE-MsgGUID: EAgsQH1sTp6iqMShiXGb9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="105683657"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 29 Dec 2024 09:55:34 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tRxVi-0004rg-1m;
	Sun, 29 Dec 2024 17:55:30 +0000
Date: Mon, 30 Dec 2024 01:54:38 +0800
From: kernel test robot <lkp@intel.com>
To: Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, djwong@kernel.org,
	david@fromorbit.com, hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH 1/2] iomap: add iomap_writepages_unbound() to write
 beyond EOF
Message-ID: <202412300135.cvWMPZGf-lkp@intel.com>
References: <20241229133640.1193578-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241229133640.1193578-2-aalbersh@kernel.org>

Hi Andrey,

kernel test robot noticed the following build errors:

[auto build test ERROR on brauner-vfs/vfs.all]
[also build test ERROR on linus/master v6.13-rc4 next-20241220]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Andrey-Albershteyn/iomap-add-iomap_writepages_unbound-to-write-beyond-EOF/20241229-213942
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/20241229133640.1193578-2-aalbersh%40kernel.org
patch subject: [PATCH 1/2] iomap: add iomap_writepages_unbound() to write beyond EOF
config: s390-randconfig-002-20241229 (https://download.01.org/0day-ci/archive/20241230/202412300135.cvWMPZGf-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241230/202412300135.cvWMPZGf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412300135.cvWMPZGf-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/iomap/buffered-io.c:982:23: error: use of undeclared identifier 'IOMAP_NOSIZE'
                   if (!(iter->flags & IOMAP_NOSIZE) && (pos + written > old_size)) {
                                       ^
   fs/iomap/buffered-io.c:988:23: error: use of undeclared identifier 'IOMAP_NOSIZE'
                   if (!(iter->flags & IOMAP_NOSIZE) && (old_size < pos))
                                       ^
   2 errors generated.


vim +/IOMAP_NOSIZE +982 fs/iomap/buffered-io.c

   909	
   910	static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
   911	{
   912		loff_t length = iomap_length(iter);
   913		loff_t pos = iter->pos;
   914		ssize_t total_written = 0;
   915		long status = 0;
   916		struct address_space *mapping = iter->inode->i_mapping;
   917		size_t chunk = mapping_max_folio_size(mapping);
   918		unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
   919	
   920		do {
   921			struct folio *folio;
   922			loff_t old_size;
   923			size_t offset;		/* Offset into folio */
   924			size_t bytes;		/* Bytes to write to folio */
   925			size_t copied;		/* Bytes copied from user */
   926			size_t written;		/* Bytes have been written */
   927	
   928			bytes = iov_iter_count(i);
   929	retry:
   930			offset = pos & (chunk - 1);
   931			bytes = min(chunk - offset, bytes);
   932			status = balance_dirty_pages_ratelimited_flags(mapping,
   933								       bdp_flags);
   934			if (unlikely(status))
   935				break;
   936	
   937			if (bytes > length)
   938				bytes = length;
   939	
   940			/*
   941			 * Bring in the user page that we'll copy from _first_.
   942			 * Otherwise there's a nasty deadlock on copying from the
   943			 * same page as we're writing to, without it being marked
   944			 * up-to-date.
   945			 *
   946			 * For async buffered writes the assumption is that the user
   947			 * page has already been faulted in. This can be optimized by
   948			 * faulting the user page.
   949			 */
   950			if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {
   951				status = -EFAULT;
   952				break;
   953			}
   954	
   955			status = iomap_write_begin(iter, pos, bytes, &folio);
   956			if (unlikely(status)) {
   957				iomap_write_failed(iter->inode, pos, bytes);
   958				break;
   959			}
   960			if (iter->iomap.flags & IOMAP_F_STALE)
   961				break;
   962	
   963			offset = offset_in_folio(folio, pos);
   964			if (bytes > folio_size(folio) - offset)
   965				bytes = folio_size(folio) - offset;
   966	
   967			if (mapping_writably_mapped(mapping))
   968				flush_dcache_folio(folio);
   969	
   970			copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
   971			written = iomap_write_end(iter, pos, bytes, copied, folio) ?
   972				  copied : 0;
   973	
   974			/*
   975			 * Update the in-memory inode size after copying the data into
   976			 * the page cache.  It's up to the file system to write the
   977			 * updated size to disk, preferably after I/O completion so that
   978			 * no stale data is exposed.  Only once that's done can we
   979			 * unlock and release the folio.
   980			 */
   981			old_size = iter->inode->i_size;
 > 982			if (!(iter->flags & IOMAP_NOSIZE) && (pos + written > old_size)) {
   983				i_size_write(iter->inode, pos + written);
   984				iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
   985			}
   986			__iomap_put_folio(iter, pos, written, folio);
   987	
   988			if (!(iter->flags & IOMAP_NOSIZE) && (old_size < pos))
   989				pagecache_isize_extended(iter->inode, old_size, pos);
   990	
   991			cond_resched();
   992			if (unlikely(written == 0)) {
   993				/*
   994				 * A short copy made iomap_write_end() reject the
   995				 * thing entirely.  Might be memory poisoning
   996				 * halfway through, might be a race with munmap,
   997				 * might be severe memory pressure.
   998				 */
   999				iomap_write_failed(iter->inode, pos, bytes);
  1000				iov_iter_revert(i, copied);
  1001	
  1002				if (chunk > PAGE_SIZE)
  1003					chunk /= 2;
  1004				if (copied) {
  1005					bytes = copied;
  1006					goto retry;
  1007				}
  1008			} else {
  1009				pos += written;
  1010				total_written += written;
  1011				length -= written;
  1012			}
  1013		} while (iov_iter_count(i) && length);
  1014	
  1015		if (status == -EAGAIN) {
  1016			iov_iter_revert(i, total_written);
  1017			return -EAGAIN;
  1018		}
  1019		return total_written ? total_written : status;
  1020	}
  1021	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
