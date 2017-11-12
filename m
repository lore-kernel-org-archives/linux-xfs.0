Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37482 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752276AbdKLBUd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 11 Nov 2017 20:20:33 -0500
Date: Sun, 12 Nov 2017 09:20:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [kbuild-all] [xfs-linux:xfs-4.15-merge 102/131] {standard
 input}:1233: Error: displacement to undefined symbol .L331 overflows 12-bit
 field
Message-ID: <20171112012030.c7whsttfstvfcm7e@wfg-t540p.sh.intel.com>
References: <201711120808.bRgNYGgz%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <201711120808.bRgNYGgz%fengguang.wu@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, kbuild-all@01.org, "Darrick J. Wong" <darrick.wong@oracle.com>

I'll blacklist this error pattern for sh4 builds. Sorry for the noise!

On Sun, Nov 12, 2017 at 08:50:10AM +0800, kbuild test robot wrote:
>Hi Christoph,
>
>FYI, the error/warning still remains.
>
>tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-4.15-merge
>head:   2d1d1da3d9cc387262193e83f0a96d753b040720
>commit: 43518812d297179ae1e432d5cd640ec168596283 [102/131] xfs: remove support for inlining data/extents into the inode fork
>config: sh-titan_defconfig (attached as .config)
>compiler: sh4-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
>reproduce:
>        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>        chmod +x ~/bin/make.cross
>        git checkout 43518812d297179ae1e432d5cd640ec168596283
>        # save the attached .config to linux build tree
>        make.cross ARCH=sh
>
>All errors (new ones prefixed by >>):
>
>   fs/xfs/xfs_ioctl.c: In function 'xfs_ioc_getbmap.isra.9':
>   fs/xfs/xfs_ioctl.c:1629:1: internal compiler error: in change_address_1, at emit-rtl.c:2150
>    }
>    ^
>   Please submit a full bug report,
>   with preprocessed source if appropriate.
>   See <file:///usr/share/doc/gcc-7/README.Bugs> for instructions.
>   {standard input}: Assembler messages:
>   {standard input}: Warning: end of file not at end of a line; newline inserted
>   {standard input}:1415: Error: missing operand
>   {standard input}:1415: Error: invalid operands for opcode
>>> {standard input}:1233: Error: displacement to undefined symbol .L331 overflows 12-bit field
>   {standard input}:1260: Error: displacement to undefined symbol .L361 overflows 12-bit field
>   {standard input}:1274: Error: displacement to undefined symbol .L333 overflows 12-bit field
>   {standard input}:1285: Error: displacement to undefined symbol .L362 overflows 12-bit field
>--
>   fs//xfs/xfs_ioctl.c: In function 'xfs_ioc_getbmap.isra.9':
>   fs//xfs/xfs_ioctl.c:1629:1: internal compiler error: in change_address_1, at emit-rtl.c:2150
>    }
>    ^
>   Please submit a full bug report,
>   with preprocessed source if appropriate.
>   See <file:///usr/share/doc/gcc-7/README.Bugs> for instructions.
>   {standard input}: Assembler messages:
>   {standard input}: Warning: end of file not at end of a line; newline inserted
>   {standard input}:1415: Error: missing operand
>   {standard input}:1415: Error: invalid operands for opcode
>>> {standard input}:1233: Error: displacement to undefined symbol .L331 overflows 12-bit field
>   {standard input}:1260: Error: displacement to undefined symbol .L361 overflows 12-bit field
>   {standard input}:1274: Error: displacement to undefined symbol .L333 overflows 12-bit field
>   {standard input}:1285: Error: displacement to undefined symbol .L362 overflows 12-bit field
>
>---
>0-DAY kernel test infrastructure                Open Source Technology Center
>https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


>_______________________________________________
>kbuild-all mailing list
>kbuild-all@lists.01.org
>https://lists.01.org/mailman/listinfo/kbuild-all

