Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6662D3DC4C8;
	Mon, 27 Jul 2026 22:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785191265; cv=none; b=dSNcjUUpFemspqCnl8qpDyixqC6MEtgMb6/d1HTJTgJqf7Q1iStMPkKrMJvNC+S9ji3l7+AjE98/Rv4iZLBQW1fcvJ2SU5R4ku95flooT2HVnxhXFqDfPeB56G/iLeBrZCug0KxJlHe7jH5mx1E0Z+pL5CuyQKMsztRS7u/QOSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785191265; c=relaxed/simple;
	bh=S2D+CBQMrw14FTgTfJ0hZVZvwjHB8TGxTIWlJ+ZWJEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QixubBf58+xlBYmL6WeTPlNnmBK7gpQqr/AlKIG2ivCSNgwS3fmg8JaA1mDibSu4GbpTG0VznYG/kH34Dq/eLYJUNmsfAHYOc9okHtad+Z2m3asQRulsz9qo2uaQI46Pj2EDLAwKDcwQPxQSmXXZ1PbDPP/eSuF1B8o8IzB9egs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVIO9qYs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVIO9qYs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E6C321F000E9;
	Mon, 27 Jul 2026 22:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785191264;
	bh=pag/+fzHwPE/vDaa2l0xBCISQ94B6iSC1RRi04354hA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bVIO9qYsOobUl1Pxvp11/KPjLkd9z6pda8iMETX+nmJMOQ2XthrdmNm4y3Tp0AvYS
	 ko7WdCEBcu39qeocB6DLYlGPBTMdMCYCR7qnt3e+UwOlEnrO2ycJfznEBCmK7zz85s
	 Sue4FoiMa1lY7fw07zisxi600cFu2QQ7m6Rn0Lzwpx4Jgd5zsmg1DkxUh4yXMd3Jo4
	 aMULw5OWJoZ0vTFBFoNDdWE2HOfN4h3NsTtf0vfu+uVPAI2SyTl8ruelcvkj5h60KN
	 kkD4B8vbzm++x/xt4Pryv0v+LElX5lUEAbU6VjhPW3Myj8fHqxUuHTqjlqVu+mE104
	 v5loDs1xbsR1A==
Date: Mon, 27 Jul 2026 15:27:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, hch@lst.de,
	linux-fsdevel@vger.kernel.org, changfengnan@bytedance.com,
	kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>, tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 04/21] iomap: add ->iomap_next()
Message-ID: <20260727222743.GF2901224@frogsfrogsfrogs>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
 <20260727211758.1116539-5-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727211758.1116539-5-joannelkoong@gmail.com>

On Mon, Jul 27, 2026 at 02:17:41PM -0700, Joanne Koong wrote:
> Have one ->iomap_next() callback instead of ->iomap_begin() and
> ->iomap_end(). ->iomap_next() finishes the previous mapping if needed,
> and produces the next mapping.
> 
> Collapsing to a single callback lets a performance-critical caller
> inline its iteration loop and pass its ->iomap_next() function as a
> compile-time constant, so the compiler can devirtualize that callback
> into a direct call instead of an indirect call through a function
> pointer.
> 
> iomap_iter() uses ->iomap_next() when the filesystem provides that
> callback and otherwise falls back to the ->iomap_begin()/->iomap_end()
> path, so filesystems can be converted one at a time.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Looks great!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/iter.c       | 8 ++++++--
>  include/linux/iomap.h | 9 +++++++++
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> index 66ccb87441ab..e05574602946 100644
> --- a/fs/iomap/iter.c
> +++ b/fs/iomap/iter.c
> @@ -107,8 +107,12 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
>  
>  	trace_iomap_iter(iter, ops, _RET_IP_);
>  
> -	ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
> -			ops->iomap_begin, ops->iomap_end);
> +	if (ops->iomap_next)
> +		ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
> +	else
> +		ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
> +				ops->iomap_begin, ops->iomap_end);
> +
>  	iter->status = 0;
>  	if (ret > 0)
>  		iomap_iter_done(iter);
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 80832edc7ec2..d203d9fe0f89 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -231,9 +231,18 @@ typedef int (*iomap_iter_begin_fn)(struct inode *inode, loff_t pos,
>  typedef int (*iomap_iter_end_fn)(struct inode *inode, loff_t pos, loff_t length,
>  		ssize_t written, unsigned flags, struct iomap *iomap);
>  
> +/*
> + * Produce the next mapping (finishing the previous one if needed).
> + * Return 1 to continue iterating, 0 if the range is fully consumed, or a
> + * negative error on failure.
> + */
> +typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
> +		struct iomap *iomap, struct iomap *srcmap);
> +
>  struct iomap_ops {
>  	iomap_iter_begin_fn iomap_begin;
>  	iomap_iter_end_fn iomap_end;
> +	iomap_iter_next_fn iomap_next;
>  };
>  
>  /**
> -- 
> 2.52.0
> 
> 
