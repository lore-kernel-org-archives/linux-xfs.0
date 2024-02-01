Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFA73B789
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 04:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706761061; cv=none; b=shGXTz/AvEr6dm09h6JYB2FXkVF3ovvfLHUWJidgBQJ0YT74uTd2Gcglx9SPKARJDd6F1ur/esE+B619F1fHTC3wzY8ejt7azYGKYsRMrPlwOHCKkpmGgB3Pg6G7liBdqx99Bq2NB4ziqttzUSAggE7PJr8saazzh7sWafrOACQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706761061; c=relaxed/simple;
	bh=CRKrxvCNfo4DxaQaa4wughrUTeyPN+8QubiVdbHviPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cnkoa2U4mA6pYmTPiR+HWNi1IbrE146Eriq5vteovRmB/kiAndvcm5mu4Ql0fA8HFgDL4hhs+x4zKurd7UcyGeZC1nUg2Yzpt2Fth+iMLPNpu8FYFzWdc1+PtFG+zUtygf7MK6Zc8pHjxGfbx1GwY6k3HoqGRAxxOiuK1yk5wWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ArBVE5ZS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ArBVE5ZS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CRKrxvCNfo4DxaQaa4wughrUTeyPN+8QubiVdbHviPA=; b=ArBVE5ZSZH0a5RV3i+lFIQif/v
	NH6ulHNCZGIEKgqduX6KTki+fFi9SW7eT/sxlJlPd5gXzX8nODnOhTJBo8tbIJb8mJqe6VJnPy1B1
	Fu/+YWpIt3V8kFV7Ykdan+faj//vmu6w6gnkGlwyZaTWJ7YeZbs2UrI++CrAmziKnpqg3tSPjhHmG
	EZr1LPBDd0c60kvZtX6IpEB6GgLE1V9XQMUwVKk0bpZOxpRRfUpNyGBUimOwnbKZyy/fMj2+Epx6Q
	pPsWwroSJS882ykgB2YyWq/I1bN5zyjfBztGeCndPHFCYUljjygngo5JJz6tt67prikm+Gl/hkSbI
	/uw0YuLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVOW9-00000006TY0-1WyC;
	Thu, 01 Feb 2024 04:17:37 +0000
Date: Wed, 31 Jan 2024 20:17:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanrlinux@gmail.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: disable sparse inode chunk alignment check when
 there is no alignment
Message-ID: <ZbsbYQt55lr3-ReM@infradead.org>
References: <20240131194714.GO1371843@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240131194714.GO1371843@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(and we really need large blocksize support to be able to test
64k block sizes on x86 :))

