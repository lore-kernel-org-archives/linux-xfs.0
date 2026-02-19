Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56B42E6CAB
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544619; cv=none; b=fb44SY3I3OT4EHt/xEXsGKrIs1RzD4Ktez+NqAgY2fhwspLwuLo8pJW++vpJoC6KbaQZv3S+s/vuaJh2197R+PNFBJmjsoEiSYculKM1VuG/yyZeM7wphGGu0J6eEziNXGDWvAQsQzSdaUjuF4tLenMhMMj7nJtESmcvEfNDT7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544619; c=relaxed/simple;
	bh=zvgoqDuU6IFE2O3RIfm29wa2ioh+M8zB8ptDgUCOdmw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=D+SYk+WQzaTjpN3r7HIdN3ZThC/r9pYG9U5bSkqcOMalJbe5v3ntiXycZHwAv6km8ZoCm0e8vKr7kpsXM24nygeFxLwBbfsPOQZIFMvPq0hCZgZ3j2QaYvvoMXd+J4OYD75NlQI6OGnJ8VAy26OKgvFpK7pGHzJioyjozujGxAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jdI7WyQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jdI7WyQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A5EC4CEF7;
	Thu, 19 Feb 2026 23:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544619;
	bh=zvgoqDuU6IFE2O3RIfm29wa2ioh+M8zB8ptDgUCOdmw=;
	h=Date:Subject:From:To:Cc:From;
	b=jdI7WyQBDpz/TWw8Camx1qPSth3t6YxdYpjJvRZPvbRcP2VfD9lEI2fqcVixGsUsO
	 fHT7L6x9Zvb+kTicht+BS/ceQICieidBRDVGKThjyjrne+oqjdy+z9ivQhoPOXoYQZ
	 9Wq1iOmnapO/gcc9U6QmuR5vLItMpnBpqXIKOo7VXDeie2veR49a3NyJz5K/MhOqHO
	 4reQ+KpOPqkUnHqcIY3OGfAYNCPLsOHvuBkJ5rByWPDJbxb1/HX4blLysVA0qTRsek
	 8pPLbB7oT1bhl1V9cr/Q+4vidaSmEyAuUOuYmPuW5Ly1HfqIjEYB2rZcOAtE4AhMU5
	 723xnpTr427JQ==
Date: Thu, 19 Feb 2026 15:43:39 -0800
Subject: [PATCHSET 2/2] xfsprogs: various bug fixes for 6.19
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This is miscellaneous bugfixes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * mkfs: set rtstart from user-specified dblocks
 * xfs_logprint: print log data to the screen in host-endian order
 * mkfs: quiet down warning about insufficient write zones
 * xfs_mdrestore: fix restoration on filesystems with 4k sectors
 * debian: don't explicitly reload systemd from postinst
 * xfs_scrub_all: fix non-service-mode arguments to xfs_scrub
---
 logprint/logprint.h       |    1 +
 debian/postinst           |    3 ---
 logprint/log_print_all.c  |    5 +++--
 logprint/logprint.c       |    5 +++++
 man/man8/xfs_logprint.8   |    4 ++++
 mdrestore/xfs_mdrestore.c |   16 +++++++++++----
 mkfs/xfs_mkfs.c           |   47 +++++++++++++++++++++++++++++++++------------
 scrub/Makefile            |    2 +-
 scrub/xfs_scrub_all.py.in |    3 ++-
 9 files changed, 62 insertions(+), 24 deletions(-)

