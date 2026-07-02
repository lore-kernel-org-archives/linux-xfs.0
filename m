Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117123859E6
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 19:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783021300; cv=none; b=h1b72uzNYfuRxJ6ZJPBW8QUcKMVTvh/Va4nky2qVDT13JHj38NoRZZiifBybWsV6W0CBP4iDIPFQeIivIoOS7H91raaVY+1vJpm9l266Y7U9hYRPLu28Wi67qbRM49UUQSKjMSMFIiHuXYQ5u7H/jlrchwuSvmnHfOD848yhnG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783021300; c=relaxed/simple;
	bh=nNG2fdrAbP5M7d461wvcrhikhZXcge9fk+8jev+EyhM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=X80E9gmS+x6DHPKf3oYuw4BFggLAvfDxySTwngFpMH3zRu7SFhJimVwH0w9XtvtPKR1TB9CRIVvNViEcdw5PUvOLu3jF+vhGeUpueigXXKgBTqMjg93gfDiMTGOtG18+Rc7B74DeE4uHIXLPUsjrYUE1DGRq6CFnoPjiV4dMXpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BhqN7jel; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BhqN7jel"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CE9AB1F000E9;
	Thu,  2 Jul 2026 19:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783021298;
	bh=KDObBIiKCuEIKeOjNhm0/M8ZDde4JNyyKCSkkMgvUcA=;
	h=Date:Subject:From:To:Cc;
	b=BhqN7jel+qiojQ5UdJuYTyLQt95g3KDWCPjQPyAdyl1wW0aFY++NHXkKPXIyPQIda
	 YRebswWL3c1d+KhQ1Fgc3XxQMKQTNHOv2e+kKtnz2JpGTvJ8gttDWSymGDz6jHGzAB
	 f9o0e1/8cdJrGRQQHwsuas+ufTLBME5dVtyrq0c38mvpL7p3czyVvrvUjdcU9WUYGd
	 HtsKkcxqNFumCU8A3nrRGOo48SE7RFY6kEz3GPK/taiBVa7Qntn0V8rVzskCRathSA
	 zpAoe/thQHHUzIRwF7HsTwP2xu5UK7YPr2XOfSCWPw9HP3TPcvqPAzPcVFypgvsj+l
	 xhogbLemVd/TQ==
Date: Thu, 02 Jul 2026 12:41:38 -0700
Subject: [GIT PULL 1/3] mkfs.xfs: codex-inspired bug fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178302114822.828394.4589678788668515207.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 7.1-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 7a26df144fadd9c721323a4b0ff9808473d5608e:

xfs_healer: fix getmntent race in weakhandle (2026-06-30 11:51:45 +0200)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/mkfs-codex-fixes_2026-07-02

for you to fetch changes up to b3268fb3d822a7ef7d647284e0dfeaeb61713011:

xfs_protofile: make nondirectory arguments actually work (2026-07-02 12:38:24 -0700)

----------------------------------------------------------------
mkfs.xfs: codex-inspired bug fixes [1/7]

Here's a batch of mkfs.xfs fixes resulting from Codex reviews.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
mkfs: don't redefine DIRT for protofiles
mkfs: fix PATH_MAX check
mkfs: fix symlink target length check in create_nondir_inode
xfs_protofile: make nondirectory arguments actually work

mkfs/Makefile            |  2 +-
mkfs/proto.c             |  8 ++++----
mkfs/xfs_protofile.py.in | 40 +++++++++++++++++++++++++---------------
3 files changed, 30 insertions(+), 20 deletions(-)

