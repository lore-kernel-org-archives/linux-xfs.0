Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f172.google.com ([209.85.160.172]:43396 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbfGISbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 14:31:24 -0400
Received: by mail-qt1-f172.google.com with SMTP id w17so19511437qto.10
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2019 11:31:24 -0700 (PDT)
Message-ID: <1562697081.8510.16.camel@lca.pw>
Subject: Re: memory leaks from xfs_rw_bdev()
From: Qian Cai <cai@lca.pw>
Date: Tue, 09 Jul 2019 14:31:21 -0400
In-Reply-To: <20190708213515.GB18177@lst.de>
References: <1562616489.8510.15.camel@lca.pw>
         <20190708213515.GB18177@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: darrick.wong@oracle.com, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2019-07-08 at 23:35 +0200, Christoph Hellwig wrote:
> We actually have a discussion on that in another thread, but if you
> can easily reproduce the issue, can you test the patch below?
> 
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index 757c1d9293eb..e2148f2d5d6b 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -43,7 +43,7 @@ xfs_rw_bdev(
>  			bio_copy_dev(bio, prev);
>  			bio->bi_iter.bi_sector = bio_end_sector(prev);
>  			bio->bi_opf = prev->bi_opf;
> -			bio_chain(bio, prev);
> +			bio_chain(prev, bio);
>  
>  			submit_bio(prev);
>  		}

Yes, it works fine.
