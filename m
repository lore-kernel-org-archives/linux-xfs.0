Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B970839FD;
	Sat, 22 Jun 2024 04:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719032019; cv=none; b=src5sGP9amXIdehrTSYYJF9Ub2EWgu10c4wxyni/ZOc22a1SUMEVvYlxx0JXHUR+qILpPdBDidsBc+u6sK7Fk34hKvaN/te9tzR/M1SzGDTA1NGXNoMJqrLStoUhxFLhWmsE551R1pr16Qpz0I5qSjhI88Oe6XrUv7emKZYXLac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719032019; c=relaxed/simple;
	bh=xyywLfFeMCkh7O+cOYW9oBU/UwctP4XxjqjGcMnPLEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jsgVzbJvvzjNqBF+3Jozdktc06OGOhgGHILKAW8oRMSDRlK4Q8lqMgvIi46y4Ag3gqvLR+pHtwBEJSo8ZBFdokXEe4axXfuNGjqzDL7IrnBNCZLhL3CoP6Ml2/Zzvg8rgAVxy8+SG1t9iXxPP7txlzAeqdanwvirK2xeA7xMZjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nKcP3gdI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nKcP3gdI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3YzaBe1Yi3SAM18WLxvb1zLjoWJoOBHw6xfWfYBvkqE=; b=nKcP3gdI0vvsW7bNa/GyMAzU0N
	TM+nYJ08UsPihabVuW3KT2J0+qpKG4uQPuo3B82ke9EP/K0Epy2INt2vf5ByTxl4gOMjyuLiFreyM
	7UCESEDdqvepAjPK2iFNZ/EsX0jVU/Uit788yCzsSR2Z6F3a2728zbb0CXBS7mX2gebvnLe4ZWEmt
	qRolLmxDCny6/1WS4YoW+NpcucAiJWZdjbal9vx5/SIBKMxEZi86uZDeOPVL/qFTsh5n/zD332QjD
	ZZ2jF5obCqfIk2ztwdL7NCGKrD16wVotopxpNSIA+5J0lU8sL+JiGpoykNfR1x9bGZOufySpRaNi4
	L3rGQb4w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKskm-0000000BOZf-31No;
	Sat, 22 Jun 2024 04:53:32 +0000
Date: Fri, 21 Jun 2024 21:53:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: shaozongfan <shaozongfan@kylinos.cn>
Cc: hch@infradead.org, chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs:trigger a-NULL-pointer-problem
Message-ID: <ZnZYzI1P1b8ohTw1@infradead.org>
References: <ZnPjpCovlQq7_ptP@infradead.org>
 <20240621063452.516357-1-shaozongfan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621063452.516357-1-shaozongfan@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 21, 2024 at 02:34:53PM +0800, shaozongfan wrote:
> +	if (xfs_params.fstrm_timer.val == 2666)
> +		dp->i_df.if_u1.if_root = NULL;

So what sets if_root to NULL in the original report?  We'll need to
fix that and not work around by things that just change timing.

