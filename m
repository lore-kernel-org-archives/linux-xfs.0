Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49862 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729609AbfETGGt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 02:06:49 -0400
Date: Mon, 20 May 2019 08:06:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/20] xfs: don't require log items to implement
 optional methods
Message-ID: <20190520060627.GE31977@lst.de>
References: <20190517073119.30178-1-hch@lst.de> <20190517073119.30178-4-hch@lst.de> <20190517140654.GC7888@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517140654.GC7888@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 10:06:54AM -0400, Brian Foster wrote:
> Nice cleanup overall. This removes a ton of duplicated and boilerplate
> code. One thing I don't like is the loss of information around the use
> of XFS_ITEM_PINNED in all these ->iop_push() calls associated with
> intents. I'd almost rather see a generic xfs_intent_item_push() defined
> somewhere and wire that up to these various calls.

I don't particularly like that idea, for one because it adds so much
boilerplate code to the intents, but also because if you logically thing
about it - if an item can't be pushed it kinda is per defintion pinned,
so I think this default makes sense.

> Short of that, could
> we at least move some of the information from these comments to the push
> call in xfsaild_push_item()? For example....

Sure, I can do that.
