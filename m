Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B231F956
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 20:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753820013; cv=none; b=LHinwU/DGm2Q1NbIfOydQrkoEsthoQU5DVlx7J6YLpNQQFAC/j0UrIM9NhNIIQjoh/s8p/ZFRCodbzAbC9SA7rBdb8V7tjbkb9vuqozuBF7iB7jir03FsU0plPKzLvo88Gb0K+zuInQPD9i8IqYckpr2bXNJAaNrdPCc841GU8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753820013; c=relaxed/simple;
	bh=8jphv2GsizZS6Fg3LKdPQaPgRwku9vW7u0x4NfFswFI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=RaMZ0vLrr3lCoXIHNAxDe4rPmDI6V/O1Eq18vzzK1tJdUzEInd9VoOd4TZRC8YzcH0sKcKX7zMf09s2oaYRnpEc5Fg/p9k8nxuOzniWFUyfPaKREUhQx7S+t0przso9vq0UZdHLF3knuzh/ieihQqDmFQTc7SJjThTuCRbQgdFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mceCkU7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mceCkU7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB15C4CEEF;
	Tue, 29 Jul 2025 20:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753820012;
	bh=8jphv2GsizZS6Fg3LKdPQaPgRwku9vW7u0x4NfFswFI=;
	h=Date:Subject:From:To:Cc:From;
	b=mceCkU7HlQg+1CiXqyIVVc/b/znD4PiB9xJgqp6de2jfXnc3At8Mi4Lw+km8YdOOM
	 9he9L9SFJ8mhVuDCbSwcrzWWxIOXbQaFFgx10bQQ+sIK2KviuQA7kYijNv7kv3NWQl
	 dhBMNal2hpx89dKB4aipuWykXE1MufNKvPgVunF3RfB9W0bTuW85jdmEtQq0NmWqdQ
	 gbRl3DJ/XF9X/p8NcAlTDf6Wyl5GYxzjQmBRhnwcTE9PXECS6uUIr5FfaqoYl3LqNm
	 jr0XKIRt5Fr66px3Xj81ypkyOgoVNtOcONiRAMtKQXaK70ZZTqrf3is+5rxDgvsSGA
	 +zqmI8LR2CzYw==
Date: Tue, 29 Jul 2025 13:13:32 -0700
Subject: [PATCHSET 1/2] xfsprogs: new libxfs code from kernel 6.16
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, cmaiolino@redhat.com, cem@kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <175381998773.3030433.8863651616404014831.stgit@frogsfrogsfrogs>
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

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-6.16-sync
---
Commits in this patchset:
 * xfs: catch stale AGF/AGF metadata
 * xfs: don't allocate the xfs_extent_busy structure for zoned RTGs
---
 libxfs/xfs_alloc.c  |   41 +++++++++++++++++++++++++++++++++--------
 libxfs/xfs_group.c  |   14 +++++++++-----
 libxfs/xfs_ialloc.c |   31 +++++++++++++++++++++++++++----
 3 files changed, 69 insertions(+), 17 deletions(-)

