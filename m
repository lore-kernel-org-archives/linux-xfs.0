Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2839618952C
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 09:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732093518; cv=none; b=JD9GjG9PMVv9ESLeJRVs7HWV6xfUuxsc/TvnBBTfZXQhesUmGeqzonJgbv5gMtq06spHWeebbp61u24Xyw2OsSpKZ86nw5ttwdS68KI0fM0Y/pQ4xtk/hUFiTrqeK8r2A8Hw1g1zphKfDj9YBR2QPERwnrPeY0S3sQhgsH8bWZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732093518; c=relaxed/simple;
	bh=V0j4glC442/92T/jE36E7dLQiw7JYe43suk63IbLQXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GrOkxu5LczYAY0l8ws42mH8eWqupXXwBALaJI4Hp0CxxFH2GwNVSeMM6J8hssBu8hL1gPFl9z+IKEFf0sP6vi0FX8khcR5zqfxA2ghUYRjLdlqGF2CygZeRFmMwOuwWN/VEtL6MLLaGWe33Fzblqje4N65+mobMfdVlRoolRELU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c118t83n; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c118t83n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RzDdM4gaJCYZcne1MAulL+tXV6rEVQPjLiSPRURZ+74=; b=c118t83nJi6+Hiib6gxnJ76ha+
	Sz+eFEjjl7L4U6iQkYbHCQoV6HRHYqJhvOmdLimTxxosgrINIcGkzN+0/XGeG5AJaXzftDDJXnvmI
	vy6P0JnDk7T1TDbl+fy5AR0JqGA19WZNf7LrFbF1iFmK5kHMaiLz+W0TtSdAJ41VKyz+CZhlM62sE
	BQ2cfCRilHCPH5HqbtJSvsAm3x1BxnTcz91iGjbLHLQ+JZITZkKmlyGbTIc1Y20f6NDjD3EtUFMpK
	a57NVRJPqYSj0gYrVdP5/0hKFV1+py0GjBiK8M7yeH/a4kBtFd6hordlLzJYiFo58gWdK3BZxsAG4
	giMbMazg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDgeC-0000000Eqib-1iUy;
	Wed, 20 Nov 2024 09:05:16 +0000
Date: Wed, 20 Nov 2024 01:05:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Long Li <leo.lilong@huawei.com>,
	brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <Zz2mTCq03SEjoUZV@infradead.org>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
 <ZzrlO_jEz9WdBcAF@infradead.org>
 <ZztOpQwU0pRagGwU@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZztOpQwU0pRagGwU@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 18, 2024 at 09:26:45AM -0500, Brian Foster wrote:
> IOW following the train of thought in the other subthread, would any
> practical workload be affected if we just trimmed io_size when needed by
> i_size and left it at that?

Can you explain what you mean with that? 

