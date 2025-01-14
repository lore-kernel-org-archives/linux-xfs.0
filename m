Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7251ADC6D;
	Tue, 14 Jan 2025 22:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736894885; cv=none; b=L/jU4UKGLQPLNVnfjlTX5Tr7uHjnHu2A5Kb+8jFgIGciY1K2mSnb2RlTptkoXEn3mygcn4VXVoJyZfDjUqzOr3v2OsilvYHzEulbvYN8Duh31doCUzq0oed286dEb5rPQfPEWXWT/ATfyg9M2SAq2arv9beTNhF08nGn0UtbEuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736894885; c=relaxed/simple;
	bh=rcyKz4e7UvhPxk9rVsUK0BFZlTFK/B/vYO0l7mCUEh0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dorZ0dEq2yT5IOkqxuiQfm0CucibANsvSR0yMzxAjqay6R5jXFv8HImp1ol4dHYKISnSbImmUG2/jmKzrcZtu0MpnpUPA9kj+ZPUxEVxrkja+ApATJ82xDpWIKwb35wArR/SJc/L4XdIdmvTC7DcdE7RlVf6/ACVlbDrg8t1KdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kleKP4zO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kleKP4zO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170B8C4CEDD;
	Tue, 14 Jan 2025 22:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736894885;
	bh=rcyKz4e7UvhPxk9rVsUK0BFZlTFK/B/vYO0l7mCUEh0=;
	h=Date:From:To:Cc:Subject:From;
	b=kleKP4zO7aC+EASwHjBfDQRCmQJW6fNjuksCsmtyrjipEBDWMp6QNsXULnqj2HwhS
	 IE2d8+ygrsE6zfrcFfbqldQpnzLiN99YQFgu9ONviGTFFRuoT6Qo3oixmtxz5Lid5K
	 vo7m/0aQ4KSbyvqcyFhtSDtKFfHCXhPO0EZf7jc3yDJDRJRfyhoO8cQjZY8TiqinB2
	 0fSkyRj6lTf6LbcXHX45ipPoU1TUmZ5EDGR7peXKm+80svgUm6SMfR6Jl+7+lujV2J
	 Wzih8gmyM1Gekw1jrG8/ANyrRmAFwqUetYx6Zfb7pGmlIWGbDKjUEiOgmJaFRLHWjH
	 b57bDP1W581aQ==
Date: Tue, 14 Jan 2025 14:48:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>
Cc: xfs-stable <xfs-stable@lists.linux.dev>,
	Amir Goldstein <amir73il@gmail.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Leah Rumancik <lrumancik@google.com>, Theodore Ts'o <tytso@mit.edu>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [ANNOUNCE] new xfs-stable mailing list for LTS work
Message-ID: <20250114224804.GA3530056@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

We've created a new mailing list towards which people and bots can
direct all their mail traffic for any LTS stable backporting work in
progress -- candidate patchsets, ready-to-merge patchsets, bot reports,
and any other discussions that need to happen.  We're doing this outside
of the regular xfs list because not everyone in the upstream community
want to be involved in the LTS work; and this way we don't overwhelm the
xfs patchwork with a hojillion backports.

If you'd like to subscribe, there's a link towards the end of:
https://subspace.kernel.org/lists.linux.dev.html

[yeah, I know the lore archive is busted, let me email helpdesk@...]

--Darrick
