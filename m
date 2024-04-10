Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC8520E3
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729914; cv=none; b=DUGBZhktyDMsCCXQ82tq+c1Rc1hMlmago+OYINlGa6zSyXamdrtexiUptWLcUGoRa3qpTH7IXlyCdVI7rGllayZoesTmI7sY1NPZ4QS95TMBK+y6FL+3+wj+QPNetSHR2XuzfZkw/Dx711Qlb1Sd+EfN/th7TpuL2batEe962tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729914; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eg567z42umw4J2YGaoaO7/QT9bpXBa50RSmJ1vRj9x66ZER1H/AUBGSmSsFMqzffcQXYvJli8njTQ3QKRP11NsRH/AXTsXEIrk8lprey8DuLdVYAAK2BqKm95NMItVWuieN74C2ZAnedr2xPIMkxx5ajarCftEMNh9tmPqIFfmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=5EthiMnb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="5EthiMnb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=5EthiMnbfJG9BNxPZF6GiP5koV
	+rb+HzKIKRVZQ1HV2rSKt11T6B/LYCAanXW7kA3uFDSf0P/keOXCGR7oX4MY2bwzh+1grI/SaQ44+
	xMRqQpvq5Ng7JEe3afyOpEULJrf05gw3Kkni/0x+hqJ2kfkY+iPoCcAcsYNftc3D9f5uc/s8Jt785
	BOQAE4dxTxqCsOVQWrFLZuRHk35QSEt7ns0OPsIxC/U2mZnjhIL1roO4eLPd75ynyFLE1JTe3I/eX
	TGiQGk3PVY/XQzLE3pMpQU25zJm/EQc0aRpSPYur4rl1ojHnpOxCNzOPoXCx5Hq3+tzeLBhJAMO4q
	aucw4Exg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRHz-00000005LmZ-0aqw;
	Wed, 10 Apr 2024 06:18:31 +0000
Date: Tue, 9 Apr 2024 23:18:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/14] xfs: add raw parent pointer apis to support repair
Message-ID: <ZhYvN5_uNsbIkqcV@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971021.3632937.6862433314181408424.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971021.3632937.6862433314181408424.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
