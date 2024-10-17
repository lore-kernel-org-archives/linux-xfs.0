Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B2D17DFE0
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190986; cv=none; b=YWq5NXCpAmnZH1KvG5G2WNgqqmJBQT6JSzCLzgDgU40wRlfHHNjvFXNF8BchbsBqQeLbj6CTIQM/L5PkJLrkBJjxHPXxieWvyDM3+COqmB+rwUkii7F88RbJ2ZDrDg1m1cqgNPgaNeyzuwg8HyXUmRJk3STZweKsrfRxjY1KxwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190986; c=relaxed/simple;
	bh=6H/adl1juUDMN21mzDj8YWJ6nYrzFczVU0Ahka9tF70=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XBzkWlwSMtrJWtapnr8itIoleEvp55zpDlLZjXUyvaj+A+d3l9Nwuod1uAvCyF7PMjqyAg2WraYjnB/MEPUwBcqwmOwsf1oSHYHhfyfWaUYZRdLJtDeeu0NjWDQpQPmTS7O8DXKJ2A6NV77aACnDJoKiQR8ngr0cTFNWSEjcldc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZaW6aSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZaW6aSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D462AC4CEC3;
	Thu, 17 Oct 2024 18:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190985;
	bh=6H/adl1juUDMN21mzDj8YWJ6nYrzFczVU0Ahka9tF70=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jZaW6aSy5TNsmCa1hPeHa0b/ApI23eKpd4ettC8YHkluFG5Bn0b727ZwRBxe8ltHh
	 cX2eIQdHsDyoxmtsW3Z/4CLolgExVYSicdc90g74KHMkgV2Y/puxgX2jV3s/Il5BaR
	 nsDJQaIOL9br95kTM23dBnHHF+Cc/ZIk+NNAOy5KXsOxOP8czAa95DF7ty4fJ9Bw0s
	 yGEDZC0HygJGzIMMeWRVyguwsoQxPa/rrgLC9wmzSq7eUHBm0IQP+YSRzW9Vx19WvS
	 Z8vz627vxK/eybV07x9wHNr2xz3Zr7y9deJE6U37LhCK0KNAq5w4k9IZNUkF9O3CKo
	 4kcGDdz6OAi4g==
Date: Thu, 17 Oct 2024 11:49:45 -0700
Subject: [PATCH 11/22] xfs: remove the unused trace_xfs_iwalk_ag trace point
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068051.3449971.15482371492123195647.stgit@frogsfrogsfrogs>
In-Reply-To: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
References: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.h |   19 -------------------
 1 file changed, 19 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3d29329db0dfbd..bd01b7a13228c6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4242,25 +4242,6 @@ DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_corrupt);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_unfixed_corruption);
 
-TRACE_EVENT(xfs_iwalk_ag,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agino_t startino),
-	TP_ARGS(mp, agno, startino),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agino_t, startino)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->startino = startino;
-	),
-	TP_printk("dev %d:%d agno 0x%x startino 0x%x",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
-		  __entry->startino)
-)
-
 TRACE_EVENT(xfs_iwalk_ag_rec,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 struct xfs_inobt_rec_incore *irec),

