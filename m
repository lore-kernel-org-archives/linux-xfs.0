Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8979043E4AB
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 09:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773135014; cv=none; b=FncBGCsjAKyxhN9aIG5Qi6M0L/JjQRWQoARVQx9ftZyURHuqILgDOgbkKQ5BlJBqcolCoPkq5GD2clWz4x80Fb30F7pMSggAoFU2LIFcUceZXVh8tGdhZ4PixizSGqkG5lI+4hp4gzEn0Hn/bnSATHlSus3YiBiknarFzlzpjls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773135014; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=feBqerTiy62UZZLdHKeqYJUMtiODFh/eO6DNlra0+7rrv0oPZBJbQb9rnP2Lp2YBFXnJIlQ3el4RTyYZEis4FyK+B4bEg0JBm9kmKHk+MfsoFzjTzbV9NNIWjvsm+DYzv2zx2dWmWx4i09d7yLSW2uHgnHl1ipnS2FW5PciPE8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MjlsvvAB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MjlsvvAB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MjlsvvABTvvHsN4NJ3+9V+8IjT
	yM6q1nqmWcDs0o4MMW0+9PnKX5u2f7AnJ+IytsVtxD7uRqEUn6EpUpXjoLkhKU5+/vhkaCysQBFTG
	iLa6cGlxID6VpswQuW1QU4r92oxwuALGAhDyut/97/UF5Va1AJgRDxQLtlFrcOqlaL9FuEB0/IDmz
	byJEqkNiowjnTPYVx6Lsn8pAl3I/v3Xpd2WRPqAZR0BMv+7sgqbog1ksxe/y4CQofYtNb/0z3NXj/
	DdsJ7WjqRB6PimhTvgnS36AyYeNKza1sNbqBvHdRwGzmhZPGJafPSw21HrEHIN7NUTgzcgagc1pKw
	TC6EMtPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vztPp-000000095nH-0RbU;
	Tue, 10 Mar 2026 09:30:13 +0000
Date: Tue, 10 Mar 2026 02:30:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/28] mkfs: enable online repair if all backrefs are
 enabled
Message-ID: <aa_kpSCsFy7oEuAM@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401930.1183235.5546361742527693533.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311401930.1183235.5546361742527693533.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

