Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50061 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728210AbeKUTTr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Nov 2018 14:19:47 -0500
Date: Wed, 21 Nov 2018 09:46:08 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V10 09/19] block: introduce bio_bvecs()
Message-ID: <20181121084608.GA29622@lst.de>
References: <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me> <20181120161651.GB2629@lst.de> <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me> <20181121005902.GA31748@ming.t460p> <2d9bee7a-f010-dcf4-1184-094101058584@grimberg.me> <20181121034415.GA8408@ming.t460p> <2a47d336-c19b-6bf4-c247-d7382871eeea@grimberg.me> <7378bf49-5a7e-5622-d4d1-808ba37ce656@grimberg.me> <20181121050359.GA31915@ming.t460p> <fc268b0e-61b5-aacc-67be-cb7b266c6d8f@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc268b0e-61b5-aacc-67be-cb7b266c6d8f@grimberg.me>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Tue, Nov 20, 2018 at 09:35:07PM -0800, Sagi Grimberg wrote:
>> Given it is over TCP, I guess it should be doable for you to preallocate one
>> 256-bvec table in one page for each request, then sets the max segment size as
>> (unsigned int)-1, and max segment number as 256, the preallocated table
>> should work anytime.
>
> 256 bvec table is really a lot to preallocate, especially when its not
> needed, I can easily initialize the bvec_iter on the bio bvec. If this
> involves preallocation of the worst-case than I don't consider this to
> be an improvement.

Ok, I took a look at the nvme-tcp code and it seems you care about
bios because you want a contiguos bio chunk for sending it down
the networking code.  Yes, in that case we sort of need to iterate
over bios.  But you already have a special case for discard, so you
don't really need any of the magic in the bio_bvecs() helper either
can can just count bi_vcnt in the bio.
