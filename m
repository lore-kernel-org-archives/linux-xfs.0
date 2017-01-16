Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751242AbdAPQ0C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 11:26:02 -0500
Date: Mon, 16 Jan 2017 11:26:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 3/5] xfs: reuse iomap delalloc code for COW fork
 reservation
Message-ID: <20170116162601.GB6302@bfoster.bfoster>
References: <1484157249-464-1-git-send-email-bfoster@redhat.com>
 <1484157249-464-4-git-send-email-bfoster@redhat.com>
 <20170113171312.GB27605@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170113171312.GB27605@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 13, 2017 at 09:13:12AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 11, 2017 at 12:54:07PM -0500, Brian Foster wrote:
> > COW fork reservation (delayed allocation) is implemented in
> > xfs_reflink_reserve_cow() and is generally based on the traditional data
> > fork delalloc logic in xfs_file_iomap_begin_delay(). In preparation for
> > further changes to implement more aggressive COW fork preallocation,
> > refactor the COW reservation code to reuse xfs_file_iomap_begin_delay()
> > for data fork allocation as well as COW fork reservation. This patch
> > does not change behavior.
> 
> I'm still trying to understand the point of patches 1-3:  there is no
> functionality, but a lot of new code is added to reuse some other code.
> 

IMO, patches 1-3 stand on their own as cleanup/refactor patches,
regardless of whether we want the actual speculative preallocation patch
(in current form or at all). xfs_reflink_reserve_cow() is mostly a
copy&paste of _iomap_begin_delay() operating on the cow fork rather than
the data fork, so technically we really shouldn't have a need for a
feature specific helper. Duplication aside, I also find the code a bit
confusing to follow in that we have to traverse through several
functions in "do nothing" cases such as non-shared blocks of a reflinked
file.

I would have preferred that code get factored into _begin_delay() from
the start, but it was too late for that by the time I grokked it and
there are also other callers from which prealloc may or may not be
appropriate (and that is why this patch by itself is not sufficient to
kill off _reserve_cow()). That said, we might be able to refactor the
allocation part of both functions such that we can replace the feature
specific helper with a common generic one. IOWs, these patches make it
so I don't have to further duplicate the prealloc stuff between
_write_begin() and _reserve_cow() and in the long term, I think this
helps facilitate further consolidation of duplicate code.

> How would patch 5 look like without that "reuse"?

I suppose we'd copy&paste more of begin_delay() into the reflink
specific helper (e.g., the prealloc bits). Then perhaps add a param to
control whether to perform preallocation.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
