Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBB6407CD3;
	Wed,  8 Jul 2026 09:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783502083; cv=none; b=daUtMBxY+qvI+AAzl+kLJzRLMvaJckhdKOlqvbdubRYiJAQKHHT2PBvkczgdIONTn7GoeslzM2TRtnSmOnKpEOizJ6XaxELczoa5h7BVVcDduGuo3fjPh1Dd7rszMIYaaMyeI7E0Ae0G/lHi6g4CKh964ej+05p0a9S0LcADGDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783502083; c=relaxed/simple;
	bh=q1ar3i4FES7I273eU3ZxZhldtX97msB43Y8Q40Kup1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9MeGcCLqk3GRR2ycmXCzcI3bvgXN1368diQXJgYzlLBT/G2Lp3WInYkuJzGJZki5dS6hdWaQ9Vic6/mvKK4iO50yS7V/Xo8HwWmbaJeysd0m9LRaFKfwtzi0q8OGP1IDa/GNzSzASEWksf/JyNaRVPePLnVCevU4kr2pZ21yGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 54DFD68B05; Wed,  8 Jul 2026 11:14:38 +0200 (CEST)
Date: Wed, 8 Jul 2026 11:14:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: don't wrap around quota ids in dqiterate
Message-ID: <20260708091438.GB5902@lst.de>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs> <178346726130.1271589.15159357342663936453.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178346726130.1271589.15159357342663936453.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 07, 2026 at 10:03:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that q_id is an unsigned 32-bit variable.  If it happens
> to be set to XFS_DQ_ID_MAX due to a filesystem that actually has a dquot
> for ID_MAX, then this addition will truncate to zero and the iteration
> starts over.  Fix this by casting to u64.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

