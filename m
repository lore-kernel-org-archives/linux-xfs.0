Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B07ADF60
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307438; cv=none; b=OlDe/OdA1GMPJRTx8/rZ4izYKqvamwTNMoVuVx1wo2RsgwCvEl/wIhmpluY2yLFrq69EXeExsUbodWIG5lrWmfqn2V9UXVSq1/PvaHAR4+MhID55memyAaioaVrOFTFVezI7hmOEmERthBcDL+lkUKLxXCpXDzRXh8Q/V3ThNZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307438; c=relaxed/simple;
	bh=mofFokamwyy867/TcVBxtmYY6R9Z7rO48GRURAF+DfQ=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=cDYvWde1cFF6KjaRNbe4ypMeafdpBx4sqIG8HpXHM9pAraSO0YIroFmZxlPPitNNQWuHoiBhZn0PqpOLzD83Bzi/uyX5Tc+9Gq+J946hMe7la5/EQty+p1iboBZqh05AsqrjU3bO3AaagLMxhvtpV34/FFbam2uz3loV85kyK5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UrDPkMtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UrDPkMtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B493BC32786;
	Tue, 30 Jul 2024 02:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307437;
	bh=mofFokamwyy867/TcVBxtmYY6R9Z7rO48GRURAF+DfQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UrDPkMtOJD6HzriyAEwr7OjXu6nmR79m1YD3519LqfzdxmEKR9lbsEPhFXImfqBt2
	 bRK8UBUvPS74ZMrnSuse8AVr3zNIlL+VHKS4hrP3g+5b4Ivi85iLrik2MDomwL3Q/X
	 GJk/1MLT7mQohH3/KZdMMbJYIG49lrfkApTdzp8DLiVLNBc4FO9YHkeaqFvimswuTx
	 zoKruUXJToQjE7Qwcf8yeigkP6lgN2YAJLz2IJCuBZPCbg/WTQ/w6QWZez1z39oSfO
	 IhJ4cfG3FX45sZ4VkuZQgRIKYDmFr9qO1t/uzfdE6VxZNm5GNtd86A6RDxOwAD6tXV
	 GIwkxHp33/8wA==
Date: Mon, 29 Jul 2024 19:43:57 -0700
Subject: [GIT PULL 14/23] xfs_scrub: tighten security of systemd services
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: glitsj16@riseup.net, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230459183.1455085.8900166042263013711.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 34bed605490f936c3ead49e2e1cad78505260461:

xfs_scrub: tune fstrim minlen parameter based on free space histograms (2024-07-29 17:01:09 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-service-security-6.10_2024-07-29

for you to fetch changes up to 50411335572120153cc84d54213cd5ca9dd11b14:

xfs_scrub_all: tighten up the security on the background systemd service (2024-07-29 17:01:10 -0700)

----------------------------------------------------------------
xfs_scrub: tighten security of systemd services [v30.9 14/28]

To reduce the risk of the online fsck service suffering some sort of
catastrophic breach that results in attackers reconfiguring the running
system, I embarked on a security audit of the systemd service files.
The result should be that all elements of the background service
(individual scrub jobs, the scrub_all initiator, and the failure
reporting) run with as few privileges and within as strong of a sandbox
as possible.

Granted, this does nothing about the potential for the /kernel/ screwing
up, but at least we could prevent obvious container escapes.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs_scrub: allow auxiliary pathnames for sandboxing
xfs_scrub.service: reduce background CPU usage to less than one core if possible
xfs_scrub: use dynamic users when running as a systemd service
xfs_scrub: tighten up the security on the background systemd service
xfs_scrub_fail: tighten up the security on the background systemd service
xfs_scrub_all: tighten up the security on the background systemd service

man/man8/xfs_scrub.8             |  9 +++-
scrub/Makefile                   |  7 ++-
scrub/phase1.c                   |  4 +-
scrub/system-xfs_scrub.slice     | 30 +++++++++++++
scrub/vfs.c                      |  2 +-
scrub/xfs_scrub.c                | 11 +++--
scrub/xfs_scrub.h                |  5 ++-
scrub/xfs_scrub@.service.in      | 97 +++++++++++++++++++++++++++++++++++-----
scrub/xfs_scrub_all.service.in   | 66 +++++++++++++++++++++++++++
scrub/xfs_scrub_fail@.service.in | 59 ++++++++++++++++++++++++
10 files changed, 270 insertions(+), 20 deletions(-)
create mode 100644 scrub/system-xfs_scrub.slice

