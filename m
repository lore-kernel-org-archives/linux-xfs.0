Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E62BA2D
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881469; cv=none; b=RjNCwjsN9LnRU4wAor6xuTS/EP9YgYPMgFBqQbdBopE6oP6Dsoc3OdAOZyHticLafHb8k/9rG2kdnvnqw08GqIRluyXCIa7iuRuwrg8DUTis1N3kJETot+Cw4FXVNDPb6N9jM6rBntSQYMk4NSUAiBXrspA8NbCeyeLQvy2bsFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881469; c=relaxed/simple;
	bh=PVhTg5o/Yq4FgAdR5Xk9MP9FjO0WLHruVrCpwktfLrs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ss0pVM5QrNPV09Vay/cKbBSm74Amt8BB5hC8zIdBnDjQCAHR4y4ix3d++PEo4+eGSPodxPW6WQzI8a5yTOaEpvQWs+I9d4poSL0q0bXLEnUWRVBB8PCGwgqFtwOFLFU+lkfdUjEfOLYbo6oDe/amWklazJqYDaDuVSxSfvLu5u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JeK7MuI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JeK7MuI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1209C116B1;
	Tue,  2 Jul 2024 00:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881468;
	bh=PVhTg5o/Yq4FgAdR5Xk9MP9FjO0WLHruVrCpwktfLrs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JeK7MuI6fVIGEkypD0VD7z7YkLnWcA5qOoxDBeHZniSad42Dv8MIzuSJM4yvL9RSj
	 nzq8XCjRBSZu6IEvdfR6SXPapoxJ4wZvHRvXaFl4NSzovGrF93y8RQbo6DGmWHtkpq
	 T0QoBKBFqvIZQoRl8MrI63oKjrVsllAzu0ib5NTcrS2vMnDytCZRMSVnMhikbg+Hna
	 enpUH6gIV30zKlYdMLjLYRmDZtQW/Wx8gtLgq91ZUha7mwPBzS7lZbq9Xqg2plOjaw
	 WEVKfxXSFgz2kRVy7q+gqx46D3Wjw93DvvL4cgJmF8dqrC+Opne90TyNuUUBgOkTJ2
	 545rYzZsX2DYw==
Date: Mon, 01 Jul 2024 17:51:08 -0700
Subject: [PATCHSET v30.7 07/16] xfs_scrub_all: automatic media scan service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119402.2008463.10432604765226555660.stgit@frogsfrogsfrogs>
In-Reply-To: <20240702004322.GJ612460@frogsfrogsfrogs>
References: <20240702004322.GJ612460@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Now that we've completed the online fsck functionality, there are a few
things that could be improved in the automatic service.  Specifically,
we would like to perform a more intensive metadata + media scan once per
month, to give the user confidence that the filesystem isn't losing data
silently.  To accomplish this, enhance xfs_scrub_all to be able to
trigger media scans.  Next, add a duplicate set of system services that
start the media scans automatically.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-media-scan-service
---
Commits in this patchset:
 * xfs_scrub_all: only use the xfs_scrub@ systemd services in service mode
 * xfs_scrub_all: remove journalctl background process
 * xfs_scrub_all: support metadata+media scans of all filesystems
 * xfs_scrub_all: enable periodic file data scrubs automatically
 * xfs_scrub_all: trigger automatic media scans once per month
 * xfs_scrub_all: failure reporting for the xfs_scrub_all job
---
 debian/rules                           |    3 +
 include/builddefs.in                   |    3 +
 man/man8/Makefile                      |    7 ++
 man/man8/xfs_scrub_all.8.in            |   20 +++++
 scrub/Makefile                         |   21 +++++-
 scrub/xfs_scrub@.service.in            |    2 -
 scrub/xfs_scrub_all.cron.in            |    2 -
 scrub/xfs_scrub_all.in                 |  122 ++++++++++++++++++++++++++------
 scrub/xfs_scrub_all.service.in         |    9 ++
 scrub/xfs_scrub_all_fail.service.in    |   71 +++++++++++++++++++
 scrub/xfs_scrub_fail.in                |   46 +++++++++---
 scrub/xfs_scrub_fail@.service.in       |    2 -
 scrub/xfs_scrub_media@.service.in      |  100 ++++++++++++++++++++++++++
 scrub/xfs_scrub_media_fail@.service.in |   76 ++++++++++++++++++++
 14 files changed, 439 insertions(+), 45 deletions(-)
 rename man/man8/{xfs_scrub_all.8 => xfs_scrub_all.8.in} (59%)
 create mode 100644 scrub/xfs_scrub_all_fail.service.in
 create mode 100644 scrub/xfs_scrub_media@.service.in
 create mode 100644 scrub/xfs_scrub_media_fail@.service.in

