Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B011224CC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809040; cv=none; b=pwpsPw8JyalEgnY8xeOp2sZH6QiNyeCDhAuUKI90mT3ctNeURKpraMbTtbUgX7901Rkfn1Vu9SV5c44exEnJhjF7QvETnG7zeHhWNRII3pR6R30kqK3rRUzy2zrsT8eozYFVlbpiUnXhNqF/I3vn696VclgmJKoFd1nEb+AdWMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809040; c=relaxed/simple;
	bh=1lqGcn7apA3hmGBgVLljdFZSZNIWV+w26wZUVZkjv2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MO4mcCWYHwz3VyI9ne/3S7M/l7+Rzujdk7szT2vk/JX4VbrJPJvzvOjdWdsNkV+otCEm8+zhFEk7lroieL7ae/bHbEbMMzGUJJczRAMN/4wLwdSqrthswvY1/9smIQyVwFIXNPslDfFmGvDJmFGDAAZj1GZ1FMd9V23jv25waBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l5oU9cp3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l5oU9cp3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ENNFsk7l6AuzzJa85yHU2RtpPcUq3uLl2EIk5QiJD8w=; b=l5oU9cp3Rwo5UoWUeqTH4PnpT1
	Boxmmnk3422cOpR3JNrI4k4z+RA3mRuOwUfnp4Hm+Y/rTUC29uSnwx0TeE7PYgN93K0N4TMzi4Amy
	bcidXfascPAdjv92c8XX2e4CwCMpsfm9/Wb6YLApSr1pouUW5q8XJoA3hkE8RF/490XL+JhhYYkFt
	/5WeefeVxaN7fEq+jRfGiLlKnTqk/nHu3anOs/1UzPw7AdOJR1G6i9IuhEo1aa3Ut5HWYrzv1iiWA
	H7bBwJbClWH+kQCB6z3FVuVk4DXLGLC25xtBWYQ6gJApJM8Nke1xOrzNXsXRJiai1RNkiN5EC7U33
	bs+ivNQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsvu-0000000AIFJ-39QK;
	Tue, 10 Dec 2024 05:37:18 +0000
Date: Mon, 9 Dec 2024 21:37:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/50] repair: use a separate bmaps array for real time
 groups
Message-ID: <Z1fTjg9Bn72eM33a@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752251.126362.2634382219651992049.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752251.126362.2634382219651992049.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 04:10:07PM -0800, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Stop pretending RTGs are high numbered AGs and just use separate
> structures instead.

This should be folded into the previous patch.

