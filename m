Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8141B298CA3
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 15:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422433; cv=none; b=Jv6elmumqK4CK8uRxDYOIO1eMpf1LwQLWVRgZRpNPznvMsvqm+yEDjXed5XW32KO+7vrjJeHWJBWu3FZQUcpro3ZGr2tq3aaKYlI8H8JnjZWLinoDTciAA8sbByHyiaRlijekpiA90VENNFX0mAcHJDvNzY1SAcwD8IoF/rvKUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422433; c=relaxed/simple;
	bh=KD3/TAatWe1jgjdMCnghZWMhjprcJJVzJziprJBjtdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IONqNlFHtte4f9yAuwCgjwOwjQdZ36ezQPSijvhDzgLaIjH6ucXGK86pSFqqSChS5q5eSSiXQ9xeVzQBxta5mzb2nis1paUXhYH7hO1OT/wHsDQ8hQ4b0A0mKjWPx//+ZXJ8OGrmLvWFad/XvHXlI5T81ypJ9sFF1KeDo88XJkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t6bO4Nc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t6bO4Nc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A11CC4CEE8;
	Wed, 23 Apr 2025 15:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745422433;
	bh=KD3/TAatWe1jgjdMCnghZWMhjprcJJVzJziprJBjtdU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t6bO4Nc9NJVj5tbm+7aGj9BLZQT26DQV2BTNvI7SNmFUxtoAS0bBItpwf5X2Nw18T
	 oNFwrWFfXR3PpchFpJA3s8opXbwmLiIKMx2+lbKXOsCm/zrPN1xfHNJRxU1yQeaPsV
	 mRG+ZdFFMxo48zd9La6P48J7K31Z9XM4r3XuL1fYU1hG60huziD3rnPAxqod+cwkFZ
	 nH/j6FId8ysGHFk319J06OqtAH2OwMvBPd/Eo1FOwWKl7fbStNKTqGiRm7QhqjenjP
	 rF+rwY9cADzw9GANlUVoX+P7tr1B2tvG07F3IIk1VTWbtJs57/xGFPkfSfKtPNyJkz
	 7eAzEgmEpdenQ==
Date: Wed, 23 Apr 2025 08:33:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs_io: make statx mask parsing more generally useful
Message-ID: <20250423153352.GF25675@frogsfrogsfrogs>
References: <20250416052134.GB25675@frogsfrogsfrogs>
 <20250416052251.GC25675@frogsfrogsfrogs>
 <aAc1UtYb2HL3w5T_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAc1UtYb2HL3w5T_@infradead.org>

On Mon, Apr 21, 2025 at 11:21:06PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 15, 2025 at 10:22:51PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Enhance the statx -m parsing to be more useful:
> 
> Btw, -m claims to set STATX_ALL, which the kernel deprecated soon after
> adding it:
> 
>  * This is deprecated, and shall remain the same value in the future. To avoid
>  * confusion please use the equivalent (STATX_BASIC_STATS | STATX_BTIME)
>  * instead.
> 
> do we need to do something about the -m definition in xfs_io because
> all fields aren't included in STATX_ALL?

Hrm.  Nothing in fstests uses it AFAICT so maybe we could just get rid
of the -m option.  Or we could redefine "all" to map to ~1U so it
actually does what that word means?

--D
