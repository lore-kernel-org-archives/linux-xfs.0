Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251A01FBEB0;
	Wed, 22 Oct 2025 04:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761106603; cv=none; b=s9cnS6ozwO87HCtbBaC3JTE8V30sdzJGCxqJKJChLYTBGqgALb/rhTASEzk/PqD10vQ+cmNOm1MjTe4wj6IBKkgySc2h8HjbYApJhOFzGLJM3Rv6PEZJLE+DUaU8+pk8FdPobmLpxBCpsMCm6/5M3sQLZbc7Ub+rUcA5v8eY1Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761106603; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VcgAGd1jSkVjrDLdOVRBGjbphzxrpHjeb7hONafMohTKlKYskKdmKzJKStFfw9hMiBfwcMXsKn1swpqjrSsLChosPrCy8SKeYP/FwN1DQWNdL9Lpl+Mjxu48mdQiwXEX57lCjtu1InS+ZA5m5MMal7V7kkgHVtymPXpvBwBHHoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vqv0cNhr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vqv0cNhr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Vqv0cNhrn0/yFuAn5qkAYldNM/
	Y+yLcoHI7KP/pD8uTAyIwjcWKhS9KlHSeQQe3+VqpoVp5T4Rp3GngIylpLqZsqJbz9yEtP68WKqTr
	VI/zLLGY4Ig1pBU+FEgglZJnnhvXwZGA99+Fh1bUkpqjvu5ESXwYSr8FkvKELJUcHMqc9e2I4VZl7
	j7dIl9iZQAlXOIIv4qYRa9wT6tNoEYCDA0FFq6pmacEkS5IkgRZjjCz3/7WJgVtmlCLof9mRCz4Vl
	bVY1mvDsZndKD1rF9Rqncw/CfYNijMqMeq3zfp26FED+1TTzjZhe+h7y7051BqJfO8vEV0m7dHDs4
	KHlvveQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBQH9-00000001Pqn-2N2o;
	Wed, 22 Oct 2025 04:16:39 +0000
Date: Tue, 21 Oct 2025 21:16:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, oleksandr@natalenko.name, stable@vger.kernel.org,
	vbabka@suse.cz, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/4] xfs: loudly complain about defunct mount options
Message-ID: <aPhap42o5sIrxymg@infradead.org>
References: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
 <176107134044.4152072.18403833729642060548.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176107134044.4152072.18403833729642060548.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

