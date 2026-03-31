Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594753ED5D0
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 09:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774950186; cv=none; b=XYN6IOoGN5cNdXLtbd/9URvEACuta6yQzR6Qgviltz9L8ENOIj1/sFJ22kp693vfZ4VEqiWbz81nEUOB6QhusQehNrsAHAZ5dM9Ri5EqYSDNQxjO8ZoBz+gGFgMwQdxjWhgb7ZlOq+vQ1+hTTXWkWUB0qa1bJ1SwgXQBBps5SO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774950186; c=relaxed/simple;
	bh=E0RcpRqHBKw8rXaGvbaUS6SLzMs/SCxCIt8PGrbwZFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c6FeSibnYbZIzwLsxaeNyl9mOvzrGyTR4DzaEZzMepDweB7GHAcbRegJm+F2jXQX9y7fCxyKCS1u1m3EQWV509Lv1GrClznSP3gGC0OnhiTTQTwbfC/NPUywbHZwI2F+v9Wp6vcamM1ZP/sVJeixCAjrc6Hb3cxShx28aSH3WaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jVqxn7LF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVqxn7LF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51725C19423;
	Tue, 31 Mar 2026 09:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774950186;
	bh=E0RcpRqHBKw8rXaGvbaUS6SLzMs/SCxCIt8PGrbwZFc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jVqxn7LF8SujWHiCCYu/c/UgQjbikmueyaqovI698RKafli+uSHZ7Pf8vN5jv/eo8
	 ZUmYqvodUaJstef8OhV9Vhu36hMNTRGb/EGOg1IlLnDkhyFf5Hpz4ylIuct+O8tEL4
	 v3d8vLSfMPVb5skOQAaZrv0BOm8HNqfAstTAXuEkh6FddHRYZvO9UvvS+2bBgENPX8
	 SoHuPB4VFKQWu0W4IBkr0U3LnLR9hT8ySnTvrbjkRP8bslhuD+phKolAHJBHFWiCjH
	 3cAbR8CrdyXCV3KMbslX/ugigYIHy4eNA4Ftm/vCrXKEh3MzajC7mfBRFnLKOKdIQ2
	 kV6S3g2+TNXYg==
Message-ID: <0fdd204c-06b6-4417-b816-15a77d48b201@kernel.org>
Date: Tue, 31 Mar 2026 18:43:03 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] xfs: refactor GC zone selection helpers
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-6-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260330054533.3856339-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 14:44, Christoph Hellwig wrote:
> Merge xfs_zone_gc_ensure_target into xfs_zone_gc_select_target
> to keep all zone selection code together.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
