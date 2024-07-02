Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE98D50F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881578; cv=none; b=Pq142oPrMiVe8laHANM0b5mHNR1nu+gp/cUQ3FM7IFrJ/EEi/z54qv8Ytz3xpyiSc9f1YTL4W/KycC52F2M5lEOrbYP+1nv0yCNeZ74Judzde7rzgUMCA//ZfE1p/gtCkmGtqPw/aM3AkPvZT8UjlShSR6cD4LtUJue194OeWkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881578; c=relaxed/simple;
	bh=TCab/TtBDuvmrhO+c0DWhGhDML9RCR4sTY1hx2bFOgM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fFzpS4bLfnG+QBSgUV7yzYF6oUG4Veqwd6Hm3OEEVTYGDVIY2+6Y8HN40ntRHzVz/o9c0VuYKHpVskAYA6V6G4xi9a/j2OMyu4WWiJNkK5/cJFhtqXef1vqaYrjpXYXLz7CWSgbPA210ocR1P1IwsmZcrO2X43oY5RyXfAzhkBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0GluoWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0GluoWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38383C116B1;
	Tue,  2 Jul 2024 00:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881578;
	bh=TCab/TtBDuvmrhO+c0DWhGhDML9RCR4sTY1hx2bFOgM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b0GluoWAIpUeNwk/Tt6kjbSaINCqRkFRXoMQ5eRzSXVgAcB5jjFypBP6CrH7it3cR
	 1MAI9L+XwhS5r11/7zlRwwnsotSSri2O0yJglqvtwFuqi0F4VJ8gjuwJRUSSSqRiVH
	 Osa43y1Y/xbyPhrCDITaSq9sUdaUC9g8jijOxUK/mTwKAlhH4dqczRZ3uIdqeiFgWl
	 +gQ7eQ7uNPGtWwJ6Bcy2Cb/YW/YgsKopmSwFO5m4lBCQjgInaOXIX0TYBOsLcFiCxn
	 P68WEgdRjdRkMKKZzYL5VX2JEMF2S3q1tBJTlIJgEtz7DMRezeExNhgueALdj24uyz
	 Al+ev6c+japTA==
Date: Mon, 01 Jul 2024 17:52:57 -0700
Subject: [PATCHSET v13.7 14/16] xfsprogs: detect and correct directory tree
 problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs>
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

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-directory-tree

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-directory-tree

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-directory-tree
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

