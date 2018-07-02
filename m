Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55206 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbeGBOvD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:51:03 -0400
Date: Mon, 2 Jul 2018 07:51:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/24] xfs: broad enablement of deferred agfl frees
Message-ID: <20180702145102.GA3831@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:12PM -0400, Brian Foster wrote:
> I think these issues can be mostly resolved by the end goal of a
> combined xfs_trans/xfs_defer_ops structure. Boilerplate code that
> allocates a transaction, inits a dfops, finishes a dfops and commits the
> transaction can then reduce to allocating and committing the transaction
> (where the former and latter respectively init/finish an internal
> dfops). There are other patterns and issues to consider, however, so
> that will be a matter for a subsequent patch series. (I'm actually
> thinking of cleaning up all of the firstblock stuff as a next step in
> that direction.)

Yes, I actually did a pass at firstblock a while ago when looking into
the allocation reservation issues.  It cleaned things up a lot, but
I ended up dropping it as it didn't actually end up helping to solve
the problem directly.
