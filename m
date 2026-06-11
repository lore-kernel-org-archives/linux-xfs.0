Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64CA1DEFE8;
	Thu, 11 Jun 2026 13:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186391; cv=none; b=o1nXms2YfDjllCJ1FIfhcndjxf8IvRAGc1X3q08s4zZI59fVH9DN3UhENahtRwg1UU9fKE6z6vNBX4HSAdByXi9hR6ubHsr1/go87Ym/3OhBJP/rJONGETP7HXktRxrYFqF4c6ct/kxrRztSgKxUMrr9EEhDJwzu9HtnrE5vw7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186391; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knUR9mO+MLzLOk6+zdeFywh6VxD8MxcThTljum0J5oUTFBsGKq8wnj9R43Y6Bu/s7kI2PSUytGLM0XSb/GOMkFW766zRSx+SgbG4bZm4PcxsLww0EBC4TVVhi18EFy2/rd3ummhzJZDulehwHMtJXivedmCg9WuS6dDbbdvwanE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OtR6zw32; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OtR6zw32"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OtR6zw32I6i/oUiiRzQlnRpGCS
	pNqc4N1eekL2/kZRGv3eDewZNCje54dAtBYXh8JE4IOWY+CqJamXRRlCB62Yx+uK21khvAHtNrEPp
	d0FV0b9qpzJYt8eyOJ9Qicls2By7aPfdSGGz/kWcHGhLjp5mZqKOEABX8DWLoUR5iPhzP25D0Ye53
	jM0vfBrFS3Yc1/27KOu7KJaUyqYmFBImNfluQJVYltH1DvWrmS4cj6+bvrVweeMUCOrxhvcqavTUM
	YsNuEvWk+KWPX8rjhS9ghAVSR6V4sNGRDKqiqM0k9AMGEY0u/FUWm8PEqhSjAOIDZTDXp6B+6YSZR
	IpEAutcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXfwi-00000009ZAU-3x45;
	Thu, 11 Jun 2026 13:59:48 +0000
Date: Thu, 11 Jun 2026 06:59:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikhail Lobanov <m.lobanov@rosa.ru>
Cc: cem@kernel.org, djwong@kernel.org, david@fromorbit.com,
	hch@infradead.org, hch@lst.de, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v5 1/2] xfs: skip inode inactivation on a shut down mount
Message-ID: <aiq_VPH_MxcmE3O9@infradead.org>
References: <20260610191904.12533-1-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610191904.12533-1-m.lobanov@rosa.ru>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

