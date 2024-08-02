Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4328517FE
	for <linux-xfs@vger.kernel.org>; Fri,  2 Aug 2024 00:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722557160; cv=none; b=qz9IH8Bd+ZIixbvuZ0a8xVW+T6EUvilsa7GdddK4bInQsIeYScjZOU/vynDfqY6bKCwtyVvX4HZFY/4iG2RDugx+3EwMBAom8VNIhIS38xILtWKPjj38DDDnP534U667Hasw8igrEj1wdOVHGcs9d+8hpgGnu+pNrbC4Ryekw4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722557160; c=relaxed/simple;
	bh=kPg6hNpv0fyQQ4C8xugRnahcyI2M1VfEIoO8Iylc6mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W9X8J5a0OHJUEg1ksyaEMVI7+1b04lUm13FqBzvwjvCi9dADHuj8xdy1fUXsd0XzWHNsgqnvPrRNXeJwYZRSdhstxqWjND4E06jsQhSwGLBfrjunLhSEkKriHYLuS3Fqhl7G/3SrF2U5Wh4YxwWm9QmpFJC44rXP0dkSZxbVT64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=KnYaLdmd; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KnYaLdmd"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1fc611a0f8cso57193025ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 01 Aug 2024 17:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722557158; x=1723161958; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BtsQ+3NXr7Z0grTXgI4VJ8mpDigb9614hgPF8/mg2ek=;
        b=KnYaLdmdx2kIS5cRhTBo9gtYC5Cuu9GWeGnR5/z9WkUTP3MTuLgzH26Y+un7cTRsYv
         yJjicBTWTBNCawOIBZTDcWdv4BWNIc/mkZRKIddb9YMD+TLu1uBop98FeKxls5Qk1yzE
         TUReUZcKvWJOhfKmskXQMXSij7vO1d0bHmEYOmecSuIOfcEg4fwKVWZOePvrJpHdJV9b
         QytxvDv0VDbTl82WF/WQ9T9I3wSGFHPXgDV/7/BFZ2kSWDEJCRa/EOtwi/17BOn8IWM/
         aqSPG/PcPAThwVhNVGLDusX1cBPb/4SrRJQgnEVPAiCBqnFDleu3VtqIr40a2GMAs7/v
         HK8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722557158; x=1723161958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BtsQ+3NXr7Z0grTXgI4VJ8mpDigb9614hgPF8/mg2ek=;
        b=d6nf8avM9nMPyMboqZulXmQqP2BXS/wzBNj/6HfWcY/nBzvtTqIzpoNt3t9T/6YYGh
         Zkijr/HP0dOEosGp8/mosANwHu8LirIaSvlqlk2NAHp6XLsnp2XvTWdw7x4TURlJ5x28
         oaWYkSwkZdp20gYaKijEOeL8BMmLk0/6ewo1szmLyc7/fqFMWCePCTJ64Y0rfcxTJG1I
         jyUT6gD95X7YBToqO1t2Yne1hoW6xmW39XJ23j51f7bkga65TLrIPUX2Nx29ncBOjfY5
         8ydixGEespfdOQB/unNTCuU/XnJMjVc9BqjWYFdzr/LSBFkQXkuLUCiCUNAvC3wmamaR
         oXnQ==
X-Gm-Message-State: AOJu0YwXku5lotf0r/GjKY2FtLjmKQw+NVt1V/dZtUmKMVX9cNYVmTip
	KNZRG8sy8QbPHqPvMz8JN5F0BmG6o/A+J9XpxfBkb1HDXwXh924JB8pG3ziOelg=
X-Google-Smtp-Source: AGHT+IHAi8u2E0Zyx8AqxUHQRqLu9oFcTolJxIePwk6jnTPCdufSt8G3TT6DihMhy1lfh6fr5NcjNA==
X-Received: by 2002:a17:902:f686:b0:1fb:6294:2e35 with SMTP id d9443c01a7336-1ff5743b563mr26795165ad.50.1722557158429;
        Thu, 01 Aug 2024 17:05:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff592acd2fsm4645375ad.286.2024.08.01.17.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 17:05:57 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sZfnv-0023B7-1T;
	Fri, 02 Aug 2024 10:05:55 +1000
