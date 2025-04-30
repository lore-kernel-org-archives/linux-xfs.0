Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4F42DC77B
	for <linux-xfs@vger.kernel.org>; Wed, 30 Apr 2025 02:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745980695; cv=none; b=e1RcwpHRxTCagtAdXOhsEam8anJNHleNIfNJTWAuoNNGfODy/nFxTwGZ3Jj2q8+DB8IoXUEGmgx3IOGF/C2BbElFLlM0YtHwaXpjfInd0D+t98WHa/o5GCOZoXiO1RZGYIQ+ujZIuft13bMRFA9B0rhJRZ9KD0rh6i24IyQ3wSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745980695; c=relaxed/simple;
	bh=ZfO8Eg44enoviFYo9oPUz/Jr0pBgzNIp7DNC6DQjYdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mgrl/Bj+bC0Hx0/7tQ+AKlrcQS7m1GLWNmgkSolrwEaho7Xiat4PDiYKfNe7pg6AX5txpiUCv9Riqk7riKBaWO+26jPVYSudVvzYlkKE1uk1HanF1GYHxtzpR3UXweeanj6YeweTGMFEGobTt1f+KdwhCV8tSwZo7vIq0WBgwcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=vrPnWx0H; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="vrPnWx0H"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-30155bbbed9so5519241a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Apr 2025 19:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1745980693; x=1746585493; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8MsDugTNdnsbZxlwCVQwe2nNngSFpOenJ/fQTp1DoN8=;
        b=vrPnWx0HBV2seHBvJySN+nd/r6tgnJIhtNtVEDB5WQGRDV2f4p0NdaYPh/T+c++qSK
         GCr9higumYpHBk2jjJmjYdKh8JNP/eMzLXR7Awy+E6zxUMV5pssISQMcgB5becLgVk/5
         arZAnQLstTULJluuNB+Wm1rYRQbJSeH0LoG9LKlu7ppBaAnlAP0NiR0V9X92xXNn0R/W
         iaE2xKPzfpDhKJZNoS80ADRQHsMqCK+s2WVnos/bbets3VC4vNWNgm2KRQXXNxINpCn9
         k/h1mxZsDiElvo1kTpjWuFqTnLn+4sOaKthZtn3j2uNHQcxFLx6fz3dn6qAaIwh3pIf6
         amDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745980693; x=1746585493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8MsDugTNdnsbZxlwCVQwe2nNngSFpOenJ/fQTp1DoN8=;
        b=FHDFe7XoPiAr1rcSqxgPkOxx+ci6ANuXrkXlW9V+7u9mrnjWUF9YnLvA3YCiqEeAjk
         WtviTC/AV+CyWyfn/w+E0marlSe8s4HCoWya69Tpfaj4GJkp8H4R0yiu9C0RT6MigOlj
         E7Zv+BifkfPaEntib6cWeYhxWVmsDpLhLmny6nl2J/9SuYweLAM6M+6sX+hQqUCuIHnq
         WbkYz3ZPT0QvTmsYYsU8agLX5kmL91l9txS9m5VQVwAviL1E2selAk1X3wHvfS6pFdsG
         BRkuuAdFjad4w1dWuV2TGT8bWFWZryEkpCmW3YM0sTHvv3QNDFRKsXRWYa6oDWr4LFud
         jWHA==
X-Gm-Message-State: AOJu0YyJ2CPVhyOMkMKSLF4hKp8qI5Dl8fw8qf51SN6hQ0ch/C6NzT2c
	xVto+IOAHAZlNH3WJ7K8DyUvRWtONglpuSNeuMLdT7HMLcEO7plT6Mno5xFVIxs=
