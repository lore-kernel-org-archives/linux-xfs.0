Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D066231839;
	Mon,  5 Oct 2026 05:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179797; cv=none; b=T7c9c4KAtTAuV+5aLHBxz1CfIIywlvnyd+8uaa8GCs6dotc1sg8DBWSxLsM2h92k5rM+KL8XD2kWS8Ppycwj+yn80dewiXJa1V4bbrhcp3Xf336L9LhqASndtjsiVWJU+UHrz8xRHiuUCd4zZJdH49of8SEej08EaPq7/Bo/Nek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179797; c=relaxed/simple;
	bh=3W2oAN9u0LDO7hN4PliD3EuJm4pJTFCdAftHd39ZoiU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=boBQEaaPRwD0MlJllR8VsRXszE+wPg9ZXb0rJgKtMspo+4zOMXaPFxTcdi2yI3+WgxYw7Sz20Mj/rIGMq+v/Grxmpe9Nir0qwPb23e8AOSlKyRRI+Frgf+H34kjWZV5THvS3UAWVLHaGKsBtp/N1YIx+oRA1ToglAlO5T9c8m64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D1pr1utn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1pr1utn"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1D9541F000FF;
	Mon,  5 Oct 2026 05:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179796;
	bh=oRkQM4NGsIXh34C2KbcMfoSiduYsHMJ4owtNsJlE66s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=D1pr1utnunxutm/63FBlcIFQfCQCQregaiNS4uljNL356XyyhmLJRV6zoFlWW9U99
	 h6hcIq1H4FdKMW2IFf1ZtMrS5nOIBw4Q90l0Gw6yjLUQ7AUde879vz+2bWrGYxHsaE
	 sXZc4X24rH+GdxYT4Bhf34WjAGUgM3CuqjPxnilOtqHQUCP4hJTazDtV9OClEFUGb1
	 zmelsj2qlcoKkPA9EvKS9bSaLt9DSPlhYaWU/X6IyQE1OZDwAoUtp6OOkSQ5YbcmYr
	 EsTwd/tHNlDWHsY0LalmIJ8YZP/1TOItwnqrugRZ4j5zhCppddSDCF9QDglsDPdAHE
	 qREbNiJakt/Dw==
Date: Sun, 04 Oct 2026 22:56:35 -0700
Subject: [PATCH 05/12] xfs: always reset incore attr fork buffer when
 resetting fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117965116.614350.4706792269274649096.stgit@frogsfrogsfrogs>
In-Reply-To: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that the local format attr fork verifier depends on
if_bytes being set correctly.  However, the fork reset function doesn't
reset that correctly, which can cause post-repair verifier failures.
Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/attr_repair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 387ad909e20bb9..98a74066b24000 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -840,11 +840,11 @@ xrep_xattr_full_reset(
 
 		ASSERT(ifp->if_bytes == 0);
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
-		xfs_idata_realloc(sc->tempip, sizeof(*hdr), XFS_ATTR_FORK);
 	}
 
 	/* Reinitialize the attr fork to an empty shortform structure. */
-	hdr = ifp->if_data;
+	hdr = xfs_idata_realloc(sc->tempip,
+			(int64_t)sizeof(*hdr) - ifp->if_bytes, XFS_ATTR_FORK);
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->totsize = cpu_to_be16(sizeof(*hdr));
 	xfs_trans_log_inode(sc->tp, sc->tempip, XFS_ILOG_CORE | XFS_ILOG_ADATA);

