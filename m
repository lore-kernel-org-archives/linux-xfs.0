Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36691B2184
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081699; cv=none; b=mVKBcFgw+vz/w297dtfoyfhcgqfHSP9EbJXeq4wrynS7HjCMTS8c7Wtti/lOhKn6CHZoybjsC5pXFBFE1fZSs9mnLKfW/BPGxBlH9146sRq0NIrCiU0ys3chVY4Hr/9shgxZ34n1xkwF/0sUtVjVvOlcJlpv7skZwrBme/Ixe1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081699; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VdCZ0oLSUu4JJ7NkgIlzuE8L69zquv4ARBrNFfLcNBYFkxBup52uliqftm1yQKGLsohT4VkW/xYD+uTPJzrlRuatP8ExFYYKogWSuHqmOhNFs1lx8akpiU2kVkQMZ+8kh0brzI2fv/Gjk+0QMLRvk8iT5I2nfFxr2NklfsZAmJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zkDdjO0h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zkDdjO0h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zkDdjO0h3ogDiGhGsGda7SxU6A
	whQfh30QMCFn43SXj1Vwbdy3eFl6M4OkaGjLRlSuGNOLixgzNl4T/aXbsUnCFxin+6KPvBg22S9je
	FsO0T0Q5JUz9x8AXAofh24YjlExkt+oGmKfRwHdZ/OcXptASKMyeZ95ewRTGyuRR11oWPU6JfAix1
	yHqErjw074utrALDiOWlJvQ/y03c0AyYgH7MWZeGTjOQ/cSoLJIMZSSLAaLk7PrMiDDJtPV297cP5
	HnrVuXNXhMOZJ1pKS/huSODS8g3iMMP23TEptxLlhXW6POO+6RlZEZzFtP2nvJBUncsJiTd5IJG+n
	YE4lS3Cw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1re-00000003EZR-28re;
	Fri, 13 Dec 2024 09:21:38 +0000
Date: Fri, 13 Dec 2024 01:21:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 38/43] xfs: capture realtime CoW staging extents when
 rebuilding rt rmapbt
Message-ID: <Z1v8otrhDzbrguWe@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125217.1182620.4172567589046146931.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125217.1182620.4172567589046146931.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

