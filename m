Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C275788E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421794; cv=none; b=caoK1R3a00RWVva5WWXse6PMbNhxhhGW8HtEVjSqCfyIBm0PMUUcJ1/bJOeGG0ubXs3UYJY4uxiNag+B1/CWysXHdTyO5OCE04xG0JogUOToP7hDxb5pP2weMSJARMBrUW5ovsx/1KVj8CpLpe1B3npkh5AKBX94ok4okj9ceXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421794; c=relaxed/simple;
	bh=RFruLTeEp7UQ4s8cNgUBTY4ftqtyf6LViBPTeNBybao=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AvKjn0+Jed01SYEvJRIRpTfpgCAp9nzjT+lypelr8iVKZ1+7hDv9CRLiHzwFA0R1Tkpvp4W8qbi6r6pCrkA4UH7CZRvQQyBgJp90+YwqQYlVYrpT4POq7RtOQ9HV7wcuo4TkU4qxy6iv5G4c8VIs4TZ1BEZ7FnD6x70hSbFJ9fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmNnY9Ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmNnY9Ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008FCC433C7;
	Tue, 26 Mar 2024 02:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421794;
	bh=RFruLTeEp7UQ4s8cNgUBTY4ftqtyf6LViBPTeNBybao=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LmNnY9Ur6lj6YnWVi9/o+AdOPAv7EYqbBqXRqwXiHlJTTvvaN6zo7XWrFdwuZUPJK
	 x+wA7R9UQ5oLlw+Nz0aNKl2uZK9sZ6FXRKUWv42fphFufTfxAnH+oco9erErGwv9oK
	 xUJoLVYSEjlroyWodV+Ai/HpVyBvY7LSKZqJjok4aAwjUF5LcoySBJTYhGKmEuCklx
	 dWU1PdC0xObRWe37Qcr4MyhAhADB+MJ3IXhy1xn97QZGjt9l0Etwg0W9VeDW8/uiB2
	 3DTE3dPUNxniB+Fr7DvIalDW3inNNfcK3fydiE/qoCLGiHqYk4JMzDwwX5OC9FBLvL
	 WJgkDLOdRMsZA==
Date: Mon, 25 Mar 2024 19:56:33 -0700
Subject: [PATCHSET v29.4 07/18] xfs_scrub: scan metadata files in parallel
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Bill O'Donnell <bodonnel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171142129653.2214539.10745296562375978455.stgit@frogsfrogsfrogs>
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
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

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-metafile-parallel
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

