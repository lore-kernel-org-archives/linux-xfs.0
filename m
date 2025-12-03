Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E5B2E1EE0
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 10:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764757967; cv=none; b=riCUuYcWL9bbmLORb7YLATGHFLCwVCu4DoTbX894reSO/xF5d5/okAXrdsuJmeG0X7MjT3DT7a5/a+gDHYAKOJ6raEZYtdqJf+FzgRZb+NXjqgm/1yUVDqd9bc+FSNyztRHyPvXEzz1CrxOFAsblrTins8/ZRDX+InzKNcBegH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764757967; c=relaxed/simple;
	bh=CVEugRT8suaMk45pvY4LqCq9zQ28g5I+S+6C8OT4LAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VU52vLaOpO83ueUszRcm/9HX3vzGeABnF5uzPvt3Erp6amZWHFMDRIu2k44tyUzcCtTdjuQrFarq7QfrFNHz4ZvoQ18DLdk+ZD85eXpYBaoh/nGNfVVeemSzPAKTWOHz5ez2v1l5gJRLVbhfBvG7/7MbfUKlycvPcyco1nzKvhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cn3GWikc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cn3GWikc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27125C4CEFB;
	Wed,  3 Dec 2025 10:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764757966;
	bh=CVEugRT8suaMk45pvY4LqCq9zQ28g5I+S+6C8OT4LAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cn3GWikczIE+uKa51i8e/PwJ4qInYLqr1v5xXUjHV+kmyKPUkDjmZgbgqAGIa1+44
	 7wRFsjEX9QIMqFZjsJ4I8gWQ9jNXQuAKgmjSur3K1Shx9Am+LDeQzank35Zuj09Rz5
	 QHqdW+7U18MacLqaoHAm4b4y47PU3+tWsmLdVLSx2fJA4r6siGV/5SlvvU7CyYg/IE
	 wOzkUCqlh9VxySjDvsuWStRrtSiA6dGqczcP+CJ82sjfHjY9dA/fG1VZBVbh0PhN+u
	 j9w6fRE+999lqHZP4XtfuqiTfYrlRz0pYTbq8LPt35mWah/DzsWrNwCztjevop6y11
	 zTZhBMOtQ3dsw==
Date: Wed, 3 Dec 2025 11:32:41 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>, djwong@kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs : Fix potential null pointer dereference in
 xfs_exchmaps_dir_to_sf()
Message-ID: <gl3onv4myfz34h5y7ym7uc7kmrdeyq3b4k74g26a3jt72jk3xt@uu3dpjq7pjoc>
References: <20251125142205.432890-1-chelsyratnawat2001@gmail.com>
 <FjCaOpp6EVRiefsKd7nYq1QLDJ3wzNkrAnbgjluZp3R72GAlb7sNfwEsUN3mH6uifkGw4ROOtk1RUFk38nigGw==@protonmail.internalid>
 <aS_W1IHbi3-vlLOm@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS_W1IHbi3-vlLOm@infradead.org>

On Tue, Dec 02, 2025 at 10:21:08PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 25, 2025 at 06:22:05AM -0800, Chelsy Ratnawat wrote:
> > xfs_dir3_block_read() can return a NULL buffer with no error, but
> > xfs_exchmaps_dir_to_sf() dereferences bp without checking it.
> > Fix this by adding a check for NULL and returning -EFSCORRUPTED if bp is
> > missing, since block-format directories must have a valid data block.
> 
> xfs_dir3_block_read is a thin wrapper around xfs_da_read_buf, which
> like all the buffer functions should not return a NULL buffer unless
> either an error occured, or the caller asked for read-ahead semantics,
> which xfs_dir3_block_read never does.  It seems like it currently
> could when an invalid mapping is passed in (see the invalid_mapping
> case in xfs_dabuf_map).  I think we'd be much better off trying to
> fix these inconsistencies than doctoring around them in the callers.
> 

+1
