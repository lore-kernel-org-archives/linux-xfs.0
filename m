Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEB01F943
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 21:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724795619; cv=none; b=DrKXLfdnt9zQBzubEJdYL2JZEiXzvxzAV9Y923nhqdqRpN9nk0UvomqttSnPN2D4LtkvoYiCbXSa3+nh3Uc0OJLhQQySaczUzAbi09dRlMlG5PGq+matOP0/NBvYYHQ8kP/juqp8Iu2xSo0Q6e1bM1+UMSjRi63YVpAL22y1jPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724795619; c=relaxed/simple;
	bh=Ey4VKVEkUlKyt642AGBYtmTsjIW0ykZherpMZikXl3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sDA5ORBw0dUtuvgMd+AQxaxhz9NsDug8Hm+Kjdedg8Hy/qPM4CTwyWr8GiLMFF+1pe6MsuTkzIyfjqDujDFY5U6Xl0UU5BEFHAhD/EfZPzi1oSkKD96kGL+ALZuOvQ0J5WvwatvdLAxC6LQNkDzF08N1B2GeSxtCr/tHvZh6gfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=jo6uigLO; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="jo6uigLO"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1fec34f94abso62085025ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 14:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724795616; x=1725400416; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Wo/NrKtlpvDPaRhlKS48B4Dwtb35qtRRg3qbJru4H4=;
        b=jo6uigLOAqAcVDZE2NKJEjfh7MyzBf6uRxg2x5lqY9ldUs9PeCdRRd4jB5Q7msz6kg
         hukQ05hZoqrke80WqGPI7PAHjtjIMOrL04vI7pRCN8wxPfpKlNF+4N3sPa2SBEaGv+sB
         eq9Ljzfq+97mkYzSa5eyEy5CXGD/gRby60Wjv6vw249Vgvx/agC31w4LqChzONnAH27K
         MU5INSKukEXk7yHv0wTOdcWJedIdHyPsQv1xLR0WIJtnvkvfxrugO1vYezBsCLZyLW7G
         OUwtO9M/9g29M8o5atuflQrJMypO96X2AZDAsVGaHB2KgOrUt90xVPQiPUrwoIjDP/ho
         s2ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724795616; x=1725400416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Wo/NrKtlpvDPaRhlKS48B4Dwtb35qtRRg3qbJru4H4=;
        b=wcZloa//Dops5FfVIhXIZgtwa+ZiZoc/Y4znt+JDC4A3Sa9CmOCHu4FIkbXah+zA8z
         iiphUg2P/tRkkKT80fXO/f+4Tc6SBHwgwCLtivMxXKmaSis19qVFPYtCJbdC9WxLsoES
         CZjGZ6N2FgNNiFa4L+ZJU8okfPmH/FB+NJCAsgym1VCVw2SkC2tCVAlZV/C8hxYcMPuT
         bAYpD163HmieMrTkS47R1rMS8GS6dv8Yk/W43G6Ifc4oVTtx3RAlnexHgDja+vaAOMuw
         IkWTlTK3C2N6FHVoxAFpMQHfnJxTvKIOZ51J483QeCTElk4XXFtU2Ryo7yj0RushlBl9
         4qaA==
X-Forwarded-Encrypted: i=1; AJvYcCVp3QrZkd9SvNmYb8DjkwRuKRQrpjeCVQPy4unQZMzKxzoRxYJXy0jVtt/f9FM94Bbd0mjgDIWkGy0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI+0Htin5oze4MAWG+PUjuiWAYSCNqsjC83d6yExqkVVjw8Zhn
	1wP9ACUMmBrwN5WH2Pgvl5cnKEAasLKquwF7eMWCu8RwWlsQ9gwOVe9EPvLPj5qeFZ0GV3F4FQM
	N
X-Google-Smtp-Source: AGHT+IESMrWEm32vG7mHO39WRxTSD9syfWb84dp1KHANfP9t1sWdcKewLFs7VGaBrBah+hgx/n71qg==
X-Received: by 2002:a17:903:1c8:b0:202:32f7:2326 with SMTP id d9443c01a7336-2039e479482mr197733335ad.17.1724795616419;
        Tue, 27 Aug 2024 14:53:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855664c1sm88303675ad.3.2024.08.27.14.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 14:53:36 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sj485-00F0dA-25;
	Wed, 28 Aug 2024 07:53:33 +1000
Date: Wed, 28 Aug 2024 07:53:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: ensure st_blocks never goes to zero during COW
 writes
Message-ID: <Zs5K3fZ1kbIK6yTd@dread.disaster.area>
References: <20240827050345.1750476-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827050345.1750476-1-hch@lst.de>

On Tue, Aug 27, 2024 at 07:03:21AM +0200, Christoph Hellwig wrote:
> COW writes remove the amount overwritten either directly for delalloc
> reservations, or in earlier deferred transactions than adding the new
> amount back in the bmap map transaction.  This means st_blocks on an
> inode where all data is overwritten using the COW path can temporarily
> show a 0 st_blocks.  This can easily be reproduced with the pending
> zoned device support where all writes use this path and trips the
> check in generic/615, but could also happen on a reflink file without
> that.
> 
> Fix this by temporarily add the pending blocks to be mapped to
> i_delayed_blks while the item is queued.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
