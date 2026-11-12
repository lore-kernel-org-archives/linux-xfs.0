Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794511071;
	b=AHFqp9oUu8tlg0/qUVhtuf2hwvGqDRv14Tm1Q6SrK8JNyNA588mqcCLwPZdP3S/H5j7X
	 77aZXCrV1v0KdicRqoxHxjL7nUIitCBZEbylVtRVJBAB9Nn6Gu7pb7ndllouaifeAFwRt
	 pf0djiUYswsPcJCSOePlx4OKT7Ded24FZIkk6LB7LBCrQRMx7SOwIEz1A6WkZsLnSuc1x
	 0/cky9+KOJ/SakToQuMQahQwz875oqVtfjigdzsLaVsKB2LR/AuGhK4KTxQaKN74Zid1w
	 tQKfcNTnz1fHmxmVWLzzrcjeQJkhKR6soQacyAqAw6W4hU1srq2jANp7K0IdIB6c7Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794511071;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=NM8hEvDsyj53GoOS63YWbmZbMNCb5e1wMTKVRZfgFns=;
	b=IUkrtYqN6VTN2nxQx25qoOb6gJcrIBoPfYYEAqfmSUFNwGD7liw3u2gAbkKg27aHNw7+
	 WbNaXWrmVQ/sAEtybfKuT7kge4ARV8adHQVdlJX1qa/TxPMAZEUxu86tmTdG1ovZjvFAV
	 2ujoT76tbyCPIlhi/5zg7UVVQROhpFboIb1qVyBA3H6RAg8YcOn6DPO1BTqoS/qmwKA0O
	 zVTUtrbDGn0r08o4S/xBV0kmQ7MhQzbrRVd5SfsCHIk8eRhPXjT971EkDx0pb3Q9iM8Cx
	 Og3fe6G+jVFg+ugaqbbCbUHh85kdwxNmpw/71mxi/l81JTQDZOHeJDCPvnNPkSlbv+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=A1Pl8a2d;
	arc=none smtp.remote-ip=198.175.65.10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FCD606A336;
	Thu, 12 Nov 2026 19:17:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2FCD606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=A1Pl8a2d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794511069; x=1826047069;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QXj5V9B+DPU/kbEKR6nPDD91AkHCuaht9RC9Kzlyoh4=;
  b=A1Pl8a2db95s8Xyjd+e/i1gzuq3Xu+oxSbWK3+ySkJ0lSKqSEZMYdC4N
   Q/Nf3r1o11KrFmGF6MdQi6UxeemW+/I7OOk7Rb7ix0B6nUviq0U41lYp2
   CWWAbmQ58N4ardKS2Xz+n+NjPaQBPwLepYIxywFp7/hCKM4j7WlUd0Iu+
   nhwyyy8h7KFOZMl++6kvTonZRMfB8uslWstU1LH1cyhb98Yh02F2c80XU
   dnbiBSHmS0HSVvWL44fSVS3a6CeqV3WlEq7YiFCuK307M77k1MrpmmXO9
   rYkQkGzsyvffZ8/eRrhEzVhpCY311VRjQUH0PJED8UV4v9qqq6+IkGkhP
   w==;
X-CSE-ConnectionGUID: /W1UONB4TUe5ex20PkuRJg==
X-CSE-MsgGUID: fXxJcu8oREClsMErdIrVRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11964"; a="3216974"
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="3216974"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 11:17:49 -0800
X-CSE-ConnectionGUID: uS3kAE7SRt2/q8epaHuiww==
X-CSE-MsgGUID: KP39O6smQ7WlIcF1hv3mEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="10464617"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa012.fm.intel.com with ESMTP; 12 Nov 2026 11:17:47 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRaIq-000000011xb-3v5I;
	Thu, 12 Nov 2026 19:17:44 +0000
Date: Fri, 13 Nov 2026 03:17:39 +0800
From: kernel test robot <lkp@intel.com>
To: Wang Yibo <wangyibo@kylinos.cn>, arlos Maiolino <cem@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: convert the dahash test to KUnit
Message-ID: <202611130302.dGXAb4Py-lkp@intel.com>
References: <20261112041631.2792545-1-wangyibo@kylinos.cn>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112041631.2792545-1-wangyibo@kylinos.cn>

Hi Wang,

kernel test robot noticed the following build errors:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on linus/master v7.4-rc2 next-20261111]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Wang-Yibo/xfs-convert-the-dahash-test-to-KUnit/20261112-121631
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20261112041631.2792545-1-wangyibo%40kylinos.cn
patch subject: [PATCH] xfs: convert the dahash test to KUnit
config: i386-randconfig-1012-20261112 (https://download.01.org/0day-ci/archive/20261113/202611130302.dGXAb4Py-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261113/202611130302.dGXAb4Py-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611130302.dGXAb4Py-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: fs/xfs/xfs_dahash_test.o: in function `xfs_ascii_ci_hashname_case':
>> fs/xfs/xfs_dahash_test.c:671:(.text+0x88): undefined reference to `kunit_binary_assert_format'
>> ld: fs/xfs/xfs_dahash_test.c:671:(.text+0xc0): undefined reference to `__kunit_do_failed_assertion'
   ld: fs/xfs/xfs_dahash_test.o: in function `xfs_da_hashname_case':
   fs/xfs/xfs_dahash_test.c:655:(.text+0x178): undefined reference to `kunit_binary_assert_format'
   ld: fs/xfs/xfs_dahash_test.c:655:(.text+0x1b0): undefined reference to `__kunit_do_failed_assertion'


vim +671 fs/xfs/xfs_dahash_test.c

   658	
   659	static void xfs_ascii_ci_hashname_case(struct kunit *test)
   660	{
   661		unsigned int	i;
   662	
   663		for (i = 0; i < ARRAY_SIZE(dahash_test_vecs); i++) {
   664			const struct dahash_test	*tv = &dahash_test_vecs[i];
   665			struct xfs_name			xname = { };
   666			xfs_dahash_t			hash;
   667	
   668			xname.name = test_buf + tv->start;
   669			xname.len = tv->length;
   670			hash = xfs_ascii_ci_hashname(&xname);
 > 671			KUNIT_EXPECT_EQ_MSG(test, hash, tv->ascii_ci_dahash,
   672					    "case %u", i);
   673		}
   674	}
   675	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
