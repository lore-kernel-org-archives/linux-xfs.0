Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DCDC00A8F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 15:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjJXPBp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 11:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjJXPBo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 11:01:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB0B93;
        Tue, 24 Oct 2023 08:01:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA60C433C7;
        Tue, 24 Oct 2023 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698159702;
        bh=1pZsvfNqaW8uD8hkD8AmBgpUOr49aKiJeiOe+uJEpVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KktcCfctLPQhL+IMb6wsd/xVbuB4Q7Z5eQOmT1zrSH7h1ipk5I8vl04BNqcrZgGvX
         6p2KXUL1xZti/clWXXm44msXQxCjZyJMiyQc4KOQ0XS1P5CIDWnGLtULiZE4Ff3hny
         y+neJtJ7/4YisAEb+ijlwPXXhNf/x+ZskCQEjvgOvC7u2z0XZOswGyoa216htHBczY
         ZMI9pt0ayZWV2vdpSGrgkuxhZoNaeZK6L8fhLcMTvxtXa+O1stF0RItZ8EjGsV+f+I
         Vw4dqX6JTWlq61EQJiskayVfnapJeRuLWVoKP5vHaOyt0O80BPCgoxs9iUOBqHhtX4
         fElkE/WbP55Xw==
Date:   Tue, 24 Oct 2023 08:01:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] block: update the stable_writes flag in bdev_add
Message-ID: <20231024150142.GZ3195650@frogsfrogsfrogs>
References: <20231024064416.897956-1-hch@lst.de>
 <20231024064416.897956-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024064416.897956-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 08:44:15AM +0200, Christoph Hellwig wrote:
> Propagate the per-queue stable_write flags into each bdev inode in bdev_add.
> This makes sure devices that require stable writes have it set for I/O
> on the block device node as well.
> 
> Note that this doesn't cover the case of a flag changing on a live device
> yet.  We should handle that as well, but I plan to cover it as part of a
> more general rework of how changing runtime paramters on block devices
> works.

Yessssssssss! :)

> Fixes: 1cb039f3dc16 ("bdi: replace BDI_CAP_STABLE_WRITES with a queue and a sb flag")
> Reported-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems sane to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  block/bdev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index f3b13aa1b7d428..04dba25b0019eb 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -425,6 +425,8 @@ void bdev_set_nr_sectors(struct block_device *bdev, sector_t sectors)
>  
>  void bdev_add(struct block_device *bdev, dev_t dev)
>  {
> +	if (bdev_stable_writes(bdev))
> +		mapping_set_stable_writes(bdev->bd_inode->i_mapping);
>  	bdev->bd_dev = dev;
>  	bdev->bd_inode->i_rdev = dev;
>  	bdev->bd_inode->i_ino = dev;
> -- 
> 2.39.2
> 
