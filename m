Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202D313CA95
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 06:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731913197; cv=none; b=Yf/ISPulKwSdoLTdiEBZx7873OwaSqdknDcjhzSmnACQMA6AWe/k8yGv72P6RNmMXP4ATxf5tEGQuPBi0A/TBupK4sDnEzLc/cvllBFBu1iIDnbf87XBFiHnb4eGUAzcZI5thhLxMu9hVACudI/5anIIyD4fx1Qgguj8Ploy0yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731913197; c=relaxed/simple;
	bh=dhJVvMyIpdiXT/SShVYSgC7CbUy0uDYRNR+Jm7/ct/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTYWhz9rQhoA0GvSPMkyuhdR+WoTZ4YOVBB+KPFP4ECZukaWprveS8AAN2Z3lBQqiofLych/TosNU0vFeQW2KT3XjoAYq9pcjw1q4DeAgdWc0ZP0c7BHmn1H0suWz2ckJxmAK0pxd9NQbh1RyMNw6Tuio3EWiI745/sHis+M9XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T9EgRf5W; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T9EgRf5W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ygTUqQ1T5sdduje3yM6YeD84bIbbOnkm8WtmmPsvgUg=; b=T9EgRf5WIuohmCOpVxAgppinc1
	WgjNFxdcAbLLDY17jhFtHT1jx+bfnjTh176ji5DxWd+98mD+km5NfzOXWf+wdWCKIP5cAJViiEFNK
	zOe9Ai4Gu9diTQBnjoOKrPj9T7q/VMeQ9JGDSQMwPwbmQFUCuw//4L6z8y795nl2ThINB3I29F2sr
	dVr0f3CQgE7ZUSwvoJlQK/FlZKvBhhPxSBlXzo4EzrjzGzXe05ekxNsuaQ8RTxzwKL82k177BlcD7
	4JX57CpQofb8yBXetRGzz1noNKqrt2H+WwoJzRGg19TKFK2rgl9wayQ/du4CeDjMhyrKPppdzaJSW
	LHRscbOA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tCvjn-00000008anP-3325;
	Mon, 18 Nov 2024 06:59:55 +0000
Date: Sun, 17 Nov 2024 22:59:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zizhi Wo <wozizhi@huawei.com>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfs: fix off-by-one error in fsmap's end_daddr usage
Message-ID: <Zzrl63rLW3h9G0z7@infradead.org>
References: <20241108173907.GB168069@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108173907.GB168069@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> @@ -737,8 +738,8 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
>  	 * we calculated from userspace's high key to synthesize the record.
>  	 * Note that if the btree query found a mapping, there won't be a gap.
>  	 */
> -	if (info->last && info->end_daddr != XFS_BUF_DADDR_NULL) {
> -		frec.start_daddr = info->end_daddr;
> +	if (info->last) {
> +		frec.start_daddr = info->end_daddr + 1;
>  	} else {
>  		frec.start_daddr = xfs_rtb_to_daddr(mp, start_rtb);
>  	}

Nit: no need for the braces here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
