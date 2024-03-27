Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36172219E1
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504887; cv=none; b=LT2xtbdUrrhfjgL0GGGVooTkFGLQESPtEsSnZDwLMK3kIT4cE14NIiLXL2gGAlau/IPAuyIO031+YWh76aQqqcFtDn+6+EioYnI+XgnMaNWb1EovFC6+XVpGQkC3AG+kmBRtXn8w9/+1o+ZtYfavI8COJ1ANli9EP2QpOx4J8lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504887; c=relaxed/simple;
	bh=gS0InY1xRPc8NzdRfTMtsgKPoQBx6v9fk4icE5iNMNw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O7E6neLYLwKVHbv/Vvy3h7gfBgQgTixwpq63j/wy3UA61TpLYhp/Rhf7/qGj5ER2Vp0qotALqQEpceGTmJX8eY/7x3BjHh/2w4Q4hoYzuvKdFqekoi4usaw6fFIAi8H0iZMRcbYstFNxZedeKEsuSMUNmkx8gPEG6HSIhqhSwBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O4q7W09C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O4q7W09C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E067C433C7;
	Wed, 27 Mar 2024 02:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504887;
	bh=gS0InY1xRPc8NzdRfTMtsgKPoQBx6v9fk4icE5iNMNw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O4q7W09CKxhuQH1qVTrxNR8HyQGEboMGyVE/6xa/diTw1Gg+lcxyjGRVksuumwhnV
	 GknqT0WQd/dLSKunLIgct+6tRHtiYu1oZtwyYGaDMdnhMmOuRtEiFNQn0cI26dsNH5
	 L9E2seSk2Z4rw8pzKOowNz6TykKRKHj5VZBOWh1HojLSJ3XeZpLKCmbNHjlvfR/KiH
	 HlrcvwbsNMTIglHgmQ0YOCGmCSpccV3OXM9IDxnMt5GCcssp04YdOq91FH/oSNx4Y5
	 1ulRnrcyZD7PfTS3/Wx5iX6hfGo42iZvYdw3q5Io6X9iG5FX45NlOdBGRfOW+LYGMR
	 ZuJ+pLUZ+U+Cg==
Date: Tue, 26 Mar 2024 19:01:26 -0700
Subject: [PATCH 1/7] xfs: enable discarding of folios backing an xfile
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150382685.3217666.12304471419925877732.stgit@frogsfrogsfrogs>
In-Reply-To: <171150382650.3217666.5736938027118830430.stgit@frogsfrogsfrogs>
References: <171150382650.3217666.5736938027118830430.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a new xfile function to discard the page cache that's backing
part of an xfile.  The next patch wil use this to drop parts of an xfile
that aren't needed anymore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/trace.h |    1 +
 fs/xfs/scrub/xfile.c |   12 ++++++++++++
 fs/xfs/scrub/xfile.h |    1 +
 3 files changed, 14 insertions(+)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5edbabacc31a8..b5fe49a6da534 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -948,6 +948,7 @@ DEFINE_XFILE_EVENT(xfile_store);
 DEFINE_XFILE_EVENT(xfile_seek_data);
 DEFINE_XFILE_EVENT(xfile_get_folio);
 DEFINE_XFILE_EVENT(xfile_put_folio);
+DEFINE_XFILE_EVENT(xfile_discard);
 
 TRACE_EVENT(xfarray_create,
 	TP_PROTO(struct xfarray *xfa, unsigned long long required_capacity),
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 8cdd863db5850..4e254a0ba0036 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -310,3 +310,15 @@ xfile_put_folio(
 	folio_unlock(folio);
 	folio_put(folio);
 }
+
+/* Discard the page cache that's backing a range of the xfile. */
+void
+xfile_discard(
+	struct xfile		*xf,
+	loff_t			pos,
+	u64			count)
+{
+	trace_xfile_discard(xf, pos, count);
+
+	shmem_truncate_range(file_inode(xf->file), pos, pos + count - 1);
+}
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index 76d78dba7e347..8dfbae1fe33a5 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -17,6 +17,7 @@ int xfile_load(struct xfile *xf, void *buf, size_t count, loff_t pos);
 int xfile_store(struct xfile *xf, const void *buf, size_t count,
 		loff_t pos);
 
+void xfile_discard(struct xfile *xf, loff_t pos, u64 count);
 loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
 
 #define XFILE_MAX_FOLIO_SIZE	(PAGE_SIZE << MAX_PAGECACHE_ORDER)

