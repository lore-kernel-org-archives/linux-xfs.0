Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40302 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753282AbdLFC1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Dec 2017 21:27:16 -0500
Date: Tue, 5 Dec 2017 18:27:13 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 00/73] XArray version 4
Message-ID: <20171206022713.GN26021@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206014536.GA4094@dastard>
 <20171206015108.GB4094@dastard>
 <MWHPR21MB0845A83B9E89E4A9499AEC2FCB320@MWHPR21MB0845.namprd21.prod.outlook.com>
 <20171206021752.GC4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206021752.GC4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, Dec 06, 2017 at 01:17:52PM +1100, Dave Chinner wrote:
> On Wed, Dec 06, 2017 at 01:53:41AM +0000, Matthew Wilcox wrote:
> > Huh, you've caught a couple of problems that 0day hasn't sent me yet.  Try turning on DAX or TRANSPARENT_HUGEPAGE.  Thanks!
> 
> Dax is turned on, CONFIG_TRANSPARENT_HUGEPAGE is not.
> 
> Looks like nothing is setting CONFIG_RADIX_TREE_MULTIORDER, which is
> what xas_set_order() is hidden under.
> 
> Ah, CONFIG_ZONE_DEVICE turns it on, not CONFIG_DAX/CONFIG_FS_DAX.
> 
> Hmmmm.  That seems wrong if it's used in fs/dax.c...

Yes, it's my mistake for not making xas_set_order available in the
!MULTIORDER case.  I'm working on a fix now.

> What a godawful mess Kconfig has turned into.

I'm not going to argue with that ...
