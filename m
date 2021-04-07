Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D1EC433ED
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF8B46139B
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243477AbhDGPhE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 11:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347315AbhDGPhE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Apr 2021 11:37:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADA086112F;
        Wed,  7 Apr 2021 15:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617809814;
        bh=sLsL/lA1/Y9LoSqd1iNJ6mQ5V88ONuxnXT4WPPku4LY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OtCGOYZtfBrGOMc3SowtF8EqQ/HLEfj9nCTEWp6RV/leacDoPOKp4hsNd+0uXryZG
         cHd3ZE6OnsySHGsZebWtq0+xTn/Witj4U0m2IkECbkewjQweawzSCskk9JRnCCUyhp
         MH65Pzt3twjP5e8SVHrNRD5auDdkDRU42ys6FzAZw1WqnvKV0nSToBC3C37MG1uyx8
         9sUi3Jw9bgK5q3iRXhSoZmbhcWi9DP1r/bMEjkPUTJq9xmGconWkhLmy3vwQkVXzJo
         3Gp2+MJp1jFH9XG85d6j0KUVw1INncvtIB4V6fh+dMRcY7A1Cen1Tg5BDfs3Er3OP+
         hasqRfYMEWgaQ==
Date:   Wed, 7 Apr 2021 08:36:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/4] iomap: remove unused private field from ioend
Message-ID: <20210407153654.GJ3957620@magnolia>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210406102754.795429-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406102754.795429-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 06, 2021 at 06:27:54AM -0400, Brian Foster wrote:
> The only remaining user of ->io_private is the generic ioend merging
> infrastructure. The only user of that is XFS, which no longer sets
> ->io_private or passes an associated merge callback. Remove the
> unused parameter and the ->io_private field.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/iomap/buffered-io.c | 7 +------
>  fs/xfs/xfs_aops.c      | 2 +-
>  include/linux/iomap.h  | 5 +----

This iomap change needs to be cc'd to fsdevel just in case there's
anyone planning to use it.  To my knowledge gfs2 and zonefs don't use
io_private and don't have any plans to, but let's not yank the rug from
under them.

(Code change looks good to me, fwiw)

--D

>  3 files changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 414769a6ad11..b7753a7907e2 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1134,9 +1134,7 @@ iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
>  }
>  
>  void
> -iomap_ioend_try_merge(struct iomap_ioend *ioend, struct list_head *more_ioends,
> -		void (*merge_private)(struct iomap_ioend *ioend,
> -				struct iomap_ioend *next))
> +iomap_ioend_try_merge(struct iomap_ioend *ioend, struct list_head *more_ioends)
>  {
>  	struct iomap_ioend *next;
>  
> @@ -1148,8 +1146,6 @@ iomap_ioend_try_merge(struct iomap_ioend *ioend, struct list_head *more_ioends,
>  			break;
>  		list_move_tail(&next->io_list, &ioend->io_list);
>  		ioend->io_size += next->io_size;
> -		if (next->io_private && merge_private)
> -			merge_private(ioend, next);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(iomap_ioend_try_merge);
> @@ -1235,7 +1231,6 @@ iomap_alloc_ioend(struct inode *inode, struct iomap_writepage_ctx *wpc,
>  	ioend->io_inode = inode;
>  	ioend->io_size = 0;
>  	ioend->io_offset = offset;
> -	ioend->io_private = NULL;
>  	ioend->io_bio = bio;
>  	return ioend;
>  }
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 87c2912f147d..e24e0a005b48 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -146,7 +146,7 @@ xfs_end_io(
>  	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
>  			io_list))) {
>  		list_del_init(&ioend->io_list);
> -		iomap_ioend_try_merge(ioend, &tmp, NULL);
> +		iomap_ioend_try_merge(ioend, &tmp);
>  		xfs_end_ioend(ioend);
>  	}
>  }
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index d202fd2d0f91..c87d0cb0de6d 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -198,7 +198,6 @@ struct iomap_ioend {
>  	struct inode		*io_inode;	/* file being written to */
>  	size_t			io_size;	/* size of the extent */
>  	loff_t			io_offset;	/* offset in the file */
> -	void			*io_private;	/* file system private data */
>  	struct bio		*io_bio;	/* bio being built */
>  	struct bio		io_inline_bio;	/* MUST BE LAST! */
>  };
> @@ -234,9 +233,7 @@ struct iomap_writepage_ctx {
>  
>  void iomap_finish_ioends(struct iomap_ioend *ioend, int error);
>  void iomap_ioend_try_merge(struct iomap_ioend *ioend,
> -		struct list_head *more_ioends,
> -		void (*merge_private)(struct iomap_ioend *ioend,
> -				struct iomap_ioend *next));
> +		struct list_head *more_ioends);
>  void iomap_sort_ioends(struct list_head *ioend_list);
>  int iomap_writepage(struct page *page, struct writeback_control *wbc,
>  		struct iomap_writepage_ctx *wpc,
> -- 
> 2.26.3
> 
