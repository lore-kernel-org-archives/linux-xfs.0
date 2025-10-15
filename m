Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB103254BB
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 20:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760561368; cv=none; b=iblZjvZRBKOZf72wZn7bHC4rEPT2tkXNF/FRSXvdji4xSlkaCcGgEYwxKoBxTLHtD8skBemJTaE6rqqR6Uqz8HfYuqRCIzR4a3llZIsQN0DXpMKkgBbhAdcegun/zdLdxHGMc7/Wi1v9NElm1gkFfI/w12znnqihzw5KcbPiBC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760561368; c=relaxed/simple;
	bh=UmDLpH0vzZtApf00pfDiSU7Gyo9PT9iQwmLTp+p7NNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g9dMovdJHEwzLFzyARE3lcdW9xVdI2hY6HLX3w3nfzEQYAM3e8dbvXZQMaLZ5thAY2jI2mEr+Vtzl/VYzz4UAvDbsdlKzb/uSrejZ6wghJM22adDCYsRlTOGFJuVpjb2Ih1Y2MX9cbZx9L+Z9Ag/K0GDeE1kHuRqKaac9x8Yahk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=S5HTGDhc; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="S5HTGDhc"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7930132f59aso98397b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 13:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1760561367; x=1761166167; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=auiaq9bXtW9OcLEmzCAQsL1QWCboNbAO7KbnHsw+v7A=;
        b=S5HTGDhcsc00RYv02MISYGgz5+oZIbltK9jaocIczgx9US7FsQCEdeSkdf5kM0C2hE
         uL+NsPp3Z+VIa6NPsm/Uydnbde4n8Dd9NkUGdThIHl7G0TsXJfbEZZpjZD0+Miu2NQqY
         UTV3jQIg11bThugDJeCPiHzrrd7rVCZyPoXXkoSH6njyd0le0P96a6wkzJaxWWr+hK5O
         7kjGIPH9feoYDz1AVQD4SMunR9cfMwxq53pOEvksybT6XaNi97nAmF03ZlCOEA7OXMa9
         RSrsf/GUk+aCFQGn9n3P+G2BY/5GqkEWxzjbmA5nF1SZuEE6J8W8NLsH/6V9vqbCNIkU
         w+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760561367; x=1761166167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=auiaq9bXtW9OcLEmzCAQsL1QWCboNbAO7KbnHsw+v7A=;
        b=He1dp8+KrfZ1v67npUgX4eSBjf55rEDYoc9XhymhvO0iJ/lAsEf2Cm+xUAishgaQaD
         mGzvt8d8rt/g/4SQ6/DGbkdwFwP1nNoGyBWZo74RNJhmf1dWjw9/V0Lp5O2xsMIHO5St
         N5ZqbOjEow9YVGA/ZM+lFr1dUx3FW5JJnBEj8LcpD8igrhA67XiNTe0uuDD+EP8awTkr
         43oXiZ5UxiLtlowbzD/ArWPP6KliThsacKgNTFHCETOtWO5h+K+9W3jrZnAyT3Qvcubs
         i3e4rOx5bssCIPztapYPgXVKQIlBduMhCOw1ym9TZY1JPJeFjwfrVTNvqVrOnbrcvps/
         j+Ow==
X-Forwarded-Encrypted: i=1; AJvYcCU03sjn6yfOIx9TDSNCQHCdsD+YYV3tL3rQ5EVdcjsiA8wpNXZSzNCgZa7GpT9l/ugnuosQLQsUOCE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbZOELMEYdETIawGUJmTUWai0hWOxsCUDGjZ1nP8V4jLpl5J4H
	AlCAvXilh92WrSRA2rbI7rh5AXMn2z6MKZeQpOmfTLV+N6WZP5+pgRRt3A9DZhhcxM0=
X-Gm-Gg: ASbGncutxwC9pqKIB5G1ZiNvLXs+jWj8P91gtkx/m30sHGiFw8zu5rpIegDhFplCq1H
	EUlTRtn7YmYo3lOmLxaofM+Aa+0u6SsP38UcAmKi6O8p4Q71iXxciVLnXSn9wRMPSue2hU79YrO
	Qkn1cYoDU+zmfEmUtvGmkNsUV8b19I2J/QRKoLoP7gWeoa9glVZIEhgGnYmr8giWxa2RckL0KOt
	N3nJY60kuiRX9SyMq64wry7OQyPJhFYPM58BfMw+uO4ILL96BrtxMHkUrRMCWpmFU9bg/B+9EVQ
	GRImjUuHvyPKkHgg5j1gMSzlsanjK4xDvZuvEalOmtzshFuiMGxYhzUboA1RCKKtb2eMqfhR1Xk
	PuGp8Y+WBwznMKheGa9MkhnU/Nv2m0pBNwrRxnDlfoTn94mhnGDTg68pkR6GTgwk+WVGVmWXSyK
	xDISU1Bhf17mgsfXDPCQHpqLr8YdCPKc7lknIEATlkamn68dD3DLmsCAQ4viz84A==
X-Google-Smtp-Source: AGHT+IHxmIPwCOfcZsbFhwrxgWT3gZcy36a1nJDg9vCya37PskWUDI/8725jdDe3RMayeVo56dRu2w==
X-Received: by 2002:a05:6a00:1406:b0:78a:f70d:b80c with SMTP id d2e1a72fcca58-79387826a86mr32369735b3a.22.1760561366355;
        Wed, 15 Oct 2025 13:49:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d0e2774sm19762406b3a.63.2025.10.15.13.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 13:49:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v98Qy-0000000FJEJ-1QPI;
	Thu, 16 Oct 2025 07:49:20 +1100
Date: Thu, 16 Oct 2025 07:49:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <aPAI0C23NqiON4Uv@dread.disaster.area>
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015062728.60104-3-hch@lst.de>

On Wed, Oct 15, 2025 at 03:27:15PM +0900, Christoph Hellwig wrote:
> The relatively low minimal writeback size of 4MiB leads means that
> written back inodes on rotational media are switched a lot.  Besides
> introducing additional seeks, this also can lead to extreme file
> fragmentation on zoned devices when a lot of files are cached relative
> to the available writeback bandwidth.
> 
> Add a superblock field that allows the file system to override the
> default size.

Hmmm - won't changing this for the zoned rtdev also change behaviour
for writeback on the data device?  i.e. upping the minimum for the
normal data device on XFS will mean writeback bandwidth sharing is a
lot less "fair" and higher latency when we have a mix of different
file sizes than it currently is...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
