Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733241AbfETLiQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 07:38:16 -0400
Date: Mon, 20 May 2019 07:38:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/20] xfs: split iop_unlock
Message-ID: <20190520113811.GA31317@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-8-hch@lst.de>
 <20190517174915.GG7888@bfoster>
 <20190520061043.GG31977@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520061043.GG31977@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 08:10:43AM +0200, Christoph Hellwig wrote:
> On Fri, May 17, 2019 at 01:49:16PM -0400, Brian Foster wrote:
> > Refactoring aside, I see that the majority of this patch is focused on
> > intent log item implementations. I don't think an item leak is possible
> > here because we intentionally dirty transactions when either an intent
> > or done item is logged. See xfs_extent_free_log_item() and
> > xfs_trans_free_extent() for examples associated with the EFI/EFD items.
> 
> That's why I said theoretical.
> 

The current commit log says it's either rare or doesn't occur in
practice, which leaves the question open. I'm pointing out that for the
codepaths affected by this patch, I don't think it can occur.

I agree that it's still a theoretical possibility based on the current
log item interface and intent item implementations...

> > On one hand this logic supports the current item reference counting
> > logic (for example, so we know whether to drop the log's reference to an
> > EFI on transaction abort or wait until physical log commit time). On the
> > other hand, the items themselves must be logged to disk so we have to
> > mark them dirty (along with the transaction on behalf of the item) for
> > that reason as well. FWIW, I do think the current approach of adding the
> > intent item and dirtying it separately is slightly confusing,
> > particularly since I'm not sure we have any valid use case to have a
> > clean intent/done item in a transaction.
> 
> Indeed.  I think there is plenty of opportunity for futher wok here.
> 
> > I suppose this kind of refactoring might still make sense on its own if
> > the resulting code is more clear or streamlined. I.e., perhaps there's
> > no need for the separate ->iop_committing() and ->iop_unlock() callbacks
> > invoked one after the other. That said, I think the commit log should
> > probably be updated to focus on that (unless I'm missing something about
> > the potential leak). Hm?
> 
> The streamlining was the the point.  I just noticed that if we were
> every to about a clean intent item we'd leak it while doing that.

Ok, then I'd just suggest to update the commit log. I guess it's easier
for me to just suggest one, so for example (feel free to use, modify or
replace):

---

iop_unlock() is called when comitting or cancelling a transaction. In
the latter case, the transaction may or may not be aborted. While there
is no known problem with the current code in practice, this
implementation is limited in that any log item implementation that might
want to differentiate between a commit and a cancel must rely on the
aborted state. The aborted bit is only set when the cancelled
transaction is dirty, however. This means that there is no way to
distinguish between a commit and a clean transaction cancel.

For example, intent log items currently rely on this distinction. The
log item is either transferred to the CIL on commit or released on
transaction cancel. There is currently no possibility for a clean intent
log item in a transaction, but if that state is ever introduced a cancel
of such a transaction will immediately result in memory leaks of the
associated log item(s). This is an interface deficiency and landmine.

To clean this up, replace ->iop_unlock() with an ->iop_release()
callback that is specific to transaction cancel. The existing
->iop_committing() callback occurs at the same time as ->iop_unlock() in
the commit path and there is no need for two separate callbacks here.
Overload ->iop_committing() with the current commit time ->iop_unlock()
implementations to eliminate the need for the latter and further
simplify the interface.

---

I'll try to get through the rest of this series today..

Brian
