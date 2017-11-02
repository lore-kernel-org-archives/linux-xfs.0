Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56317 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932571AbdKBSvj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 14:51:39 -0400
Date: Thu, 2 Nov 2017 19:51:38 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/18] xfs: introduce the xfs_iext_cursor abstraction
Message-ID: <20171102185138.GC4244@lst.de>
References: <20171031142230.11755-1-hch@lst.de> <20171031142230.11755-13-hch@lst.de> <20171102171437.GH16645@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102171437.GH16645@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Nov 02, 2017 at 01:14:37PM -0400, Brian Foster wrote:
> Can we just open code ext->idx here rather than maintain two counters,
> or will that go away later?

This area will change quite a bit.  Please take a look at the end result.

> > -	ASSERT(bma->idx >= 0);
> > -	ASSERT(bma->idx <= xfs_iext_count(ifp));
> 
> I think it might be useful to encapsulate this check (which is also part
> of xfs_iext_get_extent()) into a cursor validation helper so we can
> preserve these asserts (here and in the other bmap functions). E.g.,
> something like:
> 
> 	ASSERT(xfs_iext_valid(&bma->ext));

I'll take a look at that.

> 1.) Why do we place these new cursors directly on the stack as opposed
> to dynamic allocation?

Why would be do a dynamic allocation?

> 2.) Why not encode the fork/inode in the cursor rather than passing them
> around throughout the helper functions?

We could do that, but I'm not sure it's really worth the effort.
