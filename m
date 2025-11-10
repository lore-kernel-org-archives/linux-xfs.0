Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE5521CC64
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781054; cv=none; b=I+OLDEoG78bLl34SPz1aDf9zY7RFAKJi02/DuYWmfKxrTVFY7oI3eHNw/KrvTcTn7LbLOmuWNwF5+uci8tsL9XTKC45PS1Ufuflq8O7TwPvHJaerXchlqYGT+BvNGa/18ig6XcXeyFGdqwULP6lPN9h3cZ2MlaBrp11J8vyAl2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781054; c=relaxed/simple;
	bh=BO22zwslK4WLjSiHsBqMLIySGxfTZStsyzZyRIP7X5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoY2QXNqsBBPVFna1c728tugJ5cu2D0Ma5HeDTFL2QWFuHHJLQWfB4tsEUkk6jk8qfZ/Rz+cg+5PCSaerK3/LhOI349ezmq6XibUJS43ByK7xLTAkbxkMqGRnpvfhE4hS1/fOxTTnluCu/7tSZMGmxwZ5k0jUhioNCEvfnmiy9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HY0dCS2a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HY0dCS2a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zDlBlHDSV6MHC/EtQq7REcFNYYI0x1qQifsU0HHl76c=; b=HY0dCS2aI+TB7bKlPzDz/Aq6oK
	h/nnSc/n+3yT9pkSzNZPXSGS5UCrqv9R8oRdu3YRuaymgLF1hg5lSkgUlifS7lApeOpnIGKvabx9Q
	8ppm1drccPlagAj3PSPB0NIAarjjgazfCQPeDprqavT8x/AKVRpVwVKDDnRsYKaFbZV8UvhAHOkvJ
	PEQXveVGMvoB0F+9Bol4aSFRSapUk+qjyoJvlAOmMxbX7/FdLqI5z3ngOaoctHQSzMcNWQLamldIw
	IvWtUTkAkbMChuOm/gzZRGiAu6YW9S9yPRZWaQWfAr/6DfHA3OuKNPOmIV6PbciuNevl7+2M12HGD
	bl/5IHZA==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRsS-00000005UTA-04YN;
	Mon, 10 Nov 2025 13:24:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 08/18] xfs: xfs_qm_dqattach_one is never called with a non-NULL *IO_idqpp
Date: Mon, 10 Nov 2025 14:23:00 +0100
Message-ID: <20251110132335.409466-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110132335.409466-1-hch@lst.de>
References: <20251110132335.409466-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The caller already checks that, so replace the handling of this case with
an assert that it does not happen.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c    | 13 +------------
 fs/xfs/xfs_trace.h |  1 -
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 5e6aefb17f19..b571eff51694 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -297,19 +297,8 @@ xfs_qm_dqattach_one(
 	struct xfs_dquot	*dqp;
 	int			error;
 
+	ASSERT(!*IO_idqpp);
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
-	error = 0;
-
-	/*
-	 * See if we already have it in the inode itself. IO_idqpp is &i_udquot
-	 * or &i_gdquot. This made the code look weird, but made the logic a lot
-	 * simpler.
-	 */
-	dqp = *IO_idqpp;
-	if (dqp) {
-		trace_xfs_dqattach_found(dqp);
-		return 0;
-	}
 
 	/*
 	 * Find the dquot from somewhere. This bumps the reference count of
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fccc032b3c6c..90582ff7c2cf 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1399,7 +1399,6 @@ DEFINE_DQUOT_EVENT(xfs_dqadjust);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_want);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_busy);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_done);
-DEFINE_DQUOT_EVENT(xfs_dqattach_found);
 DEFINE_DQUOT_EVENT(xfs_dqattach_get);
 DEFINE_DQUOT_EVENT(xfs_dqalloc);
 DEFINE_DQUOT_EVENT(xfs_dqtobp_read);
-- 
2.47.3

