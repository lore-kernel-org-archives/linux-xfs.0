Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51539 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728499AbeKVAfk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Nov 2018 19:35:40 -0500
Date: Wed, 21 Nov 2018 15:01:05 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V11 11/19] bcache: avoid to use
 bio_for_each_segment_all() in bch_bio_alloc_pages()
Message-ID: <20181121140105.GB2323@lst.de>
References: <20181121032327.8434-1-ming.lei@redhat.com> <20181121032327.8434-12-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121032327.8434-12-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Wed, Nov 21, 2018 at 11:23:19AM +0800, Ming Lei wrote:
> bch_bio_alloc_pages() is always called on one new bio, so it is safe
> to access the bvec table directly. Given it is the only kind of this
> case, open code the bvec table access since bio_for_each_segment_all()
> will be changed to support for iterating over multipage bvec.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
