Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05681E00A0;
	Wed, 22 Oct 2025 04:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761106896; cv=none; b=eXgywlZ/Uisz6CAJ0u/vTSdwXDZipYpFDToHHtR/560EPWy4EbOZPP5pU5Qt5y4TYP0QFUX0mdM/fV91r8G2MxnVx5NrEhJyQGfAk9Ip+eB5fZLFeMmoNmCDyFU4S4uzA3irFvel608W96wa7/NzVeKe/VaQev2YCQIV8xq+DA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761106896; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARhdGUvGEwBpiI4cp2ksMDL9B3wfDlBmRTs819bTIYY6L9szvcATeF9thybAbufSvKPRL9mnDe4HM3AH6q5rIt68tzGx0PRgqqYOQF2jglYQuiHxqb5v0R5HPTKfCx02qkJrd/OP2Zr8w4X/u2Vv0YJLCpauBiN/2nbJ4OU9lj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Lju8o3LG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lju8o3LG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Lju8o3LGDOhW6jqsYX1VHfoEib
	zX+JNJ/sB5FPrgGPxOuPzY0uBCq5+e0QNFzm3YIdmraxLxrn7ZdXO42ZGcKifUZMnJf6tAvt1Vole
	NQH6THE6Qw2ZU7byz1I+yjxYlvdpOtuugGnrF2E1xhUStfpLwdvrpWNfJXo8f4btBvzcPsG1bl3Y8
	k06nkR67y4aGI+UH2EqKhh7l6Ay8M7o3OAqPz7IxZzsQXcEA+gwwVu3+IL/BmDGvQtMHN/y4U/xTK
	j9s4Op4nYMshBuSQFMds3qHh41cldLLl09Hag5wZEiRRw5ndhOJrTX8XclJszroE2ID3Y/S3WmMIG
	Or+2ns+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBQLu-00000001QHi-2Ge7;
	Wed, 22 Oct 2025 04:21:34 +0000
Date: Tue, 21 Oct 2025 21:21:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] fsx: don't print messages when atomic writes are
 explicitly disabled
Message-ID: <aPhbzi-r_mn5qzA-@infradead.org>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
 <176107188870.4163693.967026967128229321.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176107188870.4163693.967026967128229321.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

