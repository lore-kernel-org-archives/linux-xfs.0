Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2A3208AD
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 06:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712297237; cv=none; b=s+qpg/F0VIdE/KnOoT8vfEyxUCAsedQb3WiVRLy4UtLLMtZKzktxKYjIr0c3uzNALUwWT9NMqK+IrvqIYaiErYQteS6BgJLJGQ+7pOsKSgOpItj4nVp9dyE6k/2/HQmS1zzf9Bnzd0Q4F5RNQEg70RbDhVQHONy6qQVid/hy4m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712297237; c=relaxed/simple;
	bh=xkRUW8MqgDkKxGHbh0wJM7gxP0Cnv1EVLGQapHLYSEU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XxBe9Ef80Z1u+ybGb+fhNZ8IrZiRcTzT+Z3uEorSAgmswek/JztwEViafv6rdYISVBeF9zyCjEQnxE5YV30CxwvPv8YVV6/GEnoEWmHZyGRdBcKquGbeIW3OPKDtTbrCVUsAeF1BMLPainIEqECezND6fi3QR02e9qN42hAyLjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fBuqqoY1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fBuqqoY1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xGhh8sHPIUV5QpirSnWndrxPwB/0DuOq0uLOamLC9oU=; b=fBuqqoY1jtQ18fMyKC4vL6INhQ
	dFpf9iCpQKm0k5lXKBj1eDTLyKJUfUqwKbW4tF/CQbTYCAwgrls8H8mhJ1UE2wPNTN+woQwl+7TdT
	1jzin879WmyGV4GdHVhFfl5ytAtcx4FwsJmoso0jCp2MVCrOu9FzScjuBuCxadzo+yb1X0rh46E9o
	SdBECf83Y3o2frilIQpKwt64Vz+aO4AzQNuaXvdPi66gidm9rFHetuXPzggD6r5Br7fa03HP9nJ5A
	Tv8tfgasb6Yy6+8BNLFRInjZ7RuJePAigc+o32gu/7vccC7fDSzipOOLjDW0NLsWuNj1wSHliTCis
	cc3hzBNQ==;
Received: from [2001:4bb8:199:60a5:d0:35b2:c2d9:a57a] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rscjK-00000005OMx-2kX7;
	Fri, 05 Apr 2024 06:07:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: move more logic into xfs_extent_busy_clear_one
Date: Fri,  5 Apr 2024 08:07:08 +0200
Message-Id: <20240405060710.227096-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240405060710.227096-1-hch@lst.de>
References: <20240405060710.227096-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the handling of discarded entries into xfs_extent_busy_clear_one
to reuse the length check and tidy up the logic in the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extent_busy.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 56cfa1498571e3..6fbffa46e5e94b 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -518,20 +518,26 @@ xfs_extent_busy_trim(
 	goto out;
 }
 
-STATIC void
+static bool
 xfs_extent_busy_clear_one(
-	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
-	struct xfs_extent_busy	*busyp)
+	struct xfs_extent_busy	*busyp,
+	bool			do_discard)
 {
 	if (busyp->length) {
-		trace_xfs_extent_busy_clear(mp, busyp->agno, busyp->bno,
-						busyp->length);
+		if (do_discard &&
+		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
+			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
+			return false;
+		}
+		trace_xfs_extent_busy_clear(pag->pag_mount, busyp->agno,
+				busyp->bno, busyp->length);
 		rb_erase(&busyp->rb_node, &pag->pagb_tree);
 	}
 
 	list_del_init(&busyp->list);
 	kfree(busyp);
+	return true;
 }
 
 static void
@@ -575,13 +581,8 @@ xfs_extent_busy_clear(
 			wakeup = false;
 		}
 
-		if (do_discard && busyp->length &&
-		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
-			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
-		} else {
-			xfs_extent_busy_clear_one(mp, pag, busyp);
+		if (xfs_extent_busy_clear_one(pag, busyp, do_discard))
 			wakeup = true;
-		}
 	}
 
 	if (pag)
-- 
2.39.2

