Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDC7276050
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 08:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979475; cv=none; b=WYmVhgw7w749sx2/2BslrEpgJEiCfLKUbMg5lCuhy48bZ+ZbW6v+BYZiiBfR9EOLSQyajn31OKf515cBaHXg0dU1JF4DO0vcu6saBhDRlYVtIqXPFR/ZgCMZHhvxodwa2TuPU82eUoOJlw064EKI2qpzT2k8Bihmg2R+VMGIox0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979475; c=relaxed/simple;
	bh=DFdVUtvoaCHRVp6N4ZooUjatoe2OihaJtcFo1iqNlyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=orgPp1VNdbinMNqsW8bzX7axflFSK2PAKoqw8/fDwz6TWElgayxYOr2i5HaiCHTHzMk7VA8X7ebmxv2h+dKnswNL7T800TRhvOIMbPYeHnfkGbn2tcKpYe6oTntDlrysmN0k8KGteTfU4uxRbGxmMWEcTRmCtYncikWRUXo95zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FIrsSSdQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FIrsSSdQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pFqxjtG6U20E86qqMzf4SEJiilS8IIRcs5pJiLb8qew=; b=FIrsSSdQPsPch/W7N7/CHrjoqT
	vvHqh1atTMoMGV37OTzn8SUrTgc+9xTf/hGXREsOzr7ltBwrTav+8QPvP3Icwode/S2ZHSIvR+3Mg
	ed5B56aBDzd7BeUINaAz45ZLoBBLMNVf+IS+XMjKquOwcij3n5e5u41+0km/YBVX4pgmVgKAKBo5j
	0HKRl0Sz7ZR/sZVYkoRw7wgI0kywO4AuMvjHT8Gfb9x9pmEcksrllVBSR8xA+r1PZ6Upk0PQ/++ON
	okuuxFlBWyeAVPg9dHmmnsWrnSnKJm9aGJCcwiyJ2nPeVQp5CYF+u/ax2zGAR2GRzvIeJBH5g0+Go
	e8f8tJZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8ZQe-00000001Lgb-3TFF;
	Mon, 21 Sep 2026 08:31:12 +0000
Date: Mon, 21 Sep 2026 01:31:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: add config file for the 2026 LTS kernel
Message-ID: <arDrUJPMZW7hXC8N@infradead.org>
References: <178996057889.169776.13298686198868661581.stgit@frogsfrogsfrogs>
 <178996057914.169776.676694849229728136.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996057914.169776.676694849229728136.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 20, 2026 at 11:14:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a config file for 7.3 since it'll be the LTS.

I wonder if they are going to move it given that 7.4 should land
just after new years?  So maybe wait a bit with this, even if it
does look fine.

