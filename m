Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551392F1FC9;
	Tue, 14 Apr 2026 07:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776153493; cv=none; b=M+PKNl1k1/Ktmru5j2Ya5tkjgwgHQfOFbrCGBy+lDX3aGjQd5bDV/XaLZoTPx0apoqFwSeoHiN7v6XpPuYUZamt+pab5oetCCThkMZmsaZThcUF6sqjVvo019JWvtuUBq3w0gZRUu3VnZurBSZu5ClT4CPPWPLQy0qu9RC0UNJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776153493; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHMXS0v2SpsM1jgC+uZWZ6ixg8nxVlrTHbnCFOjLo923Ylm22uyk/CbNXRjz5cqiapzaG3Zi92f/QbJDlt7X+P6WXcQAjZFhG2YcpY5jVkGjdxYniY4JvTinMyhXDHE7AmtlUBBDNQz3O3tgWlJ05XNexogClN/hRk5KQs2Yd5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gEezPdPN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gEezPdPN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gEezPdPN5xzZnTwz7TYCaR3u73
	YNStk28scgsGqtE9g1r3PyprCFNOLBgvMfYGo9qUBJLuy9Tdv2TLM5ButiRk7uJR0sJV6F40hkAoz
	7LueOaPfm8rmcJ1ZB9ixi5mtVM8S7n9yWFFGDJ/d/imXgTa5MFqoVUf6nAQBJRb7FkJjY+wWA2L0u
	7oqFfrA+SBDVFppAAcBa7Kf2Y12Uolth+FB7xpfe0Fh7gMithhhMhasJn5NIytSx96tBu2MEXSxbj
	WaHdCMSHoapZzZaLjZ1ruYkIpr8gSl+guXldir9f3zezRU+NWBtNclBS5v4KphcDUIeel6JJoTyek
	qu6Y5RGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCYex-0000000Gvlo-3tWp;
	Tue, 14 Apr 2026 07:58:11 +0000
Date: Tue, 14 Apr 2026 00:58:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] treewide: convert all $MOUNT_PROG to _mount
Message-ID: <ad3zk61gsVNjZFna@infradead.org>
References: <177610262399.115381.16343458870133010450.stgit@frogsfrogsfrogs>
 <177610262425.115381.16374107672753586865.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177610262425.115381.16374107672753586865.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

