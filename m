Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B512054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420666; cv=none; b=S/u8y7P8VR/e9Ml9D53/ml0lmC2cIQY23SIKc+t0ONINhyQE61p1C+cqf8EFw9ZPNinbX9c8x03JQ3esijaVGNIAsc1XpAwbTMETZgiYudMlQSlB2IMP0vwQ7j3lMcFxFc5JDOs8K/aFnPySAI5bTU7wcesT6CWFz+z0rzESzoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420666; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzHKNeADIiR3knq/cCOXS3o6053nyitGNo1BW0rFK9uai18oVsCKV0BCJe+0KeBX76FQHJjsw6sIuwVFXew382eH6SVozf/+xPD/xpkDKqpoIEaYNoio8328BgyWyHllKNIaZfiRMSACTEGpT40mg7kgc0tXUnhO/x2l87eGgfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FV+cAMrE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FV+cAMrE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FV+cAMrEqcAVY6BWQKQwhiEwl8
	VrA1FRR49cPx+nnRmuUlxmDeQqDwx8NykJN5iE34VdY9U0sapZWZhUaDTrlAzpzcuqJepLMeTpB/i
	rbU8DjwgtfhDcPmozKFJT5qBYsJQyOLhUTFepOks1R93Vv4O4YsH/vZPxq5/iqqhCuvh8MX3INji6
	EfrXyf/WI6l/WtnYQaIvHXVDndjRiw8ve6sMathVN37gkrqia0hrVf3hKN+ggNkw0HHwC99SX0i2E
	RnYuXiqwRayHWvvF8+CZdpwCh3eZKiLIo0dxKnDWTtyG6vvGGDb1tQUz2JSE8RMQq1E3Y3YJNHTVd
	rfn+TQSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQm0-00000009i84-2cRr;
	Thu, 13 Feb 2025 04:24:24 +0000
Date: Wed, 12 Feb 2025 20:24:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/22] xfs_repair: allow CoW staging extents in the
 realtime rmap records
Message-ID: <Z61z-ASAjqLRF5AO@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089101.2741962.17270845980448624809.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089101.2741962.17270845980448624809.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

