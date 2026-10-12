Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C087D3019C8;
	Mon, 12 Oct 2026 13:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810690; cv=none; b=G5lpEcJPEXwdWlBPKXxibgE6dqfXSiGVx0sJ9kKyp0nWDwMLuJSxPJkKElCPbwylzkMuH7CApDL4Rb7AZthExBUH/IX1FmrrTshvUefRDsmsKQt6I3C4a51uJn1Otz9bLSsPTDsBWhlFR0Yoz3DP3plW0RR5ome5cUv/cSddE6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810690; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ANbhZ6ghtZXik4274tG3aSlOYhu6t5AHFZYBU40uhwfSNfSbQPj69GF7JNnD6IJDjeR2BnD5qqddwoLLLcqmZipoM/EeBTKzfbC+taKBM561KZgj3c7rhaVgOVHpPR0ZHA+8SCb1ueMrcCmv6CHq/z50xiY1zL2lOv9v81kl3Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vLnMmbYR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vLnMmbYR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vLnMmbYRMY6VMSmIcQ+WaTtckp
	xC73Gb1DSAxv2p0pf6TJS6BTqAFU3LQgXBb6YqhK4pzHaLtuUtSk3k7XobZKAzXjwh/ZoMnM+hwd1
	aItQSjoyE08v4JEscV8IxWzfz5gfdxB/hCdyKG/qffjWOZFwHIwX01nmCjXZ0qC3+G0/2+/iByu+y
	k7X4dJHLzFnMMJFTGfSXT/NxOFQdXVPo9RpMZcb/KIelhYKcpi9ks9eQgD7muLNxYq7JG7KMDag4i
	B4ccJrEISuvMQ66pfdKoE6v0FKzMyIG+tmT0Sdmw6XnASvRcopTNeqvWkU22hXDwFk++TFJNZjBvj
	Wx7o7sBw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFoP-0000000AXL7-07N4;
	Mon, 12 Oct 2026 13:11:29 +0000
Date: Mon, 12 Oct 2026 06:11:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: always report scrub errors in tracepoints
Message-ID: <aszcgYaO_p-OPWzx@infradead.org>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065432.1058326.16069797217698789453.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065432.1058326.16069797217698789453.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

