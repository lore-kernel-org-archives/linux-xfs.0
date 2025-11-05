Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1AB2641FB
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 13:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762348377; cv=none; b=nQ1rlvv62+Rk1tNY9kEnu9dLia/cw6hVVtOzuGox576TefoU8hdiOT4v+inYyMSVPgLTMhUbA0fVnSRBsp1zUjbKbH+d9gE7YDjEFRper7hhZpjCOsW9EhqkAbvhr/ZZs2/q43VYzky8w5ISSz+7EkcQ95AbqBKJ50B/JIkJnvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762348377; c=relaxed/simple;
	bh=qKb6ZNiCjaNgC0GiQglmYKOfQhMSoJoSBQQLkMm4JW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LP5+Lmmt/N9PYD6mXZhQPnmGwfaH5cpZDnkNVYVEEyYKzdebZDMkacSj/mCRhmHHCTGbRoPiK0Ptq+M2t9+WdrIJF6lVzd3Pw/0wpZDKuqNglN2XcjhI1EAfHuc2ffo1Prb3uhetEXr78Z2xgbUupip/wZKA/yLh3vErOCmua0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X4amzTdv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X4amzTdv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zlkI+kwdIp/IAHHryRW799GfPN47amNEHI354GdNKes=; b=X4amzTdvmaY2PbptH2DimEqEz2
	MnSgD1gRABO/WtVqbkiZ1TD/PGQ1FZamefFE8Q0FBoP/78yn1ruUtFVtTILmSHBhw+u38fr6bSFZt
	aJpJ7dblaim0kSYhvCo+kkNOjjDSynh/zpP+2BzXd7JSG2nomco2lO8reioN4B0FHW3mAjoKnMHVK
	9x8EXA3Ifc7tEiT2ZSUL8hn0jyWXOJS9/aEhwnfO/KZJRZGzIKV59qoy2gkFpA2p1WLVb7/MrtUJn
	uCHlJAwStZLoZg2XoaDXLxFRwxuRMYI0QQi0O/upqS9DM5khJPZD3INgR/0UVoRSGmYrQLCfzljl+
	a1zlxssA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGdJn-0000000Dk0h-0tQ1;
	Wed, 05 Nov 2025 13:12:55 +0000
Date: Wed, 5 Nov 2025 05:12:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com, bfoster@redhat.com,
	david@fromorbit.com, hsiangkao@linux.alibaba.com
Subject: Re: [RFC V3 0/3] xfs: Add support to shrink multiple empty AGs
Message-ID: <aQtNVxaIKy6hpuZh@infradead.org>
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
 <aPiFBxhc34RNgu5h@infradead.org>
 <20251022160532.GM3356773@frogsfrogsfrogs>
 <aPnMk_2YNHLJU5wm@infradead.org>
 <24f9b4c3-1210-4fb2-a400-ffaa30bafddb@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24f9b4c3-1210-4fb2-a400-ffaa30bafddb@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 05, 2025 at 01:26:50PM +0530, Nirjhar Roy (IBM) wrote:
> Sorry for the delayed response. So, my initial plan was to get the the
> shrink work only for empty AGs for now (since we already have the last AG
> partial shrink merged).

For normal XFS file systems that isn't really very useful, as the last
AG will typically have inodes as well.

Unless we decide and actively promoted inode32 for uses cases that want
shrinking.  Which reminds me that we really should look into maybe
promoting metadata primary AGs - on SSDs that will most likely give us
better I/O patterns to the device, or at least none that are any worse
without it.

> Do you think this will be helpful for users?
> Regarding the data/inode movement, can you please give me some
> ideas/pointers as to how can we move the inodes. I can in parallel start
> exploring those areas and work incrementally.

I don't really have a really good idea except for having either a new
btree or a major modification to the inobt provide the inode number to
disk location mapping.

