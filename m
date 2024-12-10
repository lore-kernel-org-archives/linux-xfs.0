Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D1722759F
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810437; cv=none; b=cJO3dIjtGYWvfrhk2jLMtk3bcjvysUVpmJs3rP28Zw2jSRyZr/Q5qULWiezmmYiAhaXxB/3+b7OhbTB1Jgx5jlMZwplY+CXsDp2ds125LXu3Tdgr6pCRZDoKyGrTjUqNG2fQ9Bx8NamK4V4Rtx/qTy2b3da+iZFWDErHCYJnQPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810437; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L1n+9ljMt3Qk1a5qAe/E+XE6wvNdIqadOy5qtUyKP0tPOH/O7EGpxviRLpAJusuOBfKUDwRLj3ujl10mZdZkH2yKcfSn+AOx+Nphhx7QY0GMGFBocRZGaKUBRldL2MqQgIv4SPP1K7CnCn506o67SOUWiQXnAU/NZpwL6IRYAmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uHwvHtDv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uHwvHtDv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uHwvHtDvPocPXe2QUqx5DG/oPb
	3PtY7QPOsKQpPAuJrr70uj+BtTNU3GiKdrquK0XKFHchDIK+XmNtlUFnlq8BQQL4+9kahCFLJbqPA
	yEW3Yro0rTL+lpXitSTxa2uDW5O+9xNKwxyozU8USOfNhMM4YUanFqNCcMF7qHvfhDsBvxzE33RuK
	6NtLwlwkxEG+/qjeZceOxsn+uODLH2Iy9GMsM+zoETWIGCpL9+p8dEI3wLo+4ZNDyZ4EYP9qt8Q1+
	zEt9eJydRJ4yP2wAC/ro91eZqb4O0YefrKE5K0Dp7CCZKm9vxv0z7STiLm5TX2uXzVUsCMzdGLDIi
	ajIDcvNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtIR-0000000ALc9-3V1K;
	Tue, 10 Dec 2024 06:00:35 +0000
Date: Mon, 9 Dec 2024 22:00:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 43/50] xfs_spaceman: report on realtime group health
Message-ID: <Z1fZAwRj2vxkttau@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752602.126362.14398852032899348325.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752602.126362.14398852032899348325.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

