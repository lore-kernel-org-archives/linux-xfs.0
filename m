Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA3439FD8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390391; cv=none; b=EUw5vUl2EpxUQ0xKrT4pZUeu1D2TPU3w02Qa6MvNbl7H6/Ej5eXFJ0BOGOo5BgNWMzwt6OczmKkHb2PGVJRp29JR2GrYf+DW3HCLAPIDXs+9vkrn2Aap31zG6c8XuOPotK4SIyG21NrencaPOBav5a0s5KEs2VOMzbvL9XvrSDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390391; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GXjsJQ4eCBAF73omAjywcnoVTbIKIHuh6cUX0Og6pFeyNx79XeK1t3CyZkEp1YACdKaNSOyqmKv4F1aP/4LgbiJP6DbBGci+U9aq0UnEB6O+0JgFabiicGLK6Spxb0vSaYWFaLq79BWjKrtZaLvTL2A5SbTSFamWt9Gh9f5GXIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vxBU6Xa9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vxBU6Xa9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vxBU6Xa90LNlEE/EL9BGBKtkYe
	7gkRCs/eKnujTHXxk+lBsXGUtOmjbefcNIC+lqmyUQpnhW4IPat/ISCzwOnRfoTD1tLnYaVHO77nZ
	yrGB6WtqTwsmaqCFXOXC6gNWjm6LBhHP8BtRiL8UUPy/eWCtVHjq6k1inecNA4eyE55cqbowkW5DT
	UxttBR0qq0GHXkRUZmJmJ6Fq/nBfydcE0lvYFTYdVMjRAbAs+j5JD9Y9zz5BSQzUQS7dsbS7H2Yhq
	55UOaSb9ckP4fNotFn2yqZuHAKPy1MlKPzyYq4qbUg4uHAZ2iJr1aXSjBiZmep9N42MZv4DHEk3Ui
	IkGpoYZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMiE-0000000FHrr-0rJW;
	Fri, 23 Aug 2024 05:19:50 +0000
Date: Thu, 22 Aug 2024 22:19:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/26] xfs: repair realtime group superblock
Message-ID: <Zsgb9s6mghjspYQr@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088939.60592.12149395691309789384.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088939.60592.12149395691309789384.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

