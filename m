Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57545 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388382AbeKVVTm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Nov 2018 16:19:42 -0500
Date: Thu, 22 Nov 2018 11:40:49 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V11 14/19] block: handle non-cluster bio out of
 blk_bio_segment_split
Message-ID: <20181122104049.GA29654@lst.de>
References: <20181121032327.8434-1-ming.lei@redhat.com> <20181121032327.8434-15-ming.lei@redhat.com> <20181121143355.GB2594@lst.de> <20181121153726.GC19111@ming.t460p> <20181121174621.GA6961@lst.de> <20181122093259.GA27007@ming.t460p> <20181122100427.GA28871@lst.de> <20181122102616.GC27273@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122102616.GC27273@ming.t460p>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Thu, Nov 22, 2018 at 06:26:17PM +0800, Ming Lei wrote:
> Suppose one bio includes (pg0, 0, 512) and (pg1, 512, 512):
> 
> The split is introduced by the following code in blk_bio_segment_split():
> 
>       if (bvprvp && bvec_gap_to_prev(q, bvprvp, bv.bv_offset))
> 		  	goto split;
> 
> Without this patch, for non-cluster, the two bvecs are just in different
> segment, but still handled by one same bio. Now you convert into two bios.

Oh, true - we create new bios instead of new segments.  So I guess we
need to do something special here if we don't want to pay that overhead.

Or just look into killing the cluster setting..
