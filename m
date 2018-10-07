Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:40705 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbeJHFLn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Oct 2018 01:11:43 -0400
Date: Mon, 8 Oct 2018 09:02:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/8] xfs: remove magic handling of unwritten extents in
 xfs_bmapi_allocate
Message-ID: <20181007220258.GC18095@dastard>
References: <20181002174207.25275-1-hch@lst.de>
 <20181002174207.25275-4-hch@lst.de>
 <20181006093433.GA18095@dastard>
 <20181006094331.GA5845@lst.de>
 <20181007101319.GA25721@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181007101319.GA25721@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 07, 2018 at 12:13:19PM +0200, Christoph Hellwig wrote:
> On Sat, Oct 06, 2018 at 11:43:31AM +0200, Christoph Hellwig wrote:
> > I suspect the asserts actually are what is incorrect.  But given
> > how late we are in the cycle I've just dropped the patch and kicked
> > off xfstests runs (now including rmap, sigh..).
> 
> Without this patch test runs including rmap succeed.  Do you want
> me to resend with the patch dropped (thing should just apply without
> it as-is).

I'll drop it and see what happens...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
