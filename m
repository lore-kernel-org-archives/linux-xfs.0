Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22A978F26;
	Tue, 21 Jul 2026 03:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604399; cv=none; b=OHq0KPYPtSlrFtKWULLPVX+6Y/9CKyXpFjLYqgzVsVlqV3hfDoYbAtAMSEOtECSULGjp1H7KjnKbttBOpdAvfkG99C4J5Mj+HGm+qqD6vzvS2faaFloG/US2S9IoBN1HbextqwqcDbCL4+RGwz+athmetPQ+9hZ0FLM2Zn16UIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604399; c=relaxed/simple;
	bh=WWvomjM93IF0VTSv6RUfq4F1eGd+gdBzKZ5ULU7AMdk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VNA86gr60suNVIBbxrqKI4k3hyx1RirD07PawbVSpzKtSV0sNHfG7VyhwfdJ0QA6uOeSwmrKsHkQdD7LC92GbroJoxz7gZm7KsKzUMn3yMTZUZ5fKukmYuxK+QMJHxH6ObSA/r+9EHDuOuHAo+eIPnzAX+SUfCPsJpL6ZEUOp48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=idQ2Dive; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="idQ2Dive"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7B37D1F000E9;
	Tue, 21 Jul 2026 03:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604398;
	bh=0Xcnrz3tfIjXodC9sKjV7JmuHojTmNmC7mnGzQf82gM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=idQ2DiveaZBrdgPkPtNm1izb90Ls9rFbUieD8SJwIUKntN8rvwN6G5VCGHNZVAujn
	 Lvd46wAb1Q8z7OiaLctSUos9jQZeONZB1FoKtUbneINbk9iBKGMyWZC6RtyyIBSaIw
	 G2DClDRO9IKY6k2E8cQg7jxSuhuKnwqlJrvu9lE761wVGyCDgFM1hRMaGFAgiwRDUX
	 fmgEZFWmQBQ0MVaXmLhVSUYM+BvXGAGG+xAHS4ZVsZVpsuDCPNsRf1/WIT10VEIhb+
	 Kra5hp1xZuDXx002Y4szQtTgZYM7TZ4Kj+Uv54s163SuY+gRKi2fixIfdzr4lb1Y4f
	 FVb0sVpwsEhXQ==
Date: Mon, 20 Jul 2026 20:26:38 -0700
Subject: [PATCH 7/9] xfs: fix allocated inodes that show up in the unlinked
 list
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419637.830862.15080147963623340285.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If an allocated inode shows up in the unlinked list, we need to get it
completely off the list.  Set the corrected next/prev pointers such that
the inode will not look like it should be on an unlinked list at all.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h           |    1 +
 fs/xfs/scrub/agheader_repair.c |   57 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 51 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d5d39d82749e5c..00fbe1b9c2354f 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3542,6 +3542,7 @@ DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_uncached);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_wronglist);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_nolist);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_ok);
+DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_allocated);
 
 TRACE_EVENT(xrep_iunlink_relink_next,
 	TP_PROTO(struct xfs_inode *ip, xfs_agino_t next_agino),
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 8514d2d7e3cea3..edd406a97b7ce9 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -979,6 +979,13 @@ xrep_agi_calc_from_btrees(
 	return error;
 }
 
+/*
+ * Magic value that means "not unlinked" because xfarrays don't support storing
+ * totally zeroed elements.  There can't be a cluster that starts in daddr 0 so
+ * there can't be an inode #1 either.
+ */
+#define LINKED_AGINO	(0x1)
+
 /*
  * Record a forwards unlinked chain pointer from agino -> next_agino in our
  * staging information.
@@ -1362,6 +1369,29 @@ xrep_iunlink_resolve_bucket(
 			break;
 		}
 
+		if (VFS_I(ip)->i_nlink != 0) {
+			/*
+			 * Inode is allocated!  Blow out both unlinked list
+			 * pointers, advance the list, and pretend we didn't
+			 * see this inode.
+			 */
+			trace_xrep_iunlink_resolve_allocated(sc->sa.pag,
+					bucket, prev_agino, next_agino);
+
+			error = xrep_iunlink_store_next(ragi, next_agino,
+					NULLAGINO);
+			if (error)
+				return error;
+
+			error = xrep_iunlink_store_prev(ragi, next_agino,
+					LINKED_AGINO);
+			if (error)
+				return error;
+
+			next_agino = ip->i_next_unlinked;
+			continue;
+		}
+
 		if (next_agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
 			/*
 			 * Inode is in the wrong bucket.  Advance the list,
@@ -1540,6 +1570,24 @@ xrep_iunlink_rebuild_buckets(
 			xrep_iunlink_add_lost_inodes, ragi);
 }
 
+static inline void
+set_inode_prev_unlinked(
+	struct xfs_inode	*ip,
+	xfs_agino_t		prev_agino)
+{
+	/*
+	 * Magic value that means "not unlinked" because xfarrays don't support
+	 * storing totally zeroed elements.
+	 */
+	if (prev_agino == LINKED_AGINO)
+		prev_agino = 0;
+
+	if (ip->i_prev_unlinked != prev_agino) {
+		trace_xrep_iunlink_relink_prev(ip, prev_agino);
+		ip->i_prev_unlinked = prev_agino;
+	}
+}
+
 /* Update i_next_iunlinked for the inode @agino. */
 STATIC int
 xrep_iunlink_relink_next(
@@ -1573,8 +1621,7 @@ xrep_iunlink_relink_next(
 		if (error)
 			goto out_rele;
 
-		trace_xrep_iunlink_relink_prev(ip, prev_agino);
-		ip->i_prev_unlinked = prev_agino;
+		set_inode_prev_unlinked(ip, prev_agino);
 	}
 
 	/* Update the forward pointer. */
@@ -1641,11 +1688,7 @@ xrep_iunlink_relink_prev(
 		ip->i_next_unlinked = next_agino;
 	}
 
-	/* Update the backward pointer. */
-	if (ip->i_prev_unlinked != prev_agino) {
-		trace_xrep_iunlink_relink_prev(ip, prev_agino);
-		ip->i_prev_unlinked = prev_agino;
-	}
+	set_inode_prev_unlinked(ip, prev_agino);
 
 out_rele:
 	/*

