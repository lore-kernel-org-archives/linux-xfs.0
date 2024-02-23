Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4350D6FBF
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 14:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708698029; cv=none; b=mNzf/0e7Rl1oM7F1bKjlC8p2alypCblnGFlJe8RyIkRjsQzreWLWf9x+7oB+6LW8YA2fB5AUwnPRV0aIynHrrCp/QLCTYuzBPJYw27vFrU9yDNGO6Eow94N0J1OHYoIrhyDwiqrAY6JAajH6NhAAMmDiC50zgk+CpCEIQmjw5Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708698029; c=relaxed/simple;
	bh=WuvbJ3uZTm71Zt0nssg5tLPcSk1TFJvTbb0PunTVF9w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ahwLRC0TeQ65yTxoW1HyC1NFP9swk/p2EEN15CcQGAbMo3Pi1fn4bPeLWZFwO2dPSJzALOYsVsgKgFWI83mSuGVWHvqroti8bvN990d65Kp4dcBHeFL1rYCj1Ctg7XQzdVKCRiJI0Ll8zNmRWBpoZQ6+YjoZrCSt0zGvugSy/Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U+ymLFZq; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U+ymLFZq"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-41296e2c2faso2557965e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 06:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708698026; x=1709302826; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=POLI0JEOpTm4SThx4D+bXsNSasavy0KNT5gM4crdzL4=;
        b=U+ymLFZqozmlzb0aMRg4RPG/daqBJX5YaSE+RoyfA4giTJd9OXaUxxgUI+q7VfYrZw
         wodjLk08mkXPY/trfLda6icH5azmSASt90MKZmZoS3qUP35W269srAsiYq6oKl/xyjg0
         WfBh+B20sSvHzlZNif72yBus4+wFtHHh/LQyT24aTAgPJuSrA9YkAqFYUFduLaV3w4rp
         gQ7xcxVGqRdo69sr/3AKpVsV1QJ/GmtfM3c45Cphn1ufvkeYzjYg3m4xHe2t/WduAh5j
         hObZY1jk7ZB4zpDt6gQSnSd+vOXO964S2KrKzrG9zlkkBXse43vNrtdQ3lzKGlj/2Get
         xkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708698026; x=1709302826;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=POLI0JEOpTm4SThx4D+bXsNSasavy0KNT5gM4crdzL4=;
        b=mG1/czIjTGB0fW7bPEmY5eF/HGDWG1EKVPMjfCb1BlVfMkS0NGbO3+tcn5MulQj713
         2nKbZe909oWepiJ9bze8BxmUzTPz2HVJ7nElno6ypxyGkp98i7yqEOMEdcBu3THguyVa
         bWpIetu5Zs6Taa28bQNnH4Aq+t5zBrhq+QZuRo1H4uVKhqq72ja/ybh+wqKesPj17DNx
         jHNzIZe0abbmQzNfMjQOpw2Vp/5EzR7rU2mYEWH1ssFeTgX84qAKGG8PvbZZhMQvRoNN
         301iU5Mp5uQ/oDObXwHHXvwLV1HZqD1kObB8oeTwrrMwfDTnulBV1YPs498ZGMhKNE3X
         RV0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUU3XLwcjI3zOJD4GZVLkZd8OmVp1nncODuLyWCLBifxEgJ8Fk8J5Sg4T2r/+R38l89FF8nVfUkbYSq/Uqk9/4moGHoMljkbJyz
X-Gm-Message-State: AOJu0YyydVMy6/kJdI8gbR9UJvTmiBdZXYgjbob1hdVW1MMKjJGJivmI
	2KFm59H/q68U6VezKS4CI2WxgASMOruxC2BiysTa9ruu6sXYwjwT3o3OENjrctJCSzAabvVDr+l
	r
X-Google-Smtp-Source: AGHT+IH7RJt0Yvsbex1jyYde5sE9SXyMR0dFEFOpISoPg0m4i+0dPsykp36etoqV+MqyTL+P05QmGQ==
X-Received: by 2002:a05:600c:a4f:b0:411:c789:5730 with SMTP id c15-20020a05600c0a4f00b00411c7895730mr1354485wmq.35.1708698026704;
        Fri, 23 Feb 2024 06:20:26 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id k22-20020a7bc416000000b0041061f094a2sm2467429wmi.11.2024.02.23.06.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 06:20:26 -0800 (PST)
Date: Fri, 23 Feb 2024 17:20:23 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: dchinner@redhat.com
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: [bug report] xfs: convert kmem_zalloc() to kzalloc()
Message-ID: <4cbe2515-fa82-4883-bdff-d6261ae61179@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Dave Chinner,

The patch 10634530f7ba: "xfs: convert kmem_zalloc() to kzalloc()"
from Jan 16, 2024 (linux-next), leads to the following Smatch static
checker warning:

	fs/xfs/libxfs/xfs_btree_staging.c:416 xfs_btree_bload_prep_block()
	error: potential null dereference 'ifp->if_broot'.  (kzalloc returns null)

fs/xfs/libxfs/xfs_btree_staging.c
    383 STATIC int
    384 xfs_btree_bload_prep_block(
    385         struct xfs_btree_cur                *cur,
    386         struct xfs_btree_bload                *bbl,
    387         struct list_head                *buffers_list,
    388         unsigned int                        level,
    389         unsigned int                        nr_this_block,
    390         union xfs_btree_ptr                *ptrp, /* in/out */
    391         struct xfs_buf                        **bpp, /* in/out */
    392         struct xfs_btree_block                **blockp, /* in/out */
    393         void                                *priv)
    394 {
    395         union xfs_btree_ptr                new_ptr;
    396         struct xfs_buf                        *new_bp;
    397         struct xfs_btree_block                *new_block;
    398         int                                ret;
    399 
    400         if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
    401             level == cur->bc_nlevels - 1) {
    402                 struct xfs_ifork        *ifp = xfs_btree_ifork_ptr(cur);
    403                 size_t                        new_size;
    404 
    405                 ASSERT(*bpp == NULL);
    406 
    407                 /* Allocate a new incore btree root block. */
    408                 new_size = bbl->iroot_size(cur, level, nr_this_block, priv);
    409                 ifp->if_broot = kzalloc(new_size, GFP_KERNEL);

The rest of these were changed to GFP_KERNEL | __GFP_NOFAIL so I suspect
this was an oversight.

    410                 ifp->if_broot_bytes = (int)new_size;
    411 
    412                 /* Initialize it and send it out. */
    413                 xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
    414                                 XFS_BUF_DADDR_NULL, cur->bc_btnum, level,
    415                                 nr_this_block, cur->bc_ino.ip->i_ino,
--> 416                                 cur->bc_flags);
    417 
    418                 *bpp = NULL;
    419                 *blockp = ifp->if_broot;
    420                 xfs_btree_set_ptr_null(cur, ptrp);
    421                 return 0;
    422         }

regards,
dan carpenter
