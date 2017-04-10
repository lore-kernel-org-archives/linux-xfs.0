Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51995 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752753AbdDJRln (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 13:41:43 -0400
Date: Mon, 10 Apr 2017 19:41:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] xfs: remove attr fork handling in
        xfs_bmap_finish_one
Message-ID: <20170410174142.GA19106@lst.de>
References: <20170403121833.7825-1-hch@lst.de> <20170403121833.7825-3-hch@lst.de> <20170410170539.GU4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170410170539.GU4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Apr 10, 2017 at 10:05:39AM -0700, Darrick J. Wong wrote:
> Hmmmm.  We never schedule deferred bmap operations for the attr fork,
> but all that stuff got plumbed all the way through to the bmap log item
> that is written to disk.  Therefore, it's possible that we may some day
> replay a log from a future XFS with a deferred attr fork bmap item in
> the log, at which point log recovery blows up here.

If we add that it's a format change that needs a incompat feature
flag.

> I wonder if this might be worth a WARN_ON_ONCE just to make it obvious
> that recovery stopped because it doesn't handle deferred attr fork bmap
> updates?

Sure, although we should never actually hit it.
