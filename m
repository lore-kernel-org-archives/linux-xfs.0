Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4C422258C
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 14:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719443; cv=none; b=UVBrX/fG8V7CCGmtKIeo6eHjuLZdpoAbKcTB4pBcJhh3QJyCvFurqYKDqa32xzgvDwhtpPRcXHcHL54oFhJbSNkVP1yWUTr0HFcP16fUMiT84mHlmoj5FCzUmtMvVCNCM0ywWCKfrRySVSI/1l04Oe93jcXOOZmeiF2lUQ6Vc+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719443; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZDbQtA+x7qZ9pN0Tq/tTKlxJOdgS18r2ZcbpRdSnSXbamEl1C8P5Sr6vGpO1yodx7YYNlSHqSrT/P2pbRS2GVJMHhkwhJR/M3UKvBNN6oOUgrk1awb3AAhx+l81jaExcw/kLLkv8UODsUjck/rlDkVRBR3iy8qyS5iw++Dr5a38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ttFRiP9P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ttFRiP9P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ttFRiP9PmTX9In7TL69Gj87+ku
	4UuE7BtBnk59uKRYsujUVtvJUvpLgF2bVUCZWi6hr3fVPnXh8PTCt0mQnVd3pYqvro763GtD5Llkk
	n3GYH5QHT62ae9IEywu1KmpJDm8VLNJudeddtIgYZzuedzP0CclUw6XWP5rnkE6O8+PugHKPFQF5g
	SDiX0ybudyQVw4dlV8szIzAoBF3Jxo3EgvZx1Bybhd5bkdtyJnI19q2iHTQGtU+8BvyhIDVee7YMm
	opoWaNKgvZ0R+V7C+TLvk/WhEUnRtZJmK1xDw3yF6w4ZNiKBcV7LNwkuYcn+HNodqpoQYF8Nl0xJr
	uTVoE8MA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9J4-00000001vBi-1NYz;
	Thu, 05 Mar 2026 14:04:02 +0000
Date: Thu, 5 Mar 2026 06:04:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] libxfs: fix data corruption bug in libxfs_file_write
Message-ID: <aamNUjHd7L3jGVXj@infradead.org>
References: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
 <177268457046.1999857.4333152615677714192.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177268457046.1999857.4333152615677714192.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

