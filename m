Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A81830DEB5;
	Fri, 23 Jan 2026 09:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769158925; cv=none; b=TWvU36aPsB6Afcsnojl/P8NzkgTh3HVJPOOxrJC+FPqqjliSR52srVuK/cMO34dOdx+nCGOa5Q6mHvk2E3iqZusuRxxzxnokJ6+coPM1+yR6ciSsCLXPYs83eO6mB2tyDioT7mvahLA/bzE5mAL2dvuVsjRXi9tYRCTpnWgVcD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769158925; c=relaxed/simple;
	bh=od7QhlGz8k6QGdfYBAw3FTNk4NeE7Nl4L1tec8q7WJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=imdzrp0+lr/jVv9/FQxXMdppx+yAmFn2GEBSzx1bSR1u5XE4Pth4sJCpRndjGCg4+O+GFDGogqkfey22sV6GOqfv7UTHo/3b4l5lJhQTIJLZecmMiDX/DjEK1w7NMEfxLdbW+lk7bUXJtaxDMM3/MxBrnOlbwRCgb/zPqgia/1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rNuE9VS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rNuE9VS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF4EC4CEF1;
	Fri, 23 Jan 2026 09:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769158925;
	bh=od7QhlGz8k6QGdfYBAw3FTNk4NeE7Nl4L1tec8q7WJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rNuE9VS4oatYoGZWS+yaU+S677RGpEt1FgJ2oVoo9gZy2zPxHTxJyKiPmLK2KsoCF
	 oBM/Idb9A/ygW78xPVdxVXyces4DVhsowCOiZ+BSTWAJOuUEUirUxqVt1O7SBlD/5q
	 pGOPTDTr5mKrYu/15TuBea33le6eX1EP2f+/LA/uU80Oc91SBpQY0nFX84R/GOzvkd
	 4qdA++xreiBESUBkIXk11zWtllQBtuDRsal3YB7ZtR54IRUZwmpm/UoFoyJ0f2JbSX
	 S2o9NADU+Y7cpujBLAD+/1pJeSPlBg/n5J2Fu4XbSrbTnv0NSk4JR/epo3LPOuCNY4
	 d25c4bQmd+EeQ==
Message-ID: <dfeb80f0-342b-4710-b098-2722da5ea060@kernel.org>
Date: Fri, 23 Jan 2026 20:02:01 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/14] iomap: support ioends for direct reads
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-13-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260119074425.4005867-13-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/01/19 18:44, Christoph Hellwig wrote:
> Support using the ioend structure to defer I/O completion for direct
> reads in addition to writes.  This requires a check for the operation
> to not merge reads and writes in iomap_ioend_can_merge.  This support
> will be used for bounce buffered direct I/O reads that need to copy
> data back to the user address space on read completion.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
