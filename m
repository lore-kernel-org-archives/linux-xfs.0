Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9097238C16;
	Thu, 19 Feb 2026 06:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481356; cv=none; b=uQTikPstcz7ZiCeP+yNBWFM0bEDoGzpqXRR4fOswUTxGEmPA7qLmHroyJFTwPlMzkn5ZC1b6ENHOc4P3RaZnMmKoVR5ak+6czY5fCRxk3WTopHx+KTtMEZX8u+4xMEiddvpf/N0gmSMN/EDjIAKcqj8UCWqkCyz+akIFQg1ql+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481356; c=relaxed/simple;
	bh=nE5aXNzRUS3BruGnYSE/bvVT1StFUOHL+l6VB/rRyBo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=sM+qAp278sla81s9dO9WbRweXpPQFMDV2c/Gw1iXK3AgBfkDbFYtQxmPxXnM7qaSA3gpYJYcaRDw5QNNcrXXG70/W6MEsGaWblWfBsTv529wcdzG+GiFI6oF1Lcr6pD9XxmIvnesRuATDr5L4K7vKwe4qgC/0B3rq0vfR1bq/Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSChKKia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSChKKia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D33C4CEF7;
	Thu, 19 Feb 2026 06:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771481356;
	bh=nE5aXNzRUS3BruGnYSE/bvVT1StFUOHL+l6VB/rRyBo=;
	h=Date:Subject:From:To:Cc:From;
	b=RSChKKiaUMn6QFDLSd+/mN1XDPsDae4mgeAGK1VaVCAD1zuZ5qn1Zf6Xd8bqcAntD
	 HArW3R5shG6/ybJMpLE1qz5NPi73CMbBx/9gu9z3BNnNmem+iiueObw4V/5ZkJ3FVB
	 fsGu85eXpBLu9VIbxKC6UnPtELXMc7mVRb8vo6U75yDE41QiipLIVBl7TMmGCtrm9e
	 RuLjFPM2Fz3VV4Seh0QlzzQ+QkBaJSbriIBBh4BGfj+FtVfdJwtSA+NVoPIro9Wq8g
	 ZUFi0O1I0MMw7RLUONmzB661/ULiwE/hsKxo2Eh7ILBRHczNuQ9WLo2dEfXPzga50i
	 Lr1jsQoYrRASQ==
Date: Wed, 18 Feb 2026 22:09:15 -0800
Subject: [PATCHSET] fs: bug fixes for 7.0
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@infradead.org, amir73il@gmail.com, jack@suse.cz, brauner@kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-ID: <177148129514.716249.10889194125495783768.stgit@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vfs-fixes-7.0
---
Commits in this patchset:
 * fsnotify: drop unused helper
 * fserror: fix lockdep complaint when igrabbing inode
---
 include/linux/fsnotify.h |   13 -------------
 fs/iomap/ioend.c         |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 13 deletions(-)

