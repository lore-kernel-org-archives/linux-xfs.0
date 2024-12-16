Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64D2F9D6
	for <linux-xfs@vger.kernel.org>; Mon, 16 Dec 2024 06:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734331136; cv=none; b=L5wNwPEFxfREJiZZ7REd02ZqhbwUk9gE69s8U+3EKc8k/DEcixUNhW4m0rM8DhktEbtN7pe7UAmSX9N4d+8QP0llWNu/JYLsbRQ7kZ8GcQk3bRbml0/KPwA6GIsnOl1xZDxdTm0z2U6CHkQkhhhnS63Pd7FTc+shApWgu/oq+XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734331136; c=relaxed/simple;
	bh=VqFQZ9wxOqQeKYp/cabS9yMZ1ffTReEZk74s+fFULiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ep6gR/jLzcH3bvgSpxJS75YtHe5CY5Yw+uLTWc0XDVLWMlyz93GvAozwqmJU89h1trOT7bP1rhiWfaBzZB0sK95Y6NNZbqEJ7y3GvCS8BWDipXhxflrsbq2Vsu9bopKEa/oLSu+4O3wXKbAi18tAepmrRgctslXRgQhrEZQAKAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eY4vLQLd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eY4vLQLd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gTweXXFuFk6YHyeV88XXpKK3BaKJvN/omUZ8YHczWGY=; b=eY4vLQLdQjEwxpmN8XfBXSl/T6
	8Esdc5hz9iJRxCrbbNNjhzCb1wHqU+BYc7mnjVDQASIG+eAL+ypEWJa4aPO9X/WfG2CUI3So9aPkS
	iI9XOJYDlMOzpAcMLvu3lgqgxrAo6EY/uhjD70I9R9f3AQqVUD3PZkNwL/YzcO7K+W8awnOkEr45X
	3OrPUoR5Z+7KK7405WrZPAHpgg0jx1zlkfyIDy4yBJq+lAPgcO/ZOK3wfRNEsBbBmlnm/F62UX31J
	XZ/MIQJsSZCL1Txewh+9TYzGhXBKFGr3MH0b00JVXlHT4BODx4ZwmHAjJzF4vpdrj2bfeRFZ/2EwC
	yccDKX9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tN4km-00000009CN3-31y0;
	Mon, 16 Dec 2024 06:38:52 +0000
Date: Sun, 15 Dec 2024 22:38:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/21] xfs: create incore realtime group structures
Message-ID: <Z1_K_Bo9lmhJez8R@infradead.org>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
 <173084396972.1871025.1072909621633581351.stgit@frogsfrogsfrogs>
 <Z1g0MxNmVKpFgXsU@bfoster>
 <Z1kMRAzsOla3QhNR@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1kMRAzsOla3QhNR@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 10, 2024 at 07:51:32PM -0800, Christoph Hellwig wrote:
> So without CONFIG_XFS_RT we obviously should not update rgcounts,
> but should also fail the mount earlier if there are RGs.  Turns out
> that non-rtg file systems have a fake RTG if they have a rt subvolume,
> and the count is always set to 1.  So yes, this should just return 0
> and your fix is correct.

Are you going to send this fix formally?  Or should I?

