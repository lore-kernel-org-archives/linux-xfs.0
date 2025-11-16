Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA10223D7F8
	for <linux-xfs@vger.kernel.org>; Sun, 16 Nov 2025 13:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763298222; cv=none; b=FZSpcnECr6KohemZEdzdRQm/285jdlnrkNvxi+TsX+IiwbzgBORxWUZh7bMoo4vyaiJdpJNy4v489gkb+fPiccg2PoXZfBxRt1xbs666sv/aO/b7lo73hU0PtQp21k2aCv2zFh2a84SzDbenzJCsrTI5v1v27rWXib4295TnfAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763298222; c=relaxed/simple;
	bh=WqloIHZV6Jgf5Ikf0UooMrQizcWSAlwDvWuF1QeJZsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0euuk9dTdaFqGRCES9ubJwUybKMcYfWLmJnrt3PhP7WTXwa3Nbv2LbEwPA+BvsqhTz9HxjBKLwtzjd0xZ1o1eQPey8OCyC5J/EKdDII2kPPWId1ZFTHe9YcQvtfU/aDlE2EvMUqPGBP0dn+mp67A6AvA8IG8koX9yfLHgOE7Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=07IFPMd5; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="07IFPMd5"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-297dc3e299bso34178705ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 16 Nov 2025 05:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1763298220; x=1763903020; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eEG44CRLtBPfcyqDgTz8tqstkTla6g/UV1yJWYPB3J0=;
        b=07IFPMd5YZmNxqzSQYcynxyDy4Aw2PLkKx2gcL+8/+7rRJxseTe/MoVqOe+2n1QM9v
         0e7vpBaqIKh/1b1k8FQl9iTFR+yfqdXoEaqyrZP9XZw9+9oWXB8uUe05QnaW4gsSXnTa
         59c5RUyRYs1BY+diWgHqdIb/fMcpetPHLU1BOmT/66vwtx0tQnbCRXTQMezQdNYdRbmz
         r1hT3D7h+J5z+xZfvSZCsdHGgErSnv5e/1oQwCNNv5vHWX0uS0NiftcrHhARQF988NeC
         Jh2YPMf/1Wkxztl44HPcCEZTO4Q9jayyzyOYzmd2Ch/LVFThUuTeOBVeD+4zr6wOioqU
         yMbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763298220; x=1763903020;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eEG44CRLtBPfcyqDgTz8tqstkTla6g/UV1yJWYPB3J0=;
        b=Gk2WzQ3aooaW5V6lPoSN3mf5VXOJ6OnpqSBhd3ImXUZ92nWH5FZMs0XzImw4ebYQhd
         U3FYHzkzb4wljZNlzLrSZVhTiGxAEAaB7JbSFpRf5SXQBa/IKc6E6GxYCMZbWl1940j8
         6woJgHn7avByPNcnDHyAo1UIRsCkZsr65VwY4n9E+ZLksXPSeQBEX5j2sx9AX+fPSO1C
         e4dsoXgN38nwcTLi+incIciXPRiEscHt2tdODezRskeKlGNzWyuPOCuVwP/h9vkmELaa
         qfokroaPtO3VUGmEG1DMtgsyhdt9TmsAziwt45CXski5F1bM/W6cCoZ5zHqiRGCjfnN6
         5avg==
X-Forwarded-Encrypted: i=1; AJvYcCV8xKWVAcYxCV6C+hwlqe88/OD0kSy3ChwItnQ2n09RU3lLeUssbrT8r2kt/id4qVkZSO3p+skjQn4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR4WwfRMjznXvi42PdyLPFgZce+EhwzH4FA6QZCWQulVtstgIG
	+dHpqKY1JXXutLEHgFQNXOPRv5jBeC4t+NVG7HwBlqeVgQWDv0CXmuMNPjlww1R0UzQLtXVbVge
	dhLOd
