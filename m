Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AE4157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224964; cv=none; b=unRiA/iM87K/Gu08ESoP5mioXwXuzL7c5BQzEfVQjim3CFEVf6zE776PEh51WdzGXn2Ks/O6+BmDlHiLLnNG2kkpxzu71KMABzGy2v2jBgJTKeUwrRFgYfsY7RjGCKQcj7vFx8zwUr8nIOgXUaohkBR047lOl/2+2XEHgqFrECA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224964; c=relaxed/simple;
	bh=JBswXr+DQLBCiVPV8pMnpdI2JS0Icmpq0C05UcO89JI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KZHUwkUiRlakrZJSSU7c3j3aH5uSDQBtxwZ7rYyUfFEk3dcktm/XNXLJzxgfM9ynlHysRxVV0vKmTZpaRmW9PCr32NXEwLNuIKgFom4xnrXYyBoabIl2K1tzjJjYnfuNQ7dMrm0V9TXSKlSF4FyrQ5dV6sH6ZWr62VOBcJ9zypk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W2Z0dQv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W2Z0dQv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA16C113CC;
	Mon, 15 Apr 2024 23:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224964;
	bh=JBswXr+DQLBCiVPV8pMnpdI2JS0Icmpq0C05UcO89JI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W2Z0dQv3DIEeCFaUNYblxixZYV4r+9t5ACHRVXp0sbKh186Z8OOawMBRGrJp8fHde
	 dAatCt0rhReK5l/f+GFZym2HKO6RGtCcc7xSS0XEyTFoSuZIa+9VHc8/3Xui9a6k83
	 jYnOz1GEgEbAYTZLc7oD9XjMjpHs3pjTKraw+S3Y50YmNRkd3Fr6zzyS+zDR2lmxNY
	 JMQ4pNjn8Il8QNhhQusavnf7ERGeyyS6oscOCqsg4nsiK9c3t8ywGQ0sVvZKDKdZt3
	 wQP4/0jY3WzAwjtPfrCOHn3ziTDnS9ZByeJCpq7wHgUv1Cg4KL4jFUJeAYw+ivcyO6
	 vZ1h/6OlKPSAg==
Date: Mon, 15 Apr 2024 16:49:24 -0700
Subject: [PATCH 1/7] xfs: enable discarding of folios backing an xfile
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383097.88776.2091431390251169750.stgit@frogsfrogsfrogs>
In-Reply-To: <171322383061.88776.6099178844393502891.stgit@frogsfrogsfrogs>
References: <171322383061.88776.6099178844393502891.stgit@frogsfrogsfrogs>
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
index 8d05f2adae3d..7d07912d8f75 100644
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
index 8cdd863db585..4e254a0ba003 100644
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
index 76d78dba7e34..8dfbae1fe33a 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -17,6 +17,7 @@ int xfile_load(struct xfile *xf, void *buf, size_t count, loff_t pos);
 int xfile_store(struct xfile *xf, const void *buf, size_t count,
 		loff_t pos);
 
+void xfile_discard(struct xfile *xf, loff_t pos, u64 count);
 loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
 
 #define XFILE_MAX_FOLIO_SIZE	(PAGE_SIZE << MAX_PAGECACHE_ORDER)

