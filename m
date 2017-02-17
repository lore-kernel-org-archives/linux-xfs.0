Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42486 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755495AbdBQMra (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Feb 2017 07:47:30 -0500
Date: Fri, 17 Feb 2017 13:47:28 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: simplify xfs_rtallocate_extent
Message-ID: <20170217124728.GE23739@lst.de>
References: <20170216212110.4370-1-hch@lst.de> <20170216212110.4370-2-hch@lst.de> <20170217010232.GI6813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170217010232.GI6813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Feb 16, 2017 at 05:02:32PM -0800, Darrick J. Wong wrote:
> >  	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
> >  	ASSERT(minlen > 0 && minlen <= maxlen);
> > -
> > +	
> 
> Inserted whitespace?

Yeah, fixed.

> > -	if (error)
> > -		return error;
> 
> We shouldn't be ignoring errors from xfs_rtallocate_extent_*, right?

No, we shouldn't.  I'll add the check back.
