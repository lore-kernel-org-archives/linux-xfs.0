Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBA919B5B1
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 23:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731021900; cv=none; b=jjq3L+m6gNEJV9TYGb88VgTeN5uPSWbJJcF5LdVTorOVaaH6JhXRgD1bBs+ARchF79gk/GJdwL3JMZYX6wTdigL2tNT+qSedKFUaq1HCfQ8a/jUQ7EGuKX3NDCZstY/M6b9RvMKTv8lrQrNQqRMty+xLUSzndnYXzfUEEGsP5xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731021900; c=relaxed/simple;
	bh=IaCgT7p15cqHUOFgWUudOoTTGxAh+mXu+VcvFRjAZ9g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gKYUxl0cDPCvRmR67DMgAS8CQ0oRDJFB3bLaHxvyNuVNcHyxw5EQek4JIz0kzcB7nQ9gHMqMCOyCAuIcdIDwOq5n91I6denokOvfuvf7QwqGx7LiRJytG1X+3SIfB6xGgOSD3Kd5g9W/QpeKfOivRSR86XIIWiILlJUphW+W4z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zu1GejRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zu1GejRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B5BC4CECC;
	Thu,  7 Nov 2024 23:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731021899;
	bh=IaCgT7p15cqHUOFgWUudOoTTGxAh+mXu+VcvFRjAZ9g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Zu1GejRStZAd98VUCftIPRfDM+s/4p1KetaCd81YvNTHPoQgFTPDGzMaAgqPBvoHZ
	 JRjwcG8yiqljNBe/D51qj72efLwnqKmEMR+A5sZ0Bq6Fpqca4ZM9s3XDm5AGQDLc6u
	 FfkWMMgGgkNEJO5AXV4PVTdFqmGEGvPLvS9sIUNm5se6i6xL58rs3XtCAh59UrWTXm
	 DQOiPItDBARyS8z2P0nDA6YS7AHNTrIb9kK8Vutr3DXuaFnwqWqRM6Pejs96us+HFt
	 q+M7oUar/+nqDklln8du/ymbpXU9YBXrfUnc6nBXJEeCZkvmZh4LsdS2NOfxQa3v54
	 pWOzRbw8Mtopw==
Date: Thu, 07 Nov 2024 15:24:59 -0800
Subject: [PATCHSET v5.6 1/2] xfs-documentation: document metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173102187468.4143835.2187727613598371946.stgit@frogsfrogsfrogs>
In-Reply-To: <20241107232131.GS2386201@frogsfrogsfrogs>
References: <20241107232131.GS2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This patch documents the metadata directory tree feature.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=metadir
---
Commits in this patchset:
 * design: move superblock documentation to a separate file
 * design: document the actual ondisk superblock
 * design: document the changes required to handle metadata directories
---
 .../allocation_groups.asciidoc                     |  550 --------------------
 .../internal_inodes.asciidoc                       |  113 ++++
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   22 +
 .../XFS_Filesystem_Structure/superblock.asciidoc   |  549 ++++++++++++++++++++
 4 files changed, 684 insertions(+), 550 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/superblock.asciidoc

