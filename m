Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43694 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfHNLBz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 07:01:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id y8so4723455wrn.10
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2019 04:01:54 -0700 (PDT)
Date: Wed, 14 Aug 2019 13:01:50 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190814110148.kbp6tplxibrnfpej@pegasus.maiolino.io>
References: <20190808082744.31405-5-cmaiolino@redhat.com>
 <201908090430.yoyXYjeY%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201908090430.yoyXYjeY%lkp@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

Hey folks,

> All errors (new ones prefixed by >>):
> 
>    fs/ioctl.c: In function 'ioctl_fibmap':
> >> fs/ioctl.c:68:10: error: implicit declaration of function 'bmap'; did you mean 'kmap'? [-Werror=implicit-function-declaration]

Any of you guys may have a better idea on how to fix this?

Essentially, this happens when CONFIG_BLOCK is not set, and although I don't
really see a hard requirement to have bmap() exported only when CONFIG_BLOCK is
set, at the same time, I don't see use for bmap() if CONFIG_BLOCK is not set.

So, I'm in a kind of a chicken-egg problem.

I am considering to just remove the #ifdef CONFIG_BLOCK / #endif from the bmap()
declaration. This will fix the warning, and I don't see any side effects. What
you guys think?


>      error = bmap(inode, &block);
>              ^~~~
>              kmap
>    cc1: some warnings being treated as errors
> 
> vim +68 fs/ioctl.c
> 
>     53	
>     54	static int ioctl_fibmap(struct file *filp, int __user *p)
>     55	{
>     56		struct inode *inode = file_inode(filp);
>     57		int error, ur_block;
>     58		sector_t block;
>     59	
>     60		if (!capable(CAP_SYS_RAWIO))
>     61			return -EPERM;
>     62	
>     63		error = get_user(ur_block, p);
>     64		if (error)
>     65			return error;
>     66	
>     67		block = ur_block;
>   > 68		error = bmap(inode, &block);
>     69	
>     70		if (error)
>     71			ur_block = 0;
>     72		else
>     73			ur_block = block;
>     74	
>     75		error = put_user(ur_block, p);
>     76	
>     77		return error;
>     78	}
>     79	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation



-- 
Carlos
