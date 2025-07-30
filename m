Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303472AE84;
	Wed, 30 Jul 2025 14:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753885273; cv=none; b=THn7nMsfmZUsdhQsaZBTzc7F69LC9mRDewjP9vq/8srsovCKJ4EoR1+pzh6+J9d6phLwOjrKY3Jkss19VjZ+YscJ30UU2hj0/8MGQM0qcptfaI41DxMJsUHPXw7+bO3nMlDsFLJs5Sz4HJaCL2hUOmBl0X4ziXPbgwJbJBs3Reg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753885273; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t9ydWMn9kca5XHxEDHTdO+UVp/jJ2fZQrZPVtrXTHOZn0JV5mYJIZK5e1wnuwkEFXr9+BWWqlJfPKIYVO4k4hyMBUREqUM1bXc8O7jWLRPEe9VZOf5DSsgVqTGmrI4VFOyWDBPqScoueTvm26oxSOgpkzzlZB4ZiRt2xdg25Knc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=05fn+5kG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="05fn+5kG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=05fn+5kG6S51ZTLrZ0MghA1Snq
	qMettGxUq4zL0FKtWQYmpuuX9q8s6ROJ1cwQLGUNLV47srRCIh+ycyl2iPwk2jS13K3efa8cBQCW6
	Bym3YL4ALLrsfNnAXJlVx5xgP1ui46HTiMAh2SEOd2gx+ZKiq8dMJ2/JbroR47ULt7qWgW5QVkgCX
	7B9MX7TBJAQ3TdpKKTkcshBEBGQnuU99wa76QB6iFFG2Yt7wrJ6XZrZJr7f+EGWu26+bn3SCBijXU
	JiJu+51/RbybIaEJbWwva9kcNEpqQepNIEv6AW/wU1Fm/eP7SsCilCnFbOzuTDmLL3uRhWRyFmWjh
	C7Mwm5yw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uh7g7-00000001ivT-2wsT;
	Wed, 30 Jul 2025 14:21:11 +0000
Date: Wed, 30 Jul 2025 07:21:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/432: fix metadump loop device blocksize problems
Message-ID: <aIoqV0OhoCtk-ggH@infradead.org>
References: <175381958191.3021057.13973475638062852804.stgit@frogsfrogsfrogs>
 <175381958234.3021057.8571406990911180650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381958234.3021057.8571406990911180650.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

