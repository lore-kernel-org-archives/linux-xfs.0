Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36401 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbeK0JOQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Nov 2018 04:14:16 -0500
Received: by mail-pl1-f193.google.com with SMTP id g9so2073423plo.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Nov 2018 14:18:41 -0800 (PST)
Date: Mon, 26 Nov 2018 14:18:35 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH V12 06/20] block: rename bvec helpers
Message-ID: <20181126221835.GG30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-7-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-7-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Mon, Nov 26, 2018 at 10:17:06AM +0800, Ming Lei wrote:
> We will support multi-page bvec soon, and have to deal with
> single-page vs multi-page bvec. This patch follows Christoph's
> suggestion to rename all the following helpers:
> 
> 	for_each_bvec
> 	bvec_iter_bvec
> 	bvec_iter_len
> 	bvec_iter_page
> 	bvec_iter_offset
> 
> into:
> 	for_each_segment
> 	segment_iter_bvec
> 	segment_iter_len
> 	segment_iter_page
> 	segment_iter_offset
> 
> so that these helpers named with 'segment' only deal with single-page
> bvec, or called segment. We will introduce helpers named with 'bvec'
> for multi-page bvec.
> 
> bvec_iter_advance() isn't renamed becasue this helper is always operated
> on real bvec even though multi-page bvec is supported.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  .clang-format                  |  2 +-
>  drivers/md/dm-integrity.c      |  2 +-
>  drivers/md/dm-io.c             |  4 ++--
>  drivers/nvdimm/blk.c           |  4 ++--
>  drivers/nvdimm/btt.c           |  4 ++--
>  include/linux/bio.h            | 10 +++++-----
>  include/linux/bvec.h           | 20 +++++++++++---------
>  include/linux/ceph/messenger.h |  2 +-
>  lib/iov_iter.c                 |  2 +-
>  net/ceph/messenger.c           | 14 +++++++-------
>  10 files changed, 33 insertions(+), 31 deletions(-)
