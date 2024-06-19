Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF79433C3;
	Wed, 19 Jun 2024 06:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777364; cv=none; b=s4MdKsvI3U/GojXwwvZmfiUFBtjwrAoMGNQ24IzJJGdn5Qhb0PV7ycSJfTNLWrM3anQ16nqE+4afDdAHj4Isf8ySCIcHxJq5p8R5mrbn1h27jRlmHTxou2VQ7Eh1rYp7a+w5XvVnxrkUnYKCudwUAmc9KykNLgs+DlrZ7x1MEvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777364; c=relaxed/simple;
	bh=5kgCBM+1sF6zJzIK5YftNtq5yqFoKZ+Qhm08fW4KV9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IancgLgpUjlFhNm07PbKjIAMMnwXgrSOG94fdt3F5hDC3dPRRBukWYVd2RD89Fx2XG53h0vI2Lz1LDk8pgLNh3bUdnjWr1TcIEr7Dlo96gco7L0XBY26/HXtbcSV5zMZ+LY+/LYGC8sFadYBkbewp7PTpbxFcY3atL/JdGbbY9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DW2TCDNF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DW2TCDNF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0lcwgkWFoBlNFSrM26phnqEjnz1wyw+fYGyXAriAqHc=; b=DW2TCDNFAYL6U2Vk35V579wGO8
	d5r5ugqf5edXCAgaeIZF6XkUU+gHLaBhF/c0EY/9zXbVGZCxORkAmt0ZdbGyWIj8I5s473O2/UnNN
	85sA3Cs+E4pKfhysTEvnLJkm1BpVpsdg/kOSDypC8fLNlJ2ru8L6my/KHEpgnQnw7I7U4gkXoqGmT
	MW9bHxKCzb9aqDWkGrL9s4y/k+lqtPgThkq8r0tFS2lqBZ4tUvUBryUdOsh+FlAJEYvYlqwDrPa8A
	0A3yG2zLXJpbgbe5rwbMZfrr23kGhdq6zkEf582nr7OybaVu4TJsF+7dRDlIF1RMcpLFlqhn/zE8G
	zISFZJcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoVW-0000000013y-3bTY;
	Wed, 19 Jun 2024 06:09:22 +0000
Date: Tue, 18 Jun 2024 23:09:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] generic/717: remove obsolete check
Message-ID: <ZnJ2Ehz8PIcQ5m6R@infradead.org>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145359.793463.11533521582429286273.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145359.793463.11533521582429286273.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 17, 2024 at 05:47:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The latest draft of the EXCHANGERANGE ioctl has dropped the flag that
> enforced that the two files being operated upon were exactly the same
> length as was specified in the ioctl parameters.  Remove this check
> since it's now defunct.

The last draft is what got merged into 6.10-rc as far as I can tell,
so maybe update the commit message for that?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
