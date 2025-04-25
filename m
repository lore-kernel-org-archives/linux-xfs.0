Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE6F1F1520
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 13:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745586715; cv=none; b=d1PdNSMYgF8CR8z6ZJkab4hFwc0GYoLs1oWEEllp3eUpykgkc4OOyXdKx5U1nnM25ozyBnypFM5ZPQUzEyqt72v74sLDyBpeB6qOL2Sw8qUPipkboieDw+XK2ssDWxCdraxXv2UGa7ZRS91HvmSHPF4Rwfjyf0+TVeGN0juETMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745586715; c=relaxed/simple;
	bh=LKHrbuXC585ohcedXYP6XjPbrnBBKIAOrhNlgRkVX4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pqwm/k0dZh6FAdE1YPJYF/UqwEC3euF+n++wcm7QbUuxhmpMHlHVWL8R5yaL06icrUlw6HU0kC4IfMjRUMjofrgt6uvFJWdUPUnjbX9/YaXeJSoLdkIcR3jEtWamxydZF5fiULmlPWplNpi6xEZ/5IH9R8hBtqrcAnODLzjFs0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=irmOrB2h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="irmOrB2h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LKHrbuXC585ohcedXYP6XjPbrnBBKIAOrhNlgRkVX4o=; b=irmOrB2hyRU6Y90j4AJ6Re7Ptm
	Bi9gBn8cGa7tqO4JeyrHYpQo4jC1Iz+x30ajvjDV0MuiHeeKMbKsp1djGcwKVCENKsR0i4pf/GjBv
	nMUoZ1TrnYNlDlJDdLakJqoqAsoqeuhtwkzLoOEPTbGoBll0WqWuZ4xTjw1fjK1G7V1FfVtqkK00h
	mEnxd1MfPb6lx09A361fJ5Afmsm4qAcqhRaQVw013lsPQMjmuixqSBPED3SQjJ2Mej6p7kVNg7tcG
	cEuPJas23fxzCYYbCs0spG+bWXQjeNNBAs8/ARUHP23dpe0sJMCWDTZFVNkC8ERx48uz8Scilff5N
	i4jyoGAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u8IqP-0000000HEQc-2lIy;
	Fri, 25 Apr 2025 13:11:53 +0000
Date: Fri, 25 Apr 2025 06:11:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_io: redefine what statx -m all does
Message-ID: <aAuKGV6N1RSnbVoq@infradead.org>
References: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
 <174553149374.1175632.14342104810810203344.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174553149374.1175632.14342104810810203344.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 24, 2025 at 02:53:23PM -0700, Darrick J. Wong wrote:
> +The default is to set STATX_BASIC_STATS and STATX_BTIME.

The default without this options is to set STATX_BASIC_STATS and STATX_BTIME.

?

Otherwise looks good:


Reviewed-by: Christoph Hellwig <hch@lst.de>
