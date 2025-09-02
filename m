Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CAA32F743
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 06:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756794515; cv=none; b=faE8PHA4sKcujaJr2J837nyNbtv/Tuvcbm2/YHUQX1RBLx1rwlm1mOlbyk5cRy15B6RdsnN/xwMBKiSptpSLNFEbRK1GNjlR6fGEjLyHS6dlngNmNRTrCGSWg0Hz6VKhylkeJMaRd+vW9P3xhafLwnAxOjqIhawRQqNYGObzWqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756794515; c=relaxed/simple;
	bh=7gUlgkEfP+/JWEugX2CR612m9HozAJmFDg7DLei+SfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qKSx0EiGVsWnxEIjPs06nwglGwQJB7pU+mbKG0T6VDh3JA+M2nHT8kssnd9x23hVfNykyN8yUtE5GNd6702aEjSTGO/2ktWitZqRafclry9HKtaHBRhpWPgYqVBUdqjbWyOU9D2zml8ravMIivceMM72ZLPGvPaiUQgCG7WUWz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C217068AA6; Tue,  2 Sep 2025 08:28:29 +0200 (CEST)
Date: Tue, 2 Sep 2025 08:28:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: remove static reap limits
Message-ID: <20250902062829.GG12229@lst.de>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs> <175639126605.761138.1788578695179861070.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175639126605.761138.1788578695179861070.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 28, 2025 at 07:29:57AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Get rid of two of the static limits, and move the third to the one file
> that uses it.

Removing the two now unused one is obvious, but could still be stated
here to not puzzle the future git log reader.  But why move the third
one?

