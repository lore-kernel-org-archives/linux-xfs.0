Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F318728F4
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607296; cv=none; b=V6oEwB0F/qSovoHGDsYxp7GbIhhcUWnnz353/ctfNoG/Mz8L+/54hedfGlffySBV4RIvVJ5UtEbQfC3R6kqKNfopZHEceb41FczdxajUa81bX1WFC6C/MmXg9S2vYScvk3nj8/jl0e5i/kqSBFf2UAyqJDUug3yLTG9qPNHZ6bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607296; c=relaxed/simple;
	bh=3o2OzYz4z6NdmYM5pKR+q3PpKSxN0KvhKLO+Jkwf3CE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a1IT84CTMVEAXzC1+TdQcWM7GnhGSWW5hDe8BiUrDcJVeDMqWA1kQTHBguBAL7sYyeUNHZ3U37Db5byleQBKNf2vwEdOCLZRE2muoYQXFbKF0YO0QFaZT+LBk9gzvFdCxZzBJdeu6fg5dUudKpYJQr883WV7UD1cCgJ4NiJwWik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOH1SFKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOH1SFKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C8BC4CEC5;
	Fri, 11 Oct 2024 00:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607295;
	bh=3o2OzYz4z6NdmYM5pKR+q3PpKSxN0KvhKLO+Jkwf3CE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dOH1SFKc4/Ap6fPFTEWlXvoMRdoWx7wckq4ngXA95CxqwavkOXUWNWFVHGJ0Uvq1m
	 Zhxr8jeu7Fl3/dhQAf1ZhlRksOa5BvEQ/nd07kvCD1cDMbKM8EevYGm3VQXS/YmLaq
	 73rBg+n+IdWaDG7yhfNB4WcxIVkCj88WRzaBWV8urR/15bKruiL2+GmK+5o9o3/wjS
	 0iWBOa8AwYXLPfy5ZnBfwH08WIj1Cc/4hDVFKDVgWiBYgfRkW4DFyDOzEroLltjmYw
	 lsFrqD6esmY2ubO15wasjzYaoRS26JVGsvXLAY1Elh9JEln1s0ereUz+6abxNv+T9U
	 3mVqwSfYG7xsA==
Date: Thu, 10 Oct 2024 17:41:35 -0700
Subject: [PATCH 15/25] xfs: remove the unused xrep_bmap_walk_rmap trace point
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640670.4175438.13589151016370255147.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/trace.h |    1 -
 1 file changed, 1 deletion(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index c886d5d0eb021a..5eff6186724d4a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2020,7 +2020,6 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
 DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
-DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_walk_rmap);
 
 TRACE_EVENT(xrep_abt_found,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,

