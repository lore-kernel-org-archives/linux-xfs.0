Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DED6AD7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 04:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712119222; cv=none; b=lj5pyx6L6cW07VR2rzDbRywv6oZ/+eac96d2cVA0djPuxoINHsGReLSfFv/a5gNiizkxVWAkyCxdzFdLVLnLEP5rJj+8VJqdzHV9UL5Z8ZswfRrGMtxygLIU4BXqUamEtNea7lxojyHQEe539MX5fzft0iAMXYIbNgkRX7DuUBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712119222; c=relaxed/simple;
	bh=lalTOOBttlfkEUjvHYke9Ony4LPBAsywQvksLi/Bnuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YxsIpGrH7wyXP5CD+iv5+uTSMUIBnMca99rTtkc4ZQM73IpfEnDVi4VSxRYm1BMXQeiv1X0huwqGJvB6Mhrp/uocwYEUGF7Hw7FI69qfBbyEtGSSPxjpHw+jOEdAD3qY1rkYW9jGY6UQrJrjZwRXFuxad5vZhoxJicLoSv5m0yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0+xtAwoP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0+xtAwoP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yb4L3vUNBlRS9pmSA327dbGzlvyHmeycu0R2dYKgpWg=; b=0+xtAwoPrY0F4FzbQTYvVkoUnt
	xRwvqFwYj153Qq+qDW8cinM8fNkdcAX0ieXLwCqzDgsXFSYLCfxDlj81+86TGb2gJk77nxjpd8JCl
	N29F7iasHOVdg7M2wMMb1QrwmM1+615BokRtBgoMYtfa2tS9fABV22fOcC5j5m+OGOZ3L+vHVjgFN
	RyNAqiHq2bYoIO/9AnsfLpon+9LclHgW4qLksytS5Hl/UE+fURue6UE9Wg/bV3stPOsTUBV7bmZKd
	oolTvp0FgbA3Ay8ug/V8HAwgwJ2IE/vY+orevdjn5r6d+mvCC1BrDm5zlMV+BEMeUlIY32YGQ0ySh
	cYo25YPQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrsQ9-0000000Dylr-0IeE;
	Wed, 03 Apr 2024 04:40:21 +0000
Date: Tue, 2 Apr 2024 21:40:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 2/4] xfs: xfs_alloc_file_space() fails to detect ENOSPC
Message-ID: <ZgzdtYGyVN1-UQdM@infradead.org>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402221127.1200501-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 03, 2024 at 08:38:17AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_alloc_file_space ends up in an endless loop when
> xfs_bmapi_write() returns nimaps == 0 at ENOSPC. The process is
> unkillable, and so just runs around in a tight circle burning CPU
> until the system is rebooted.

What is your reproducer?  Let's just fix this for real.

