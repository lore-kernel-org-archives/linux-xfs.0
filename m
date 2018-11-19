Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbeKST1l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Nov 2018 14:27:41 -0500
Date: Mon, 19 Nov 2018 17:04:16 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V10 15/19] block: always define BIO_MAX_PAGES as 256
Message-ID: <20181119090415.GM16736@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-16-ming.lei@redhat.com>
 <20181116015936.GJ23828@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116015936.GJ23828@vader>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>, Huang Ying <ying.huang@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Thu, Nov 15, 2018 at 05:59:36PM -0800, Omar Sandoval wrote:
> On Thu, Nov 15, 2018 at 04:53:02PM +0800, Ming Lei wrote:
> > Now multi-page bvec can cover CONFIG_THP_SWAP, so we don't need to
> > increase BIO_MAX_PAGES for it.
> 
> You mentioned to it in the cover letter, but this needs more explanation
> in the commit message. Why did CONFIG_THP_SWAP require > 256? Why does
> multipage bvecs remove that requirement?

CONFIG_THP_SWAP needs to split one TH page into normal pages and adds
them all to one bio. With multipage-bvec, it just takes one bvec to
hold them all.

thanks,
Ming
