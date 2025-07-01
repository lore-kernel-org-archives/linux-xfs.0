Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E5F27F75A
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 18:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751393092; cv=none; b=tgb5lT9SB50VZ+69Md/gmW0jCcSqqkEa4VLKlVMQBWMkMrBMyK+4+FvK6GzaUq4Kw9z9a8yiuP/FjAFCzpPWzu7BJFegstIivx/DE9rM4VqZhhxqmc687oLZ80KbvwovL2EpJWWu5JYFEoAZXHVs5TpSp7+VnRDlA2LBEs0fHb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751393092; c=relaxed/simple;
	bh=lj7og8+cc+svuQxvG3S2Cdoe559Upney2rSdaYNJgwE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z20MThNve48omVLgG5dODD8p6XLeqhqQtQfy9RcIecLuZq6Hbg5vzs0VMaUDmgxMBNlEN9vXvRIcEr5PZ2lXSK8t0sPZHQX0b5YrGcqGfSqBtG00V6wOb7U+uv4cDgD7r1zn0X82pqYJiLFUiNAytiYsWQoo4BBCDuRf6HENFcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfXFIoee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfXFIoee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB711C4CEEB;
	Tue,  1 Jul 2025 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751393091;
	bh=lj7og8+cc+svuQxvG3S2Cdoe559Upney2rSdaYNJgwE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QfXFIoee0qF5E9T2GHLTi+sMEU6ctJs0UIlXbUU3QkvCxlmir62fsKClie/5vO3kR
	 6ab6dQqyFgewEiRrbJSuNZXWAQ7kiq7rqaIDo1jXqtKQB8ajwAySfawSg+0UmdLvvu
	 D8XYfk+KTh45zA2wboeUeLr8RcvrohFv2J9WHFfYxoa1dpjQnJYPUiTqAoE7bDeyNe
	 T8lzEl5Zrb9O/PPRq/pptGIwUkVPoyFvj6+aLERVO0bgKXQXPeQGzSfbgRjj/F0qh6
	 VqDRLM6jpO/Pk6zM2GaK6Ie3lfq5wel4hLMLvfkOn9TC48T1vxQmHfNwiFPTTLyFVt
	 Zqz4nFsaFT0cw==
Date: Tue, 01 Jul 2025 11:04:51 -0700
Subject: [PATCHSET 1/3] xfsprogs: new libxfs code from kernel 6.16
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175139303469.915889.13789913656019867003.stgit@frogsfrogsfrogs>
In-Reply-To: <20250701180311.GL10009@frogsfrogsfrogs>
References: <20250701180311.GL10009@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Port kernel libxfs code to userspace.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.16
---
Commits in this patchset:
 * xfs: add helpers to compute transaction reservation for finishing intent items
 * xfs: allow block allocator to take an alignment hint
 * xfs: commit CoW-based atomic writes atomically
 * libxfs: add helpers to compute log item overhead
 * xfs: add xfs_calc_atomic_write_unit_max()
 * xfs: allow sysadmins to specify a maximum atomic write limit at mount time
---
 include/platform_defs.h |   14 ++
 include/xfs_trace.h     |    3 
 libxfs/defer_item.h     |   14 ++
 libxfs/xfs_bmap.h       |    6 +
 libxfs/xfs_trans_resv.h |   25 +++
 libxfs/defer_item.c     |   51 +++++++
 libxfs/xfs_bmap.c       |    5 +
 libxfs/xfs_log_rlimit.c |    4 +
 libxfs/xfs_trans_resv.c |  339 +++++++++++++++++++++++++++++++++++++++++++----
 9 files changed, 429 insertions(+), 32 deletions(-)

