Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9F55A780
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 10:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706005696; cv=none; b=c9JU1oSeGYT81XknME2zQ2s6O2l0Pq2Db1EVNMqK2IXvHhkeIzWe3j3Xp8leCXAjkfI0y+xX/wrSA9J/YbdsnMEgAhZ34C1W6VHd03gRI3KV+BI642hKj/OJXtBmehFpOmuE6PXEhtcIwW72r/2Ujp6Fg79bs/ojvRel7yg1aXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706005696; c=relaxed/simple;
	bh=rFFrXYM1Y77b3uhLp7M81YuiIqciizFphSdXvqc8T54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o9F5t7Jack3KKOaKjGQ23gzhc10eQZsHZRQud6NwLMnC5M5k+E1dKKPCmRsuwyg9XaN/EotTDK3UJINOktq9aIOz3+w4Ej9iUHYMVqEZfDhxiUuqEdsCo1PUnEW1tgrmciVpNIb77a/MvhAGFXeEk79wovb3wRE4udBYUcZc+54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlowUYe+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlowUYe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FF2C433C7;
	Tue, 23 Jan 2024 10:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706005695;
	bh=rFFrXYM1Y77b3uhLp7M81YuiIqciizFphSdXvqc8T54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QlowUYe+7giqiOxaWXpVS5j3n00ViC9qYn/CVqqTf+YcLQYk84NmX4QBV2q3Qy+DC
	 CQu64MgH8Nrn4I9vXtb8PdQbCX6aFm7vXQyX3BdN6DbOJ28GAU3y99DHU2F0meLedC
	 X1r9g3EAklZ9mfnEtS5J4DSfAoSOtTiAn4F8txnsWnGoLR7xF+38lPWSG5vcaZ9/vK
	 aQMcIGTqMBIcr6gCzNqZnAiEJGOqMNzO5t4qniIxE6T/wIdOUn+fy0qapOjqDPCLyk
	 vq38GUTE9KzbG+BGOR2cWTXEnpUoIr38oVnKotgEGGlkkRDIGgP4TJm4eBijKvCtFi
	 5IwH2fTE/dyGQ==
Date: Tue, 23 Jan 2024 11:28:11 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 2/6] xfs_scrub: fix licensing and copyright notices
Message-ID: <ymjmo2m4qf4s6ud55tcockqqh36yx67xkgu2wusjk4unmzjr4g@qzkaeedma5he>
References: <6ln-C8MQIeVLIFpLVXfp0JWgL94Nzr1i-5EVvBytfrdRRk0jdAjlKwrQxBIooR9W8iYwHL3IHU015luhjb0X1g==@protonmail.internalid>
 <170502573264.996574.15670186027839841218.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170502573264.996574.15670186027839841218.stg-ugh@frogsfrogsfrogs>

On Thu, Jan 11, 2024 at 06:16:41PM -0800, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull this branch with changes for xfsprogs for 6.6-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit 55021e7533bc55100f8ae0125aec513885cc5987:
> 
> libxfs: fix krealloc to allow freeing data (2024-01-11 18:07:03 -0800)
> 
> are available in the Git repository at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-fix-legalese-6.6_2024-01-11
> 
> for you to fetch changes up to 52520522199efa984dcf172a3eb8d835b93e324e:
> 
> xfs_scrub: update copyright years for scrub/ files (2024-01-11 18:08:46 -0800)
> 

Pulled, Thanks!

Carlos

> ----------------------------------------------------------------
> xfs_scrub: fix licensing and copyright notices [v28.3 2/6]
> 
> Fix various attribution problems in the xfs_scrub source code, such as
> the author's contact information, out of date SPDX tags, and a rough
> estimate of when the feature was under heavy development.  The most
> egregious parts are the files that are missing license information
> completely.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> ----------------------------------------------------------------
> Darrick J. Wong (3):
> xfs_scrub: fix author and spdx headers on scrub/ files
> xfs_scrub: add missing license and copyright information
> xfs_scrub: update copyright years for scrub/ files
> 
> scrub/Makefile                   | 2 +-
> scrub/common.c                   | 6 +++---
> scrub/common.h                   | 6 +++---
> scrub/counter.c                  | 6 +++---
> scrub/counter.h                  | 6 +++---
> scrub/descr.c                    | 4 ++--
> scrub/descr.h                    | 4 ++--
> scrub/disk.c                     | 6 +++---
> scrub/disk.h                     | 6 +++---
> scrub/filemap.c                  | 6 +++---
> scrub/filemap.h                  | 6 +++---
> scrub/fscounters.c               | 6 +++---
> scrub/fscounters.h               | 6 +++---
> scrub/inodes.c                   | 6 +++---
> scrub/inodes.h                   | 6 +++---
> scrub/phase1.c                   | 6 +++---
> scrub/phase2.c                   | 6 +++---
> scrub/phase3.c                   | 6 +++---
> scrub/phase4.c                   | 6 +++---
> scrub/phase5.c                   | 6 +++---
> scrub/phase6.c                   | 6 +++---
> scrub/phase7.c                   | 6 +++---
> scrub/progress.c                 | 6 +++---
> scrub/progress.h                 | 6 +++---
> scrub/read_verify.c              | 6 +++---
> scrub/read_verify.h              | 6 +++---
> scrub/repair.c                   | 6 +++---
> scrub/repair.h                   | 6 +++---
> scrub/scrub.c                    | 6 +++---
> scrub/scrub.h                    | 6 +++---
> scrub/spacemap.c                 | 6 +++---
> scrub/spacemap.h                 | 6 +++---
> scrub/unicrash.c                 | 6 +++---
> scrub/unicrash.h                 | 6 +++---
> scrub/vfs.c                      | 6 +++---
> scrub/vfs.h                      | 6 +++---
> scrub/xfs_scrub.c                | 6 +++---
> scrub/xfs_scrub.h                | 6 +++---
> scrub/xfs_scrub@.service.in      | 5 +++++
> scrub/xfs_scrub_all.cron.in      | 5 +++++
> scrub/xfs_scrub_all.in           | 6 +++---
> scrub/xfs_scrub_all.service.in   | 5 +++++
> scrub/xfs_scrub_all.timer        | 5 +++++
> scrub/xfs_scrub_fail             | 5 +++++
> scrub/xfs_scrub_fail@.service.in | 5 +++++
> 45 files changed, 143 insertions(+), 113 deletions(-)
> 
