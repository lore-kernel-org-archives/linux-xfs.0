Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A352F4A
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052794; cv=none; b=FwhTmeQg7ClWwodlDM3UEsRtlA+h5A3n0u7juckRmD1EJNgVy9CSxcYlw/uWd8CW6YcyAufjmfROhcf0A1rbCpYSZeAfOlCjzM+bOWsF/2M6kJ6UeRge5YDShGy+467U/BEBBDdHk/Ze4e/N+M+ZNeAxApfG5bWlCa4kr6UR0Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052794; c=relaxed/simple;
	bh=0yjR6IX1nNx+Wtk+Tbs95AfzWBDvh4WLLTcGTVBG6ro=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r/RdXaYkkt9NDgNwSd4KRUBAbJt3Jpb2/v1PQhkKNT9uRAJWZongEr7YC7bumB8w/lYgczR5bJMnCTIdq0St78g1wV3wz1O483ASH/ghyPKY68aWVtTH+OosDrEzTu1WgiYEuFJmS0jwaoS/+CwUivJSRSANPHTWPs1ao+zjCso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sk/6racc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sk/6racc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2E0C4CECE;
	Fri, 13 Dec 2024 01:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052794;
	bh=0yjR6IX1nNx+Wtk+Tbs95AfzWBDvh4WLLTcGTVBG6ro=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Sk/6raccNoKANtw4k4xrORaFSnFNKq5b+WTjRiQvSv9ScGYxUMBbzb2iEbcXOBeym
	 VaioA0zNELmNCgPgNm2UCfrskFtwfRb8tpCF8C4OLRgFedZFa46qEMU+yD3qm7Vfya
	 yYV7YYNa2m+MpCeBq6Ulqc1M31b9FtOgvG4VIr72VNfcrRahTFZIsyNtWoqC1G5TWG
	 oRihUtplloQcDnFKWYxX0NkD11p42hVNcPrZz4Zwj+J3p5SClqmy/5bKJ9zoVkcaPn
	 ehG3txWgZlX5YP9V6HQ+pKgcYndV6Iwzpd+5KP5vvJDgiuBbERds92b9ItK4yrlacL
	 24SQIFfy1jvyQ==
Date: Thu, 12 Dec 2024 17:19:53 -0800
Subject: [PATCH 37/43] xfs: walk the rt reference count tree when rebuilding
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125200.1182620.4067826887871768042.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're rebuilding the data device rmap, if we encounter a "refcount"
format fork, we have to walk the (realtime) refcount btree inode to
build the appropriate mappings.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/rmap_repair.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index c2c7b76cc25ab8..f5f73078ffe29d 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -33,6 +33,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -519,6 +520,9 @@ xrep_rmap_scan_meta_btree(
 	case XFS_METAFILE_RTRMAP:
 		type = XFS_RTGI_RMAP;
 		break;
+	case XFS_METAFILE_RTREFCOUNT:
+		type = XFS_RTGI_REFCOUNT;
+		break;
 	default:
 		ASSERT(0);
 		return -EFSCORRUPTED;
@@ -545,6 +549,9 @@ xrep_rmap_scan_meta_btree(
 	case XFS_METAFILE_RTRMAP:
 		cur = xfs_rtrmapbt_init_cursor(sc->tp, rtg);
 		break;
+	case XFS_METAFILE_RTREFCOUNT:
+		cur = xfs_rtrefcountbt_init_cursor(sc->tp, rtg);
+		break;
 	default:
 		ASSERT(0);
 		error = -EFSCORRUPTED;

