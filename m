Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4050037F8DD;
	Tue, 22 Sep 2026 05:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054334; cv=none; b=qJhmuAQsdEYqPWnMC1CGlb+qbdN3oDlppQ7i94FrKwSIJQcBpMy+vadkj+qvAQjZ/SCiTtfmx2lbK3R4ZOfuBxlas81LDfE/RNs0Pi8tvN0bVQhCpaSkOS3tydv07HquwIpbBx/ppbbopklucGN6jN7X8nm7IdsedH1vtB0+Nns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054334; c=relaxed/simple;
	bh=2J3K80uJLaQHQe3E4zSCJE2Bj7NwsLbdUvMu/Q+ahTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LUwDyfc2FZoCqKcOBBqE3ZaV6dNmcC/8+HcKi0NaRh7kZwdDazci2UJt7Z5PikRaxYxHVYj1VCtHTcZo2txGgHaA+0l/9Z2uSL4RMMPu8+2kksvAxQNlgYR7PI3fRGhaHNojXKukEQZNbr6cbGt7pBn9jctnb0AqpVysS1tKH3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4M6E318a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4M6E318a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P44zRFJVm3Sj8WihFmCb+KiWBAOzzAb1+o385c/mquA=; b=4M6E318avLaUr+9xAU1l58RrkW
	vpMX/KWsmo5ILNslldia3cqxuoRjLrPpgJu/MUvtWeoId1ppIDZBSPWRvkgediuTnVO/PFfffNs1g
	Vze7NCWJsQgeVL7XbXSnH7psOkkjq00F6rvU20SiV1qk1n88Cj05UK5rhETucf0KtFpFzGxgRtHdJ
	8wPPpi/hYrwcYxJ4mPbC8+3AAIfyQrjFppS/qH9Obpc3O4tgJl3e3R7C8PQ6XRnxfJr7Di70eroTe
	Glv6wd4Rz4JWnUAGLnyq7Gu8kmsBk4ELF+Oot3NHXL7Gl1ZWz3fJJRFdlsQlNbzjKsdkxMNDXbf0k
	SU8nv6ig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8su4-00000004Egf-2kai;
	Tue, 22 Sep 2026 05:18:52 +0000
Date: Mon, 21 Sep 2026 22:18:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] xfs: pass xfs_trans_resv object to reservation
 calculation helpers
Message-ID: <arIPvDO2vAM3jGw5@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120658.181988.9146739765881528995.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120658.181988.9146739765881528995.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 20, 2026 at 11:16:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_calc_namespace_reservations computes the directory tree related
> transaction reservations for a given xfs_trans_resv object.  The helpers
> it relies on, however, read the live one from the xfs_mount even if
> we're doing this for minlogsize calculations.  In practice this
> shouldn't be a big deal since the minlogsize and live reservation
> objects don't differ in a meaningful way, but LOLLM complained about the
> inconsistency so let's fix it anyway.
> 
> Cc: <stable@vger.kernel.org> # v6.10

Is this really a stable candidate?  Same for the current merge windos,
at some point we need to split these fixes into those that could
cause real issues and those who don't to not flood later -rcs with
lots of updates.  And this looks like a very clear candidate to not
rush.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

