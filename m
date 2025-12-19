Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B35529D291
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 09:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766137031; cv=none; b=renbuSWl5NArssaBSwXXbPiHzs9Zvz4YQt7l1MLUnU618VG6dWlNZ5lsM36Knzz+RNFhOQVkAdRiqawafQVFtZl13AEbJfjMSNvWK0DMTWACq5GGjNGii8vrVh4cV+9cdvfH3eSauqn4+Tg3F5eJwZtaMxNrynwiAg433xh1LY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766137031; c=relaxed/simple;
	bh=WQaccYJL4EjaMnmNrPUftS1uF8yTtsuSGK4ww/5whrw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Y8gmUiit2RJqyLDbHswrj++Kzorog/bUBPo421r1Q4m3+lNkVg9mBBf31+9vykTfCgfNolQ5SNNDi+LIBrTixiV0T78zJFpbjY0TYg9tQEhIzow+BrlrBDMXo5h9HDVIRrv+6hKh3an9GBbV9JraYTP2CS570BF5NNX6dCnJaro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZaiL9gU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZaiL9gU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FA0C4CEF1;
	Fri, 19 Dec 2025 09:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766137031;
	bh=WQaccYJL4EjaMnmNrPUftS1uF8yTtsuSGK4ww/5whrw=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=ZaiL9gU2VuSwJXLWYSYRU3zfLPmmOBpmYovnQUtEoLPB/LjCUWmoeGh4FZLAax6cz
	 Z7/PhKPJJYhqh3cD+9uNQRLfaoW6IFe7OvnQZAtpQaricPjrJCDALXk34Jm8kOFrH5
	 MkLvWNik/Oh9MgZt70fW116crDBZYu6bWGNBFf9zMrGK4ZgBuLRC3W5YyM1+WhtdnI
	 rJ0c5y5T82XAo3R912iZjXBopLBeERCWQtj1REY4fl3OR9hfr9536T9sk7KUjTjkHC
	 4B0Em17tlkKD/7w1BFhhPXNa6GggRSSHZgKG6N5xo0EwJCRc7qjKRbGBI/6aeVPuJr
	 A3joHVbMFpI6Q==
Message-ID: <4f788bad-b621-49d5-bfb2-0af75ae84379@kernel.org>
Date: Fri, 19 Dec 2025 18:37:09 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Enable cached zone report
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
References: <20251219091232.529097-1-dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251219091232.529097-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/25 18:12, Damien Le Moal wrote:
> Enable cached zone report to speed up mkfs and repair. Cached zone
> report support was introduced in the kernel with version 6.19-rc1.
> This was co-developped with Christoph.
> 
> Damien Le Moal (3):
>   libxfs: define BLKREPORTZONEV2 if the kernel does not provide it
>   mkfs: use cached report zone
>   repair: use cached report zone
> 
>  libxfs/topology.h | 8 ++++++++
>  mkfs/xfs_mkfs.c   | 7 ++++++-
>  repair/zoned.c    | 7 ++++++-
>  3 files changed, 20 insertions(+), 2 deletions(-)
> 

Please disregard this version. I botched the patches and they breaks mkfs &
repair on kernels that do not have cached zone report. Resending a v2.

-- 
Damien Le Moal
Western Digital Research
