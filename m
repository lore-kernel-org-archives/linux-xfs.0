Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932954AbeGCPK2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 11:10:28 -0400
Date: Tue, 3 Jul 2018 11:10:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/24] xfs: cow unwritten conversion uses uninitialized
 dfops
Message-ID: <20180703151025.GD22789@bfoster>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-2-bfoster@redhat.com>
 <20180702134304.GA19162@infradead.org>
 <20180702173241.GA4775@bfoster>
 <20180703145938.GS5711@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703145938.GS5711@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 07:59:38AM -0700, Darrick J. Wong wrote:
> On Mon, Jul 02, 2018 at 01:32:41PM -0400, Brian Foster wrote:
> > On Mon, Jul 02, 2018 at 06:43:04AM -0700, Christoph Hellwig wrote:
> > > On Thu, Jun 28, 2018 at 12:36:13PM -0400, Brian Foster wrote:
> > > > A couple COW fork unwritten extent conversion helpers pass an
> > > > uninitialized dfops pointer to xfs_bmapi_write(). This does not
> > > > cause problems because conversion does not use a transaction or the
> > > > dfops structure for the COW fork.  Drop the uninitialized usage of
> > > > dfops in these codepaths and pass NULL along to xfs_bmapi_write()
> > > > instead.
> > > 
> > > Looks good.
> > > 
> > > Is this something we should maybe queue up for 4.18?
> > > 
> > 
> > That might make sense because of all the refactoring, but otherwise I
> > don't have a strong opinion. Let's see what Darrick wants to do...
> 
> AFAICT this only eliminates the passing around of an unus{ed,able} dfops
> parameter, right?  We're not fixing a regression or some other breakage,
> just eliminating cpu cycle waste, so I think this can soak (along with
> everything else) until 4.19.
> 

Works for me. This does have the side effect of enabling the deferred
AGFL block free behavior wherever dfops is used, but that is a not a
critical change/fix. The problem that inspired the behavior in the first
place was resolved by the more targeted changes in the first series.
The goals of this (and the series or two to follow) are primarily follow
up refactoring and to provide more consistent behavior fs-wide.

Brian

> --D
> 
> > Brian
> > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
