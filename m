Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE2225CC45;
	Mon,  5 May 2025 14:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746457040; cv=none; b=Zp6toI5v3PGwUbsjYO1k9bNcXzMK0ORPuf19M1CF9k9mtRjl5q6qvi8kB6uXSafgASMO5VEUrjvu3CoszjTWfaZk9apErgmpvNRJ1FcWafZygSWJIz+8RgOWm3Jt0/mKD24lAnJ2tcMlLUX4hyQZ4Q1EEy+cXe4tWYIGWMDJAI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746457040; c=relaxed/simple;
	bh=YXBLGFfCSiNERP2l1252Bbo0ChipWii3oYahuv6UgPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rCkzAq9GW4baaSABq5sW7uTi/N7Yxv44UCY8UVLSo7atTlsiSjKNTdYHYeAhDKIlGMyXVHc21tyRdAHuyrqgHOLHCu5gaIQ1ktbAie1hgEGU1SeSFvtWejVlRhlwytz1d6BMpEQL+e5uVh0JvpEeOhtOKzw17vU5/uyqbIJBrLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JtFi3GOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JtFi3GOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A901EC4CEF5;
	Mon,  5 May 2025 14:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746457039;
	bh=YXBLGFfCSiNERP2l1252Bbo0ChipWii3oYahuv6UgPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JtFi3GOYrH9nID2fxqmQJ+ntSD0GsUSivANnY/Zb6ZyHy+PYAQdMO3iSo/ltbEfzb
	 qGWCVLZK/6y2TAfZmJYHuBd3/ZusBqvMXPJIqOrJVjUQwkPhaoORldgdhuXap7B4bV
	 3ORdDdVcC2dKLfcouK+oH2uQhUD9/T3vrZOZBsiu2+wDUkT0HtRxfC/vSeGGyYekD+
	 YStS4KlSDbxpa2BANmOQFghQj2M5jyaRBbCv+LEF35Wz0M3+GLrYzQfzRY/giA4r2M
	 nwRfDZ9qEJPk5qSc6ojndkZb8eJMEnwemQemXw5iw1UkHd3M277b9Q/T4emOKvjXiN
	 +rbd8qxR5hMbA==
Date: Mon, 5 May 2025 07:57:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v5] generic: add a test for atomic writes
Message-ID: <20250505145719.GY25675@frogsfrogsfrogs>
References: <20250410042317.82487-1-catherine.hoang@oracle.com>
 <aBRwTFxik14x-hyX@infradead.org>
 <20250502193942.GP25675@frogsfrogsfrogs>
 <aBhOg_jB4DWSz1A4@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBhOg_jB4DWSz1A4@infradead.org>

On Sun, May 04, 2025 at 10:37:07PM -0700, Christoph Hellwig wrote:
> On Fri, May 02, 2025 at 12:39:42PM -0700, Darrick J. Wong wrote:
> > Me neither.  We can't write 512b blocks to the rt device obviously, but
> > I think the whole point of the separate "sector" size is that's the
> > maximum size that the fs knows it can write to the device without
> > tearing.
> 
> The sector size is really the minimum addressable unit.
> 
> > Maybe there's a way out of this: the only metadata on the realtime
> > volume is the rt superblock, whose size is a full fsblock.  Perhaps we
> > could set/validate the block size of the rt dev with the fsblock size
> > instead?
> 
> We still allow subsector dio to the rt device, so this would be a bit
> of a sketchy change.

I don't understand the 'subsector' in this sentence -- we allow
sub-fsblock dio, but not sub-LBA dio, right?

So the only thing we need to validate for the rt device is that
fsblock >= lbasize to avoid confusing the pagecache when it does IO, as
well as user programs that aren't expecting such things.

--D
