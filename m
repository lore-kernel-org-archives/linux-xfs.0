Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8BEBA27
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295377; cv=none; b=oKeQDWb7TsrzXTsWczq12QsZtAgUXvEiTAXg1FmuXFC4DULoiE8WYld7lJMXyZfhLS7kvpWsj9SfLrGMweAqOEfcMjZWfd9oNblxCBiJYYrk+R8+vldGJBJoVE859JVPPvqDOf6KX+OG5ZJkVri0dN5oAB20NMyX+kJgwKVKk80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295377; c=relaxed/simple;
	bh=TwQe0RY3pXX2m3AFgUO/7oeqrMHAsXOFqXwAkvcOrT4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DKIgH68SRQIOetRrl355Trrz8xbjNhZYRaH8I3EcREVGe/RI/qBqoLPH+tt2W1sbzaz8kMm32jBNelenGOyxB+6UsP/jJ4tJQRhBHBMcSduZh1DceHVQLeDaAX98PuXG7d9kaIxbX/0JIVKS6EnIO+77Uet1bLmGYpPBDjGj1oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EF9zPSZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EF9zPSZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B6BC433C7;
	Wed, 13 Mar 2024 02:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295377;
	bh=TwQe0RY3pXX2m3AFgUO/7oeqrMHAsXOFqXwAkvcOrT4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EF9zPSZHiZFP3cCR54tqDt0OrT6Imeiohv309+GlnJQKqp1c7ly1ai4Kmf96LW29o
	 dyQTzB/236cMnf9uOkB0Pf8LOnEegW0nzaN4Ud2Fl7fnPR+BXZiRb5dTnJT/I2CcvH
	 bWTCjlqbmqkMeJRNSV+tfCzO2f1xtxaOlzdIhwBwV0LPTHwBHwbUtFxELGGoS85yxd
	 wMscCjNOj1PJvcRQ+fkKAiS9tLrS4KMSZ0SfYFTqPtHNsY0d5xhtezam0Nx44oqsFo
	 f6yLPyzxG/5S5wB8GdjeLlgrIVxvrOuQ4k4OFi+EXbQ7tk2YggxvFAAhczScydxPp8
	 tst4cqGYTM7KQ==
Date: Tue, 12 Mar 2024 19:02:56 -0700
Subject: [PATCH 38/67] xfs: set inode sick state flags when we zap either
 ondisk fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431741.2061787.10784889103633621285.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

