Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973C016B3BF
	for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2024 12:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726576204; cv=none; b=KHEITeky12DW9lyuyzM+VhcIQZ7e1HF/PQBGpUhW7TIG4q7D68DOttIWWnOv4Xmlpf0m2lrNRBDM7/jDW1VXvrVMhEC0pY1+tM9S+Mz+Na3v0MvzDFhgJ/5mD8nP6/rYmm+uZkzGIMxC9HOkDuErVTG2wjsz/g2CPL9qbLqaA3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726576204; c=relaxed/simple;
	bh=5qhWv9rjROSSJnhNAUop4dyz0CHA0RgaVgsgLL/HUU8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PuI65D7/hZigM0EGoaaKvxhfXrG5xPoslEUdlOM+CVVYP0X3yRKETrhMArLB041NkAKhTd2b1s+nCVS22bBTY+4qvbuYkfbvHr1zSHBBS7yuyUcT3dGhtMrQcuJt2U+hWVjHBml/x+Gkc2OvqvLIuNW04Q/61g3LKFnTumOTeSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bhvgxmFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bhvgxmFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9D1C4CEC5
	for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2024 12:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726576204;
	bh=5qhWv9rjROSSJnhNAUop4dyz0CHA0RgaVgsgLL/HUU8=;
	h=Date:From:To:Subject:From;
	b=bhvgxmFK9k+A0gPoOWN97B/TIL/BOndy6IoLEVv3z3OAlJKrwJLXE6tb7frLwUpcc
	 CZu3kfamNKY0tNWePeif1lAcgXY1bBM3UaUsHJjaWvZJqMBbFT7yeRU84oTg+oRGZG
	 FskHTiRegM3PuwbaoMvYkXfwaFG0ctDxgihOasqLhMp1vSrU2hQfylcgTV7Hp6srBi
	 YxmJfB3UellbSAH7+XeVd9OFSbA/wNal2O5+cKzwacaFeqN5WkbDrBoFVNTPAxmHwC
	 gvIuYwa1vdsusdoRO7W18Of0BxdkVLK+Vm82jifHQn8TMbTDn1hxs9VOtcqhA3a7DV
	 /jlU5b4LfMdcg==
Date: Tue, 17 Sep 2024 14:30:01 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 19dde7fac
Message-ID: <ymwcteqfgfjeaftumodmt6hbfhbskef2iavgsckrh7jjoutjy2@vd64xfubvz4f>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

19dde7fac0f38af2990e367ef4dd8ec512920c12

6 new commits:

Bill O'Donnell (1):
      [2f0fedf94] xfs_db: release ip resource before returning from get_next_unlinked()

Carlos Maiolino (1):
      [aa9263413] xfs_io: Fix fscrypt macros ordering

Darrick J. Wong (1):
      [71d2969be] libxfs: dirty buffers should be marked uptodate too

Gerald Yang (1):
      [19dde7fac] fsck.xfs: fix fsck.xfs run by different shells when fsck.mode=force is set

John Garry (1):
      [871d186c7] man: Update unit for fsx_extsize and fsx_cowextsize

Julien Olivain (1):
      [baf5cde86] libxfs: provide a memfd_create() wrapper if not present in libc

Code Diffstat:

 configure.ac                    |  1 +
 db/iunlink.c                    |  5 ++-
 fsck/xfs_fsck.sh                |  4 +--
 include/builddefs.in            |  1 +
 io/encrypt.c                    | 67 +++++++++++++++++++++--------------------
 libxfs/Makefile                 |  4 +++
 libxfs/rdwr.c                   |  2 +-
 libxfs/trans.c                  |  1 +
 libxfs/xfile.c                  | 16 ++++++++++
 m4/package_libcdev.m4           | 18 +++++++++++
 man/man2/ioctl_xfs_fsgetxattr.2 |  6 ++--
 11 files changed, 85 insertions(+), 40 deletions(-)
