Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1DB20E6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298776; cv=none; b=BxMY1xnWNf/3LsfR2OLsJFBT1TqKpd4BsYCvKFo3c7rIsJDuBZVlIAcLqN5aqeNBSe0ZXEC/KwkT7sZTd26Zz/joPgYEiDmBwFYujKqcj3Kf0s647Sn6d8B/9xIxQlLakgeniRk0Xc52jdZ0I0+Ir1Acyy9bq3L9QjCmjh/fAsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298776; c=relaxed/simple;
	bh=/0UuspgYjfVLHITl95TTwAPrQvVfmlo/A7387H+a0WQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FGTv/ZN7JUb6p9CS2AI0+bIOv7lmjkauzo4sSxo4kUZiClZlfVxrWzHBRsPwLbuUn0tusUDIYNNa1AETR7qhgE1JzTz+SGiM1p7lAytf2FX44R0fFMoYTprJbJiZ9ZQDpIOAwUhQjNn/v38/ldXktnGARoOxWaGc0j+reJPT3/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxkKIZ76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxkKIZ76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4011C32786;
	Tue, 30 Jul 2024 00:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298776;
	bh=/0UuspgYjfVLHITl95TTwAPrQvVfmlo/A7387H+a0WQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hxkKIZ763CHOskcTHp0zSU8iRfJqYnkPGQV0nevlKNiTJi0p7WCigiNaBeui8xyJB
	 LNgCQDRI0t0+ql1PxVw7UpDpdaJM960LVBCrNvk6Rd43AR0s6nUqV5xHS53ceE6F0L
	 1AmSbc0ostHkquBdnt9NpkMfMYkaIF2Gy9RT+zDdw1TF/S3xjnKBTOhPRKUHo2r36b
	 Y3ZbdSVB6lgEBtxZzPb8JLXjPO9Z0MI8/IGojvye+4p4Xiaklvds+2znSF5b8sglY7
	 89pvNEvVPfYaqU4I5ktstv06AY8MutapX55Y3m6+sq68TpbaxY3SrxG9LeDlGNQNA7
	 X/cihwFLHotdA==
Date: Mon, 29 Jul 2024 17:19:35 -0700
Subject: [PATCHSET v30.9 12/23] xfs_scrub: move fstrim to a separate phase
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fstrim-phase-6.10
---
Commits in this patchset:
 * xfs_scrub: move FITRIM to phase 8
 * xfs_scrub: ignore phase 8 if the user disabled fstrim
 * xfs_scrub: collapse trim_filesystem
 * xfs_scrub: fix the work estimation for phase 8
 * xfs_scrub: report FITRIM errors properly
 * xfs_scrub: don't call FITRIM after runtime errors
 * xfs_scrub: improve responsiveness while trimming the filesystem
---
 scrub/Makefile    |    1 
 scrub/phase4.c    |   30 +----------
 scrub/phase8.c    |  151 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/vfs.c       |   22 +++++---
 scrub/vfs.h       |    2 -
 scrub/xfs_scrub.c |   11 ++++
 scrub/xfs_scrub.h |    3 +
 7 files changed, 183 insertions(+), 37 deletions(-)
 create mode 100644 scrub/phase8.c

