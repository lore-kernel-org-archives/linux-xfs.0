Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBA23BD635;
	Tue, 25 Aug 2026 06:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787640350; cv=none; b=fUoUUz3pMvlRmJsvoerFI/pNpXN/DTePkCDZTJ+23ura1qFDFtRzIuj67O8ICYAMOWyG8iiNkJFKE/VbVSnFeUC7jmU15SC5AVQ/K8LW9/UuPCfk0xdw+Jc/9f48NO/oZfzd8YFurrRrIClGJJWxhqf47fN6cDVy+t2wpRV6DWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787640350; c=relaxed/simple;
	bh=rXiVelj7EeZ78DvxYNlueuYAnS4CuuWomfWIxysHcC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyXyRMaGE/PZP9kOdtami2TRV2frdWtlIAnlF+fVt+8t5dHs4Vx6041tIjhf5455mE/kvFMSycrCCMdYAIfTm5yvoETlSGYBcW1BEfvDJmrMiysGp5v4GPtnUuBSueaPvgEV2VtxFsdNHo9KcVSzPKWp+k9z1Pmf1oMaFlAk20I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5098968BFE; Tue, 25 Aug 2026 08:45:46 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:45:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: bump lost_prev_errors if we lose even the
 healthmon lost event
Message-ID: <20260825064545.GC24532@lst.de>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs> <178760941144.944364.17236586366229926747.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178760941144.944364.17236586366229926747.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 24, 2026 at 10:36:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM observes that we don't bump xfs_healthmon::lost_prev_event even if
> we can't allocate or queue a LOST event, which means that events can
> disappear silently when things are going very wrong.  Bump the counter
> to avoid this problem.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

