Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA26332EBD;
	Sat, 25 Jul 2026 19:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785007427; cv=none; b=itWj2pei4VPP1tIP4DCNgAKHUhsuuoX6aGvf3QAM3bNDtmXZbNe0q8pETgE2eBl5utNcWmdM0YSNpBJBjO1qwL4hBUpYQkGxSFYXWkP75dYV5ZwQjsbbYS/eRIRO0vOfvI/5hSfbbkG6cFncq3bIgEUqtKfIHPfktzAUe1eZzD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785007427; c=relaxed/simple;
	bh=jVg+L2Exyf4K4F6Gf2i3SjiVAQ4iYbUyeTmPcEkO1YM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=tsC6sFm979lr+cUTlx69KjgFqad8/Dhh/HBVP+8rfNr8KYCLUOfMUT7gFz27sR3pfwBPNZExpqhrNMc2V4CTHu7TO7f6dng0CR0cUOkqRDuvsnCG1NEbsU7gqogbv0Am45wrF7ucwUG9sm3KMt1kJJXS2yphTH6NeyLTTyth/E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eW9hwrQ9; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eW9hwrQ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785007426; x=1816543426;
  h=date:from:to:cc:subject:message-id;
  bh=jVg+L2Exyf4K4F6Gf2i3SjiVAQ4iYbUyeTmPcEkO1YM=;
  b=eW9hwrQ91gMGcgnvjIphaF4I1TA5W4zQpCjyFZxjA60D+l9BvqVarFcc
   FH6ScOgMeLoYXdN9IJCHZg2nbH8LKaHWD8a27u52QyMsoHYTl7LEfHtTw
   vMDrRHiKGbXhplbubH5vbygClpVoBSrCpU4LpBXgc5AulYO2qEQuBJNjk
   jtm18IaUQ7bsCno/B0/mMlm0aJh0bgiLXkeFlW2dir6+uufHlbaEjGoDW
   tZT5K9EzmdRd5IOnJNR3MVGXgbgJ/5s9MNVvEAjhFFv5hBAs65uykSc9v
   i0j3Wt/EZ5MU1WbDnPyP45sJ+qc2cZvAOO7hy6BrgpVk3MqUvuq3RFWrw
   Q==;
X-CSE-ConnectionGUID: F/9rJmEiTOq++FHCSnqQQw==
X-CSE-MsgGUID: 5x8USorRSpC0cMNHTGc3LQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11856"; a="97151585"
X-IronPort-AV: E=Sophos;i="6.25,185,1779174000"; 
   d="scan'208";a="97151585"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 12:23:45 -0700
X-CSE-ConnectionGUID: GVhADuxjT2KVmxX9FvsHxQ==
X-CSE-MsgGUID: VoxEGVhSSMGW3Jyvys9FwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,185,1779174000"; 
   d="scan'208";a="297242565"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 25 Jul 2026 12:23:43 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnhxn-00000000c1u-03lw;
	Sat, 25 Jul 2026 19:23:32 +0000
Date: Sun, 26 Jul 2026 03:22:35 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH WARNING
 9eebf259d5352b87080d67758f483583d9e763d7
Message-ID: <202607260311.Mnd1CzmA-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 9eebf259d5352b87080d67758f483583d9e763d7  Add linux-next specific files for 20260723

Warning (recently discovered and may have been fixed):

    Warning: drivers/gpu/drm/panthor/panthor_fw.c:143 Excess struct member 'end' description in 'panthor_fw_binary_section_entry_hdr' (did you mean one of: 'va.end', 'data.end')
    Warning: drivers/gpu/drm/panthor/panthor_fw.c:143 Excess struct member 'start' description in 'panthor_fw_binary_section_entry_hdr' (did you mean one of: 'va.start', 'data.start')
    Warning: drivers/gpu/drm/panthor/panthor_fw.c:200 Excess struct member 'buf' description in 'panthor_fw_section' (did you mean one of: 'data.buf')
    Warning: drivers/gpu/drm/panthor/panthor_fw.c:200 Excess struct member 'size' description in 'panthor_fw_section' (did you mean one of: 'data.size')
    Warning: drivers/gpu/drm/panthor/panthor_fw.c:273 Excess struct member 'ping_work' description in 'panthor_fw' (did you mean one of: 'watchdog.ping_work')
    Warning: drivers/gpu/drm/panthor/panthor_mmu.c:405 Excess struct member 'kernel_auto_va.size' description in 'panthor_vm' (did you mean one of: 'kernel_auto_va.end', 'kernel_auto_va', 'kernel_auto_va.start')
    Warning: drivers/mtd/nand/raw/omap2.c:671 Excess function parameter 'ecc_data2' description in 'omap_compare_ecc' (did you mean one of: 'ecc_data1', 'page_data')
    Warning: drivers/phy/apple/atc.c:631 Excess struct member 'sw' description in 'apple_atcphy' (did you mean one of: 'swap_lanes')
    Warning: drivers/tee/qcomtee/async.c:107 Excess function parameter 'msg' description in 'async_release' (did you mean one of: 'async_msg')
    Warning: drivers/tty/serial/mux.c:117 Excess function parameter 'ports' description in 'mux_set_mctrl' (did you mean one of: 'port')
    Warning: fs/inode.c:1300 Excess function parameter 'isnew' description in 'inode_insert5' (did you mean one of: 'inode')
    Warning: fs/inode.c:1303 Excess function parameter 'isnew' description in 'inode_insert5' (did you mean one of: 'inode')

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607260226.sVPNzyMU-lkp@intel.com

    fs/iomap/direct-io.c:939:36-37: WARNING opportunity for min()

