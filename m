Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD4F2DF712
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 05:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756186973; cv=none; b=RAREgFR3VjNAy0n42VjcXltl4/LBy18lJfRxaojKI3P7QqirSSbg4nND0YGUKcdFCGcmMjaBM3/2jep3O1N/IgiI2Mf7TXhHj+W4rbbg/1LN3Tgeb8DiFnLeqvVPX1Ol+3zq77T8nRA5x35zKnyFEnkcHF7+ZVT3KQqW/SUVHNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756186973; c=relaxed/simple;
	bh=kx3codHJijdVyccGmH5zorjd1ng56+u5ohMWY61J0hA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8l82dNzotcU4ZlYfEwAhtKknC4oMAf7kxcOweVSS8MQzs9n4+WhsLxrlTqLGuBE6+IeyPzKKvfW9FNHCwfO4tN4l4gPoNn+KWe1xnagFR5Vjet1z7aSgqgszDKuOXIfN9awaLsuqzvUjBU9Yu/ERBau6uEafSWF77aM+V43n4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LI7c+D8B; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LI7c+D8B"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76e2eb6ce24so4020464b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 22:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1756186971; x=1756791771; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yqWXuqC6+qBsK5NxRM/RN2zY545tGqFkL75put0bCRQ=;
        b=LI7c+D8B9MkHzg5BfioPM0ruJxF1yU9TvnKhkO3IUUNStHvNlDNYGUM5fOyrR7j+fY
         BL/kkb8yB1gGe8tZ3ZYrIW9Q7hVxDd/FOaDNNWhmOisaib8UdFGftlmPrNmieGORaaRf
         eV78xRyBg89J1RvpkSaSsgw28XDsYFhVSHt2Prr2cspUqaiTkNr7HhH47u+XUzbHtexQ
         y8kcQ3qjeOXfr5krrwuXiO/laZUDA84V0zUMytwBVOGhomgHKDXm1zaYRsRa62htX++w
         jBLoPEALPRnL2PpkeJ/VKpMIHNsElt9hElaaEwkMbx4HU5IaQV5PO0hyoe8echwnQNbs
         a3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756186971; x=1756791771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yqWXuqC6+qBsK5NxRM/RN2zY545tGqFkL75put0bCRQ=;
        b=LbbqVsPI574JcapT9WqSabGfQYoYeohZn7uTRQrM3QXQ+z67D64uNMkveeKxVuuvd2
         msYZoonzgeIfxdOPPhS90vF2bDBnJysBZwgQggUVPXUC/gCdf6SI97qm9u2+btx5AmsX
         +BI4ZZ9GpQQx7IYo+KR9mAVML5y5LovI6ZXHbdEHDCd+Ih8eZpG6zg3QZbwPCugJxo6Z
         kpk9RNEBkHw+nupZMSHlb8nEYpbs9SP5GN/2MxUv5LiwialoDkrceg5n2BNB7/PLLjfh
         4xLMKwWpKsBjaijX+8U2xXOK9Jz4N64E4a5ycMUYsCwyUkU9UEmY34OcWcUcfMCVSiqu
         7O4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUMBJaTQCNEX0edRx88xD+d/w590Jv8gjLVlTD/hAjDD2Xepvb4FVy8C9KL+b0FS7u2pAvpHfipb9s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb/lfYaWg88utK4WkCFdWSLKOqURqTnQ6uL0s32CCp21yuiV22
	waFjlu50hC4MLviw0PeuA67rgUe+qUwVdin6LrVkNxJ3vz5Z1iZikC/1a5uSU12Dnlg=
X-Gm-Gg: ASbGncvQFbEF0kYnYquvBfVLhtx++RtmkjIrx/McEqgqBMEEK2uf/yXwlyZwlO7sySl
	ovd9y40yX9a5bgd81y/OI2NbLQG/9s8c2i6IqRtD06bjr/8J8lZofKTCbd+LuJX8W+Gi4cMe2rn
	VUKUNRrx7V3Ekga+f5B1jlMnsUWd0RbTKR3SSFfeArymOjQdhSGLT9SuT/TSny0tL/oBrlLvdVO
	pPnbZNFHj4UbSAnYSI9vAY0ncWg7u9iePIjmgheuK4AYKQ7CM+MejFuCSgiJ+p92yjyLC7pawH3
	Sginihw+9Y917UM/PQDvf61Gxezii6I2ORbpM1fHs0WFx+QanWKOsj9q9OpZKmDA3+ig7du+PeJ
	FDvAKPL0fcVcTVPn4ymAtrtOsiAFTbdoka7t2rTrAo3ijq4PxJfc671JseYzMF4kUHpvW1+6uNn
	Qod8/VFb91
X-Google-Smtp-Source: AGHT+IFINrtcdliSsg0U+XhZO6oK1C9AVwo47JgYkX16p3ZtGMRV667nzZdHTSlirL16SR/n0Ou9kw==
X-Received: by 2002:a05:6a00:13a9:b0:771:e114:35be with SMTP id d2e1a72fcca58-771e1143863mr8773636b3a.13.1756186971281;
        Mon, 25 Aug 2025 22:42:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-771e4e906dasm4075569b3a.113.2025.08.25.22.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 22:42:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uqmSG-0000000BDNy-11ek;
	Tue, 26 Aug 2025 15:42:48 +1000
Date: Tue, 26 Aug 2025 15:42:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: track the number of blocks in each buftarg
Message-ID: <aK1JWBw72zzC1uvN@dread.disaster.area>
References: <20250825111944.460955-1-hch@lst.de>
 <20250825111944.460955-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825111944.460955-2-hch@lst.de>

On Mon, Aug 25, 2025 at 01:19:35PM +0200, Christoph Hellwig wrote:
> Add a bt_nr_blocks to track the number of blocks in each buftarg, and
> replace the check that hard codes sb_dblock in xfs_buf_map_verify with
> this new value so that it is correct for non-ddev buftargs.  The
> RT buftarg only has a superblock in the first block, so it is unlikely
> to trigger this, or are we likely to ever have enough blocks in the
> in-memory buftargs, but we might as well get the check right.
> 
> Fixes: 10616b806d1d ("xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c              | 38 +++++++++++++++++++----------------
>  fs/xfs/xfs_buf.h              |  4 +++-
>  fs/xfs/xfs_buf_item_recover.c |  7 +++++++
>  fs/xfs/xfs_super.c            |  7 ++++---
>  fs/xfs/xfs_trans.c            | 21 +++++++++----------
>  5 files changed, 45 insertions(+), 32 deletions(-)
....

> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 5d58e2ae4972..d43234e04174 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -736,6 +736,13 @@ xlog_recover_do_primary_sb_buffer(
>  	 */
>  	xfs_sb_from_disk(&mp->m_sb, dsb);
>  
> +	/*
> +	 * Grow can change the device size.  Mirror that into the buftarg.
> +	 */
> +	mp->m_ddev_targp->bt_nr_blocks = mp->m_sb.sb_dblocks;
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp)
> +		mp->m_rtdev_targp->bt_nr_blocks = mp->m_sb.sb_dblocks;
                                                              ^
That's not right.

Perhaps we need some growfs crash/recovery tests to exercise this
code....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
