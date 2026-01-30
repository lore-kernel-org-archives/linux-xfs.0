Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8B7347BDB
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 05:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750455; cv=none; b=iCVufLETM215OzcgFOgfDwHxVZJjRleDp0t0rg/2r8FAQrDZzCuaRPStC3i3sYtY38oOM9Z3phmF4qSeQS2dd1zUHJ8Igrt8rCUk0jkOqgcIEXRxLxGjl1+floOgxScJ7IfcfB16UXTkKKBc4qVYSf7WHEbG9JAf8DzNakfxsJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750455; c=relaxed/simple;
	bh=YmTijWLPNRVDgIQ28ghPqY0CMrikBX7BMIIYZNPIPTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftrPimVYVfaERIZQiqvT4Y1Qle8Vf7I2dzNHww97f69ZL3yAHAYWogMNEoS2OWDN3ajB8s2s/531wnR6km8Elo+5YRRy0ms1WzrH9cYftHIOc3sx9xQx6pPiRCdDP+Fp4cIO7Ar/6/eOsNKdT/Xbrx13TrGzqXniwSqmedjFhPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HEz6/t82; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HEz6/t82"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PzCSIFAiOoXDTQ/0KylAflXgdjhjPENtQo/2NvMug/s=; b=HEz6/t82l6nKXdM6JqwfodNuz7
	6Z9+fxGZC1f1NTz0mQfp08P8cCfRax2ABu9Pet/CUMm/uYCkCg0OR3AG9dW21Qg9rOvnqtzFxsyNd
	iscCd7VC3CRWEV4hPn40urZ/QIUcx7EXCc3MOWIt6RFTqdJ2hzx/Ln/+VLpZcytfEGxJ1/nlR21TG
	UX7qnlQaJ8EseWWcBXBjRWpx71Wpdd6UD5OJzCHDhxzDbOjm2nJ/BBegXYBX03FnN+OQ3lWAAoUKp
	NDBBEhpIpQWDM2/vHkpiof5AFfbobHDROZlfwaGGcAy1Yid39toiaO6BIaTPxr3unDaNhUlBqH0CI
	ZQWrO7Jg==;
Received: from [185.190.48.89] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlgw9-000000013JR-0855;
	Fri, 30 Jan 2026 05:20:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/11] xfs: give the defer_relog stat a xs_ prefix
Date: Fri, 30 Jan 2026 06:19:25 +0100
Message-ID: <20260130052012.171568-11-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130052012.171568-1-hch@lst.de>
References: <20260130052012.171568-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Make this counter naming consistent with all the others.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c | 2 +-
 fs/xfs/xfs_stats.c        | 6 +++---
 fs/xfs/xfs_stats.h        | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 0bd87b40d091..c39e40dcb0b0 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -565,7 +565,7 @@ xfs_defer_relog(
 			continue;
 
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
-		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
+		XFS_STATS_INC((*tpp)->t_mountp, xs_defer_relog);
 
 		xfs_defer_relog_intent(*tpp, dfp);
 	}
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 9781222e0653..3fe1f5412537 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -23,7 +23,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 	uint64_t	xs_xstrat_bytes = 0;
 	uint64_t	xs_write_bytes = 0;
 	uint64_t	xs_read_bytes = 0;
-	uint64_t	defer_relog = 0;
+	uint64_t	xs_defer_relog = 0;
 
 	static const struct xstats_entry {
 		char	*desc;
@@ -76,13 +76,13 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		xs_xstrat_bytes += per_cpu_ptr(stats, i)->s.xs_xstrat_bytes;
 		xs_write_bytes += per_cpu_ptr(stats, i)->s.xs_write_bytes;
 		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
-		defer_relog += per_cpu_ptr(stats, i)->s.defer_relog;
+		xs_defer_relog += per_cpu_ptr(stats, i)->s.xs_defer_relog;
 	}
 
 	len += scnprintf(buf + len, PATH_MAX-len, "xpc %llu %llu %llu\n",
 			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
 	len += scnprintf(buf + len, PATH_MAX-len, "defer_relog %llu\n",
-			defer_relog);
+			xs_defer_relog);
 	len += scnprintf(buf + len, PATH_MAX-len, "debug %u\n",
 #if defined(DEBUG)
 		1);
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 15ba1abcf253..d86c6ce35010 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -142,7 +142,7 @@ struct __xfsstats {
 	uint64_t		xs_xstrat_bytes;
 	uint64_t		xs_write_bytes;
 	uint64_t		xs_read_bytes;
-	uint64_t		defer_relog;
+	uint64_t		xs_defer_relog;
 };
 
 #define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))
-- 
2.47.3

