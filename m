Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA96FEAFA
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606905; cv=none; b=S7lueHCEXYx7lPS9dEqVxgktbWCwrrYsNkRjsl4sJLUtWg5el06W6dNaTqpR5B9lmyPNpGG4uLIffkocFzeLn9F5jn6zQM7zFDD8tHxbl+42iJg1eY93jmOMbqfLaPnI0jdIFBPIykMxb0zQ2pWdB8W3dDlAv9SbD19Y+TjagqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606905; c=relaxed/simple;
	bh=4rZl83bSyuqybUOn3sQYbPKs8jmcN2Pk15Edki09M+0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NSSC6Ue490w1mdQTVqyf+iG1SyDLqyvhYHYo3+zFbhKfRD6pEm3JRlw3BSCEbnp9GJAEo9mdtzLjtiOp7THudjA4lhZatFwzjXQq/TFNGYuClDiUoDb1BE6jEKAjdv6iiaKFf0MQ+CMMEjJI60j661awSyqwuUt0dnbKqqFJrx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lH/lye46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lH/lye46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40657C4CEC5;
	Fri, 11 Oct 2024 00:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728606905;
	bh=4rZl83bSyuqybUOn3sQYbPKs8jmcN2Pk15Edki09M+0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lH/lye46g8k6zV1LAFdg153m/RbEgjDn2njsD6t+iqcfubsKtQmm0d03Menwkih8o
	 AlXCXULg7MYb8ab6bgJEN/fIRg8Xrv9maofWUTn1H96LGgWCZsfJ9AaBiN5MJI4Bhn
	 5YK7O+e70lOIbUr80E54Fs9KODAkojiZ0lGnuqBSVFk2DEeJD2EHMvGFkqhsSRYTe1
	 CoAnqyrkbKYlJ+Fl9XbF/C4b6e8cvRB7kEno7ntwLLbQXNKughM+I7dwXdfK4nFI3Q
	 slxirz+y9t4UDftJKm1ltFvOtDYpTtdedIIc40/OnvQ9YLjgCkh0dYhP4SeGzpXkPV
	 aa0YCsnzWFNJw==
Date: Thu, 10 Oct 2024 17:35:04 -0700
Subject: [PATCHSET v5.0 7/9] xfs: persist quota options with metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860645220.4179917.14075452764287165701.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
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

Store the quota files in the metadata directory tree instead of the
superblock.  Since we're introducing a new incompat feature flag, let's
also make the mount process bring up quotas in whatever state they were
when the filesystem was last unmounted, instead of requiring sysadmins
to remember that themselves.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir-quotas
---
Commits in this patchset:
 * xfs: refactor xfs_qm_destroy_quotainos
 * xfs: use metadir for quota inodes
 * xfs: scrub quota file metapaths
 * xfs: persist quota flags with metadir
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |  190 ++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_fs.h         |    6 +
 fs/xfs/libxfs/xfs_quota_defs.h |   43 +++++++
 fs/xfs/libxfs/xfs_sb.c         |    1 
 fs/xfs/scrub/metapath.c        |   76 ++++++++++++
 fs/xfs/xfs_mount.c             |   15 ++
 fs/xfs/xfs_mount.h             |    6 +
 fs/xfs/xfs_qm.c                |  250 +++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_qm_bhv.c            |   18 +++
 fs/xfs/xfs_quota.h             |    2 
 fs/xfs/xfs_super.c             |   22 ++++
 11 files changed, 571 insertions(+), 58 deletions(-)

