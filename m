Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7D62EA14D
	for <linux-xfs@vger.kernel.org>; Wed, 23 Jul 2025 15:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753283983; cv=none; b=bCQhBWn5z4FDFLRfuVpmPqhHXiAarZqeHcg30AXqUstXt8rU+c47YDGLBRklI0N9j7b1P0jVTTqEsheq766mTdYWXCTjYISj80uxJEJU/+2DcY37Ir7feGLN8GLd94ut5z8gm91Z0EkAZmEpw2TxYptx4AroW2g03XIYnR6WAKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753283983; c=relaxed/simple;
	bh=4Vgh37wGiSWzgKjMYZfXfNRmseLzBOz6v8bhlgPUupw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XVCKlQGSEWTEyzMAlAz6NK5V83+j+w/+kafriJjgpilvQj5CRPQ14uh7BvFXo0BQLwgEofLsj0XoSSku3B0BXcnE78c1k2u0ta0pOVIWs7B1YAUKnrCX4UDxwm7WRPwNLfCcCioyxYNnxS8ED4QOVLcD5UGtMDKNBnG3DPo9gK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qX4ezFGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qX4ezFGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF6DC4CEE7
	for <linux-xfs@vger.kernel.org>; Wed, 23 Jul 2025 15:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753283981;
	bh=4Vgh37wGiSWzgKjMYZfXfNRmseLzBOz6v8bhlgPUupw=;
	h=Date:From:To:Subject:From;
	b=qX4ezFGg0m5vi3BqtsF5zQ/xKTjBPm+x8qiy6n8zqr3qYQepDJ9UQn1oeyrMoRQ5d
	 V/548F9VIudNFS8o6Cok531UU614l8FSsuUsf2B2ARTto6bPukP4OS8+JpmHi06bDw
	 wy852jWlr4ua8jUsZMAaijkoBs0neUnZVcyn9B8UAgaCgXr21c6LI9smhP/jubjzuG
	 6jI0enmXOlAj6V3KREPRfEB7UfpJYXc9C7RoseNxvyJqlZEGDvQYRbediYssw1wx5t
	 DmHF5Y/ieAbCi/Fwm13ToIHCq3P9nGgBUSqGRs6CBU+8noq9Hn6cjM2KtONOkiXj73
	 QJqhfp38blrnA==
Date: Wed, 23 Jul 2025 17:19:38 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 41a35f69b694
Message-ID: <cno5btxb4qlxe5wut4ues52ejbpesqldfqq5ca3xdpsuikvcec@fqwuzc6atg7h>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

41a35f69b694 Merge branch 'xfs-6.17-merge' into for-next

5 new commits:

Carlos Maiolino (1):
      [41a35f69b694] Merge branch 'xfs-6.17-merge' into for-next

Steven Rostedt (4):
      [1edc170bb240] xfs: remove unused trace event xfs_dqreclaim_dirty
      [55edb3326b4b] xfs: remove unused trace event xfs_log_cil_return
      [c17f506f0abe] xfs: remove unused trace event xfs_discard_rtrelax
      [10a957e43f28] xfs: remove unused trace event xfs_reflink_cow_enospc

Code Diffstat:

 fs/xfs/xfs_trace.h | 4 ----
 1 file changed, 4 deletions(-)
