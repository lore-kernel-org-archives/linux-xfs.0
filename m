Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7434D1EA6E
	for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2024 23:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707350054; cv=none; b=RKdGQAwOWe9kxn/vr6f8OpCM9cnlarGEWsEh5dJ48r81r4NRML3i4z9nD1pp2DX9nnU8K4GWdd4dOGE54Q46Cs9jCfQWW93CayhbsFHhlNfdPSm49QOm8T7ER5jXBsE4LSjVUf92TQRB3wZJLGKyk0eVDgLR7BEqpjmel6XEjmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707350054; c=relaxed/simple;
	bh=YS1SoihYpxYV6ImW/p0cr8hOra+pxcx/6uuM40cw0vE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXF+R0pqOMxuIFlMFqi4pmKm38ag/zpAlkEM7459IxukZjMt0P59OYx+zuRoPHhOlhlqH7fTbgab/0NLcK7TddEQ8L0j0dgiCR7GUBZ3bauVmpnDxLfql5k5PyNxo26N+P5SU+DMFt8y67c5crOwrNlNUhcWg2Q1SSOyhvnQE9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=DMEj7dkZ; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="DMEj7dkZ"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6da4a923b1bso1012421b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 07 Feb 2024 15:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707350052; x=1707954852; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=urayTzFDAD3toseV6L1NpHPSbq5x7nNFQF7qOyEtSPw=;
        b=DMEj7dkZTRivwCJvyu5TiewCYZ7L0HSbfmcwU0wR2lzwboL8DfZVm80SgqZSo0Jd6W
         4nH17OXSbwLpui0rtP8AGe9u/YaBYvkNACwnvNYkcJ6VAgmhL3omOIgM2TzRXyERhvUP
         wXrZxoLnqxkR5EnXmNQJapKt8uH2DTg8wFqvfwJnATS0y+uA372d7iURhNzFI0h0hjbM
         8B7yANOA8Sr2xl6uymQD6DRyyQM+2nxlpxC7nVhW44iV15L4np+1mRxq3SuCRtkgKARY
         TpWj3/ErHT4XL5U/4vmN0zf1OnLrSeIsd3o2dtBEa4BBv6sP0Snmh9WqXIt714hda064
         hp1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707350052; x=1707954852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=urayTzFDAD3toseV6L1NpHPSbq5x7nNFQF7qOyEtSPw=;
        b=vi2HMSslS1OcCcAtf24tLzB63DTqKElHRhhg4TKcjDJEy0g+QdVJ+zCNVPQpi2qQs6
         k3AMWDu8TSOru5ED/zm2CpNcek5cFDLTlOIAl+HDXX2TYTAUNr8hwWWKMdJrtpGfQcxK
         6INkEwsEpOl2EHIsmRxmOkqXaXjVvyhzmP542njnumL9wX46kJBYCPEXfnV6R7jyVPwu
         ziKm+nMk/H2FBoKTr8EY5hPpeCgGUBXpvXIekD+CAR+FmDDeLlL2EW1D4Ft70v1t7daj
         zJezUpeNpJ7XpZ8nJmJDnEmlrPml0jHI6Hp7EMgtJcNXC5W7uLsEFQLpw880Za8k0gEO
         /QIQ==
X-Gm-Message-State: AOJu0Yx7uatPPV3XuFj8jfTTqQhU3e8QhtiTF8NYsv1RblxDv6d+iSIZ
	dhEKm06b93bUmbUQ3jXYOnLmHfZA9ggM6Dw8xDIMXIG9UD7hqGVTzVRr1eJPGgs=
X-Google-Smtp-Source: AGHT+IHID15cnRs/C6HBN//rKKrKlh4mq+ysyI1MimK9DUeqpEanRDrRHYcOn73GDkQdSk0VMn5+bg==
X-Received: by 2002:a05:6a21:3383:b0:19e:3c51:7d37 with SMTP id yy3-20020a056a21338300b0019e3c517d37mr7244766pzb.8.1707350051668;
        Wed, 07 Feb 2024 15:54:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWyI2aoCjnV5fn/cm576Z9H7rGrWajCbc1+3YlEEVXqMltaWEz0r+MoJr2kbJpEYXvRKcNhvZwtWctmM88lrz830yRSGPL4akUxBfwu7FFEMzMMLvKIBk5dpvmI2mT4H2/gH0tvhWRjbUfjo6EgNweKUVwJno9i/pHTld96gXjW1byn2LerPw==
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id q19-20020a170902e31300b001d911dd145esm2063184plc.219.2024.02.07.15.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 15:54:10 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rXrk0-003U5g-1F;
	Thu, 08 Feb 2024 10:54:08 +1100
