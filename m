Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37109 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727507AbfHNLJD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Aug 2019 07:09:03 -0400
Date: Wed, 14 Aug 2019 13:08:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190814110859.GA1885@lst.de>
References: <20190808082744.31405-5-cmaiolino@redhat.com> <201908090430.yoyXYjeY%lkp@intel.com> <20190814110148.kbp6tplxibrnfpej@pegasus.maiolino.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814110148.kbp6tplxibrnfpej@pegasus.maiolino.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

On Wed, Aug 14, 2019 at 01:01:50PM +0200, Carlos Maiolino wrote:
> Hey folks,
> 
> > All errors (new ones prefixed by >>):
> > 
> >    fs/ioctl.c: In function 'ioctl_fibmap':
> > >> fs/ioctl.c:68:10: error: implicit declaration of function 'bmap'; did you mean 'kmap'? [-Werror=implicit-function-declaration]
> 
> Any of you guys may have a better idea on how to fix this?
> 
> Essentially, this happens when CONFIG_BLOCK is not set, and although I don't
> really see a hard requirement to have bmap() exported only when CONFIG_BLOCK is
> set, at the same time, I don't see use for bmap() if CONFIG_BLOCK is not set.
> 
> So, I'm in a kind of a chicken-egg problem.
> 
> I am considering to just remove the #ifdef CONFIG_BLOCK / #endif from the bmap()
> declaration. This will fix the warning, and I don't see any side effects. What
> you guys think?

Just provide an inline !CONFIG_BLOCK stub for bmap() in fs.h that always
returns -EINVAL.
