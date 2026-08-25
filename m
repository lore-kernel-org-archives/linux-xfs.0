Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC68138332F;
	Tue, 25 Aug 2026 06:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787640402; cv=none; b=MPyHjeSDy1STvWOo47cBZqlugXnp/2E3DzMdsuCKMx+Zgkf9C2FuTklNQiKYcJTS690yuSl9FOVtOHv2YT8TbPlu1e9YGw2ssRvg2xxP4pVsVa3vde6VRCIwDIsSkZLR7O0FwdmXKuYhNIQuoRJKBWnvjUuOsqCfOx7/7K6eKAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787640402; c=relaxed/simple;
	bh=xxnf1umLg3VbfDMDE8knNUJMUfAX94aP6onqBC0rL90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rn7krbYvlnx/LKFmEjqbByaFf/jDqQSpRQNPfOx+N/pu8b77iljSbmluvoZ2ASuxe9M/O2z6D77UF3SS/zsYtcZ46GsmjMHouodgYeBzaY2c7TkAa3h4okXrnm8QEcTuqdqcoAIJNd45GyQPoU93EOtXLrw5lyV2LGmcEWqDWmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 72E1068BFE; Tue, 25 Aug 2026 08:46:37 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:46:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: report nonexistent parents as a filesystem
 corruption
Message-ID: <20260825064637.GD24532@lst.de>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs> <178760941165.944364.4932010221437452578.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178760941165.944364.4932010221437452578.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 24, 2026 at 10:36:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that when the directory tree scrubber tries to walk up a
> parent pointer but the parent inumber doesn't point to an allocated
> inode, we allow the EINVAL/ENOENT error code to bubble up to userspace.
> That's not right, we should be reporting that as a cross-referencing
> error so that someone runs the parent pointer checker.

Test case?

Either way, the fix does looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

