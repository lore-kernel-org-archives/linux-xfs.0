Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97D9314A60;
	Mon, 19 Jan 2026 16:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841819; cv=none; b=ebr1whWgjOhELdz+w5/VIuAyRZAbbJDRGcl2r1GCTYnNezg3M0yEOKmdFqCc1HxCbH5ZfbzAA14dkGC8LuwkvTXb7NOWFTsBV25eC5JDrt0gDdhSmi7GiJJJqHPNV74/zANpEiTdgTypJ3zhbj1kw93A1Mc8pADbV8x3kfUXt5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841819; c=relaxed/simple;
	bh=Xowcft0xkXz2W3N0nUhU7g4atdzwl1x5G7ysxX9HdPI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jfksYmYuQb/ckskNQ37lLHt+VUlIQuV4mKtZtqjz2Lold+3TUiJJ4gC8WmXQQYKjLc0oDFJU0+Lz/NiNKdOcexJ7nRVz2zwBuoyS8GLQVecR4piGJPQiDkJIRqdETt4qJwL67ZxKR2JWyNagaEfY03NEybI8PN48eAV8fZfGiwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vBT7e/gB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vBT7e/gB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5EAC116C6;
	Mon, 19 Jan 2026 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768841818;
	bh=Xowcft0xkXz2W3N0nUhU7g4atdzwl1x5G7ysxX9HdPI=;
	h=From:To:Cc:Subject:Date:From;
	b=vBT7e/gBTEpG5mu/93ql83CMaWH9Ih+IDrjuf686SiIX33V9YbpFGHhNtOoXMijSa
	 GQYRDPTAtmsg6DEc25s2aG0sgU2KKau8CTW/Abdk05e8jZvOzIpOZEyCGqUs/Q6ScX
	 w7366h6gnlX4oXMruDogeke3W3O0P0GHDleiJMYLDD0bRamAxR7K65OA+fmlYRhDSn
	 mEObSkpzF7V2/f1gseBBIN/MoyLGQDAiy9Xnii32vnI/EqI0iKySQLIsSRDA5ZSIQi
	 IrHgA1BE6i4wqrgZ1jE5kxMbJxUvfwBbE7oZNZdYJvvLYtKQmBugS2EPLJWca4FqZ6
	 VwgZb3Sz5KvaQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	djwong@kernel.org
Subject: [PATCH v2 0/2] Add traces and file attributes for fs-verity
Date: Mon, 19 Jan 2026 17:56:41 +0100
Message-ID: <20260119165644.2945008-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This two small patches grew from fs-verity XFS patchset. I think they're
self-contained improvements which could go without XFS implementation.

v2:
- Update kernel version in the docs to v7.0
- Move trace point before merkle tree block hash check
- Update commit message in patch 2
- Add VERITY to FS_COMMON_FL and FS_XFLAG_COMMON constants
- Fix block index argument in the tree block hash trace point

Andrey Albershteyn (2):
  fs: add FS_XFLAG_VERITY for fs-verity files
  fsverity: add tracepoints

 Documentation/filesystems/fsverity.rst |  16 +++
 MAINTAINERS                            |   1 +
 fs/file_attr.c                         |   4 +
 fs/verity/enable.c                     |   4 +
 fs/verity/fsverity_private.h           |   2 +
 fs/verity/init.c                       |   1 +
 fs/verity/verify.c                     |   9 ++
 include/linux/fileattr.h               |   6 +-
 include/trace/events/fsverity.h        | 143 +++++++++++++++++++++++++
 include/uapi/linux/fs.h                |   1 +
 10 files changed, 184 insertions(+), 3 deletions(-)
 create mode 100644 include/trace/events/fsverity.h

-- 
2.52.0

