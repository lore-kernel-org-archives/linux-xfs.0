Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE301DA23
	for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 08:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776153757; cv=none; b=nMkyCZDU7wyidL0RDB7bQIeyp8HYiQqiOj3Ci8c3JagW8rtTY4h7YW6E6itfZ7AZcEK0XROKrDhoWs+iErQUHj+RVUmpHLWbxjnRoz32R6XivtuqMizuNpGINDOvl/fe1pwsOxueHtMgtQKPIgfDj8KfsQIUY2Dm+ZNLbMg60L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776153757; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BEvPsg9BAB6xu5OCtUfj5vWcr/PPKfr8ialyHk8AJRggGbnLFElYMHgp+zEEFUnrM7Zu9o51rry5a364x7Ces4XfPsw+qKg4aHYUOJ5L/fA5mznC9qp4P364c3Z/cO1cRFePc02Bjk3akooblzmtssYtDQAzaJWQCZCvG7wb28Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tkSAkmFg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tkSAkmFg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tkSAkmFgtaTfLAmCq77X1NkhLe
	L9IG3SZ7cG9rLeIVqhNnNRKphI0HO7CfGsStxQqJ/eVxCQzkcDGJnWijj/+XChYDLdg2g3RFH7cRd
	nnBLlvPuGD8+4No8Slt5w8xzGtFAPBh4UFyJlsRLzIs6+np9n1FNQx/0F6N6VbHkpynZRMJ8rxsza
	2XwRw2s899fBsUviW47mxvplm9KvkeSZKrACV5o823wuR0rV2OgeBH1qcNspZVjGoW8NQlmU6EnKQ
	JiLUwEwQ5ja3qropkcUlSEylDD0368mTxVxOSq94R+hCi11mlkKC9l4f975ERoHG6M/mMlCHKiTp4
	kUOGdC1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCYjD-0000000Gw8s-11DF;
	Tue, 14 Apr 2026 08:02:35 +0000
Date: Tue, 14 Apr 2026 01:02:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ravi Singh <ravising@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org,
	hch@infradead.org, aalbersh@redhat.com
Subject: Re: [PATCH] xfs_quota: display default limits for users with zero
 usage
Message-ID: <ad30m3AEWU817kVr@infradead.org>
References: <20260414071921.1226575-1-ravising@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414071921.1226575-1-ravising@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

