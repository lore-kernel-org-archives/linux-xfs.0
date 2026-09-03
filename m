Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270FD311597;
	Thu,  3 Sep 2026 05:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414662; cv=none; b=G4XweoqM44vwmiRAIj6m/oI1l/noqT3/T40rSnG5Aefc7iax5l+udwi30FLVcCT1eupuDe/vLyadrdXiT38TLnrQT1BAj9zTveoXaV1jk6wEfSLPA8if/itFeq5NFFIjhlFEUhxoeDiGpDADd/zc7VQaJQ69QABRNUoGVKiFLD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414662; c=relaxed/simple;
	bh=n79RYO/BJz/jTRhr4DAjdRAvuoY47V5JIlKsdKMt4g8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=du5D8Np2HCYeJOgpaRiMSy/ChXSGzqnJ38VBq45x4+mmzgD3PJIzoKfIKlueHCt1WL7zVip5mo6UUjmt0aM2zhp1AgmhDE6lr4gGxt5gy7fAfER9AAxoOhT3LyI41orkXEx5o+AVhxzweKIomiHamDOA5FuvAS8ebVODHWp1HVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5RNQHeG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5RNQHeG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 85D881F000E9;
	Thu,  3 Sep 2026 05:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788414660;
	bh=f74QrAAonV82jIsB6vdhvZ8Y/2GM/ahdT7hXkkIG1JQ=;
	h=Date:Subject:From:To:Cc;
	b=d5RNQHeGZLL9XknMG61DFuGXlTWj6A4toGc9Xddz177kiOSYNrKQ0sxU/HlxdZpiG
	 lnmyCpNOiJPOfoxVa+Hts1WzmJlUYFm/pRulmbV4ML4Djkeo5Kcgtl05D80F33parV
	 HAJUxlVzZkqtNDGvABc3bJ/47Lde9nFU28NhxQJizE1HzxH/fQ0cIj6MFMxYDB6M9b
	 kIHoSkhIdvsLLjRjAy5z015a4Pt3AT5VqfsLocsupIlUTRuNzOb3TUlR4XeP5hC9Lz
	 8inECDrW8nKwf7OUEiqSmfQfCqskBFkPnb0p6fdY599LHpht96sSimtUE3xoC+A489
	 RhHM0MigGxdrQ==
Date: Wed, 02 Sep 2026 22:51:00 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 10
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a tenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-10
---
Commits in this patchset:
 * xfs: cross-reference the rtgroup superblock extent, not block
 * xfs: use the rtgroup extent count to find rtrefcount gaps
 * xfs: strengthen the "is cow staging" helpers in scrub
 * xfs: fix rtrefcount btree block counting in scrub
 * xfs: make the rtsummary repair fix the file size too
 * xfs: count escaped corruption errors in scrub stats
---
 fs/xfs/scrub/stats.h            |    4 +-
 fs/xfs/scrub/refcount.c         |    6 ++-
 fs/xfs/scrub/rgsuper.c          |    6 ++-
 fs/xfs/scrub/rtrefcount.c       |   80 ++++++++++++++++++++++++++++++++-------
 fs/xfs/scrub/rtsummary_repair.c |    3 +
 fs/xfs/scrub/scrub.c            |    3 -
 fs/xfs/scrub/stats.c            |   28 +++++++++-----
 7 files changed, 98 insertions(+), 32 deletions(-)

