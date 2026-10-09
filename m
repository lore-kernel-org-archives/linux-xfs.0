Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7751035C6B8
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589914; cv=none; b=VV3hFUOfVrZui/GyQ4pw9YxcKJdMM8XRJq2+RFIuhQbZaKnhwSJfHmhSC+EmaIJc01IfTWihy6exncTpt6K5PL3Dp1AlCR9vjj4/m4IG4fGuiX6wSBTkSzE2vI7EN4ZX5qGkL/LyoH24ddeu7zLSRPP55Pj9ivizgkSujLsiBTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589914; c=relaxed/simple;
	bh=ZT5YkLG+F+KbFm96kDUqLVS9j9mPDOhUO3J4UXcdjdI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M28KOEHIP18yGeq0KQh0zanfpqDiw1zD04kUXo52dx36N4g1dMOvXC28RTcSMgwF3AF9qisxoMxhGW2EtUvAODHM3sAnWtX1kjwWzaiE91/iF+1G/2PB7EpSjWzG6rRBxyGvOg4W9zV0EesjmrU4/L22ZTyDYCfz4Qeymf4ucBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IqwsQS6p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IqwsQS6p"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 495DD1F000FF;
	Fri,  9 Oct 2026 23:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589913;
	bh=QY4TVPcqH60roeQDbBI5MqRgmxhN2JZMI5NaMCeI6NE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=IqwsQS6pJsMXTPCXCxQyfGpA9c99eykuDp7GTd7xvDpp/morAKX81NqqiSDSL7MsD
	 hY0KRofkX/UemOtNflQNXeiIp8CvRVPzsFrv57NDeP2KSWTIb+sVKyoKUeZr0H4Kvk
	 br/MgWldUEzXZp8GdHR8fVzvRfJ+zYw7YSrCFfx/jJioFnE9wAcdVfVxgoUHKBwHzW
	 ojPCYfh935hJ1KnBPY0eB/tNjx0bEAISuf3J3no63p74RR22Ars0QrVnZoYgSzAaLP
	 OiQkZyBARSgLajzrCBu8s9QF2fnhbbz2Q+n+uxD+ySQ1rIJoXp658GOXkqzaFigFZA
	 elR+KgHVhovUA==
Date: Fri, 09 Oct 2026 16:51:52 -0700
Subject: [PATCH 24/26] xfs: fix typos and repeated words in comments
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hemanth.selam@gmail.com,
 linux-xfs@vger.kernel.org
Message-ID: <179158947808.3719791.3574121681653540386.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Hemanth Selam <hemanth.selam@gmail.com>

Source kernel commit: 2f3c2a6f963e57cf4f0f34cbf24ab11abb64d118

Correct ten misspellings and eight accidentally doubled words in
comments.  No code changes.

The doubled word in xfs_zone_alloc.c was not a duplicate: "so that is is
reused" is "it is" misspelt, so that one reads "so that it is reused"
rather than dropping a word.

Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.h        |    2 +-
 libxfs/xfs_errortag.h  |    2 +-
 libxfs/xfs_format.h    |    2 +-
 libxfs/xfs_alloc.c     |    4 ++--
 libxfs/xfs_attr_leaf.c |    2 +-
 libxfs/xfs_exchmaps.c  |    2 +-
 libxfs/xfs_inode_buf.c |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index fd22fe59893176..ee636b66a72f6d 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -207,7 +207,7 @@ xfs_perag_next(
 }
 
 /*
- * Per-ag geometry infomation and validation
+ * Per-ag geometry information and validation
  */
 xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 6de207fed2d892..f0c83f1f0b3b41 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -83,7 +83,7 @@
 #define XFS_RANDOM_DEFAULT				100
 
 /*
- * Table of errror injection knobs.  The parameters to the XFS_ERRTAG macro are:
+ * Table of error injection knobs.  The parameters to the XFS_ERRTAG macro are:
  *   1. The XFS_ERRTAG_ flag but without the prefix;
  *   2. The name of the sysfs knob; and
  *   3. The default value for the knob.
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index dd0ed046fbe9c9..1a7a7e60a170c4 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1051,7 +1051,7 @@ enum xfs_dinode_fmt {
  * block is 1KB in size.
  *
  * With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and
- * with 1KB sized blocks, a file can reach upto,
+ * with 1KB sized blocks, a file can reach up to,
  * 1KB * (2^31) = 2TB
  *
  * This is much larger than the theoretical maximum size of a directory
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 4cad09d8be61a9..eb0c9b4e0650da 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3485,7 +3485,7 @@ xfs_alloc_read_agf(
 }
 
 /*
- * Pre-proces allocation arguments to set initial state that we don't require
+ * Pre-process allocation arguments to set initial state that we don't require
  * callers to set up correctly, as well as bounds check the allocation args
  * that are set up.
  */
@@ -3606,7 +3606,7 @@ xfs_alloc_vextent_finish(
 	 * ABBA AGF deadlocks because a future allocation attempt in this
 	 * transaction may attempt to lock a lower number AGF.
 	 *
-	 * We can't release the AGF until the transaction is commited, so at
+	 * We can't release the AGF until the transaction is committed, so at
 	 * this point we must update the "first allocation" tracker to point at
 	 * this AG if the tracker is empty or points to a lower AG. This allows
 	 * the next allocation attempt to be modified appropriately to avoid
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index a7c4c0bbcf5278..380a54712f4f60 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1713,7 +1713,7 @@ xfs_attr3_leaf_add_work(
 			/*
 			 * This freemap entry starts at the old end of the
 			 * leaf entry array, so we need to adjust its base
-			 * upward to accomodate the larger array.
+			 * upward to accommodate the larger array.
 			 */
 			diff = sizeof(struct xfs_attr_leaf_entry);
 		} else if (ichdr->freemap[i].size > 0 &&
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 7d6f949aa1f3b3..e044a42cf785ee 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -394,7 +394,7 @@ xfs_exchmaps_one_step(
 	/*
 	 * Re-add both mappings.  We exchange the file offsets between the two
 	 * maps and add the opposite map, which has the effect of filling the
-	 * logical offsets we just unmapped, but with with the physical mapping
+	 * logical offsets we just unmapped, but with the physical mapping
 	 * information exchanged.
 	 */
 	swap(irec1->br_startoff, irec2->br_startoff);
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 6fff9bbd39abb0..02a56321059b03 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -624,7 +624,7 @@ xfs_dinode_verify(
 	 * have di_nlink track the link count, even if the actual filesystem
 	 * only supported V1 inodes (i.e. di_onlink).  When writing out the
 	 * ondisk inode, it would set both the ondisk di_nlink and di_onlink to
-	 * the the incore di_nlink value, which is why we cannot check for
+	 * the incore di_nlink value, which is why we cannot check for
 	 * di_nlink==0 on a V1 inode.  V2/3 inodes would get written out with
 	 * di_onlink==0, so we can check that.
 	 */