X-Gm-Gg: ASbGnctgo44eG5W053LnZqKZoFul94sGOGtZzosTNagOuzTwzW/YI7hbRK4Y8wWSgaZ
	TrmsiOHDqPWfjtcRxxE70tDPGuhQkAjjlXgqMpDR2mFC1DmxucNizHZUc7OE8W/O7f00l6MwJ8N
	Cud9qIZThP793M0kUd9Q+Wg/Q7kSHa97X5ZPbR+CaQonqCeAJP5QxF+s/M+fniH1/ysXj/vvzzG
	udgaY3ODe5QtWp1cLtYuiMtcHV2tgmhGmqnr7luRJUW3aqFdUuA1sjvUPUsGZtK4X5jLB6UA+Nu
	L0QMzJ75Iebj8BtLZkLg5xThiINEpYPxTqcraT31oaO1gf4jA4/rv9dH9ozWOjbxwXOu7dboRnL
	HRWMHoJfWQRbU5g==
X-Google-Smtp-Source: AGHT+IHsLCOS4eBHDruSuTeeAlSHoZ6Yzawr7sbrxM8MhUiRyHAIr/al2u9eSaq0nzG7culaXCssOQ==
X-Received: by 2002:a17:90b:1f88:b0:2ff:6ac2:c5a6 with SMTP id 98e67ed59e1d1-30a33367f5dmr1740559a91.31.1745980692719;
        Tue, 29 Apr 2025 19:38:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a11a0asm331827a91.23.2025.04.29.19.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 19:38:12 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1u9xKr-0000000F3as-268Z;
	Wed, 30 Apr 2025 12:38:09 +1000
Date: Wed, 30 Apr 2025 12:38:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: export buffer cache usage via stats
Message-ID: <aBGNEUfidgqfXpkW@dread.disaster.area>
References: <20250428181135.33317-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428181135.33317-1-wen.gang.wang@oracle.com>

On Mon, Apr 28, 2025 at 11:11:35AM -0700, Wengang Wang wrote:
> This patch introduces new fields to per-mount and global stats,
> and export them to user space.
> 
> @page_alloc	-- number of pages allocated from buddy to buffer cache
> @page_free	-- number of pages freed to buddy from buffer cache
> @kbb_alloc	-- number of BBs allocated from kmalloc slab to buffer cache
> @kbb_free	-- number of BBs freed to kmalloc slab from buffer cache
> @vbb_alloc	-- number of BBs allocated from vmalloc system to buffer cache
> @vbb_free	-- number of BBs freed to vmalloc system from buffer cache

This forms a permanent user API once created, so exposing internal
implementation details like this doesn't make me feel good. We've
changed how we allocate memory for buffers quite a bit recently
to do things like support large folios and minimise vmap usage,
then to use vmalloc instead of vmap, etc. e.g. we don't use pages
at all in the buffer cache anymore..

I'm actually looking further simplifying the implementation - I
think the custom folio/vmalloc stuff can be replaced entirely by a
single call to kvmalloc() now, which means some stuff will come from
slabs, some from the buddy and some from vmalloc. We won't know
where it comes from at all, and if this stats interface already
existed then such a change would render it completely useless.

> By looking at above stats fields, user space can easily know the buffer
> cache usage.

Not easily - the implementation only aggregates alloc/free values so
the user has to manually do the (alloc - free) calculation to
determine how much memory is currenlty in use.  And then we don't
really know what size buffers are actually using that memory...

i.e. buffers for everything other than xattrs are fixed sizes (single
sector, single block, directory block, inode cluster), so it makes
make more sense to me to dump a buffer size histogram for memory
usage. We can infer things like inode cluster memory usage from such
output, so not only would we get memory usage we also get some
insight into what is consuming the memory.

Hence I think it would be better to track a set of buffer size based
buckets so we get output something like:

buffer size	count		Total Bytes
-----------	-----		-----------
< 4kB		<n>		<aggregate count of b_length>
4kB
<= 8kB
<= 16kB
<= 32kB
<= 64kB

I also think that it might be better to dump this in a separate
sysfs file rather than add it to the existing stats file.

With this information on any given system, we can infer what
allocated from slab based on the buffer sizes and system PAGE_SIZE.

However, my main point is that for the general case of "how much
memory is in use by the buffer cache", we really don't want to tie
it to the internal allocation implementation. A histogram output like the
above is not tied to the internal implementation, whilst giving
additional insight into what size allocations are generating all the
memory usage...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
