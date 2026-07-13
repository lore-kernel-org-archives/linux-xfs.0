Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD8F38E8D1;
	Mon, 13 Jul 2026 07:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783926719; cv=none; b=jmypG8qBpcK0UkIDqAEIuyFghj7W580RS6LC9Cb7A2mda25BclL9awyqqMNCAwYhiGj7wlKLJ3w41J8YFN5UAs97asuiNT0xxFnPa3ciVOPN8ITRo49XmJ9udaHTwkBqzW2IZVtr+OEqNodom+qsdoxESaLXHXLf83dT3Bh7r8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783926719; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WoXgj3q8j20XyFdb44Cz6DzGE2+4AkGeASsc4FzP6hdTpuadbPWRmniViqiU/irGcQV0VL7VwJ0VuDoz/B+z6MSpF2bcx0iN10OggiqyAGF4mJFgtNrnAM7y4QA703G4b+Xe8KB9JaUjyDEgt8pneNo4L1pe8Y5/JVRkdRQvV9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1miRW8Y5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1miRW8Y5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1miRW8Y5ESL+XQzu0RZIg+eouf
	ZTCEtvumZGc5kmrhiOyq0HFWvf6ttHKINmC2WRjaG5a2dpvQk8NWIl7GuX+3X+OhtMU5U3OcHuW6Z
	ECD09Dhc3/ApDhzYfL94n+THoxXMCFT2iPKCJkhkp2nqVM9JLgovfR7C2YSKqUfLWUFB46cpGT0h+
	PYJ+tAV1lbl7TDN//G3foXMqf4veuWqf/kT/CIIAXg7aLTba7ZxLLi9i3A+eApFQ2l2ECXKk4AYpu
	npDpU7eoOZGsUODv7wX2IxkAVTIvoEBhdUi09OYpV4HVzX1/ifi8uyHsirpXpmgiVU2YrdF8ebWGS
	udH3roWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjApP-00000008LrB-31v0;
	Mon, 13 Jul 2026 07:11:47 +0000
Date: Mon, 13 Jul 2026 00:11:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, bestswngs@gmail.com
Subject: Re: [PATCH] xfs: fix off-by-one in rtrefcount btree root level
 validation
Message-ID: <alSPszh1rI0_2m6N@infradead.org>
References: <20260712002644.2519804-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712002644.2519804-1-xmei5@asu.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

