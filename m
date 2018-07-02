Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752970AbeGBRdH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Jul 2018 13:33:07 -0400
Date: Mon, 2 Jul 2018 13:33:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/24] xfs: use ->t_dfops for recovery of [b|c]ui log
 items
Message-ID: <20180702173304.GC4775@bfoster>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-6-bfoster@redhat.com>
 <20180702134550.GE19162@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180702134550.GE19162@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 02, 2018 at 06:45:50AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 28, 2018 at 12:36:17PM -0400, Brian Foster wrote:
> > Log recovery passes down a central dfops structure to recovery
> > handlers for bui and cui log items. Each of these handlers allocates
> > and commits a transaction and defers any remaining operations to be
> > completed by the main recovery sequence.
> > 
> > Since dfops outlives the transaction in this context, set and clear
> > ->t_dfops appropriately such that the *_finish_item() paths and
> > below (i.e., xfs_bmapi*()) can expect to find the dfops in the
> > transaction without it being committed with the dfops attached. This
> > is required because transaction commit expects that an associated
> > dfops is finished and in this context the dfops may be populated at
> > commit time.
> 
> Do we want comments explaining this in the code?
> 

Yeah, I think I meant to do that and just lost track. Thanks.

Brian

> Otherwise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
