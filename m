Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F08736A350
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 09:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789031476; cv=none; b=mmIfkTFlc7WWfvbO6c8iZN7k3oBBQM/xN60Ni/1onHjz3uwW1nfozTKt8y0S9J7Ki+47Wp77wjvNv/4dKcvY00eINR1xfVg1xW4cMmNQBZ6O4gLray0gUbdfk1mJPP/QwK+MiFdPe7rxp9cXph6kCYnB/XTvpjpkXo9Z6dZH8PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789031476; c=relaxed/simple;
	bh=GZ4VbV6YCK+TGYtCIh6X/V/BO3V2+Hw5F14fzf2Pr+I=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=p/dD9UohflFCt4arj71npixOdeC/3u2Adps7KGtqYEER0gjD8OFZAYWLP92kP/ruabNYYOf9XGFb11nVoN9qnfcGf551y08MAI0NjuLiVqYyo488clc3blgRcR5jzV+b8pEYdCaMNzepgbZSY2KtnUyGP8qKopzvkf6Uj3hdtAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CcjMLYm7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CcjMLYm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9222B1F000FF
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 09:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789031474;
	bh=T43oOdZefXVDErPmyp9/KMwi2REUvWX9uFaWDDx805Y=;
	h=Date:From:To:Subject;
	b=CcjMLYm7ZhxcyMQ3hGHimfTJcH2M7PGI+wzuAl/FZTx3dAK7uGAMnmQw1tTm78Vc3
	 dkENZMCoF9+yXoZCTdzOPat3fvugGbc4C83QWs3BpBbWM7m9ygwKrwiXrQ7J/dlp7e
	 jkD4ZihEuwBNptXC3EGuByg/h4b9Ol1Mhohtv+9QhLS1ZgMAl6BFiHA2qdkwtXtkPe
	 yHXNOXxarIqpmn+9hlntRdiOX9gczMHlNabSeNGrq5oKAzSe32QjoI83LntAg1XQi7
	 /Y8YxG1kSuG0JuGoTCHQ1QCAk588ZDE+2Mf8zaTM3dNlQ6A+WUCPfuHjir53rV35n5
	 v4EQnTQ3Jkegg==
Date: Thu, 10 Sep 2026 11:11:11 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to e965895c8872
Message-ID: <aqJzuukCHRxPzFxO@andromeda.toxiclabs.cc>
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

	gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

e965895c8872 Merge branch 'xfs-7.3-fixes' into for-next

9 new commits:

Carlos Maiolino (1):
      [e965895c8872] Merge branch 'xfs-7.3-fixes' into for-next

Darrick J. Wong (6):
      [2c67526f55f3] xfs: snapshot scrub stats when rendering them
      [c7de6c2cefd2] xfs: report healthy filesystem events in scrub stats
      [45125e769b6a] xfs: report runtime failures in scrub
      [08655d4168c8] xfs: remove redundant function declaration
      [036c497d345e] xfs: snapshot old AGFL before rewriting it
      [763490d70e9b] xfs: bail out on bitmap errors in xrep_agfl_fill

Deepanshu Kartikey (1):
      [4870da4f49ae] xfs: take hm->lock in xfs_ioc_health_monitor() before insert

Zizhi Wo (1):
      [157dcb8230a4] xfs: remove several unused and never-implemented declarations

Code Diffstat:

 fs/xfs/scrub/agheader_repair.c | 39 +++++++++++++++++++++++++-----------
 fs/xfs/scrub/common.h          |  1 -
 fs/xfs/scrub/dabtree.h         |  2 --
 fs/xfs/scrub/scrub.h           |  1 -
 fs/xfs/scrub/stats.c           | 45 +++++++++++++++++++++++++++---------------
 fs/xfs/scrub/tempfile.h        |  4 ----
 fs/xfs/xfs_buf_item.h          |  1 -
 fs/xfs/xfs_healthmon.c         |  2 ++
 fs/xfs/xfs_inode.h             |  1 -
 fs/xfs/xfs_log.h               |  2 --
 10 files changed, 59 insertions(+), 39 deletions(-)