Warning ids grouped by kconfigs:

recent_errors
|-- arc-allyesconfig
|   |-- Warning:drivers-gpu-drm-panthor-panthor_fw.c-Excess-struct-member-buf-description-in-panthor_fw_section-(
|   |-- Warning:drivers-gpu-drm-panthor-panthor_fw.c-Excess-struct-member-end-description-in-panthor_fw_binary_section_entry_hdr-(
|   |-- Warning:drivers-gpu-drm-panthor-panthor_fw.c-Excess-struct-member-ping_work-description-in-panthor_fw-(
|   |-- Warning:drivers-gpu-drm-panthor-panthor_fw.c-Excess-struct-member-size-description-in-panthor_fw_section-(
|   |-- Warning:drivers-gpu-drm-panthor-panthor_fw.c-Excess-struct-member-start-description-in-panthor_fw_binary_section_entry_hdr-(
|   |-- Warning:drivers-gpu-drm-panthor-panthor_mmu.c-Excess-struct-member-kernel_auto_va.size-description-in-panthor_vm-(
|   `-- Warning:drivers-phy-apple-atc.c-Excess-struct-member-sw-description-in-apple_atcphy-(
|-- csky-allmodconfig
|   |-- Warning:drivers-mtd-nand-raw-omap2.c-Excess-function-parameter-ecc_data2-description-in-omap_compare_ecc-(
|   `-- Warning:drivers-tee-qcomtee-async.c-Excess-function-parameter-msg-description-in-async_release-(
|-- i386-buildonly-randconfig-001-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- i386-buildonly-randconfig-002-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- i386-buildonly-randconfig-003-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- i386-buildonly-randconfig-004-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- i386-buildonly-randconfig-005-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- i386-buildonly-randconfig-006-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- i386-randconfig-r053-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- loongarch-defconfig
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- m68k-randconfig-r051-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- microblaze-randconfig-r053-20260725
|   `-- fs-iomap-direct-io.c:WARNING-opportunity-for-min()
|-- parisc-defconfig
|   `-- Warning:drivers-tty-serial-mux.c-Excess-function-parameter-ports-description-in-mux_set_mctrl-(
|-- sh-defconfig
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- sparc-randconfig-r052-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-001
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-001-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-002-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-003-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-004-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-005-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-006-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-randconfig-161
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-randconfig-161-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
`-- x86_64-randconfig-r054-20260724
    `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(

elapsed time: 3026m

configs tested: 117
configs skipped: 1

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    gcc-8.5.0
arc                  randconfig-001-20260725    gcc-11.5.0
arc                  randconfig-002-20260725    gcc-8.5.0
arm                  randconfig-001-20260725    gcc-8.5.0
arm                  randconfig-002-20260725    clang-21
arm                  randconfig-003-20260725    gcc-10.5.0
arm                  randconfig-004-20260725    gcc-15.2.0
arm64                randconfig-001-20260725    clang-24
arm64                randconfig-002-20260725    gcc-13.4.0
arm64                randconfig-003-20260725    clang-24
arm64                randconfig-004-20260725    clang-24
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260725    gcc-9.5.0
csky                 randconfig-002-20260725    gcc-16.1.0
hexagon                       randconfig-001    clang-17
hexagon              randconfig-001-20260725    clang-17
hexagon              randconfig-002-20260725    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260724    clang-22
i386       buildonly-randconfig-001-20260725    clang-22
i386       buildonly-randconfig-002-20260724    gcc-14
i386       buildonly-randconfig-002-20260725    gcc-14
i386       buildonly-randconfig-003-20260724    gcc-14
i386       buildonly-randconfig-003-20260725    clang-22
i386       buildonly-randconfig-004-20260724    gcc-13
i386       buildonly-randconfig-004-20260725    clang-22
i386       buildonly-randconfig-005-20260724    clang-22
i386       buildonly-randconfig-005-20260725    gcc-14
i386       buildonly-randconfig-006-20260724    clang-22
i386       buildonly-randconfig-006-20260725    gcc-14
i386                          randconfig-001    clang-22
i386                 randconfig-001-20260725    clang-22
i386                 randconfig-002-20260725    gcc-14
i386                 randconfig-003-20260725    gcc-14
i386                 randconfig-004-20260725    gcc-12
i386                 randconfig-005-20260725    clang-22
i386                 randconfig-006-20260725    gcc-14
i386                 randconfig-007-20260725    gcc-14
i386                 randconfig-011-20260725    gcc-14
i386                 randconfig-012-20260725    gcc-14
i386                 randconfig-013-20260725    gcc-14
i386                 randconfig-014-20260725    clang-22
i386                 randconfig-015-20260725    clang-22
i386                 randconfig-016-20260725    clang-22
i386                 randconfig-017-20260725    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260725    gcc-16.1.0
loongarch            randconfig-002-20260725    gcc-13.4.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260725    gcc-11.5.0
nios2                randconfig-002-20260725    gcc-9.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260725    gcc-10.5.0
parisc               randconfig-002-20260725    gcc-12.5.0
powerpc              randconfig-001-20260725    gcc-9.5.0
powerpc              randconfig-002-20260725    gcc-15.2.0
powerpc64            randconfig-001-20260725    clang-17
powerpc64            randconfig-002-20260725    clang-24
riscv                randconfig-001-20260725    gcc-8.5.0
riscv                randconfig-002-20260725    gcc-8.5.0
s390                 randconfig-001-20260725    gcc-10.5.0
s390                 randconfig-002-20260725    gcc-16.1.0
sh                                 defconfig    gcc-16.1.0
sh                       edosk7760_defconfig    gcc-16.1.0
sh                   randconfig-001-20260725    gcc-16.1.0
sh                   randconfig-002-20260725    gcc-11.5.0
sparc                randconfig-001-20260725    gcc-16.1.0
sparc                randconfig-002-20260725    gcc-8.5.0
sparc64              randconfig-001-20260725    gcc-8.5.0
sparc64              randconfig-002-20260725    gcc-10.5.0
um                   randconfig-001-20260725    gcc-14
um                   randconfig-002-20260725    clang-24
x86_64              buildonly-randconfig-001    gcc-12
x86_64     buildonly-randconfig-001-20260724    clang-22
x86_64     buildonly-randconfig-001-20260725    clang-22
x86_64     buildonly-randconfig-002-20260724    clang-22
x86_64     buildonly-randconfig-002-20260725    clang-22
x86_64     buildonly-randconfig-003-20260724    gcc-14
x86_64     buildonly-randconfig-003-20260725    clang-22
x86_64     buildonly-randconfig-004-20260724    clang-22
x86_64     buildonly-randconfig-004-20260725    gcc-12
x86_64     buildonly-randconfig-005-20260724    clang-22
x86_64     buildonly-randconfig-005-20260725    gcc-12
x86_64     buildonly-randconfig-006-20260724    clang-22
x86_64     buildonly-randconfig-006-20260725    gcc-14
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260725    gcc-14
x86_64               randconfig-002-20260725    clang-22
x86_64               randconfig-003-20260725    clang-22
x86_64               randconfig-004-20260725    clang-22
x86_64               randconfig-005-20260725    clang-22
x86_64               randconfig-006-20260725    clang-22
x86_64                        randconfig-011    gcc-14
x86_64               randconfig-011-20260725    gcc-14
x86_64               randconfig-012-20260725    gcc-14
x86_64               randconfig-013-20260725    gcc-14
x86_64               randconfig-014-20260725    gcc-14
x86_64               randconfig-015-20260725    gcc-14
x86_64               randconfig-016-20260725    gcc-14
x86_64               randconfig-071-20260725    gcc-14
x86_64               randconfig-072-20260725    gcc-14
x86_64               randconfig-073-20260725    gcc-14
x86_64               randconfig-074-20260725    gcc-14
x86_64               randconfig-075-20260725    gcc-14
x86_64               randconfig-076-20260725    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260725    gcc-16.1.0
xtensa               randconfig-002-20260725    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
