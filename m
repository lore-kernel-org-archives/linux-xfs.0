Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31431EF08D;
	Fri, 21 Mar 2025 21:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592312; cv=none; b=JQ+aPWX66xldzdvRrOveNZdUjT3G4ybHIdkCJtWijC42GRvU0mDYyvLFMVnkLWlJ2cupTKpxo0beBBEhYs/+VoSrWr4s54UsTzWaWP4A/CEgSyOUusTiiTEgGXa6L6P40bM/gp8+sZtex38s/QgxkrwJJH+x36vhjaBnmLf5cDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592312; c=relaxed/simple;
	bh=jkDkw9SG1/PEUHKows908ElsXDxiOV084c6bNZLfMEU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cS59b6UILAFq0IsDtMSv41YVT6YHZujNTinNhdLC747VY/eZapq87jys59MOT2GikifXvWiz7+JSV3cXAerYm/KryB/cHPow96x4+oFt8I48tTtPRPGx5sMwF7/8H1a3m1SUSh/wyiBVFXiMGUb4Owg8OC53hmpW+jgjF1QUlcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kG6YAER+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kG6YAER+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCEFC4CEE3;
	Fri, 21 Mar 2025 21:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742592309;
	bh=jkDkw9SG1/PEUHKows908ElsXDxiOV084c6bNZLfMEU=;
	h=Date:From:To:Cc:Subject:From;
	b=kG6YAER+RAHtT771Gigndhldfq5t7DD+vhyX78Be7DAErdNmUoMWCNvKwtQi/KFA6
	 tZmOJ4zkvlJIzQ2T2ykAFinQgGk9M+R2b89zbd6wbT/5dszSyjecsMeVUn1F3Fqt4+
	 RjbRLCbpTfE4kGY1V3ofjCzNuZrrYTZkkg239fTpeKYt0MXQ8Iw5u1HoiFLqoH4gKs
	 ZJKZOBd0pV9xPeA5xzIIFUzk8PnNeyK90qozOcLtxYfyIeM6BTyTbwIb0eC88Um96U
	 VieEct/lE3rSHvuKUNWpLgRfFjT/eFR5LW0w9wl/Cw8kB8xqGdQA9HJgfc4RqvQbMQ
	 cfPftIBXW+WfQ==
Date: Fri, 21 Mar 2025 14:25:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCHBOMB v2] fstests: random fixes and 6.14 stragglers
Message-ID: <20250321212508.GH4001511@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Here's a fairly small series of patches for fstests -- the first two add
functional testing for some new utilities that went into xfsprogs 6.14,
and the last one is all bug fixes.  This time around I'm dropping the
/tmp checks and have added a few more bug fixes.

The following patches have not yet earned their review tags:

[PATCHSET 3/3] fstests: more random fixes for v2025.03.17
  [PATCH 2/4] generic/537: disable quota mount options for pre-metadir
  [PATCH 4/4] xfs/818: fix some design issues

--D
