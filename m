Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41473 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1032952AbdDTOru (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Apr 2017 10:47:50 -0400
Date: Thu, 20 Apr 2017 15:43:56 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Message-ID: <20170420134356.GD22135@quack2.suse.cz>
References: <20170414120257.8932-1-rgoldwyn@suse.de>
 <20170414120257.8932-6-rgoldwyn@suse.de>
 <20170419064505.GD20053@infradead.org>
 <d3467259-675a-2723-7cf9-d4f2f067d634@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3467259-675a-2723-7cf9-d4f2f067d634@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Wed 19-04-17 10:21:39, Goldwyn Rodrigues wrote:
> 
> 
> On 04/19/2017 01:45 AM, Christoph Hellwig wrote:
> > 
> >> +	if (bio->bi_opf & REQ_NOWAIT) {
> >> +		if (!blk_queue_nowait(q)) {
> >> +			err = -EOPNOTSUPP;
> >> +			goto end_io;
> >> +		}
> >> +		if (!(bio->bi_opf & REQ_SYNC)) {
> > 
> > I don't understand this check at all..
> 
> It is to ensure at the block layer that NOWAIT comes only for DIRECT
> calls only. I should probably change it to REQ_SYNC | REQ_IDLE.

Ouch. Checking 'REQ_SYNC' for this is

a) unreliable hack
b) layering violation

You just don't care why someone marked bio with REQ_NOWAIT at this place.
Just obey the request if you can, return error if you cannot, but advisory
REQ_SYNC or REQ_IDLE flags have nothing to do with the ability of the block
layer to submit the bio without blocking...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
