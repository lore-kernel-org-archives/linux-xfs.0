Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6CC17E44D;
	Tue, 25 Jun 2024 21:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719352591; cv=none; b=gI9AT+N3D8dcD9P1msoAAPs9FEK5BPNn9IIABBbfht8hJq6Q4Ci5Bcf95svf8w/KunaOCtt7TncbLV6so5NKXBIYGIKUwFtqwT0xDNlr3yL3Vg/SnN1SN6G5AO5ZdB6Dczcj+lnt0vy1KioDFHiPOorrB7mbkyHkOAxJNRzxr44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719352591; c=relaxed/simple;
	bh=GuWNAbs7bjOaL4xc/BCWazvANohjlV1xZcqX4cb6aYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9eM1yYliBGIKFCwUYCPID/QfIoyt9uZFmHBe4BIDpmOEM0stjn9eQ3SCEBSylHAauEyUvAGplIwnDlTgeH1EDtTZD0VSWZHq9+lRWA/o4iUw+1+qQgnkLHLn2LhKsi0Uo5/DWtbFzDWWQxwMyEWIO4170PJld52Wmvj9SBX1jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=euGDFgYI; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="euGDFgYI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719352589; x=1750888589;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GuWNAbs7bjOaL4xc/BCWazvANohjlV1xZcqX4cb6aYc=;
  b=euGDFgYIni1RyIWe6inr+QYYSCoTHoHj3mODwBPmUO4By/paVGRnqYPs
   Kr26F6zuAonUUBr9+6XuL4aPXC2Sj3IRAKFNekJCbzSEPL9Xyr15iiYXq
   Gl3a21u/6fWstoblxC7jlf4nZmo/Wk3+G+rWI2ZP/BHlHmKPj4bNQXkf0
   UoOGI48xTHNofgy6HmbtjiehwrZe6u85Mg14fH3rg9pCC6kjQS3S9kej1
   3sTUnsbSuADyXE+lhF0rlPuNeysK9g81Xs7fFrE4J5Azp23DUhZphLcuW
   K+yjbqvda/ZwfRKu39hLgFeHeVCDtx+RzE9PrPeki9B10Zun/V0iLcM+a
   Q==;
X-CSE-ConnectionGUID: QykL6JPHTQaslLOykv7vxQ==
X-CSE-MsgGUID: cJQu5yDbS2+Xv64TXNFAwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="20280751"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="20280751"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 14:56:29 -0700
X-CSE-ConnectionGUID: pELEltEYQ9isSrYY+jItRw==
X-CSE-MsgGUID: hQBpxJTqSCmHvPdzCK8TVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="43856013"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 25 Jun 2024 14:56:27 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sME9J-000Ekc-0Q;
	Tue, 25 Jun 2024 21:56:25 +0000
Date: Wed, 26 Jun 2024 05:56:06 +0800
From: kernel test robot <lkp@intel.com>
To: alexjlzheng@gmail.com, chandan.babu@oracle.com, djwong@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, alexjlzheng@tencent.com
Subject: Re: [PATCH] xfs: make xfs_log_iovec independent from xfs_log_vec and
 release it early
Message-ID: <202406260523.tGxY7QOx-lkp@intel.com>
References: <20240623123119.3562031-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623123119.3562031-1-alexjlzheng@tencent.com>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on linus/master v6.10-rc5 next-20240625]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/alexjlzheng-gmail-com/xfs-make-xfs_log_iovec-independent-from-xfs_log_vec-and-release-it-early/20240625-192710
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20240623123119.3562031-1-alexjlzheng%40tencent.com
patch subject: [PATCH] xfs: make xfs_log_iovec independent from xfs_log_vec and release it early
config: i386-buildonly-randconfig-004-20240626 (https://download.01.org/0day-ci/archive/20240626/202406260523.tGxY7QOx-lkp@intel.com/config)
compiler: gcc-13 (Ubuntu 13.2.0-4ubuntu3) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240626/202406260523.tGxY7QOx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406260523.tGxY7QOx-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/xfs/libxfs/xfs_da_btree.c:24:
   fs/xfs/xfs_log.h: In function 'xlog_finish_iovec':
>> fs/xfs/xfs_log.h:46:34: warning: unused variable 'lvec' [-Wunused-variable]
      46 |         struct xfs_log_iovec    *lvec = lv->lv_iovecp;
         |                                  ^~~~


vim +/lvec +46 fs/xfs/xfs_log.h

    38	
    39	void *xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
    40			uint type);
    41	
    42	static inline void
    43	xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
    44			int data_len)
    45	{
  > 46		struct xfs_log_iovec	*lvec = lv->lv_iovecp;
    47		struct xlog_op_header	*oph = vec->i_addr;
    48		int			len;
    49	
    50		/*
    51		 * Always round up the length to the correct alignment so callers don't
    52		 * need to know anything about this log vec layout requirement. This
    53		 * means we have to zero the area the data to be written does not cover.
    54		 * This is complicated by fact the payload region is offset into the
    55		 * logvec region by the opheader that tracks the payload.
    56		 */
    57		len = xlog_calc_iovec_len(data_len);
    58		if (len - data_len != 0) {
    59			char	*buf = vec->i_addr + sizeof(struct xlog_op_header);
    60	
    61			memset(buf + data_len, 0, len - data_len);
    62		}
    63	
    64		/*
    65		 * The opheader tracks aligned payload length, whilst the logvec tracks
    66		 * the overall region length.
    67		 */
    68		oph->oh_len = cpu_to_be32(len);
    69	
    70		len += sizeof(struct xlog_op_header);
    71		lv->lv_buf_len += len;
    72		lv->lv_bytes += len;
    73		vec->i_len = len;
    74	
    75		/* Catch buffer overruns */
    76		ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lvec + lv->lv_size);
    77	}
    78	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
