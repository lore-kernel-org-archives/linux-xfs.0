Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D94249EB
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731514349; cv=none; b=SLt7Qm2X4fFmP9z49JUqkNfEc261nh6QPF5nxUhm8yc7m93bQ36hbZnUXJ6r210IMTYXmjIpcfV06QqK55iu4OHIV/hk+d1BlPDLd8DVR+jkVoFpzQyV/fQilNuu15k3DTwl95kV8q4ZDKXSAWTQdHYdtzx2jsK2x8NL0tBGJj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731514349; c=relaxed/simple;
	bh=YG7xNYdzUZaxC42kJX2IoFm7Ro58CDWHon85JeOG7UQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPNEGR5hnYPF11xTOR1IyFaggg6wKU7mI7k1nmNjcPx8yKf6x+W0Onu2RRFnwTu+/4o1SG/uLXBVB3gNWAHO5rIJh7HaJsHHtNciIwj9oGq4XmmGnqWxYxb+LbNPxaH9wxXrvIO2dlRpsMO4GOtx6W4n2c/uGWTsU+K0j6Lg65Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FdkaxBls; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FdkaxBls"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731514346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LBUg+yYwVEJ+Qz+l5mxDN3j7+eM4Rv073pYPlQYxwOY=;
	b=FdkaxBlse4ANqejqy+jfTC6OzEng2DhhaC/+K0KXlF6xL3M9xrmgAxerTD+8mPmPO/4gad
	ASVS2opdP5zif3iHUpPcisdfvyG5rLaBZ7VWeZJrH+6OzLYw2CVLq26+OURdhPmvrjJkIF
	ANmh6XBvXPxLp3SO7wHDLpeyiTBrqmU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-WwA7JqMsP1WybDZZLSomTw-1; Wed,
 13 Nov 2024 11:12:21 -0500
X-MC-Unique: WwA7JqMsP1WybDZZLSomTw-1
X-Mimecast-MFC-AGG-ID: WwA7JqMsP1WybDZZLSomTw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35DDB1955EE7;
	Wed, 13 Nov 2024 16:12:19 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.120])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 420FD19560A3;
	Wed, 13 Nov 2024 16:12:17 +0000 (UTC)
Date: Wed, 13 Nov 2024 11:13:49 -0500
From: Brian Foster <bfoster@redhat.com>
To: Long Li <leo.lilong@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <ZzTQPdE5V155Soui@bfoster>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113091907.56937-1-leo.lilong@huawei.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

FYI, you probably want to include linux-fsdevel on iomap patches.

On Wed, Nov 13, 2024 at 05:19:06PM +0800, Long Li wrote:
> During concurrent append writes to XFS filesystem, zero padding data
> may appear in the file after power failure. This happens due to imprecise
> disk size updates when handling write completion.
> 
> Consider this scenario with concurrent append writes same file:
> 
>   Thread 1:                  Thread 2:
>   ------------               -----------
>   write [A, A+B]
>   update inode size to A+B
>   submit I/O [A, A+BS]
>                              write [A+B, A+B+C]
>                              update inode size to A+B+C
>   <I/O completes, updates disk size to A+B+C>
>   <power failure>
> 
> After reboot, file has zero padding in range [A+B, A+B+C]:
> 
>   |<         Block Size (BS)      >|
>   |DDDDDDDDDDDDDDDD0000000000000000|
>   ^               ^        ^
>   A              A+B      A+B+C (EOF)
> 

Thanks for the diagram. FWIW, I found the description a little confusing
because A+B+C to me implies that we'd update i_size to the end of the
write from thread 2, but it seems that is only true up to the end of the
block.

I.e., with 4k FSB and if thread 1 writes [0, 2k], then thread 2 writes
from [2, 16k], the write completion from the thread 1 write will set
i_size to 4k, not 16k, right?

