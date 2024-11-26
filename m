Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E684D16C687;
	Tue, 26 Nov 2024 05:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732598296; cv=none; b=HW+U0A1vGEpRMfWY5aOV2ZU2sEyja/gqMaS9rFHMcfY5cYQhMMRdFiJDHvDFyfC3rcXQcSHSYLIP05m+y4Cfy/g6yCJsUzSM/4JNJ67SoZQwrzFZPm00DNne5oqjYnGGi1o0WA/2B4Ymaln9TrqYpzyUKW8NZq34g2gM8Dlzrz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732598296; c=relaxed/simple;
	bh=WkwlmBSb+NVuIgxhDHKprKfWj85ge9SaUjroCuxusVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bcrPAMUoa1AuhHaMMtS70F1QBG9zqRF+K2VV/gy7V+GmaxCNz0mpWJB3W50gn6x/adp1oDsLmiSPus540eCKBzavBzks4rGXxIavIHiosR/2N9g+fpulAjo2PujDfTFWtrtk6Tum5RTzsLMsDnVvLDhIftMG7lnnpC33ncLXBXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V3vBF3bL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V3vBF3bL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Dv2W+al+MzcTKCK5k9ZEcjYsIl7duNfQ7UycB8/iYA4=; b=V3vBF3bLulGXgGk0XLsqEdRgLj
	xQW82lh4BGoMzswY+agd80rmB9PU43rn5MQEpgjmMcp8ngLgojrqe+cooWMXeRFRTd4LdWVMGh+ak
	yhLhTw949MzZJKPDA8t4eVmL2JT3T3LmGMjPWhlrTdUTPw6Wu5UIOSnNdhajZi9v1EqWblRPKNHI/
	T5gKLN6aIXycYFLJACVAeEm9ulGqAMlxuTf0c1gygA7JxVFdScS1urxbIi31XTu2zOxEpDTqpsGW5
	OduyolgiJHBSbR7aWxfPXwCObWX4IWArKZrWoApTU5XZ9IOQtISlmAXjj8kzouAJqO3yGomL8F7SA
	cejgC+9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFnxm-00000009f0S-2UW2;
	Tue, 26 Nov 2024 05:18:14 +0000
Date: Mon, 25 Nov 2024 21:18:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/21] xfs: don't lose solo dquot update transactions
Message-ID: <Z0VaFnJDFhcfs9K_@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398090.4032920.6440798067032580972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258398090.4032920.6440798067032580972.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 25, 2024 at 05:29:08PM -0800, Darrick J. Wong wrote:
> This is currently not the case anywhere in the filesystem because quota
> updates always dirty at least one other metadata item, but a subsequent
> bug fix will add dquot log item precommits, so we actually need a dirty
> dquot log item prior to xfs_trans_run_precommits.  Also let's not leave
> a logic bomb.

Unlike for the sb updates there doesn't seem to be anything in
xfs_trans_mod_dquot that forces the transaction to be dirty, so I guess
the fixes tag is fine here.

Reviewed-by: Christoph Hellwig <hch@lst.de>

