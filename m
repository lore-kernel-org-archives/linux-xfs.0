Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44672 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbeKLCTB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 11 Nov 2018 21:19:01 -0500
Date: Sun, 11 Nov 2018 17:30:01 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] xfs: introduce an always_cow mode
Message-ID: <20181111163001.GA3331@lst.de>
References: <20181110115104.30293-1-hch@lst.de> <20181110115104.30293-4-hch@lst.de> <20181110174752.GA4235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181110174752.GA4235@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Sat, Nov 10, 2018 at 09:47:52AM -0800, Darrick J. Wong wrote:
> >  	xfs_ilock(ip, iolock);
> > +	if (xfs_is_always_cow_inode(ip) && mode != FALLOC_FL_PUNCH_HOLE) {
> > +		error = -EOPNOTSUPP;
> > +		goto out_unlock;
> 
> It's the weekend, so I'm only doing a quick scan of patches:
> 
> Why can't we support collapse range, insert range, zero range, or
> unshare in always_cow mode?

Yes, this a little agressive.  I think we should be fine just
skipping modes zero and keep size (ugg, the fallocate flags
scheme is horrible..).  I'll do that for the next version.
