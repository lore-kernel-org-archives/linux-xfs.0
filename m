Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6FB191F64
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 18:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724437223; cv=none; b=B2wT2M6YECWC2BVvzkeQCA8c7t9R6riqGK5Umt52vTd8n1WWnHc5DGz7JfFOtEl3z4dODgGTi4oCtDpgyVDHCA/Uq1nZj5Ubb2QoaMucxM6xRoU9Zah085fP/tPxqeYtytQH/kl8v8zGU02ACCgcnIU9k9HbpccBe1sXSwpmUnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724437223; c=relaxed/simple;
	bh=4wW9xSYYFqcUh3k2xEPQbtzrQhV6p75NGfjM7XaNvRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0sXGwlWUg8RgOYby57AHEEW0vv2L2/wYAlsZKnveAIH0LYTLPUG8R5LOA3A+m62XtYU61npgPBXbKvxGUGaT7xdCqqJRWlngBl7K9frd2Coa3hkq/05Wu7dFSVAh6IlxOug2yOswz2e+d5gpBqm25tg7hNu9K30oC+/nGRjvBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l3sU/Fjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l3sU/Fjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B04AC32786;
	Fri, 23 Aug 2024 18:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724437222;
	bh=4wW9xSYYFqcUh3k2xEPQbtzrQhV6p75NGfjM7XaNvRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l3sU/FjduTxz5z+vUo3fFpCHjanMMSmmYnZi+5yPNUu+UrVTgfGi1g8UpvGjAFfOF
	 qA3+5XpGmQKvEIYhrq9MalqxvthEYM40e1j9gqsBgadnjMUlWed8VtfjhjSXRyr4lE
	 /tS2cPdj/AzdcWqZETuAl98kEmZdjWAf2NA2CqBBHBs/0TMUWxp9wlbvRhkKiZTlR6
	 Un++xW5Y8lWTT4Wzct/AfiEC6bBF157dwMcG+/u3VU7ddE2w9oNztAMHh10Vyu6bK4
	 3n3ZF7zudqOZryRkIzJwwsdOrhtt8FKhxvpDz+lPxvFMjt43yWVHIn68wUztLpMrj+
	 nfeIw7XlBwQjQ==
Date: Fri, 23 Aug 2024 11:20:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: use metadir for quota inodes
Message-ID: <20240823182022.GP865349@frogsfrogsfrogs>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089397.61495.2669421430531282333.stgit@frogsfrogsfrogs>
 <ZsgjvJFjZMHg0Fil@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsgjvJFjZMHg0Fil@infradead.org>

On Thu, Aug 22, 2024 at 10:53:00PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 22, 2024 at 05:28:28PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Store the quota inodes in a metadata directory if metadir is enabled.
> 
> I think this commit log could explain a bit better what this means
> and why it is done.

How about:

"Store the quota inodes in the /quota metadata directory if metadir is
enabled.  This enables us to stop using the sb_[ugp]uotino fields in the
superblock.  From this point on, all metadata files will be children of
the metadata directory tree root."

> Otherwis looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
