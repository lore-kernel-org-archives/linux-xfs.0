Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39539 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753711AbdBGJne (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Feb 2017 04:43:34 -0500
Date: Tue, 7 Feb 2017 10:43:32 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/4] xfs: improve handling of busy extents in the
        low-level allocator
Message-ID: <20170207094332.GD15267@lst.de>
References: <1485715421-17182-1-git-send-email-hch@lst.de> <1485715421-17182-3-git-send-email-hch@lst.de> <20170203162243.GF45388@bfoster.bfoster> <20170204095606.GC18472@lst.de> <20170206164750.GG57865@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170206164750.GG57865@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Feb 06, 2017 at 11:47:50AM -0500, Brian Foster wrote:
> That said, that limitation should be noted somewhere. Can we add a
> comment in xfs_extent_busy_clear() right above the hunk where we do the
> SKIP_DISCARD wake? E.g., something that points out the gen number for
> any particular extent could be bumped in such a situation.. (or
> something along those lines)?

I could add a comment, but given that the tree tracks busy extents
and is not in any way specific to discard I think it's more confusing
than not having it.
