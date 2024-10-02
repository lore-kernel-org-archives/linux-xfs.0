Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169357DA9C
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848499; cv=none; b=iV66wODqbV4WA7XR5TIr6crA4CUFw7dCkRDMAiEBYiP0Iz4RCePxHWi7tp/rPbTbYP4ogvNlrb+NLlFp17ppt5V4i+hOmtI0e28zre5kYoLEFg3Ixor4E+erIpcy56GM9tLyMTljWsPfHVUJMhRDPcndorxo76l+EPtZdKfxzRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848499; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aA0qb4/KNZSPPWwGyyiFS6YLCIBdsfb72MW2kxksUT9Q1vSi1KJ9QhDPteWMMrLao4F8UwC5gM0S0j2Nd3XjWQPJlTcGm+BiUrQASKWxiN7bnJ3tMCYdRT5nWJ0e2udd2FlhZnQpHnXuNu6wk7VKlFQb1++IJynOba3WhdkON5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1LU3/Vy2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1LU3/Vy2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1LU3/Vy22LRzSKKPS6s1kn/LcJ
	3q80vNisBq9z18dHbM7bu7jPjoWAMiCLRAgalKfPvyz+M0lGF8TwVAkQqtou1QddMdrzNVmjjBjOS
	GK0LdySAA1QWaP+m4atjJLUrfPEeJYlVTVkh8ZDtnQ9BeJgFefYYSwC0+iOostAiv3ZddY41WwbVX
	UPgwsiMU3Gd4CqWGiSu8uJvsSxjMHTTJRagXYoLP3NfJ6hGKRyk4ge8Y9WR36J6Kd9oioBQX4ss4I
	mnoQ1yq+NbQ9oDMzEnN8kRwDy5OhcORuAetIL5GtPKvsLYR3D1O8Nq0Eu0ChUn/cXvjbViB/L7Xe8
	wrhVqzAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsK9-00000004sgm-3H9M;
	Wed, 02 Oct 2024 05:54:57 +0000
Date: Tue, 1 Oct 2024 22:54:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_db: port the iunlink command to use the libxfs
 iunlink function
Message-ID: <ZvzgMZFsegdt1DrM@infradead.org>
References: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
 <172783103090.4038482.8296139533705611698.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783103090.4038482.8296139533705611698.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
