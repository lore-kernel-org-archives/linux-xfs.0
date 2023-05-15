Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7538BC77B7D
	for <linux-xfs@archiver.kernel.org>; Mon, 15 May 2023 15:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240326AbjEOPNj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 May 2023 11:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjEOPNi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2023 11:13:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEBC19B1
        for <linux-xfs@vger.kernel.org>; Mon, 15 May 2023 08:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684163572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1zWXPZ+hKj8mW1OufbAklQelyenp0i4mqdPLh4AzjOM=;
        b=LbiMrZLxtzFxfES+etbSn5jvFCmDv0sGUwA1nhiAq7PlxRux4iBILAh9zT66gSHMAxxmWD
        EtQ/KSx6ZUVnHZ074SfCNDmA4ul25tR677EFANqg8HWYauZ+dWUVhS2fR4vzGJUKcU8JYu
        7v2tDoKkIvQ+j78I9Sc9nk6r0WBd2e4=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-oMmIRhUOP9eikrvvNH1tfA-1; Mon, 15 May 2023 11:12:48 -0400
X-MC-Unique: oMmIRhUOP9eikrvvNH1tfA-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-436558e7cf3so201478137.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 May 2023 08:12:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684163568; x=1686755568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zWXPZ+hKj8mW1OufbAklQelyenp0i4mqdPLh4AzjOM=;
        b=AHu8ZpRjLMv81NHWSDeOdkrhVdFZkh56DwGCkIrrnqNdNkm72CwGIYkMqpjK7n6xTU
         YAXh4MHwQfbbrRG8wYhzHrKGNwuUPVaUh0tIz/YOXVf+VQex4j79QyU0ZynTjzBc6hIT
         l++rsT9eY6ue21sgTDRguGta6hPdzx35gXxekd8iVnHDW8HdOzubarQNazdA2r/KLgb5
         LQXH7RO51bMOVyggGqA1FKidxl9F5SUAlYJ+ZabAu7EkqLGjVn1j8l/hOXmleL9TniBj
         Y61wv9cJQI7GRLwVH5aIb94NgZiOuwlndzR9DGw1iWAfGYLaMvvjaoKsOQ0fODqVqzv+
         0cQg==
X-Gm-Message-State: AC+VfDx3XDD1OpJCIg3y0D5ruC6UsQn10N+1IQlaTelMEFX9hVMOjmGF
        DY1vbyzRsNHg5NtM0V4wQ7xDoYKwwV150+d4GfBJouxAkTo7DBy2SnKGjNzE+dfThRT1+1vHMxX
        8YhSTr+BIwAfgYF9Jvfsj
X-Received: by 2002:a67:b44d:0:b0:434:87e4:ffda with SMTP id c13-20020a67b44d000000b0043487e4ffdamr12060628vsm.26.1684163567812;
        Mon, 15 May 2023 08:12:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4ux7weiYQBkUcfKsjuuAAA4XG3YsqSI7XlMm/H0AXO8ebcJxtHr0/YjRf3EOBgt6NpQ/suaA==
X-Received: by 2002:a67:b44d:0:b0:434:87e4:ffda with SMTP id c13-20020a67b44d000000b0043487e4ffdamr12060603vsm.26.1684163567474;
        Mon, 15 May 2023 08:12:47 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id s1-20020a05620a030100b00759333a57adsm17816qkm.11.2023.05.15.08.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 08:12:46 -0700 (PDT)
Date:   Mon, 15 May 2023 11:15:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Disha Goel <disgoel@linux.ibm.com>,
        Aravinda Herle <araherle@in.ibm.com>
Subject: Re: [RFCv5 5/5] iomap: Add per-block dirty state tracking to improve
 performance
Message-ID: <ZGJMg2G4XVeFnMcY@bfoster>
References: <cover.1683485700.git.ritesh.list@gmail.com>
 <86987466d8d7863bd0dca81e9d6c3eff7abd4964.1683485700.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86987466d8d7863bd0dca81e9d6c3eff7abd4964.1683485700.git.ritesh.list@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 08, 2023 at 12:58:00AM +0530, Ritesh Harjani (IBM) wrote:
