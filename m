Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBD531DDBC
	for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 14:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761316421; cv=none; b=I7kXsl0kCLHqLusgg5MjKqavtBQJVWv05xwf31JjnKd8ZMF6qe+bPI9zR0iWG49pvbONObPJQGnwJ7XcbBvMIlq8Aay4E6FyfvqmQ/ttiRw8vBwlIVIYpIz2S5G1YtvdwzSv/ldQMko8ldverY608tKIWzzM6zmqEeXni7hPi0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761316421; c=relaxed/simple;
	bh=e5Rif285Ee4PeQNih6azyBNfnA1JqjkHdSNFFYNZsnQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=gemmcG5t3WH7X/JiFU9P4PdiUZnrhgmMi8GvVGbt1SVUNstEKJSPNTjfHjRqyIN4AjfkElczuWdqgeUsq/urmLSEinpEJgZu73tQjrJ8IQxtNkb7fOs7kbfnQS2bTYoz5Sr1vVt79UrLix8JcQIar6ahnjEK0zWQXqVJP6b6ZjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hcAoWOuy; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hcAoWOuy"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-33be037cf73so2386543a91.2
        for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 07:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761316419; x=1761921219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OBa3HllmoLDrq9FnY3XyxI3+B1m8MLAu+gv0tRm7xcs=;
        b=hcAoWOuy+g3o3RfgzxD8XCmmc8sZxoIgeQ9vUVN8HZ1+DWer/nw0PijhAAhw8yuNwN
         0r0aMx8Yo7jGtIKgAb5GZDWKQQDP3b8EkjVG2ivjsPCx7M0Q+8QYEN5ubCqCIryBm+4F
         S7P2bkdxfXI9VKhA0SWoW4EHTEu8Mrm8IbG80lNsG7ah4R4XAi6BA48ede7bXCZOHarc
         eB5Gxqjmtjp0tKJYx5yrU/YhDfMPx1XoEtsCWVS7+HBka4fMR0l9bBb0BLqAXBnP5xFk
         cgVIXomtlHKElWkJyFlfg4rxhAjBgsVg8Wf4mzNYzXntvI26/89XU1dlVFhKqXQja5NJ
         5gSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761316419; x=1761921219;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OBa3HllmoLDrq9FnY3XyxI3+B1m8MLAu+gv0tRm7xcs=;
        b=cyKfYtBOMXO2OibTdFs0lVANC1qDqc1bIxPJ/3ChQQv+O72+vyvLsMvb0FyRZYcXOW
         fkb2nVT8FcFFjNWFrhmeYLb8yh9mpIurtZTSwyAz+NTWvXPF5OtGPAH1qHAlJv+YpmzC
         33m6YAd/ISxGC5dFKTsC2uTASnLGuHQ74QI8dTMvvEduM5g7Efl+bGh0g4mEaTwJYjHT
         4h6ukfBtRE9Q+/GlN1C+jeMBvtFUiUHcr94s4akDUyUQRG96prJPDhy3KBj7WslL22Wl
         E5q0u6lL9u/sIrAu5l36ueSIvNTHkaWCRfkegrlEjHZiqILX6W5XfZb3+RDUAct9su+3
         9DfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWA1Tb6VqIjFenOoCWhTH/CcFHNPIcWVn++UYzGr4TWEuKcb4hbKHxvfSuF8a7af844JdXUvHH0QYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbCRw/ixx0k0CoFRL1bGpE0mFhS3CQnEMXwmgpPjY4tTaoIQn4
	SB4X0FHn5cg43jOWWeVXfJC4fICZlVWk2JnSHlfND8fGiYTQzQ2p0+TF
X-Gm-Gg: ASbGnctXpE5yz54IJzppDs2j8bZ6pwNzedbC183/kvsXSOh/fRFpF9h9eebkFEA7jFT
	P5s3kKjXLCDAceeH+h8PKZNNReGKu/v4EUsu2zgHbAIKBHc7G+TT0klK4BeAr9k2K3Y9EqNSsyj
	7Gg+rnOaXir1XGPydJ6/b/+xrvuD0d+Y7jdvztDaGz9zrbdBPk204PQthoCEeEcvNBYKVw2aOyY
	c3947OAxBF0k5Z9XzKbe/r5HhQ0fu2QA0VXm7Tsr3sDySW50+kQdP/h1vcbTZbTOL1ZSImw00tX
	55UigXkoQbmp/L/KOk7F6HBLsPV/NL+138PekOvXYmU8KwrS4sQH0utKf6z+ealW2w3T7w1TerV
	xcAavCiL8/OatVT9I+It6Pw6zF2Zbt71YQcUnjuROWIqL7U2BOpz5lxliIKQZEu2EILDmctIoqA
	5kWl4onvieDP2TQEtyiSa9Js89nVg19Ii69JTQX+G4hmZwXSMjHrl3ZowoyJJll2E=
