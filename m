Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9571E24EF8F
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 14:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408338; cv=none; b=fhcvKNm/rqTCUQEpqBdtdwNBcJxLxUxfAOvY+56xSv3XApPdXPs2bpO7Vc6ZfG4uWW+6162kpuuyJhYDyjFYJt9HLYXoRMj3D1n78jchp0kNH6VYSDFYGHthosyMPWP9X1clS+MTWtMJ80QHQ+sM29kZg13PlVj9oPtzG/HyQ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408338; c=relaxed/simple;
	bh=j2Z1IZLlvSar+KKw/lOOG5Nj2051ElfgVGncxY0sfEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dcbc7u871IePNMbyxUB66kU2gcqk3s3G/Qx5cCZ6ydbic1ybcNovwik/D4YoHnfk/balyWRVGrOO6aOsAW/3ZiZoeJo6Rp4GwtJEOJ1JrjNhbOrrubweUyDYLuuYpmfzXijvYEDOGHFXvv/yXECxpYem8IQJYne7Fu7ViYuhsQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jQGzbz0c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jQGzbz0c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740408335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/50YoxcClbm8VBalwlKPG61QNGbv8mkZkX5giUEfsyw=;
	b=jQGzbz0cGlPOf8rzoDfc3swNj8o7ZWek9kRZAQ3A+ZHyrC22v5jQKkgfX3ig9+lp5vt6vS
	cNtY7nUI5WBRLRl4rW1NexOOQF57Bh0zrDLV5o+0jsmv8SjVpNqcGRSRwAJ+ldT0lrnE8t
	DYEE3m46z+dOK5DE7SpRh8440fI3Ku0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-85-kB37VTtWOjuAJVDz6AM7og-1; Mon,
 24 Feb 2025 09:45:29 -0500
X-MC-Unique: kB37VTtWOjuAJVDz6AM7og-1
X-Mimecast-MFC-AGG-ID: kB37VTtWOjuAJVDz6AM7og_1740408329
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF03D190F9EA;
	Mon, 24 Feb 2025 14:45:28 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.79])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE77A19560AA;
	Mon, 24 Feb 2025 14:45:27 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v3 07/12] dax: advance the iomap_iter on unshare range
Date: Mon, 24 Feb 2025 09:47:52 -0500
Message-ID: <20250224144757.237706-8-bfoster@redhat.com>
In-Reply-To: <20250224144757.237706-1-bfoster@redhat.com>
References: <20250224144757.237706-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Advance the iter and return 0 or an error code for success or
failure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/dax.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index f4d8c8c10086..c0fbab8c66f7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1266,11 +1266,11 @@ static s64 dax_unshare_iter(struct iomap_iter *iter)
 	u64 copy_len = iomap_length(iter);
 	u32 mod;
 	int id = 0;
-	s64 ret = 0;
+	s64 ret = iomap_length(iter);
 	void *daddr = NULL, *saddr = NULL;
 
 	if (!iomap_want_unshare_iter(iter))
-		return iomap_length(iter);
+		return iomap_iter_advance(iter, &ret);
 
 	/*
 	 * Extend the file range to be aligned to fsblock/pagesize, because
@@ -1307,7 +1307,9 @@ static s64 dax_unshare_iter(struct iomap_iter *iter)
 
 out_unlock:
 	dax_read_unlock(id);
-	return dax_mem2blk_err(ret);
+	if (ret < 0)
+		return dax_mem2blk_err(ret);
+	return iomap_iter_advance(iter, &ret);
 }
 
 int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
-- 
2.48.1

