Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B8E370ACD;
	Wed,  2 Sep 2026 07:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333757; cv=none; b=Nw0q/YM8lKE+1GeTdIkxfIrVyPY6wyoSk3RNP1SnEj7F4wUjTGcR8lwtAyszmyBZQQ05EoHeYWWgJ2o2F7E3sw8rID87FbnCl29YZLkT5EJEOnDZ1wYUsywWGTFyaVsHP+7d6W+KARZg21qMw8t+vbtM5mzrk30XhZoCkH45G9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333757; c=relaxed/simple;
	bh=HX24aB5yT3M92Sf5OHiLTMe7I+A2opRwu89OguLkCRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZrmKeP4kudgmoral7+ng92RJ7Wa22Bhcs/QRBKUPgqWH1op16bFqZ29hTrQt1omAClfBtxfeJR3E0hj/fNJOLhrigmY5fr9sJeNFbNwwgq92y5woIG2cpdF6w+1Wvd2Zdrps0e6Gzjaur+eHO3vNqq8L8r4ZgLQoqBwsfjuEYu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 95A2968B05; Wed,  2 Sep 2026 09:22:32 +0200 (CEST)
Date: Wed, 2 Sep 2026 09:22:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: truncate quota file correctly when repairing
 quota file
Message-ID: <20260902072232.GB26173@lst.de>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs> <178832750752.3508131.12269209789139517612.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178832750752.3508131.12269209789139517612.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 01, 2026 at 10:49:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xrep_quota_data_fork screws up the unit handling when
> it computes the offset at which to start truncating the quota file.
> max_dquid_off is the file block offset containing the highest possible
> dquot, and xfs_bunmapi_range takes the starting file block offset.
> Therefore, it makes no sense to multiply max_dquid_off by the blocksize;
> all we need to do is start truncating at the next block.

Aka we never really truncate anything with the current code as the
offset ends up being crazy high...

The fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

