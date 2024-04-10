Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7658F44
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725743; cv=none; b=fGbYW2qCtqPkwIfibjpn7wz16K27AWY0vrAFJhQ0uu6W3m1A/GZTSJGssODUOjP0tl/ALxMZi888qWRPuPlD7cFFMWrmELWrLIXh5T4mhMgST5yHSEe1W4KAu5lggwdjyhJIQ73T9YplbRms5qq6Lxcl8Jhg2Pk0VyrFJoP4sWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725743; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZAtCaG2N/lEnlDLVch0/l7kqd5mb20eOpyVVlzF2VBbb6Rt4x6bL2rjKR+MOOtTqWxCjjNRro1ZDmW0LXcd2czWHD7DdXcjGTXiB5i4GSLAoUdjU2SUK8ILHUmOJx9Z8dvLVTUafzaJ8KuGigEosxvaJ5v3qnNun954Hmzqd1DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MKJ0oy+B; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MKJ0oy+B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MKJ0oy+Bq1JqJKqgo6foJ2/JQk
	+v7Y6AzoMlxnfsP1PSEdZjK0Kcw4SGVPrN63GY86Jvm6AIkRzZhpckjrY+yVuBdpH6RHsuvA52dzb
	5h7QPV0gfd+qWK03f9B7UhkoA27S6O9KePMW7Nky1t8TFinTDwUP6bIPXB4dRPXgO5KEj472wTUzE
	q+e3v2YFpAaKg48Bq0tP5SN6PTQISNY3kOmU1eKOkIYJeWTVc1e5oUDIyOOvlEtK9Wofx3c5B8XAG
	D/wpMhHMpkrHrTbjuizT2P4MZpwZFdx1Qb6DK63LNHB/F0nmkpF+3pz+aql0+RVdQPR3KK0bebDMz
	DFfpmD0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQCj-000000057rM-2vdN;
	Wed, 10 Apr 2024 05:09:01 +0000
Date: Tue, 9 Apr 2024 22:09:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: refactor name/length checks in
 xfs_attri_validate
Message-ID: <ZhYe7eESDi7jjv-U@infradead.org>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270969031.3631545.9868795270237115582.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969031.3631545.9868795270237115582.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
