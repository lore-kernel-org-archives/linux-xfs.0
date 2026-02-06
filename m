Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8270D32E72C;
	Fri,  6 Feb 2026 09:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770370854; cv=none; b=gc/eq5j1ZxUPqXxQmVEyKFj3gU+/BjC7aXg4hhrZp+WXO08qCm3WnT4hV9a85OpJmtRh93XZMkveZArWGgW8Ku6bE+IwOCcRyDcOmReDb/BJnJE71AgK3EeymEkLfLyY3STLIBQZc555fUtplsFNwHSaCefU7qkZDHHjaxjTrGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770370854; c=relaxed/simple;
	bh=fC0bZIWHVa85gQm485t6OL57fPmerIVuB3ioec0wM+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AcCtA7Ru972WUM9D+YFfVX9HJID3KceaNgD26jcyoD66sywwcu4dxRBVBi8meE9Lm+qelQk+YcFG6U2i5B/G002hYlcJUPBqReMkg1L2pr7Y4BC5SS6I6+2zddl6HmmgO4FbaF97/zjSzbF6QCTLxEA1DuWNZdb1lTdNo0jXKbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D+iSRACW; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D+iSRACW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770370854; x=1801906854;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fC0bZIWHVa85gQm485t6OL57fPmerIVuB3ioec0wM+0=;
  b=D+iSRACWopvz7D/s7g9J5ODeuFmcQ3rgzx4b+HtiCcMiSImXqBXiB5hN
   zVooZwGNGLn13CY0ViWag+j/+rwWIoqWH/T+Nj3Bc5x8cQiBOSXwnsuJG
   CpFYcKrbk2ZaH0E8WRfL9EtgDSTtUNDzEK/dluXtT+3B4iIavD9pWvycx
   PuDadLJ9ThWZWLN4q2L1vtX3tYW7MS+RgZlUi5JUlU8ydUEpV5Vwt5Dtb
   M3PvBcn5IZ8f5EbtBkN9v1t5er2syrcWetlgW9XjS5vaXCUAjOi2BFFZe
   1037cEU5X4uXzeYFXSDU02eYtLJUwnS3sfzw10VjRNtykP5uCLq7lvL6Y
   g==;
X-CSE-ConnectionGUID: Wg17dtXUQy6sE/tD6pWvug==
X-CSE-MsgGUID: PHsg6JKzRgCi57vB6N9cLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="70772766"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="70772766"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 01:40:54 -0800
X-CSE-ConnectionGUID: bx4xuHGASRyNDscEi8vz+Q==
X-CSE-MsgGUID: q/RPj8O1ToOaz+/Bgqq4Xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="215794011"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 06 Feb 2026 01:40:51 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1voIKX-00000000kcS-1Gud;
	Fri, 06 Feb 2026 09:40:49 +0000
Date: Fri, 6 Feb 2026 17:39:54 +0800
From: kernel test robot <lkp@intel.com>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Message-ID: <202602061752.Okg2N6tw-lkp@intel.com>
References: <20260206030557.1201204-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206030557.1201204-2-wilfred.opensource@gmail.com>

Hi Wilfred,

kernel test robot noticed the following build errors:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on linus/master v6.19-rc8 next-20260205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Wilfred-Mallawa/xfs-add-static-size-checks-for-structures-in-xfs_fs-h/20260206-111013
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20260206030557.1201204-2-wilfred.opensource%40gmail.com
patch subject: [PATCH] xfs: add static size checks for structures in xfs_fs.h
config: m68k-hp300_defconfig (https://download.01.org/0day-ci/archive/20260206/202602061752.Okg2N6tw-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260206/202602061752.Okg2N6tw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602061752.Okg2N6tw-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/semaphore.h:11,
                    from fs/xfs/xfs_platform.h:11,
                    from fs/xfs/xfs_super.c:7:
   fs/xfs/libxfs/xfs_ondisk.h: In function 'xfs_check_ondisk_structs':
>> include/linux/build_bug.h:78:41: error: static assertion failed: "XFS: sizeof(struct xfs_flock64) is wrong, expected 48"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:10:9: note: in expansion of macro 'static_assert'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ^~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:230:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
     230 |         XFS_CHECK_STRUCT_SIZE(struct xfs_flock64,               48);
         |         ^~~~~~~~~~~~~~~~~~~~~
>> include/linux/build_bug.h:78:41: error: static assertion failed: "XFS: sizeof(struct xfs_fsop_geom_v1) is wrong, expected 112"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:10:9: note: in expansion of macro 'static_assert'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ^~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:231:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
     231 |         XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,          112);
         |         ^~~~~~~~~~~~~~~~~~~~~
>> include/linux/build_bug.h:78:41: error: static assertion failed: "XFS: sizeof(xfs_growfs_data_t) is wrong, expected 16"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:10:9: note: in expansion of macro 'static_assert'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ^~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:236:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
     236 |         XFS_CHECK_STRUCT_SIZE(xfs_growfs_data_t,                16);
         |         ^~~~~~~~~~~~~~~~~~~~~
>> include/linux/build_bug.h:78:41: error: static assertion failed: "XFS: sizeof(xfs_growfs_rt_t) is wrong, expected 16"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:10:9: note: in expansion of macro 'static_assert'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ^~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:238:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
     238 |         XFS_CHECK_STRUCT_SIZE(xfs_growfs_rt_t,                  16);
         |         ^~~~~~~~~~~~~~~~~~~~~
