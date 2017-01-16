Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43632 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbdAPRhb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Jan 2017 12:37:31 -0500
Date: Mon, 16 Jan 2017 09:37:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/5] xfs: reuse iomap delalloc code for COW fork
 reservation
Message-ID: <20170116173730.GA11796@infradead.org>
References: <1484157249-464-1-git-send-email-bfoster@redhat.com>
 <1484157249-464-4-git-send-email-bfoster@redhat.com>
 <20170113171312.GB27605@infradead.org>
 <20170116162601.GB6302@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170116162601.GB6302@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Mon, Jan 16, 2017 at 11:26:01AM -0500, Brian Foster wrote:
> IMO, patches 1-3 stand on their own as cleanup/refactor patches,
> regardless of whether we want the actual speculative preallocation patch
> (in current form or at all). xfs_reflink_reserve_cow() is mostly a
> copy&paste of _iomap_begin_delay() operating on the cow fork rather than
> the data fork, so technically we really shouldn't have a need for a
> feature specific helper. Duplication aside, I also find the code a bit
> confusing to follow in that we have to traverse through several
> functions in "do nothing" cases such as non-shared blocks of a reflinked
> file.

I'm usually not a fan of refactor patches that adds lots of new code
without adding functionality.  In terms of readability I'm obviously
biasses having written a lot of the code, but I find the new code
much harder to read.
