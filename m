Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE6D3403E8
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 05:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054707; cv=none; b=Rdn4rRzkqNSWKWJCwGCzbBtKaL7NE60UnGM3B9orFC4N33oIqNuYA0yuHuKH56y4l1TzP7EouBlGgMwH0+B6dg9j7ZHFi3cENQSfnNX0xCmQZF2HhknJt/8gpLh4xsz7D6rniqRCugfqkJyOxZd81svmj7GkiZrRhQmint5Lnms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054707; c=relaxed/simple;
	bh=xofoHJn7ntCK8KBchbRGeu7pLX7UULi3JUgpahnGumk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgaaAk1Kx4PL1hvBKzJE1xN0c4NrS+vqWL70uc+wcK7EC0cAVAHBQ8Oyxpw9FRPPEHbokEDf8pnAO36g95GHFsHX8oXm30KqUImM6sFXKVW0Dye0OyOHg1sEwNPkyhUgXk8iZbGUM2dnS1z1x5yhK2KGu1Ue8uS9qKEmCUt9jNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KttHAf12; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KttHAf12"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SVOSnJ9RoaT6cwMahLkvnMFFFZjhr+qZet9TORLLJu4=; b=KttHAf12pp++dvcPZlEhtg1bsA
	NPvgJ4b7MqoJp+PQtHENWbuTGNAMmuYK/sZ/mQYE3X5+gm8CkOf2oxg/hi4Pb9DJdsOHOhqRBcVUv
	LDKMyPOEJCJovWOSjJGV0Qk5+18PrLVroFwTjIQEpREE9u2oVxnlfrtE2hzbtov8AKg22JdxXRJoh
	YarnnT/2flUKX3Mt6AJvuaHspPVtcLcQkJrUKBuroKmzyuHL1VX5AhbiyDo+dvmv6sHNXppvyK+Ky
	4Owr2DI2oyFMUIR58jFy6p5Uvapsib3YLQ+rpIF9UXgb4KO5uaNb9TG+OzDR5g8Wn7OQbjwnDe4T7
	1Fxxdf+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8t06-00000004Eve-1bQW;
	Tue, 22 Sep 2026 05:25:06 +0000
Date: Mon, 21 Sep 2026 22:25:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/14] xfarray: warn against sorting arrays with
 identical elements
Message-ID: <arIRMtTNPK25dNFV@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120850.181988.12177498355342705156.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120850.181988.12177498355342705156.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 20, 2026 at 11:18:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains about a potential underflow here if xfarray_qsort_push
> is called with lo==0.  However, this isn't possible in most cases
> because filesystem metadata records cannot be identical.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

