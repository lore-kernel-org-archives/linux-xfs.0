Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AF3BA3D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809192; cv=none; b=a0ycyyQE9FNYORIKOYE2ASQL8Ek7PFJxbm4RK2YXd5PiKa4YGyAnFmwE+8hpkOu+Ape72zXhP/hNPSHCeCpGaJaADE+B16isKRDfrt4Tcm6dmTW6TTb/jvQATsLA1x2ibMT9hGxEMg+wi51HPyBtJdKvWU5ZYg4XlcHhRCv9ePE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809192; c=relaxed/simple;
	bh=mzm52nfQgiHxdL4MhwLfOWkFlt4Ogya2J1OfLHIADwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLqkLkUB3oUi4M+VikeT/mtbGWxRvFZukKdC2YWBaHU+zvBmC6ZpioHaFUx6CXDBuFPg6sYU3JVSli8nJ0KVtk1ioSzTS2YynNI8HnQU57KfcMPxfEGDjksTzye6y70ng29+SMco1yPs8AiKzu3Vc00CZrZKCN6qkcWY16wsKPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=y5+J2uo5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y5+J2uo5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mzm52nfQgiHxdL4MhwLfOWkFlt4Ogya2J1OfLHIADwc=; b=y5+J2uo5ljXxT8Nrg2vRbcrAfk
	OilLo0UGiPJYWciHVO+GMkci9cS3S6H/D9/m5/g7kkfTKlkqhOLDt1cGO5VJkUzAED4f2SISf+mk+
	DoK+pGnAGBTRQfQ3eGgy6DrTyjxJDm+GWSykyxmF4w5zlgD94VS6ExtSMTEP8tMgh/jvX0vxYv66o
	fKYY4+itSsSkMX2MHFcsrMk4MEnzAwhw3x1qQNNmtZUvEyznhnD8yWgMo3ohTT/vIeNCjHxgkEtQ6
	HGVUVThdzNrv/pwD4/HVH0cDbLO7qctjIh6/6+TtjdItE36c1/BapJsjhdN2dOi18c9YcQafGHwSS
	brYobUwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsyN-0000000AIRh-0wFo;
	Tue, 10 Dec 2024 05:39:51 +0000
Date: Mon, 9 Dec 2024 21:39:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/50] xfs_db: fix rtconvert to handle segmented rtblocks
Message-ID: <Z1fUJ3mpFOizl5vK@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752342.126362.7151084225885980106.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752342.126362.7151084225885980106.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

s/fix/enable/

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

