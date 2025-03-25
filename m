Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9131078F4C
	for <linux-xfs@vger.kernel.org>; Tue, 25 Mar 2025 00:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742864079; cv=none; b=d+grJJtmZ9KfSQll68wqai6JxYhdfdGmFlWre/GByv/Y1XW65UVrYgMvERRvYu564WmmT0iBVStE/Anj0QG1e05GSSfLBZUEGkhggV0GwaqMI/g3Q5eZ1VOp7gFS2I15nJaouqvfpvsWxOcoW/HIJL/jGj1zs1qRnow/n+D1R70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742864079; c=relaxed/simple;
	bh=5zhMoyoEsU9e9lgjRimOd87KupMDh/WDlDJwQQGiWKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=atYJlkCkIRhI8aeZGKbqTCdtYeRBl/BNF0XhvOOxlRcYqi9tmKEQIR6+fYHsjMnalNjrPQ4dgvXg0JNnQXNIueDufRvG7MwiatVNLN1LBrNbwyi6TP8jE4Iif5/tRb1S6Scqsw01MStPqlbW0OPeVMJMP1CsIz1fxOW0YjxGhsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G/uDuvqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G/uDuvqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66831C4CEDD;
	Tue, 25 Mar 2025 00:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742864079;
	bh=5zhMoyoEsU9e9lgjRimOd87KupMDh/WDlDJwQQGiWKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G/uDuvqY9ZcKdA89i8k0ABjrDW5BkvGC+b0VNROA4/TmShcmlFh/u89NjyZ9bB3ig
	 WnYO+Ril4+8TiQQtG1TBKD8OOz228+2XyfPIlPUJO9N69rbUBJzo5NQU4JbXEumswd
	 FJaQpfk109rWKlxIBwJcUOWW5J8DjgQvrBHWUmN/+oLyBew+7qCXdW3YakyqXz6b1O
	 W/7XgeNVBImxgLSIGpcV5XHd3YxKpAkQPZPM7gwGG0q0sHs7xP92G0CY+Wln/dqaBi
	 X8BrjeeDotfFiM67LzwN/3IGXJV6JTFpp8SaC8RBM9jJdD6sHwVt/ElhmE+nkPdXcZ
	 kszuEOMy+GCZg==
Date: Mon, 24 Mar 2025 17:54:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/4] xfs_repair: don't recreate /quota metadir if there
 are no quota inodes
Message-ID: <20250325005438.GS2803749@frogsfrogsfrogs>
References: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
 <174257453614.474645.7529877430708333135.stgit@frogsfrogsfrogs>
 <Z9-rRv7jZrcHCBcX@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9-rRv7jZrcHCBcX@infradead.org>

On Sat, Mar 22, 2025 at 11:33:42PM -0700, Christoph Hellwig wrote:
> On Fri, Mar 21, 2025 at 09:31:31AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If repair does not discover even a single quota file, then don't have it
> > try to create a /quota metadir to hold them.  This avoids pointless
> > repair failures on quota-less filesystems that are nearly full.
> > 
> > Found via generic/558 on a zoned=1 filesystem.
> 
> Interesting, I never saw that fail.  Any interesting options you had
> to inject for that?

No, just use a pathetically small device to try to pound on ENOSPC
harder. ;)

--D

> The patch itself looks fine, though:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 
