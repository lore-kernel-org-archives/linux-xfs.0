Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBA135B650;
	Fri,  9 Oct 2026 06:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526569; cv=none; b=bT4/bAZUxR8O6rdlNo+vVCeTsZbc1TwnQyNOgjgr/hVbMHtueT3RmNnvwwM1eU1eeLgNAB0c4NVpmCUZ51gvRlmCQpMO6cafdxWOGesd6z9ZWqMefl3ofM45EC/vmjV+WYpebVtxq2x7Tr40hVRmtdnynLHODRU77z1bv1pr54c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526569; c=relaxed/simple;
	bh=wVF/KkvOmn24aNuuvGCcx4rpdhhaARzE6Uvl9Dnip7s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FSzgu7GlwdG6m80SAmaSAt1gL7cgf/EQRkQnGkHI5BJoqZQhJ2ueyhsu/XA7ExHFjQ2AxQ1xjmTlMOQ22VrEiHj+PuUn1Q6XjDWgv+ilrVpr55rCPEN9YGMANSheFMBaX328raA7iXtJrmckaL35SalbBuf+5fX3n0mJRS208Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IJQFIhDN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IJQFIhDN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4E1A71F00898;
	Fri,  9 Oct 2026 06:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526568;
	bh=IHPAe+EK3SR6m688M0HXlXDeX2DGa15tDj2sxHZuB/8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=IJQFIhDNFSKHhbvEHtHVDzKYBkfAlK8I3g/3/pM28VrqqonLRozioi7KlLlnpPG/o
	 cvrhypRgdpjWLSnhaCudJty1aBHZz46+hnFLJmxhZ68DrTkbP1iNNQ1JcaxAmgKPRH
	 5sFxAWOt2bi96cGAvc5M8vyA8OKMcfQAeJDilWkxbLD8/22A9L9zHSDr2xp26HtFGw
	 5srllBccYJfUnC4PhFP/rBgjLBDiTzeRezxUw/O7wrP0wpwUmWYdatm2zqK8G5mhk+
	 y2FhyVxo/CHa3bOOAJ5k+TskJmyKHc12LAHmNUD2SkUwbN8/DG8CVFe7DMnGRecwZL
	 +PTQiCJz3pvhQ==
Date: Thu, 08 Oct 2026 23:16:07 -0700
Subject: [PATCH 05/13] xfs: never reset the default quota timer
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179151614728.3163896.2964423795162030201.stgit@frogsfrogsfrogs>
In-Reply-To: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that xrep_quota_fix_timer doesn't check the dquot id,
which means that it can inadvertently reset the default quota timer when
we really meant to ensure that a (non-root) quota overage timeout has a
sane timestamp.  Fix that.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quota_repair.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index a37fcd3fb6629b..2b695e5b34177c 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -272,6 +272,9 @@ xrep_quota_fix_timer(
 	time64_t		new_timer;
 	uint32_t		t;
 
+	/* never reset the default quota timer */
+	if (ddq->d_id == 0)
+		return;
 	if (!soft || count <= soft || *timer != 0)
 		return;
 

