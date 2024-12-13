Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFBC18D621
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734072816; cv=none; b=PfpdDPIsozWCqadvfi+NDyIIZFgK3QOa9nI92vuar14JyH1dg1NiapjvVhFPsa9hjbs9psfy9t0bfBH7d8QAvX/KZLkHdimSY5wGjgFnwkWLz8aphg2vJ5VqKmOcXv/Kxtgt8sdB64iqFDC/uqK9C6amODz/VZZAI4Vxh7BdD0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734072816; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EkVXpqvdrt2wTK8urCL5K7VZwRoxhC3sUJH3V+7K5QFc7X2pzhNIuTXjPFaFjXSgUKR985AS+NBX1AMvNmaeV12N2dGP0CC/eg3acU/HdqcnMuoLz9tRt+d/lmww9RwdjcFX+0UCtB3NGsjhiZrtXGXhkWOlVCBBL2058Wy8b3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S2IAholM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S2IAholM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=S2IAholMu/QWn07jLr2hki8QaP
	DmCgyPqfanvprpRrokt0oyQNqAwtARDKc/M/UXnRXn8eUjd2v/tx1xF5V/Va1bYZ0qMw+SnspMnr+
	E7jvxKhLBNRyWC/lzL/KA9TKcuEJdJG9DSyGX50m2JNBphseDqk2kF8NN6ygXUCTb2YthsfpMJuL2
	gmb1wQtMiJ2gDnaYBLvaysx1+v+SEAdMGvOomR7NXnM5z4xQ1kZ8wRUAzhXdWf30tg8ZVdVUKUweh
	RTJudEq01Ryj8hPxURctI4eZGIZQlLwE28XXlzNIv3gzCrLs2wk2gctqQpAIMO4LawG23iq74VP1V
	jqqWpq1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzYM-00000002uJJ-290T;
	Fri, 13 Dec 2024 06:53:34 +0000
Date: Thu, 12 Dec 2024 22:53:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/37] xfs: check that the rtrmapbt maxlevels doesn't
 increase when growing fs
Message-ID: <Z1vZ7hOpUKZyMupX@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123623.1181370.1362773049349118652.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123623.1181370.1362773049349118652.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

