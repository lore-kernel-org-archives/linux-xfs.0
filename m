Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E351531D2
	for <linux-xfs@vger.kernel.org>; Thu,  3 Oct 2024 10:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727952343; cv=none; b=lX954GRm3Vw3hHyX7u8O08XITw3fX0lEMopT4ceFIkCKaf3YAdFO6828H3+qZxKw89VrSN4FnZy8kaNIjjvs+QVFHbfgT/b55n9CV+oqxRuVuPhy+Gh363XS+6dtEePjZ66zS20q0cftAEQQQPuDnsAyEbS9IKp8CPgr3yGTIIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727952343; c=relaxed/simple;
	bh=JnDst/N3EU8yXgVsCAnf0R6OPYnWSUN7cuQxkqSLUqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KyVat3ml9RU/c9NTHugh/hfDJsCQz/DpAYTbrT/GOnuclm+vlK2gv3EeqE3SY0LxuP1g2BpVBV2YVgp7JfEdiqegcMFIXwn84ixwmJiNBHxogm43kCONguTN9bWLvbHtYBdHYWf9f8fJsmSNakU8OcxIKnriUqf9sqNO5cHWjws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=L4yUiyjl; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="L4yUiyjl"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7d50a42ce97so335474a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 03 Oct 2024 03:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727952340; x=1728557140; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o6UEGl17TzSnxTVIe1qUXkNcfbf0xAa9jJkDuFXexI0=;
        b=L4yUiyjlYspY5GbjjV57mDjnDtLz4boQhMHNQW2JnEwIB6/kKcut3f8DI7c0ajPyV7
         pQ44zRRYaFyZU7P2lqq6ttuT6VBqXekagyHx1dZ5uxTyAfNik+9KEmNippBnL5LU0pu3
         e0SalqI1K4HxavWYuaugt3EDDkM0dbJn0xN1FBFVXN+m/R3yanIKb4Rxet7qnkryKqcg
         OQs2T4j3BTZDFORppiD1iQjpNCNCUN+zPJSLjR0sdgDUzmEmygwRWOXnX0JS3yrk/Nsl
         QzF6v4k0HSt+QYzTw692WR4/5NA7gNnp566Fjtxrndtz5ttTh88zP8aoaknx/yH/99rf
         3jHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727952340; x=1728557140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o6UEGl17TzSnxTVIe1qUXkNcfbf0xAa9jJkDuFXexI0=;
        b=xDsGG2xEVvp7Fb5KL05cfKSyTmmcPjzpl1E3IFj0bE3pfzXzqpJIHA5/dIh2/RSJ3A
         IAynHWu1J93800cB9pTjHL9NeeLqerBu1lIM+yW1di+nepWlt9lO6I1C6I90JE3KAlyD
         7wcc/BJE78Ndn7qk5wMAb+ezuvo8eSDNbW42iIDw6Hn44UnVHegEE6pHqCO0W+nGYjq8
         i+HQEZg7ZOLvMSOSdcae6KT0vNT75xBQQKkvvteRg4nV/AJiXKpPr/ibMbNAQbv0YrHK
         ZAZcr9tN20VU/whqHZkJVFgQistzWp4XkN2Bsmjzq3NGO83GcVL+TVQkrKBPaUKJZdPy
         fZtw==
X-Forwarded-Encrypted: i=1; AJvYcCXbrKMZME6/jegHEimIDMJX9Bw7/hdg+96ISdp52Jo0N7ZUwfy4kmi4Dg4z2x5GQ7JXzwVjefffxXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqCYRCp1ovkp/NjLTQVCDpXqnzxF1ZmMOeU91zzpxBkk3ui3Zj
	ZLTC5ClDZZWwB+F1ngKeyu1iFTtYySHRmam7I3mH+UdTUmBGDI1fU8O0bcjdTuU=
X-Google-Smtp-Source: AGHT+IGoytEofKifwHVbCQpUDi4tPiiN7+0yohLIMmp0p3RrLmvhOU0hAQk1EofdGGJ9Nht5ooiEog==
X-Received: by 2002:a17:90a:c713:b0:2da:802d:1f95 with SMTP id 98e67ed59e1d1-2e18456b4e8mr7835223a91.5.1727952339868;
        Thu, 03 Oct 2024 03:45:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1bfad5d15sm1232890a91.7.2024.10.03.03.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 03:45:39 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1swJKy-00DLpH-1h;
	Thu, 03 Oct 2024 20:45:36 +1000
Date: Thu, 3 Oct 2024 20:45:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, kent.overstreet@linux.dev,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 3/7] vfs: convert vfs inode iterators to
 super_iter_inodes_unsafe()
Message-ID: <Zv510LDnAtmJFuTA@dread.disaster.area>
References: <20241002014017.3801899-1-david@fromorbit.com>
 <20241002014017.3801899-4-david@fromorbit.com>
 <Zv5EcaWsFYHhlMaI@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv5EcaWsFYHhlMaI@infradead.org>

On Thu, Oct 03, 2024 at 12:14:57AM -0700, Christoph Hellwig wrote:
> > diff --git a/block/bdev.c b/block/bdev.c
> > index 33f9c4605e3a..b5a362156ca1 100644
> > --- a/block/bdev.c
> > +++ b/block/bdev.c
> > @@ -472,16 +472,28 @@ void bdev_drop(struct block_device *bdev)
> >  	iput(BD_INODE(bdev));
> >  }
> >  
> > +static int bdev_pages_count(struct inode *inode, void *data)
> 
> This are guaranteed to operate on the bdev superblock, so just
> hardcoding the s_inodes list seems fine here as it keeps the code
> much simpler.

Maybe, but right now I want to remove all external accesses to
sb->s_inodes. This isn't performance critical, and we can revisit
how the bdev sb tracks inodes when we move to per-sb inode
caches....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
