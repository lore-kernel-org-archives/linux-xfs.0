Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4AC1C1F1F;
	Wed, 19 Feb 2025 07:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950258; cv=none; b=aJBN+u9QZbouJXm3CcEbcs2kuoyVTCMr3dDZZYOYhkvr3V0c0wiHWMIG56beF5Lno35T2I1ycLGZr8130puX/L01eBKJnKrWbj1Q8WJ0cNn+V4TQpsWfvzkDuQLAu7U1+ixx2TLA1KyPxTaqQ1ZkVatC2434SLFuLhev69U9NxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950258; c=relaxed/simple;
	bh=zN0okDCJ2hOXQemKbqVPH+5jK5UCBUDTkp+cjUlyCEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+4juhzKFJ2h9TfGbpCqW83UuukuqOPG+Jmt+gU7BBRuksqFL3U4bi3M+sBBzeSLSYtWQKs50Pj25lKxq3wl22i+uQCNtBz1HlpzyOgEwGUw+GSmzq1zojY+pXC7RQCrZ7KEf22dt+MKfMYfV8LF0VQf5xg7HyYkPBWa1qx09Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CDOJo9hD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CDOJo9hD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BLs1VrhS0WXkYS88rfLt2cWsKmk49crc6JmH8XYzcbE=; b=CDOJo9hDKqWujfJzYkIEoRpdTG
	t21/wq2N5nLtg0GjSl0rpM2Yc/W0aAC21+oC5hsLdJ/gfq9hJsN6y/N/ngogEPCgbGTUtAP6TEABI
	K/bhnipjwxvpc8LbOOUk60DeobDwd9TCks3Q3Ew+vEfw5rllnvD84HTHte2hgVJ5F6TOmiMQK+BMF
	QqDO0Hi0wtNUS38efralznFOofobnKxBmsNmWRTWUkagOYi3Mhl/zbKX/AZ+oMDwMRUFhzUHuP7wM
	Hmt4T68zxYWKiezXj+k+GXp0uubagGwfEdvZPO0itBYmsT5TXKwriH5UXF/RHKS/Ri+pYvFo0QO59
	Rp4xWMqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeXp-0000000BG2d-103g;
	Wed, 19 Feb 2025 07:30:57 +0000
Date: Tue, 18 Feb 2025 23:30:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: skip tests if formatting small filesystem
 fails
Message-ID: <Z7WIsZec_ZHIKKHQ@infradead.org>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591276.4080556.2717402179307349211.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591276.4080556.2717402179307349211.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 05:05:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a few tests that try to exercise XFS functionality with an
> unusually small (< 500MB) filesystem.  Formatting can fail if the test
> configuration also specifies a very large realtime device because mkfs
> hits ENOSPC when allocating the realtime metadata.  The test proceeds
> anyway (which causes an immediate mount failure) so we might as well
> skip these.

In this patch only a single test case is touched and not a few.  But
I remember hitting a few more with the zoned testing.

