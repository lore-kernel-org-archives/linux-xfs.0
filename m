Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93721CF29C
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730418254; cv=none; b=u5A0WBbkzJGuMK+c776O6rbHUALRym2PIrcL1eq/eJm5ybw6Qpz0YUXlcDPpGExmR8AaV2P5xOd4k9oJZ3Uk4837Q3Y5cMobmC6i1l794f1BDhwFkRiCwLqkRFvFts1kRzu5e5oKWLnp83sW/tk06m7Om9fByZu4iAFPZNQDo40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730418254; c=relaxed/simple;
	bh=TCCbty4V+E/8XIi8NisO3V2tVqw2qiFQrX0FzQ22JI8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=nIrciKbhGgn0/GjBh7mTmCwm8/Q2p1lT/dkhTiiNoNslLnZuaO7VfoRW/GsUL7/vA+C99cvxEXdlFLcInYsBp6OnEme7H9CENTUYjpRsOxfvChcU4GYTZfu+oLxjkoHSq3lmuzqTquULWORCYdji63ciUT8ifNE8wvVMF4pLQBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mb26wLFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mb26wLFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44440C4CEC3;
	Thu, 31 Oct 2024 23:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730418254;
	bh=TCCbty4V+E/8XIi8NisO3V2tVqw2qiFQrX0FzQ22JI8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mb26wLFx4BeP7HsfbmNOl+JjDBFJLzr2+AT8A243204kd9ZHSY0uswRlBVRLd+CqM
	 eKD+uD/mZWB6sckS0SvBcOueqEDH9SmTQ7mWKYLEDGnZFegeBsjz9h3LnemHkGb50I
	 iM+HbhKmtNt1clz0t6tLj2KARplr7IGHJ3sQHZXwfdf3JoRKB4hgQYt1O6sJQcvEmN
	 7bgX1bbmA5nLgmldVYzz59hivUZYAt8GSExfQT9EaY0wmwNervb945q4st4cZaVNtD
	 dbPCLkzKlvrMFxYrkSS66hl8HXaHY+OtKKPsbCPhjtrR4WySlWmlIefxaKYqnhdByx
	 8uXkYRqVXbSCw==
Date: Thu, 31 Oct 2024 16:44:13 -0700
Subject: [GIT PULL 7/7] mkfs: new config file for 6.12 LTS
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173041764926.994242.16998301667196193579.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241031233336.GD2386201@frogsfrogsfrogs>
References: <20241031233336.GD2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 024f91c02f22a6f1f1256a5b09323bc3b104f839:

xfs_scrub_all: wait for services to start activating (2024-10-31 15:45:05 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/mkfs-configs-6.12_2024-10-31

for you to fetch changes up to d19c5581b03e236de3737a35e53c99529ac8e912:

mkfs: add a config file for 6.12 LTS kernels (2024-10-31 15:45:05 -0700)

----------------------------------------------------------------
mkfs: new config file for 6.12 LTS [7/7]

New mkfs config file for 6.12 LTS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
mkfs: add a config file for 6.12 LTS kernels

mkfs/Makefile      |  3 ++-
mkfs/lts_6.12.conf | 19 +++++++++++++++++++
2 files changed, 21 insertions(+), 1 deletion(-)
create mode 100644 mkfs/lts_6.12.conf

