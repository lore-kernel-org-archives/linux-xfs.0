Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C288B670
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+7jnPRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374FEC433C8;
	Sun, 31 Dec 2023 19:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051613;
	bh=xPRNmL6Qhi+rhbfFLpZYcqKz/k+E6gBI99EW6i9CIvo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L+7jnPReV5mKEZ/sp2AleEo2JfKJWWATyhv9dAy315UWGcuVvGuPfrg8stdV9fQmH
	 ESuUew5Q0L1VB4yoOcVcpuHSizzPPyKrIKBs9PHqWxdkAkmYlBfhLouDGerzqdP3TB
	 FnVkx6s0NPwbUA0Mbt5oLU595xX3l9UbYYa6/V/0B7VVTFdqrGGXzzi7JWYrX+YzFk
	 1TI8DWYkjLcwfbxhnSafwvQ/5Cu+VKmMPe+mFjjCtc/VqOUT0Z+2MG/+7gAwtfGydj
	 Ubbv1MOwJry3Ll6I6qlZWV0p6talVXgr5FpiRtx825kjMywpVuTUw2E+WnJ49q+mhh
	 VCdU4QH33xpVQ==
Date: Sun, 31 Dec 2023 11:40:12 -0800
Subject: [PATCHSET 02/40] mkfs: scale shards on ssds
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404989423.1791433.6933477036695309956.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

For a long time, the maintainers have had a gut feeling that we could
optimize performance of XFS filesystems on non-mechanical storage by
scaling the number of allocation groups to be a multiple of the CPU
count.

With modern ~2022 hardware, it is common for systems to have more than
four CPU cores and non-striped SSDs ranging in size from 256GB to 4TB.
The default mkfs geometry still defaults to 4 AGs regardless of core
count, which was settled on in the age of spinning rust.

This patchset adds a different computation for AG count and log size
that is based entirely on a desired level of concurrency.  If we detect
storage that is non-rotational (or the sysadmin provides a CLI option),
then we will try to match the AG count to the CPU count to minimize AGF
contention and make the log large enough to minimize grant head
contention.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-scale-geo-on-ssds

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=mkfs-scale-geo-on-ssds
---
 man/man8/mkfs.xfs.8.in |   46 +++++++++
 mkfs/xfs_mkfs.c        |  254 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 293 insertions(+), 7 deletions(-)

