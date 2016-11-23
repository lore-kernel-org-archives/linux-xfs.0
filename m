Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55083 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933326AbcKWIg7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Nov 2016 03:36:59 -0500
Date: Wed, 23 Nov 2016 09:36:57 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: an iomap-based direct I/O implementation V3
Message-ID: <20161123083657.GA16966@lst.de>
References: <1479064054-10474-1-git-send-email-hch@lst.de> <20161122225243.GN31101@dastard> <fe3fa405-7295-1a86-0e78-85be65d9edba@kernel.dk> <20161123000204.GO31101@dastard> <d0a96b3e-9fb1-9c93-2c0e-6a1d7ec1e98d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0a96b3e-9fb1-9c93-2c0e-6a1d7ec1e98d@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Nov 22, 2016 at 05:40:30PM -0700, Jens Axboe wrote:
> That's going to be somewhat harder... The REQ_IDLE used to be
> REQ_NOIDLE. bio_iov_iter_get_pages() is a single commit, so that's easy
> enough. The poll bits are 3-4 patches, so not too bad either.

I think we'll simply need a tree that has latest master merged into
the block tree as a base.  The only other option would be to cherry-pick
bio_iov_iter_get_pages from the block tree into the XFS tree, and I'll
resend the series so that it doesn't require the other block changes,
those are fairly mechanical merges that could be carried in linux-next.