>> include/linux/build_bug.h:78:41: error: static assertion failed: "XFS: sizeof(struct xfs_inogrp) is wrong, expected 24"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:10:9: note: in expansion of macro 'static_assert'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ^~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:239:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
     239 |         XFS_CHECK_STRUCT_SIZE(struct xfs_inogrp,                24);
         |         ^~~~~~~~~~~~~~~~~~~~~
--
   In file included from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/semaphore.h:11,
                    from xfs_platform.h:11,
                    from xfs_super.c:7:
   ././libxfs/xfs_ondisk.h: In function 'xfs_check_ondisk_structs':
>> include/linux/build_bug.h:78:41: error: static assertion failed: "XFS: sizeof(struct xfs_flock64) is wrong, expected 48"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   ././libxfs/xfs_ondisk.h:10:9: note: in expansion of macro 'static_assert'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ^~~~~~~~~~~~~
   ././libxfs/xfs_ondisk.h:230:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
     230 |         XFS_CHECK_STRUCT_SIZE(struct xfs_flock64,               48);
         |         ^~~~~~~~~~~~~~~~~~~~~
>> include/linux/build_bug.h:78:41: error: static assertion failed: "XFS: sizeof(struct xfs_fsop_geom_v1) is wrong, expected 112"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   ././libxfs/xfs_ondisk.h:10:9: note: in expansion of macro 'static_assert'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ^~~~~~~~~~~~~
   ././libxfs/xfs_ondisk.h:231:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
     231 |         XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,          112);
         |         ^~~~~~~~~~~~~~~~~~~~~
>> include/linux/build_bug.h:78:41: error: static assertion failed: "XFS: sizeof(xfs_growfs_data_t) is wrong, expected 16"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   ././libxfs/xfs_ondisk.h:10:9: note: in expansion of macro 'static_assert'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ^~~~~~~~~~~~~
   ././libxfs/xfs_ondisk.h:236:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
     236 |         XFS_CHECK_STRUCT_SIZE(xfs_growfs_data_t,                16);
         |         ^~~~~~~~~~~~~~~~~~~~~
>> include/linux/build_bug.h:78:41: error: static assertion failed: "XFS: sizeof(xfs_growfs_rt_t) is wrong, expected 16"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   ././libxfs/xfs_ondisk.h:10:9: note: in expansion of macro 'static_assert'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ^~~~~~~~~~~~~
   ././libxfs/xfs_ondisk.h:238:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
     238 |         XFS_CHECK_STRUCT_SIZE(xfs_growfs_rt_t,                  16);
         |         ^~~~~~~~~~~~~~~~~~~~~
>> include/linux/build_bug.h:78:41: error: static assertion failed: "XFS: sizeof(struct xfs_inogrp) is wrong, expected 24"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   ././libxfs/xfs_ondisk.h:10:9: note: in expansion of macro 'static_assert'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ^~~~~~~~~~~~~
   ././libxfs/xfs_ondisk.h:239:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
     239 |         XFS_CHECK_STRUCT_SIZE(struct xfs_inogrp,                24);
         |         ^~~~~~~~~~~~~~~~~~~~~


vim +78 include/linux/build_bug.h

bc6245e5efd70c Ian Abbott       2017-07-10  60  
6bab69c65013be Rasmus Villemoes 2019-03-07  61  /**
6bab69c65013be Rasmus Villemoes 2019-03-07  62   * static_assert - check integer constant expression at build time
6bab69c65013be Rasmus Villemoes 2019-03-07  63   *
6bab69c65013be Rasmus Villemoes 2019-03-07  64   * static_assert() is a wrapper for the C11 _Static_assert, with a
6bab69c65013be Rasmus Villemoes 2019-03-07  65   * little macro magic to make the message optional (defaulting to the
6bab69c65013be Rasmus Villemoes 2019-03-07  66   * stringification of the tested expression).
6bab69c65013be Rasmus Villemoes 2019-03-07  67   *
6bab69c65013be Rasmus Villemoes 2019-03-07  68   * Contrary to BUILD_BUG_ON(), static_assert() can be used at global
6bab69c65013be Rasmus Villemoes 2019-03-07  69   * scope, but requires the expression to be an integer constant
6bab69c65013be Rasmus Villemoes 2019-03-07  70   * expression (i.e., it is not enough that __builtin_constant_p() is
6bab69c65013be Rasmus Villemoes 2019-03-07  71   * true for expr).
6bab69c65013be Rasmus Villemoes 2019-03-07  72   *
6bab69c65013be Rasmus Villemoes 2019-03-07  73   * Also note that BUILD_BUG_ON() fails the build if the condition is
6bab69c65013be Rasmus Villemoes 2019-03-07  74   * true, while static_assert() fails the build if the expression is
6bab69c65013be Rasmus Villemoes 2019-03-07  75   * false.
6bab69c65013be Rasmus Villemoes 2019-03-07  76   */
6bab69c65013be Rasmus Villemoes 2019-03-07  77  #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
6bab69c65013be Rasmus Villemoes 2019-03-07 @78  #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
6bab69c65013be Rasmus Villemoes 2019-03-07  79  
07a368b3f55a79 Maxim Levitsky   2022-10-25  80  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
