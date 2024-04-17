Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6081F1422B6
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367284; cv=none; b=I5vQe4vHETRaQTnrSr83Azi3iCnJgUoa788JSKmCHYokhsvbq6mKMEmMs5axv5DQuqjUEAHfP0LlDMHA76LSWdc6nhefwcEHOHHipcLQ6c5mbmPY15jO6gNnuBQOGkdiTohkfHd/WgaSFbCwRenUQACnTFQzOQcGfD3BBDqBzXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367284; c=relaxed/simple;
	bh=xmHEWorQyrqslpXCp9wU/nrknHjBX/LuOBH1ra97bSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=noZnUz5+CjILvg9U8OjFO3AFYXea9UmqgoU/TNh8BUccdO5ctjBFxKUwfDrZcrCTHTYP5FknOfVHweGlAh3c1gNj9E3PQi0ATMYjRY1Yc/Z/fu8mbrLDJ9ek5xBDl+qmGrHwQkj4q5bPbOzEJnJWkQvBZKgXuissgxcQHOVUnv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w8ajxWm/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w8ajxWm/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=19q3FM1IoRnnxhnWZvfAnhKBLw1MNVzzXgRgmaNkqfw=; b=w8ajxWm/SlDhpcE5e/hXYAfnmS
	YBm4LG5XFk3l32hexHA/dczDnZqzSZcpEg5o4kNW0SpUxSekDQqBI5mo3EQOYoykMSvXYqEy2lC3z
	+EIfqOPuo8sbSpbZgWCZOGjyczFKz+EimVowwtOmc/cJR1hn++wdeEA7gNJUzp1tklAZ2MWpHVlSX
	NJxD2pznEyGNNHZdgsqBC/fm7al03b5J72YnarXqXhin+sPpJj8Kw88t2otqasUUI7YTdpp5VqEd2
	IhUvu3xsdAyPIOb3+K/6al6VSEEaLtJVpPVIGi0Hd7J02476gSt9yGaIJGSzBzB65cA4WWhwE49vE
	UBaAJh1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rx76A-0000000GZ1u-3eGw;
	Wed, 17 Apr 2024 15:21:22 +0000
Date: Wed, 17 Apr 2024 08:21:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v3 2/4] xfs_repair: make duration take time_t
Message-ID: <Zh_o8iQtw1eKbTo6@infradead.org>
References: <20240417125227.916015-2-aalbersh@redhat.com>
 <20240417125227.916015-4-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417125227.916015-4-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> -				(int) (60*sum/(elapsed)), *msgp->format->type);
> +				(int) (60*sum/elapsed), *msgp->format->type);

The case here is still superflous, and the space around the operators
are still missing.

