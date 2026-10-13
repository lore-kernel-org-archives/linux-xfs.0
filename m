Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869B849C4A4;
	Tue, 13 Oct 2026 06:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871754; cv=none; b=gqIWdlu1s5Fg+FJ6xGeWaLTMvPNfF5a3fEoDuL/IqEdpUCHAQkh2Dw8/MDsauW3JLTl+e9guKDAY5nbvbWOqbGwwACN6QObvQug6IO6F5+o/g08GmDW+1S4wNwv2o/dLrVOGkWWLcFyQmUJ596BbpG+FRe9PS0kbKxARl48hFZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871754; c=relaxed/simple;
	bh=J4EzPIbZXN75VUJubuRsR67pHnmKnq3IrtGAyxNW0ac=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mujlJIGVKhjrrFjA6+lFBoYqd8GUIoTJcRtng4y53wpd0Vmc62SyVPuUE8rmzpapBNAWJKEgRdWOU4yqw+wqdoOMsIkXOkfVSAuHObjjKIbTk6sDnIMpjuKnYNyNMDI5Znqra/DR980xt1sDSbE/vQub/zgiie5P0hp8HvnpCDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IcS+C0rO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IcS+C0rO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9940D1F000FF;
	Tue, 13 Oct 2026 06:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871747;
	bh=S7AFqnM79n7jBgXBaS0LY3Ifb5fdJEq2HXQZV5VxLrE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=IcS+C0rOnaj4GGGy3JqK3YkD+73hiBLPTYzNSYEyBje02anpLooN9QuNSt1hpbxwq
	 4K1gjm2kL3VkDfzeT9jL0I7kLsnR6cSUDbZs+IfJmpQdOdRgOOumGMmNnFxhevbFio
	 iZLkHOOhvl7EkCWELLVcdT8gUHeW5wGTnsBn8pEjyElKHkzqbcktOj5JLnskrq0TrT
	 IdtDtf1yPctXIBfnUXVKH+MUmp1tptZLOdSc4zY/aSMiPagIhc40QseJeglNpwxVRr
	 Eg3r1FY+A8wDzOXOMGfDlCr+wL5jZdBkkuvSUAQQTIJYknrJKQjYKi8Xma09h0orcV
	 fioxTseD73Viw==
Date: Mon, 12 Oct 2026 23:09:07 -0700
Subject: [PATCH 03/12] xfs: rescan the AGs if incore delalloc counter is
 negative
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107906.1898896.10797643225456623847.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
References: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that percpu_counter_sum can return a negative number but
we instead misinterpret that into a huge unsigned value and do bad
things to fdblocks.  It shouldn't do that, so let's add a retry loop and
an attempt to freeze the filesystem to (hopefully) zero out the incore
delalloc counter.  It probably won't work, but at least failing the
repair beats doing the wrong thing.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: 75efa57d0bf5fc ("xfs: add online scrub for superblock counters")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/fscounters.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 5984fe13a973b8..67e159f39951ac 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -297,7 +297,7 @@ xchk_fscount_aggregate_agcounts(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_perag	*pag = NULL;
-	uint64_t		delayed;
+	int64_t			delayed;
 	int			tries = 8;
 	int			error = 0;
 
@@ -359,6 +359,11 @@ xchk_fscount_aggregate_agcounts(
 	 * of the computation.
 	 */
 	delayed = percpu_counter_sum(&mp->m_delalloc_blks);
+	if (delayed < 0) {
+		ASSERT(delayed >= 0);
+		xchk_set_incomplete(sc);
+		return -EFSCORRUPTED;
+	}
 	fsc->fdblocks -= delayed;
 
 	trace_xchk_fscounters_calc(mp, fsc->icount, fsc->ifree, fsc->fdblocks,
@@ -417,6 +422,7 @@ xchk_fscount_count_frextents(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_rtgroup	*rtg = NULL;
+	int64_t			delayed;
 	int			error;
 
 	fsc->frextents = 0;
@@ -442,7 +448,14 @@ xchk_fscount_count_frextents(
 		}
 	}
 
-	fsc->frextents_delayed = percpu_counter_sum(&mp->m_delalloc_rtextents);
+	delayed = percpu_counter_sum(&mp->m_delalloc_rtextents);
+	if (delayed < 0) {
+		ASSERT(delayed >= 0);
+		xchk_set_incomplete(sc);
+		return -EFSCORRUPTED;
+	}
+	fsc->frextents_delayed = delayed;
+
 	return 0;
 }
 #else

