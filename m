Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43040 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755243AbdBGWV5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Feb 2017 17:21:57 -0500
Date: Tue, 7 Feb 2017 23:21:55 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/5] xfs: improve handling of busy extents in the
        low-level allocator
Message-ID: <20170207222155.GA29750@lst.de>
References: <20170207171501.4268-1-hch@lst.de> <20170207171501.4268-4-hch@lst.de> <20170207215149.GG12378@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207215149.GG12378@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Feb 07, 2017 at 01:51:49PM -0800, Darrick J. Wong wrote:
> > So instead we add a new waitqueue and a generation counter to the pag
> > structure so that we can do wakeups once we've removed busy extents,
> > and we replace the single retry with an unconditional one - after
> > all we hold the AGF buffer lock, so no other allocations or frees
> > can be racing with us in this AG.
> 
> Um... is this patch supposed to be merged with the previous one?
> They have the same subject/commit message.

It is - but git rebase keeps duplicating patches when you try to fold
a patch into the previous one and there is any kind of conflict.  In
that case it needs another pass to really fold it which I missed for
this series.
