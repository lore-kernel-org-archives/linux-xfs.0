Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1AF2D978C
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 14:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753885552; cv=none; b=piiv1BWgoLU0nxU3D/vRZzgmKFd741U03DH9Xzbivqi6b/62Qitk/ER3AyTLs74tvg8t210mmjfquixOmyXe1EvKMR3te84HhP4rlWA/nx70rlnpJ74rWlqndfQU+uFrIp3xwYD3ShoWTNM9B3Sn8kIGhiH3U+ZG/lV8uScWSeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753885552; c=relaxed/simple;
	bh=LvLzBi2d/HJgURhzHko2L7rdXxxaEq3XIMrVAnIkMu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EaIqHLt50enBkA2mrHjHhDJ+zxnELQaFBtGRXOtvtQmhp9i+gdlAQhb1KP6NCdkktixcv9FFz6eTlN6w2Y62wpvFC8VRVo0H7GLOIZO+xUIp/FqjsAc/84PEXcNceV2GLW1ZrKiyFN2DiU0sApCtQks/IqXswKdqP4ONMUQI50o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2vXddeyz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2vXddeyz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XPy4JKgxbPQ8SMcavqa/jSKxAP2W+8RI8gsjn9xPJgo=; b=2vXddeyzpWY3uu99xOP0Oh08n2
	H+C5qi/QJaA8nrmCN+YD+LeBblHZ8YHzmRuhDAmFdbNgLkXtVM+yKqLbxeQeK6cyuml2BFiy9EJ9K
	oR2fDd7BmUUcA6B2iIXk8cUHHDapu0VxNe7TDFgwTJU2YLJY0nSc1EsMtLwfKc6cHdvPVONouB36D
	HjPIqsq03uFsoLmd/iTVODmKX0beJEphqNJ+hIbsaQ1TR3FoCVguBqYRps317aqXxO8LxGVGhX1Aa
	lZfGi62LyWshGEpQ+Z8Q9F0swcbsensp1diNar88AY8vN/Py8OO8SGfxKVFBYlho4ZCLnUZZbfo2I
	dhcS95QQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uh7kX-00000001jfb-0UlG;
	Wed, 30 Jul 2025 14:25:45 +0000
Date: Wed, 30 Jul 2025 07:25:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, dchinner@redhat.com, cmaiolino@redhat.com,
	cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 1/2] xfsprogs: new libxfs code from kernel 6.16
Message-ID: <aIoraWkCyc9xerT0@infradead.org>
References: <175381998773.3030433.8863651616404014831.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381998773.3030433.8863651616404014831.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 29, 2025 at 01:13:32PM -0700, Darrick J. Wong wrote:
> This has been running on the djcloud for months with no problems.  Enjoy!

The patch are pretty recent, aren't they? :)

Anyway, the resync looks good.