> When filesystem blocksize is less than folio size (either with
> mapping_large_folio_support() or with blocksize < pagesize) and when the
> folio is uptodate in pagecache, then even a byte write can cause
> an entire folio to be written to disk during writeback. This happens
> because we currently don't have a mechanism to track per-block dirty
> state within struct iomap_page. We currently only track uptodate state.
> 
> This patch implements support for tracking per-block dirty state in
> iomap_page->state bitmap. This should help improve the filesystem write
> performance and help reduce write amplification.
> 
> Performance testing of below fio workload reveals ~16x performance
> improvement using nvme with XFS (4k blocksize) on Power (64K pagesize)
> FIO reported write bw scores improved from around ~28 MBps to ~452 MBps.
> 
> 1. <test_randwrite.fio>
> [global]
> 	ioengine=psync
> 	rw=randwrite
> 	overwrite=1
> 	pre_read=1
> 	direct=0
> 	bs=4k
> 	size=1G
> 	dir=./
> 	numjobs=8
> 	fdatasync=1
> 	runtime=60
> 	iodepth=64
> 	group_reporting=1
> 
> [fio-run]
> 
> 2. Also our internal performance team reported that this patch improves
>    their database workload performance by around ~83% (with XFS on Power)
> 
> Reported-by: Aravinda Herle <araherle@in.ibm.com>
> Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  fs/gfs2/aops.c         |   2 +-
>  fs/iomap/buffered-io.c | 115 ++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_aops.c      |   2 +-
>  fs/zonefs/file.c       |   2 +-
>  include/linux/iomap.h  |   1 +
>  5 files changed, 112 insertions(+), 10 deletions(-)
> 
...
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 25f20f269214..c7f41b26280a 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
...
> @@ -119,12 +169,20 @@ static struct iomap_page *iop_alloc(struct inode *inode, struct folio *folio,
>  	else
>  		gfp = GFP_NOFS | __GFP_NOFAIL;
> 
> -	iop = kzalloc(struct_size(iop, state, BITS_TO_LONGS(nr_blocks)),
> +	/*
> +	 * iop->state tracks two sets of state flags when the
> +	 * filesystem block size is smaller than the folio size.
> +	 * The first state tracks per-block uptodate and the
> +	 * second tracks per-block dirty state.
> +	 */
> +	iop = kzalloc(struct_size(iop, state, BITS_TO_LONGS(2 * nr_blocks)),
>  		      gfp);
>  	if (iop) {
>  		spin_lock_init(&iop->state_lock);
>  		if (folio_test_uptodate(folio))
>  			iop_set_range(iop, 0, nr_blocks);
> +		if (is_dirty)
> +			iop_set_range(iop, nr_blocks, nr_blocks);

I find the is_dirty logic here a bit confusing. AFAICT, this is
primarily to handle the case where a folio is completely overwritten, so
no iop is allocated at write time, and so then writeback needs to
allocate the iop as fully dirty to reflect that. I.e., all iop_alloc()
callers other than iomap_writepage_map() either pass the result of
folio_test_dirty() or explicitly dirty the entire range of the folio
anyways.  iomap_dirty_folio() essentially does the latter because it
needs to dirty the entire folio regardless of whether the iop already
exists or not, right?

If so and if I'm following all of that correctly, could this complexity
be isolated to iomap_writepage_map() by simply checking for the !iop
case first, then call iop_alloc() immediately followed by
set_range_dirty() of the entire folio? Then presumably iop_alloc() could
always just dirty based on folio state with the writeback path exception
case handled explicitly. Hm?

>  		folio_attach_private(folio, iop);
>  	}
>  	return iop;
...
> @@ -561,6 +621,18 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len)
>  }
>  EXPORT_SYMBOL_GPL(iomap_invalidate_folio);
> 
> +bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio)
> +{
> +	struct iomap_page *iop;
> +	struct inode *inode = mapping->host;
> +	size_t len = i_blocks_per_folio(inode, folio) << inode->i_blkbits;

folio_size()?

> +
> +	iop = iop_alloc(inode, folio, 0, false);
> +	iop_set_range_dirty(inode, folio, 0, len);
> +	return filemap_dirty_folio(mapping, folio);
> +}
> +EXPORT_SYMBOL_GPL(iomap_dirty_folio);
> +
>  static void
>  iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
>  {
...
> @@ -978,6 +1056,28 @@ static int iomap_write_delalloc_scan(struct inode *inode,
>  				}
>  			}
> 
> +			/*
> +			 * When we have per-block dirty tracking, there can be
> +			 * blocks within a folio which are marked uptodate
> +			 * but not dirty. In that case it is necessary to punch
> +			 * out such blocks to avoid leaking any delalloc blocks.
> +			 */
> +			iop = to_iomap_page(folio);
> +			if (!iop)
> +				goto skip_iop_punch;
> +			last_byte = min_t(loff_t, end_byte - 1,
> +				(folio_next_index(folio) << PAGE_SHIFT) - 1);
> +			first_blk = offset_in_folio(folio, start_byte) >>
> +						    blkbits;
> +			last_blk = offset_in_folio(folio, last_byte) >>
> +						   blkbits;
> +			blks_per_folio = i_blocks_per_folio(inode, folio);

