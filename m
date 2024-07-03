Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C7D4DA04
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 06:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719989584; cv=none; b=BcQ9Wloag0wW1N4NcJESAW2Xa/UMhEpda2yV3ss7QsxOAizHDQpkTx8DcCas3zMaC4Q7eSC9zFc5IjD37XrfN1o2i8B6hR5ssmAAJnKYLgAlsIBLA+h231BIG3J86/aeHRIUsDfExvlJqrppz3KQ4tyl9UuEA2EGiUVm02PIE4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719989584; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/NMciQVYJeVF8B7pU4y5uF0Q7CiLQ1u2CIdd6aHuty64GVRFxPlRBz0bArL8JQ/BMe/TlJ9dfKTX1eTo//I4PDvUVSsDnI10PTkrtasLQdoqCoRg/y1ZxOQrgKBpSPENRloL6vKpMy8jW27FOcyXRijhQGSOFzxzFF/KE8Jp2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EUnkvEDr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EUnkvEDr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EUnkvEDrhbWbqWXAF4DxLZBC8R
	MV5Imtm+RvMRLezRuNv1UCa2gPxiJOoweiDk8ASt4HhBZlyZ9aDn3FeVukvSGZvAmAeXSM9PnFIsU
	ussnQBL48j+CB3oS0vqc8c+WGJ/IQoc3S6T3A0ILfsh3NEk9uut7OGNHOmRrP+5BLfDKaqXsGKNVR
	PSvB95AXQ4LBJTffWWPWgvILiuZVWYi3icyxPr0Bbqi/sryDzSLFeD5+NQ1Rr1R/1TYEDSdfseKg5
	F5z9CQZNP0+QBwDBzcg5iWZMJmgVK3EuXTL5DVIwAxd7nUEWfZBn9wql96IV/v11UGwDb5RP+Ihmy
	iWedNUog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sOtrQ-00000009G96-0RZO;
	Wed, 03 Jul 2024 06:53:00 +0000
Date: Tue, 2 Jul 2024 23:53:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH v2] xfs: get rid of xfs_ag_resv_rmapbt_alloc
Message-ID: <ZoT1TFvXniMFgLBD@infradead.org>
References: <20240703064226.229599-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703064226.229599-1-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
