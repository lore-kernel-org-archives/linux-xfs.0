Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE366132464;
	Wed, 18 Sep 2024 05:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726636235; cv=none; b=H6YlA5hvmQCB/aNK9PDObiCXLKCusnVs7YfpZJpdfFPiLEO8wkQXbyRzadBvF0UTlTYOOxjIdY8hv41/YUmRmyoMGYstuiNE2T+KGhFtZIl7GlA15K9upDQStZReoMGMh2GL1/FLXqMsxGnJ7aVNu1Na0vRguC/nqVZZK+WtbAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726636235; c=relaxed/simple;
	bh=3+i2RU/w7E/NnDp7wxgsoX86Nspr0/bbCqtUQuJauag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qJ89OQhEYAJZp481iJ2/GK3xXJ0h6ALczKnaFZguMPLje3nn6nylpt4zYzCmc/9NE0mgnUGNUk5VtuIf9rxnfjI6SepHA7pNGTkYDxYtVhy5V0xJez7+FLoQVBhxu+Bj+LcH9Reu/UI1bHVao+pcPeP/3UG5EsFR+95ObHFBaAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D3C47227A88; Wed, 18 Sep 2024 07:10:29 +0200 (CEST)
Date: Wed, 18 Sep 2024 07:10:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: take XFS_MMAPLOCK_EXCL
 xfs_file_write_zero_eof
Message-ID: <20240918051029.GB31238@lst.de>
References: <20240910043949.3481298-1-hch@lst.de> <20240910043949.3481298-8-hch@lst.de> <20240917212427.GD182177@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917212427.GD182177@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 17, 2024 at 02:24:27PM -0700, Darrick J. Wong wrote:
> Ah, ok, so we're taking the invalidate_lock so that we can't have page
> faults that might add folios (or dirty existing ones) in the mapping.
> We're the only ones who can access the page cache, and we're doing that
> so that we can zero the folios between the old EOF and the start of the
> write region.
> 
> Is that right?  Then

Yes.

We might eventually also relax this a bit to only take the look if
we actually zero anything, but for that we need to do the work to
turn the iomap iterators inside out first.
