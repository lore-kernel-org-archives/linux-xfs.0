Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0960B3769F9
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 13:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811155; cv=none; b=NL8VyYsrWHqyjgOOQ0NIpZRSihjUFkyIcK2SGDRjbJlR6CW8NM1RmrHy2Px4+8v1SrizbrgVy6cyCRuK6bAlTxt5bZR6tlbb0Mv8A6LXKU+fHekvAEHwD1r9a1xhlgvhFpneQ7rj4Cuyl9+FDG7jfk+muHAtxDia0XeKdUyo95M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811155; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQUw4BhuSu00MgeU2FT6+VYeD7zaLbqPkzzHzt+MI0q3xYjsc1xi5u3mQfPY51WE6vUVVfzmw83mYHUlfoKlCPPxfFzO1YTbwWAHc7gaWUxokIujC7vLcxChRx6HA80EmbET5Zdn1STn2lmpHQ7jb9EJ/VrZv0+ybu/BK331K0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gCcYHWBJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gCcYHWBJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gCcYHWBJoeORMRMQGL8AKx73na
	U5d/yNXZlTGNaEAtJcCH7KHxRIlAJdTuTBM4KM+IMNpGsFvwy/0svNGVZW7gd5uLa0aI3qVdZHzg9
	5g8mePte9/oHWVdEq0hW8VcBRaVKcCiBnqFndBuIsHYFmqpaRZdWHvK1UlvBJ1NmMoXt5IxhpQpzI
	UHCIFFDBl/+S2EndVMj6IjinG3nAZjH7FAMGGBMTqH0+7/2I1ZqwKN1CtyZwncPWRxWwuwZuOYxjl
	moBz/SN8ujPG2nfWDrfc73KshVNyuvovg9XzikA8NouEKB725TUxPExju4tlqBHF4797LuV7BYyVW
	SM77GP/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFvt-0000000AY0W-27uw;
	Mon, 12 Oct 2026 13:19:13 +0000
Date: Mon, 12 Oct 2026 06:19:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: drop unnecessary sa parameter from xchk_ag
 init functions
Message-ID: <aszeUQ4n8v959clJ@infradead.org>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178066014.1058822.8802191247645588099.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178066014.1058822.8802191247645588099.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

