Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7B11D619D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990000; cv=none; b=HvVEQgKkk36qvH6GTz6biUUPy7mYIdhkvEy8/iS/R02Y+01NmpbOJKFJrKC6kL9257sym68fEmnmVshk2qIfry2eYN9JjkorqxoylP1BVT/36au8WLItlF5y/lm/3qMZX1qUfrurh7o/MygHaljqj2NzSndma5Awn5yJ59ttENc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990000; c=relaxed/simple;
	bh=5PtFnDfEP460iHV4IKt8kyruSzfaZY3zPbE0rOoAA5U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LBLZxAvRm7IiycstjKP+m8bK6v/XFGZET/khLoceeXscN50NmRYJlQemTKAgvStVKJ6naeXt5Zfv5+pY0o6DUn6w3XPLh5CFgKo+FQUTpwaBrji813QYgSvtAdfqOW/PuvswvVf3UjvoWszkF8kcU+c7WSzH8DRHe8WVkBiMLJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8we/qv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8we/qv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96C0C4CED3;
	Mon, 23 Dec 2024 21:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989999;
	bh=5PtFnDfEP460iHV4IKt8kyruSzfaZY3zPbE0rOoAA5U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L8we/qv3SZZjxjocrp9Ra6Y/Ep/HupeJtpJwYPQy29ku+1VmSOU+w+tyDo4Lep59z
	 IWaO9fUhTmb27Lfjb79l5Y6U+N6pXhQhRjwQ+a9WPl/3BD8DqsMvzBt5VINCsCIcCX
	 ei/ocv73IOfmO+1sdASODHTahyi9mkIwuIgH4ea6xg4OVl/F2GjyApKLiAWmiyc+CX
	 hE+8xMQxDBVw7WfDwmJRhOD4tprE9c6aUHkiXDEV9eBMrAKtMTtOVQTOwI8O8kEsog
	 Uda+ivqY+ycotYUiTYiNuBoJjTCocoYWGFdNB4BNHFLYg89zoxAIxvfniG0s4Qy4P3
	 CFm/iBpPMsokg==
Date: Mon, 23 Dec 2024 13:39:59 -0800
Subject: [PATCH 11/36] xfs: pass objects to the xfs_irec_merge_{pre,post}
 trace points
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940115.2293042.6563097897581787673.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 487092ceaa72448ca3a82ea9fb89768c88f6abec

Pass the perag structure and the irec to these tracepoints so that the
decoding is only done when tracing is actually enabled and the call sites
look a lot neater.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trace.h |    4 ++--
 libxfs/xfs_ialloc.c |    7 ++-----
 2 files changed, 4 insertions(+), 7 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index ba51419b3df3d3..0986e1621437d4 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -85,8 +85,8 @@
 #define trace_xfs_alloc_read_agf(a,b)		((void) 0)
 #define trace_xfs_read_agi(a,b)			((void) 0)
 #define trace_xfs_ialloc_read_agi(a,b)		((void) 0)
-#define trace_xfs_irec_merge_pre(a,b,c,d,e,f)	((void) 0)
-#define trace_xfs_irec_merge_post(a,b,c,d)	((void) 0)
+#define trace_xfs_irec_merge_pre(...)		((void) 0)
+#define trace_xfs_irec_merge_post(...)		((void) 0)
 
 #define trace_xfs_iext_insert(a,b,c,d)		((void) 0)
 #define trace_xfs_iext_remove(a,b,c,d)		((void) 0)
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 01b2e2d8c27c22..b3d6f7f4212588 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -601,15 +601,12 @@ xfs_inobt_insert_sprec(
 		goto error;
 	}
 
-	trace_xfs_irec_merge_pre(mp, pag->pag_agno, rec.ir_startino,
-				 rec.ir_holemask, nrec->ir_startino,
-				 nrec->ir_holemask);
+	trace_xfs_irec_merge_pre(pag, &rec, nrec);
 
 	/* merge to nrec to output the updated record */
 	__xfs_inobt_rec_merge(nrec, &rec);
 
-	trace_xfs_irec_merge_post(mp, pag->pag_agno, nrec->ir_startino,
-				  nrec->ir_holemask);
+	trace_xfs_irec_merge_post(pag, nrec);
 
 	error = xfs_inobt_rec_check_count(mp, nrec);
 	if (error)

