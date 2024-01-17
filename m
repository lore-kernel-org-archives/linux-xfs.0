Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3FA2561B
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 21:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705526075; cv=none; b=XYcts++9qQz+qHZgiCbXspr9hHhD8+x5vgpgjJmoVK0vMmQvTk61SYtI//PtYoKhkeeEw1UUhDVgi9fzZxSgEUTIX9oJRm+AnS6uR9ifVn4NDHYPPnbAT3Y9AtQnGQ7izQRZxqTY1tMkmUB7DON5P9T1Lc3M/rWOonfdTPq9sd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705526075; c=relaxed/simple;
	bh=m72cEXbghjz93vQK/G/IAjFnDqq7KoqnNtHMQsbXvXg=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To; b=EWtgM1aosMA+/Olzn9sTxAU7KZrP2J3UFFBgbPpIVjWtti2nmmCIKbEn1Cd0PxkeBAr7U8v/XIoHlM/eGotG8I9X+AHM+BS/wUrIqhoPj4vFKQw7Txutp4dcJqRF8aFNc4M6sOPWWoBnDaFaldtQstTsU9++fUePe1JbzFlejMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=P11yZNZh; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="P11yZNZh"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5ce0efd60ddso6378938a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 13:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705526073; x=1706130873; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fv6o7A6PuwILmYlfaoY/53+kOfCnsqQLdRoAQu8Vxp0=;
        b=P11yZNZh0FA2UZc9MJeOwdcGr1ATqWgiYyhuvF9qsc0AumEccHwNJYYmjrbY1GALcy
         Koj6hvvzAl1kZjVwkoTxZ7Wlyw6ygcWl0BttJScIVy+fwnKqwQkLxAkFWJvalmkWenqa
         2J9zKWj5sbKHUmBNZFkL6UMzkDNOC+wfZ3VOdVpilqJRTWmtaG9e4JUbrsnPTSjCnRLy
         iw8cCMiRGUFXT9xl9CI7JmAfXhSugwEognLute1eA18Xj8uLztu4ZxHM+pveygOjP9Sh
         Cv0v3hbOMUWTdc4Df8OAY8eYHUzQsb36dhFNBoRKrmYq5H1P9csZDZP8uFu7WUetTK1d
         0Lng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705526073; x=1706130873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fv6o7A6PuwILmYlfaoY/53+kOfCnsqQLdRoAQu8Vxp0=;
        b=dAJ9eHpHsV8Q1YU2vJsxP2DQ6Gr4IZPatfeAEfsa5htfkWZdrngs9lFnSgwujQk9sO
         GsMBuOS/IjNXzUoVIREoNFi//QGCL3UjklxIhMrgKUdtJEWzTuumMOWNPhnTrBO7x637
         PbgwHmGckk4iVLJiOqUmY2NnSEZpOxOkP3a8hHTgL12SdMcndAmaWYuqkJVKlAoWhoXR
         zvuoOKbNsi74gqpqWREh5ZsyZReLnSFWyLftifwIrWKuHaoepkH5vrx9ZvmOqmfCjUw6
         gWlyQ5jLM2J8wicg0K391DX77ETfM8BKlQcR+K1WwY6j+aRy9pz54C9rdODdvx/mps0r
         YbZw==
X-Gm-Message-State: AOJu0YxWPF2XVSUOmq5QZvuniONPfehM/EdJvYRGqCYUFTXWtjhchY8w
	SoxS2StG85Tr5RDjbwmIYU8tder8ltEZkw==
X-Google-Smtp-Source: AGHT+IEZsCYP+ZaErdpz8zrP+wRtiKpEhSVYBmnJxoqGWb8EG3uSSJwqZIst5xr2/qezvWd9MQpdBA==
X-Received: by 2002:a05:6a20:7b26:b0:199:8fff:de89 with SMTP id s38-20020a056a207b2600b001998fffde89mr4456537pzh.30.1705526073387;
        Wed, 17 Jan 2024 13:14:33 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id z4-20020aa79e44000000b006d9beb968c3sm1908598pfq.106.2024.01.17.13.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jan 2024 13:14:32 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rQDF0-00BjmL-0s;
	Thu, 18 Jan 2024 08:14:30 +1100
Date: Thu, 18 Jan 2024 08:14:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: fix log sector size detection v2
Message-ID: <ZahDNkhNhd5s7ZR8@dread.disaster.area>
References: <20240117173312.868103-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240117173312.868103-1-hch@lst.de>

On Wed, Jan 17, 2024 at 06:33:07PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series cleans up the libxfs toplogy code and then fixes detection
> of the log sector size in mkfs.xfs, so that it doesn't create smaller
> than possible log sectors by default on > 512 byte sector size devices.
> 
> Note that this doesn't cleanup the types of the topology members, as
> that creeps all the way into platform_findsize.  Which has a lot more
> cruft that should be dealth with and is worth it's own series.
> 
> Changes since v1:
>  - fix a spelling mistake
>  - add a few more cleanups

Series looks good to me. Nice cleanup!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
