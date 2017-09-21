Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50224 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbdIUNgM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 09:36:12 -0400
Date: Thu, 21 Sep 2017 15:36:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: rewrite getbmap using the xfs_iext_* helpers
Message-ID: <20170921133610.GD13541@lst.de>
References: <20170918152630.24592-1-hch@lst.de> <20170918152630.24592-2-hch@lst.de> <20170920230036.GB7112@magnolia> <20170920230824.GC7112@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920230824.GC7112@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Sep 20, 2017 at 04:08:24PM -0700, Darrick J. Wong wrote:
> > I'm still wondering why we allocate a potentially large getbmapx buffer,
> > fill it out, and only then format the results to userspace?  I think
> > getbmap (the ioctl) is now the only user of these functions, so can't
> > we just call the formatter directly from _getbmap_report_one and
> > _getbmap_report_hole, like what getfsmap does?
> > 
> > (I also feel like I've asked this before, so apologies if I'm merely
> > forgetting the answer.)
> 
> Oh right, it's because we have the inode locked, and copying things to
> userspace could incur a page fault, which we can't risk with the inode
> locked because some malicious person could create a fragmented file with
> a bmap request header at the start of the file, mmap the file, and call
> bmap on the fragmented file with the pointer being the mmap region.

Yes.

Can I get a Reviewed-by: tag now? :)
