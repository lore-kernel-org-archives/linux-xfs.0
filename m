Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA7E653
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 05:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732598871; cv=none; b=N4Cq+IZLFhXpA0KOtQzShpDwlfCHfWJO8vc9IVTBdasGLQDEKgtGa9T/E3DvP7D3LGtVPO5mP6am6mdSgeX43oxcN6uboXv7DqzsVtsYGrFVSlLm4XcmYwo6FZd4N8+5s4/mRBF+XtVnY4bMgpbQDOQAMtCIkxZWkySxMU3n5ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732598871; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nl6BTpkn/8lJmA1zsYp0VK8Xf/Oghdc8RYN4QXUIruuzcuUn4/HmM397rbq06B0YWc8LRlrzok5wU0TapfgIXnUJCitjCwpivotfRoh+Zoto8vKOR5ZWCsmIKQpKdibCxX2lHuxSUCZ3MkZP5Gqo1fDyKAxxFXx4GPyaOAs5X30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eztQUN/I; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eztQUN/I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eztQUN/IRExmVe/nSnPA4MdjSs
	uoqi3XurNEbC2eOxCuTFlWYe7M8CRf8G+vZap4tdtghgRwBxsQSl17gKW4Pma3DUi7u6HzBzWXMMQ
	7FttTAuMcT1W5g3TliA/FiyE3NmhkFnmQmkv60QoBrgLwkUbQ83jgULAC3axAM5xKHJSluIwWHBk3
	O82LZ8dvQbJc7cCuOiQMz86bg9HeQbpYBsDS1Itew3Q21oIm5BvrPag92rYanfcmTymljVVI5Fl1L
	SqT1Mzu5f0vfFchoeeDG+Em8G6WfzSWzpINlEvjgKfdawECkR0lfz4kxou5HsKlGvCRmzFdAhHSwC
	XYFdamIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFo73-00000009fZk-1BbF;
	Tue, 26 Nov 2024 05:27:49 +0000
Date: Mon, 25 Nov 2024 21:27:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/21] xfs: separate dquot buffer reads from xfs_dqflush
Message-ID: <Z0VcVdRJrLT0JeXi@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398108.4032920.1511154808709795549.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258398108.4032920.1511154808709795549.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

