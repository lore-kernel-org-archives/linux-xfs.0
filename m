Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00B23403E8
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 05:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054680; cv=none; b=haUHjor1aLaNWpuJ2WnQqGEz4oX+cOEwoNYeZYpEfMzGsEX0ffLw1jxBKruoNnDJCeN30J/VE9652QTCGOt7GwVfzfK5/8ANaayd3adfVnP/Bc/vc6i8hJCmSaAFTbaHI84YGweadn2K2pd/UHfcfhKgY5YXkVwA/Qfr0bgBg4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054680; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZj1DxLQ5ftju/H1lIYife+SIrZOgLMxQX9g03+t1d0pnabo1E2PD8sd/zpKLzVRWabqbiatojCx8FlDiv1MpIwuf81Od6TfA5MOe8PbuFAh8GiX/mAnqMfTUXPWntNXzzMMrEKElbqh+7dl6VeaW7xONUBdnR0OfrskCRjPYRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XR++gBDT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XR++gBDT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XR++gBDTvzVIBnEWdsrtHKaVAy
	4N3gl5qCEc49CVROxb+RAhjzh49fBW6Jb6o0+Hvh4yGwRK9g1bm4gW09k1TV5qkPBSi2G8hQ/8dyu
	JACuKSJKpOleg2B+lP3EKIESaXwDriSfrhSegIh/uudUzthLoZQ2p/pDMIJHA6jy2hWkVKtcOm/eh
	Aev7vBnYCKozf7VDZMBvXWfC2KAvh4rvUvw4ug1SwmDR40uC7StLd5qfGiO44J0QeQ9wfL0Ni4kXp
	xT6XkV/p/sw2wWOiC1MLkZ5ihs0IbsTwwEEm0zHGKAM/inE9h4Urrd7zuEAHr7K7T6yyPpKHrJ9cE
	AQdaevNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8szf-00000004EuN-1kJd;
	Tue, 22 Sep 2026 05:24:39 +0000
Date: Mon, 21 Sep 2026 22:24:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/14] xfs: simply the free space btree repair code
Message-ID: <arIRFzIKwzW8V0Pi@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120828.181988.215380146814084651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120828.181988.215380146814084651.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