>   D = Valid Data
>   0 = Zero Padding
> 
> The issue stems from disk size being set to min(io_offset + io_size,
> inode->i_size) at I/O completion. Since io_offset+io_size is block
> size granularity, it may exceed the actual valid file data size. In
> the case of concurrent append writes, inode->i_size may be larger
> than the actual range of valid file data written to disk, leading to
> inaccurate disk size updates.
> 
> This patch changes the meaning of io_size to represent the size of
> valid data in ioend, while the extent size of ioend can be obtained
> by rounding up based on block size. It ensures more precise disk
> size updates and avoids the zero padding issue.  Another benefit is
> that it makes the xfs_ioend_is_append() check more accurate, which
> can reduce unnecessary end bio callbacks of xfs_end_bio() in certain
> scenarios, such as repeated writes at the file tail without extending
> the file size.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/iomap/buffered-io.c | 21 +++++++++++++++------
>  include/linux/iomap.h  |  7 ++++++-
>  2 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index ce73d2a48c1e..a2a75876cda6 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1599,6 +1599,8 @@ EXPORT_SYMBOL_GPL(iomap_finish_ioends);
>  static bool
>  iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
>  {
> +	size_t size = iomap_ioend_extent_size(ioend);
> +

The function name is kind of misleading IMO because this may not
necessarily reflect "extent size." Maybe something like
_ioend_size_aligned() would be more accurate..?

I also find it moderately annoying that we have to change pretty much
every usage of this field to use the wrapper just so the setfilesize
path can do the right thing. Though I see that was an explicit request
from v1 to avoid a new field, so it's not the biggest deal.

What urks me a bit are:

1. It kind of feels like a landmine in an area where block alignment is
typically expected. I wonder if a rename to something like io_bytes
would help at all with that.

2. Some of the rounding sites below sort of feel gratuitous. For
example, if we run through the _add_to_ioend() path where we actually
trim off bytes from the EOF block due to i_size, would we ever expect to
tack more onto that ioend such that the iomap_ioend_extent_size() calls
are actually effective? It kind of seems like something is wrong in that
case where the wrapper call actually matters, but maybe I'm missing
something.

Another randomish idea might be to define a flag like
IOMAP_F_EOF_TRIMMED for ioends that are trimmed to EOF. Then perhaps we
could make an explicit decision not to grow or merge such ioends, and
let the associated code use io_size as is.

But I dunno.. just thinking out loud. I'm ambivalent on all of the above
so I'm just sharing thoughts in the event that it triggers more
thoughts/ideas/useful discussion. I'd probably not change anything
until/unless others chime in on any of this...

Brian

>  	if (ioend->io_bio.bi_status != next->io_bio.bi_status)
>  		return false;
>  	if ((ioend->io_flags & IOMAP_F_SHARED) ^
> @@ -1607,7 +1609,7 @@ iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
>  	if ((ioend->io_type == IOMAP_UNWRITTEN) ^
>  	    (next->io_type == IOMAP_UNWRITTEN))
>  		return false;
> -	if (ioend->io_offset + ioend->io_size != next->io_offset)
> +	if (ioend->io_offset + size != next->io_offset)
>  		return false;
>  	/*
>  	 * Do not merge physically discontiguous ioends. The filesystem
> @@ -1619,7 +1621,7 @@ iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
>  	 * submission so does not point to the start sector of the bio at
>  	 * completion.
>  	 */
> -	if (ioend->io_sector + (ioend->io_size >> 9) != next->io_sector)
> +	if (ioend->io_sector + (size >> 9) != next->io_sector)
>  		return false;
>  	return true;
>  }
> @@ -1636,7 +1638,7 @@ iomap_ioend_try_merge(struct iomap_ioend *ioend, struct list_head *more_ioends)
>  		if (!iomap_ioend_can_merge(ioend, next))
>  			break;
>  		list_move_tail(&next->io_list, &ioend->io_list);
> -		ioend->io_size += next->io_size;
> +		ioend->io_size = iomap_ioend_extent_size(ioend) + next->io_size;
>  	}
>  }
>  EXPORT_SYMBOL_GPL(iomap_ioend_try_merge);
> @@ -1736,7 +1738,7 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos)
>  		return false;
>  	if (wpc->iomap.type != wpc->ioend->io_type)
>  		return false;
> -	if (pos != wpc->ioend->io_offset + wpc->ioend->io_size)
> +	if (pos != wpc->ioend->io_offset + iomap_ioend_extent_size(wpc->ioend))
>  		return false;
>  	if (iomap_sector(&wpc->iomap, pos) !=
>  	    bio_end_sector(&wpc->ioend->io_bio))
> @@ -1768,6 +1770,8 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
>  {
>  	struct iomap_folio_state *ifs = folio->private;
>  	size_t poff = offset_in_folio(folio, pos);
> +	loff_t isize = i_size_read(inode);
> +	struct iomap_ioend *ioend;
>  	int error;
>  
>  	if (!wpc->ioend || !iomap_can_add_to_ioend(wpc, pos)) {
> @@ -1778,12 +1782,17 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
>  		wpc->ioend = iomap_alloc_ioend(wpc, wbc, inode, pos);
>  	}
>  
> -	if (!bio_add_folio(&wpc->ioend->io_bio, folio, len, poff))
> +	ioend = wpc->ioend;
> +	if (!bio_add_folio(&ioend->io_bio, folio, len, poff))
>  		goto new_ioend;
>  
>  	if (ifs)
>  		atomic_add(len, &ifs->write_bytes_pending);
> -	wpc->ioend->io_size += len;
> +
> +	ioend->io_size = iomap_ioend_extent_size(ioend) + len;
> +	if (ioend->io_offset + ioend->io_size > isize)
> +		ioend->io_size = isize - ioend->io_offset;
> +
>  	wbc_account_cgroup_owner(wbc, folio, len);
>  	return 0;
>  }
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index f61407e3b121..2984eccfa213 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -330,7 +330,7 @@ struct iomap_ioend {
>  	u16			io_type;
>  	u16			io_flags;	/* IOMAP_F_* */
>  	struct inode		*io_inode;	/* file being written to */
> -	size_t			io_size;	/* size of the extent */
> +	size_t			io_size;	/* size of valid data */
>  	loff_t			io_offset;	/* offset in the file */
>  	sector_t		io_sector;	/* start sector of ioend */
>  	struct bio		io_bio;		/* MUST BE LAST! */
> @@ -341,6 +341,11 @@ static inline struct iomap_ioend *iomap_ioend_from_bio(struct bio *bio)
>  	return container_of(bio, struct iomap_ioend, io_bio);
>  }
>  
> +static inline size_t iomap_ioend_extent_size(struct iomap_ioend *ioend)
> +{
> +	return round_up(ioend->io_size, i_blocksize(ioend->io_inode));
> +}
> +
>  struct iomap_writeback_ops {
>  	/*
>  	 * Required, maps the blocks so that writeback can be performed on
> -- 
> 2.39.2
> 
> 

