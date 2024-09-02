Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F284919CC0A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301357; cv=none; b=I98PMRCdM+r0d+tg4iFUd3nxJFSTyt3XB5+3LNYoYYlWSQOVv2LiHTlLBrDlLFuLnCKuQEjM2ARBiSkAQNbPKbTNNj7PK+xV9KSaI0SlwQPogZNo5JOaKaR9ivaiQ/HYZ9QjGSROtNtbmgP2ikpiUdmiDbpAwAZ6Ys6nzd79f/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301357; c=relaxed/simple;
	bh=YFzepLvS/pn5kU+Gjt4itwlpCioh9A2h8zqcdOoS8o0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kQPz9q9xm8lrY6uigNrEZ5ocz9DW0NU65P7z2hJPFllUlgJtc/u3a09rdkfJW7dnXAtyYOfdpiYPfYm59sS3PlD18B1Tn/U2M7s/r/ux/PJkTSaIG+wu80Zzoc2FCEU9FujBoOX2YfQLDw/Wzow7b9IRs0C6fp20RjnUIwNyA1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKHEjR8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKHEjR8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C576C4CEC2;
	Mon,  2 Sep 2024 18:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301356;
	bh=YFzepLvS/pn5kU+Gjt4itwlpCioh9A2h8zqcdOoS8o0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BKHEjR8SB10htB6UcIRZll9e+hzsnJvOiEamz2NBfavZorpdHX6veriXhb+e4WGNP
	 MlvC4fj7Zhbs6grkhb+9CPtnXJX7LChIE9Pbd0y/3JffWu27r5iNP9icjU0YRvLq4P
	 SDsqOHP4pmiGeCVDeC6jCD4V4ksV5vdK0wUeZBcb84vFXE+u9Ih/cqjwj06yWhQdxc
	 oEYo1nvy+LHXtBqqN02kbG3xvzg+v0RR/gDcNmAEA6nuR9lBtZPT0G6eA2RJTsMBYQ
	 wFLgQzLHJAZX7IBa82O/O+McDs/aHuvRxgf25vOUDEBOUZI8Ep2+vuFdUFlKt/z5Sl
	 qKxVJj1TFzInQ==
Date: Mon, 02 Sep 2024 11:22:36 -0700
Subject: [PATCHSET 7/8] xfs: various bug fixes for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, kernel@mattwhitlock.name, sam@gentoo.org,
 linux-xfs@vger.kernel.org
Message-ID: <172530107589.3326571.1610526525006344754.stgit@frogsfrogsfrogs>
In-Reply-To: <20240902181606.GX6224@frogsfrogsfrogs>
References: <20240902181606.GX6224@frogsfrogsfrogs>
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

Various bug fixes for 6.12.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-6.12
---
Commits in this patchset:
 * xfs: fix C++ compilation errors in xfs_fs.h
 * xfs: fix FITRIM reporting again
 * xfs: fix a sloppy memory handling bug in xfs_iroot_realloc
---
 fs/xfs/libxfs/xfs_fs.h         |    5 +++--
 fs/xfs/libxfs/xfs_inode_fork.c |   10 +++++-----
 fs/xfs/xfs_discard.c           |    2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

