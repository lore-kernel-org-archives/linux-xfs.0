Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48793 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbeLSTac (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Dec 2018 14:30:32 -0500
Date: Wed, 19 Dec 2018 20:30:30 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/11] xfs: make COW fork unwritten extent conversions
 more robust
Message-ID: <20181219193030.GB28624@lst.de>
References: <20181203222503.30649-1-hch@lst.de> <20181203222503.30649-11-hch@lst.de> <20181218222211.GP27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218222211.GP27208@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

> >  	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
> >  	xfs_filblks_t		count_fsb = end_fsb - offset_fsb;
> > -	struct xfs_bmbt_irec	imap;
> > -	int			nimaps = 1, error = 0;
> > +	int			error;
> >  
> >  	ASSERT(count != 0);
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > -	error = xfs_bmapi_write(NULL, ip, offset_fsb, count_fsb,
> > -			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT |
> > -			XFS_BMAPI_CONVERT_ONLY, 0, &imap, &nimaps);
> > +	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
> 
> At this point you might as well convert the one remaining caller of
> xfs_reflink_convert_cow to take and drop the ILOCK around the
> reflink_convert_cow call...

I looked at it - the ilock is not the issue, but moving the bytes
to fsb conversion into the only caller makes it look worse than
keeping a helper for that one helper.
