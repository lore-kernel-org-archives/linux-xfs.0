Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3452D36E46E;
	Wed, 21 Jan 2026 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769007976; cv=none; b=FHYKBxxaOXoJs/2Re1lTpsy66HL4HdTILfrB7wG/JSH5tV5rtLJdR+7QK4Izdz5+iEovdyUGbFRnK7ieWo/uNQx9TIkWvOMyKk5PObBy3kk/CQiqykulakE49NLsUpwCGFnBivNoW7cQ+Yc1FHc1Owd8xSSXYg0bmw59a4aY3A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769007976; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e33Wuvi05SfsUKfjVAfRQGtS5nqglitUSARoh3so5enA+xt+kQYEF/z8rDLUo9EJS0p6UXMX2IJpktWXBun0EOq/fKeF0U4RyGIAMFSo4H5fptgh55IbE+l5rninOUm5TClscAJRlrUPnvjFVSJENaRW7HCwXJsolJjKBmdCK6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a/eIqqFp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a/eIqqFp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=a/eIqqFp8Md+eD8IJTkmiS97je
	DvQxh67GxS9nyi7qEJfUrFGkttwsnMPV7yJNeMUDGpmYvrkqNsICed8yDLT7gdEYuK46INi2ZTnhF
	xKCBq4iExq3vzlNMrdCNbiSNBNQ3ZHyo1jV76HADiZ2dP5RS8Tq3Ck352n77QlV1kszGJ/TfcgNGH
	dEjeJE2kCBhbz4RMYlwF0l4pXZ1JXil78PL77W6P9Sz9ZLt6GXYU6BS3XDGTo2MZ3LWk1KPTF1uAm
	asxJFM4AsVIoRAZKTkNfowJs3L4x/B+D0h3PMjWkG0f1YGrQvKRfOCUa176dVilDIufKN8WXa1pj0
	kwe+XTHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viZmf-00000005hJy-2qD8;
	Wed, 21 Jan 2026 15:06:13 +0000
Date: Wed, 21 Jan 2026 07:06:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: fix freemap adjustments when adding xattrs to
 leaf blocks
Message-ID: <aXDrZWXs1A-9r4Wd@infradead.org>
References: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
 <176897695598.202569.14161628486500284706.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897695598.202569.14161628486500284706.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

