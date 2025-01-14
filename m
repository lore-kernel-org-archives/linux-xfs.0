Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F1F24024E
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 00:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736814258; cv=none; b=O1/IUF6TazmU09QE4W3y2a/pf5TN+cXk/yvPPqQUPTpyZTdzMNkx+yTFtTdFSVy7eW2lFaK6exVBlQkpcwU08CZVUTcfMTRnTd3tEhrwwYKXO03PekmE9eoWxeCSZjJFpIKv944k+zR2a3NvLReLvPHmvdyWBLxVa2Caybr3LcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736814258; c=relaxed/simple;
	bh=szAJpOSdmAgfaqbb46zzq3DxNk9NMGIqyUIOU9zCrTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gkwrxl/DAi/ZuXz3zmzR01XiTgvJiY6zCe7I6joJP0HGwCEu2d0zC7ewDjVRbKXaCrArRwWP04DOqK+dbQs+jb2MI9QZeQRkrq861lNcjDGzhQnJ6r66TIkucp6H5oRu7p7hJxgIuu4QneGewcubMnsb94DlsZSBLOn6QFXxGzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=k2ZsuoHc; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="k2ZsuoHc"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21bc1512a63so22151515ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 16:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736814256; x=1737419056; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pYpZ/6d7A13ea8bJgcLtOpzSf9Qfmy9yleOBT2PCUMk=;
        b=k2ZsuoHcJUWfVR3ZyKYPAdMmjbZIJQVAaauiEI+jZysBtVPO3KOD6wW3JCJ433b9Zq
         cCeZ1ybnHzQBViqkWlK3X803c6erx4qik0xS/HvgbGhX+heUOSFw4tZX/9r911SLJGan
         1HUss4iZFude+Mz5/plRYPtFUJ3KBR9zBbLEB5xGJ6LqVEuw9q61yD1hZhPIXYBWSVBe
         GPI2cwZ/5HONf/H2qsUmaXIXE4LgEToG6qp3tWPR8+WMrcTRM1LdE1zGtIepCgAfZMZA
         cx1D+1Z8HUtut79ndidZOz2ORsUqf6AfwHHhTPYFO/hp5T5UB/bluCsMJ1l3t36qX1V3
         k6WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736814256; x=1737419056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pYpZ/6d7A13ea8bJgcLtOpzSf9Qfmy9yleOBT2PCUMk=;
        b=O9wYzx3Eax8Pp+QS29ptHHxBzzPszKWYMWYVd9HTINU8bVZYYQL6Tqt7CmSwXhqh0s
         vx7XnEXRthlIUD8R0D6hetw9eAnfRy9Ymm9mLI//Phm5bCsyk5jgkyEw/G7nz3An96FX
         NQDohOeIBJGtOaAHx+iE9eXoNtj0H+Wt5WaqvPelsdwgumqTJuGgx/Pq8f5IE1MJPc8K
         xycKoxDMj4dMfEnl28khewgMgCxZJ5xry0T46L96rYcDfvbXyGqLe6qp4T7SwSe+gO7c
         3bCnCrFEaA9xtNgiOZufUsidHMrTk8wN4loL8/fwgDIrZ4YXE4BsWWPvHxdtkNEka4jV
         v+vA==
X-Forwarded-Encrypted: i=1; AJvYcCV9rgrH+V26faF+a1rssRhT9iFy5COX9W7gsBPfLxETUdLSwybb/yFkImifXxhmyADqp8hgiyX7tj8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2Ep5LQEUS0kdXSp9TwdGaxGtzLNtXT7vHTMysKWr4y7ws2uy4
	49NR1nudopjrfoJQ34WWihxyZGbmugm5eQYS8n94v7EwFDJhd730iK0JWviOFnyJ/1qOWCJSaIF
	3
X-Gm-Gg: ASbGnctAAYMYSPsHovPahFieY7j9UvyDTdquJTKeZr/VNWoegpzYQdHqYM89jGtwoMg
	NzImEfQe+8y6XR1HZnIBVRb5a9BYkFCz7nOuTdq7aUNDeWq30trtgft6AnbUcLEXrCY3HKgN9eH
	O84js7ZPq81mn3TvJUP2X7bjN4+1sPD0huG6wVQFZIDldcOqc097NyROT35pQVI2Gxzme7N9fxJ
	V2AmtZz4uEdpTbDYGNGXSuk895D5bG0Pjauu3O0p7xsxe/icO1YhS5D8XrzX4sMAVzoXHLx5RwF
	QwY/xr/LGB4KltCsfsYrnw==
X-Google-Smtp-Source: AGHT+IFMppQP2kxwbiZfXwSQxFibKD9fkU2Ef+hCY05BF9UqjfoGrh8t58mYjmueInaNqSN1xVwARA==
X-Received: by 2002:a05:6a20:3942:b0:1dc:2a02:913b with SMTP id adf61e73a8af0-1e88d10e966mr31176580637.15.1736814256487;
        Mon, 13 Jan 2025 16:24:16 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a318e056063sm6324935a12.31.2025.01.13.16.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 16:24:16 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tXUj7-00000005Xzt-2dt5;
	Tue, 14 Jan 2025 11:24:13 +1100
Date: Tue, 14 Jan 2025 11:24:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: check for dead buffers in xfs_buf_find_insert
Message-ID: <Z4WurfJbDa_77CSj@dread.disaster.area>
References: <20250113042542.2051287-1-hch@lst.de>
 <20250113042542.2051287-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113042542.2051287-2-hch@lst.de>

On Mon, Jan 13, 2025 at 05:24:26AM +0100, Christoph Hellwig wrote:
> Commit 32dd4f9c506b ("xfs: remove a superflous hash lookup when inserting
> new buffers") converted xfs_buf_find_insert to use
> rhashtable_lookup_get_insert_fast and thus an operation that returns the
> existing buffer when an insert would duplicate the hash key.  But this
> code path misses the check for a buffer with a reference count of zero,
> which could lead to reusing an about to be freed buffer.  Fix this by
> using the same atomic_inc_not_zero pattern as xfs_buf_insert.
> 
> Fixes: 32dd4f9c506b ("xfs: remove a superflous hash lookup when inserting new buffers")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 6f313fbf7669..f80e39fde53b 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -664,9 +664,8 @@ xfs_buf_find_insert(
>  		spin_unlock(&bch->bc_lock);
>  		goto out_free_buf;
>  	}
> -	if (bp) {
> +	if (bp && atomic_inc_not_zero(&bp->b_hold)) {
>  		/* found an existing buffer */
> -		atomic_inc(&bp->b_hold);
>  		spin_unlock(&bch->bc_lock);
>  		error = xfs_buf_find_lock(bp, flags);
>  		if (error)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
