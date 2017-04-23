Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51939 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162749AbdDWRkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Apr 2017 13:40:10 -0400
Date: Sun, 23 Apr 2017 10:39:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: strengthen log intent item refcount checking
Message-ID: <20170423173911.GN23371@birch.djwong.org>
References: <20170421200043.GL23371@birch.djwong.org>
 <20170423082315.GA21577@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170423082315.GA21577@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>

On Sun, Apr 23, 2017 at 01:23:15AM -0700, Christoph Hellwig wrote:
> On Fri, Apr 21, 2017 at 01:00:43PM -0700, Darrick J. Wong wrote:
> > Use ASSERTs on the log intent item refcounts so that we fail noisily if
> > anyone tries to double-free the item.  This will help us diagnose
> > potential problems with the deferred-ops mechanism via generic/388.
> 
> Any specific problems you're looking at?

Not at the moment -- this was a debug patch I'd written up the last
there were refcounting problems with xfs_defer, and the refcount_t
discussions prompted me to send this in as a stopgap until we figure
out what we're doing w.r.t. refcount_t.

--D

> 
> Otherwise looks fine to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
