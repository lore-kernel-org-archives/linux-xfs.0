Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CACE3AE717
	for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2026 06:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774332926; cv=none; b=M2vVDKQP3iudHN2MXkTJ/43JxxBZlKF9YBnbQMSgV89110DnE6va8P5eIpwlNOciZYSuhJSozNGsKKVVDxG8KbhLDK78TaOy1DRkGo4ykM6fKJow5YRNN8eAzycGQ4Z8Hv0zpIYpELxzXVfzl6exx7Af5EUvOyRXo4hjkivHZ+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774332926; c=relaxed/simple;
	bh=znZYB6JMkfpn7GEmlZ4w50jv2RT14YrQDphxb37OK/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ss6WjxJWmDoO0+y/m0I+KEArYk21e9Z0BO3VYAMLmMkcMJox0iwSNU8AbTlzJjW/7WHA8I739ysxmeBatajBR3aLGgI9HZ4DVa1pQvoSUYCg8CVsKJr+XDz8lZc2TC1L8ESYZLfxaciLU8LjqazClcdKAE6FCoS7fwsiK9l5yFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rsT3NbM+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rsT3NbM+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lDHtQocQ9aVe6ZkQNwlKF1cn9KNEzo3lNyasLo1mJ/s=; b=rsT3NbM+dGdQGj/Vy876PTbyTT
	V/lEILzhrSspJKQ/ZFBGP64zYQzGVNg+JUFsfQwIkLiZrqyHweNmayRBBauDtmX8e/rx1qCd/FPNi
	aDlPDX81Z5LMQUlOyuYNQlLSDkTfjaHhZr+EkchxlsfuIolo9DnCukHlZ+J1WZ9pM0mUBJzLpaIic
	Yo4rk3YpXgdlUlhqXE/EZB7zVmGnNNiQaH0pwJTzXmjdOm6P8OQf5+AsK5R8hMa4Kx6e09dRSI2Wx
	u8vUWYJd97sI3WG38Cm3AA7Z0lyhCBBvnOQyDKNrO48+UKfK1I3rkfDRSBS1rtpCubcmqRCUCkT2s
	UkBwXHGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4v2z-00000000fkY-06fX;
	Tue, 24 Mar 2026 06:15:25 +0000
Date: Mon, 23 Mar 2026 23:15:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/40] libxfs: fix XFS_STATS_DEC
Message-ID: <acIr_Vx8zzFviTRY@infradead.org>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
 <177429120757.2266274.10399851330751546106.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177429120757.2266274.10399851330751546106.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 23, 2026 at 11:41:32AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This macro only takes two arguments in the kernel, so fix the definition
> here too.  All existing callsites #if 0 it into oblivion which is why
> we've never noticed, but an upcoming patch in the libxfs sync will not
> be so lucky.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

>  #define XFS_TEST_ERROR(a,b)		(false)
>  
> 
> 
---end quoted text---
