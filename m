Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D75F22F0C
	for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2024 05:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708493682; cv=none; b=cmIgRak98AhoIpDDAHIgJWcej3b6UuCpEZs6EYut6yH+LHZYkgseyjmAfh1TePzaTbzYk3puSYBaiNBEK7/jwUoOQ4iYTfGsBeWCYkNvQ3L58BC8Cwyx1v6OG51H8p2pfaJGxpxczV+1azdf9lP0r1T2yjfUjI7/rqI9bT43ot0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708493682; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCKi1nleoawD24x8JOQw89+KNIjlKmzZpqiZwavLWX5dtT1t4o1dQRc1vujhsJP1TbAy8dFuLPhHeWvcLyfaznFgeLoP+NTjQ8TlQYK80HRoExKGyBezJbTKBLZZmFlDB7Rrui7Dfif+slGs7vrjH9Q1RdvgPhml4FgQm7m1heY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qWIsOGhl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qWIsOGhl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qWIsOGhl86/wLDZ2JIS2fyRcRu
	KalK3qzvSTVc4vIFnKrGAwM+tGT04vArIngJCMw+HE2MDqOF/+QLh0HtS5hbWjAbYC9dOOS2Evdca
	jz47oOZxWtdt2Nlzd0cBKzCUpjPAbqnLZjB7RSHejFS+7RZzshiBJEw98lxPemhJVhE0Y08Ad+lcG
	lavxqAuBWAMUwcEVvM+FF1AXIRKdFdRm5YtHR1XZvPzOOwNktO9b0nVuXaDHLEDcePPoJ8H+eUTCu
	WC9eu3Hv6ruqPCef6SGGeKK5IqRhsT7fPkUKDYOtkpQpCGCsvPYudlOAIKsw3jNtWjH+A/SmR86Zp
	JIaMQt8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rcfFf-0000000HCsS-1c83;
	Wed, 21 Feb 2024 05:34:39 +0000
Date: Tue, 20 Feb 2024 21:34:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: fix SEEK_HOLE/DATA for regions with active COW
 extents
Message-ID: <ZdWLb5dGfSBwNhub@infradead.org>
References: <20240220224928.3356-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220224928.3356-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
