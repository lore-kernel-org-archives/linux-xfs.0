Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36464 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbfAUJnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 04:43:25 -0500
Subject: Re: [PATCH V14 00/18] block: support multi-page bvec
References: <20190121081805.32727-1-ming.lei@redhat.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <61dfaa1e-e7bf-75f1-410b-ed32f97d0782@grimberg.me>
Date: Mon, 21 Jan 2019 01:43:21 -0800
MIME-Version: 1.0
In-Reply-To: <20190121081805.32727-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com


> V14:
> 	- drop patch(patch 4 in V13) for renaming bvec helpers, as suggested by Jens
> 	- use mp_bvec_* as multi-page bvec helper name
> 	- fix one build issue, which is caused by missing one converion of
> 	bio_for_each_segment_all in fs/gfs2
> 	- fix one 32bit ARCH specific issue caused by segment boundary mask
> 	overflow

Hey Ming,

So is nvme-tcp also affected here? The only point where I see nvme-tcp
can be affected is when initializing a bvec iter using bio_segments() as
everywhere else we use iters which should transparently work..

I see that loop was converted, does it mean that nvme-tcp needs to
call something like?
--
	bio_for_each_mp_bvec(bv, bio, iter)
		nr_bvecs++;
--
