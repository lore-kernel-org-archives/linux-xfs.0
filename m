Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33390 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755263AbdIHHdZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 03:33:25 -0400
Date: Fri, 8 Sep 2017 09:33:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/17] xfs: use the proper state defines in
        xfs_bmap_del_extent_real
Message-ID: <20170908073324.GA25065@lst.de>
References: <20170903072956.3175-1-hch@lst.de> <20170903072956.3175-8-hch@lst.de> <20170907154708.GG61662@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907154708.GG61662@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Sep 07, 2017 at 11:47:09AM -0400, Brian Foster wrote:
> The code looks correct because the states ultimately map to the correct
> logic, but I think this is actually a misuse of the bmap states. The
> contig states are used to define left and right extent contiguity. Here
> (and in del_extent_[delay|cow]()) we use them to track extent
> replacement alignment, which should be represented by the left and right
> filling states (as is done for delalloc/unwritten conversion helpers).
> Perhaps we should fix that all up?

Sure, will do when reposting.
