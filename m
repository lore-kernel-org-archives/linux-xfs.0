Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C5A331ED1;
	Thu, 13 Aug 2026 05:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598648; cv=none; b=tkc5+FgZOczBT3Cmc/nJEWywKzOws8HDIPKyLEwXlBWpIgLf0138YZFIpVTm/QxhNUpfcPW/psbtSrBOTMFAtTtDFLWAEHxu+R58zdUmDe0HLf/JtD95CJuPhOE/5fy4Maw7ykIaPtCXcUy7L2q65llU/L3LhM6zgSq1eEv5ovA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598648; c=relaxed/simple;
	bh=PCGo01gMMHG9wd5YvyPXwj9o+ztf0aNGj5eRG9Nwlxo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=hc0FqgexPK8fvtAAYeYZ0B7eSoAdOqvqsnh8Zuzymn1a1vBQewD3DGve/qaYRYxM49XQaHxTKQHTOZGitIVnP62VnojiJpcqyT/6Foncg9PgQC1abhjs4n7drlISKnCFlNEXjUnh4hewz8B145k7gHqfrSu6Ec8N0i2sDXlhD5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DO88Axu/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DO88Axu/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A64181F000E9;
	Thu, 13 Aug 2026 05:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598636;
	bh=0zpLtgHZZvicpeANdqVMLIvJSX8dBRixfrY+AiicSTA=;
	h=Date:Subject:From:To:Cc;
	b=DO88Axu/MifT03EIB09aVhyrAc1XQUXyJcHIyl1vDxLECoAGUdDcLdYinxKx0C/Rs
	 xnQvJYZbPrxi5N6QmuTbLSGr7SOWIdDnCMHUSo+57vGkoCY6H2wztM847nblpym4kJ
	 gthZ1bkFbSjhDvbiE2yZ7BaXqbjCmfFJt4+boYx3AZ9cQ7FccnAjE1/ZrKndAM3F+1
	 aoZO9DtEMpD27zSv8pqT4mz+sjcn6OVRPk+6o+5vZRXmX7b7mAAgBwcxUHmiB5se+K
	 d+9LR8v4ifTSXNlN3p/7NlBS18vVwITWhUYjNyGbgZk4izHeCu0m4A+RyR2X1mEREe
	 Rr0SAnW9nfS2w==
Date: Wed, 12 Aug 2026 22:23:56 -0700
Subject: [PATCHSET v2 1/2] xfs: LLM-inspired bug fixes, part 5
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a fifth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

v2: add RVBs

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-5
---
Commits in this patchset:
 * xfs: fix unit conversions in per_binval computation
 * xfs: fix short ifork reaping computation in xreap_bmapi_binval
 * xfs: fix name string recording in slowpath pptr tracepoints
 * xfs: don't leak dqacct if rhashtable insertion fails
 * xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions
 * xfs: adjust datadev sector count to reflect internal rt volumes
---
 fs/xfs/scrub/trace.h                 |    2 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    7 +++++--
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |    4 +++-
 fs/xfs/scrub/quotacheck.c            |    4 +++-
 fs/xfs/scrub/reap.c                  |    6 +++---
 fs/xfs/xfs_buf_item_recover.c        |   12 ++++++++++--
 fs/xfs/xfs_super.c                   |   11 ++++++++++-
 7 files changed, 35 insertions(+), 11 deletions(-)

