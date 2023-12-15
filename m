Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A2B610D
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 04:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EYFbtl3x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iCZAcrkdE310vXqBy1Z6u1jwUAV5oSwpwCp1gvlGmB0=; b=EYFbtl3xP9KCW6Hx3pN3HG2Hqa
	RUpx6g9uL273oxUE85d97ucrIdFcnY71HlrQLjuo2NUjUXYmUMscLan/2DuG59gfZ5bzpHnilV8jy
	xp4BKcCtfyK3/8Sy/WPtp+Ci3SoHvPC/laUaZ/BmHFVRfWSmEg8a9ec2M5uCtL/njumaJQsDPQtsU
	GLN6qMzUhwuxZzvEc1pIZSviZjsSuIuj76LJ7PuSh0upUzIT0FUK/dKVRvXzgWZ2UkWC05a3NTXBT
	df0zkjIKhCJFoD5Pg01WiS1w4YIBmRyYuReLWIYKCAPz5irp7B7ESS/NhmSvSFjbNv1FvQhTbaX/T
	jpwjlYuw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDzfL-001xiT-2J;
	Fri, 15 Dec 2023 04:19:11 +0000
Date: Thu, 14 Dec 2023 20:19:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: short circuit xfs_growfs_data_private() if delta is
 zero
Message-ID: <ZXvTv9XtthEdd1AF@infradead.org>
References: <a6a7bfa4-a7bb-4103-9887-63c69356d187@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6a7bfa4-a7bb-4103-9887-63c69356d187@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 14, 2023 at 01:28:08PM -0600, Eric Sandeen wrote:
> Although xfs_growfs_data() doesn't call xfs_growfs_data_private()
> if in->newblocks == mp->m_sb.sb_dblocks, xfs_growfs_data_private()
> further massages the new block count so that we don't i.e. try
> to create a too-small new AG.
> 
> This may lead to a delta of "0" in xfs_growfs_data_private(), so
> we end up in the shrink case and emit the EXPERIMENTAL warning
> even if we're not changing anything at all.
> 
> Fix this by returning straightaway if the block delta is zero.
> 
> (nb: in older kernels, the result of entering the shrink case
> with delta == 0 may actually let an -ENOSPC escape to userspace,
> which is confusing for users.)
> 
> Fixes: fb2fc1720185 ("xfs: support shrinking unused space in the last AG")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
