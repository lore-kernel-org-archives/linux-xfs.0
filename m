Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB73C8E2
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724014; cv=none; b=IofJgtsSxEPgaloym16Vy3JCxbTDeUh8sMjNf666m+8zWpwqXDKOJZZ2E5l2z9KNWz6IdPK1mfUuUwyDph2xGZKKB5jxh4EqUjtMHVzHxDv5/KBQPiSqiUOTmmBdVM1YUbhwSJ2JhXi/4Kl513wuZbd1isvr3n0h6kEna3bE5oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724014; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jFR32zkx2zmQmp7l2sMkfKuqY1x9LeYo4Xd0lSxZhLX72qVpkOcKTg9hjuj7YJucWw5NgQpoUKKQRyeCaQ+y41+ICTcjwzKEZazAfFGMqYaEBUHZdzrwDDVQr1jyQeO2mWpQDE9hS9uEqlBaNZthqyiktqJs/5uQCg2w6HZluc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PwPe04mw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PwPe04mw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PwPe04mwREzd86r74tbSUTdfhk
	hERnKwS5YqBtKwQrgkcVsEoyiliUPSNFpqFhoyERlZwK+OfimoaXKyT+yw1Rp1uBfcFrzlZOx5JHy
	fMkqBGDUVioHluIONo8hrQ8Z73/LvF3QlpgL9nqWGvriMDzfuGplq+qVQT8TWz/aPZqhASwopgqRU
	t3iBLtH6irZ3qRcqQA5hJKEzPxo2YAZkSVCHkY/UHaHLFGgw3UyO2cAS80QSmAvK1UE2UVZfthBD0
	/3V7eIj5rGqFB+caddh9U91mNtiC/LUuoFDJHj9J6Ujrpqla5QJx9qMDe9Z69i7dWzpFKrgnv2vbB
	N+6rj1Og==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPko-000000053J7-1ftG;
	Wed, 10 Apr 2024 04:40:10 +0000
Date: Tue, 9 Apr 2024 21:40:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] docs: update the parent pointers documentation to
 the final version
Message-ID: <ZhYYKj3BZRE8bfGI@infradead.org>
References: <171270967457.3631017.1709831303627611754.stgit@frogsfrogsfrogs>
 <171270967483.3631017.15423312733723466021.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270967483.3631017.15423312733723466021.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