Unused?

> +			for (i = first_blk; i <= last_blk; i++) {
> +				if (!iop_test_block_dirty(folio, i))
> +					punch(inode, i << blkbits,
> +						     1 << blkbits);
> +			}
> +skip_iop_punch:

Looks reasonable at first glance, though the deep indentation here kind
of makes my eyes cross. Could we stuff this loop into a
iomap_write_delalloc_scan_folio() helper or some such, and then maybe
update the comment at the top of the whole branch to explain both
punches?

WRT to the !iop case.. I _think_ this is handled correctly here because
that means we'd handle the folio as completely dirty at writeback time.
Is that the case? If so, it might be nice to document that assumption
somewhere (here or perhaps in the writeback path).

Brian

>  			/*
>  			 * Make sure the next punch start is correctly bound to
>  			 * the end of this data range, not the end of the folio.
> @@ -1666,7 +1766,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  		struct writeback_control *wbc, struct inode *inode,
>  		struct folio *folio, u64 end_pos)
>  {
> -	struct iomap_page *iop = iop_alloc(inode, folio, 0);
> +	struct iomap_page *iop = iop_alloc(inode, folio, 0, true);
>  	struct iomap_ioend *ioend, *next;
>  	unsigned len = i_blocksize(inode);
>  	unsigned nblocks = i_blocks_per_folio(inode, folio);
> @@ -1682,7 +1782,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  	 * invalid, grab a new one.
>  	 */
>  	for (i = 0; i < nblocks && pos < end_pos; i++, pos += len) {
> -		if (iop && !iop_test_block_uptodate(folio, i))
> +		if (iop && !iop_test_block_dirty(folio, i))
>  			continue;
> 
>  		error = wpc->ops->map_blocks(wpc, inode, pos);
> @@ -1726,6 +1826,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  		}
>  	}
> 
> +	iop_clear_range_dirty(folio, 0, end_pos - folio_pos(folio));
>  	folio_start_writeback(folio);
>  	folio_unlock(folio);
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 2ef78aa1d3f6..77c7332ae197 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -578,7 +578,7 @@ const struct address_space_operations xfs_address_space_operations = {
>  	.read_folio		= xfs_vm_read_folio,
>  	.readahead		= xfs_vm_readahead,
>  	.writepages		= xfs_vm_writepages,
> -	.dirty_folio		= filemap_dirty_folio,
> +	.dirty_folio		= iomap_dirty_folio,
>  	.release_folio		= iomap_release_folio,
>  	.invalidate_folio	= iomap_invalidate_folio,
>  	.bmap			= xfs_vm_bmap,
> diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
> index 132f01d3461f..e508c8e97372 100644
> --- a/fs/zonefs/file.c
> +++ b/fs/zonefs/file.c
> @@ -175,7 +175,7 @@ const struct address_space_operations zonefs_file_aops = {
>  	.read_folio		= zonefs_read_folio,
>  	.readahead		= zonefs_readahead,
>  	.writepages		= zonefs_writepages,
> -	.dirty_folio		= filemap_dirty_folio,
> +	.dirty_folio		= iomap_dirty_folio,
>  	.release_folio		= iomap_release_folio,
>  	.invalidate_folio	= iomap_invalidate_folio,
>  	.migrate_folio		= filemap_migrate_folio,
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 0f8123504e5e..0c2bee80565c 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -264,6 +264,7 @@ bool iomap_is_partially_uptodate(struct folio *, size_t from, size_t count);
>  struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos);
>  bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
>  void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
> +bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio);
>  int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
>  		const struct iomap_ops *ops);
>  int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
> --
> 2.39.2
> 

