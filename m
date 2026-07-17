Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FC5344DB7
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 19:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784316268; cv=none; b=khhp0ARBBiGkokCIeHsJFEUjx1rL9/oc9wIoyPTMlCar4xcB4ejPIIoJveLzC84AZA3Ij8E6WTk6l8Zi6hQVfTl2zF//hmIKoWovnMKkXdSN18pATKMRG613rhBZYxB+EvAr6CRSd/XAZtYaP3FYQdc6x8of99WPHm70UKnfibc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784316268; c=relaxed/simple;
	bh=i/WgzP6lZuuyNEtMaJY/UWvIQ5UI8hty7FfFBAOERBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qH4KEOODvXaZR1pI9TRTlxlEGoebmLNNHgVB0N3gAJ52wlVtxxK33tDoaYvN6y82HsA5RA5BFOV+GXlAnRV1N3xSstFnO2jAUKb9ChuKkWwpFJAN/TF4mKhYUhOdzSoPdbmMdvfMkWhfECNtHXdVxLYsYg1Cqy9g8ZwF46NMjOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hLk0U/2Z; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hLk0U/2Z"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c999f162c9aso5181637a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784316267; x=1784921067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VBBh4eIvoYVVWqSs1HTvVBO2wVeUL8KYjFpGqJiymeQ=;
        b=hLk0U/2ZIOqtbfgfA4YhQKqPWIY7gcw0WgPQH92qfamRDYwg4c2390WffYrYfd7Brb
         Vz37MlvCVHTeTsjs6hE5bFGhQqW0uGt51dMBLQ28enfVrJU/agE8gB4Ok8XxBnNHYhb4
         N0Hn5dX6cnxySiAs6NjEx4d7wD0gYCySGfzO/lA1mq8XqOmVvw4+hlXHkn5WyacBaVC1
         UfE6enmZZcOjyR+zK16pd116/Iitb1PUleyhBM+hMc1ffB+40k2aTqIeaP5q8o2RL77n
         GP74VoiCnJYaMJrfdUfXu01EYdhAtdscvXgeR2Zgje8OkVRMzwwRg2S5cqHO15HdKdaj
         A2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784316267; x=1784921067;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VBBh4eIvoYVVWqSs1HTvVBO2wVeUL8KYjFpGqJiymeQ=;
        b=ThWsI2Cg75iMVnADcuv4YBtF0kYE12gRkJyCITLFOpCtqJu1CDttQoQ3AbhB4RMmEG
         8Hys+NNWYOn5C6q2SRAQA5JHjEv6qVlGkejxLAt3v8yHnIrASTXM+DFXNusPSQFTBYFU
         GU7djiywNOLswSC47KxJfeTDpzoUzYKkcUoDhRjWIt6JzzIEFeTSof/EwefLmzTwAYjx
         aPT75hXWhYEN9O6dYnJuF1B6x/upcQ/mYUDaWZM0UT/VXPg7Lji7phulzmig36N+l/tg
         iMPfhnQDiI2MC3hi3mRAn/z7MhrfMpKAJdIzPSVHJ/DEVQP+u7RkQSrOX5J7HBGlctB3
         XYIw==
X-Gm-Message-State: AOJu0Yy9NlF/00JEX4YB+EbsZva2hBxuU6gFr157m1Y25SYRs3/NvcHX
	O6H6sItZa5NzRx65cZDP+0IKEgipZn6nxROms/MRSlQmRaqwxHFLuY8Q
X-Gm-Gg: AfdE7cmJa1UmgPbFZgthzLz+YK6UxywZSxxlPYxkS1aa3dBIw1uPqid+nm+O7E8/ILa
	fn3tEvF02ICS+SEfT2ZUm93CLfQuIyI9rvKdoTyTGHhyLS88oYTZ7jjNjK0X6/LcOxsVhfHSy7z
	2UOaW/gwyi4hyPdmHageYViOZ1aCBO51VGKfIyfX2YaCIBiJNjkE0Wrxjrk+5gPBNFubEfenjYY
	k9BvszR9zjVXE8vgzfDFJ12vbOo543xvUVE0jI8XV5ojQXDzulZQ7XNJWuoBsrJq5DxfEWA6mvR
	9KPT+S8vQe4zj6Mt6hdbhWg+fE32nj0aiflYqzOnBhq3oDJx2i/+YPLNxX1wNrbJ4CIvO1ZHRVr
	vkEwkLIRaLpmfQ0hdUZo8kigJaN9Pi1QkXLCWQofr+J/UnmXXHSvESZCqKoVVf/fHrp9Z3D1TN5
	t3PlB5iYgE2aeYzWdJckVpPIMmTVMYRLRyGPUEkrC/dC8WmwQ=
X-Received: by 2002:a17:90b:2703:b0:37f:9cdf:f0ab with SMTP id 98e67ed59e1d1-38e4b53898fmr3984171a91.26.1784316266648;
        Fri, 17 Jul 2026 12:24:26 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm18648783eec.21.2026.07.17.12.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 12:24:25 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xmei5@asu.edu,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH v2 0/2] xfs: add a log item verifier pass to recovery
Date: Fri, 17 Jul 2026 12:24:06 -0700
Message-ID: <20260717192408.109168-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1 added the missing region and structure checks piecemeal in the pass2
inode decode. As Dave pointed out, that mixes validation into the decode
and replay code and is hard to audit. v2 reworks it into a verifier pass
run in the pass1 scan.

Patch 1 handles the generic part: an item not logging all the regions its
format declared is a log format property, not an inode concern, so
xlog_recover_commit_trans() rejects any such item for all item types. This
alone fixes the reported mount-time NULL deref.

Patch 2 adds a ->verify() method to xlog_recover_item_ops, called in pass1
for every item, with xlog_recover_inode_verify() as the first user, and
removes the log dinode checks it subsumes from the pass2 inode decode. The
checks that need the on-disk inode buffer (its magic, the LSN/di_flushiter
replay-ordering decisions, di_mode/di_format consistency, and the final
xfs_dinode_verify()) cannot move to pass1 and stay in pass2.

Scope: only the inode item is converted, and only its self-contained log
dinode structure. The btree-root fork record count is not yet bounded
(clamping xfs_bmbt_to_bmdr() and the rt converters is a separate fix), and
the other item types can grow their own verify() the same way.

Reproduced and regression-tested on a crafted dirty-log image under QEMU:
the crafted item is rejected in pass1 with the mount refused (EFSCORRUPTED)
instead of crashing (20/20 runs, no oops), and log recovery of a
filesystem populated with a range of inode types (regular files,
directories, symlinks, hardlinks, xattrs, device nodes, and a btree-format
data fork) is unaffected.

v2:
- Moved the "all declared regions logged" check into
  xlog_recover_commit_trans() as a generic check for all item types.
- Reworked the inode validation into a pass1 ->verify() hook on
  xlog_recover_item_ops, and removed the now-redundant log dinode checks
  (magic, forkoff) from xlog_recover_inode_commit_pass2().

Weiming Shi (2):
  xfs: reject log items with missing regions during recovery
  xfs: verify recovered inode log items in pass1

 fs/xfs/libxfs/xfs_log_recover.h |  3 ++
 fs/xfs/xfs_inode_item_recover.c | 87 +++++++++++++++++++++++++++------
 fs/xfs/xfs_log_recover.c        | 16 ++++++
 3 files changed, 90 insertions(+), 16 deletions(-)

-- 
2.43.0

