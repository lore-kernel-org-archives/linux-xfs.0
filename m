Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42102 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932218AbdJUSGs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Oct 2017 14:06:48 -0400
Date: Sat, 21 Oct 2017 11:06:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/15] xfs: inline xfs_shift_file_space into callers
Message-ID: <20171021180643.GB5483@magnolia>
References: <20171019065942.18813-1-hch@lst.de>
 <20171019065942.18813-9-hch@lst.de>
 <20171021000720.GB4755@magnolia>
 <20171021081314.GB21101@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171021081314.GB21101@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sat, Oct 21, 2017 at 10:13:14AM +0200, Christoph Hellwig wrote:
> > > +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> > 
> > So it took me a while of wondering "don't we have to have the
> > MMAPLOCK_EXCL too?" before realizing that yes, the caller actually does
> > grab that too.  I wonder if it's worth checking here, since you're
> > asserting the lock status at all?
> 
> This just moves the previous code around..  I can send an incremental
> patch if you want, though.

Sure, either resending this patch or tacking a new one on the end is
fine, I don't mind either way.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
