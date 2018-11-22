Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731891AbeKVVFa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Nov 2018 16:05:30 -0500
Date: Thu, 22 Nov 2018 18:26:17 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V11 14/19] block: handle non-cluster bio out of
 blk_bio_segment_split
Message-ID: <20181122102616.GC27273@ming.t460p>
References: <20181121032327.8434-1-ming.lei@redhat.com>
 <20181121032327.8434-15-ming.lei@redhat.com>
 <20181121143355.GB2594@lst.de>
 <20181121153726.GC19111@ming.t460p>
 <20181121174621.GA6961@lst.de>
 <20181122093259.GA27007@ming.t460p>
 <20181122100427.GA28871@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122100427.GA28871@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Thu, Nov 22, 2018 at 11:04:28AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 22, 2018 at 05:33:00PM +0800, Ming Lei wrote:
> > However, using virt boundary limit on non-cluster seems over-kill,
> > because the bio will be over-split(each small bvec may be split as one bio)
> > if it includes lots of small segment.
> 
> The combination of the virt boundary of PAGE_SIZE - 1 and a
> max_segment_size of PAGE_SIZE will only split if the to me merged
> segment is in a different page than the previous one, which is exactly
> what we need here.  Multiple small bvec inside the same page (e.g.
> 512 byte buffer_heads) will still be merged.

Suppose one bio includes (pg0, 0, 512) and (pg1, 512, 512):

The split is introduced by the following code in blk_bio_segment_split():

      if (bvprvp && bvec_gap_to_prev(q, bvprvp, bv.bv_offset))
		  	goto split;

Without this patch, for non-cluster, the two bvecs are just in different
segment, but still handled by one same bio. Now you convert into two bios.

Thanks,
Ming
