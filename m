Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5545836655D;
	Tue, 16 Jun 2026 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781613923; cv=none; b=QA+eC2+ckjgCCE9OqnaglM4HWuky+YWGNy9MtB72RvbSgQeIVWRFS/JR52EafaKnHnrf6lrdFBGnhDMcMzmv7Ia4nLnUBWehoYpNjslCpb7+xH/fjUgTnZuWu0/m+dES8SjAXRk8UzvYvP3ypkk5NLextOs5g3DtmIzNLDufpVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781613923; c=relaxed/simple;
	bh=SggZT2C7cp87YVTBNRXReoZ0VUWjlrBTppbHc1aGe4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j6Vbd/Hix2Z131mZN4JmwVwMBXXzPq9xr6mfMAPqeVmR2J99fB4kmQGLRoICD23ioYDuR/ez7pp6fVp/DostVV+9hBQziQf33nAmM96ZCESHyDZnpVDToEuN23vrQU+WbjlTW2QLq3e1XqnKHhvcO8C5Uz0JdmJlOi24nA10kt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UP5evmVy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UP5evmVy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SggZT2C7cp87YVTBNRXReoZ0VUWjlrBTppbHc1aGe4k=; b=UP5evmVy1ZY8d1T8/17NDC7KCT
	dsgF3EPfH5GvVFeHz7/X0iUdTB3n+NXL6lj2KCcra+9MWOLzIcR5FjncrBCVjVbGKdd9EvVDTLjWP
	MOwQcF9ly9/gpXmHUC92nXg3KCLdJiMq+C1q4YNdYhKIDVQoL7AVAUnj+sTM6cZs17W/f4GYThd/+
	46lVUvA9PHyOtqlhxTVXXBZKCBFxCeSL261Tb04w1PVf5V++PuXPjrBX5r0zwMqLQr4HIWMBDOmjR
	Qiw9yIyenHe2KPA2Ll2VxdKQgZdb8TkSMZ0aCnVTVA/9FN10rvFYIwKOzgctzlwJf2KVc3pZagBju
	6WnwP/Ww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZTAP-0000000FmrE-24FS;
	Tue, 16 Jun 2026 12:45:21 +0000
Date: Tue, 16 Jun 2026 05:45:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 0/3] btrfs: use IOMAP_DIO_BOUNCE flag instead of
 falling back to buffered IO
Message-ID: <ajFFYT10i1dvAy89@infradead.org>
References: <cover.1781597506.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1781597506.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Note: You'll need to include Jens for the block bits to get either an
ACK or a merge through the block tree.

