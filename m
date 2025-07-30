Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E801B2D662D;
	Wed, 30 Jul 2025 14:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753885406; cv=none; b=KPOE8/er59JzOGi72qxo8LKu9oUxE6wGYI/UnmXMAsKVIjxZJFw0fXXPlc4tcIcjP9aIW8ypMDPGBaOejbndM5CF4cLT1Bpd8pEQW2u63UE2BVyEysrDG9KdbYCtdqZIEO23TEJJbedVXzkgVNcfyGTS/F5VO2KY6OdG3wFn/NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753885406; c=relaxed/simple;
	bh=FNip1lJ11LmzMVpo0gkxbEKPZPJ5pZDVsdSGr3tGFLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gM6VJr8zz8ntfCVcr/wKr6jtpWbbzqvId0G3WhFN0mkDzS70paAW4Mpu/G3iJbfw/uFZ9rrpbzT527ucVONOSIeLqOM0G0HqROSmQkEghyBZ3WIZtmiLc79OtNYFhs6KK/5002ZTggMtO83QNVq/B4luqDBI894n9ogKyR6/2t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QYMGvZat; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QYMGvZat"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9GKp2r8p0VKwKQRo0R27r6Ik8ukpO80qLA1j84snWDc=; b=QYMGvZatFn/yMgLOwzWz59NYHg
	PcvWn1Kn+lhdMH7q+72AzlId//VZtqLNtz+vPNysumWBYF0gwaorfb5my+SxkANMM+h9vvZHeIoXs
	lTnbdba+nVGRaCVu9ACo19W3iQkrl412JQlc3qeP3R0bol2PAQYSZNeIEc5A38K9WdQKW5nXFrZo4
	wGnVL68qeHfJLLG+aDhiM4fJBfTfNRuTLvKdGnDw33QF85EVDFKYyhvnpWrf8/81o/i+c5k6WmIT4
	1jDi1dXrsEnwqe+b51PdiEajTm/6sbIx7dCsvjKCRUNFEXUnO8uweoJ+wMkmSxuJCiHQBmTtQauCA
	URY1iZcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uh7iG-00000001jKD-2NBq;
	Wed, 30 Jul 2025 14:23:24 +0000
Date: Wed, 30 Jul 2025 07:23:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] fsstress: don't abort when stat(".") returns EIO
Message-ID: <aIoq3LgL2ODgENFy@infradead.org>
References: <175381958396.3021194.15630936445319512317.stgit@frogsfrogsfrogs>
 <175381958421.3021194.16249782318690545446.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381958421.3021194.16249782318690545446.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 29, 2025 at 01:10:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> First, start with the premise that fstests is run with a nonzero limit
> on the size of core dumps so that we can capture the state of
> misbehaving fs utilities like fsck and scrub if they crash.

Can you explain what this has to do with core dumping?

I'm just really confused between this patch content and the subject of
this patch and the entire series..

> This is really silly, because basic stat requests for the current
> working directory can be satisfied from the inode cache without a disk
> access.  In this narrow situation, EIO only happens when the fs has shut
> down, so just exit the program.

If we think it's silly we can trivially drop the xfs_is_shutdown check
in xfs_vn_getattr.  But is it really silly?  We've tried to basically
make every file system operation consistently fail on shut down
file systems,

> We really should have a way to query if a filesystem is shut down that
> isn't conflated with (possibly transient) EIO errors.  But for now this
> is what we have to do. :(

Well, a new STATX_ flag would work, assuming stat doesn't actually
fail :)  Otherwise a new ioctl/fcntl would make sense, especially as
the shutdown concept has spread beyond XFS.

