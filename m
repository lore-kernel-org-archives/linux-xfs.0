Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA12198E91;
	Tue, 18 Mar 2025 05:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742276994; cv=none; b=OMcg/9C1d2XbcTJwLSy49ITn1dALVOB+pxSKRhApUAz6UBi9AN1lofcww0/5nXv+iSukIehK3V2u/vfFz6dsYq6xmLxZyb1MT2Zju7tX3pj+/ZJj2nwnSv0srTIRrgmwa2nbSkJesvgdBE8nLBrE0D6jdUgAChVH7exaoxSbusA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742276994; c=relaxed/simple;
	bh=u3Esmc6Ik/3MOa6jACXAMdbExX1TtlVh7LrWsFzbHtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YsBLvWg7ReDiHTghHhBprhB2j4vl1u+Gm29sv3413kGFjCRTvL96ehBn/l2psl21jHA0V7u6TE21e1PaEFwqGgntTdILPI/mxmAUpEDFSGwaGdvvRq6ieII9ElubMv3oJktHs89GqKD2nJ0oDEBSLcSOTUgc2gTE4j9ArfUx00U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 853F968AA6; Tue, 18 Mar 2025 06:49:49 +0100 (CET)
Date: Tue, 18 Mar 2025 06:49:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 4/3] common/populate: drop fallocate mode 0 requirement
Message-ID: <20250318054949.GA14993@lst.de>
References: <20250312230736.GS2803749@frogsfrogsfrogs> <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs> <20250314175449.GL2803740@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314175449.GL2803740@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 14, 2025 at 10:54:49AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> None of the _scratch_$FSTYP_populate functions use fallocate mode 0 (aka
> preallocation) to run, so drop the _require check.  This enables xfs/349
> and friends to work on always-cow xfs filesystems.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

