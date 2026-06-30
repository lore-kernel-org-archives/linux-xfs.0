Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99723233927
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 05:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782797481; cv=none; b=jGH2CVXWDSH95zIVyIjU9VF/iPcBPY/mA2dU+YJmmzM/xfsdV6rFgP6HXoSstBlr6xgjZZVHlBz329juN8C0UkwQpS/1qxSVgZLlTkB4n0zhsRKuDQ2QAAfAHeoZtOymbuQmMbNXaOep8f4/MMaEmCVUVRd2WXU0K/YY6hlUmwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782797481; c=relaxed/simple;
	bh=7mjXnvSZ2494dje4ZcNB66hp5/8yBi0Z880EpK6jqD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JDtzJMaVVHqnX4Q4sf1VNNv2SgaEZLoSfPfla+HovULs3roLzWWULajiDqW3DCg9LspaK5GSFGHr+jPf/s5T4XtMoEp/rOnZRIqEUtPAorzwGCRbY+ebNJg1iHnnomVNIkNd0IuB++SHUen0hevvKz6gATi9vdDrQCvYQTop+mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2A7B368C4E; Tue, 30 Jun 2026 07:31:17 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:31:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/6] mkfs: don't redefine DIRT for protofiles
Message-ID: <20260630053116.GA21007@lst.de>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs> <178278129825.858323.6960589915672224202.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178278129825.858323.6960589915672224202.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 29, 2026 at 06:02:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex noticed that the mkfs Makefile redefines DIRT to point only to the
> xfs_protofile script.  This overrides the more expansive definition in
> buildrules; we should use LDIRT instead.

Man, we really need to get rid of our horrible build system...

Reviewed-by: Christoph Hellwig <hch@lst.de>

