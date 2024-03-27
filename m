Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B707380606;
	Wed, 27 Mar 2024 11:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711539153; cv=none; b=sM4iB+AZvJ2+rcjZxN0vPmSpz1pVc6UKbgQk8rb6PsBAiE2srZIQIFUmL29FzrN5aI8Er3jE8m+tgMFuVLn8SNJ9SYc3PIgzr6SKtnHEZphS4yKwkB+J6/rli9vSoVqUV0CeHumryFckkacGfFgFr0o3MItZyVSm0MM+kj3Bgpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711539153; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rne2mcxy8WuUMs5G7O5QKvqJjoo3UlurY/KNlsCIcptYzGnsvCfOVImCWMKcwhM3UKeqUZU8vSUYsz2L+4Sza3+HDzIoDS5yAJL+ihukCimPzwRKEcIKyuD2+OAAVDvgSOTDzHWKnDsVRVWdvhXr/WfrlBG7HOwK2dLJBMv0OZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tRgzAe6Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tRgzAe6Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tRgzAe6Zu9v9WtudO/36kbD/Ab
	1wqeYZ61VBsaAah9KssUc3vf5MsMxfKaUilsnMEwjt0n6XAHahm7+2ISl4bkFCv+z6l/HB7N/BLtL
	ReUV2PNjXwme0PsgJscKey2A9md/kK/DOgkIVJzo5MlF4lt/vRFFNaCKsk26rJSGmnNBCxyvLW/qG
	bNsXKjXjrKn3VKNbhsolzX4tCnR5QLdGgNwWqAFpjdN5fJZ/lcV7E4O9PMW7CsIb0KFnWKpPxxGYo
	Vi8nevQhxvNkzfG9++s9DZ+G+YPgOvA40T4hnNoDGcAMjwit2Obfxyit4ZJEi4bTT9xaZDG4CJRp7
	WxDxeNUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpRWC-00000008cvM-0sCR;
	Wed, 27 Mar 2024 11:32:32 +0000
Date: Wed, 27 Mar 2024 04:32:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	guan@eryu.me
Subject: Re: [PATCH 2/4] xfs/176: fix stupid failure
Message-ID: <ZgQD0FROfWEZo8X4@infradead.org>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
 <171150741023.3286541.16393057569793003518.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150741023.3286541.16393057569793003518.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

