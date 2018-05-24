Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58228 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935605AbeEXH4O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 May 2018 03:56:14 -0400
Date: Thu, 24 May 2018 10:01:43 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 19/34] xfs: simplify xfs_bmap_punch_delalloc_range
Message-ID: <20180524080143.GA11149@lst.de>
References: <20180523144357.18985-1-hch@lst.de> <20180523144357.18985-20-hch@lst.de> <20180523161710.GA33498@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180523161710.GA33498@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 23, 2018 at 12:17:11PM -0400, Brian Foster wrote:
> Mostly looks Ok, but I'm not following what this get_extent() call is
> for..? It also doesn't look like it would always do the right thing with
> sub-page blocks. Consider a page with a couple discontig delalloc blocks
> that happen to be the first extents in the file. The first
> xfs_bmap_del_extent_delay() would do:
> 
> 	xfs_iext_remove(ip, icur, state);
> 	xfs_iext_prev(ifp, icur);
> 
> ... which I think sets cur->pos to -1, causes the get_extent() to fail
> and thus fails to remove the subsequent delalloc blocks. Hm?

True.  This function should probably walk the extent list backwards
like xfs_bunmapi as that is the model that xfs_bmap_del_extent_* is
built around.
