Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91082054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420593; cv=none; b=uMiegnATjZMdmGFzSFP4AY/o0ax2ALnzxTc8V1CjkqpJyDQOQfEHo8e6gycWlKq8e8OZpcVYQ1D8DnlEba7HFU+KDR4ahCaw1LxS14f/8p7a8CiTsRKS5pvV9wy1uWesqBwCbwip9EPOg8ba9/LW6rqYJqkYmgtPPqekXBs3jhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420593; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DvJkUjrv3WWlPuP+5UP3Cf0meSIcQ0p0vfhAXlJ2iDVPa7IFVjSmUelHzvZ0hpBkAVMn/ZGY+q/R0fmu+JzPd724GkffgN/pjHu47gHeRnbleG8OLh0jx4PmD3QoMdjLRre4efB7Nm88Cjs1ho3ZVXKlnAHjxJCHz3N5ZnUJj/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c9OP3G0w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c9OP3G0w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=c9OP3G0wHymWbtiPHXOlAx55P9
	C1AppNE2Za6DsIQiAmraIf7TwWB4+9wFs3/FfeqYCkqtqky7Ln+pWwYg9+ShUBa3vXlLTFOtiC1Dy
	drW7ti9DfLuTSpGMapsgN7Ej7tccZ2jnf3vBJD71qubop/g5aNO0Z6FSDwjISrfynIbcJWjn+4/Qy
	t2KxTkkWY82kPy+Kf0f34PhhsMTW6CKSAYCwOBPKw1IAYMVNiKCmEJhF6zzVBWuVqznZPTPLdsKrk
	3HNEWZobeLiTZknGOUijk3dNMqCQkjfT55BcxJi/d+JSbWJSaZqzWCGkt8KjNfcZA2t/Bv/IdSfYx
	e4/By9Rg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQkp-00000009i2N-2WUs;
	Thu, 13 Feb 2025 04:23:11 +0000
Date: Wed, 12 Feb 2025 20:23:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/22] xfs_db: copy the realtime refcount btree
Message-ID: <Z61zr5uETHOHxIa0@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089055.2741962.11135146687529271423.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089055.2741962.11135146687529271423.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

