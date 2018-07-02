Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752158AbeGBRku (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Jul 2018 13:40:50 -0400
Date: Mon, 2 Jul 2018 13:40:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 00/24] xfs: broad enablement of deferred agfl frees
Message-ID: <20180702174048.GD4775@bfoster>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180702145102.GA3831@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180702145102.GA3831@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 02, 2018 at 07:51:02AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 28, 2018 at 12:36:12PM -0400, Brian Foster wrote:
> > I think these issues can be mostly resolved by the end goal of a
> > combined xfs_trans/xfs_defer_ops structure. Boilerplate code that
> > allocates a transaction, inits a dfops, finishes a dfops and commits the
> > transaction can then reduce to allocating and committing the transaction
> > (where the former and latter respectively init/finish an internal
> > dfops). There are other patterns and issues to consider, however, so
> > that will be a matter for a subsequent patch series. (I'm actually
> > thinking of cleaning up all of the firstblock stuff as a next step in
> > that direction.)
> 
> Yes, I actually did a pass at firstblock a while ago when looking into
> the allocation reservation issues.  It cleaned things up a lot, but
> I ended up dropping it as it didn't actually end up helping to solve
> the problem directly.

I slapped a series together to deal with firstblock at the end of last
week and it survived testing over the weekend. It's basically a similar
sequence as this one, replacing the on-stack firstblock instances with a
->t_firstblock field in the transaction and ultimately eliminating the
need to pass it to xfs_defer_init(). I should be able to get it posted
soon now that this set has been reviewed. Thanks!

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
