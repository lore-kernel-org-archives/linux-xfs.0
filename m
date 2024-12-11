Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DF833993
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 03:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733889096; cv=none; b=VctDPMaYiGX7XBg0VqK9PC/2w7UjKJBBSj+YVNZTUkVjWeFMsvXBilDb2W1zXI9b/M4eFborDkkbw86Wrl4V1BP42yqAGqK9zOPM9Emjt7Ip395TOeToi249r7/ighryQ4i66BEAQNokUjoV2BdlU4m/dsvTp1dJxINu0z0VWE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733889096; c=relaxed/simple;
	bh=U51ZcbIatsKPn7fzKzqn6FYTqFnQtrM2CIREfnNzg3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hI7ljNZpqRzDqQTIeyiQhw/yR9mh+icaI2qAH8HcVjoJ7YJGwN+QQ0ZVIyQg+E+yRrB/ezEAm0/Y2sSPorPE4oDhgta3rRwb8EqfpjQmSjY4mmrNPWeQKB9a0kdSVCJPm/9Gp7BkiFN+cXsvWy0V+5pANBTDegKSkm7m9kfnBk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o/SbB0tC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o/SbB0tC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sTH1nQA6O17C7tgxfaTCGnfhBxraAeR3yE+Q0dGV7p0=; b=o/SbB0tC8Tlw7WtLAD7pYofAnP
	32luwN9eJ017h6O1XDt7CMbvmFQGfYYEfUPB//WIuHIpUcYvsHHS07xRf/jfue3MUdo+AwHKJOWvA
	Y18c5bS67vJzqc7Fo0Zxow7/LQgO5UB/GGn0HGHbkIJbqd6Ay+0S4EpdfWq2wwm2yOvQdph/sSvnT
	nrJUyvi3dtmle/1ZbCNUr97PFSq/6+c4U9TmAU2ezZUhOOlKHTzSSg4yl6av1J9WLOmGJYxLmG1IL
	vlW2hxVLX9SjSVUcEMR/ET6bG+K1axYQp0d1xBiwTZbevaaBh1isUz/g/9k7d1POaWBeI53hrgS9H
	dEnASrrQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLDl6-0000000Dhj0-25tY;
	Wed, 11 Dec 2024 03:51:32 +0000
Date: Tue, 10 Dec 2024 19:51:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/21] xfs: create incore realtime group structures
Message-ID: <Z1kMRAzsOla3QhNR@infradead.org>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
 <173084396972.1871025.1072909621633581351.stgit@frogsfrogsfrogs>
 <Z1g0MxNmVKpFgXsU@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1g0MxNmVKpFgXsU@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 10, 2024 at 07:29:39AM -0500, Brian Foster wrote:
> This patch appears to cause a regression with CONFIG_XFS_RT disabled. On
> generic/034 or generic/039, I see a mount failure and hang with the
> following in dmesg:
> 
> [  522.627881] XFS (dm-2): Mounting V5 Filesystem c984a654-8653-430a-9042-b59f26132eb6
> [  522.676496] XFS (dm-2): Starting recovery (logdev: internal)
> [  522.693551] XFS (dm-2): log mount/recovery failed: error -95
> [  522.701508] XFS (dm-2): log mount failed
> 
> It seems to be related to the xfs_update_last_rtgroup_size() definition
> above in that the issue goes away if I replace the error code with zero,
> but I've not looked further into it than that. I'm also not clear on if
> the hang behavior is related or just a separate, latent issue triggered
> by the injected error.

So without CONFIG_XFS_RT we obviously should not update rgcounts,
but should also fail the mount earlier if there are RGs.  Turns out
that non-rtg file systems have a fake RTG if they have a rt subvolume,
and the count is always set to 1.  So yes, this should just return 0
and your fix is correct.

