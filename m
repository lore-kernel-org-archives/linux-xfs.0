Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E1946EC69;
	Mon, 28 Sep 2026 08:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790582941; cv=none; b=DqEkGu0sDBXY5fF72r+erln4SD06LBbDl1Lc+mIhrkzQfpnSOTb2PPw6e2J2SKIIQYAUnyJia/GSUMbw4FyRML9N9jjsyUW7XvuIOoZG4Z8V8EZTJFbB5E26K4pkr26rpGsvfdfPwy8sNiJSVjGg5GntoO3WeHpuYs95ClhtkC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790582941; c=relaxed/simple;
	bh=Eti6AqbhO9qvCNi8xn/e8sF7iM7ZJ5jmtzco+9ZZ3ic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tKVNzRGu65vnMUD7wLbP7x1axoixd4tPR9aXBQ5Ct3eAnKqS85A0DXiaV0xcVK9s/zrVmFMWhGGWPe8XsYa5Bp/cV+Ne7OBgVbQWNaIfVTwvzfyqvuMQF3gFPhqtrHe7dw+afYdQvqM8UYzHoEKyZ5nnSFHZ7OOKZUM24pcXddU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JTXCHtzl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JTXCHtzl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WC6fHLE9PzsXopz1pgasBvjEd2g4DlymGdpPa+DQxQM=; b=JTXCHtzlwap7gonPru+zq5G2tl
	jnSoUVxDV1RwkIi/0Ak+l4fSG6T90jjj2m6bv6x7YvHbp7YbdxOwF9raZuUvd2MsMDbikEBV3VqqE
	KN6MQg/6wuyiGQuya0xzaNeWrBpJUjztR7KNRjy11XnKr4c9nZUabCcCh1WiHjtoFFSEmU/bgvB4a
	s2fo2llqM4UiNNzpdfeu2qXiNU4uteJHttOMiXQYI8Lbnlkx2k8+WxVibmt7LTwOEYdkmigxrRvcL
	qpxFAPldmJqur8iM6B5Cw8Uw8nr5584LkvMRJXcYcvDiAMH75v34RJay3rZskROnoR3/Ckb7o7WZd
	XZACd+kA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB6Pz-000000001kT-2bYn;
	Mon, 28 Sep 2026 08:08:59 +0000
Date: Mon, 28 Sep 2026 01:08:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: allow softlimit with no hardlimit in quota
 scrub
Message-ID: <arogmy9SCL5oDPRQ@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612745.479634.15770032430010226973.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179057612745.479634.15770032430010226973.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 27, 2026 at 11:17:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM observes that the sysadmin can set a user's soft limit to a
> nonzero value and the hard limit to zero, so those aren't corruptions.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

