Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbeKUPhQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Nov 2018 10:37:16 -0500
Date: Wed, 21 Nov 2018 13:04:00 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V10 09/19] block: introduce bio_bvecs()
Message-ID: <20181121050359.GA31915@ming.t460p>
References: <20181115085306.9910-10-ming.lei@redhat.com>
 <20181116134541.GH3165@lst.de>
 <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
 <20181120161651.GB2629@lst.de>
 <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
 <20181121005902.GA31748@ming.t460p>
 <2d9bee7a-f010-dcf4-1184-094101058584@grimberg.me>
 <20181121034415.GA8408@ming.t460p>
 <2a47d336-c19b-6bf4-c247-d7382871eeea@grimberg.me>
 <7378bf49-5a7e-5622-d4d1-808ba37ce656@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7378bf49-5a7e-5622-d4d1-808ba37ce656@grimberg.me>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Tue, Nov 20, 2018 at 08:42:04PM -0800, Sagi Grimberg wrote:
> 
> > > Yeah, that is the most common example, given merge is enabled
> > > in most of cases. If the driver or device doesn't care merge,
> > > you can disable it and always get single bio request, then the
> > > bio's bvec table can be reused for send().
> > 
> > Does bvec_iter span bvecs with your patches? I didn't see that change?
> 
> Wait, I see that the bvec is still a single array per bio. When you said
> a table I thought you meant a 2-dimentional array...

I mean a new 1-d table A has to be created for multiple bios in one rq,
and build it in the following way

           rq_for_each_bvec(tmp, rq, rq_iter)
                    *A = tmp;

Then you can pass A to iov_iter_bvec() & send().

Given it is over TCP, I guess it should be doable for you to preallocate one
256-bvec table in one page for each request, then sets the max segment size as
(unsigned int)-1, and max segment number as 256, the preallocated table
should work anytime.


Thanks,
Ming
