Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E77A288D6
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552828; cv=none; b=An9DaPf9SMuqixlXxqggw+AWpF61CEgH9znvr/Z5OvZaveIM8dF1iYwepufEEh+NIK6AOLZ4ZcaZpPZmAn3/HmUAxQJ16ma0kSi04+wQ8ndwNnjIVLMMtnUI3WugVdqNCEr2PmxAFo7BuHhvHNgSIRZr/O2ZG/XE9bSEH36Wj4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552828; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eo/k2yixjCxpYKJ2aBYN+NSpFCZDydxYgNm6B6o1TpC7l1z7VPI5jfWMsi8Qc6m7YNSN9z4cwD+EPmZFZZU7Qd9ONpG3BIfHwL30Cy7jn8ZKTWUdsvygcRrL0f1UuTm5Qa/JGiVQi6LDdccshRkpuZvlfeT4Tc3P2KoQLQi+g/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tMN2xCyv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tMN2xCyv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tMN2xCyvJLirkcPzY2qV3od+wO
	PyKJAg4LnZv+k816iIkfE5eE7VFYcxyajHHeKBxru5H+i8+4rm5ZeKHt961qCRLEnGnoV7nn+oawZ
	BW9uaxfotnsHeHkrm771ZHRgiMuLSnBmM/TMUfRd8ZFNz3orj7EiknqzXA2iG8hxkzyISlxntfk/r
	WHd3d/miYCWwiICdGx/gEiEdvwgeIlMsToOnrQsFWirKCD/sYlVwFWr044OnluvUO7z7BrSiTXH9I
	JBNeJYkwW6rPT5Pke45rrmuGcZaPVGRFkXiM1nbKf2t94o8EeBNedavDPs9UUQazH/ksUDStiQRHF
	0nmlq0jw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRxi-0000000FSIi-3QkF;
	Tue, 03 Mar 2026 15:47:06 +0000
Date: Tue, 3 Mar 2026 07:47:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/26] xfs_healer: create daemon to listen for health
 events
Message-ID: <aacCeu1nEpy4PWJe@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783453.482027.10512315516573302721.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783453.482027.10512315516573302721.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

