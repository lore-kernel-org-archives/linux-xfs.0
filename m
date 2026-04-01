Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95436361DCA;
	Wed,  1 Apr 2026 23:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775087099; cv=none; b=egEmhIYjtMYr3n3rWHDoxQ1G3r+0GM3MNxxVUjGs+lngj07WSMw9b76LEntn8ciTvh6KaUYHkkuD+rRPuW+zRTbjm5KmRG2p50JVVUjkTjMn2XF5qBcT08cD40Fv5+EqoGcp23I0BHqmj7Kqjtk4N4+vgynEQ4Yb8W9DM7Rtiik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775087099; c=relaxed/simple;
	bh=I3xgUwZ2fScTOSKu5gwFFScGgHMI2afVQxSZDC/mXks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N7sYomhwfp32FXzrOdJf2bFo5ZOYRYyX8sJpUXpndjl3/hwmmnHwe6h/KsfzgaaA/G9IrO5m71zUCOloveene0+6FHkL/O3c3IZNtQOp5eeZ/eG8pMcU2v0pSXY0ooA52uFuOdwQLHh4Tp9/Ezjxfg0jK6bn1EBycbCcXNfSn6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLTTuWYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLTTuWYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DD3C4CEF7;
	Wed,  1 Apr 2026 23:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775087099;
	bh=I3xgUwZ2fScTOSKu5gwFFScGgHMI2afVQxSZDC/mXks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kLTTuWYjGkfeV2FsJ7DX/P+c0a9k/HMpIiBn0q0Ya39n328rSNCwdilnVV8I4EvH/
	 MNl2/Cm7tlfnJbbX6m2CQKX47RpBqz/zbe1U76f/HBCqhsiBTSUrqSdZhKLQQ88nEP
	 GfCnBWR1LjIhUW/RfWd+yNwtwwe6ZL0U76pWLtHfZvGEqpywJHzlu2/Qi/bNEKl9uS
	 NUC7IzAlAMFGGqLjvFOTtULL1lUQ/l6DeOynk4NylDpT4dl6lkuxiC9awuGV6MHIXK
	 8+KtBWeqR4Bpu+iicWHk0h6WgL6gfAS6TMkHzsjhOq3FPPqWzZIzQDTKqklnfF1Xe4
	 vBzLmiZ/NMdGw==
Date: Wed, 1 Apr 2026 16:44:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 05/22] fsverity: hoist pagecache_read from f2fs/ext4
 to fsverity
Message-ID: <20260401234457.GB14247@quark>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-6-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-6-aalbersh@kernel.org>

On Tue, Mar 31, 2026 at 11:28:06PM +0200, Andrey Albershteyn wrote:
> This is the same function to read from pageache. XFS will also need
> this, so move this to core fsverity.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Acked-by: Eric Biggers <ebiggers@kernel.org>

Would be worth mentioning that the ext4 and f2fs copies of this function
had diverged slightly, though.  This patch takes ext4's implementation
of doing it folio-by-folio, which seems like the right choice.

- Eric
