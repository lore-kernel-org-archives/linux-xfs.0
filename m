Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7E523BB
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607280; cv=none; b=ecbJIrcYKTeqFONy8MbE7Z2chghZAB71bQ7zJs5VDRjlrTLglQc+FlLQxmye0rX+lJRFivs4am45z/dgwilFRiB6iyWQIQlnQydjNMclJHGrVWJgonZ6B1PzdS5vUKS5Mk8Go2uZ0hFQ83o0JZuc4viAqJ3PY8xKmK6f0Bxd9bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607280; c=relaxed/simple;
	bh=6H/adl1juUDMN21mzDj8YWJ6nYrzFczVU0Ahka9tF70=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PdXeWVKAwXfn0OP9nVw0EwdBP+16DRaeG9qNGtsxwjcszatNxVVBsjOOsPwb5Z2cIcXV7sx23KIFAn6fQUqQ7jNyzMmfz43Aua+89yZmpsrot8OKgYOtr6WO58eZja8QIUJih2YJj5pzmIw9JPHxUg8J0QspaufU5edC9d45rA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B551G+Mp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B551G+Mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE14C4CEC5;
	Fri, 11 Oct 2024 00:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607280;
	bh=6H/adl1juUDMN21mzDj8YWJ6nYrzFczVU0Ahka9tF70=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B551G+MpUXGLEruSnYCyzeDbyFZs/+gorZd0DDrpIJxZIyC9qb687pAefilK8H/TQ
	 ni+nJhN5DzRMoAq+IlMBmGRAbkT98snVBUsriR75gcco57Q0SdshwrNtxv9tlhPc8g
	 yNa5pB9SBw/rloPFWmSHAqly9srvMd85HrnLWbCAx4u1r7RB9MnJ8yLMhG8aIeWQSL
	 2S3dPZmJC9numK0qDI70vTs6RYiZKrqAhui39JjBiM5cXj5Sb/RrpjxPAyDbZOwaik
	 0ILGB8QC/GtWXQhwqGTEkNYDPYa/PUilpY81NkcldHcRvaL5LcrSUFbmBDIL+aNXNs
	 4duhbskKqkVGA==
Date: Thu, 10 Oct 2024 17:41:19 -0700
Subject: [PATCH 14/25] xfs: remove the unused trace_xfs_iwalk_ag trace point
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640652.4175438.135124096863758262.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

