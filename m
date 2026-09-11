Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC47415F27;
	Fri, 11 Sep 2026 07:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111016; cv=none; b=MNa5TDHmx8u9i9DQPhoRMhpeOQV65eYVTY5Ts7p0wjxrusPP95IfwLZjxZ45QLTwcZZJE+iXIn1ZH3R/aNRO4YgXfGFo0aU/jBoqGii2P3waLx9BXlhXoCr1/5uz4z4c/jlWH76Azl0ax8g/37J3mVha4wlpFTtiIumqqYqSTxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111016; c=relaxed/simple;
	bh=6W23qz3z5Skhm0bskRjWatTtZm+w5RdaaSxYaxhHB3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lr1QzZY2nVFN0tUNPDmTttS1DG4/ceh4depg/Cj29y1RiyLRr30ubYYOR7aXEEYvw+jBhCgRkI/X+T1fuZxcv0r7gGrsEkCfaE79sPY5/dCvf8Grwx3DhLresjjXcC5z/yO/oFwxUW3o3tc4hQS5Eg1d08TKTn6kCG3aTarj9Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3658668D05; Fri, 11 Sep 2026 09:16:42 +0200 (CEST)
Date: Fri, 11 Sep 2026 09:16:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: only flag zero padding for dir3 data blocks,
 not dir3 block blocks
Message-ID: <20260911071641.GE16914@lst.de>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs> <178910162126.174887.2134061998195559640.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178910162126.174887.2134061998195559640.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 10, 2026 at 10:54:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that xchk_directory_data_bestfree can be passed a
> directory block that is either in "block" or "data" format, but the
> check here unconditionally treats the dir3_block and dir3_data blocks as
> if they have the same header format (they don't).  Consequently, we can
> incorrectly set the preen state on dir3_block blocks, which of course
> we can't preen away because dir3_block blocks do not have a padding
> field.  Fix this.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

