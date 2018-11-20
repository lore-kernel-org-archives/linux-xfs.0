Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:13768 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbeKTNL6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Nov 2018 08:11:58 -0500
From: "Huang\, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH V10 15/19] block: always define BIO_MAX_PAGES as 256
References: <20181115085306.9910-1-ming.lei@redhat.com>
        <20181115085306.9910-16-ming.lei@redhat.com>
        <20181116015936.GJ23828@vader> <20181119090415.GM16736@ming.t460p>
Date: Tue, 20 Nov 2018 10:45:03 +0800
In-Reply-To: <20181119090415.GM16736@ming.t460p> (Ming Lei's message of "Mon,
        19 Nov 2018 17:04:16 +0800")
Message-ID: <87o9ak8o28.fsf@yhuang-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Omar Sandoval <osandov@osandov.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

Ming Lei <ming.lei@redhat.com> writes:

> On Thu, Nov 15, 2018 at 05:59:36PM -0800, Omar Sandoval wrote:
>> On Thu, Nov 15, 2018 at 04:53:02PM +0800, Ming Lei wrote:
>> > Now multi-page bvec can cover CONFIG_THP_SWAP, so we don't need to
>> > increase BIO_MAX_PAGES for it.
>> 
>> You mentioned to it in the cover letter, but this needs more explanation
>> in the commit message. Why did CONFIG_THP_SWAP require > 256? Why does
>> multipage bvecs remove that requirement?
>
> CONFIG_THP_SWAP needs to split one TH page into normal pages and adds
> them all to one bio. With multipage-bvec, it just takes one bvec to
> hold them all.

Yes.  CONFIG_THP_SWAP needs to put 512 normal sub-pages into one bio to
write the 512 sub-pages together.  With the help of multipage-bvec, it
needs just bvect to hold 512 normal sub-pages.

Best Regards,
Huang, Ying

> thanks,
> Ming
