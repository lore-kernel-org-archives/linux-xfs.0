Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F4F27874F;
	Thu,  2 Jul 2026 15:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783005781; cv=none; b=BNWbCvmUwuh4rlpNwFWjz7eWMkkzebboUOnrjZJgE/5rdGGpERd1Bix1ShVgYRAvG6kqqR6Rq/Uffjkkisl7sKYsKxgMcmxtswwol6qrD3Qy92OpCj80+Q4oaD6UWerEobFxLwwzSu3v6AA4BbyzeFQE0aM55BsWoORVvYr+kec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783005781; c=relaxed/simple;
	bh=INCac1ZPgwaSqHp+1kxreFrQQFIRuTrt8LiUJ7cB0Pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lwT7tCYwSHyHMjjx3edxNhJYhbNSQ6V/qffdaLKPpxAQj2OB5bInE2sT24ZQ925VhUuIPQS2PBykMUMARK+T1MLa3OHoFFRb4MZ5ptYo6mKKvwqXqn6ztz9w2pAlCeH37eeplOtE20PkqC8wF/nSIsqex4OBrgA2M7r/X7ujrvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0k0R8IK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0k0R8IK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 673681F000E9;
	Thu,  2 Jul 2026 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783005780;
	bh=s+gjcV0Qn1Z8rgIZ2iKJ8UY1dnECyMpl7OC6425VNU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b0k0R8IKo2iisXsZuigOoYgptZ9zE8KOIGhoMTGDIJA+7TMHC7sVIJh++J+/Id6Cv
	 mx2OqPdoPxdy/rmThiXbHp0B8odTmfJuOSEe9wVHBSisPlUIUGCsKMJhLvP+hbR1rz
	 1CDnJ6mksRnJhcnnkBl/DyKMZpfouLbVKksnbfvNBJ2VdjaCVHra60onMiLj3sM474
	 8Fkr02tFAX3nwLzr668JDv4eQgMuOypVeRIf7+u1WNg7xGH56gOOUf+E9qgk0y5N+i
	 WNBZAkdt8znZ4iRSJALF+aAZHtSFKdpELh79Zzg8CRwuH021xP+4n7OkXWGxYrpRYk
	 xCiZ7Pc74OEQA==
Date: Thu, 2 Jul 2026 08:23:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Yao Sang <sangyao@kylinos.cn>
Subject: Re: [PATCH 1/2] xfs/656: rearrange directio pread/pwrite for zoned
 filesystems
Message-ID: <20260702152300.GD9381@frogsfrogsfrogs>
References: <20260702035523.GA9381@frogsfrogsfrogs>
 <20260702103504.GB6816@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702103504.GB6816@lst.de>

On Thu, Jul 02, 2026 at 12:35:04PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 01, 2026 at 08:55:23PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > On zoned filesystems, a write failure shuts down the filesystem, which
> > makes this test fail with:
> 
> Looks good an increases the test coverage.  This also makes half of
> "common: skip data write EIO survival tests on fatal configs" obsolete.
> 
> Darrick, Yao, Zorro:  I think we need to arrange all the tests in
> this area into a coherent series.  Should I do that?

Yes please :)

--D
