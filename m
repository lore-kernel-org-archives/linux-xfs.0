Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA59333ADBD
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 09:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768813429; cv=none; b=hya0/2nOYrXRt/S2KU8ZH0mrdw+GDLZHstauowwOpg1qpTr9+wagHSs4n50cT88FagiJK7emYHW0vLTzqqemzy8uag68M4KNyoYzhtaN7QNwAAuTogTu9Z/bjZqH6VqRtID2rIPD7JowwD5Q6garY6mHkXN7a26ObTAVDTHroj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768813429; c=relaxed/simple;
	bh=I3u2Y6LR7bxaQuWTJZmWXONfo6WHa78LcNsuLgqcYbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gp+wLEyzLyZFpeiFx4+St/5L57/ZcZJW5zQ+0RKsYUqVaM+uZnmlk1KtxKQOYug6UvlGM9hFTYRERExIxvh37nrz7RQO4saBe415iX8W6IPLH83VKToxl8Jm3jWiiGiNdmd24Ba8FAb42oUYLcvrTcS/Sn5BGJ1CUE6wVnku4/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O7WBAqT8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O7WBAqT8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I3u2Y6LR7bxaQuWTJZmWXONfo6WHa78LcNsuLgqcYbY=; b=O7WBAqT8k9on1r/cAw8lBLzwaG
	sSfwnpgmVMHKKDDnXnv3rPjGLySpN+7qa6yUBbcTmR29eu6JmazGgMTqQQhcP3pYPCgd2Y3V49VkB
	4/IU3XzlJs4YD3xUiGjAgHm/YhJfvBEEYtEoQ1BrkTsYIC/ae5yyB899S+3HsHcotYmV/j4bVY+Hp
	V4ohkXJeBatMs8wzc/U3dXBDykgsPeUzVrPxWX0QlwApcq3Xy7Ds1tbNAPqhCk8jezMU8ww1MTREO
	nBq11F4fI0jKzyV3bKYeC/ngsqkqOFBn3dzsbPUfcZ21vgGfMBqJfUjmNhVoqZxBwsAi5hxe1KliE
	3WU5L+Yw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhlAo-00000001bFV-11RY;
	Mon, 19 Jan 2026 09:03:46 +0000
Date: Mon, 19 Jan 2026 01:03:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Cc: linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] Monthly xfs report (Oct 2025)
Message-ID: <aW3zct8OHdx5QJpG@infradead.org>
References: <6901e360.050a0220.32483.0208.GAE@google.com>
 <aQMPqDAxyM3i3pQk@infradead.org>
 <aQMbZoAAVWxxx6wc@infradead.org>
 <aW3J5Cc3ezll_601@infradead.org>
 <aW3g7G_dWk4cbx0_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW3g7G_dWk4cbx0_@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

#syz test git://git.infradead.org/users/hch/xfs.git xfs-buf-hash
