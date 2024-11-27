Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D02A4689
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666855; cv=none; b=ADFN02qK/GOBqFtRo33Dnsx+S/LMYnZAGCUeV32aDrCW7ClQe1QgzTr6dhZZdImn71MMfwU1TnE/QgX8fXKclVtya2wxm1ZAXsa0MXqJM1y1kCvSgSCIWS6AQmEJ3ibTESDfoB9SaKgS56hhjmOBQVdMqTwZTo2UX0YMWniBEnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666855; c=relaxed/simple;
	bh=DGbX8Sp9yltwWdR8l+QKS85yoeIClfgU618oFikOHb8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Gz6tmqc52jsWGroI6svtE922pD3s7oqz6oWCPoGMaHwmICPV3wWKZvwISe+JyG1X+oYY66aCuHchsDLNzBVlqhcaVpn5h0/fUTdTAfQhzgOwR2lW+SwpeVbBzVTOrMovL1jfhosYMAeOMmDU0Nrw35Ix2oY2kbXu/4n8OJek3P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JOjhxxTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JOjhxxTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA82C4CECF;
	Wed, 27 Nov 2024 00:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666854;
	bh=DGbX8Sp9yltwWdR8l+QKS85yoeIClfgU618oFikOHb8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JOjhxxTu7qmq2l0Bso9v2QRyJ207XTxCWjCj04Leey/qpIvssbq9qFoPoyWS//Xth
	 RVFLGj163U/mhM8KDVCOsCcz54M4zbacQaPk1b4vSEAuduaHjmKET/6cR1dhghgTN/
	 tLIQ8+pSUg7ehCjeRfdJ9aweEwjUAA1tq0lY7gvunW08VP0DJIxpwmALNhuQBe+DSi
	 R8xGN/T2C+z4m3TPoB1XOkNh1uBZ/AboCF3e5i+8nm4aUjt0OnP/BHIu8Y4x4fZNT1
	 /wzs19TRTcH8iSprIcSOqpPZ+geHI3yhpLO5fmqqj/4nJVIp02E+v4CSf6j7MyGrxE
	 BO+bcrKu3wmFQ==
Date: Tue, 26 Nov 2024 16:20:54 -0800
Subject: [GIT PULL] xfs-documentation: updates for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173266663318.996567.5228465764402393420.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241127001630.GQ9438@frogsfrogsfrogs>
References: <20241127001630.GQ9438@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Darrick,

Please pull this branch with changes.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 661d339d50b8e504456d6435ae25246057d21a21:

Merge tag 'xfsdocs-6.10-updates_2024-08-22' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation into mainn (2024-08-22 17:05:15 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation.git tags/xfsdocs-6.13-updates_2024-11-26

for you to fetch changes up to 368784fa00f920518ac686638c163852a477937c:

xfs-documentation: release for 6.1[23] (2024-11-26 15:57:07 -0800)

----------------------------------------------------------------
xfs-documentation: updates for 6.13 [1/3]

Here's a pile of updates detailing the changes made during 6.12 and 6.13.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (10):
design: update metadata reconstruction chapter
design: document filesystem properties
design: move superblock documentation to a separate file
design: document the actual ondisk superblock
design: document the changes required to handle metadata directories
design: move discussion of realtime volumes to a separate section
design: document realtime groups
design: document metadata directory tree quota changes
design: update metadump v2 format to reflect rt dumps
xfs-documentation: release for 6.1[23]

.../allocation_groups.asciidoc                     | 570 +-------------------
.../XFS_Filesystem_Structure/common_types.asciidoc |   4 +-
design/XFS_Filesystem_Structure/docinfo.xml        |  19 +
.../fs_properties.asciidoc                         |  28 +
.../internal_inodes.asciidoc                       | 154 ++++--
design/XFS_Filesystem_Structure/magic.asciidoc     |   3 +
design/XFS_Filesystem_Structure/metadump.asciidoc  |  12 +-
.../XFS_Filesystem_Structure/ondisk_inode.asciidoc |  27 +-
design/XFS_Filesystem_Structure/realtime.asciidoc  | 394 ++++++++++++++
.../reconstruction.asciidoc                        |  17 +-
.../XFS_Filesystem_Structure/superblock.asciidoc   | 574 +++++++++++++++++++++
.../xfs_filesystem_structure.asciidoc              |   4 +
12 files changed, 1192 insertions(+), 614 deletions(-)
create mode 100644 design/XFS_Filesystem_Structure/fs_properties.asciidoc
create mode 100644 design/XFS_Filesystem_Structure/realtime.asciidoc
create mode 100644 design/XFS_Filesystem_Structure/superblock.asciidoc

