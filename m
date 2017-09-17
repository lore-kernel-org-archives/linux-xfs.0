Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49722 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751352AbdIQVWs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 17 Sep 2017 17:22:48 -0400
Date: Sun, 17 Sep 2017 23:22:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/18] xfs: refactor xfs_bmap_add_extent_delay_real
Message-ID: <20170917212247.GA28851@lst.de>
References: <20170915145426.26194-1-hch@lst.de> <20170915145426.26194-13-hch@lst.de> <20170915170022.GC7276@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170915170022.GC7276@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Sep 15, 2017 at 01:00:22PM -0400, Brian Foster wrote:
> > -		da_new = temp + temp2;
> > +		da_new = PREV.br_blockcount + RIGHT.br_blockcount;
> 
> da_new should be the new total indirect reservation. The above sets it
> to the total/remaining delalloc block count. E.g., it should probably be
> something like this:
> 
> 	da_new = startblockval(PREV.br_startblock) +
> 		 startblockval(RIGHT.br_startblock);
> 
> Or alternatively you could set da_new right before diff is calculated
> and reuse it in that calculation. Otherwise the patch looks good.

Indeed.  And we should probably use da_new for the calculation of
diff as well, or rather clean up the mess with the double
xfs_mod_fdblocks.

xfs_bmap_add_extent_delay_real is such a beast..
