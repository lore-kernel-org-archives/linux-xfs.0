Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5DD27F73A
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 12:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756383741; cv=none; b=kS2x97lfwyI3jSVhfIKMf0jJzminT24aSGMDMHznaB7TCBpS0nw31tYa6DTPW09DPwEDpelSMOyO0Joe/pUZ+X88vOsL/os/v9w4DYS96NksijnMIFigukSvbDSA2Fo9ztoa3n2z80facrLK30pnKI6CVNF0clxRWAKz2232DxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756383741; c=relaxed/simple;
	bh=ZCh4TP7NRMrVelhROF9faPlokX3vvEbMimBZNAE9nHQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sae1WE2S7x9grY+M2py2flMak3I/WdOd+7DB1CfE8pJUHbdqEDM7UYJ6putuMfxNxVYZS/+J4i0y74MauH9y359fO++9xaM5+9X5/AG0uxG9lf92UeJXts0KxsazOt/EfI3uedm0YYGq0xMvrV4V7LWDqWUeuDktMFWIadGgcnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fvdctsxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fvdctsxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA111C4CEEB
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 12:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756383740;
	bh=ZCh4TP7NRMrVelhROF9faPlokX3vvEbMimBZNAE9nHQ=;
	h=Date:From:To:Subject:From;
	b=FvdctsxzscznOx7GBue65ZZCFA7ca+bd23noDf7q13l0LhAxWICJ2+951bXqcI0sw
	 rFmr9Nqz1j60uRdQ1Lut/RDK5o3hsampwpA5hXa7KrUd1CBR7rMr/xjOSeKS6T+SRc
	 /Z6rZFznEtaoPmCXtXaycaSNxY81Bd4SnAHuPikizNzQ/S7qc1tAkkvmCg/ylCsMI1
	 5QfARp/xjLSH4x6VJOSDw4p6aL40UyBy+6vhYkDlrAmi07uuELA8t6Dl0Ql7MnZdcy
	 ldolGHpjaM5PqX0Z9Bb7S+AcgRWsx5V/uywu86MaCDEQ1hUwxjIxSXNo3ZFoqG0YKo
	 9vyfQtkY1oJCg==
Date: Thu, 28 Aug 2025 14:22:14 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 851c4c96db00
Message-ID: <eaejrzb6qmdm3gjghmemn2l7rnc573bjub46ctcnn3buxcjmn5@qytvlpfvmvun>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

851c4c96db00 xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr

4 new commits:

Andrey Albershteyn (3):
      [8d2f9f5c64f1] xfs: allow renames of project-less inodes
      [8a221004fe52] xfs: add .fileattr_set and fileattr_get callbacks for symlinks
      [0239bd9fa445] xfs: allow setting file attributes on special files

Christoph Hellwig (1):
      [851c4c96db00] xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr

Code Diffstat:

 fs/xfs/xfs_inode.c | 64 +++++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_ioctl.c | 24 ++++++++------------
 fs/xfs/xfs_iops.c  |  2 ++
 3 files changed, 45 insertions(+), 45 deletions(-)
