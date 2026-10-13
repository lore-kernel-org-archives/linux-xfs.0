Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4B82EA75E;
	Tue, 13 Oct 2026 07:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876807; cv=none; b=EKV8ZMu3fsfKCW/YUcHeqdhzq0w5DvImwc/u0ZrrFKTTBcIZyA3t5cfIspwD9gcO/9UAQlW5/U/u9rF4cK8/GKDYRdAeLGuVn7B2mlV2F1mv+/dmYXc6L9xK+d/BH969eZki2u9PwpkHo0IHLAZoeab4KBTG25xzd6fh0k0wH5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876807; c=relaxed/simple;
	bh=dSYzrq9ijtZDeQYjDJ0FrIhVCO596evAFlvFtM7Ts6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTI4CTFUsAXAPjFVwqIiYwg1ovlHqfS+e1nWsOnVo/c4cdMh4wwfsPrVHsHtkqXPD6LXGdcR8KOFYSxyHN3AjDsq8eXNdAqTBwEUr0Kh2TwkAJbn54ebDgBYo4yv5zwIj5EpkXJjju/5//9pGvR4wuOGBg3wYpeshBYl1+teW2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bYM0YgX0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bYM0YgX0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/qoapMn/6pL1hrFdLLkBtCXnBQL3sIWQsusHKE/W6mU=; b=bYM0YgX0r//nHJpjP3+PFyEUzr
	vlOFS8I7a3nioRfe4U+oXcX/s9kWP1pv0ETdHg8Fj3Hm11l6ooCuEKRIl0c0A4mDJi3ArpEc7J7El
	kYPKuBY9gXtr3ZYezbtDnievAYgF3+1u3ePeE9MJYAtmBuu05ynvlorbdkBGx3MKJm0acXiJqVp0O
	4V+JIeRW2cVjaGEep7jTpugSMyWSOs+JRT2Vi/g8G3ylG034KY9gsEAS1Vn5PxPubp30vw/6EsFSN
	HGz3xZYjsRNwcciYWSSP2p5rU07OPBq9qOeBYR8h4z0Um6+PJ+r5dGtmOQE4RE4pFqFwA5utlPxuF
	qsc2lUSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGX0l-0000000CDui-2npF;
	Tue, 13 Oct 2026 07:33:23 +0000
Date: Tue, 13 Oct 2026 00:33:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: test rt group superblock repair
Message-ID: <as3ewx0oyRLR3j9n@infradead.org>
References: <179185007737.1732474.11416600010761357309.stgit@frogsfrogsfrogs>
 <179185007762.1732474.3280794647975804123.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179185007762.1732474.3280794647975804123.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 12, 2026 at 05:10:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Test that we can rewrite the rt superblock if necessary.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