X-Google-Smtp-Source: AGHT+IHqM/Dr/7zI0QdtU2XvgPWrPkn/dWWd8IC38n+KsA38rQN80+eM8sij34CR1Do2DRiLEiMI1g==
X-Received: by 2002:a17:90b:5386:b0:32d:ea1c:a4e5 with SMTP id 98e67ed59e1d1-33bcf85128emr34116336a91.1.1761316419443;
        Fri, 24 Oct 2025 07:33:39 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6cf4bb9c71sm5343832a12.4.2025.10.24.07.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 07:33:38 -0700 (PDT)
Message-ID: <fba8631d9159c9bd8df98e4cf33a6ffedecac050.camel@gmail.com>
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>, 
	Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, 
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Fri, 24 Oct 2025 20:03:34 +0530
In-Reply-To: <20251017034611.651385-3-hch@lst.de>
References: <20251017034611.651385-1-hch@lst.de>
	 <20251017034611.651385-3-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2025-10-17 at 05:45 +0200, Christoph Hellwig wrote:
> The relatively low minimal writeback size of 4MiB means that written back
> inodes on rotational media are switched a lot.  Besides introducing
> additional seeks, this also can lead to extreme file fragmentation on
> zoned devices when a lot of files are cached relative to the available
> writeback bandwidth.
> 
> Add a superblock field that allows the file system to override the
> default size.
So this patch doesn't really explicitly set s_min_writeback_pages to a non-default/overridden value,
right? That is being done in the next patch, isn't it?
--NR
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/fs-writeback.c         | 14 +++++---------
>  fs/super.c                |  1 +
>  include/linux/fs.h        |  1 +
>  include/linux/writeback.h |  5 +++++
>  4 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 11fd08a0efb8..6d50b02cdab6 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -31,11 +31,6 @@
>  #include <linux/memcontrol.h>
>  #include "internal.h"
>  
> -/*
> - * 4MB minimal write chunk size
> - */
> -#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_SHIFT - 10))
> -
>  /*
>   * Passed into wb_writeback(), essentially a subset of writeback_control
>   */
> @@ -1874,8 +1869,8 @@ static int writeback_single_inode(struct inode *inode,
>  	return ret;
>  }
>  
> -static long writeback_chunk_size(struct bdi_writeback *wb,
> -				 struct wb_writeback_work *work)
> +static long writeback_chunk_size(struct super_block *sb,
> +		struct bdi_writeback *wb, struct wb_writeback_work *work)
>  {
>  	long pages;
>  
> @@ -1898,7 +1893,8 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
>  	pages = min(wb->avg_write_bandwidth / 2,
>  		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
>  	pages = min(pages, work->nr_pages);
> -	return round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
> +	return round_down(pages + sb->s_min_writeback_pages,
> +			sb->s_min_writeback_pages);
>  }
>  
>  /*
> @@ -2000,7 +1996,7 @@ static long writeback_sb_inodes(struct super_block *sb,
>  		inode->i_state |= I_SYNC;
>  		wbc_attach_and_unlock_inode(&wbc, inode);
>  
> -		write_chunk = writeback_chunk_size(wb, work);
> +		write_chunk = writeback_chunk_size(inode->i_sb, wb, work);
>  		wbc.nr_to_write = write_chunk;
>  		wbc.pages_skipped = 0;
>  
> diff --git a/fs/super.c b/fs/super.c
> index 5bab94fb7e03..599c1d2641fe 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -389,6 +389,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
>  		goto fail;
>  	if (list_lru_init_memcg(&s->s_inode_lru, s->s_shrink))
>  		goto fail;
> +	s->s_min_writeback_pages = MIN_WRITEBACK_PAGES;
>  	return s;
>  
>  fail:
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c895146c1444..ae6f37c6eaa4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1583,6 +1583,7 @@ struct super_block {
>  
>  	spinlock_t		s_inode_wblist_lock;
>  	struct list_head	s_inodes_wb;	/* writeback inodes */
> +	long			s_min_writeback_pages;
>  } __randomize_layout;
>  
>  static inline struct user_namespace *i_user_ns(const struct inode *inode)
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index 22dd4adc5667..49e1dd96f43e 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -374,4 +374,9 @@ bool redirty_page_for_writepage(struct writeback_control *, struct page *);
>  void sb_mark_inode_writeback(struct inode *inode);
>  void sb_clear_inode_writeback(struct inode *inode);
>  
> +/*
> + * 4MB minimal write chunk size
> + */
> +#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_SHIFT - 10))
> +
>  #endif		/* WRITEBACK_H */

