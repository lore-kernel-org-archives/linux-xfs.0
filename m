Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7CD3FBA5
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389262; cv=none; b=oW+kbu70VKJ8U0CnBWZauLCPkfssJQoyf2hRtEiVN1IyYFdd6N1p8KXtXiUTHF+TmQyGMhnk1P20SCug2kP8Dc7OCSVXGgZaBWjmOTRBxlcoyQWDTx0xLLDKGUend5vnwE9GGlFePe/AcoJ9R2brRgLVXkX+52SjmOoF9LeI6R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389262; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EeUGfXFDEUJocvpRKA8BGQuNHCCl/r0hPBkpFOQrGNEhdBAlcGYWl974afaz1aWqD8z7eiJ2psN+09cStCWRalV4vytFhI9N7ahHA1GWzKyey7AZV7sle1XXO/EreEqR91+DVwfgl+MBiM5+kVC/xksVpsXMVLVLQyggCXV9LJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cnRk4Gvs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cnRk4Gvs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cnRk4Gvs/1g20o6vFxrL1xmBBR
	qZ4n8sMEW8WbFyenDbOq3Vs3lFQJ4fQ0Md1hx4EadJ54welNWUAISuYIoYS/xJdfP6hGqGGiyvT6R
	ODetUaMea4blGXB6/ecef0/sr8wHakqUPBgiojk2/wwY9LCMCDeDzrb6KG0Y7ab3VYsOCX1J9tISD
	9YM8PMp4A5kI8dssxlujvbV3vlRCPZMEaZUky8QHZfAUVieIHr3TWkZpAmOeMDuwr4VWDtHpF/q+E
	RFfF7X2riIszcft4CbCX6lwvcp4CIA60zx4GVeCXEsRaWomIuhBYd6RWHJwB66nQUaAfMr1MPzqUw
	C25UMKeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMQ0-0000000FFGI-3GrT;
	Fri, 23 Aug 2024 05:01:00 +0000
Date: Thu, 22 Aug 2024 22:01:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/24] xfs: rearrange xfs_fsmap.c a little bit
Message-ID: <ZsgXjMAFZzgWqHhI@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087398.59588.6301556679404762421.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087398.59588.6301556679404762421.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

