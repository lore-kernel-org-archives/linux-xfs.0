Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9F133991
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 07:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737530310; cv=none; b=A8pH2ZFa/G6YTRSy6ITK+UomUKslAKeAEK9ZDr+QIW164sklhFbE9KG9uQysvj9nqwk1y83AQoJe2GJRlBRoSoLbAmiIlv1v9UnjTI2vpfXVhShI+L/RZmg13k6g2kURwivWP6AnAJpwgvRfK0CeF0E619u6gf0puxY2H5G80Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737530310; c=relaxed/simple;
	bh=OuZoVHYQHT4HyWDwIuE6qjJfqlD7rURqAyzljBccYCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mLTJ79zPEeWEUZUXcoQgR5RpvncfQrki3pBVy9yTzr9RxxHQ2vqYKhxOc/DUeTtPemKZaMXsNhEZ9FAnlRfyuKCmxxuEp+R8FXadjI/JH7DZhHDyrr7dX174PAMN46a5IFhx5Qh61uETBJdFSqT/9+c3zCPZAadrhdlHHAW0NfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=txoYsVGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="txoYsVGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CD2C4CED6;
	Wed, 22 Jan 2025 07:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737530310;
	bh=OuZoVHYQHT4HyWDwIuE6qjJfqlD7rURqAyzljBccYCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=txoYsVGSkn1fahK4IytPzs4mXYwLyqh12ROamBv1HuD7Dyzq7Aqx8uJskxK/qLmrI
	 zqlRSmkCosL+GtyQNoKIDGr+OTLtOXOihNcNqZytPT0rp6Yb+qcH3qMjVx4hEhdhsB
	 /3/dktapuQCULvnzB/ZMLew3wv6Ala4xu5kb+6DaWvYy+yH1iUyy3AmFRYjqSc44Hn
	 ehq4PSskSfO3ShvSsexJBHNMwI89+AQ8Bygtc+Hqa2ghY+PV4JOkK8rF/9xQUZEMxB
	 GH7CrkupzqrxZKyXhucF7hEJ3b5PpZHu9UQzD6olqUDPdppjNHfSM5Psd+YcYbK13m
	 szEEFszPQZnBw==
Date: Tue, 21 Jan 2025 23:18:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub_all.timer: don't run if /var/lib/xfsprogs is
 readonly
Message-ID: <20250122071829.GW3557553@frogsfrogsfrogs>
References: <20250122020025.GL1611770@frogsfrogsfrogs>
 <20250122060230.GA30481@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122060230.GA30481@lst.de>

On Wed, Jan 22, 2025 at 07:02:30AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 21, 2025 at 06:00:25PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The xfs_scrub_all program wants to write a state file into the package
> > state dir to keep track of how recently it performed a media scan.
> > Don't allow the systemd timer to run if that path isn't writable.
> 
> Why would the path not be writable?  Do we need a different place for
> it that is guaranteed to be writable even for setups they try to keep
> much of the system read-only?

Eh, it's mostly to shut up systems where even /var/lib is readonly.
IIRC systemd's volatile mode isn't quite that silly, but it'd be nice
to avoid xfs_scrub_all repeatedly failing every time the timer fires.

OTOH maybe a better solution is just to run scrub in media scan mode if
the media scan stamp file can't be opened for writing?

--D
