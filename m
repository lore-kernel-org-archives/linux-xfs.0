Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F6F12882F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422813; cv=none; b=JZE38xjv/qlLCRdOCASOHINZruAZbdwbrJCgz3HV++1S88+Qh5KTTH0PyH4szJAQ6xHWjzwxI6Q6et1jE+T4LW6xTs+PrAfwWyGegCgZWEYrAzSOptf38xdrLOnWkHHfOfBXe2bvVJBP1bUSfPwJhzdr0Gwl1aqp20xOTCx+v3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422813; c=relaxed/simple;
	bh=G0UE7OO9gToXmxxc7ZfqwgmWoY4hDAR0oXezJv6tqI8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E5GpfhWdsNDjR/zOpqf8E7TpCqUVINhqYvd++3zl5NzK7rI2DVQQlc/XGPXA0FB14Yr8hyuv0Ey4NtF69cDYGMHoegxR+v8B6ZNjPBGSvT/dLjvoDqxyhnqsbligu9HywFNW5eAOwRyz4Rm0Mr4WAG2GAKNqzpMyBc8QW+Vv2Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jl4Evkrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jl4Evkrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FBBC433F1;
	Tue, 26 Mar 2024 03:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422812;
	bh=G0UE7OO9gToXmxxc7ZfqwgmWoY4hDAR0oXezJv6tqI8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jl4EvkrwfWPHsSSS/GBQ4EqoCzQi2ZB4zh7BS9uGMO0qKvavOvqaKE2ehbvk/b4+a
	 juKrUJH5rzxDv0pzTOnXy6fmmFSFa+X32z+DzcNGzAIrZ24cj4IXQMNdtkcSb5peKH
	 WjCUYeFdUo4yuDGy7kp3WZEHvqnHsK45d+voh7Pp0mpQaYazmvFgAXrTu0zPbw4GZr
	 aavgzJbsQZZRghdtFADBLcyRsEvIrO3ni8WPe+iTB+5vW+m3fjdG6lpUEBXH3EHPrS
	 2qyscdDHAUfBaZRGuaxrBGKZ1ALHiaChSX3cr8uRWGTpkxsafAEFtSS6K6h/fCLBjj
	 +BYl+P89f8DpQ==
Date: Mon, 25 Mar 2024 20:13:31 -0700
Subject: [PATCH 41/67] xfs: create a ranged query function for refcount btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127553.2212320.3913297269314889338.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: d12bf8bac87a0d93e6e5fab67f399d1e3d3d5767

Implement ranged queries for refcount records.  The next patch will use
this to scan refcount data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_refcount.c |   41 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_refcount.h |   10 ++++++++++
 2 files changed, 51 insertions(+)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 3377fac1283b..de321ab9d91d 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -2030,6 +2030,47 @@ xfs_refcount_has_records(
 	return xfs_btree_has_records(cur, &low, &high, NULL, outcome);
 }
 
+struct xfs_refcount_query_range_info {
+	xfs_refcount_query_range_fn	fn;
+	void				*priv;
+};
+
+/* Format btree record and pass to our callback. */
+STATIC int
+xfs_refcount_query_range_helper(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*rec,
+	void				*priv)
+{
+	struct xfs_refcount_query_range_info	*query = priv;
+	struct xfs_refcount_irec	irec;
+	xfs_failaddr_t			fa;
+
+	xfs_refcount_btrec_to_irec(rec, &irec);
+	fa = xfs_refcount_check_irec(cur->bc_ag.pag, &irec);
+	if (fa)
+		return xfs_refcount_complain_bad_rec(cur, fa, &irec);
+
+	return query->fn(cur, &irec, query->priv);
+}
+
+/* Find all refcount records between two keys. */
+int
+xfs_refcount_query_range(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*low_rec,
+	const struct xfs_refcount_irec	*high_rec,
+	xfs_refcount_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_irec		low_brec = { .rc = *low_rec };
+	union xfs_btree_irec		high_brec = { .rc = *high_rec };
+	struct xfs_refcount_query_range_info query = { .priv = priv, .fn = fn };
+
+	return xfs_btree_query_range(cur, &low_brec, &high_brec,
+			xfs_refcount_query_range_helper, &query);
+}
+
 int __init
 xfs_refcount_intent_init_cache(void)
 {
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 5c207f1c619c..9b56768a590c 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -127,4 +127,14 @@ extern struct kmem_cache	*xfs_refcount_intent_cache;
 int __init xfs_refcount_intent_init_cache(void);
 void xfs_refcount_intent_destroy_cache(void);
 
+typedef int (*xfs_refcount_query_range_fn)(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*rec,
+	void				*priv);
+
+int xfs_refcount_query_range(struct xfs_btree_cur *cur,
+		const struct xfs_refcount_irec *low_rec,
+		const struct xfs_refcount_irec *high_rec,
+		xfs_refcount_query_range_fn fn, void *priv);
+
 #endif	/* __XFS_REFCOUNT_H__ */

