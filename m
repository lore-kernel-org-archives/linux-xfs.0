Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879801;
	b=A26ROR/C1JTKQdLVN2/dD9iIMhCKya/OrVNCTduv3fqSHx1uPiAHnc1xIR3UXvMcuesE
	 u0xLWpf357v0uWjUl7zDtZ6CVYwsRbd2BO8K0xrRARDt9d9Pfy7VMvqZ2GVV7CERAzmvE
	 GSMSQJsjp4/1L32TIUhlbzjeBMg1MVsEzfDvxC4uut7I7+c6+KW0L8zCMRRyqPwYXpY5a
	 +nzH4+azulNWXBUg9wmddtZHuxF2i//AApGz+A5gCEkbG8+fip067b+t56In6fsL3+WLD
	 /cAdox6Ia08dDwwpN0TwBLqgcv9UZE5RlR8nOoF5weGN9JuiNWdl/4msmNFV+brfZfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jWfWtiSRF9ohz4K/V0l41cooucJsu+dpibJLDPYDXkg=;
	b=j6I+xWW+Ku7KPn47zBREYK2OAIgkZS3LfUNnNw6PTjdE2N4V15+gxUEJ9jvo7CZGrFfC
	 A/A1Eiuwm+hA5P/9FY4ZwDnkS0qc711PK+PTzGu43zj9nTE2CqMEiuCPreY35TfKONfiD
	 p2cuXOYd3cudzMN0R/oCkYCeyQtQC3qBLJyyVt5JHl+UT8FO5tvfxZWcve5wloPAVphec
	 nBtwg9D6orczh1N6G+bIqJVbbL674Bxa05RhnmCFrmbGD1AnquvEk/BVCpzECkhe8b1lv
	 cbk8h7cATln8aYml+JpdjmBMRzzSmVKIxenV0Ao3WMxFDimdvMfLrbrLE1TvSpWbG3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AjaW5H+p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884E2606A329;
	Thu,  5 Nov 2026 11:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AjaW5H+p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0671F00919;
	Thu,  5 Nov 2026 11:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879801;
	bh=jWfWtiSRF9ohz4K/V0l41cooucJsu+dpibJLDPYDXkg=;
	h=From:To:Cc:Subject:Date;
	b=AjaW5H+psLSec360G8YGjTp9dQ4N0SAk+L8tN9wncqWl0DTzYxgvn/hGtTXHzfHOs
	 QNfs7PHT3/n1ieFpBsgAq+Ad8aLbAd4WK+TB+Pdp2yBKncv6QSj8pWA0Nx7FZrgXpb
	 YnbqSwrkbE/30RIwBExMTH6zdBIzmw3GQCavbq9/sYMGfJtnWUUVWCQPiyP/6kHl+d
	 IMrAPnfivXIbEqserKVywaSln2M+6CyV4pTEE4+dz9UgqTLiimGPSXO/6IgukbEygT
	 sgMYiVBS0RzFCI0Zy7T+XSY36pDuEKkKgvhMtvzDV5Qs7HDIfNGOyKUYMSrunQ/KaO
	 1KL5jt66feBnA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	fsverity@lists.linux.dev,
	dsterba@suse.com
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jaegeuk@kernel.org,
	chao@kernel.org,
	tytso@mit.edu
Subject: [PATCH v2 0/5] fsverity: lift ioctl() input masking and runtime inode flag to VFS
Date: Thu,  5 Nov 2026 12:55:25 +0100
Message-ID: <20261105115532.613467-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This patchset lifts two things from filesystems to VFS level:
- No-oping FS_VERITY_FL in SET ioctl()
- runtime fsverity construction flag

The first one fixes BTRFS get-modify-set loop with
FS_IOC_GETFLAGS/SETFLAGS ioctl()s, as it does return fsverity flag but
not mask it out.

Testing, -g verity passes for all fs, except btrfs/277 and
btrfs+generic/574.

The btrfs/277 seems to fail due to difference between what kernel
and userspace versions support (btrfs-progs v7.1 doesn't seem to
support latest streams v3).

The generic/574 on BTRFS fails only for 1024 block size no matter
the change (fails on v7.3 too). I haven't checked why.

Changes in v2:
- Return ret in btrfs_begin_enable_verity()
- Include linux-fsdevel

Andrey Albershteyn (5):
  fsverity: strip FS_VERITY_FL from FS_IOC_SETFLAGS
  fsverity: add I_VERITY_BUILDING inode state flag
  btrfs: use I_VERITY_BUILDING instead of private flags
  ext4: use I_VERITY_BUILDING instead of private flags
  f2fs: use I_VERITY_BUILDING instead of private flags

 fs/btrfs/btrfs_inode.h   |  7 -------
 fs/btrfs/verity.c        | 14 +++-----------
 fs/ext4/ext4.h           |  7 -------
 fs/ext4/file.c           |  2 +-
 fs/ext4/inode.c          | 17 +++++++++--------
 fs/ext4/ioctl.c          |  3 +--
 fs/ext4/verity.c         | 18 +++++-------------
 fs/f2fs/data.c           | 10 +++++-----
 fs/f2fs/f2fs.h           |  7 -------
 fs/f2fs/verity.c         | 15 ++++-----------
 fs/file_attr.c           | 10 ++++++++++
 fs/verity/enable.c       | 22 +++++++++++++++++++---
 include/linux/fs.h       |  6 ++++++
 include/linux/fsverity.h | 21 +++++++++++++++++++++
 14 files changed, 84 insertions(+), 75 deletions(-)

-- 
2.54.0

