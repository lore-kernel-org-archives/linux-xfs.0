Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4114A18
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666682; cv=none; b=Cn5EdN0FWNao65EA2T58n8QCFh1YTTaoTtEHjMPGEvTlikPUa3NZ5D8m/szU0VH0yWlQtT5iE1AKzq2BB37ec8PNMzDizJvkWmtzvQLN94AXcHK0xSC0SBFeRvIdb7FBHNnHiyGGS+1uLMXeZBRaQd8m3ZO2Rt6A9thJOZwhzQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666682; c=relaxed/simple;
	bh=+iqDAn2f0FCzZUL+1BXeybLWXfZE4okhPKwlBqmHXmA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SvbUT10gzCzRde2dJYE0H9C6BP9pympuQu4lnJnEikIy2M2HokoEtBxsjmZ2EOMd/BdI4ELtxeaW0iD64FXbh1j3lXIQukCGTMeG4YCWy2lnbRGsa8FibTDmQGcw/JqRa5MHXjTRnV6O3kpYEeJsUK/b7rgTR+O4R62c34t4rcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZW/woZ9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZW/woZ9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEF9C4CECF;
	Wed, 27 Nov 2024 00:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666681;
	bh=+iqDAn2f0FCzZUL+1BXeybLWXfZE4okhPKwlBqmHXmA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZW/woZ9Fq+3AfJ5dJdjxH2EgEFkCtW2NxOS5y8Pv/EZmIWBVf+hUkuwhfbQGwZdti
	 y1DUpx3eRUbdJVxvwGqSE5ITa+mjOtJYqI36X62bAlivWVWPXJE7Wn54ylPKNDNtCc
	 i4TXkcZpAckJ5RhFijVyMGxSpCLTbevZrs5B3Cb1KlKRG1ZXqirBa6uywNvGDDOl8L
	 vmMgSVQOvVP5s+BzcJiQ70Ks1sIaLJu8hESwhPo9+frRXrZkTxU7efKwkK/MyT/a22
	 mpxwuu59S1m34iPMw/T93dxm54DthTk4Cxw7LBJ/SJE8dl+fl4dwjMC5/tozlbf6Ef
	 986x+s+J/TjhQ==
Date: Tue, 26 Nov 2024 16:18:01 -0800
Subject: [PATCHSET] xfs-documentation: updates for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
In-Reply-To: <20241127001630.GQ9438@frogsfrogsfrogs>
References: <20241127001630.GQ9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a pile of updates detailing the changes made during 6.12 and 6.13.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=xfsdocs-6.13-updates
---
Commits in this patchset:
 * design: update metadata reconstruction chapter
 * design: document filesystem properties
 * design: move superblock documentation to a separate file
 * design: document the actual ondisk superblock
 * design: document the changes required to handle metadata directories
 * design: move discussion of realtime volumes to a separate section
 * design: document realtime groups
 * design: document metadata directory tree quota changes
 * design: update metadump v2 format to reflect rt dumps
 * xfs-documentation: release for 6.1[23]
---
 .../allocation_groups.asciidoc                     |  570 --------------------
 .../XFS_Filesystem_Structure/common_types.asciidoc |    4 
 design/XFS_Filesystem_Structure/docinfo.xml        |   19 +
 .../fs_properties.asciidoc                         |   28 +
 .../internal_inodes.asciidoc                       |  154 ++++-
 design/XFS_Filesystem_Structure/magic.asciidoc     |    3 
 design/XFS_Filesystem_Structure/metadump.asciidoc  |   12 
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   27 +
 design/XFS_Filesystem_Structure/realtime.asciidoc  |  394 ++++++++++++++
 .../reconstruction.asciidoc                        |   17 -
 .../XFS_Filesystem_Structure/superblock.asciidoc   |  574 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    4 
 12 files changed, 1192 insertions(+), 614 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/fs_properties.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/realtime.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/superblock.asciidoc

