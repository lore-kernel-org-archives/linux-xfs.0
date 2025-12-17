Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B39635CBA6
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 10:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765967129; cv=none; b=DAWOfUD87QqdPTARk593JoZPfWaij7jNK55z/7bFg0wp9ia5d7H/XzadP11XnBpDoxHR9ngV6zArzkDVcuZHR6CIDgyn3o7l3mkWam4we3gNshtooRdCdqycsmLZLxTFRrHx1g39tFd/Xu9y+ZrejNuZV5TPv/yOxhx22uLbrRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765967129; c=relaxed/simple;
	bh=0mjg0dUvFM6WOFNEAaRYyGgeqRXOpcxdJV+Bk3TqUEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkPr8pdu3yzLz4eZMnFN4A0XyPv/7OW1Y1wq3IStDQ2jG5CmrJmVOqRFXzItZT26CZUMcQik1eiEYQGufzBHve1KXSwJ9wXKjVJr4chN9q9GB3vacSNGR8K6Rkwnpn3SEKhAiiKOZGmG5KDDJ74DajbCCcE/kMPol1qzAwqSV9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DFgqODqz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DFgqODqz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1WOAw0qJY4gsi0bXhfIlK7SvRVbFusiduVOf9rYH8yU=; b=DFgqODqzcDV06UW6qmhAsii5rU
	jjnxk8pUkvsjUnMd2tM4qtGyAmX9WJjhD31oKaVCI130d4ZiQuWa1hwGxE9H07wuVfo6vP7lothmr
	uIGVS3vRtKctn6JB2IhfrBXEeR/vqMid7olVzCBepAnq9ZVNIrKYS98nHtL9ZYJTYdyc6ZgA6VhOY
	+ziCBqkCgen1r+oSmsJxSu6+DzFzcsc7m0nLqIKMCzCTrswx96WF8F3nSZSGr4BwRAD4RwK4uhJxb
	IQuc4l8gvmBsgtE/aoje4NcgOtdupFVMON6o96wEcjQCf82eSFAhWBPgLa2RoDPv984GnkAlEK+CL
	RYesQYWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVoil-00000006dvs-3BTq;
	Wed, 17 Dec 2025 10:25:27 +0000
Date: Wed, 17 Dec 2025 02:25:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v1] xfs: Fix the return value of xfs_rtcopy_summary()
Message-ID: <aUKFFyGAOEIclGTs@infradead.org>
References: <d4209ce013895f53809467ec6728e7a68dfe0438.1765949786.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4209ce013895f53809467ec6728e7a68dfe0438.1765949786.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 17, 2025 at 11:07:42AM +0530, Nirjhar Roy (IBM) wrote:
> xfs_rtcopy_summary() should return the appropriate error code
> instead of always returning 0. The caller of this function which is
> xfs_growfs_rt_bmblock() is already handling the error.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Fixes tag?

