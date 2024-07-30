Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9221146588
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307406; cv=none; b=VRaqwAsIZPv1kNBfYP8H2iTcjDVqi6GqE0XUH1LVnd+UJsIIaw97H/xXZ3f6lA62F8zR+fzFk59ChfI68JyHlYO63b45VYArLWbfb7XiiSzZTVx5UDX6zJqKwSCc67bncbt5gXbOxr4nhD5Q4OAQ/r2SImnNQeRLRf+aeEaUVM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307406; c=relaxed/simple;
	bh=DkcBSKkMVUqGzcAtIzsZiAgW8di4LWJx0Gnjs0LUimI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=rsggPxeikgUsZwZ7QwXCl7DLvfVTxPESTpwvziPuhcDchtf4v9z/9UNRXb6DEiLaNyyEvmwm1QPAvbB8m9x8VcH4G0QtoijDR1GJB9u9/G9jLkUQJ3InIk4eERW/N0s1tm7ntp3dWBNRYTAtUKoLxvXzNFjbE639dpLx152a1EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YCs3CxXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YCs3CxXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC3CC32786;
	Tue, 30 Jul 2024 02:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307406;
	bh=DkcBSKkMVUqGzcAtIzsZiAgW8di4LWJx0Gnjs0LUimI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YCs3CxXnPR61D36ulQz9Rz6AOLlopeOyz8Fhao6OLYCyWnVsz70LxMd/bhupwZn9m
	 xciyvcf9jm8v6yj6q8+hwJBCXHRdEoFzUfJxnrtMNRdZgB43YGslE0XldMf35jQWtX
	 VB76y+4d2/IUek3du5EclILVEi8JUKXXrAY/SJ3Lv1aFtBoydgAe22WIgC40qurG+x
	 7Fez2a5W6XPkYdWYRf4wMEz6AZgZCpGGffwMJimHFEJXhHNPt3qApaTbVsNmqIGSkR
	 V6DATL/J0bq31UL8CwJwhpCht/HD7br1h0O6s5xDa/XK5NVGUckHA1lta5/wH9+ewv
	 +/EGSmbBY7XBA==
Date: Mon, 29 Jul 2024 19:43:25 -0700
Subject: [GIT PULL 12/23] xfs_scrub: move fstrim to a separate phase
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230458966.1455085.4399793624957809063.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 746ee95b71649b4ae515893ffa3bbe7b5e815d0d:

xfs_scrub: dump unicode points (2024-07-29 17:01:09 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-fstrim-phase-6.10_2024-07-29

for you to fetch changes up to 5ccdd24dc9987b50333332b7381ff1a305e67ef7:

xfs_scrub: improve responsiveness while trimming the filesystem (2024-07-29 17:01:09 -0700)

----------------------------------------------------------------
xfs_scrub: move fstrim to a separate phase [v30.9 12/28]

Back when I originally designed xfs_scrub, all filesystem metadata
checks were complete by the end of phase 3, and phase 4 was where all
the metadata repairs occurred.  On the grounds that the filesystem
should be fully consistent by then, I made a call to FITRIM at the end
of phase 4 to discard empty space in the filesystem.

Unfortunately, that's no longer the case -- summary counters, link
counts, and quota counters are not checked until phase 7.  It's not safe
to instruct the storage to unmap "empty" areas if we don't know where
those empty areas are, so we need to create a phase 8 to trim the fs.
While we're at it, make it more obvious that fstrim only gets to run if
there are no unfixed corruptions and no other runtime errors have
occurred.

Finally, reduce the latency impacts on the rest of the system by
breaking up the fstrim work into a loop that targets only 16GB per call.
This enables better progress reporting for interactive runs and cgroup
based resource constraints for background runs.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (7):
xfs_scrub: move FITRIM to phase 8
xfs_scrub: ignore phase 8 if the user disabled fstrim
xfs_scrub: collapse trim_filesystem
xfs_scrub: fix the work estimation for phase 8
xfs_scrub: report FITRIM errors properly
xfs_scrub: don't call FITRIM after runtime errors
xfs_scrub: improve responsiveness while trimming the filesystem

scrub/Makefile    |   1 +
scrub/phase4.c    |  30 ++---------
scrub/phase8.c    | 151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
scrub/vfs.c       |  22 +++++---
scrub/vfs.h       |   2 +-
scrub/xfs_scrub.c |  11 +++-
scrub/xfs_scrub.h |   3 ++
7 files changed, 183 insertions(+), 37 deletions(-)
create mode 100644 scrub/phase8.c

