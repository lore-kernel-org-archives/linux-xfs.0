Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC3A13CFA6
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738906414; cv=none; b=sgw+OR2hC0oIVaTtTdKCXOZ4bc6o31jwFqA9UdBGzAWnqwcUNMJoBS3uhLsLQFN0ITaajvDyNYqdGgWmYfXCBKduTS3+IVK2Z+DMoGbMSedbhBEBkmQUUafNluK1vXb+J+71eQLwjAAGug09/dTOAbsAwEJ/mtfIEzbdPVB1Njw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738906414; c=relaxed/simple;
	bh=UmD+OjaU9kkjXfHInKx5qlGT2grEuTh60nE2PPlgCtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bXER+czA8j+3YCpyYuOZAEcSKkKZVX4dqYJt3wftpC39ShTR74qRcEK/Oe+tQsNq6+0/QB7UFSduLxOqKVPrZsqOyUiaMNDKidGCC7ecGds9TtJrTAyQ66YhIMDhJ9TSAfmciydzbuFjl7YUmPUhUNGGnUBaiR5T4yX95sZZBrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S056u7TT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S056u7TT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UmD+OjaU9kkjXfHInKx5qlGT2grEuTh60nE2PPlgCtQ=; b=S056u7TTtowDl9sE8PZBE/V+d9
	5IKR8F0s92wTouUggajgemNqkcmyWPDVmFTw7h9h/2omsql10bTmr06mCdi25LvkwwrXc/fF4g8Q4
	dX/yvb68b44o+hMPTDPKvKoFFg2fBWogpMH0ZYuFDEwyzAxb9/MTfEUm29opVVJ3peKkzSPrsgxzl
	itQbrgjXSFdtQSewlLg83oRQ+tQdEQu7tYCRpSXXAQJjS5RFZUZE3pTPNB0boCvcgsBlQRH0i/b9f
	o55UJbbXO26de6UnIH1TYtCdKwycOp5rBO1cH48RqSgue33cBi2Jp/5bWfiWoHlK8ZJu15VfX2D1e
	fNFD3z2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGzc-00000008NUk-1r6Z;
	Fri, 07 Feb 2025 05:33:32 +0000
Date: Thu, 6 Feb 2025 21:33:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/27] xfs_repair: find and mark the rtrmapbt inodes
Message-ID: <Z6WbLGeievEgBmqW@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088371.2741033.14204258331206705184.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088371.2741033.14204258331206705184.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:54:25PM -0800, Darrick J. Wong wrote:
> -extern void rmap_avoid_check(void);
> +extern void rmap_avoid_check(struct xfs_mount *mp);

You might want to drop the extern while you're at it.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
