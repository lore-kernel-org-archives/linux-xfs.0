Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437C6333440
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 10:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780914039; cv=none; b=gbwFOwwdUcmoPbYB+fYG7q9NoqomK0LJEYKkxeVeWBRI/F3FT+oJjpsBdyWF8PvK+cm/+HPp2wpqonuQ6gnOyPBMlqAU/mIRVxlEcZGXN127bq3MGHvT3YctLEPGAzDVM1Umre7Gjo21lJdWLZfTVPSwMlihxj8y0XYLq/MwHqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780914039; c=relaxed/simple;
	bh=qJHtYoJremAlAjr7vrEgcY+CflKCtnpspO1p4hKziUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wd2idJWbZo272TJ+w2VCHlZ8kj6B0FsVGHs7k0zmpWAjgNHnOxzOclwgxqztM2AJmFSSKZVugSItOPSxd5Yzo00LFwRImzsgq9POUIMOvF/DaBAabZrA1+vcEwlzNj1aehXqtQTUdy4Vk60gO9urf8Jf5NiqeoU+Sc8oMOaCI+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RSOdXBj3; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RSOdXBj3"
Message-ID: <7084832c-800b-4248-aaee-3da5ea266c1f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780914035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S2p5OSJgNixRE6jU10gQiRnnvNmi4wdQ8Jxz6iq3bpc=;
	b=RSOdXBj3pX4W6AQvSabYYlXLNcQbYInNYNEGQ+JHAdBmLtIz6G6Cd7cyqyB3AcwxY3S7JF
	9dOeCqAhfALnexVtdMU9gQySTygFJ2enNPlwJLlRjUdv8enK80KMKkiDmgErsGR/lN4VFc
	ngvV/rI1rR2MYF+5TRkjuZygld+UqAM=
Date: Mon, 8 Jun 2026 12:20:29 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
To: Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org,
 dgc@kernel.org
Cc: bfoster@redhat.com, lukas@herbolt.com,
 "Darrick J . Wong" <djwong@kernel.org>, gost.dev@samsung.com,
 andres@anarazel.de, kundan.kumar@samsung.com, hch@lst.de, cem@kernel.org,
 hch@infradead.org, pankaj.raghav@linux.dev
References: <20260604101442.2613872-1-p.raghav@samsung.com>
 <20260604101442.2613872-3-p.raghav@samsung.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <20260604101442.2613872-3-p.raghav@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


> +
> +	error = xfs_alloc_file_space(ip, offset, len,
> +			XFS_ALLOC_FILE_SPACE_WRITE_ZEROES);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * xfs_falloc_setsize() would re-zero the written extents via
> +	 * iomap_zero_range(). Use xfs_setfilesize() instead.
> +	 * Update in-core i_size first as xfs_setfilesize() clamps the on-disk
> +	 * size to it.
> +	 */
> +	if (new_size > i_size_read(inode))
> +		i_size_write(inode, new_size);
> +
> +	return xfs_setfilesize(ip, offset, len);

Sashiko reported:
On 32-bit systems where size_t is 32 bits, lengths exceeding 4GB will be
truncated, which might cause the on-disk inode size to be permanently updated
to a severely incorrect smaller size.

So a simple fix would be the following as we already store the value of offset + len locally:

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 37623baaaed6..86fae2190c24 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1426,7 +1426,7 @@ xfs_falloc_write_zeroes(
        if (new_size > i_size_read(inode))
                i_size_write(inode, new_size);

-       return xfs_setfilesize(ip, offset, len);
+       return xfs_setfilesize(ip, new_size, 0);
 }

Probably I will update setfilesize to take 64bit values for len in a separate series.

I will also wait if others have any comments before sending the next version.

@Dave: You were against the initial design[1]. Let me know your thoughts on the current version.

[1] https://lore.kernel.org/linux-xfs/abCzhDSVmFx4PtWI@dread/

--
Pankaj