Date: Thu, 8 Feb 2024 10:54:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: Max theoretical XFS filesystem size in review
Message-ID: <ZcQYIAmiGdEbJCxG@dread.disaster.area>
References: <ZcQDrXwyKxfTYpfL@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcQDrXwyKxfTYpfL@bombadil.infradead.org>

On Wed, Feb 07, 2024 at 02:26:53PM -0800, Luis Chamberlain wrote:
> I'd like to review the max theoretical XFS filesystem size and
> if block size used may affect this. At first I thought that the limit which
> seems to be documented on a few pages online of 16 EiB might reflect the
> current limitations [0], however I suspect its an artifact of both
> BLKGETSIZE64 limitation. There might be others so I welcome your feedback
> on other things as well.

The actual limit is 8EiB, not 16EiB. mkfs.xfs won't allow a
filesystem over 8EiB to be made.

> 
> As I see it the max filesystem size should be an artifact of:
> 
> max_num_ags * max_ag_blocks * block_size
> 
> Does that seem right?

max sector size, not max block size is the ultimate limitation.

Not really. Max filesystem size is also determined by compiler,
architecture, OS, tool and support constraints

> This is because the allocation group stores max number of addressable
> blocks in an allocation group, and this is in block of block size.  If
> we consider the max possible value for max_num_ags in light of the max
> number of addressable blocks which Linux can support, this is capped at
> the limit of blkdev_ioctl() BLKGETSIZE64, which gives us a 64-bit
> integer, so (2^64)-1, we do -1 as we start counting the first block at
> block 0.  That's 16 EiB (Exbibytes) and so we're capped at that in Linux
> regardless of filesystem.
> 
> Is that right?

We could actually support the full 64 bit device sector_t range (so
2^73 bytes), and we support file sizes up to 2^54 FSBs, so with 64kB
block sizes we are at 2^70 bytes per file. IOWs, we -could- go
larger than 8EiB, but....

> If we didn't have that limitation though, let's consider what else would
> be our cap.
> 
> max_num_ags depends on the actual max value possibly reported by the
> device divided by the maximum size of an AG in bytes. We have
> XFS_AG_MAX_BYTES which represents the maximum size of an AG in bytes.
> This is defined statically always as (longlong)BBSIZE << 31 and since
> BBSIZE is 9 this is about 1 TiB. So we cap one AG to have max 1 TiB.
> To get max_num_ags we divide the total capacity of the drive by
> this 1 TiB, so in Linux effectively today that max value should be
> 18,874,368.
>
> Is that right?

No.  It's (2^64 / 2^40) = 2^24 AGs (16.7 million), not (2^64 /
10^12) AGs.

Also, inode numbers only go up to 2^56, so once the AG count goes
above 2^24 we'd have to introduce a new allocator that to handle
inode/data locality in such large filesystems.

> Although we're probably far from needing a single storage addressable
> array needing more than 16 EiB for a single XFS filesystem, if the above was
> correct I was curious if anyone has more details about the caked in limit
> of 1 TiB limit per AG.

AGs are indexed by short btrees. i.e. they have 4 byte pointers to
minimise indexing space so are limited to indexing 2^31 blocks.

> Datatype wise though max_num_ags is the agcount in the superblock, we have
> xfs_agnumber_t sb_agcount and the xfs_agnumber_t is a uint32_t, so in theory
> we should be able to get this to 2^32 if we were OK to squeeze more data into
> one AG. And then the number of blocks in the ag is agf_length, another
> 32-bit value. With 4 KiB block size that's 65536 EiB, and on 16 KiB
> block size that's 262,144 Exbibytes (EiB) and so on.

Sure, in theory the XFS format *could* handle 2^80 bytes when we
have 64kB filesystem blocks. But we can't do that without massive
changes to the OS and filesystem implementation, so there's no point
in even talking about XFS support beyond 2^64 bytes until 128 bit
integer support is brought to the linux kernel and all our block
device and syscall interfaces are 128bit file offset capable....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
