Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF94F291E
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734066766; cv=none; b=S2RL2J3JGVJJlKMSOlvTH1IpG8360lhEfXjta3377tmmKrv839dre2H3CKha3dlgL6CzWiCsnle0AUpIw4y1GlQJ7XXLlnw2iBMwowOJnbLEQKE8hhqGVSHb8C4+RhSeUrAr6PM0U/4rOaQHsCb1jek7d1Dypt0p2VZRdwOsf/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734066766; c=relaxed/simple;
	bh=RO3hqw4jvDhBVfOFnwnxZzxnaEJV2LbdMPpBTtPwnoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fY5jOmBIrc1+wIuRQUqnKx0e+5vPDTuuPZ9FWBYgzF53/dtC48U1jBXS8zlzwrj6ZE+OXNGM7X1E7ZROFimAUjK2rLmMvu9z+Y0rJu41i7SNSpeT/8CUBYBiwazNyWhAjgmvVrSG5lZOjpGV10DIlDDSif6yF2X9nhS+MLuuILo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2494C68BEB; Fri, 13 Dec 2024 06:12:42 +0100 (CET)
Date: Fri, 13 Dec 2024 06:12:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/43] xfs: skip always_cow inodes in
 xfs_reflink_trim_around_shared
Message-ID: <20241213051241.GG5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-12-hch@lst.de> <20241212213857.GW6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212213857.GW6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 01:38:57PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:54:36AM +0100, Christoph Hellwig wrote:
> > xfs_reflink_trim_around_shared tries to find shared blocks in the
> > refcount btree.  Always_cow inodes don't have that tree, so don't
> > bother.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Is this a bug fix?

For the existing always_cow code it is a minor optimization.  For
the zoned code that can do COW without the rtreflink code it avoids
triggering a NULL pointer dereference.

