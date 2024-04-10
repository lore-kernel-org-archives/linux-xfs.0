Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298C219E
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712709989; cv=none; b=t2uWR5PjCOGzq+iGyp1jN+1ePPR94BM/rCS/F94UvikJj1idUm/w6Ub0hEQCpcSSvWpJ1lMPreDaRZ6KH4VDYLXZiUPzcwER12Afg0li7QRQoAI4oUWWZER+chpOuVK7hcLmujM2uzfOtlURZWeeJSYw/PSVX07QcQBpBgCuZpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712709989; c=relaxed/simple;
	bh=KaKQgd3WnfF0QcUO9oUC+FBLHhwzd3S3fYhDlBXhOko=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NXLhs0TWNihq30Ao568zZJKnTzvpA3whP/2fvdWzKv1fhdjfQVEAMVRYUIEyOF60OOFFc8m2MYD2KzRkLlWQS6m5DtLPiOJ4GjpH7zQ40tZ9D6uPT1pJtqax3BcdttUG3xkkLs1KEXVCFIxh2F64U6bQABdLpjKsoqqF0K60tAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctsOgHRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctsOgHRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25D9C433F1;
	Wed, 10 Apr 2024 00:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712709988;
	bh=KaKQgd3WnfF0QcUO9oUC+FBLHhwzd3S3fYhDlBXhOko=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ctsOgHRWi39N/KmLdHg0XWwcNw/ejpwi+xaHiaKLRvXixUnu9RzFFSylxHcxL0mq5
	 IqVKDxC0FpyUn6Korq/dA/wzq7Q1OmSeLA1Wkeh2gFxMkFXtfkY5yXxF6PcJ5VCf0R
	 lnjwzWIBNzfrUn32l3iWINjVb2ldUWDiM3PDscLvPZYSaVRVB3Co9Vw5CDA8Il0B5C
	 SexxoFu7sLt3b5YzpTCPKzkIdDp3GaMP4rf5m5RZm36RtuZjhfMt3mUhJJLS5j2Rjg
	 Vv12VYAxaee+8Yu1E/VmdhiOnTjI09tNPMS+MaFcX/p1VKhIFmZErs8xjTR6cXNqFW
	 WUWO+aG4t/x5w==
Date: Tue, 09 Apr 2024 17:46:28 -0700
Subject: [PATCHSET v13.1 9/9] xfs: vectorize scrub kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
In-Reply-To: <20240410003646.GS6390@frogsfrogsfrogs>
References: <20240410003646.GS6390@frogsfrogsfrogs>
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

Create a vectorized version of the metadata scrub and repair ioctl, and
adapt xfs_scrub to use that.  This is an experiment to measure overhead
and to try refactoring xfs_scrub.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=vectorized-scrub
---
Commits in this patchset:
 * xfs: reduce the rate of cond_resched calls inside scrub
 * xfs: introduce vectored scrub mode
 * xfs: only iget the file once when doing vectored scrub-by-handle
---
 fs/xfs/libxfs/xfs_fs.h   |   40 +++++++++++
 fs/xfs/scrub/common.h    |   25 -------
 fs/xfs/scrub/scrub.c     |  168 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h     |   64 ++++++++++++++++++
 fs/xfs/scrub/trace.h     |   78 +++++++++++++++++++++
 fs/xfs/scrub/xfarray.c   |   10 +--
 fs/xfs/scrub/xfarray.h   |    3 +
 fs/xfs/scrub/xfile.c     |    2 -
 fs/xfs/scrub/xfs_scrub.h |    2 +
 fs/xfs/xfs_ioctl.c       |   50 ++++++++++++++
 10 files changed, 410 insertions(+), 32 deletions(-)

