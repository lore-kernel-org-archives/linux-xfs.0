Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84A717C
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 00:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715040341; cv=none; b=FKyy8MnDI0y2PYyB+IyjHIW6o6IgsvCuGBUZoXO/NkDUAHvhDc+AdaLhLgHUNK1smmpayOaHRQGYZRkeWMoWy8QQ2+YrGbA6EJWybAGLCbD7de/WuwvviyrrhxIGrvjGRhcaqVUDAJLIHiiSom0mHy2vcswvhEe6n2Zab/Qej3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715040341; c=relaxed/simple;
	bh=+r96OpFsdE3OiCouE0MboKQhCrMK+ry6ELfJeJnog1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R8BTKRjndk1EdUMSyfu2u4ohVhItMAccW0lgKn8QYAQAp99UY3sn6nVOKCjZ4IAsfV1752t8UTZVWNWooegnv6FyOxKT/dH7D6z6JF5N5nnt4qquL4kqDTqCVJV0mchjRUoeWuURktFdZThctbQ/gYicv1jUZhxwC1J2I6+IbSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=IUyxVQE7; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="IUyxVQE7"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1ee7963db64so517775ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 May 2024 17:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1715040339; x=1715645139; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/mO8RAIpI3ciXCmAN8uZAWkBK2a+XdI/Wl85E3eh0Xg=;
        b=IUyxVQE7r4mBofKiCzu+Q0FePdp2ilg3FpDTBZak3xlnXkJ01fqpceRZRzYFnWokOX
         e63nJ+KFJvdDjwEPV+fL0PpXQRIsFrH0Nn9eHNNBQ/55jGVmU3yikpReTmY2B8HD+up/
         vkFLxvBw68l2/BL5/pMTYyFdC9WFMkntDvc1a8GHgAUo5NgDiQVnAqzBtL2bkW2twxIH
         KEm3Hb4i5JOIkYKqoWNLBqSQWRtEYe9HpnF6EPcoPs3aPty3ryTXGoJC7azoUIwtMpY+
         P2ZxepmzKX9sFZ/p72kOKOpYuO4u+MwNf//NpHJR/0opNGgtRDGSEVs6Mw4Id4oP3RAN
         yt4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715040339; x=1715645139;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/mO8RAIpI3ciXCmAN8uZAWkBK2a+XdI/Wl85E3eh0Xg=;
        b=RYo4gEp2QybusxxqZHVuco+72MMgzC04e+64QO2R2Y3dbPU6X4W0OUAwiuDRWGc86s
         lzk6/xUI4q6o7sSPl3ntOnl+v/98OnindVKxcDdLrQnYRsjlJRy6V7mx63RKCcQGe91w
         pxAmnckZ0d+P9gWxKe56GSa5GH4okNBs77YP98rfN/ROO9yocJJrBVwqrMvUijLf9N5H
         YgeKyr8xUoxQ5J3ecCRdwg9LssmkmfGUHtK7P+bE100KVq7Rxlbe0k4ty5tmV/5/q6+n
         6oA8uNPtpk2kfWxGbOyst9KOKqveMFhBF9xT2AmdBQ+jByYNPNMF85TQI2NFcm29DqdW
         kGLA==
X-Forwarded-Encrypted: i=1; AJvYcCVG5IvlUymJ19EmuNp1RaTdMMUod29DhBAXVyM3rRhJNeAwOktUSszOZuqxcMX7dmGgeh8LJs32RLiyxE/hYQPD9C/H4MdoblFY
X-Gm-Message-State: AOJu0YzAtLm37AYJAaGlgMaWIor+5nA86K7G83Rq5dmWar2BSZeYkZrc
	qO24/4khKjovpdg83UaVOikAeEFGxyIj7cE4nMp9H4I+KWF7DrPc1qc2pVL8hAI=
X-Google-Smtp-Source: AGHT+IFMS+uzDdaAPRHwq/U9jqHYjfdEca1j76tOxwxbkz7wqlqDtFC+MYf5HxlMEVl3x/q1hzXhRw==
X-Received: by 2002:a17:903:2306:b0:1eb:1af8:309f with SMTP id d6-20020a170903230600b001eb1af8309fmr18304829plh.4.1715040338808;
        Mon, 06 May 2024 17:05:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id e2-20020a170902f1c200b001e088a9e2bcsm8829552plc.292.2024.05.06.17.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 17:05:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s48Kt-006745-2E;
	Tue, 07 May 2024 10:05:35 +1000
Date: Tue, 7 May 2024 10:05:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: akpm@linux-foundation.org, willy@infradead.org, djwong@kernel.org,
	brauner@kernel.org, chandan.babu@oracle.com, hare@suse.de,
	ritesh.list@gmail.com, john.g.garry@oracle.com, ziy@nvidia.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, p.raghav@samsung.com, kernel@pankajraghav.com
Subject: Re: [PATCH v5 11/11] xfs: enable block size larger than page size
 support
Message-ID: <ZjlwT65S9wJVW98w@dread.disaster.area>
References: <20240503095353.3798063-1-mcgrof@kernel.org>
 <20240503095353.3798063-12-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503095353.3798063-12-mcgrof@kernel.org>

On Fri, May 03, 2024 at 02:53:53AM -0700, Luis Chamberlain wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> Page cache now has the ability to have a minimum order when allocating
> a folio which is a prerequisite to add support for block size > page
> size.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

.....

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bce020374c5e..db3b82c2c381 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1623,16 +1623,10 @@ xfs_fs_fill_super(
>  		goto out_free_sb;
>  	}
>  
> -	/*
> -	 * Until this is fixed only page-sized or smaller data blocks work.
> -	 */
>  	if (mp->m_sb.sb_blocksize > PAGE_SIZE) {
>  		xfs_warn(mp,
> -		"File system with blocksize %d bytes. "
> -		"Only pagesize (%ld) or less will currently work.",
> -				mp->m_sb.sb_blocksize, PAGE_SIZE);
> -		error = -ENOSYS;
> -		goto out_free_sb;
> +"EXPERIMENTAL: Filesystem with Large Block Size (%d bytes) enabled.",
> +			mp->m_sb.sb_blocksize);
>  	}

We really don't want to have to test and support this on V4
filesystems as tehy are deprecated, so can you make this conditional
on being a V5 filesystem?

i.e:
	if (mp->m_sb.sb_blocksize > PAGE_SIZE) {
		if (!xfs_has_crc(mp)) {
			xfs_warn(mp,
"V4 File system with blocksize %d bytes. Only pagesize (%ld) is supported.",
				mp->m_sb.sb_blocksize, PAGE_SIZE);
			error = -ENOSYS;
			goto out_free_sb;
		}

		xfs_warn(mp,
"EXPERIMENTAL: V5 Filesystem with Large Block Size (%d bytes) enabled.",
			mp->m_sb.sb_blocksize);
	}

-Dave.
-- 
Dave Chinner
david@fromorbit.com
