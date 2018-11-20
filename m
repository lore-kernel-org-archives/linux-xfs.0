Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46161 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbeKUCqr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Nov 2018 21:46:47 -0500
Date: Tue, 20 Nov 2018 17:16:51 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V10 09/19] block: introduce bio_bvecs()
Message-ID: <20181120161651.GB2629@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com> <20181115085306.9910-10-ming.lei@redhat.com> <20181116134541.GH3165@lst.de> <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Mon, Nov 19, 2018 at 04:49:27PM -0800, Sagi Grimberg wrote:
>
>> The only user in your final tree seems to be the loop driver, and
>> even that one only uses the helper for read/write bios.
>>
>> I think something like this would be much simpler in the end:
>
> The recently submitted nvme-tcp host driver should also be a user
> of this. Does it make sense to keep it as a helper then?

I did take a brief look at the code, and I really don't understand
why the heck it even deals with bios to start with.  Like all the
other nvme transports it is a blk-mq driver and should iterate
over segments in a request and more or less ignore bios.  Something
is horribly wrong in the design.
