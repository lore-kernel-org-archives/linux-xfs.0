Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39478 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbeKPMKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Nov 2018 07:10:04 -0500
Received: by mail-pg1-f195.google.com with SMTP id r9-v6so9857156pgv.6
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 17:59:38 -0800 (PST)
Date: Thu, 15 Nov 2018 17:59:36 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH V10 15/19] block: always define BIO_MAX_PAGES as 256
Message-ID: <20181116015936.GJ23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-16-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-16-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Thu, Nov 15, 2018 at 04:53:02PM +0800, Ming Lei wrote:
> Now multi-page bvec can cover CONFIG_THP_SWAP, so we don't need to
> increase BIO_MAX_PAGES for it.

You mentioned to it in the cover letter, but this needs more explanation
in the commit message. Why did CONFIG_THP_SWAP require > 256? Why does
multipage bvecs remove that requirement?

> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Cc: linux-erofs@lists.ozlabs.org
> Cc: David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: linux-xfs@vger.kernel.org
> Cc: Gao Xiang <gaoxiang25@huawei.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Cc: Coly Li <colyli@suse.de>
> Cc: linux-bcache@vger.kernel.org
> Cc: Boaz Harrosh <ooo@electrozaur.com>
> Cc: Bob Peterson <rpeterso@redhat.com>
> Cc: cluster-devel@redhat.com
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/bio.h | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 5040e9a2eb09..277921ad42e7 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -34,15 +34,7 @@
>  #define BIO_BUG_ON
>  #endif
>  
> -#ifdef CONFIG_THP_SWAP
> -#if HPAGE_PMD_NR > 256
> -#define BIO_MAX_PAGES		HPAGE_PMD_NR
> -#else
>  #define BIO_MAX_PAGES		256
> -#endif
> -#else
> -#define BIO_MAX_PAGES		256
> -#endif
>  
>  #define bio_prio(bio)			(bio)->bi_ioprio
>  #define bio_set_prio(bio, prio)		((bio)->bi_ioprio = prio)
> -- 
> 2.9.5
> 
