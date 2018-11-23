Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503502AbeKWVeu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Nov 2018 16:34:50 -0500
Date: Fri, 23 Nov 2018 18:50:26 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V11 15/19] block: enable multipage bvecs
Message-ID: <20181123105024.GA13902@ming.t460p>
References: <20181121032327.8434-1-ming.lei@redhat.com>
 <20181121032327.8434-16-ming.lei@redhat.com>
 <20181121145502.GA3241@lst.de>
 <20181121154812.GD19111@ming.t460p>
 <20181121161206.GD4977@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121161206.GD4977@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Wed, Nov 21, 2018 at 05:12:06PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 21, 2018 at 11:48:13PM +0800, Ming Lei wrote:
> > I guess the correct check should be:
> > 
> > 		end_addr = vec_addr + bv->bv_offset + bv->bv_len;
> > 		if (same_page &&
> > 		    (end_addr & PAGE_MASK) != (page_addr & PAGE_MASK))
> > 			return false;
> 
> Indeed.

The above is still not totally correct, and it should have been:

 		end_addr = vec_addr + bv->bv_offset + bv->bv_len - 1;
 		if (same_page && (end_addr & PAGE_MASK) != page_addr)
 			return false;

Also bv->bv_len should be guaranteed as being bigger than zero.

It also shows that it is quite easy to figure out the last page as
wrong, :-(


Thanks,
Ming
