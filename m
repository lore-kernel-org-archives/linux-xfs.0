Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC3013A3F0
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 05:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576587; cv=none; b=JUTRw+ikRGt8zATFjmFqeG1SKyWPLVibzjbQ/s165/VhA7fJ/XRoOmYEhEBsU1RNoXPfaOKU3PTKk7fPDN2EmgWWZ3zHmZZ5o1nl1UNnPp1wiQ3RcIK5qiZuO+9RQOf+I4l5lOklxmvNc4zYw1SglYwNnEkqkP7EqSe++ajOqQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576587; c=relaxed/simple;
	bh=Z8bRS6gwYBmvdruhknoTJ0olKesH4tm9yv+aTk0Lsec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5CM0+WdF35NmEmYgLZNGrc8RYOsecDBnapXm1RE4Lh9aKM0NjGpV36hEmxlCXk+E2eqNNfGlJ9TVOMdn0xHSq7mzvzt0TEXsVIf//aTrKpOVaNR19xSc9Do/MROikA5jUgEZtsUn+OTkYEuGN+DsdEurKA1jRC11iYgcWqKeTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kBAypSMy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kBAypSMy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=azxknk7szVXGYUXPurX84NgYQhiyDMoYrmGB9Ad16f4=; b=kBAypSMyMbh9yg9AmKDqHq0W9J
	y8EyaFf9138BCivy2LhF4Ui+hh/qd8Bz903Sspug+CcuBAPRnhMXlK81jbcbURcwQKWNrVFbna2mu
	noF+MOkKJ4dLdBggFkW3nNwaY9Z5buUTrwEx5XN5zks1YmFQx6HAsM1k9IeO+LeXxvBNgJy5O+bhs
	D7KcpOKuN7t4v8nN0AFN2BuMqVy+c892ICiGzdG3t+wRJW9aPSn5OKX27VAqqkx6TRCJlroNhcmbB
	QsY3QHTnjII/D5aGAmAA4R1fEo/6iDBN+xc1mluHxLzAdhoT73Z3HcM8/bc2HG0/FmShlKznUYPcd
	ZHNuCiKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t37sY-00000009jFa-0Njj;
	Tue, 22 Oct 2024 05:56:26 +0000
Date: Mon, 21 Oct 2024 22:56:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/37] libxfs: require -std=gnu11 for compilation by
 default
Message-ID: <Zxc-ih6g7u-6fjlN@infradead.org>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
 <172954783487.34558.3883793884591579863.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172954783487.34558.3883793884591579863.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 21, 2024 at 02:59:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The kernel now builds with -std=gnu11, so let's make xfsprogs do that by
> default too.  Distributions can still override the parameters by passing
> CFLAGS= and BUILD_CFLAGS= to configure, just as they always have.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
