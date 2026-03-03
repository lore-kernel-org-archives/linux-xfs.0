Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FA9395D8F
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 14:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772548935; cv=none; b=qQ5S4NE1LXLjtnPtfs4h7b34gzOh0Xb8NUxdqYwAkhXRT9li6x+qVJxjVks+u5UQofCSqGGyJ6XiG4A4v+I7Rt6IeIpocZMTNvUG/Z2OwG2f1bdxACAQ4YRS29+NyZ8TRyJcKxJAiPwXrRnrUiSw9sakcEL3CkXCyhRbK/tRsdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772548935; c=relaxed/simple;
	bh=9bGhvQVN/D6T9G5r1/2Ni7/E1ETvBeWGLJn5ZF25lVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FnYpk6e78R8TW/yN/DW4w6fjUZz3QS1wbeeiVTE3E1CPeukwhQOMQZFDIBw6+V7p5y090WjF/xVhTI5eOeFkSKr60CggahvvoonQj42hQfNXGUjlZJaDwAC29dfPBhlkdR20iL9J3t8+VF4AwnBi3TKTgng62W0KSnAaPN/kZuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qiGeql+b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qiGeql+b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J/DlD14JbWrGeeK6G6xIeO9r92r+571CMLtYCFCincA=; b=qiGeql+b6dNfMMATV9JoPbUAwL
	IlY8Sx74eUBxo8qXJ6PMyHLKVqk9x6Sumgi7fYM6vlSMmFhUmg3q9yN7Qr7FiI/EYCNS7q+3AfmoR
	je9hOxiVLe2zr6myGvghE3l2zNeHGd9KMiBeSJFGMcOTvuDJX6AfqKGG29998aNisA1P2ljrNcqlr
	TsBQ/tVgi6rH1MPHZZHscWbJCzXrhp/gGIlKMOvS/fG809C05chqKmBSKZKU7+/EB+UOpa1rQ4bnB
	uWueRbiSGRYvASmOeproVfzmMp0K8bKLg/sBMgr+8xeH5O5rBFKPxn1KdqZHFplJzk5nYGp87Dl92
	tP4nX1rQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxQwv-0000000FLc8-3463;
	Tue, 03 Mar 2026 14:42:13 +0000
Date: Tue, 3 Mar 2026 06:42:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/36] libfrog: fix missing gettext call in
 current_fixed_time
Message-ID: <aabzRYmFpaYq0dEq@infradead.org>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249637813.457970.13704898468170992838.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249637813.457970.13704898468170992838.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 02, 2026 at 04:12:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This error message can be seen by regular users, so it should be looked
> up in the internationalization catalogue with gettext.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

