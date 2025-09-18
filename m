Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612592BEFFE
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 15:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208207; cv=none; b=KW4GHxxX5T4UktXDXq2RZSF5QWxBJzNKwiXX9bihmVgngU8uRu9Za6gVZAAoX/X1d7cAumItGg6pNU9w4liVAQdpVs5kTD1LPklY1Xf+qdJO9NZ+4KdJq6Rf0XNamAOEDtFGu+ofND/EFS3oAQS5Lk5oovm+OYwszPrZ8dDSU8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208207; c=relaxed/simple;
	bh=/bW4u0Lu2Wad/5N7Gec1Xu1AeQ8tQRIEE+tkxCHHQ8o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KIKkfzNuatTRtmrqYSdJkkOOFlM4r2gvnGTFNJ1wSk8D4swD9rP6vgeiFKjXbyALoocaV1Q31b+rFZhcH18ZKHQ7Mvvd9c+RcjsiC8mOpgvhvvYg+DGsgZhA76d5wRLlQNG+6PjBrWU19lYajdcL7iLdBPalCL5OO1gS7SoYRuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTOM0/E0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTOM0/E0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FFCC4CEE7;
	Thu, 18 Sep 2025 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758208207;
	bh=/bW4u0Lu2Wad/5N7Gec1Xu1AeQ8tQRIEE+tkxCHHQ8o=;
	h=Date:From:To:Cc:Subject:From;
	b=hTOM0/E0SYz+e1MnrSatzvs9nmSCA2qmE/+GyFBnLz3CN+KnlNBzOPKpXl0TR8tRh
	 bnCj6AjElb19aMWwS7CN1gc0eYXtkIh9Mjwnj5RkgjgfGKzydgtpTnDPS3mv+rBe3O
	 xlrsysFs2Jk5qY+PB+VKRMqxLzi5Tr4rM9f5E/8a4Qh2xVy5FESGfuJfcJv2u6HKn4
	 S88otv3AbYkSm3aDwUT1X/rx+QPS6H03kl2iPdGLwdD7w9uypAyyB7PPI6DzTy+x2u
	 3QvFXNRcS29ZXG7r3vJvLb3H8wa+f7VzxUJCZco/NMsLVhi47reiapZpjPVns6tIbt
	 By1iLnoDSHmZg==
Date: Thu, 18 Sep 2025 17:10:01 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: AWilcox@wilcox-tech.com, aalbersh@kernel.org, aalbersh@redhat.com, 
	arkamar@gentoo.org, cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, 
	johannes@nixdorf.dev, lists@nerdbynature.de, luca.dimaio1@gmail.com, 
	yi.zhang@huawei.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to 75faf2bc9075
Message-ID: <efozymij7cwizwc5brkd3owm4dcm7vyxrurwm7k7kmmc2ut7fs@2e5hveznynjf>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

75faf2bc907584acc879accae60a59bd655b6b6a

New commits:

A. Wilcox (1):
      [75faf2bc9075] xfs_scrub: Use POSIX-conformant strerror_r

Andrey Albershteyn (4):
      [56af42ac219b] libfrog: add wrappers for file_getattr/file_setattr syscalls
      [961e42e0265c] xfs_quota: utilize file_setattr to set prjid on special files
      [7c850f317ef8] xfs_io: make ls/chattr work with special files
      [128ac4dadbd6] xfs_db: use file_setattr to copy attributes on special files with rdump

Carlos Maiolino (1):
      [9bd2142c5e35] Improve information about logbsize valid values

Christian Kujau (1):
      [9c83bdfeef71] xfsprogs: fix utcnow deprecation warning in xfs_scrub_all.py

Johannes Nixdorf (2):
      [6cfae337a101] configure: Base NEED_INTERNAL_STATX on libc headers first
      [07956672b784] libfrog: Define STATX__RESERVED if not provided by the system

Luca Di Maio (1):
      [8a4ea7272493] proto: add ability to populate a filesystem from a directory

Zhang Yi (1):
      [7b65201af8a7] xfs_io: add FALLOC_FL_WRITE_ZEROES support

Code Diffstat:

 configure.ac              |   1 +
 db/rdump.c                |  20 +-
 include/builddefs.in      |   5 +
 include/linux.h           |  20 ++
 io/attr.c                 | 138 +++++----
 io/io.h                   |   2 +-
 io/prealloc.c             |  36 +++
 io/stat.c                 |   2 +-
 libfrog/Makefile          |   2 +
 libfrog/file_attr.c       | 121 ++++++++
 libfrog/file_attr.h       |  35 +++
 libfrog/statx.h           |   5 +-
 m4/package_libcdev.m4     |  29 +-
 man/man5/xfs.5            |  12 +-
 man/man8/mkfs.xfs.8.in    |  38 ++-
 man/man8/xfs_io.8         |   6 +
 mkfs/proto.c              | 771 +++++++++++++++++++++++++++++++++++++++++++++-
 mkfs/proto.h              |  18 +-
 mkfs/xfs_mkfs.c           |  23 +-
 quota/project.c           | 142 +++++----
 scrub/common.c            |   3 +-
 scrub/xfs_scrub_all.py.in |   8 +-
 22 files changed, 1262 insertions(+), 175 deletions(-)
 create mode 100644 libfrog/file_attr.c
 create mode 100644 libfrog/file_attr.h
