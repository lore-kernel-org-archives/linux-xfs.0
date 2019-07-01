Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:41231 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729294AbfGAOFG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 10:05:06 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so29035869ioc.8
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2019 07:05:05 -0700 (PDT)
Subject: Re: [PATCH V2] block: fix .bi_size overflow
References: <20190701071446.22028-1-ming.lei@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8db73c5d-a0e2-00c9-59ab-64314097db26@kernel.dk>
Date: Mon, 1 Jul 2019 08:05:01 -0600
MIME-Version: 1.0
In-Reply-To: <20190701071446.22028-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Liu Yiding <liuyd.fnst@cn.fujitsu.com>, kernel test robot <rong.a.chen@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org

On 7/1/19 1:14 AM, Ming Lei wrote:
> 'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
> bytes.
> 
> Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
> include very limited pages, and usually at most 256, so the fs bio
> size won't be bigger than 1M bytes most of times.
> 
> Since we support multi-page bvec, in theory one fs bio really can
> be added > 1M pages, especially in case of hugepage, or big writeback
> with too many dirty pages. Then there is chance in which .bi_size
> is overflowed.
> 
> Fixes this issue by using bio_full() to check if the added segment may
> overflow .bi_size.

Any objections to queuing this up for 5.3? It's not a new regression
this series.

-- 
Jens Axboe
