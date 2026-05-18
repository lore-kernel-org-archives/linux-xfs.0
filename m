Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3978E1F91E3;
	Mon, 18 May 2026 06:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779086919; cv=none; b=pj7hPb9LWAV27Z7bkqd4vwNiMVpoikSPLKGr6ztDeON1EmNqGPNXIgqR8BXMaykXfz9dOq6SsQWd6K+UmtVMHyyPcnwutdE1mEAb5WXfVYuhsnu2LDhy3FbDPHu8++VBW2UqJbyR84v3TA29c0dhtrjDvqOZpOg1mK1nt5evCxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779086919; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=anTJWHbGWBUwTP6FDkKbgQhVoDDPnzRY7lcLkEmWQlg//dKK3yDTcdi17xtL5rI7U3UWOtCr+xcRVt+x+3iYh3UA/FEx21h2GYWf79cygNPp9LA96qFNVKBu67Hpi93J2TT4+CHeLg4HvTWez+auhPtn9SF1JLdnsnKaFz9Vw+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Cpo1+QCS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cpo1+QCS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Cpo1+QCSLlBOD2DUlxCYFMB4oH
	puN1Nl3rQ+d9UzEW7pqcnPF2vNcXAsAH9V5QdgrQQqjvJKfXS8xTMXjptXvMzjN+8zHEl2WiFlwLC
	LNt9Un1Wk7ewKcxIKAhSw4t+yTQ8wL4IcQW/wQAfEyPW3SIZYoJQToBqVqo09eI76Xs6vbRgpvgnD
	Rrzk/g2QRVQSkTELX6T9CVv126Ibkpv1Iz8Uur9MvefZNbLVRtCGdSyYs4DAsWWC8owKaSg4p7Woy
	7y1FBQ1SAfbV5RwuuyC5Z/Ieaw48tXMPzfPtrS5pfdx4LVUSerOStZM/ECnh4WCVbKiR3DGkrwxza
	NzAHOSPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOrmE-0000000ETWz-1PDs;
	Mon, 18 May 2026 06:48:34 +0000
Date: Sun, 17 May 2026 23:48:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 2/4] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
Message-ID: <agq2QoZWSY4LTtY7@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-2-782e2fa7477b@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514-blk-dontcache-v6-2-782e2fa7477b@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
