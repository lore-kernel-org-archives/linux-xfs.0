Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49882 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbfETGLE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 02:11:04 -0400
Date: Mon, 20 May 2019 08:10:43 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/20] xfs: split iop_unlock
Message-ID: <20190520061043.GG31977@lst.de>
References: <20190517073119.30178-1-hch@lst.de> <20190517073119.30178-8-hch@lst.de> <20190517174915.GG7888@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517174915.GG7888@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 01:49:16PM -0400, Brian Foster wrote:
> Refactoring aside, I see that the majority of this patch is focused on
> intent log item implementations. I don't think an item leak is possible
> here because we intentionally dirty transactions when either an intent
> or done item is logged. See xfs_extent_free_log_item() and
> xfs_trans_free_extent() for examples associated with the EFI/EFD items.

That's why I said theoretical.

> On one hand this logic supports the current item reference counting
> logic (for example, so we know whether to drop the log's reference to an
> EFI on transaction abort or wait until physical log commit time). On the
> other hand, the items themselves must be logged to disk so we have to
> mark them dirty (along with the transaction on behalf of the item) for
> that reason as well. FWIW, I do think the current approach of adding the
> intent item and dirtying it separately is slightly confusing,
> particularly since I'm not sure we have any valid use case to have a
> clean intent/done item in a transaction.

Indeed.  I think there is plenty of opportunity for futher wok here.

> I suppose this kind of refactoring might still make sense on its own if
> the resulting code is more clear or streamlined. I.e., perhaps there's
> no need for the separate ->iop_committing() and ->iop_unlock() callbacks
> invoked one after the other. That said, I think the commit log should
> probably be updated to focus on that (unless I'm missing something about
> the potential leak). Hm?

The streamlining was the the point.  I just noticed that if we were
every to about a clean intent item we'd leak it while doing that.
