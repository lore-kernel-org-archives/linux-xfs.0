Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7484E29AB1A;
	Mon,  7 Sep 2026 05:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760718; cv=none; b=Ky564kt36l4srHNBRHD+FgeawqqYH1TL4bWf/BrtLMyJkdAioiaHeDkr8DBHKae3VKQ9oYXLLXNl/wkeNgbaBe0No3bPsold0NzrSBRep/7Hs+6CP8u5Qe7gOAboFVmwAkwjieAoXLy/stRM79C/Nf+AjhHZtH6i+p3aISnNspE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760718; c=relaxed/simple;
	bh=44gTVwRAsegoxFkXrw44wN0MffJaj1FEhieMwYDQ1k0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKTczaIv0uytAa5H/Pf79TQVQQm7svkoBJ7vERnzgsupE5xSd4+h6aqmYQoinS4yNxEhI6+YTok8l27B4zHhibL/PP6jMZjsLjAB3CKyySgzY16ep5/PTb3iiOlDpRvHVHUZkUu/tyrTtifApY0aX3VIC1+ZE+SNHTx7ULpYXhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9B05E68D07; Mon,  7 Sep 2026 07:58:33 +0200 (CEST)
Date: Mon, 7 Sep 2026 07:58:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: snapshot scrub stats when rendering them
Message-ID: <20260907055833.GA31753@lst.de>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs> <178850312518.1198660.12930219318866018921.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178850312518.1198660.12930219318866018921.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 03, 2026 at 11:26:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains about concurrency problems in the scrub stats code
> because xchk_stats_format doesn't synchronize in any way with updates.
> These stats are only reported through debugfs so I don't think it really
> matters, but I guess I exist to make bots happy now.

What concurrency problem?  There should be no need to have an exact
snapshot of all counters, so it's really READ_ONCE/WRITE_ONCE that
are needed here I think?

Either way maybe add a comment explaining the snapshotting if we want
to stick to it?