X-Gm-Gg: ASbGncstv/mbzYPwgi0Kr56lHk0Cq4+LjbyRrD8b08rYaWgbaS0YBS4f7ZF+TvwjFIB
	eL/YdKB8+cokUMUFoafNkw/i3J83mYXUMfY7W5700snZyr/S0QylGFSadlOTfO7thHYB/xQmYd9
	OAf+s5aVlUGtzUT9JdFF+zNfIYc6kVMCTBKsUcqyyH+cYgq1lAobRwMmK5GSrnwLgAQCq6V4ik4
	Nxc4nIML2xOkAU+/weM7j3lt+Bm6EXQazsFcNs41SJ+SIHAHifdvvX3fvGP40LP+mhLAiSyfyaS
	4OuDUDajJOBFYVgtOAtUZWPp9rpy6fRhBgiUhQoRd1UxIMDbpCgeduEBJ03k2dcuyxR9b8Gt2rr
	MBGSwxz8atG56sRYCv22+x5hn5gUsCaeCCqYMNRiMNLhu4XHTo2ToHDB6UlGoxT0wkNqUz/z98n
	HOEaJ/zT9fCl85nUL3vn1KNEu3q4C8lt6q3Z9hPbXhlGpnZqDa3fpfxSWNMyRGlA==
X-Google-Smtp-Source: AGHT+IFfmyeHt0Tov7cPA+jYihZHDlsjawwoyLBdqKUlAM4uzl+h15bPmP9eM0UvhQrgwONTGSVjfw==
X-Received: by 2002:a17:903:124b:b0:295:5a06:308d with SMTP id d9443c01a7336-2986a6ca930mr104647585ad.14.1763298219795;
        Sun, 16 Nov 2025 05:03:39 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b1088sm110330065ad.57.2025.11.16.05.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 05:03:39 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vKcPo-0000000Ba7D-3RT4;
	Mon, 17 Nov 2025 00:03:36 +1100
Date: Mon, 17 Nov 2025 00:03:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: Haoqin Huang <haoqinhuang7@gmail.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org,
	Haoqin Huang <haoqinhuang@tencent.com>,
	Rongwei Wang <zigiwang@tencent.com>
Subject: Re: [PATCH] xfs: fix deadlock between busy flushing and t_busy
Message-ID: <aRnLqK_N25LvkSZQ@dread.disaster.area>
References: <20251114152147.66688-1-haoqinhuang7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114152147.66688-1-haoqinhuang7@gmail.com>

On Fri, Nov 14, 2025 at 11:21:47PM +0800, Haoqin Huang wrote:
> From: Haoqin Huang <haoqinhuang@tencent.com>
> 
> In case of insufficient disk space, the newly released blocks can be
> allocated from free list. And in this scenario, file system will
> search ag->pagb_tree (busy tree), and trim busy node if hits.
> Immediately afterwards, xfs_extent_busy_flush() will be called to
> flush logbuf to clear busy tree.
> 
> But a deadlock could be triggered by xfs_extent_busy_flush() if
> current tp->t_busy and flush AG meet:
> 
> The current trans which t_busy is non-empty, and:
>   1. The block B1, B2 all belong to AG A, and have inserted into
>      current tp->t_busy;
>   2. and AG A's busy tree (pagb_tree) only has the blocks coincidentally.
>   2. xfs_extent_busy_flush() is flushing AG A.
> 
> In a short word, The trans flushing AG A, and also waiting AG A
> to clear busy tree, but the only blocks of busy tree also in
> this trans's t_busy. A deadlock appeared.
> 
> The detailed process of this deadlock:
> 
> xfs_reflink_end_cow()
> xfs_trans_commit()
> xfs_defer_finish_noroll()
>   xfs_defer_finish_one()
>     xfs_refcount_update_finish_item()    <== step1. cow alloc (tp1)
>       __xfs_refcount_cow_alloc()
>         xfs_refcountbt_free_block()
>           xfs_extent_busy_insert()       <-- step2. x1 x2 insert tp1->t_busy

We haven't done that for quite some time. See commit b742d7b4f0e0
("xfs: use deferred frees for btree block freeing").

-Dave.
-- 
Dave Chinner
david@fromorbit.com
