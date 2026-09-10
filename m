Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E4435CB76;
	Thu, 10 Sep 2026 09:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033439; cv=none; b=TTu34Hp3Qkp/Gic48bxwpTdnTpMGdNlcdQl6A0Z5mBLeYnqnnmW6QhcGk2McWtr1+pX/jRXVS0Ru4xtwxMs5gfuY8klfV7AWaSSymaFAJjrlC2UFdHvzISQpnhAzwtD6qztC5IR9BBEBcFLXjXnVYuBWD4DyvA7zUui+cOrUAOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033439; c=relaxed/simple;
	bh=Snbvov7Inl4drrHup9GpVl217rfyAYmRpqiUomhQSnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JR1zKrCZpEbIcKIS8oXTZGGGYIAtogIgKreOKQ0p7c+MdD9YvDodcvMBDPs6Ufr9hz9I8UhTyNKDGgIpTToJj7kHGmtNhSgQ8qnwAOCUPeIHYNfbG5lrHKe7HMmHrOAdzYW77pyMdTLoVT9DqAY7ASTmquG92tjS/cOHRJCLsn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D72DF68BEB; Thu, 10 Sep 2026 11:43:45 +0200 (CEST)
Date: Thu, 10 Sep 2026 11:43:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	dgc@kernel.org, floss@jetm.me, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: fix under-reservation of blocks when
 repairing sf directories
Message-ID: <20260910094344.GA5330@lst.de>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs> <178892936640.4057962.1916451282677820756.stgit@frogsfrogsfrogs> <20260910050031.GB26687@lst.de> <aqJANTuQQMEIqcmO@andromeda.toxiclabs.cc> <20260910060907.GC6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910060907.GC6253@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 09, 2026 at 11:09:07PM -0700, Darrick J. Wong wrote:
> I prefer not to leave a logic bomb in the scrub code in case we ever
> have multi-fsblock attr blocks.

There's plenty of logic bombs to unwind in that case :)

Best if we want to prepare for that would be to use xfs_dabuf_nfsb
and make sure we use a helper like that everywhere.

