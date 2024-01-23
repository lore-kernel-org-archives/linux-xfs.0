Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6305E38386
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 10:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706005851; cv=none; b=PCNhW73O1bYFAD3UnYx6H26AXMJLSFY8Is6yfUI72y91t3NovtURu/nrkDF7D+fy7GBIb1trr8vjZaS1kijFEevnffgJwZPDJz+oN+FHzlwyHUhS4epL/KisDhA3ooE7vPM6rIHzbap+NLNrMf4cR4HgmXpS3sA5V0PrejN2Who=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706005851; c=relaxed/simple;
	bh=+WHs/EGq7F8XMU9lm3BUGWoimCl+Me7U3RzYGh1Mq/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZ/JaiLEC6d7K7mEMN03CtSXKtecH/hKWyzrz25tzbz1pE06cTzbHVBzD3lXCLg2lbTczBGcVdRSVum+raBG1kNz0mA4WaIfwwuzKoL1dsSdxmn35IjH65lhBmMKKV6QMlW3JL+V+mMRyMkxLx5a5w1ckJ8AJyHHkSKGm3Jq3Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ffp3FJTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ffp3FJTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6633C433C7;
	Tue, 23 Jan 2024 10:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706005850;
	bh=+WHs/EGq7F8XMU9lm3BUGWoimCl+Me7U3RzYGh1Mq/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ffp3FJTzJis5R0aUCXrYnclG5DygTMfI2qUlKIFe5S1GX25hLLpYhmEHackc5j9Sb
	 8u7MgrChvkNY8odvBm6x/G7q6E4fZgP6lDgExE5tmnKRGF+6qFuahJbK92cShU3WWq
	 yGdRuY7m2ThYYV2EolMwXn8xX1EdoCoxJFJk1EErDD33mGLeNtKdfQWFHsCHfv+PK2
	 kdq7wYdJv4RHEN0agQuXtpBkudmpjey9dS4ILFjjvKErhaZZ2sJEfd9MqhtLa5V9qi
	 71aYrmrzJTWZ2knwMcdxQVFfoV+Smb9E2O8zGZYyPg1fKYW9BOpcda6tDGRnF6ed4I
	 F4qjKAt+c97rg==
Date: Tue, 23 Jan 2024 11:30:46 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, neal@gompa.dev
Subject: Re: [GIT PULL 4/6] xfs_scrub: fixes for systemd services
Message-ID: <6y6lo5glm3emr7zsahyjdyzh5cwf7s3ps7vyj3kits7mvudbpm@iq3w7prijo44>
References: <YyATtfVqzg9jTrOOleNbtue2jxrd6bTPSEzNLTxj3aanjCgT1NJpZrCCKfSrfvt7gSNPy9uwLOYTPb0V3GLC_A==@protonmail.internalid>
 <170502573456.996574.9256149259911075241.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170502573456.996574.9256149259911075241.stg-ugh@frogsfrogsfrogs>

On Thu, Jan 11, 2024 at 06:17:12PM -0800, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull this branch with changes for xfsprogs for 6.6-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit 96ac83c88e01ff7f59563ff76a96e555477c8637:
> 
> xfs_scrub: don't report media errors for space with unknowable owner (2024-01-11 18:08:46 -0800)
> 
> are available in the Git repository at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-service-fixes-6.6_2024-01-11
> 
> for you to fetch changes up to 3d37d8bf535fd6a8ab241a86433b449152746e6a:
> 
> xfs_scrub_all.cron: move to package data directory (2024-01-11 18:08:47 -0800)

Pulled, thanks!

Carlos

> 
> ----------------------------------------------------------------
> xfs_scrub: fixes for systemd services [v28.3 4/6]
> 
> This series fixes deficiencies in the systemd services that were created
> to manage background scans.  First, improve the debian packaging so that
> services get installed at package install time.  Next, fix copyright and
> spdx header omissions.
> 
> Finally, fix bugs in the mailer scripts so that scrub failures are
> reported effectively.  Finally, fix xfs_scrub_all to deal with systemd
> restarts causing it to think that a scrub has finished before the
> service actually finishes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> ----------------------------------------------------------------
> Darrick J. Wong (9):
> debian: install scrub services with dh_installsystemd
> xfs_scrub_all: escape service names consistently
> xfs_scrub: fix pathname escaping across all service definitions
> xfs_scrub_fail: fix sendmail detection
> xfs_scrub_fail: return the failure status of the mailer program
> xfs_scrub_fail: add content type header to failure emails
> xfs_scrub_fail: advise recipients not to reply
> xfs_scrub_fail: move executable script to /usr/libexec
> xfs_scrub_all.cron: move to package data directory
> 
> debian/rules                                |  1 +
> include/builddefs.in                        |  2 +-
> scrub/Makefile                              | 26 ++++++++++-----
> scrub/xfs_scrub@.service.in                 |  6 ++--
> scrub/xfs_scrub_all.in                      | 49 ++++++++++++-----------------
> scrub/{xfs_scrub_fail => xfs_scrub_fail.in} | 12 +++++--
> scrub/xfs_scrub_fail@.service.in            |  4 +--
> 7 files changed, 55 insertions(+), 45 deletions(-)
> rename scrub/{xfs_scrub_fail => xfs_scrub_fail.in} (63%)
> 
