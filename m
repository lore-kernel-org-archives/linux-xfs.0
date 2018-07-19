Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34186 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731732AbeGSUHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 16:07:19 -0400
Date: Thu, 19 Jul 2018 12:22:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/8] xfs: trivial xfs_btree_del_cursor cleanups
Message-ID: <20180719192230.GM4813@magnolia>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192905163.31685.17441257298247003323.stgit@magnolia>
 <20180719164353.GF10151@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719164353.GF10151@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 09:43:53AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 18, 2018 at 08:50:51AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The error argument to xfs_btree_del_cursor already understands the
> > "nonzero for error" semantics, so remove pointless error testing in the
> > callers and pass it directly.
> 
> Looks fine, but we should also get rid of the XFS_BTREE_ERROR and
> XFS_BTREE_NOERROR defines as mixing them with errno values is going
> to be very confusing.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> (assuming we get another patch for the above eventually)

Eventually, yes.  The remaining usages are not so trivial to fix and
require more careful auditing.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
