Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDB7625
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738451; cv=none; b=qODwMp12MXU0ntyxVpc4/n8Zr21PnShxTGyzlg1pIflgtsKnA892oEBlGWXsTvkRLkRf9zGoIrLDl4LBHmQUoplvO4srduCcOJmyrycRomNe9zFg8JceBkHpJYB2KwuqbPui+nepAWEjuXAi8UtNsUOa1cfo9esT3/G3iOfD5qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738451; c=relaxed/simple;
	bh=TwrdVm0tE7742Xn0E4vr+EQKLKQxqivBJ5+8QJhKr6I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EC8o6SUP/HyfsxZ3wBhcqW6SSz9g1+cqOXgcARVOHfZ7ctladv1h8hLpPUSp+1NtdweIOaRfKtElRj3KMj7j8rNcahkeVV5Wp5yBYykb/ONHuu/wq426EDq1bOKgZoV3WHGfpRs5imSVVvEbYtpx4DM5aSFvClm3GDpQROPMA8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CA6eaGV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CA6eaGV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B0BC433F1;
	Sat, 24 Feb 2024 01:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738451;
	bh=TwrdVm0tE7742Xn0E4vr+EQKLKQxqivBJ5+8QJhKr6I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CA6eaGV/m5OmLMoA/bvyuQ7ZXcr7bQiKlFQL2MJiH09wFKYRgV5QV24VLDy9dyjMx
	 mie+s8PETE7u9lAYtGzWD/8MATOPl5ufDX2hjfr2MtanJwfH2aWA0egmDD9wfSRe11
	 dLH+TY9xVP+Cw4FDdzpPMY+QPp/xjuEpKle6jMbre6tJ84peVHkKYc/FHjYlkRhM+M
	 I3D676ttGx6qk1Y2DJufFqCGu8VOXYevAUeJQXB5ZlFgDz6EVfspdAJr0HuDU8S2v9
	 MBHiaL8FpLLD6UaoqGGxD/1h2xJoG9zpObgYiFW4sADFp6u9yNzxDqAjv7crQmp3+w
	 HLVa13Wo4bH+g==
Date: Fri, 23 Feb 2024 17:34:10 -0800
Subject: [PATCHSET RFC] xfsprogs: live health monitoring of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170873836546.1902540.13109376239205481967.stgit@frogsfrogsfrogs>
In-Reply-To: <20240224010017.GM6226@frogsfrogsfrogs>
References: <20240224010017.GM6226@frogsfrogsfrogs>
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

This patchset builds off of Kent Overstreet's thread_with_file code to
deliver live information about filesystem health events to userspace.
This is done by creating a twf file and hooking internal operations so
that the event information can be queued to the twf without stalling the
kernel if the twf client program is nonresponsive.  This is a private
ioctl, so events are expressed using simple json objects so that we can
enrich the output later on without having to rev a ton of C structs.

In userspace, we create a new daemon program that will read the json
event objects and initiate repairs automatically.  This daemon is
managed entirely by systemd and will not block unmounting of the
filesystem unless repairs are ongoing.  It is autostarted via some
horrible udev rules.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=health-monitoring

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-monitoring

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=health-monitoring
---
Commits in this patchset:
 * xfs: use thread_with_file to create a monitoring file
 * xfs: create hooks for monitoring health updates
 * xfs: report shutdown events through healthmon
 * xfs_io: monitor filesystem health events
 * xfs_scrubbed: create daemon to listen for health events
 * xfs_scrubbed: enable repairing filesystems
 * xfs_scrubbed: create a background monitoring service
---
 io/Makefile                    |    1 
 io/healthmon.c                 |  172 +++++++++++++
 io/init.c                      |    1 
 io/io.h                        |    1 
 libxfs/xfs_fs.h                |    1 
 libxfs/xfs_fs_staging.h        |   18 +
 libxfs/xfs_health.h            |   48 ++++
 man/man8/xfs_io.8              |   22 ++
 scrub/Makefile                 |   23 +-
 scrub/xfs.rules                |    3 
 scrub/xfs_scrubbed.in          |  519 ++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrubbed@.service.in |   95 +++++++
 scrub/xfs_scrubbed_start       |   17 +
 13 files changed, 916 insertions(+), 5 deletions(-)
 create mode 100644 io/healthmon.c
 create mode 100644 scrub/xfs_scrubbed.in
 create mode 100644 scrub/xfs_scrubbed@.service.in
 create mode 100755 scrub/xfs_scrubbed_start

