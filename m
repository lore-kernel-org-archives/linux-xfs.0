Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46995 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751986AbdDCTVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2017 15:21:19 -0400
Date: Mon, 3 Apr 2017 12:20:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix over-copying of getbmap parameters from
 userspace
Message-ID: <20170403192050.GQ4864@birch.djwong.org>
References: <20170403173430.GL4864@birch.djwong.org>
 <20170403173619.GM4864@birch.djwong.org>
 <20170403185702.GA28344@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403185702.GA28344@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Mon, Apr 03, 2017 at 11:57:02AM -0700, Christoph Hellwig wrote:
> > +	 * so using a straight memory copy should work fine.
> 
> I'd skip this half of the comment.

Will do.

> Otherwise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
