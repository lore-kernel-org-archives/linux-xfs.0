Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0B743901F
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 07:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979261; cv=none; b=k7maCCUQ9nhph9tc2TZph2YFZz2Aj59wbSsiZPdG4jFXxQ7iIgzqDYABlF3fXYjisTN004tR8sUV6yc+/pIMRoFMvUOBNTKx8FBP0yYuguNrJ1ybu8nSA+cCojmay9GPs2sgtn945xJlN+zx1Mp4n18F1buxJnd6cX2PoYSzfI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979261; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pIq38jq199HBAQZPKi8A2xs5puXdMsvOuvuKUOpi/0Zgd9pK/PpRnciypAFgJ/GsR9L3Nf5Sl3rnn7vH8Hy55vIT/ay4O7/hTtR3jeuTrPbaASMldpOBa6E8obK2WnB+CJ4CTl9733iKT163SMouzNNvuChpC0EV+YPtXPqtP8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UrCLBqJ9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UrCLBqJ9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UrCLBqJ9oOSACxNN8PPBJG3rPU
	QeREBoN/yovMZd4Od9jfOk6xg87hW0AdV0Umr44kLlOM/VKscO6YY8TMAWp78dNpLdoXjXUaLs5UF
	7EdkLj5CLiNFU8+fJvALw27tDbVMdGcFJCBFa9iRpWN7q6nSoDDT502x5Bze0+0X6hF7GZjBkV2rw
	WfmEQWZVSwDk+Z0zjXxt3yV8HAYq12fBdbqaRPTh6vMRey3Dxdwh/ziIzfABxxfKdgpzajffzdBhx
	i/pepqjU7ljJqAsV7U8nK8x1Mi++BCVPRVrB4jW8O1OxwmWWL8hK+4EVecFews9pn+UpW4AcNBEYT
	/XPpUhQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viSJR-00000004zDV-1WwG;
	Wed, 21 Jan 2026 07:07:33 +0000
Date: Tue, 20 Jan 2026 23:07:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] mkfs: set rtstart from user-specified dblocks
Message-ID: <aXB7NXcw5_9gy_z0@infradead.org>
References: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
 <176893137089.1079372.9346420785447726442.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176893137089.1079372.9346420785447726442.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

