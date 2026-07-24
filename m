Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67A333B6F1;
	Fri, 24 Jul 2026 06:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874124; cv=none; b=MQtinvd4pnglQ5qCmSZgocrpkrGwu1yjty/AK5F1iaSb55KVYGvg27y8lV0W1m9CG519JlPMLrkjUMZGnkFidPVWLD6ma3MeY23rrW4cy5W6Gf6+i7XOFK1U4CoKbPPxvBDjE12svTQWef1XCHNOmszroak5JgfI/igKB2chK2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874124; c=relaxed/simple;
	bh=9puJWqxQ9Wnp+4vRoR97JvV80CmOjCPLO3ht0iPKoBs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QOnYkw4uwyGbWmSjMkheHuMHdVmYB+hDkREOarnxngLFhfn3A8qc+zFTUJQiGpoM1HC5Gw3oICB9t3JHXK7FG1axO0qJWKQqDbbn+1SHSvTnk8b+HO4Vb3AQu1nSLe2r9BQnauFLtnu3xZ4LPt0gz5nb0HSeQCSSAJABJ3zAdSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iHSoOCqm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iHSoOCqm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7BC5E1F000E9;
	Fri, 24 Jul 2026 06:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784874123;
	bh=/vYPDhYAzlq2/vXyz08tFGhTBhiFjEeBmK7pyQ/CgLM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=iHSoOCqm/BYZe2AiKpa5U4yRHcLvQVfABXyRCF1onZE3BqRyzrso/TF77JWJSEtFO
	 1sjjkBp231APgZmLlfQXbuglrHjSQYXJ5mWUowQwDVBjGkxIVQmtWp/jQpmB7VAKK/
	 LGMUz4n0+y3iwIMYBLiX3cW/2r0AkEJZG3vIybDaRdNOVj/YS551ufIxBsTu1WHIVh
	 AVdCuL/Alox3cQ3k36wang/Gn/OtOYfNTBJdXAgBtJpoHpmz+mSZjUGS8ikTXxjiAE
	 goz7jstKekVLMJsgpElZlCf5uipefOx2QF+TNGjHRiLKG/KxFrWCfOG2cfMpGZeEmq
	 N3SmCqnUqAvtQ==
Date: Thu, 23 Jul 2026 23:22:03 -0700
Subject: [PATCH 4/6] xfs: don't zap the attr fork on repair when there are
 queued pptr updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178487405462.3442778.17642300701831053718.stgit@frogsfrogsfrogs>
In-Reply-To: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs>
References: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_xattr_rebuild_tree doesn't check for queued
parent pointer updates when it decides that it's going to zap the attr
fork.  This is obviously incorrect, so fix that.  We hold the IOLOCK and
the ILOCK of sc->ip at that point in time, so we can't race with any
/new/ operations.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/attr_repair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index be627ab655ad16..fa26328bdeac91 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1427,7 +1427,8 @@ xrep_xattr_rebuild_tree(
 	 * If we didn't find any attributes to salvage, repair the file by
 	 * zapping its attr fork.
 	 */
-	if (rx->attrs_found == 0) {
+	if (rx->attrs_found == 0 && (!xfs_has_parent(sc->mp) ||
+				     xfarray_length(rx->pptr_recs) == 0)) {
 		xfs_trans_ijoin(sc->tp, sc->ip, 0);
 		error = xrep_xattr_reset_fork(sc);
 		if (error)

