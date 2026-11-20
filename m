Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190024;
	b=jk6KTE62wy6dVfk6XpUWDiXuzfxz4adVwtX9u1BG7BCg5LdtZFMgN0P4kHeMfzAkiBLg
	 qQm5UBgBTWHdEzazsdHngj62lQR4vYmlW6l+JUlA+RtQ8DfpH2ZiMjKTjrQBbyg25jK1T
	 QKJ3XL6AnSrIZaCxyb92uOPfFZfEq12qZYnjWPW7MKHAH9VgQxt/HbLSbCPjEZGFxP++2
	 1GnigY6y22Y8pDSlEglxXAu3aNNKkHzM2uQ2LQzvM0uKXRc7/ZM98sDQloYUjwMMk78ue
	 GhMtX34EfJrx2eMG0pxHjLj6tPEoanM/8gzXhKvI7nYBc5rd66hvVvj+Dk1pizFm7Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v+LHSOGcYG6qwjHdgPt0+XZc2oJGKJ+L7kW/ZhoRQBc=;
	b=zLpUkR3yNHxTKamX/ajH4aYQElGzfIKMrOyely8dNTjV4KIFUU+XCRChZHRd9hjgkeBu
	 a4ql0Yzg2g7CLFGQII5fejp7tPASpTW1Fs4BlGOm9UuYllJfwbGkLos6/D7u38vr0p8Vf
	 HO2SqsNWiHInz2uDXz+/CLnM4K59KBw3NQuqCucsQgcj3WrIi684Gwxpnn5XSvu5Eqcfz
	 Ib+CvdYLghcUT8Qm5iFfCW5+dQj//UUHjURYY3cQW8RSypx520r+XQv2htanjpCvNsswg
	 kbY+OJA2b0Wss2wMOtzuEnfCjZyHCoB7n8itsO168UyAh7IUizyRX/3P49FTVt8tgFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DTWV4yfc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC09E606A334;
	Fri, 20 Nov 2026 15:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DTWV4yfc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D3D1F000D0;
	Fri, 20 Nov 2026 15:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190024;
	bh=v+LHSOGcYG6qwjHdgPt0+XZc2oJGKJ+L7kW/ZhoRQBc=;
	h=From:To:Cc:Subject:Date;
	b=DTWV4yfch6T4GKNBEDPtPRjXNy936zjSMDhrGuKJvN/8SwkSNSYDzrCPcYZwfLb3l
	 1slRfaMzRiOXOxdJpAkxti4i6T2MFR3Nv3huXUy/H/jQBkb5ljZe7YtCK9rIE5qYap
	 mh+RxfXvSz5RVEtdOTN3PqKgv9/a9jykomEYe2TrmIIYxFhBg76PlhYbpiq3dSNTmc
	 oIOed94Q+baMMwrVDIjpZoS0xWYmt/adIw0ZFOzTAsJDDKTxlKbZY6XJOurL8F3r0/
	 PxVhTTSv2Nl8tJnJbGWy/yZHAalZgK5QGFuikwrI1iVwJiPw7Ido60UMggXtPTwffK
	 D+Vw5QInfdfcg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "fsdevel" <linux-fsdevel@vger.kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-f2fs" <linux-f2fs-devel@lists.sourceforge.net>,
	"linux-xfs" <linux-xfs@vger.kernel.org>,
	dsterba@suse.com,
	"Eric Biggers" <ebiggers@kernel.org>,
	"Christian Brauner" <brauner@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	tytso@mit.edu,
	chao@kernel.org,
	jaegeuk@kernel.org,
	viro@zeniv.linux.org.uk
Subject: [PATCH v3 0/7] fsverity: lift ioctl() input masking and runtime inode flag to VFS
Date: Fri, 20 Nov 2026 16:50:22 +0100
Message-ID: <20261120155032.187246-1-aalbersh@kernel.org>
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
- No-op'ing FS_VERITY_FL in FS_IOC_SETFLAGS ioctl()
- Runtime fsverity construction flag on inode

The second patch fixes BTRFS get-modify-set loop with
FS_IOC_GETFLAGS/SETFLAGS ioctl()s, as it does return fsverity flag but
not mask it out.

Testing, -g verity passes for all fs, except btrfs/277 and
btrfs+generic/574.

The btrfs/277 seems to fail due to difference between what kernel
and userspace versions support (btrfs-progs v7.1 doesn't seem to
support latest streams v3).

The generic/574 on BTRFS fails only for 1024 block size no matter
the change (fails on v7.3 too). I haven't checked why.

Based on v7.3-rc3.

Changes in v3:
- Add comment that I_VERITY_BUILDING is set over enable
- Revert comment changes in ext4 and f2fs
- Added I_VERITY_BUILDING to show_inode_state()
- Updated comment in begin_enable; dropped -EBUSY
- Added patch changing inode_state_read_once() to const
- Use fsverity_is_building() around ->begin_enable() call
- Use fsverity_is_building() in iomap
Changes in v2:
- Return ret in btrfs_begin_enable_verity()
- Include linux-fsdevel

Andrey Albershteyn (7):
  fs: constify inode argument of inode_state_read_once()
  fs: strip FS_VERITY_FL from FS_IOC_SETFLAGS
  fs,fsverity: add I_VERITY_BUILDING inode state flag
  iomap: use fsverity_is_building() to check for fsverity IO
  btrfs: use I_VERITY_BUILDING instead of private flags
  ext4: use I_VERITY_BUILDING instead of private flags
  f2fs: use I_VERITY_BUILDING instead of private flags

 fs/btrfs/btrfs_inode.h           |  7 -------
 fs/btrfs/verity.c                | 12 ++----------
 fs/ext4/ext4.h                   |  7 -------
 fs/ext4/file.c                   |  2 +-
 fs/ext4/inode.c                  | 17 +++++++++--------
 fs/ext4/ioctl.c                  |  3 +--
 fs/ext4/verity.c                 | 19 ++++++-------------
 fs/f2fs/data.c                   | 10 +++++-----
 fs/f2fs/f2fs.h                   |  7 -------
 fs/f2fs/verity.c                 | 12 +++---------
 fs/file_attr.c                   | 10 ++++++++++
 fs/iomap/buffered-io.c           |  2 +-
 fs/verity/enable.c               | 22 +++++++++++++++++++---
 include/linux/fs.h               |  8 +++++++-
 include/linux/fsverity.h         | 26 ++++++++++++++++++++++++--
 include/trace/events/writeback.h |  3 ++-
 16 files changed, 90 insertions(+), 77 deletions(-)

-- 
2.54.0

