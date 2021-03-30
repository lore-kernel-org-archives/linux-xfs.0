Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 017C0C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B53E4619CB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhC3ScA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232839AbhC3Sbz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 14:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31BDC61924;
        Tue, 30 Mar 2021 18:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617129115;
        bh=ZQ8TB5Rw0Rcg+WRGBtk6BKlGYGNHqbrgWffIXk9Iqp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W0yixvUKo17JFOI2m5B7DjJbEcCQOAJaxZesOl/ivigJ22j3fYnx2FjQzioTnEhee
         /KildT7CTH7RL4oKAgxibcDDUxCUhPtnDuRyZLU7yEpFqP9tZIrL3hnsYeOLRkKNma
         vfG/UQHcUyaE9fYx9vBWqeJ27gRXVFb5G9uHa6GUXMpVmbrOuUJcXoYWCeXpSue+/E
         MOvgS+ba1WYrUsqE7xV3dt+YQYFY3FjIHeICyeb41sqnK5Ksc/eJIbdbvqtEb9UDwz
         3+0dpsSqj7QXwTbPJ3Q8EluXn2z5BljBQafRlLEgc8xln/gG8DnBinJQlV0Nt9A/up
         VH2JNL1P39z3w==
Date:   Tue, 30 Mar 2021 11:31:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH v3 8/8] repair: scale duplicate name checking in phase 6.
Message-ID: <20210330183153.GX4090233@magnolia>
References: <20210330142531.19809-1-hsiangkao@aol.com>
 <20210330142531.19809-9-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330142531.19809-9-hsiangkao@aol.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 10:25:31PM +0800, Gao Xiang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> phase 6 on large directories is cpu bound on duplicate name checking
> due to the algorithm having effectively O(n^2) scalability. Hence
> when the duplicate name hash table  size is far smaller than the
> number of directory entries, we end up with long hash chains that
> are searched linearly on every new entry that is found in the
> directory to do duplicate detection.
> 
> The in-memory hash table size is limited to 64k entries. Hence when
> we have millions of entries in a directory, duplicate entry lookups
> on the hash table have substantial overhead. Scale this table out to
> larger sizes so that we keep the chain lengths short and hence the
> O(n^2) scalability impact is limited because N is always small.
> 
> For a 10M entry directory consuming 400MB of directory data, the
> hash table now sizes at 6.4 million entries instead of ~64k - it is
> ~100x larger. While the hash table now consumes ~50MB of RAM, the
> xfs_repair footprint barely changes as it's using already consuming
> ~9GB of RAM at this point in time. IOWs, the incremental memory
> usage change is noise, but the directory checking time:
> 
> Unpatched:
> 
>   97.11%  xfs_repair          [.] dir_hash_add
>    0.38%  xfs_repair          [.] longform_dir2_entry_check_data
>    0.34%  libc-2.31.so        [.] __libc_calloc
>    0.32%  xfs_repair          [.] avl_ino_start
> 
> Phase 6:        10/22 12:11:40  10/22 12:14:28  2 minutes, 48 seconds
> 
> Patched:
> 
>   46.74%  xfs_repair          [.] radix_tree_lookup
>   32.13%  xfs_repair          [.] dir_hash_see_all
>    7.70%  xfs_repair          [.] radix_tree_tag_get
>    3.92%  xfs_repair          [.] dir_hash_add
>    3.52%  xfs_repair          [.] radix_tree_tag_clear
>    2.43%  xfs_repair          [.] crc32c_le
> 
> Phase 6:        10/22 13:11:01  10/22 13:11:18  17 seconds
> 
> has been reduced by an order of magnitude.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  repair/phase6.c | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 063329636500..aa991bf76da6 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -288,19 +288,37 @@ dir_hash_done(
>  	free(hashtab);
>  }
>  
> +/*
> + * Create a directory hash index structure based on the size of the directory we
> + * are about to try to repair. The size passed in is the size of the data
> + * segment of the directory in bytes, so we don't really know exactly how many
> + * entries are in it. Hence assume an entry size of around 64 bytes - that's a
> + * name length of 40+ bytes so should cover a most situations with large
> + * really directories.

"...with really large directories."

> + */
>  static struct dir_hash_tab *
>  dir_hash_init(
>  	xfs_fsize_t		size)
>  {
> -	struct dir_hash_tab	*hashtab;
> +	struct dir_hash_tab	*hashtab = NULL;
>  	int			hsize;
>  
> -	hsize = size / (16 * 4);
> -	if (hsize > 65536)
> -		hsize = 63336;
> -	else if (hsize < 16)
> +	hsize = size / 64;
> +	if (hsize < 16)
>  		hsize = 16;
> -	if ((hashtab = calloc(DIR_HASH_TAB_SIZE(hsize), 1)) == NULL)
> +
> +	/*
> +	 * Try to allocate as large a hash table as possible. Failure to
> +	 * allocate isn't fatal, it will just result in slower performance as we
> +	 * reduce the size of the table.
> +	 */
> +	while (hsize >= 16) {
> +		hashtab = calloc(DIR_HASH_TAB_SIZE(hsize), 1);
> +		if (hashtab)
> +			break;
> +		hsize /= 2;
> +	}

I still kinda wonder if the hash size ought to be some prime number,
though I suppose /finding/ a prime number isn't necessarily easy.

Hm, let's assume you had the maximal 32GB directory.

size = 34359738368
hsize = size/64 = 536870912
DIR_HASH_TAB_SIZE(hsize) =
	(sizeof(dir_hash_tab_t) + (sizeof(dir_hash_ent_t *) * (hsize) * 2))

== 40 + (8 * 536870912 * 2) == 8589934632

That's ... kind of big?  I guess the saving grace is that we halve hsize
if calloc fails and the address space isn't populated with memory pages
until we actually use them.  It might turn out that users want a lower
cap than 8GB per 32GB directory, but I suppose we won't find /that/ out
until we try...

With the comment fixed,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	if (!hashtab)
>  		do_error(_("calloc failed in dir_hash_init\n"));
>  	hashtab->size = hsize;
>  	hashtab->byhash = (struct dir_hash_ent **)((char *)hashtab +
> -- 
> 2.20.1
> 
