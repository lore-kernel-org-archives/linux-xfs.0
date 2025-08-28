Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78FA3148AA;
	Thu, 28 Aug 2025 14:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391320; cv=none; b=pWggzgqHAfLK/NXWyLW/hQ6Nh64oRRsXUMeIBu63J8QbAlwQeXHqyt1ymwAboJoQF/YgG13K5f1sOKfzbe+QYYC8sxUmyrAxIXKxcnHbvLKEStsafzHsJVxoUp9xU653H6FVs972w0o/J+85ksxYMUnDhWQ8ErRC7sBLo1Vqero=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391320; c=relaxed/simple;
	bh=g/YZW4958m4oLwRqPjzAj+rLRzVZubwrSj/QrnGIVDk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rTEQRAzfYm0YGzWw4E2gwMr7l/p91jd2Oc8Kjh2iqeN8EjsZtxKJ3mt9ibFN33kAu9XMZpR7NwSxC7S/P5O7gWNsgdhvwdp0GOBGkYT/IrWAO+4GhEasDDcfCBYQWclofOVvP/rb45ti9ENx1RYqrADe5K/d0+nOL4b1VFAziy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S32R4eke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S32R4eke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C3CC4CEEB;
	Thu, 28 Aug 2025 14:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756391319;
	bh=g/YZW4958m4oLwRqPjzAj+rLRzVZubwrSj/QrnGIVDk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S32R4eke5zKB0GY8HTcTO4VXU5kal1Zlp9Nv7r17GlY4ltSUvkWOo0gVGpwt9KD3j
	 TqVlVsNA3yrOidaJ3SsatVxTBfFtfyWrUfMi3kLLqwlxfn6m68MiJXyP7xc5tKJoRH
	 fCPkg/9ByA5xDrQ3Z2QlOdBPABXyltFq3rXYckKdonLdCj+dav/bux29qSeluAEuRR
	 NYbR1dq235fQlNGvQx9QCOwvQLujqqh7ihEIt1zoUpXOo4kESBI7mjZCGscW+3E0qO
	 2CWS+se5vAzQ/QMcWu17+o/jAsmEm3vsYvWMrFR2SuiQBxgt+ume5ZRTZOVCCKZbX/
	 iZhlwW7ShtmVw==
Date: Thu, 28 Aug 2025 07:28:38 -0700
Subject: [PATCH 3/9] xfs: use deferred intent items for reaping crosslinked
 blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175639126502.761138.11864019415667592045.stgit@frogsfrogsfrogs>
In-Reply-To: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're removing rmap records for crosslinked blocks, use deferred
intent items so that we can try to free/unmap as many of the old data
structure's blocks as we can in the same transaction as the commit.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: 1c7ce115e52106 ("xfs: reap large AG metadata extents when possible")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index db46f6cd4112f3..33272729249f64 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -430,8 +430,6 @@ xreap_agextent_iter(
 		trace_xreap_dispose_unmap_extent(pag_group(sc->sa.pag), agbno,
 				*aglenp);
 
-		xreap_force_defer_finish(rs);
-
 		if (rs->oinfo == &XFS_RMAP_OINFO_COW) {
 			/*
 			 * If we're unmapping CoW staging extents, remove the
@@ -440,11 +438,14 @@ xreap_agextent_iter(
 			 */
 			xfs_refcount_free_cow_extent(sc->tp, false, fsbno,
 					*aglenp);
+			xreap_force_defer_finish(rs);
 			return 0;
 		}
 
-		return xfs_rmap_free(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno,
-				*aglenp, rs->oinfo);
+		xfs_rmap_free_extent(sc->tp, false, fsbno, *aglenp,
+				rs->oinfo->oi_owner);
+		xreap_inc_defer(rs);
+		return 0;
 	}
 
 	trace_xreap_dispose_free_extent(pag_group(sc->sa.pag), agbno, *aglenp);

