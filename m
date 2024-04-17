Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498FA262A3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388656; cv=none; b=NeEMFbUBOsOj/aD/IFvfvTXSyNR2D6Jb6sIeyqGzmPI699JMFfirQOPozFP2f1e2ycq3AH8gUuY7FhVfUGB2O7cbZj4y06/EPYnipED5ei724tCl0sxBmWIFLbCfunpwoDNlZicMBWuQ9MguNsRz+5z9+urLIAhj3/yFL9tC810=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388656; c=relaxed/simple;
	bh=yaZR9FAnxG4FMVdBOgIPp7MHS1812cSAof0w2eEOQ/E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PIY3NMPy5IHrx/YA/BTDqFWNQaDpf4lKRDtd69caeiKMnIFk6D+HybHrlg/ZvbcjQ+aT8T7smkCg1RZNOjWvlm6nfO6IulRNShSBxMt9+/02gNkZjKeyMR65eP1kZzXSYbQ1o9fL7TUmBmKkVX8kT39SP8LPrVxw2YIXPzP/nNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cyaFTzQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cyaFTzQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208FFC072AA;
	Wed, 17 Apr 2024 21:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388656;
	bh=yaZR9FAnxG4FMVdBOgIPp7MHS1812cSAof0w2eEOQ/E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cyaFTzQ/eEV5cuZKn3V2wI+isqAk2AGO5XFRQxksqyIBNBYxZ3GHCrRySXX5P6tzx
	 C9tEGVczaiicEYPo2FAdipxk1ycuQbNYDfqYQSu+gPtndnRsk+2EGIB78Xb2oBzOFa
	 KDxQj7KgSduP2uGEViVrntmI1aHsFz11DLWkrKhzn5fzbdSlxltO9T+gPkVMPSxR9C
	 6RNF1F7O4XIqdw8My1cSoaqkq2ojnbGszvNEGiybj6EICu47jbMlz0wWQQW9VlBWJ1
	 KWKLKafS+tAP8TGXP9RbSQbMa6dPmT/hPYman3nbe/1K2rMqi5IUWvFO33WFFokvmo
	 LG5/zsqJWBjGw==
Date: Wed, 17 Apr 2024 14:17:35 -0700
Subject: [PATCHSET v30.3 09/11] xfs_scrub: scan metadata files in parallel
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338845069.1856356.14579148362990140838.stgit@frogsfrogsfrogs>
In-Reply-To: <20240417211156.GA11948@frogsfrogsfrogs>
References: <20240417211156.GA11948@frogsfrogsfrogs>
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

At this point, we need to clean up the libfrog and xfs_scrub code a
little bit.  First, correct some of the weird naming and organizing
choices I made in libfrog for scrub types and fs summary counter scans.
Second, break out metadata file scans as a separate group, and teach
xfs_scrub that it can ask the kernel to scan them in parallel.  On
filesystems with quota or realtime volumes, this can speed up that part
significantly.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-metafile-parallel-6.8
---
Commits in this patchset:
 * libfrog: rename XFROG_SCRUB_TYPE_* to XFROG_SCRUB_GROUP_*
 * libfrog: promote XFROG_SCRUB_DESCR_SUMMARY to a scrub type
 * xfs_scrub: scan whole-fs metadata files in parallel
---
 io/scrub.c      |   13 +++--
 libfrog/scrub.c |   51 ++++++++++-----------
 libfrog/scrub.h |   24 ++++------
 scrub/phase2.c  |  135 ++++++++++++++++++++++++++++++++++++++++++-------------
 scrub/phase4.c  |    2 -
 scrub/phase7.c  |    4 +-
 scrub/scrub.c   |   75 ++++++++++++++++++-------------
 scrub/scrub.h   |    6 ++
 8 files changed, 194 insertions(+), 116 deletions(-)

