Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F37147C9B
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 04:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806316; cv=none; b=D9XvCusGsh6+ewiAHoy2kBp8OhBEdgJQpxCSQUCUwYuKJQgrrR5HQ9uThn03GTbXIyUkZ0x7uO9QFP9jb3Ztf5rJuaBUYj7IgfvfUlm4Ff7O8TXvIVa0ZlJ1NnxuOwmxiTwlNAyF5en2xDPiNXgHMUeMSJzg7rRYD77eAuL5+s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806316; c=relaxed/simple;
	bh=zHflfpHPQrOYnxLO+GrzGxeQfNTdTJdRZKX23snvvog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D+GJDFMgVHkMkd7hL1Kxw0nW+UMfQFxvmlFsjeAkPyQhvCylldF+06jSFI9g0F7ItwSRBu8Oj3d43AL9RVkXGQ/q7KdnOpN3lL57sapCrozWg2MsALFWGDqy/+1JDkZ/N4txpcctrf2DEY9Mzdn+GD6JCHEd5oA62zj+Opzosx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AePxGiKq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AePxGiKq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zHflfpHPQrOYnxLO+GrzGxeQfNTdTJdRZKX23snvvog=; b=AePxGiKqK8yqiLlEYxqa2ZALW+
	lHF8hYTEgqyS/VqpwadjvICyg4V9AvJDMlY7BQnSVJKy9AYrFQC86NrYwxBEXwc+xE5puFWfB1tEW
	kRGTEaOL2tyCqZxKgAQNL43FQ3zUe8hGnjMHUb74I86uS8jjTAQmStl2D+xczpIkl162KHqhtbm9t
	wB5lXOFoM2JXerEbNLbi1nyfJ699EnvmShCB+i9xGE7jEn4+ufvAIm/7iBAkChPxc0+6BIJn48jpD
	2q6UqxwfQx1eTnXe/Jat96+YcbnSxaxncWGsiIMNZVwL3ToQdcEZ7iy8p86gu0KqKvMvCjrsW69Sb
	BH8cNS5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsDw-0000000ADwF-2shI;
	Tue, 10 Dec 2024 04:51:52 +0000
Date: Mon, 9 Dec 2024 20:51:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, dchinner@redhat.com, leo.lilong@huawei.com,
	cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v5.8 2/9] libxfs: metadata inode directory trees
Message-ID: <Z1fI6Kq0pcyQMmrB@infradead.org>
References: <20241206232259.GO7837@frogsfrogsfrogs>
 <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This entire resync looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

