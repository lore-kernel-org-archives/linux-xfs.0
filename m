Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588EC3314D9;
	Fri, 23 Jan 2026 08:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769157813; cv=none; b=in0iulEYtlD329HJseFb2g20+7TOohGikM7HjLfYUKvxPOJylGDI7eBX53225JbWzZ7ht07V/685vBzvJFIBRhLD12CH1xzLEvwH9OMD1iWBSwcmBSxnWpn+o8FZMUQ9yyh3bYdX+w/Cztqf9wH+K/PZUntuJ4qrHu+T1a26jOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769157813; c=relaxed/simple;
	bh=IjBzeukcuum7qie/wGvJsDRzxzqGbiX2MwG4HT1vpOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iL53nwIfWZVYgfL3FV6ZdK7eJPsRhcjLIbjHIM9HfC9L+raMz70UTyjtWoYbcVIG2vm7GtgkQlOsUvUD8DYbyPmvkXQJhI9Un6GKMw8KF9dh/fy5Oti+AD6WdG3Kr+Slm0jGpaBIcsr3bhyiR0yKXeXrA8e5wBY25SK8zmbxuYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPArbCqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPArbCqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6337C116D0;
	Fri, 23 Jan 2026 08:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769157812;
	bh=IjBzeukcuum7qie/wGvJsDRzxzqGbiX2MwG4HT1vpOg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DPArbCqFQV6S6jzffEe6x0Or3TFnRdn/3fz4YpibBhZDda9p91mptWfib3r/Y8qbH
	 OAXKo69MdcX5MZpjfNnS/ebLG5oWTzwZI7G5Uox15zaREF+WuqY9lQIdh0ykF016n8
	 CdzU2Beli1fOQz+KGaqlHonhep+HAXQaOMP2EwwkGoE0NVt1bHoIl5EgyIuO4Qv1tQ
	 lnoF4PjOiOv0vKiAtUj0tprRtsbnfcbO0pgMGlbqqpkuc6++fDU/cB4sm/leccyH5a
	 agm19Rj5oCAONxB9g4h9UAbJDY38NHYazFH2kDEMryrkupDIy6h3ybUxzPAFcd9enL
	 Xic3trAJivnWg==
Message-ID: <f556fdbc-604c-4c5d-b1f5-0f9ca9322e55@kernel.org>
Date: Fri, 23 Jan 2026 19:43:29 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/14] block: remove bio_release_page
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-5-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260119074425.4005867-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/01/19 18:44, Christoph Hellwig wrote:
> Merge bio_release_page into the only remaining caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
