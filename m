Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3012238C1B
	for <linux-xfs@vger.kernel.org>; Sat, 25 Oct 2025 09:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761384777; cv=none; b=ElcvvmG7uh/au5tDDYikdS0jRHGS07bGHGylR0pOg3OzbwCZb/DX/4ajOfEFiZ58bgL3eUMWljr0HXgb9laRIJsOiiZwrrJVi5V3B17TSkTOVMuXyt1gpEKrjjZ+cD+3YWDBhtDyaevoa9A3/hlUoDcIRxe7DtEo90ZadotWSks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761384777; c=relaxed/simple;
	bh=KOlx1RCXB9BW5iQY0QLGzuKBLqGyprgkVy1Pnbsb+80=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CUTTb85pO+eEQEdelCMnqErbT8oHu/Q8KphLp2VaQzqKcrlnoE9ugLgpwVCwiCpzDbhQfvrkA/2E0Ces3CBz9/k3Ok9EPBLXbvWEI2PcsuwpZEANApgGA6q6bypA72M34oglQe1p+S04xNtUmAnw5GDHRwHt1A3pH2MycQPJ84w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nqD7LBVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nqD7LBVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2DBC4CEF5;
	Sat, 25 Oct 2025 09:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761384777;
	bh=KOlx1RCXB9BW5iQY0QLGzuKBLqGyprgkVy1Pnbsb+80=;
	h=Date:From:To:Cc:Subject:From;
	b=nqD7LBVyBFBlg7lPJ2BUhsM4C/u3Ri158x62MI+CragRxzsy6YoyP5E8B8sNeoBqo
	 O/x6X/kSjjeScqd1iKMyzAP+FFPBbLJFtR/kfKc+Xif9Z4bLSaeGF02l+U5EZNiBL4
	 T+W7C0eqSXlQKB6Pb3NphzooBjr1zZnPPwWSmQHDL4OuTKwc2aq4HBvevMXpu/Rce0
	 B7HsLwao6snT87ziAHlO95dESIE6eJZMYFTTZqBr4Yp8BTlUs7VU/o7LxaVtVcethK
	 niorELDIT1no5didsVoEmJ1FArJdKYuNmWZTIqIO8tJUH2ZYbxMk9O2VVCM43HpuOy
	 drmtMXVbg/aQQ==
Date: Sat, 25 Oct 2025 11:32:53 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: fixes for for v6.18-rc3
Message-ID: <pg3ebhfwryenhfnhuhyfqjvs37ivhpqp2ijvhfjbih3c3zyxio@mr2a44csgwzv>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.

The main highlight here is a fix for a bug brought in by the
removal of attr2 mount option, where some installations might
actually have 'attr2' explicitly configured in fstab preventing
system to boot by not being able to remount the rootfs as RW.

Besides that there are a couple fix to the zonefs implementation,
changing XFS_ONLINE_SCRUB_STATS to depend on DEBUG_FS (was select
before), and some other minor changes.

Thanks,
Carlos

The following changes since commit 211ddde0823f1442e4ad052a2f30f050145ccada:

  Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.18-rc3

for you to fetch changes up to f477af0cfa0487eddec66ffe10fd9df628ba6f52:

  xfs: fix locking in xchk_nlinks_collect_dir (2025-10-22 10:04:39 +0200)

----------------------------------------------------------------
xfs: fixes for v6.18-rc3

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (3):
      xfs: avoid busy loops in GCD
      xfs: cache open zone in inode->i_private
      xfs: don't use __GFP_NOFAIL in xfs_init_fs_context

Damien Le Moal (2):
      xfs: Improve CONFIG_XFS_RT Kconfig help
      xfs: do not tightly pack-write large files

Darrick J. Wong (4):
      xfs: don't set bt_nr_sectors to a negative number
      xfs: always warn about deprecated mount options
      xfs: loudly complain about defunct mount options
      xfs: fix locking in xchk_nlinks_collect_dir

Geert Uytterhoeven (1):
      xfs: XFS_ONLINE_SCRUB_STATS should depend on DEBUG_FS

 fs/xfs/Kconfig          |  11 +++-
 fs/xfs/scrub/nlinks.c   |  34 ++++++++++-
 fs/xfs/xfs_buf.c        |   2 +-
 fs/xfs/xfs_buf.h        |   1 +
 fs/xfs/xfs_mount.h      |   1 -
 fs/xfs/xfs_super.c      |  53 +++++++++++++----
 fs/xfs/xfs_zone_alloc.c | 148 ++++++++++++++++++++----------------------------
 fs/xfs/xfs_zone_gc.c    |  81 ++++++++++++++------------
 fs/xfs/xfs_zone_priv.h  |   2 +
 9 files changed, 193 insertions(+), 140 deletions(-)

