Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D791A9B59
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 07:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736407039; cv=none; b=aTAlhGE0nKJku+7ZVkgs+bYGN6FdfSPBlZh/DfjH4r5M9NrFbPz27bbZovOyN+smEKY44DB2Ai4mVUAtpPlelIGuqdx9gYryBHXsfhnPNc0xlsD/bkRgqcUNGdBiwGHFs/gGtX60dv6vKLOWheeOd4C4TL/Xo7i2DqCduZ061dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736407039; c=relaxed/simple;
	bh=N2Zaa+mZTW7mPJAijpsCQjBWqCIuqKvt5nHaS3kvBFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oi2lWnfxJ2D0xLTQPX2knr1V5r/9KMnIQ6fwN120WZhVyDZw2KG0RajrSPzKabNfWOLbSivL5Bsx/EQGm32mIami0DXMjVerXnE8MtiGAbeAsRuYKJFvzu3Gm6RemPBnTfIWiZb3tAHSvmuZO6mW9+5V3PV2TQlkXQnjEJszlXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dMpVF2C3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMpVF2C3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1F1C4CED2;
	Thu,  9 Jan 2025 07:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736407039;
	bh=N2Zaa+mZTW7mPJAijpsCQjBWqCIuqKvt5nHaS3kvBFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dMpVF2C3Qm3VKqGy1lSDUlBf1w87Zf59SHTXt/yoCGdZo/1H0SMoNaAvUlm/Z4BMK
	 Ap9R6k8p0V5O7Mi9barhG8xa4TdZu0zLZDrsl3g63Lsor/zody4Zy9t2wY+DGd7d31
	 KRYjpqVSfwtcKYBbeNKiWBrXuoPgVi10of6Zu9YHgM348GiLv9E4gXyBubzIZSLy1p
	 B/mnapbU/4i7/r/mV68iE/maNn4oGsJRQHrRvVdCVKy+WjYdNP74IqExN9d1rH8wpN
	 YGqVmwzxTTUpxq6M/kwWqAbYT/+lkMwMVDS346cRmv3g9QXeedO3sDWEMntVccddNV
	 ygEicH6UW/0lQ==
Date: Wed, 8 Jan 2025 23:17:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: lock dquot buffer before detaching dquot from
 b_li_list
Message-ID: <20250109071718.GO1306365@frogsfrogsfrogs>
References: <20250109005402.GH1387004@frogsfrogsfrogs>
 <Z39nxRk8AdTR3BCR@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z39nxRk8AdTR3BCR@infradead.org>

On Wed, Jan 08, 2025 at 10:08:05PM -0800, Christoph Hellwig wrote:
> On Wed, Jan 08, 2025 at 04:54:02PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > We have to lock the buffer before we can delete the dquot log item from
> > the buffer's log item list.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I did look a bit over how the inode items handles the equivalent
> functionality, and AFAICS there is no direct one.  xfs_qm_dquot_isolate
> is for shrinking the dquot LRU, which is handled through the VFS
> for inodes.  xfs_qm_dqpurge tries to write back dirty dquots, which
> I thought is dead code as all dirty dquots should have log
> items and thus be handled through the log and AIL, but it seems like
> xfs_qm_quotacheck_dqadjust dirties dquots without logging them.
> So we'll need that for now, but I wonder if we should convert this
> last bit of meatada to also go through our normal log mechanism
> eventually?

What if we replace it with the one in scrub/repair_quotacheck.c? :)

--D
