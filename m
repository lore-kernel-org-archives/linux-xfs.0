Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43188 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751340AbdH3HvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 03:51:10 -0400
Date: Wed, 30 Aug 2017 00:51:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: skip free eofblocks if inode is under written back
Message-ID: <20170830075109.GA4711@infradead.org>
References: <20170830042628.5592-1-eguan@redhat.com>
 <20170830072950.GJ10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830072950.GJ10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 05:29:50PM +1000, Dave Chinner wrote:
> Quick patch below, doesn't work on reflink filesystems yet because
> the way it handles cached COW mapping invalidation is unnecessarily
> special and so doesn't work. Can you test it and see if it fixes the
> problem?

FYI, I thought about this problem a while ago in the context of
rcu lookups of the extent tree (not, I'm not doing those quite yet,
but I though of the possibilities once we've got a btree!) and
then my answer was that we'd really need a seqlock around uses of
the imaps.  I didn't think far enough that we might need something
like that even now..
