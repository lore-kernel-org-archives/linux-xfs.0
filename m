Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69263B0591;
	Thu, 30 Jul 2026 05:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389174; cv=none; b=IF01oGej2aSWjjuozgczxFTyuwYvMHhx2c3YIC0EjENvvGRy0roaQ+QlmmUooEHrzUCbMbmQlDRZ0wqt8++UZgDlMwTvqkZJo0Wvrk+TbcyAwB1POVW7xA8Dpk95ihiOPdsQvCgZYLrpEOdtXOX7iZSmm44aTef46o7Swl+So9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389174; c=relaxed/simple;
	bh=9rJH0zzluc9hiFuNznkKZcuUv2VJWVYFUImdUYF17HA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=GfqHzReTtd0hkJDT0mQwsFIStmTOIRIwuq18s8JLB3SS1gE1k46X/XcrRaHH/u2uHJiVNsYbySjOnG4SWl0Ihy6nQ8tDuoy9VwkTDBlXWQwBN571fCHg/EalW0ZgGg+Nv0Q2h283gm4uEc61F5Oa/dkNELQ63CxDoefzss6jXhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KwDKfYkv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KwDKfYkv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1765D1F000E9;
	Thu, 30 Jul 2026 05:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785389173;
	bh=Ez2cvLpLvocUL0LtvpwJGonDyIfvg6Rd7/1c8LAGp8k=;
	h=Date:Subject:From:To:Cc;
	b=KwDKfYkvwJQbwrny5ROLb1p09Jqk6/CI1zHHLAX9Wc4uMGarCeqY9pYjnk/ophyae
	 syM8u1oH6i6bJI/t4uOprnuIO17/f0aRhVEI16n6YtzjtcvwIN70xSraa+R4gcnIHI
	 BRWTmNJ3OWU46gz7HWZ3gOeb/t7JlSjZqmX+PFtAhsysjhd5MQjEW2fixMuimMuFBh
	 nXkLHGeATIXqYE2T0qkC1elr/a6YDt9ABN0nCGm7yPgaEvPAwnvUqX4YIWasCNsBHi
	 VLu7YIy1rkPsPzuZ6yiDFYHkLCMp0OmbFhVvVtBCkwRiB0TOPtFogsHq6Qx+LJGzL7
	 mFFuTXWd2rm1w==
Date: Wed, 29 Jul 2026 22:26:12 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 5
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
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
 * xfs: adjust datadev sector count to reflect internal rt volumes
 * xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions
---
 fs/xfs/scrub/trace.h                 |    2 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    7 +++++--
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |    4 +++-
 fs/xfs/scrub/quotacheck.c            |    4 +++-
 fs/xfs/scrub/reap.c                  |    6 +++---
 fs/xfs/xfs_buf_item_recover.c        |   12 ++++++++++--
 fs/xfs/xfs_super.c                   |   11 ++++++++++-
 7 files changed, 35 insertions(+), 11 deletions(-)

