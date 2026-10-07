Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9547B40BCA1;
	Wed,  7 Oct 2026 13:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378490; cv=none; b=upErYFYz6Wl5Mg6AkSMStMga1XJQTrhpyx/KIiz+kOfUurTTxTX1THycyXSAcQDFew54mqRmKQuksJ1XFWvkTOWM9mBvemZmuTlI/lnAmVwPb9vEZqo55EWWvtiZELs7F5IleHByhSOWbv2Jo0X3kSQKfW8YOyVTyxlVb+ca1F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378490; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KE/lEEt1qpWBZASuMZko+VTkIg70kB4lzk0Bu4gsE7s0dQFsAgRDSIjxkrJ4FT3CCEK3ITGGftJh4SIOCpd6tcdsPuZD4K/iJ6tUvt7SLnqa45AL3x48kW3UUbJ723oy3lO2hQuKeLmrrOA+1PkR+NfyZ8Q0ROxTuwbvzsdLN1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zm6BvqsC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zm6BvqsC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zm6BvqsC7XrN5d2+IAz//FSnyU
	JVYCeCPKCCrwzEAEvCEKWJHzMgoqiqe3Wzky6YKnVbJlOBtqjxjV6Xe8/PzasCINVnL3ASDZErX8B
	IgYt4In8KGYdIASQv6Ux5qe7I7IyzSlSgiMNJrTk/liBLiXuB+EQGqLKXr/EOUiHAenouH4q7fOvl
	2LhjM/l1bnVFh/Mx07PLEn6tLspwTbvWaZxvOT5gE5QjwmCpDgDnfH3sL6zh94Nrymbq7lx62rdN8
	EjPZ2iqgbffGji2pjUofyL9w52NhnenroXkkgryKuPu8f1O0uAJbtqzJ+pEe1DcT8SUhdt6p4TMnd
	ysk8eNUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERNI-00000002Vb7-0QRh;
	Wed, 07 Oct 2026 13:08:00 +0000
Date: Wed, 7 Oct 2026 06:08:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/iomap: document ret parameter of iomap_iter_continue
Message-ID: <asZEMBENt0f7slya@infradead.org>
References: <20261006154005.232338-1-ampr.mhd@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006154005.232338-1-ampr.mhd@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

