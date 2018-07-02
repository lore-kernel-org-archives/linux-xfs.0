Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752576AbeGBRcy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Jul 2018 13:32:54 -0400
Date: Mon, 2 Jul 2018 13:32:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/24] xfs: remove dfops param from high level dirname
 calls
Message-ID: <20180702173252.GB4775@bfoster>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-5-bfoster@redhat.com>
 <20180702134506.GD19162@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180702134506.GD19162@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 02, 2018 at 06:45:06AM -0700, Christoph Hellwig wrote:
> > -	args->dfops = dfops;
> >  	args->total = total;
> >  	args->whichfork = XFS_DATA_FORK;
> >  	args->trans = tp;
> > +	ASSERT(tp->t_dfops || !first);
> 
> Nitpick:  I like to have calling convention asserts always at the
> beginning of the function to clearly see the assumed state on the first
> look.
> 

Ok, I'll fix that up.

Brian

> Otherwise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
