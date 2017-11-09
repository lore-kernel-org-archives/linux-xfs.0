Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19432 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754802AbdKIXfU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 18:35:20 -0500
Date: Fri, 10 Nov 2017 10:26:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-linux:xfs-4.15-merge 2/122] {standard input}:1409: Error:
 displacement to undefined symbol .L256 overflows 12-bit field
Message-ID: <20171109232659.GS4094@dastard>
References: <201711100501.PXAZAvHq%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201711100501.PXAZAvHq%fengguang.wu@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, kbuild-all@01.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>

On Fri, Nov 10, 2017 at 05:31:07AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-4.15-merge
> head:   478f8da0f7c95f847a02f8e3b808926c894e3830
> commit: 232b51948b99dfcc95e81d8a289bc0409b3ff5b3 [2/122] xfs: simplify the xfs_getbmap interface
> config: sh-sdk7786_defconfig (attached as .config)
> compiler: sh4-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 232b51948b99dfcc95e81d8a289bc0409b3ff5b3
>         # save the attached .config to linux build tree
>         make.cross ARCH=sh 
> 
> All errors (new ones prefixed by >>):
> 
>    fs/xfs/xfs_ioctl.c: In function 'xfs_ioc_getbmap':
>    fs/xfs/xfs_ioctl.c:1624:1: internal compiler error: in change_address_1, at emit-rtl.c:2150
>     }
>     ^
>    Please submit a full bug report,
>    with preprocessed source if appropriate.
>    See <file:///usr/share/doc/gcc-7/README.Bugs> for instructions.

Compiler issue. Please redirect these to the gcc developers.

Cheers,

Dave.



-- 
Dave Chinner
david@fromorbit.com
