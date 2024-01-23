Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AF25C5FA
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 10:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706005919; cv=none; b=BW7j4xsOdOk8Rf5kdUgew7BFwdc0LtOvKVxwRy5k6j/EuLjlnckPkUO3C7kUVJ7adSVQeLHUS+vhvW/ZJTVU0Y0K8FIHaXeWv8aIkaeSrCaXx7Br1lpSbV2U7N31DYcTFFai8bLzBzjJ7PYWLquNHNT3jD2umctg5TZ43hl2g0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706005919; c=relaxed/simple;
	bh=NepenW3OzO9RZov69/0y8W3aSvgLa88a24NCCeUm7HY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4RgJqh4RkSkP3r9sJyid5cfogW97Ef2Y31gklxNUzVD6tIUKyPWs3TPjZkmjeK7nxKXclDeAlTVf1ew8pmfIfkYtQa3vgS1TAp47pEWCvSQEj58+2WaN+2fT0WwfTN9BR7Xy6SDgZNseBHM/Hu4moO2kW6X+16V1g5K5BlhIFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLUiyPIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLUiyPIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56708C433F1;
	Tue, 23 Jan 2024 10:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706005919;
	bh=NepenW3OzO9RZov69/0y8W3aSvgLa88a24NCCeUm7HY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JLUiyPIQYp0ImAI6E86Uzk5Wo/74D2Vb45zONre/Qj292XS18pRYsl1GeT6JY9Vuq
	 EdDLQS66dORROBLqu5sBrFmJKxnVGoBS/gErGSrXznDZbrIx1NSOUu0ORqwWpRor47
	 ns7lgS5iRtMpv3CwJ6OCUQxz+UBa4SZE4os50173f47yzWsD57BxpGmyHgRh8Eu9mT
	 eGrzVjikxHD+ogP6tfon81l91rzP0aLmSBz9PszdVB8lB8EY6OkhpXhrqUH0VBupbU
	 sgMcy8n+Q1EyZUEHcx308u0aRLVWAvDfDudrEOmUfN0FUcJdCasndiTJtCQ1c+RCL5
	 Q25KDybBgckaw==
Date: Tue, 23 Jan 2024 11:31:55 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 5/6] xfs_scrub_all: fixes for systemd services
Message-ID: <3ey3b55is5bojszfkuum2gn3zndvrbwmyuyx4uvmusm4e46lcc@cvptwyt7ez6y>
References: <VpNs4tPDS4CME1zHeEnJHwITrJtUVtt2VTGY7xVBjKUqbni_FVcO7nWGhEsmuW69gA5Ok1yTGiwroBsTdJYXsA==@protonmail.internalid>
 <170502573560.996574.2504743062956504522.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170502573560.996574.2504743062956504522.stg-ugh@frogsfrogsfrogs>

On Thu, Jan 11, 2024 at 06:17:28PM -0800, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull this branch with changes for xfsprogs for 6.6-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit 3d37d8bf535fd6a8ab241a86433b449152746e6a:
> 
> xfs_scrub_all.cron: move to package data directory (2024-01-11 18:08:47 -0800)
> 
> are available in the Git repository at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scruball-service-fixes-6.6_2024-01-11
> 
> for you to fetch changes up to 1c95c17c8857223d05e8c4516af42c6d41ae579a:
> 
> xfs_scrub_all: fix termination signal handling (2024-01-11 18:08:47 -0800)

Pulled, thanks!

Carlos

> 
> ----------------------------------------------------------------
> xfs_scrub_all: fixes for systemd services [v28.3 5/6]
> 
> This patchset ties up some problems in the xfs_scrub_all program and
> service, which are essential for finding mounted filesystems to scrub
> and creating the background service instances that do the scrub.
> 
> First, we need to fix various errors in pathname escaping, because
> systemd does /not/ like slashes in service names.  Then, teach
> xfs_scrub_all to deal with systemd restarts causing it to think that a
> scrub has finished before the service actually finishes.  Finally,
> implement a signal handler so that SIGINT (console ^C) and SIGTERM
> (systemd stopping the service) shut down the xfs_scrub@ services
> correctly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> ----------------------------------------------------------------
> Darrick J. Wong (4):
> xfs_scrub_all: fix argument passing when invoking xfs_scrub manually
> xfs_scrub_all: survive systemd restarts when waiting for services
> xfs_scrub_all: simplify cleanup of run_killable
> xfs_scrub_all: fix termination signal handling
> 
> scrub/xfs_scrub_all.in | 157 +++++++++++++++++++++++++++++++++++++++----------
> 1 file changed, 125 insertions(+), 32 deletions(-)
> 
