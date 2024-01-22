Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F1CF9C8
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 07:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705908404; cv=none; b=POVLQChwOIUS+y1rMYzpz1uGx9L81Z6UmYaDavVHqN5Epee6UZked0YtkG9RiZYPDoYVI1sVQOgF2llY6SReCd/DegiDCFRxk7fPKbQHy2zzjYxrjAbKVS26qPUIR8b/NYDc/dhJqrYep+JVVrRlPrzkjBv2K/4FOnuD4lES+08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705908404; c=relaxed/simple;
	bh=Dk5X4lDR3azjRCrsoB0vxvlXQr1SOLBMBEJtiohBudM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mskbo0ZDgnPaTsJFanwvZIE4en8Z2+8shzZBISuI5+MVUBsELRuAKgBq+ap+nrs34dz3u4xLT8hVfYez41vmX50V/zwm293WvABofqTVCc141MYh0bpn2aBJ+nureuOt+xh80O2K70GXPxGHiB05msQ/xUcs9H+cbLoCe1h27FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dL4W5Im5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dL4W5Im5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Kd1NYrz7DQHm9HHEuQGjr/3ssGIU5IiyBmWJGw4px9Y=; b=dL4W5Im5wAyjn9iuz/h5k02Yco
	bXIf5qDLjBK6JyrlY4CSdrDg2WJj9RGeTWmbEX7SReanmzljzvGOt/p+Sl8u064NTexSQ3s+uCwq5
	Ku/9kZuBBe3liYaI/PVYJmYGE4ulwmVhTH6BJFk3SFH+zFdRBtfHkiT0O+kn1NLsH8WItROIFvBLt
	iGUmihs9RGik+rcAqvY0kfE+/KP9dERcmqDTO3o40pU1jytknZKGyLyWtnJvs4sAToyOMHwp7Q6on
	TwouF0hi8GuIRz2WoUJnCRQ88nH+Eo/5FTOSBQAfLNoFKXKsbrDzu28a7xB4/1xIWkgSfqvEJrsOv
	Fna4o9Mw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rRohe-00Aqkp-1Y;
	Mon, 22 Jan 2024 07:26:42 +0000
Date: Sun, 21 Jan 2024 23:26:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Sam James <sam@gentoo.org>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v4 3/3] io: Adapt to >= 64-bit time_t
Message-ID: <Za4Yso9cEs+TzU8w@infradead.org>
References: <20240122072351.3036242-1-sam@gentoo.org>
 <20240122072351.3036242-3-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122072351.3036242-3-sam@gentoo.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 22, 2024 at 07:23:28AM +0000, Sam James wrote:
> We now require (at least) 64-bit time_t, so we need to adjust some printf
> specifiers accordingly.
> 
> Unfortunately, we've stumbled upon a ridiculous C mmoment whereby there's
> no neat format specifier (not even one of the inttypes ones) for time_t, so
> we cast to intmax_t and use %jd.

Shouldn't this go before patch 2 when applied?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
