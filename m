Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBF41C06
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 02:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710381705; cv=none; b=rN4URP2NuoNzpBgkI5P651KEFWVi/TLTMNkYHWbIZhMbHWm6KJh9I5/W57ttsql0d2CjCkEVkAnG7xJjnbxFMlai7GT7za7+ZxVe1ekdzeg/mNIh0zV2OydKCD58O5EJiUWFkq0NSuiqPqoVp4asUful2W0+t06p1RCCsrUxC/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710381705; c=relaxed/simple;
	bh=DbDW+Fde9bvPjXaPWwK2wvndG5R40gt6HVplCjj0KGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8ldU+vQYQPsdQjvxX0hdLPjKgRSNh6PVmWXOP6gYEPXdZI0qD5MK8ifoosX8eZf6cJfJBN+Hx9z74h/T12NWKDJyQf8EfLXkxV/qSKu7wceRd5LkndxgQiKhn0uhvQcDX4cl/f1MukKR9tpYz+D0Zd3mwcgLtPmbIEuX6kuapI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ODuqpzRC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ODuqpzRC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IOizRcoWtU0opq4h2FtSlEbX9WgrxvM+G1YGm8ZZGak=; b=ODuqpzRCMUXt5EaXZYm+6RpPJS
	hKM3RjmQB1uC55lZpCKPsy1zkLO2hhpyzpLcvHgzpqpr9z2jhyHqHqWDukccpmHxGHyCa4dAsgjD7
	sq3m/x+Wg2Uwbx1yMF52TQCV/aOi4sZDM0ukMwKLuSDa5UuO86B0ox2YHMp/SGtVXFmqgDGUZ/gNu
	aBM5kKqhQTPp42U4R7o1Wc5XCJYJ0pYlDFGOnCAtOwHvs/86TMe8opygU+g0r1u3MScj2cVPH/9Bt
	WdJ4NxGp4N1EoAdv/fI2OKgWeQldVfXq5Sb1c2XN/pOifu6ISSkKPE1DifFgdMiEC83LWA2BiNL1G
	8wrb5U3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkaPf-0000000CcoQ-07rE;
	Thu, 14 Mar 2024 02:01:43 +0000
Date: Wed, 13 Mar 2024 19:01:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs_db: add a bmbt inflation command
Message-ID: <ZfJah0BaLbNUFHSO@infradead.org>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434743.2065824.10519572186358226724.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434743.2065824.10519572186358226724.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +#ifdef BORK
> +		dbprintf(_("[%llu] 0x%lx 0x%lx 0x%lx\n"), bd->nr++,
> +					irec->br_startoff,
> +					irec->br_startblock,
> +					irec->br_blockcount);
> +#endif

What about just dropping this code?  BORK isn't really used as a cpp
symbol anywhere else.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
