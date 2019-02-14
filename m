Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53458 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404853AbfBNVjn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Feb 2019 16:39:43 -0500
Date: Thu, 14 Feb 2019 22:39:40 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] xfs: move transaction handling to
 xfs_bmapi_convert_delalloc
Message-ID: <20190214213940.GA11780@lst.de>
References: <20190211125427.16577-1-hch@lst.de> <20190211125427.16577-7-hch@lst.de> <20190214193816.GK32253@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190214193816.GK32253@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Thu, Feb 14, 2019 at 11:38:16AM -0800, Darrick J. Wong wrote:
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> 
> Aha, this is the problem -- this operation involves deferred rmap
> updates, which means that we have to retain the ILOCK until we've
> finished processing the rmap updates so that another thread cannot jump
> in and start modifying the file's bmap while we're still trying to
> finish the rmap updates.

Hmm, if our automatic unlock doesn't work with deferred operations
we should probably just get rid of that mechanism entirely, as it is
highly unsafe..

> 
> The patch below fixes generic/127 for me, for this configuration:
> 
> FSTYP=xfs
> MKFS_OPTIONS="-m reflink=1,rmapbt=1 -i sparse=1"
> MOUNT_OPTIONS="-o usrquota,grpquota,prjquota"

I didn't have -i sparc in my test config, but I doubt it makes
difference.  Let me check if I could reproduce the original issue
with it.
