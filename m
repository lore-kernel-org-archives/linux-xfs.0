Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB8F253932
	for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 08:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762851266; cv=none; b=C0JYQ4XRPYIeWGoy1hHccZ6IEJB16qL80+O+J0XW+FlAl3E7K9VeORwePJNAgm1zRrCgXl6iNgDtPEbwvFUSv839c/SHqBbofcudkik4K1oP2C7cFHH+T24pI+V++nNo2g+pEpA6kR+jIdZGMgDZDtxAaZ72kTjSflN494ZYiKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762851266; c=relaxed/simple;
	bh=DhiMOr8uROXptEMu2gl3xMmZcEv5y0qXexHRreDYgDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DN6JYWAxvds7faE9PvW4VaBrXyVx/i+2Y0ZSRgEBx8hO5I/TE6kH7PZYvQgrq9MDdCvHScRoreHLu2CNiMnXfR20zAAZJRtbxwqtwK5JXs2iynYuPj6OtFA52rabSlD9F9szqr6e8MlBPTy6gKPD1fIyJhMOXXAQgzcUM0ct408=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9F3F2227A87; Tue, 11 Nov 2025 09:54:20 +0100 (CET)
Date: Tue, 11 Nov 2025 09:54:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/18] xfs: reduce ilock roundtrips in
 xfs_qm_vop_dqalloc
Message-ID: <20251111085420.GA11611@lst.de>
References: <20251110132335.409466-1-hch@lst.de> <20251110132335.409466-19-hch@lst.de> <20251110181930.GW196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251110181930.GW196370@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 10, 2025 at 10:19:30AM -0800, Darrick J. Wong wrote:
> Zooming out a bit: As far as taking the ILOCK is concerned -- I think we
> still need to do that to prevent [ugp]id changes to the inode while
> we're doing a potentially expensive ondisk dquot allocation, right?

That's my assumption, and it was how things historically worked.  That
being said Linux calls all VFЅ operations that could change them under
i_rwsem aka the IOLOCK, so maybe we don't even need it at all, but that
would require a more indepth audit.

