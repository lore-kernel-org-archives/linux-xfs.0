Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6435728469B
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 15:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738466; cv=none; b=V7vxt0HDt4/MA8ad0csHDgZvUKxj0XBU1fkdCp+I9g0GWMy6RG3PwTUU8w49Mxw/L4tIknCUwrT6apj6N0H05pya5+vO/uhgVod7wKNE/m6Mvv2BpM0wUAqpWQemFQokwHkkYJFPko1z7d4S8PkQFhG6y7PzQhKGuMpIDwhWCP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738466; c=relaxed/simple;
	bh=zShWnNsijyYLEVsn9RNfQ7+NpPGTjclhIc73+w9kjEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AIkehUD7SopUotxgyt4PVBGtU+iaJ3DjtyO+SRAxLzp0uWAUdWb8P0/RrbH+wVZ7OTYuY08R8D5UrMSK8Dy3RvRXMIf7IqJS8sQYzXLT5GBbYifdh2iPIXgUO7Kr4eEDZlmycTEA4bKANolaLHjJwKRKVyS04W74xaW77qzOLlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SKgaN959; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SKgaN959"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XFoQGDpdiGHA3bPHpjS2ogTZqKSIo3l9yZZbYSAFpdY=; b=SKgaN959xb4yFg8Qw49JJhHKTn
	oAz84a2RmhaRzrcd+w0MsHm7ph1S6XnkWLYsgkQ4JLSetHwfDp9e66q0/5Xk3QKuWf8/mt/CCJtP8
	zis1igSVQKNvC6mAM45PQD5PlI1y+gpNyqV/RCb5VfMR0ljQ+0UviSzAgy+98AXL0XwJ7NwjtReQK
	zx2CWww95lhzZ5RU9Paez2oPvF6tUafI1fP2D/5SZWgK+Wh1zC26/56iPnq9zlysquEZewAWL/cGG
	2r3y0IuQOP4EbgS15oWfUVZocp1o96I7FUNyKHLojl4b/AW8nUMmYlOHbk7sqvCUx5ndi3L7KGizs
	IntMhaBw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vppxo-0000000H9LO-3aFm;
	Tue, 10 Feb 2026 15:47:44 +0000
Date: Tue, 10 Feb 2026 07:47:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: techlord8@web.de
Cc: linux-xfs@vger.kernel.org
Subject: Re: What prevents XFS from being grown offline (without being
 mounted)?
Message-ID: <aYtTIGf5OeP01FBI@infradead.org>
References: <trinity-fb1b39de-006e-4acc-8ab4-22a203b12391-1770653643533@trinity-msg-rest-webde-webde-live-54b976884-dmz76>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-fb1b39de-006e-4acc-8ab4-22a203b12391-1770653643533@trinity-msg-rest-webde-webde-live-54b976884-dmz76>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 09, 2026 at 04:14:03PM +0000, techlord8@web.de wrote:
> Common sense tells me offline growing should be simpler given that
> there is no interference from data being read and written at the same
> time. So why can XFS not be grown offline?

Short answer: because no one implemented it.

Long answer: because to grow a file system safely you want a transaction
mechanism, and XFS only has that in the kernel.  Growing a live file
system also really isn't hard in any significant way (unlike shrinking).
