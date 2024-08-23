Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34475111A1
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724373132; cv=none; b=NyEGG7oVBx0QjN9yn6MKTNQfSCZ1FMN/Winr7dfbry3r3+WFbHYHIcwrmlJ5bdH28ZodftUPYRnytNCCN1AGQC6NeTS9QfmXkVJgGjOP9azo7f7ZKFoCGnx0siLr2AQCiNQ7QTCf19nPQ52QNFBB2bmEhCzYKTGMEXZjNzu50XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724373132; c=relaxed/simple;
	bh=AShGbdcQ4mhV1q6Fp9rG62EYQLLWWkN+nY5e3wVMwrI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cValxy2y8t2VNZ3oRiWbtfgkTrss/q+KnvxzOOXgXwm50gF2laAvpnvJoBjfxAT4MGgPRzxl0jb0d3X5xC5gDFk8BXco19NBtpBDHF74ezFrnm/AdFKmUfRIjbcCuFL/Y6V1e25qdom3WaeqfnXCpbotZdn9FB7gkUSLVMD49oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sZ0xHSdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sZ0xHSdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC487C32782;
	Fri, 23 Aug 2024 00:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724373131;
	bh=AShGbdcQ4mhV1q6Fp9rG62EYQLLWWkN+nY5e3wVMwrI=;
	h=Date:From:To:Cc:Subject:From;
	b=sZ0xHSdMvKHE0GIEEJCMPRy/rtqFKv9iKgwBOGV/DwF8JXOGSkRkWx8TpAO9NmER4
	 kdtWk6VYvPHOXrcJqgRJbbK/6rYRTBOMnSY06mkSYgjB53BMBncRLeAJ5cyoAJ9wIZ
	 KFLKn+/lVx5y4FQJsAE/iIC9PCdSXyEg/Dm7Pn08bQNsWAG3Ileqj7M31LjwHA9/Kz
	 So67rx63/RK5sdt1JPL4I1NNZKvqGhKKzolDL8D375+AO0StftTU8lj3mxqG9+3p0X
	 EChvLe1xMctO9qrScnsTBRkdPivQK8vas8rs9tZPqSF9S83ockr8FTP47WE5m9602r
	 nDtNcYdLEd/tQ==
Date: Thu, 22 Aug 2024 17:32:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-documentation: master updated to 661d339d
Message-ID: <20240823003211.GY865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The master branch of the xfs-documentation repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

I have updated the pdf:
https://mirrors.edge.kernel.org/pub/linux/utils/fs/xfs/docs/xfs_filesystem_structure.pdf

The new head of the master branch is commit:

661d339d Merge tag 'xfsdocs-6.10-updates_2024-08-22' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation into mainn

6 new commits:

Darrick J. Wong (6):
      [a1fea3a8] design: document atomic file mapping exchange log intent structures
      [ff9995e7] design: document new logged parent pointer attribute variants
      [2e8458c5] design: document the parent pointer ondisk format
      [4d6cdd07] design: document the metadump v2 format
      [3ecf3b36] design: fix the changelog to reflect the new changes
      [661d339d] Merge tag 'xfsdocs-6.10-updates_2024-08-22' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation into mainn

Code Diffstat:

 .../allocation_groups.asciidoc                     |  14 ++
 design/XFS_Filesystem_Structure/docinfo.xml        |  32 ++++
 .../extended_attributes.asciidoc                   |  95 +++++++++++
 .../journaling_log.asciidoc                        | 177 ++++++++++++++++++++-
 design/XFS_Filesystem_Structure/magic.asciidoc     |   2 +
 design/XFS_Filesystem_Structure/metadump.asciidoc  | 112 ++++++++++++-
 6 files changed, 423 insertions(+), 9 deletions(-)
