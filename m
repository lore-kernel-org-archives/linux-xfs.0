Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792983063;
	b=IVaKilpO+4wD15Tkvndqewn8HS3WK1BPh8U4FF8VubhINnzmR60IL39ILcwYND/seSe4
	 Y8rhuFSy5DKreQTVUAbIH+wZyCG7yg7RANu64WJ0zLK0QP6fqzixWQNY0ow3QyiTZ+RfM
	 Ar0BxoNECLFTs99a7s8gPpNwjRooaf7hPnRLRdf5610Okhe72u6y8yu9o+RpjTtNWBll8
	 4LPDhL1yKWtAbSJv5c4xA+zwo8HOgqMzgErFMc8g4eF6E6msqwMkV/XfAg8hS8yer16NV
	 X6RGU3cVMpcNyITHcYdppQxs6t4fC7FtyCI5s4JsgbLw65NRFyk+p8A+rpIys9A35Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792983063;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=xHuoZ+h2G+HqgwQEUWSqVaW/80N7rYFmQYCMmYvVBMc=;
	b=2x9DZxCOGN0XNVNS2kPisS+VEumALOHgRYe04kpLiyGIr5xOqPWHycoFPV22AiTaDTcs
	 z1SCV9Z2hX3sQ9Ilf9z3zJ2YW5ARqOFcqCA4YUshRauNjG7eL06ZItt3V6MhWgfHy0s7L
	 4QUwBaOZvljZhBR6Ru7RkfeMSZ4bpfj4Dmc4paAO+Gxx1eFYL+Sar4ABrqwlblyUnwLMo
	 RpXGgSGlWhyT2A8L2b+hLtlTVewkbGL9xFfFoi/9nhw7+/K9leamsSi20ubRDgvM99DJP
	 mqYAHNbXQfNQ9xGI1g+cORLURIRK2MuuWYIafdDWstzfglzoTIbr+YW5LPQnFI72NVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=eE0xLLmA;
	arc=none smtp.remote-ip=198.175.65.18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7008606A31B;
	Mon, 26 Oct 2026 02:51:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7008606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=eE0xLLmA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792983062; x=1824519062;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=37QYAusxgWwB+9fgXsOBG6M9Blu9law9qU4Uq9MXK1w=;
  b=eE0xLLmAUpBI9Oze0JEfbTVUj1Y4hVuiTNNaC0f9vBY9eUfzRK1BbmrP
   oKLpzVVn23lEzd7lBpMJkncZvTVHBm5U3laFWEotGY5ZokoYXAoXrzeZI
   5O7slihLgdR4Op2eDzrzGgw2g/clMuCTC8hoQQnCUtSGCccwvAqQ4FpNr
   8kTaVwzKwoQ1NglDhjZ8adiOqOiih6UIuvT2MAuLUadu/sHXKwsLDL1Dy
   kI/GkpFASlYX947+FnaMCWe322lnsBU1lcxggnMI1bZVI8545f9Kkq8Ny
   a5mQXW9NyQjnLrUVwD++OId6rxb+Tyt6aGi5rysu8oKkMExQ35tfzyh8G
   A==;
X-CSE-ConnectionGUID: 6hu8MXxHTJawZRAZdxsiGg==
X-CSE-MsgGUID: lqY/zz6fRoivRmvY3klqRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11946"; a="1645943"
X-IronPort-AV: E=Sophos;i="6.27,178,1787036400"; 
   d="scan'208";a="1645943"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2026 19:51:02 -0700
X-CSE-ConnectionGUID: 68vOWsN9QrqwoxAiQxXaYg==
X-CSE-MsgGUID: UalFpjLVSCOmuymhkr5uvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,178,1787036400"; 
   d="scan'208";a="4244243"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2026 19:50:59 -0700
Date: Mon, 26 Oct 2026 10:50:56 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Qu Wenruo <wqu@suse.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	yi1.lai@intel.com
Subject: Re: [PATCH v4] iomap: follow the alignment requirement for
 iomap_dio_hole_iter()
Message-ID: <202610261048.3dc64aea-lkp@intel.com>
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
In-Reply-To: <73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.git.wqu@suse.com>


Hello,

kernel test robot noticed "xfstests.generic.091.fail" on:

commit: 4025185cf953e3f52ab63cf5fec50c1485ee7bb7 ("[PATCH v4] iomap: follow the alignment requirement for iomap_dio_hole_iter()") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master patch link: https://lore.kernel.org/all/73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.git.wqu@suse.com/
patch subject: [PATCH v4] iomap: follow the alignment requirement for iomap_dio_hole_iter()

[test failed on linux-next/master 20a33c6b6cbe7e4805dfb6cd68816937443aa148]

in testcase: xfstests
version: xfstests-x86_64-22348afe-1_20261019
with following parameters:

	disk: 4HDD
	fs: ext4
	test: generic-group-09


config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake) with 28G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202610261048.3dc64aea-lkp@intel.com


2026-10-24 23:20:06 cd /lkp/benchmarks/xfstests
2026-10-24 23:20:07 export TEST_DIR=/fs/sda1
2026-10-24 23:20:07 export TEST_DEV=/dev/sda1
2026-10-24 23:20:07 export FSTYP=ext4
2026-10-24 23:20:07 export SCRATCH_MNT=/fs/scratch
2026-10-24 23:20:07 mkdir /fs/scratch -p
2026-10-24 23:20:07 export SCRATCH_DEV=/dev/sda4
2026-10-24 23:20:07 sed "s:^:generic/:" /lkp/benchmarks/xfstests/tests/generic-group-09
2026-10-24 23:20:07 ./check -E tests/exclude/ext4 generic/091 generic/092 generic/093 generic/094 generic/095 generic/096 generic/097 generic/098
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 lkp-skl-d01 7.3.0-rc2+ #1 SMP PREEMPT Sat Oct 24 20:47:23 CST 2026
MKFS_OPTIONS  -- -F /dev/sda4
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda4 /fs/scratch

generic/091        [failed, exit status 1]- output mismatch (see /lkp/benchmarks/xfstests/results//generic/091.out.bad)
    --- tests/generic/091.out	2026-10-19 16:30:12.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//generic/091.out.bad	2026-10-24 23:20:20.173485972 +0000
    @@ -1,7 +1,25 @@
     QA output created by 091
     fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/091.out /lkp/benchmarks/xfstests/results//generic/091.out.bad'  to see the entire diff)
generic/092         1s
generic/093         1s
generic/094         14s
generic/095         51s
generic/096         1s
generic/097         2s
generic/098         11s
Ran: generic/091 generic/092 generic/093 generic/094 generic/095 generic/096 generic/097 generic/098
Failures: generic/091
Failed 1 of 8 tests


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261026/202610261048.3dc64aea-lkp@intel.com


--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

