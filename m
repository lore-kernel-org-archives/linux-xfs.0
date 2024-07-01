Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DE22CA6
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 01:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719796571; cv=none; b=uJgysYw6zR55TogheGCdJ38ARkk/BRgWv2xvl+6w8AdByArkJL2MoX6QIvS8U3n3Xxr5QjEllNzWCGP/LD56r/pNIanoeOQ8wD3KHrt3iuV2VU2cC9gvoE9c45Q0BtRsUxhRBKU4YXJBIi7ILO8xt677kQZv7SOR4pxlCyEBG70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719796571; c=relaxed/simple;
	bh=uiod8Gdriil62+Shj/a8XEzFRx/9BbIC8xbxkPmFaC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NWbmpk+em1RwtzdOfkzQwgnqfOnnTcg0yDr4tMRLUDQVRj1zZUquNkrRPd58EEo+yIBC6ClbEvotsEOD3+eGNmf7bStpfUGH469/PkKT3pkGNV49U1WuT9h4yq3QPol+sroj4t8L5mh7Pz/tgGRr2ZNJxzwfpF9G/BRLxxj88xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Tq0xx76s; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Tq0xx76s"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f9b523a15cso15300285ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2024 18:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719796568; x=1720401368; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/WihJp7JnQZqE8Q3tF8oBlf+IYLcmEBJKiSEmeorD3A=;
        b=Tq0xx76snsAIWJMCMefJNYzOBp9GG7RNOLUxwPazCWoYLgoANDrrWcP6HgdIL+oeug
         pDE71+wtCa1gcj/Amc+Znc8cyO4LfIGEk+RvNkMFaC8lkMTsHE7kewe5MvzWt73vCmZs
         p0dBkv0vqITqelFaatvkyFJWZbah1Qq9KZfRp9MOCV+0UMqw6IkYgOwe/nf6Ng8Tu9c3
         f50tpf7XXFeupy8vHPoDt56fQG2BS1+ZocfhOXPrw2zYMFsCAFBadoRc5vvCJGB544T/
         zMsoflyatVsi+UjBazXLYH56bQ9iq9aAj75YBxARxN/VHRlG+cpya3AkpJKxQ9OIezI5
         w3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719796568; x=1720401368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/WihJp7JnQZqE8Q3tF8oBlf+IYLcmEBJKiSEmeorD3A=;
        b=fXZTtOUT77IGdsoeQMv6yqGPs6cKRwA5wZoe39ToUzC11F/58aT50QZ6FeoDHentGh
         NY+2817Q5tOvue9uXqzyYfeSzg8Ezu4h2XHOR0w8mZv+LgnAhC7OjXR8zeQrvTnDPxxh
         b2xeFMDaEHw1Dx8/MDA0uLP0UQ3LuhRKc9DlywY6ERlnbUH0TGt/fUYLMVa9ddkSv8Jn
         3cct64mS4Gn3jXgMfjeWby5V9ZCuypnlAfy5FKPhimhqsTbgheU4gKkY/nWsicGhKhgS
         PIoc3E5cv/iDj6mv5KYsn6U7hagZPqFjFd92So5pFNRwVC/aoac1d8VEd2Li5V3HRJlK
         A3jg==
X-Gm-Message-State: AOJu0YzmZj8sceLjvkP/Uybg9mDiJNJCYOP2fKx81Sbn+MrmRqqlU51Y
	6qczlxaun0+8et+TMnKZiUfEj98uz/4Zcby/Pxrl7sNPqz532jcA/WC4sacj4Lg=
X-Google-Smtp-Source: AGHT+IEMQ/nIAAwcy5E9ZtnDihQLkeNPAxdYq4I132s7wFI5weLcV6ze43XfRapwnaVRCEDFola+Jw==
X-Received: by 2002:a17:903:1cb:b0:1f9:e2c0:d962 with SMTP id d9443c01a7336-1fac7f1b66fmr116097455ad.31.1719796567869;
        Sun, 30 Jun 2024 18:16:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac10c8bb3sm52206465ad.46.2024.06.30.18.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 18:16:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sO5eH-00HMwu-03;
	Mon, 01 Jul 2024 11:16:05 +1000
Date: Mon, 1 Jul 2024 11:16:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, djwong@kernel.org, hch@infradead.org,
	brauner@kernel.org, chandanbabu@kernel.org, jack@suse.cz,
	yi.zhang@huawei.com, chengzhihao1@huawei.com, yukuai3@huawei.com
Subject: Re: [PATCH -next v6 1/2] xfs: reserve blocks for truncating large
 realtime inode
Message-ID: <ZoIDVHaS8xjha1mA@dread.disaster.area>
References: <20240618142112.1315279-1-yi.zhang@huaweicloud.com>
 <20240618142112.1315279-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618142112.1315279-2-yi.zhang@huaweicloud.com>

On Tue, Jun 18, 2024 at 10:21:11PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> When unaligned truncate down a big realtime file, xfs_truncate_page()
> only zeros out the tail EOF block, __xfs_bunmapi() should split the tail
> written extent and convert the later one that beyond EOF block to
> unwritten, but it couldn't work as expected now since the reserved block
> is zero in xfs_setattr_size(), this could expose stale data just after
> commit '943bc0882ceb ("iomap: don't increase i_size if it's not a write
> operation")'.
> 
> If we truncate file that contains a large enough written extent:
> 
>      |<    rxext    >|<    rtext    >|
>   ...WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
>         ^ (new EOF)      ^ old EOF
> 
> Since we only zeros out the tail of the EOF block, and
> xfs_itruncate_extents()->..->__xfs_bunmapi() unmap the whole ailgned
> extents, it becomes this state:
> 
>      |<    rxext    >|
>   ...WWWzWWWWWWWWWWWWW
>         ^ new EOF
> 
> Then if we do an extending write like this, the blocks in the previous
> tail extent becomes stale:
> 
>      |<    rxext    >|
>   ...WWWzSSSSSSSSSSSSS..........WWWWWWWWWWWWWWWWW
>         ^ old EOF               ^ append start  ^ new EOF
> 
> Fix this by reserving XFS_DIOSTRAT_SPACE_RES blocks for big realtime
> inode.

This same problem is going to happen with force aligned allocations,
right? i.e. it is a result of having a allocation block size larger
than one filesystem block?

If so, then....

> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iops.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ff222827e550..a00dcbc77e12 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -17,6 +17,8 @@
>  #include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_trans.h"
> +#include "xfs_trans_space.h"
> +#include "xfs_bmap_btree.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_symlink.h"
> @@ -811,6 +813,7 @@ xfs_setattr_size(
>  	struct xfs_trans	*tp;
>  	int			error;
>  	uint			lock_flags = 0;
> +	uint			resblks = 0;
>  	bool			did_zeroing = false;
>  
>  	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
> @@ -917,7 +920,17 @@ xfs_setattr_size(
>  			return error;
>  	}
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> +	/*
> +	 * For realtime inode with more than one block rtextsize, we need the
> +	 * block reservation for bmap btree block allocations/splits that can
> +	 * happen since it could split the tail written extent and convert the
> +	 * right beyond EOF one to unwritten.
> +	 */
> +	if (xfs_inode_has_bigrtalloc(ip))
> +		resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);

.... should this be doing this generic check instead:

	if (xfs_inode_alloc_unitsize(ip) > 1)
		resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);

-Dave.
-- 
Dave Chinner
david@fromorbit.com
