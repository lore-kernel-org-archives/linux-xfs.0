Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CBD1A83F1
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jan 2025 06:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736319349; cv=none; b=BZ2GSpc0BcetXN62/K/tFUSkg9rTcyYaA0sQBQCDxxOghAflL12VfXw164GTmecyyHyNbcv3b1mZhr8oYFqKJPI4aDQesJ3kyvyPdpfTSzuHjIaCMHJoM4tWyMgZ7waprQqddkMbrES33tV0KQ7uzb6ALrNM9JaYh/Zx07sIzzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736319349; c=relaxed/simple;
	bh=5T3bA0bBspx7jIwkR1PQEGK0B/3v+F3iMCNC0rk/NSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cb63VEs2DZlerkEh0ChfvvvjdixGgwhW4NE6F2osxm8SoHZXMe5crDaEnajjb4CydivCdI6bBCRpMpjSLNA9ldZONHDmteKuIwr3hLV6pLEwlfLmpb/Y24hlHUPxYTu4AcNGF48NvsytG7uzgUR4Jkdh/si0IeK0QR3ASV3Am3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jGFhWbjO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jGFhWbjO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sJBvk44ncbE8QZYfJbkDD0B0jsD8/ZCM83wJ1Sp0TL4=; b=jGFhWbjOCCTQfFN5+sYx6sUFbH
	8h1QhWurpD/sG1uKpfBvqbqStxPGeJBuGs+Gu1ZX304/+XjGmRcGm/unDM1FJHN+edSjorYrEHHRc
	bjSqd2+LXV/qFzcnQXQBhqbTrxkHbe8wCFop9JRHKR9PpWe4E+VKM7+4KaBsYAp722rrVN1Q43Fng
	TYosFZtwy6M4uCmfc0G5fccLnmeQyOeYQNmAwUAYVhpGZVlD+L7bajutqP1iD9HxDLCgcvKmAkO9K
	MfGUgezBXDpdR85oAb+0dxp1N9G+y6o9ToQlb7DECALsrZKdw5gyOKdeJOC1FxiDfYSvlZ/Aqvudy
	6UYzJm6w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tVPyk-00000007Jhh-2PFr;
	Wed, 08 Jan 2025 06:55:46 +0000
Date: Tue, 7 Jan 2025 22:55:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Long Li <leo.lilong@huawei.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 1/2] xfs: correct the sb_rgcount when the disk not
 support rt volume
Message-ID: <Z34hciJJXpgdoMOc@infradead.org>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
 <20241231023423.656128-2-leo.lilong@huawei.com>
 <20250106195220.GK6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106195220.GK6174@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 06, 2025 at 11:52:20AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 31, 2024 at 10:34:22AM +0800, Long Li wrote:
> > When mounting an xfs disk that incompat with metadir and has no realtime
> > subvolume, if CONFIG_XFS_RT is not enabled in the kernel, the mount will
> > fail. During superblock log recovery, since mp->m_sb.sb_rgcount is greater
> > than 0, updating the last rtag in-core is required, however, without
> > CONFIG_XFS_RT enabled, xfs_update_last_rtgroup_size() always returns
> > -EOPNOTSUPP, leading to mount failure.
> 
> Didn't we fix the xfs_update_last_rtgroup_size stub to return 0?

Hmm, looks like the patch did not get merged.  I'll send a ping.

