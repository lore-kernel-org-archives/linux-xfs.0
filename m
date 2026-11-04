Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793821595;
	b=p666u76xCQMMziL7/dWWEMzNkuloIcyQRiqduPOvKWE7WWPqXqygEgOaFxKo19Gysx/O
	 ms8H9wcrG99yNEL7MWxvpo+JLdLewy78G8t3yFxlVqad5oNqjiMXxXj38bPe/pFd1jl6A
	 uMgCsHxwyIQY9dp5te/GRxPkjdZeCw2kVxiVOl0H3hqGwCXWWgTb/tRyYMLtm3FWJ2CRz
	 lroN/E8eEfBcpQgIL+p1aOeSqM7GfYwcAvU8o356fKsSjdzRF43vP3Y0gDu/zSElwq6XF
	 UGH7AefYgQC83q3N+2RGaFp0kkU0W6QgRTg7jhAYzaMdmjLsqhQPmlgaE+UkuJuIyhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lk0nkB20UHBUlsaMLEKO7TkV1KlMrxKnvx5Pki3dFMQ=;
	b=gT3vuhbF808J3fS6T2spkmW/FUfL3gO3yPElBLhQIzppeUtbhC0haUBtt6cIBkgKunc0
	 hCX4/K9wtvdOTPGrfVArR59JDBz/kE9pdtbFIJbD7GqC9C8K8MsfoCg46KhS+b9vkrteg
	 uE8ckQaBtavG+kODSA0eUxYiiSxb1WBhWo40B0JOWuuS660jVRQw0SUUxR+Ig0liHgvnH
	 kDMIKUtjGHC3tWYielk0kRO4xBo5hT0sOQY2kmRVOzqNBCakMTLBQCK4U36hLOvliy1wy
	 B596hnqbOqPSgyFpt7A00G/5Oc5l9q6HZE2IcGLhpzDQSJXi1iYDJ57GKBhKynmqAEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="VGoE//p+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5595960C9995;
	Wed,  4 Nov 2026 19:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VGoE//p+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033011F00A1B;
	Wed,  4 Nov 2026 19:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821595;
	bh=lk0nkB20UHBUlsaMLEKO7TkV1KlMrxKnvx5Pki3dFMQ=;
	h=From:To:Cc:Subject:Date;
	b=VGoE//p+hHXdD4a0I3SvmaBjEUrpDbFTIFmmepkyAZ4G80jODd/8MjIyoYzYFskCX
	 PFvn4kpUR3NyJKUYLRpFEhhWjBvZwsynVHqUXqn4w2SxeWB5QSXhYnCJ+van7KNVyv
	 UAyhZQ1xFTrmdhL+/Hrtx9hTibL8Nq2v8X4lj/rxwX1ZyKW0ZWjvEA3h4wGDLmzc9P
	 yKmIiD5dt5VHTNMVu2boYQsT0YX1LWhFs1C8EIV8GUIKzAm4lY/4rI0PM3l0nCWsnO
	 8frEcXyAP+7IckwtN8ka8x8Ircb29uVM2g63lQp1iDd449GrAExAnzyFj+hBuNNEGI
	 /dYklvs3rgWIg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	fsverity@lists.linux.dev
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org
Subject: [PATCH 0/5] fsverity: lift ioctl() input masking and runtime inode flag to VFS
Date: Wed,  4 Nov 2026 20:46:09 +0100
Message-ID: <20261104194618.103332-1-aalbersh@kernel.org>
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

Andrey Albershteyn (5):
  fsverity: strip FS_VERITY_FL from FS_IOC_SETFLAGS
  fsverity: add I_VERITY_BUILDING inode state flag
  btrfs: use I_VERITY_BUILDING instead of private flags
  ext4: use I_VERITY_BUILDING instead of private flags
  f2fs: use I_VERITY_BUILDING instead of private flags

 fs/btrfs/btrfs_inode.h   |  7 -------
 fs/btrfs/verity.c        | 12 ++----------
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
 14 files changed, 83 insertions(+), 74 deletions(-)

-- 
2.54.0

