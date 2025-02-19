Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A0E1ACEB0;
	Wed, 19 Feb 2025 07:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739951136; cv=none; b=MkjM1+wi8WYaI51ZLhNO+7DPoxsHXLCLX7ic8ma5TaSYvkYtpOFH0PYdMz2hzqUUDVgUdyVVJSkGKQduLcQ6WFURN+Vce99L5IfTQ4J87F2tjS+FS5A/V8DDXW3wbn2yDEkVj9vPOJCHPdjgo2Xz92Cj5SgNrwDoA+S7vUiFzvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739951136; c=relaxed/simple;
	bh=EMiDgHg19OW9OE1Z1wwLxUQSQ08DPzCmsrpRpmVg9Hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KPngzZCLDsRGjUfdjX7x3agw6cH1ELtHyWpe3r1aOoz+wikYn2MXRdeXXglr3Hhbe1DLFlsIpmnmTqOFnnk05QTkJJtVX0hqgqX/knXzOKGqwlnsbxAQqOxj2aAi8FLIrZQLvAkWGVooB+7AJalX6Oc1MP33ccXiVBVNQ1bJh4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=esLzYseC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="esLzYseC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J7EWeyGM6Qx+kAXWmCcgQJ1nsy+vFyBh/470QhnIPi0=; b=esLzYseCdPwWyGRkPV5Iokx/hm
	DhZoFfyfJ4Kehb8FMadNSc04wFYS3ATRE8mg1lf7oZ/feGHRzkRu1MWoG0a1FPVPvzR+uSQudo3Lq
	fYZuZE0WnTDQ7CGS1MhgyVzt/bQxkfqoUT+wMUZO382p70Xit29nSLVMvW1o5W/R2RUXVSOfk1+Hh
	hG363tqnrpUNcGP+alyPYsocTSR/jEKPLIk5jAAmtxmZ0TzY3Cdg4leRhjiwuZCbQuRVGD3HRtIkH
	3AixFzLAWn7XbTDDmRnCELeSWgQ6gz5x2xszbQYbn4GFIk9sGpqvM3UtxMBvkvg9Ie28jLniUneXe
	jwZaJk8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkelz-0000000BKN2-1V03;
	Wed, 19 Feb 2025 07:45:35 +0000
Date: Tue, 18 Feb 2025 23:45:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test filesystem recovery with rdump
Message-ID: <Z7WMHyMzBJrTbD8d@infradead.org>
References: <173992592211.4081406.17974627498372247228.stgit@frogsfrogsfrogs>
 <173992592231.4081406.4124909331519241647.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992592231.4081406.4124909331519241647.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 05:09:07PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Test how well we can dump a fully populated filesystem's contents.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