Date: Fri, 2 Aug 2024 10:05:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, djwong@kernel.org, hch@infradead.org,
	brauner@kernel.org, jack@suse.cz, yi.zhang@huawei.com,
	chengzhihao1@huawei.com, yukuai3@huawei.com
Subject: Re: [PATCH 5/6] iomap: drop unnecessary state_lock when setting ifs
 uptodate bits
Message-ID: <Zqwi48H74g2EX56c@dread.disaster.area>
References: <20240731091305.2896873-1-yi.zhang@huaweicloud.com>
 <20240731091305.2896873-6-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731091305.2896873-6-yi.zhang@huaweicloud.com>

On Wed, Jul 31, 2024 at 05:13:04PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Commit '1cea335d1db1 ("iomap: fix sub-page uptodate handling")' fix a
> race issue when submitting multiple read bios for a page spans more than
> one file system block by adding a spinlock(which names state_lock now)
> to make the page uptodate synchronous. However, the race condition only
> happened between the read I/O submitting and completeing threads,

when we do writeback on a folio that has multiple blocks on it we
can submit multiple bios for that, too. Hence the write completions
can race with each other and write submission, too.

Yes, write bio submission and completion only need to update ifs
accounting using an atomic operation, but the same race condition
exists even though the folio is fully locked at the point of bio
submission.


> it's
> sufficient to use page lock to protect other paths, e.g. buffered write
                    ^^^^ folio
> path.
>
> After large folio is supported, the spinlock could affect more
> about the buffered write performance, so drop it could reduce some
> unnecessary locking overhead.

From the point of view of simple to understand and maintain code, I
think this is a bad idea. The data structure is currently protected
by the state lock in all situations, but this change now makes it
protected by the state lock in one case and the folio lock in a
different case.

Making this change also misses the elephant in the room: the
buffered write path still needs the ifs->state_lock to update the
dirty bitmap. Hence we're effectively changing the serialisation
mechanism for only one of the two ifs state bitmaps that the
buffered write path has to update.

Indeed, we can't get rid of the ifs->state_lock from the dirty range
updates because iomap_dirty_folio() can be called without the folio
being locked through folio_mark_dirty() calling the ->dirty_folio()
aop.

IOWs, getting rid of the state lock out of the uptodate range
changes does not actually get rid of it from the buffered IO patch.
we still have to take it to update the dirty range, and so there's
an obvious way to optimise the state lock usage without changing any
of the bitmap access serialisation behaviour. i.e.  We combine the
uptodate and dirty range updates in __iomap_write_end() into a
single lock context such as:

iomap_set_range_dirty_uptodate()
{
	struct iomap_folio_state *ifs = folio->private;
	struct inode *inode:
        unsigned int blks_per_folio;
        unsigned int first_blk;
        unsigned int last_blk;
        unsigned int nr_blks;
	unsigned long flags;

	if (!ifs)
		return;

	inode = folio->mapping->host;
	blks_per_folio = i_blocks_per_folio(inode, folio);
	first_blk = (off >> inode->i_blkbits);
	last_blk = (off + len - 1) >> inode->i_blkbits;
	nr_blks = last_blk - first_blk + 1;

	spin_lock_irqsave(&ifs->state_lock, flags);
	bitmap_set(ifs->state, first_blk, nr_blks);
	bitmap_set(ifs->state, first_blk + blks_per_folio, nr_blks);
	spin_unlock_irqrestore(&ifs->state_lock, flags);
}

This means we calculate the bitmap offsets only once, we take the
state lock only once, and we don't do anything if there is no
sub-folio state.

If we then fix the __iomap_write_begin() code as Willy pointed out
to elide the erroneous uptodate range update, then we end up only
taking the state lock once per buffered write instead of 3 times per
write.

This patch only reduces it to twice per buffered write, so doing the
above should provide even better performance without needing to
change the underlying serialisation mechanism at all.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
