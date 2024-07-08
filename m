Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5753879FD
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jul 2024 22:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720477097; cv=none; b=d0u8hn/0mtQ4wY3lhv3sVqcxvXK3bUBDaK+QaGbDQiXuWlEM9kDozr8GGqW9Jr21Ir1U8g7MEKwq7Xp411yXVnXHwwvzV2r1ueOtHNe8DliV7ZI5aBZQ6B9HQVnywOh+mdd68wm35hTP+q9BRQPmHt53IZvO3F+EE2f+3H+zStE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720477097; c=relaxed/simple;
	bh=DjHGuwWLZE6AYa2F05MnDHdTnkQ+OOihy3MKZKRy3Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYRD9nJayqh1TB9FYeGuS++iqdFsg43HzypDcuuJqBRYo28h6tRt8af3JL7Y/FUgATHQDSb5+upuD0YjpDeAhfyk9imTTlyq/tLapIdnHaUZ9lBp4Ans6l/NE7LNqWRiviQk2gBcVd8y3D6t3a64KMOnetM58BYB9kNLXesHGpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=VTmwHshW; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="VTmwHshW"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70af0684c2bso2736095b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jul 2024 15:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720477095; x=1721081895; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lynMa0qMQvKrU3+x9nFoEh4w764WLqy+q+oFFlPFpes=;
        b=VTmwHshWBtH5N/BwmYN5EDxmv6b8C4eJRFOBmo3IopfhfABThpiQibAzbJN51PfUSj
         858G4AE6Yd3DFUdk5lhHFDhjFw1NnszoEmFCHz8r2L1dtsnwaFDmrdo/j0pm2OgHYOc3
         ghmkZy8oypSng+VsgMZEAr8IZaj9hsygNb7Q+D/ZhyaeQyoB4KTbR587o7qYqcTcykhd
         PbbTwzh/s1544DQkjr+rQ/BMFnZIFCQUsjiTdUNuSaSI7gsnZjumxT4OeaWEyaOT8RTY
         4/r7PZ44A9ind8IbFt8AdTBNvq5oQHrN09dfmP9bIW5dykTAgnmZKAc9ft7/rm72jc64
         hDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720477095; x=1721081895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lynMa0qMQvKrU3+x9nFoEh4w764WLqy+q+oFFlPFpes=;
        b=GWDLvihKNVlcfpL0Pb6RoJOC1yuEl2CaSi7vd0nkQTNVgPjXD6OTGtBOX5WHxT6AOe
         WrwxGH13WS5FqT9O8q92s1XHHujsCLb1ab1+u9u/FNmtoWVa7e7CXCcOxMyZmFLwwTex
         YxNmv5hbTbLSAwjfoBQbSiH2nTgazuflh9vSrTUFT4yzJX4AqZLOPHdZxeIwlz56GARv
         QAL9aHChLnGX+QGefk8VUHl74cC3h+11Xl3OpPzUe6Sw0+Db6p2icLFpRDYlwtAdluwk
         bzYZtiFPxcnylaRIzCnpBCXn32XXRgTzyTnfyOFDDa4dEoYMDyZMZHPx/24sbpFAEh6f
         9Jrw==
X-Forwarded-Encrypted: i=1; AJvYcCUNIiCnZxFx8rVCfxfU0nMGzLROjOMBAjJvXXbEyay1GSySW5jegQCbfu/HWj9usLUXg6tCzkjKSEejZiN66QTapUJu/YmxTUBJ
X-Gm-Message-State: AOJu0YwHqsJol0Mqct+S9uE+TJNaJExgIy2bVJYU0o+a1pY/LSm2ZOPq
	VB3tLEa7KuWsKtVWwCudhJe3ce7n5DUM59I59/qlniQk+VwdJhc+3w62D3C+ZaQ=
X-Google-Smtp-Source: AGHT+IEjV9bBXGFmEQTeSIY+iK7kYcB7ABn6Uk4Yy8He+5O/cUUPNO91G+kyGhhILxTgai05zaVU7Q==
X-Received: by 2002:a05:6a00:1885:b0:705:9a28:aa04 with SMTP id d2e1a72fcca58-70b43650817mr1185390b3a.23.1720477094695;
        Mon, 08 Jul 2024 15:18:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b4371fc2dsm406119b3a.0.2024.07.08.15.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 15:18:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sQwgV-008zrf-2q;
	Tue, 09 Jul 2024 08:18:11 +1000
Date: Tue, 9 Jul 2024 08:18:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: willy@infradead.org, chandan.babu@oracle.com, djwong@kernel.org,
	brauner@kernel.org, akpm@linux-foundation.org,
	yang@os.amperecomputing.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, john.g.garry@oracle.com,
	linux-fsdevel@vger.kernel.org, hare@suse.de, p.raghav@samsung.com,
	mcgrof@kernel.org, gost.dev@samsung.com, cl@os.amperecomputing.com,
	linux-xfs@vger.kernel.org, hch@lst.de, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v9 06/10] iomap: fix iomap_dio_zero() for fs bs > system
 page size
Message-ID: <Zoxlo72QteVSz1Xj@dread.disaster.area>
References: <20240704112320.82104-1-kernel@pankajraghav.com>
 <20240704112320.82104-7-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240704112320.82104-7-kernel@pankajraghav.com>

On Thu, Jul 04, 2024 at 11:23:16AM +0000, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> iomap_dio_zero() will pad a fs block with zeroes if the direct IO size
> < fs block size. iomap_dio_zero() has an implicit assumption that fs block
> size < page_size. This is true for most filesystems at the moment.
> 
> If the block size > page size, this will send the contents of the page
> next to zero page(as len > PAGE_SIZE) to the underlying block device,
> causing FS corruption.
> 
> iomap is a generic infrastructure and it should not make any assumptions
> about the fs block size and the page size of the system.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/iomap/buffered-io.c |  4 ++--
>  fs/iomap/direct-io.c   | 45 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 41 insertions(+), 8 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
