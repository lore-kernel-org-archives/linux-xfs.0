Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750855AbdAPTE6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 14:04:58 -0500
Date: Mon, 16 Jan 2017 14:04:57 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 3/5] xfs: reuse iomap delalloc code for COW fork
 reservation
Message-ID: <20170116190456.GD6302@bfoster.bfoster>
References: <1484157249-464-1-git-send-email-bfoster@redhat.com>
 <1484157249-464-4-git-send-email-bfoster@redhat.com>
 <20170113171312.GB27605@infradead.org>
 <20170116162601.GB6302@bfoster.bfoster>
 <20170116173730.GA11796@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170116173730.GA11796@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 16, 2017 at 09:37:30AM -0800, Christoph Hellwig wrote:
> On Mon, Jan 16, 2017 at 11:26:01AM -0500, Brian Foster wrote:
> > IMO, patches 1-3 stand on their own as cleanup/refactor patches,
> > regardless of whether we want the actual speculative preallocation patch
> > (in current form or at all). xfs_reflink_reserve_cow() is mostly a
> > copy&paste of _iomap_begin_delay() operating on the cow fork rather than
> > the data fork, so technically we really shouldn't have a need for a
> > feature specific helper. Duplication aside, I also find the code a bit
> > confusing to follow in that we have to traverse through several
> > functions in "do nothing" cases such as non-shared blocks of a reflinked
> > file.
> 
> I'm usually not a fan of refactor patches that adds lots of new code
> without adding functionality.  In terms of readability I'm obviously
> biasses having written a lot of the code, but I find the new code
> much harder to read.

Ok, we disagree on whether the refactoring stands on its own. I'm not
quite sure which part you dislike (note that the iomap_search_extents()
part was based on your suggestion from the rfc). Either way, this series
does add functionality too. :)

I'm not that concerned with getting the refactor in by itself if there
is disagreement. I just didn't want to continue to have two delalloc
write paths that differ only by the target fork (and with this series,
initial prealloc size). So, any thoughts on the mechanism itself, or how
you'd envision it look if not as implemented here?

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
