Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD7379DF
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898436; cv=none; b=U9IkoAVvfbFJNatXtwe4tgdaEP+09YouwslezUlrJEs0XVUxJ1H2DTwzsLdmU+BkIInP+S0DlllWLvYQRN0gC1dLMnTT3qUSX80n2QpsRSzN9CjeowqIC2aL8O/GJecuCk1Z07edmis0x/OeC2lv1aVYRyTtAhE4MdgGwtcnez8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898436; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNuHFz4b2Y/zRKQAdWdrUbGqCvJVI3HUy2XJyvlEnU+CJgR6HVEIjqgI7r2Sgt+mZSwyXxSEfMWK6+1cYW5OodQ7uKkMAvLp3W17DZYktSG9a8UF/bW8UT6bUlstdPA85lXSn1APPtEAfCM42VHaQYBXPWVkPuYwF+/WwYKpOmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D3A5E68B05; Tue,  2 Jul 2024 07:33:51 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:33:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/7] xfs_scrub: remove pointless spacemap.c arguments
Message-ID: <20240702053351.GL22804@lst.de>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs> <171988118656.2007921.16506722349320949924.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118656.2007921.16506722349320949924.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

