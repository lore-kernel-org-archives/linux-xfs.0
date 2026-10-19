Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293ED22F388;
	Mon, 19 Oct 2026 02:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792377452; cv=none; b=YKz/LzKYbMUsOBnItOA3A9GPJSN8aNFeR/3bypDOEyMIG4YmhA9dblpmusSmJ6hy76fGiZ4Gmjf72hFVBBlLGJ8xzkCKrAFIsugy+hX1SGyJWvRogLNvG0UOHKFaSOwAE1mlzY82eSUk6hlVj5J4gq7pvbZF9PCkKCmi5aaEbDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792377452; c=relaxed/simple;
	bh=TkH8KN6LIiaJU4JnU3ChbfF2cTiFvm6nT2EnB88xD+U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=E6feG/i24g7ZEXw6w+1KvI4lpRxtaY1M4b6yq6JBs2oljhO06fg23NzPtcVD3qz22nXK/GH7mb0eAAm/izscHOPBi/a4WxbiKHYbkoCmtqT5zqfUo+8YD92BWHMa7p3aPj5d+Fk5hnWkyx9+gFHstwlti+dgCtM+hQEcVlE2jOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGWqxTIk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGWqxTIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935B31F000C4;
	Mon, 19 Oct 2026 02:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792377450;
	bh=8OV6L8m+iCE0AL+70lzJ6KmZ3QSA0HDI4+I9OhsFUug=;
	h=Date:From:To:Cc:Subject;
	b=BGWqxTIk6KDipwu9T2WyauM1dVC9nMZwpZywVUXgun+y95C7XtA796qKX9NojANJa
	 9RjdDAusSHH7Am1EvEVvUqpwNMEJupz9/Jpaq30hi6s3OfrXvZOj7HMI8ra0IcRIA7
	 SDMU2r/qT942Y7W0Bcd2fw/nb8S05zGi4KUZ0H+DZ/9rOZN54RwoAIA+cbTr5IAnZ8
	 wZTsoYkh0lB3Dw2kU6d5O03mwTM3QvwIuC/OdNnrOM4DqfpwQvYG0WtRcgn26l29d6
	 TwXV1yXEXv0bTnZ7Yjzd1OrE9Bd326sx7AHSGqHDblHljQRO5cnYkR6Y+H2vuUdX7e
	 gE87Olhqx75hg==
Date: Sun, 18 Oct 2026 19:37:29 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [GIT PULL] fsverity updates for 7.4
Message-ID: <20261019023729.GC3270@sol>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit fd73f4a6659897191fa0d40695fe370925dd3780:

  Linux 7.3-rc3 (2026-09-13 14:38:02 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/fs/fsverity/linux.git tags/fsverity-for-linus

for you to fetch changes up to f9e450420da2624c93ce9585deebfabb87932774:

  fsverity: hoist statx reporting of fs-verity flag (2026-10-04 19:47:47 +0200)

----------------------------------------------------------------

Patches from Andrey Albershteyn to prepare for XFS fsverity support:

- Report verification errors through fserror, instead of only through
  an unstructured log message and generic I/O error return

- Move the reporting of STATX_ATTR_VERITY into the VFS, so that each
  fsverity-capable filesystem doesn't need to do it. This also fixes a
  bug where btrfs didn't return STATX_ATTR_VERITY in attributes_mask

- Make the VFS prevent enabling DAX on fsverity files, so that it will
  be handled in a single place for ext4 and XFS

- Move ext4 and f2fs's code to read verity metadata from the pagecache
  into shared code, so that XFS will be able to use it too

- Export fsverity_ensure_verity_info() for XFS scrub to use

- Pass all-zeroes hash to ->write_merkle_tree_block() so that XFS will
  be able to implement an optimization for sparse files

----------------------------------------------------------------
Andrey Albershteyn (6):
      fsverity: report validation errors through fserror to fsnotify
      fsverity: expose ensure_fsverity_info()
      fsverity: pass digest size and hash of the all-zeroes block to ->write
      fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
      fsverity: don't allow setting DAX file attribute on fsverity files
      fsverity: hoist statx reporting of fs-verity flag

Eric Biggers (1):
      MAINTAINERS: List the fsverity branches

 MAINTAINERS              |  3 ++-
 fs/btrfs/inode.c         |  3 ---
 fs/btrfs/verity.c        |  6 +++++-
 fs/ext4/inode.c          |  5 +----
 fs/ext4/verity.c         | 36 ++++++------------------------------
 fs/f2fs/file.c           |  5 +----
 fs/f2fs/verity.c         | 34 ++++------------------------------
 fs/file_attr.c           | 11 ++++++++---
 fs/stat.c                |  6 +++++-
 fs/verity/enable.c       |  4 +++-
 fs/verity/open.c         | 26 ++++++++++++++++++++++++--
 fs/verity/pagecache.c    | 33 +++++++++++++++++++++++++++++++++
 fs/verity/verify.c       |  4 ++++
 include/linux/fsverity.h | 10 +++++++++-
 14 files changed, 105 insertions(+), 81 deletions(-)
