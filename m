Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DFA63B
	for <linux-xfs@vger.kernel.org>; Fri, 15 Mar 2024 00:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710460978; cv=none; b=KjsFK5LFqmNXtCxoKXkIYe3Fg9DLEWqXSCPF00gj8vL2HCQrTRgIgCZdfNHpI/q+90rzFDQ/Wv7CQ3DtVE1QbZp15vFTzKQGZd7A5w1Vn8yrd2honMZeRMxnDNtY/cz0m8ihW7hWvG9eV2scxXh8KfWTQzhUqxiwQ6Oin2jX6SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710460978; c=relaxed/simple;
	bh=4oQqEzsQ/2OwUGa7gCJyUDCF3rSrlzZ1g+oD13hx7UA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jZHiH3UmXMi5DfHiojvdZTO3utyXPxtECcNZbtesDgN/GK9kopvfaOl8dypIH5jd1AJE285x6mpCEmzRQf0wTwjhvXm2LpW/NCX/DVaMKncN2Jn96M8RZaXNKlkJLwfhGEhAqRC8oJtdVsg8SOOJaFAVj37A+fXWXp1G6Durr/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rn2QLiZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rn2QLiZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723F8C433F1;
	Fri, 15 Mar 2024 00:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710460977;
	bh=4oQqEzsQ/2OwUGa7gCJyUDCF3rSrlzZ1g+oD13hx7UA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rn2QLiZ5eGQoo9sWVwZ9qgNP3COEfRpOd9UV/ZHAH8aFsr2xRQf6swgiKnicYnaOS
	 JXjDcQJ2TO3Y2VjK03qOVh1WZ0GACFE6ryWpgQBKMdhaNc/gqm7TyaPrljNV32vJZV
	 UvD55ZAvKsmallIKVWqyCrmdoB0fquxoCWkUAH2SPA3SnypqdWnrx96GV/0l9NZF9V
	 WwNdZmisOwrE9li/srBwUJDzrTmMnd4gvf12JBSt94hOQ8bQeCnn4JetuSe3RofKz+
	 GyEVdbh7NHkendmBekgypuGScePLnWMTZ2RppWU2lzPGqQEEXW+dcbOUiuWyCqTUs+
	 lgqniY3xo1jeA==
Date: Thu, 14 Mar 2024 17:02:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs_repair: don't create block maps for data files
Message-ID: <20240315000256.GW1927156@frogsfrogsfrogs>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434829.2065824.5706231368777334384.stgit@frogsfrogsfrogs>
 <ZfJbZp0MO9cidwEX@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfJbZp0MO9cidwEX@infradead.org>

On Wed, Mar 13, 2024 at 07:05:26PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 12, 2024 at 07:16:29PM -0700, Darrick J. Wong wrote:
> > -
> > -	if (dino->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
> > +	if (dino->di_format != XFS_DINODE_FMT_LOCAL &&
> > +	    (type != XR_INO_RTDATA && type != XR_INO_DATA))
> 
> Maybe throw a comment in here?  Or even add a little helper with the
> comment?

	/*
	 * Repair doesn't care about the block maps for regular file data
	 * because it never tries to read data blocks.  Only spend time on
	 * constructing a block map for directories, quota files, symlinks,
	 * and realtime space metadata.
	 */
	if (dino->di_format != XFS_DINODE_FMT_LOCAL &&
	    (type != XR_INO_RTDATA && type != XR_INO_DATA))
		*dblkmap = blkmap_alloc(*nextents, XFS_DATA_FORK);

I'll change the commit message too.

--D

> The logic change itself looks fine.
> 
