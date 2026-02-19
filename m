Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8EA21FF33;
	Thu, 19 Feb 2026 06:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480848; cv=none; b=N01F1tCvp+mI7/CgFoheaeHvY3Jr0Hg7WCUyh/4K3OxJzp3phrbecRIH4QGbzBA+H6uGAgXxoqvy43e/+JdvZmeuq2fLDZI421B3gyGC5phmiVyHpraOfq/aUiHlM3A0A4e4j7wLftNHs6aHYtyIFrs2f7JWajILPjE0Nt7SSkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480848; c=relaxed/simple;
	bh=ycByYo3VrFargZA4slJ9PqgwcdopS0X5eJ6NupY0x1Q=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=H31/pKRXrGu0VXhTebAhm2YcY9O+9euo2ndZ1Gl/QrQVR1FW27qigxdjseOrDkuIFBNXHmxhEwhHtgFNp35fTIEk71dSZxQsmH6l6G3hmWv6/hgyQ/NEoZbrI5jZWpBIaADcUQRVAFRCE12imbRs8Dxy3Zfgs8hJjiHpBWz4oYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4mfvqpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4mfvqpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB320C4CEF7;
	Thu, 19 Feb 2026 06:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771480848;
	bh=ycByYo3VrFargZA4slJ9PqgwcdopS0X5eJ6NupY0x1Q=;
	h=Date:Subject:From:To:Cc:From;
	b=p4mfvqpQwbBd1nP5zFbJJ7dKcy5rbshxB2p3b6ARIsw+2v7GZtHeZUECzEbh+/s8w
	 NvnuhOthLWQBPbvXHWP3b+6mGYHnMl65+4s6Fzz7/HUg9n6dqgbzzkrnJnXNgleNTF
	 P76QhoJ5VycQXP2l2wPAhQlek9ZQIxnWq8l2iqyfGMXQpdTzZW3435jhzPBfy++UU6
	 so4dC5HHaUluXMqW7KZ763fSFZRyUtTI4+cK8Oagz8wNNsUllc6akofKVoZ+8gGARz
	 5jhUzsoo2Z67SfLGbagFWwZ3KKoLmVyTttFAvYHEo/yyY0s6nXqez0jrgXK2Z3Bjz2
	 WNmFI1CWxRIeg==
Date: Wed, 18 Feb 2026 22:00:47 -0800
Subject: [PATCHSET 1/2] xfs: bug fixes for 7.0
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: clm@meta.com, stable@vger.kernel.org, samsun1006219@gmail.com,
 pankaj.raghav@linux.dev, linux-xfs@vger.kernel.org
Message-ID: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Bug fixes for 7.0.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-7.0
---
Commits in this patchset:
 * xfs: fix copy-paste error in previous fix
 * xfs: fix xfs_group release bug in xfs_verify_report_losses
 * xfs: fix xfs_group release bug in xfs_verify_report_losses
 * xfs: fix potential pointer access race in xfs_healthmon_get
 * xfs: don't report metadata inodes to fserror
 * xfs: don't report half-built inodes to fserror
---
 fs/xfs/xfs_mount.h          |    2 +-
 fs/xfs/scrub/dir_repair.c   |    2 +-
 fs/xfs/xfs_health.c         |   20 ++++++++++++++++++--
 fs/xfs/xfs_healthmon.c      |   10 ++++++----
 fs/xfs/xfs_icache.c         |    9 ++++++++-
 fs/xfs/xfs_notify_failure.c |    4 ++--
 fs/xfs/xfs_verify_media.c   |    4 ++--
 7 files changed, 38 insertions(+), 13 deletions(-)

