Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34472 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752508AbeGCPAI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 11:00:08 -0400
Date: Tue, 3 Jul 2018 07:59:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/24] xfs: cow unwritten conversion uses uninitialized
 dfops
Message-ID: <20180703145938.GS5711@magnolia>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-2-bfoster@redhat.com>
 <20180702134304.GA19162@infradead.org>
 <20180702173241.GA4775@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180702173241.GA4775@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Mon, Jul 02, 2018 at 01:32:41PM -0400, Brian Foster wrote:
> On Mon, Jul 02, 2018 at 06:43:04AM -0700, Christoph Hellwig wrote:
> > On Thu, Jun 28, 2018 at 12:36:13PM -0400, Brian Foster wrote:
> > > A couple COW fork unwritten extent conversion helpers pass an
> > > uninitialized dfops pointer to xfs_bmapi_write(). This does not
> > > cause problems because conversion does not use a transaction or the
> > > dfops structure for the COW fork.  Drop the uninitialized usage of
> > > dfops in these codepaths and pass NULL along to xfs_bmapi_write()
> > > instead.
> > 
> > Looks good.
> > 
> > Is this something we should maybe queue up for 4.18?
> > 
> 
> That might make sense because of all the refactoring, but otherwise I
> don't have a strong opinion. Let's see what Darrick wants to do...

AFAICT this only eliminates the passing around of an unus{ed,able} dfops
parameter, right?  We're not fixing a regression or some other breakage,
just eliminating cpu cycle waste, so I think this can soak (along with
everything else) until 4.19.

--D

> Brian
> 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
