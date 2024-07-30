Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C884A1FAA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298917; cv=none; b=ocV6ux6XkHre+JYwd+D4AgFXDfEOTWL7cP3f0KeOJHLF02yJe4zyeHOhD8YvyFO8DknDQ0YTZ+dueRJTZngXXyogbRuiOvBLTlSNp2tmQma78Q+HMxrrafYiZmebD1YxVRT3WbJ1EnZIyyrrcpGqpAP0gjKEh7AEjuoBVAjwoVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298917; c=relaxed/simple;
	bh=+cmz1F5bRzucfbubudtz6glWyZKYpARGezrUNO7tikk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W2Ct//EZjc07fb7j7Re6hMeCcZDeYmN/VvmZ/Q4s+znI1BflCDxIU0RC7nAi0kU6Yl+WoS+nN5QH0fECsovCM/5vdk+NnDcxq+MoGqo6SfbhL6xgT6Q+kiTN5QIGX41UUbScRDxpx8OboGxJPNi6J17xD9Hm0Jv7vsgGHz4PBmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AnyNAdxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AnyNAdxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C93C32786;
	Tue, 30 Jul 2024 00:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298917;
	bh=+cmz1F5bRzucfbubudtz6glWyZKYpARGezrUNO7tikk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AnyNAdxFklIb0WjiBMYuWyrLck501It8IFyQhHceQdxCea1UHiwL7FyMdHuTVyz+8
	 QdWPz/Mp3NgO/uyl/7Ulyglj1Jur+f9krG1bUiRI/u5cCh42jjFIs+GMgxjhAucXEX
	 ehkPIardkvMbc54ymf7KsqlFKWquuP9hGJ0BCyJ1s4oE0MDHPjD2AO10FmrNhpqAGP
	 9yuKc5VOXUAjKD1sAbOluUzfiTTIACbOKVFuElq8ZBbkzGTJcGYjbbE+mOVP5hSNrH
	 Qq8wTKMqefkTdGICavrkBZWT7nW8uZQdoOzry6OUfycVSutOcHGUTuB5sUapUJjpS3
	 MOUNvgngMgpQA==
Date: Mon, 29 Jul 2024 17:21:56 -0700
Subject: [PATCHSET v13.8 21/23] xfsprogs: detect and correct directory tree
 problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229851966.1353015.1969020594980513131.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

Historically, checking the tree-ness of the directory tree structure has
not been complete.  Cycles of subdirectories break the tree properties,
as do subdirectories with multiple parents.  It's easy enough for DFS to
detect problems as long as one of the participants is reachable from the
root, but this technique cannot find unconnected cycles.

Directory parent pointers change that, because we can discover all of
these problems from a simple walk from a subdirectory towards the root.
For each child we start with, if the walk terminates without reaching
the root, we know the path is disconnected and ought to be attached to
the lost and found.  If we find ourselves, we know this is a cycle and
can delete an incoming edge.  If we find multiple paths to the root, we
know to delete an incoming edge.

Even better, once we've finished walking paths, we've identified the
good ones and know which other path(s) to remove.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-directory-tree-6.10

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-directory-tree-6.10
---
Commits in this patchset:
 * libfrog: add directory tree structure scrubber to scrub library
 * xfs_spaceman: report directory tree corruption in the health information
 * xfs_scrub: fix erroring out of check_inode_names
 * xfs_scrub: detect and repair directory tree corruptions
 * xfs_scrub: defer phase5 file scans if dirloop fails
---
 libfrog/scrub.c                     |    5 +
 man/man2/ioctl_xfs_bulkstat.2       |    3 
 man/man2/ioctl_xfs_fsbulkstat.2     |    3 
 man/man2/ioctl_xfs_scrub_metadata.2 |   14 ++
 scrub/phase5.c                      |  271 +++++++++++++++++++++++++++++++++--
 scrub/repair.c                      |   13 ++
 scrub/repair.h                      |    2 
 spaceman/health.c                   |    4 +
 8 files changed, 301 insertions(+), 14 deletions(-)

