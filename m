Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6971922FD;
	Fri, 25 Sep 2026 05:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790315841; cv=none; b=I3dof9zj9J0LhkrZcF4phBYhcxnanrmiuRkuAVO748B8xGClZtHSro8loNHcRThI6YjWB5cVPGGIvvQ6K4TQSavflfsJpLmyCSLnYjVGD4C7A3YKdQ00+XpQHGPjP0/t73TrNR4A23SOwhW1yNx/nyswVd2U8XfUw60/Ae8O7/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790315841; c=relaxed/simple;
	bh=hKoo35eNQJHxl1J/UtxnYXGTQsVfXt+QXnHefzgnF3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rt/LPWBy2lQ91gBxwpgsdGuOTjNnfPUbMz1JyBs+scrigo5WYnbIi28v6dG5qNXmMKNDy5U4nP/v2lPRAPM+8Q/Oio3j7s9aVOiW+NhGNnw7n/EGcvn7XIXa+dpHg3B7MHqSMDp2pmCXAukexjTPchpgQZHMZGeI6dkOX5yZjy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8F6A668BFE; Fri, 25 Sep 2026 07:57:16 +0200 (CEST)
Date: Fri, 25 Sep 2026 07:57:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/21] xfs: introduce XFS_BLI_PREALLOC
Message-ID: <20260925055716.GC3193@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-6-hch@lst.de> <20260924214939.GG2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924214939.GG2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 24, 2026 at 02:49:39PM -0700, Darrick J. Wong wrote:
> > +	 * pace.  Note that the nvecs calaculation is kept from the regular
> 
> 	                              calculation
> 
> > +	 * look as the buffer item formatting expects it.
> 
> "...is kept from the regular look as the buffer item formatting expects
> it" ?
> 
> I don't understand that.  Is the nvecs calculation kept as the buffer
> item formatting code expects it, even though we're allocating more
> shadow buffer space?

Yes.  nvecs always need to be correct for the actual formatting at any
given time.  The allocation is the worst case one, and will be underused
until we fill the log item (and even then be very slightly underused,
as it'll only used a single region then).
