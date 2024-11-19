Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E557E153824;
	Tue, 19 Nov 2024 05:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731995157; cv=none; b=jHEXKdXgJ4AaIAexDLc0uqzvexoAXSigyQ8t6xLA6b06EyaJ2JCwh3INNDGoTTUJdswJ6iyBBIYkf/3dNHtYWzurrDkbkBn3626O5fzcM/f+/FHYcPfnpL9BefO9KICfaDFTp3IewZ4cpQsK1vkyEjUxnvPE2JD4vUtgJ7F73Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731995157; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ciz1nZulbQMIxhnEmLMYmsmrQ40WgXjDamZ3NGzZVFB+WBqezrn7Rga3dH0Iv0jqx2cur5ZNb1NXo4JVHERTrfya7U3CwdVx+JPwHnVo4tNfKGmot7/DyD+Fdb4xy7zh8sE8ZrxvDozIL9Ltb3UHztZWwQxpEaovRzd2KL71HzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KCkpNr7D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KCkpNr7D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KCkpNr7Df6302fbPNzPHRCN9tA
	2uBuMV7gHV2vw9RXnTpGShSJvhyCIilGykxm85Xz7V6ySvFtE/78QKHWXOHB0QJV/xQKHNDOq3nV7
	eG42HDGYC/ufy7l/7msdkm1vHhB8iZtWv+y8Fr9LctXbZjdumz9trdoJM+QDcnTw2Vwy+E48ipbJv
	P9lGIlZgl4ZkkAyMUsz4hAsnTLusWhd8CoFmrzITQTXFaT6F2SeuU9f9rz7lIdUwLn/l5DTVixHAt
	sEEUFhyJFiQ9rI+g6YJBj8qYbmBEtg8XquAVn/sms+3B+HuRRPsOHZHyP5R/JcIBNmfTT7lmn8hNl
	INxYeqeA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDH3j-0000000BRze-2SW2;
	Tue, 19 Nov 2024 05:45:55 +0000
Date: Mon, 18 Nov 2024 21:45:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: return a 64-bit block count from
 xfs_btree_count_blocks
Message-ID: <ZzwmE_jWRqZ1tOxC@infradead.org>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
 <173197084481.911325.2907716202971546808.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197084481.911325.2907716202971546808.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

