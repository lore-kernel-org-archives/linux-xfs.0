Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632BA20B81C;
	Wed, 11 Dec 2024 20:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733947649; cv=none; b=XO8og2RoiM5lg/ZkzK/9bjIWdIDyJkO4Cu0L2JffgTNlzmiFobKRdv/PhdqUzUxR2oz7oWtdmZu6Cxls0/Zi1P2vuMIIo7CmWbneeOhRfFP8/jMLjQfKaYqCYCWaBxrhlG4cb1zvktdiHvJcaKBLnyUCL4RlaHvjjp3juhTx1w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733947649; c=relaxed/simple;
	bh=jrwbiRZ2MfqQp3mW8deFdGU/3LLaO4WI3MTeA0thcIg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EtQH4PjhwhshzQetCk9DirjusvnK2R268ChYo/3OUVc8bdc8RTgxyC77Trni1kTooQCXGRz7Fe9b8qL8eqEQRl8bWFJG25TK/z5HkOA+pOSfk7YlgK5a+NIT6P6imvuoAXB8/4LxkQa5v/Bo2pCm45CtCbHnZONAKOu9OKJT3Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q6wVT/HM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q6wVT/HM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A15C4CED2;
	Wed, 11 Dec 2024 20:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733947647;
	bh=jrwbiRZ2MfqQp3mW8deFdGU/3LLaO4WI3MTeA0thcIg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q6wVT/HMIrXhy9jP9Uf9bCHvo5UeqCk0OFPkOEKwEqirRDj0C9Ql33yp+isA1nUZL
	 Tgaccr1bHfq8hXnYfPAx4wo7N6s0rMbQmHmaaXG8eKBLlSIviCBVzh6fWi3Jhmf1HH
	 AEawrmd1bvJFJhfRNSDzdJ2pNUOIemEBs5U8Jq8uWNlPmWsN64O1jYAvXTCkAE3Yb1
	 pU08syFP0d7j0tqQUy5NiGaG5sfMqce/cR6vLSTW4K4wDYXOkcMEwpssw/+4xLYiWr
	 jSKtDZvBofADpm5rwDfM2Sfei6SY93/WJKZrC0rFdpyKW+FzkZxN5XkriwKMldJtxh
	 anyLe/LvtpnAA==
Date: Wed, 11 Dec 2024 12:07:27 -0800
Subject: [PATCHSET v4] xfs: bug fixes for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, jlayton@kernel.org,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173394758055.171676.7276594331259256376.stgit@frogsfrogsfrogs>
In-Reply-To: <20241211200559.GI6678@frogsfrogsfrogs>
References: <20241211200559.GI6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This is hopefully the last set of bugfixes that I'll have for 6.13.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fixes-6.13
---
Commits in this patchset:
 * xfs: don't move nondir/nonreg temporary repair files to the metadir namespace
 * xfs: don't crash on corrupt /quotas dirent
 * xfs: check pre-metadir fields correctly
 * xfs: fix zero byte checking in the superblock scrubber
 * xfs: return from xfs_symlink_verify early on V4 filesystems
 * xfs: port xfs_ioc_start_commit to multigrain timestamps
---
 fs/xfs/libxfs/xfs_symlink_remote.c |    4 ++
 fs/xfs/scrub/agheader.c            |   71 ++++++++++++++++++++++++++++--------
 fs/xfs/scrub/tempfile.c            |   12 ++++++
 fs/xfs/xfs_exchrange.c             |   14 ++++---
 fs/xfs/xfs_qm.c                    |    7 ++++
 5 files changed, 84 insertions(+), 24 deletions(-)

