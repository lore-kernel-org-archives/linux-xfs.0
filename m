Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E10C12FB39
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718303736; cv=none; b=cPL/ROzv9upvm6QThv7AwQfh4vRKfhNUQm7RyRph+snj7hFPHi02FLHT/lcnabHYqvV+/Y/zut1pOYS2zLUvykYHegddt/0T98i6nQd/UjfF2Yqhs8ZO40LQ/G6iP9esVUIwSS7LJu/LTY08CIbJN894ZKeqzbl2L17OOMCJrFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718303736; c=relaxed/simple;
	bh=08KmIanXenDZPVXxfz2uvO5EQceJXFkcraxWPIjgyco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3rH1E0lrjlwo/tEyay/w5PZijn/xe/zgxoPJLxXLbUpTCbNbbWCz6DiuFuYUC/TC9hqx1JcuaTA5nNY3ZjSZbgjQgz7qEQ9iymfm9A1y0fJPnzKwiMvy78nbxFPoyVBdc1ghpuJt6ZA/NHByck8raX6Xz7f0qQ00h29Cpt5z5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YYtcAAsl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YYtcAAsl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0H0diF+ZnR8n0YjbWhBU7CLBvI3+PNmRyeRgvM0tt8A=; b=YYtcAAsloyVfJ3Ar9ZGNgNIxqQ
	sM2dqgPp3t6+A/uPZw14SCFUAa1qoPo0bZm/+cUBZuAXOmqDoau2+NaMiTnI09/WCelqVAaREPgd9
	wq8mDR3n55KfgRRB7gVDewseF8Zl8Ep+0mMDj7RSbnuaTOhqUdywPOq98K+s5f9mferJR30SGcLP9
	G4L0RIY+rOWOgQPje6xEMZs/RdbIIqaBeb5sbqTjuk7Uo+2WzL6lFem/+namq6LNa9qJRLB8sRcj8
	XOj+CqoRAr8kNUaGolnv43Oyl8PEPzq3DKOxDbXg2Vap5//sgozKG1IgIKuFo4AYmRMDYqTDp4Xch
	6miOYC3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHpIM-000000007ed-1xpv;
	Thu, 13 Jun 2024 18:35:34 +0000
Date: Thu, 13 Jun 2024 11:35:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH 1/4] mkfs.xfs: avoid potential overflowing expression in
 xfs_mkfs.c
Message-ID: <Zms79pN-ijC5Zu-V@infradead.org>
References: <20240613181745.1052423-1-bodonnel@redhat.com>
 <20240613181745.1052423-2-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613181745.1052423-2-bodonnel@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +	log_bytes = (uint64_t)max_tx_bytes * 3 * cli->log_concurrency / 2;
>  	new_logblocks = min(XFS_MAX_LOG_BYTES >> cfg->blocklog,
>  				log_bytes >> cfg->blocklog);
>  
> -- 
> 2.45.2
> 
> 
---end quoted text---
