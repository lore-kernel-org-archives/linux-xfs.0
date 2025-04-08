Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6BD22ACDC
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 16:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744129749; cv=none; b=Z3qkYJi46IEo42Or2xCCzap5bs7aldtdVao5e0tjVUUKmOpc2TNX9AOZKZRmIad9abQypMegeqXQjm1f0HZBXG8glchs5N1keR+3bLx4qo9KMQX3thAjWhh9MC0M994hEiyETvH8ZXQPebGvFw0L4mFbSfxgoEitm46BfSF7UU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744129749; c=relaxed/simple;
	bh=HPUM/87qVYxeNniVyS9mI8peO6z+4W+Oa9In7SQp3fE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=M1GdHWYztZ0gi65oFWBoBx1dY7Co6i3Ge1c62E+OVuO4CxTFUEi2YCZkUIGRSHKsN0/y0JZ4JBOgu670gXtueDl1rvei6ree2rXnoLwHsJySYAW6yywbcHb6q9qn2NPEJ7MIuVLFdyYtA+ewouKsEf//Is4j6zicIBBR0h8TgeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dRU8Heof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dRU8Heof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9B2C4CEE5;
	Tue,  8 Apr 2025 16:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744129749;
	bh=HPUM/87qVYxeNniVyS9mI8peO6z+4W+Oa9In7SQp3fE=;
	h=Date:From:To:Subject:From;
	b=dRU8HeofGrNYm1ytej/513AC8PnH5VEVMLyd0os9z7f+PFrmMqtddF35Poc3bHz4w
	 UkhSlR+vMcp9HcXGC4IYVuETRsx7lYtf/6iTVfbkmizEg+ns1llvcWVUJ1+tTmHxvZ
	 WTUBf5JmSE6d3i6h/+to/+sMgFGkAmqxWgbclvuoA5ybEdONkWYTvPpClxogzAxdOo
	 BLeUk0aS/6kA2Eg9+zEwnFK85M1mnPDeEfH3gvFJFx0ckCH9JbnRCKzfYCZbTEksUW
	 VikEU50o5Y1FSn2SgQXTRmgnnE7kBnPgofASnQHTBdnbzXiZ4ASIrtN+rMgPNJzDLe
	 25Tf7FQvpP2XQ==
Date: Tue, 8 Apr 2025 09:29:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-documentation: master updated to 7d07fb949b0f3a
Message-ID: <20250408162908.GG6283@frogsfrogsfrogs>
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

has just been updated.  You can find a pdf version of this document
here at some point when kup finishes syncing mirrors.

https://www.kernel.org/pub/linux/utils/fs/xfs/docs/xfs_filesystem_structure.pdf

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the master branch is commit:

7d07fb949b0f3a xfs-documentation: bump design doc revisions

4 new commits:

Christoph Hellwig (1):
      [b54ac15f578a78] design: document the zoned on-disk format

Darrick J. Wong (3):
      [f6cb034224a9a0] design: document the revisions to the realtime rmap formats
      [e271e0a698d6f6] design: document changes for the realtime refcount btree
      [7d07fb949b0f3a] xfs-documentation: bump design doc revisions

Code Diffstat:

 design/XFS_Filesystem_Structure/docinfo.xml        |  16 ++
 .../internal_inodes.asciidoc                       |   7 +
 .../journaling_log.asciidoc                        |  32 +--
 design/XFS_Filesystem_Structure/magic.asciidoc     |   7 +
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |  16 +-
 design/XFS_Filesystem_Structure/realtime.asciidoc  |  45 ++++-
 .../XFS_Filesystem_Structure/rtrefcountbt.asciidoc | 172 +++++++++++++++++
 design/XFS_Filesystem_Structure/rtrmapbt.asciidoc  | 215 +++++++++------------
 .../XFS_Filesystem_Structure/superblock.asciidoc   |  25 +++
 9 files changed, 392 insertions(+), 143 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/rtrefcountbt.asciidoc
