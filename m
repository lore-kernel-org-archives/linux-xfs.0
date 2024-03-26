Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9106A12838B
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422765; cv=none; b=g93Hwh4Jbew+Rk1v3qlbtm5tq2WUkdqLEyA2hnQtDNr4YC40vjBnudKBkESzZZaFJ/XpIDGGoCFNihhHK49W2zypxXmkFnDuNdZ5b6BC1asJf/yDFOgbbWGCPkPuHu2LqeDDGmYxzp8npr4hMmWRWswfTSnvrRAotk/ICFa+EJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422765; c=relaxed/simple;
	bh=Cd/s4RnE4ZemwMxbVzDJVV3/lsfDXmc2/YXBwa8DrJI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D5aCMQVO8W/HJ5L0sfQ3fu6WhaFq4yXwbtHKLyMJ4ApdRlTJ7FcUOdfqM2v+YsRgLM7rN0GY/obeyFXMuffRYDBrx/jAJITDtbQQiHxyeFoWMRAPQ+EfT9du4+e1cAvf4K/Qzk8/HWd+ckGGGSaSWrwxJUO+nsOrz6kG/9KCSJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QSouOg3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QSouOg3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7E3C43390;
	Tue, 26 Mar 2024 03:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422765;
	bh=Cd/s4RnE4ZemwMxbVzDJVV3/lsfDXmc2/YXBwa8DrJI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QSouOg3od603vGFm3Lt8/z2wPqpYdAdSyNqP4T+XwiIXpDOFvqaMNZoiX5darzkH/
	 fGkSXPhTNxoNV9LaiDg6LOQtrXYvda096nhnB8esde+fWuO1ei1SweLb+fq8tHYJYD
	 YLYpZJyMv9GAFNF5vsUw2pFaEt3wn3I9Mp1YsrdUITKdC1KyPaUDR1Umb5bT3hAChb
	 ty1m8FUELxi/gN1s2ftziyTu0Ir4xJXGkuKHjS6uNCk0wuOdcAtgg++z5a1PoBIA3l
	 SebnJKTLJeId/0pqie1IvkDBJnTaxm3HhYKMKHHdzc8f/quGZv18yozfGtCFD90kNR
	 MMtZxcB1riw6w==
Date: Mon, 25 Mar 2024 20:12:44 -0700
Subject: [PATCH 38/67] xfs: set inode sick state flags when we zap either
 ondisk fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127510.2212320.13155966651546513423.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: d9041681dd2f5334529a68868c9266631c384de4

In a few patches, we'll add some online repair code that tries to
massage the ondisk inode record just enough to get it to pass the inode
verifiers so that we can continue with more file repairs.  Part of that
massaging can include zapping the ondisk forks to clear errors.  After
that point, the bmap fork repair functions will rebuild the zapped
forks.

Christoph asked for stronger protections against online repair zapping a
fork to get the inode to load vs. other threads trying to access the
partially repaired file.  Do this by adding a special "[DA]FORK_ZAPPED"
inode health flag whenever repair zaps a fork, and sprinkling checks for
that flag into the various file operations for things that don't like
handling an unexpected zero-extents fork.

In practice xfs_scrub will scrub and fix the forks almost immediately
after zapping them, so the window is very small.  However, if a crash or
unmount should occur, we can still detect these zapped inode forks by
looking for a zero-extents fork when data was expected.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_health.h |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 99e796256c5d..6296993ff8f3 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -68,6 +68,11 @@ struct xfs_fsop_geom;
 #define XFS_SICK_INO_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_SICK_INO_PARENT	(1 << 7)  /* parent pointers */
 
+#define XFS_SICK_INO_BMBTD_ZAPPED	(1 << 8)  /* data fork erased */
+#define XFS_SICK_INO_BMBTA_ZAPPED	(1 << 9)  /* attr fork erased */
+#define XFS_SICK_INO_DIR_ZAPPED		(1 << 10) /* directory erased */
+#define XFS_SICK_INO_SYMLINK_ZAPPED	(1 << 11) /* symlink erased */
+
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
 				 XFS_SICK_FS_UQUOTA | \
@@ -97,6 +102,11 @@ struct xfs_fsop_geom;
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT)
 
+#define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
+				 XFS_SICK_INO_BMBTA_ZAPPED | \
+				 XFS_SICK_INO_DIR_ZAPPED | \
+				 XFS_SICK_INO_SYMLINK_ZAPPED)
+
 /* These functions must be provided by the xfs implementation. */
 
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask);

