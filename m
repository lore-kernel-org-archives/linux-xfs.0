Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33490 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752576AbeGBRcn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Jul 2018 13:32:43 -0400
Date: Mon, 2 Jul 2018 13:32:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/24] xfs: cow unwritten conversion uses uninitialized
 dfops
Message-ID: <20180702173241.GA4775@bfoster>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-2-bfoster@redhat.com>
 <20180702134304.GA19162@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180702134304.GA19162@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 02, 2018 at 06:43:04AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 28, 2018 at 12:36:13PM -0400, Brian Foster wrote:
> > A couple COW fork unwritten extent conversion helpers pass an
> > uninitialized dfops pointer to xfs_bmapi_write(). This does not
> > cause problems because conversion does not use a transaction or the
> > dfops structure for the COW fork.  Drop the uninitialized usage of
> > dfops in these codepaths and pass NULL along to xfs_bmapi_write()
> > instead.
> 
> Looks good.
> 
> Is this something we should maybe queue up for 4.18?
> 

That might make sense because of all the refactoring, but otherwise I
don't have a strong opinion. Let's see what Darrick wants to do...

Brian

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
