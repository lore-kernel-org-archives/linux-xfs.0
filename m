Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3D314A098
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893345; cv=none; b=bm2+u5sYWPyupagkLUtGsWra86mfGKazTrQ28ukL8B7qIBOdXFfBYU524R2A1VjKbw7o8RY82p+rwY/qoqmOCgzENR1AcHSIDRNceah9BNtlZzz+GktRInMNzk7KzQjNEXxEifK210bPMPMoy8CdeFD41pAl3Bgk/NMISMjtOOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893345; c=relaxed/simple;
	bh=FRxMi0xn8X7fAH8ZbxNsXulRtT8h+sMWsXqRcP3P0jY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mOQyHvBq5Ud5FGTgwzE3Mvd2jCzPQrkEYSbDosOqV7OgwdAj/6hYE33SeppA7J81BAc0PwYpzUZljVeqCSFuQui0TwXfjOWJESrsq2YeWy2EFz2U76hdncjqKZIcBEPsm2WH3nZEAX86FcO5xRJvClQTc+dHY7i00/Cd6pc91PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yS9lyQwE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yS9lyQwE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5Z+pgOP2MpaVPoID+Z1q0yA7NKBwrlM9BKXejRTx5mY=; b=yS9lyQwEPv0/jvc4BIKbJfjVMQ
	23ZyE7PoxuucdR4naPpGsu4lDKiOwycrIZT+zARkdCtwphn2GMvBNVDk0AOaBIgrt3UwfmDap6c65
	YKqVL7GriRjesO58YyAqMIuXKitrNoX2p/LMRNP7OsPy+3g+bOZVnWnhqRhewbU4+wnIImsddwO6H
	Gvz+i0VvviUqyGd2hZSH925GI5MN+Kw80e6Pn984juhwahqGtgAbhISDzMxVB67AUUrBYy5yv0y9h
	tbPBm2QiTu2PkScugG9qKVknu+TWA9ul9C/FpqpPNl929ca8mswMI0SZf1lKasdkAN3wC2VoOdaAk
	UIcxqKFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0G8V-00000004Cqa-3FJf;
	Mon, 14 Oct 2024 08:09:03 +0000
Date: Mon, 14 Oct 2024 01:09:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 30/36] xfs: move the group geometry into struct xfs_groups
Message-ID: <ZwzRn1fEt0xHdel-@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644760.4178701.13593967456112695233.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860644760.4178701.13593967456112695233.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 10, 2024 at 06:09:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add/move the blocks, blklog and blkmask fields to the generic groups
> structure so that code can work with AGs and RTGs by just using the
> right index into the array.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I think this lost my From above during a git-rebase that likes to
strip authorship.

But this should probably go all the way to the beginning into the
generic group series, maybe even folded into the patch adding the
generic group and thus also xfs_groups structure.

