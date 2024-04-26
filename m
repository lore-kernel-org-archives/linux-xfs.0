Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0C73B290
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168573; cv=none; b=qFiDfqK5RDYf4P9qGD+K/j4hBomX1OaXfPq3Osj/oTxfOLRydm9Mz8y7IAL8D3VO1VSLGxo24dM0Px1nzypAnyKLV4IddvPD1YSGsxLcJeRx8xqhxr8orE+8cXE1ssIlxiB2jOJww+C5OEWTqgBuaNL9kQPjHCxBXM5yfPC9Faw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168573; c=relaxed/simple;
	bh=ZAeie0BqhizVnnmgD4FuucPgIO5gG3Nz+KefeHd8Cd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2uFbx9dCBstxYdkE8zZ85KnXi84iEDX8Ife5R7y/z8dv5/pZSFBghqJoENatCpXQps7LTARZ9banFTYoeTltAS/mgMV895Xr3UShtsUI7vHzWhItxgecQji5K1jkFK0hsZ4wY24skvLAt3enRLIO5jzgQ3bAmxaKp9+8edQiNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ryz8NUKl; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ryz8NUKl"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e5715a9ebdso22928835ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168571; x=1714773371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NrbvPDJfVbs0FiQOsMs7wCJkoN/sO7lxWFpoPiUL0OI=;
        b=Ryz8NUKl+9PJnhN9P9eVGwOxomtt94hVUkKn0yhbO/jbkUYTMiclG0o2kk455CxK7P
         Z1UI2lJbC6TT22D+yWi91RS9k8zRLqFcsUSaPmlLTQunKREb2S01rKFu+c21F40kV8j1
         mn2ZTi/ZekMdVW0lhYATHkoAOya9Q5eMlPUsKdP8c4PA+MJrx2de5KjY9KqHTbBYhU7e
         HogRVDzRuQSWDx+Eb+kLYdlHHWYI1th6pdrCNeGCu9BHmlf6eocIEaLqfpy4gEYiZ6RA
         yJZLr5qDARYYnW0Mmw/r4iYZdX4CEPx9Eso0P+x9NJy+DWNpIa7IhBInY1shYRqD6he+
         OQkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168571; x=1714773371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NrbvPDJfVbs0FiQOsMs7wCJkoN/sO7lxWFpoPiUL0OI=;
        b=solND3fAqR57Izjq1gtXKzjHLr2YjADOnvRQtPKR/N/6iltazR2TX8blyUjKAKr/10
         bz0XYbiDdGhermsQMoLarN+uI8jSq6qRcnLEcfGMb8ZF9VmsJ0XmRqfIFjH/+C7CIKdU
         eO9lZ6VId8VSm6Uv2BiyQ260jf6f1VnVTRQikmE59STKZ5qeyuY+kEV+5hnypX8TMSak
         8IvwwDIqQiir0pkspdBjwVfdBGwGX/oNDKHsXyqcEKqWTj/lP6J1Ukxt4bBc1zYSOmyF
         iAoUO4vkHYsbPTbDLhyDr3I+GQS10ZOjpDcU4r0LY82oSPjCrFjovQeyc5pNrs05aHVJ
         XDlA==
X-Gm-Message-State: AOJu0Ywmtu+Sdoi/tiiOgk78NxVvrr2sikhmu8q8zJqV3ifVltXbaGJH
	MVmOFEG6PwmXHJH5FTgxPp0MiLVKn3kqOVu5smKuXltyThd9Wp66Yo3VIx3h
X-Google-Smtp-Source: AGHT+IFWyGFV1QE6JLjllsEY9l78sJdgWuDBTmba7ogiqleq5UxN5vClSChZtirjbHPG6SfLnIwhNA==
X-Received: by 2002:a17:902:dac5:b0:1e3:e4ff:7054 with SMTP id q5-20020a170902dac500b001e3e4ff7054mr1212878plx.38.1714168570951;
        Fri, 26 Apr 2024 14:56:10 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:56:10 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 21/24] xfs: allow inode inactivation during a ro mount log recovery
Date: Fri, 26 Apr 2024 14:55:08 -0700
Message-ID: <20240426215512.2673806-22-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 76e589013fec672c3587d6314f2d1f0aeddc26d9 ]

In the next patch, we're going to prohibit log recovery if the primary
superblock contains an unrecognized rocompat feature bit even on
readonly mounts.  This requires removing all the code in the log
mounting process that temporarily disables the readonly state.

Unfortunately, inode inactivation disables itself on readonly mounts.
Clearing the iunlinked lists after log recovery needs inactivation to
run to free the unreferenced inodes, which (AFAICT) is the only reason
why log mounting plays games with the readonly state in the first place.

Therefore, change the inactivation predicates to allow inactivation
during log recovery of a readonly mount.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_inode.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d354ea2b74f9..54b707787f90 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1652,8 +1652,11 @@ xfs_inode_needs_inactive(
 	if (VFS_I(ip)->i_mode == 0)
 		return false;
 
-	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (xfs_is_readonly(mp))
+	/*
+	 * If this is a read-only mount, don't do this (would generate I/O)
+	 * unless we're in log recovery and cleaning the iunlinked list.
+	 */
+	if (xfs_is_readonly(mp) && !xlog_recovery_needed(mp->m_log))
 		return false;
 
 	/* If the log isn't running, push inodes straight to reclaim. */
@@ -1713,8 +1716,11 @@ xfs_inactive(
 	mp = ip->i_mount;
 	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
 
-	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (xfs_is_readonly(mp))
+	/*
+	 * If this is a read-only mount, don't do this (would generate I/O)
+	 * unless we're in log recovery and cleaning the iunlinked list.
+	 */
+	if (xfs_is_readonly(mp) && !xlog_recovery_needed(mp->m_log))
 		goto out;
 
 	/* Metadata inodes require explicit resource cleanup. */
-- 
2.44.0.769.g3c40516874-goog

