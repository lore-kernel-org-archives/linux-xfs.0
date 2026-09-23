Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF5F4334D2;
	Wed, 23 Sep 2026 05:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143048; cv=none; b=PmqLfqGnoJqK6MfSBC3tUV5q0Bz7i6SmFjicGxjNWNCUxx1ZSuGdFI2dmNkCjuw0jYxhrk1ogktn93HrcN97KLAtzhV8V/uTq3rMiFkgR9VXDhz3eIdrFqA5d1XLwpYNdSvCSkWXW7qBOIdlLu1EFeKzNUM1lt8rBapUpo4F9sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143048; c=relaxed/simple;
	bh=SaB5jJBF08Pr31lcPuoS29hfJH1VTV6sMgQsyFbnulA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=NqVXTO1M6Kp8VAfaxuC0Jif/0iYNprsROXjdA56edr7kJULK/NpGUYvuvYN3p6w/1uURNeTjFGQrGuo1zYTmP+XodGnPQtGXTtdvyKCGmGSD7WdMcBYiY84shHs9ih/y7C171sakqMHEaxad9YSy06rE8wjujMnj5acR/KzltqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HnClBjll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HnClBjll"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AB28E1F000FF;
	Wed, 23 Sep 2026 05:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143046;
	bh=cD7rWyT8jdb94QVW+ufhgRXYvXtAZ+F0XiILWebhxnM=;
	h=Date:Subject:From:To:Cc;
	b=HnClBjlljFpYTEzEMFQDX0oj4Fi6+gH+6VoM54KDdSLb90cjwqJq4HwCTT32NGU8b
	 urJcReFNdwANoILixGmlRsJwe6UMG/NQ36t2XnZ6qolQhvv9DK4TMktIUFqyT6o0V6
	 22kZzsgmW+pIBWr250tvvlVsB0Akg5tRG3c+bm/uagjMYnDpjEMJO4cL+NYF6lREs0
	 gmBd0MOD1DQKPLKMgO8U0xC9+ODsVSGt1B81QWNb/eEQzKnM7eTlKPY9ZhKg+52Zo6
	 LCjzbCbRPcBUlZ8D0gyFPI1kRWWQI5CgQMT1YRPtP7BJw0m842iW69JSIpz7c4hUHe
	 Wx4uTASF29kdg==
Date: Tue, 22 Sep 2026 22:57:26 -0700
Subject: [PATCHSET v2 1/2] xfs: LLM-inspired bug fixes, part 16
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, dgc@kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a sixteenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

v2: add RVB tags, integrate some review feedback from humans and LOLLM

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-16
---
Commits in this patchset:
 * xfs: fix missing xfs_qm_adjust_dqlimits call in quotacheck repair
 * xfs: online quotacheck must dirty dquot if enforcement adjustments needed
 * xfs: fix buffer overruns in xfs_ioc_attr_list
 * xfs: clean up after failed metafile relinking
 * xfs: pass xfs_trans_resv object to reservation calculation helpers
 * xfs: fix xfs_rename_space_res for non-pptr filesystems
 * xfs: fix ondisk symlink target validation in xrep_dinode_check_dfork
 * xfs: add missing healthmon trace strings
 * xfarray: don't crash when sorting if array element crosses a folio
 * xfarray: don't allow users to unset in the middle of an array
 * xfs: don't allow sorting sparse arrays
 * xfs: simply the free space btree repair code
 * xfarray: warn against sorting arrays with identical elements
---
 fs/xfs/libxfs/xfs_metadir.h                        |    5 
 fs/xfs/libxfs/xfs_symlink_remote.h                 |    2 
 fs/xfs/scrub/xfarray.h                             |    9 -
 fs/xfs/xfs_dquot.h                                 |    2 
 fs/xfs/xfs_trace.h                                 |   28 ++-
 .../filesystems/xfs/xfs-online-fsck-design.rst     |   13 -
 fs/xfs/libxfs/xfs_dquot_buf.c                      |   13 -
 fs/xfs/libxfs/xfs_inode_fork.c                     |    4 
 fs/xfs/libxfs/xfs_metadir.c                        |   30 +++
 fs/xfs/libxfs/xfs_symlink_remote.c                 |    8 +
 fs/xfs/libxfs/xfs_trans_resv.c                     |   38 ++--
 fs/xfs/libxfs/xfs_trans_space.c                    |    6 -
 fs/xfs/scrub/alloc_repair.c                        |   15 +
 fs/xfs/scrub/inode_repair.c                        |   26 ++-
 fs/xfs/scrub/quota_repair.c                        |    5 
 fs/xfs/scrub/quotacheck_repair.c                   |   54 +++++
 fs/xfs/scrub/xfarray.c                             |  201 ++++++++------------
 fs/xfs/xfs_dquot.c                                 |   20 +-
 fs/xfs/xfs_handle.c                                |    2 
 fs/xfs/xfs_qm.c                                    |    6 -
 fs/xfs/xfs_trans_dquot.c                           |    6 -
 21 files changed, 277 insertions(+), 216 deletions(-)

Unreviewed patches in this series:

[PATCHSET v2 1/2] xfs: LLM-inspired bug fixes, part 16
  [PATCH 09/13] xfarray: don't crash when sorting if array element
