Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293528C0B;
	Wed, 19 Feb 2025 06:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945367; cv=none; b=kB8xZKcvalyWtWSIG4hHArADFrpPeYawFWXJk8tWQyBoTS/Y2WJnAqk7/J6RSxBW0Y1AuprrXmlyZGCiGcacIUFPjHUSlmxroHFrQr/lwkpnbGHw0KcLkjLy1i9Ik+LLaeFVsPMd4yc2l4Ne8+jg7m1i/di1F8aDqjYLKMXkeQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945367; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shUuU/jjFPZxyCTBB9Vg/xqG7Z8RYHrHIa1Wm5f4IJ5xXRNr2mODmqSCxjSoJHEscjTnwWW2bcm8dFlE/PW9EbtMP0ibbXFP/iTJz2EnWLI/4kRqA7NLJBV6O3pn8oNhkyspjZNixnW3vOPFxH9vmdSzYsd55QuCsSxvtropAOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0szPw4zZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0szPw4zZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0szPw4zZMvTf4dbSQxItcfRODg
	MlNXfA4wIgt+F2hjPOpis/lbLUq/XuBlPcjnPVqsP09Yi91pMzK4o19lySqRrn0q/V1e/enZHCVSu
	mVO/nGclN2oClamGKTt+Go2Gly75rVnMmpICXakGzvym4Txore8mTe45mdsvvDuiqLyiZkQPZ1UXm
	efei3tpcpJxVUZHP3B2ZKcB/qY6aSFydIaXervUABYGrkrDtJqBVm9Cy6veHDYyjT1tz4wlMDwmfD
	5BbjkUYXj3HYtFjaXfwpW9+etdRnPxuN4hHLUq4kocx6NdnMBikQ7tyk2UtxAibuTRwIghCnby1E/
	NQ17cWTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdGv-0000000B0JG-3Ptd;
	Wed, 19 Feb 2025 06:09:25 +0000
Date: Tue, 18 Feb 2025 22:09:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: test filesystem creation with xfs_protofile
Message-ID: <Z7V1lcJv_QYlB2ku@infradead.org>
References: <173992588634.4079248.2264341183528984054.stgit@frogsfrogsfrogs>
 <173992588705.4079248.17487544777085276923.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588705.4079248.17487544777085276923.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

