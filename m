Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081B331AAA7
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 15:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769701835; cv=none; b=qnxt8O5JvovC0Fmalb50dl7M4r+3uqtSmRmttVQG1vgQDBOjiYSX8AwmCzxca30NR3c7W51vm4ffUs/2G8YPVYnxYZCzzyHGTmDaT9bujJll1olngnyofBHK24DcoQDHZd87S3VBAdc/S0reyhoaWL7jl4kimFsqepPuuNvKP/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769701835; c=relaxed/simple;
	bh=+obdHtwl/4dPnbMylYX5zs+oa5cL7tHvzZQP2nLX7u0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mlS8l4lY/zBCB0T1yg6XQHT4HyprhXxkaiJj4sh+LDfjLxPc1FmumGk4Qb/7dILDDOuiNQUznrSk59JD1bp/W0TVUT2VOuvxM/a/C81g822I6oJwxVoPgoWdk3uDEhbt2C5Dl4bGBSnp4LGKzwSarpoB2mSg27Z8m2Qv9DBvxdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c5KsdlLN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c5KsdlLN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769701833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x+HFio3eufWe4kWp7D9KOmJycjCFWxb9enB26dubt3w=;
	b=c5KsdlLNBjUOl9NK2B1izwPOw5B2lnBRdLq1xz/5VbHQBLmd1+J88diFm51HIgyRUyURuJ
	m4KH5W16jnioOlmuUKmM+TAi0g6QeMcJ8fhrGTJsaiRYkiIqZBCcPsLT6Z4SSrq8nI4X3T
	Fcs4Vo1aGV2eCdOKETU6I4pv+foOPFQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-bzdsQyLVNJeDXeqrDJoAkQ-1; Thu,
 29 Jan 2026 10:50:31 -0500
X-MC-Unique: bzdsQyLVNJeDXeqrDJoAkQ-1
X-Mimecast-MFC-AGG-ID: bzdsQyLVNJeDXeqrDJoAkQ_1769701830
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4D4A18002C2;
	Thu, 29 Jan 2026 15:50:30 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.81.70])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3563F1800109;
	Thu, 29 Jan 2026 15:50:30 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/5] xfs: flush eof folio before insert range size update
Date: Thu, 29 Jan 2026 10:50:25 -0500
Message-ID: <20260129155028.141110-3-bfoster@redhat.com>
In-Reply-To: <20260129155028.141110-1-bfoster@redhat.com>
References: <20260129155028.141110-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

The flush in xfs_buffered_write_iomap_begin() for zero range over a
data fork hole fronted by COW fork prealloc is primarily designed to
provide correct zeroing behavior in particular pagecache conditions.
As it turns out, this also partially masks some odd behavior in
insert range (via zero range via setattr).

Insert range bumps i_size the length of the new range, flushes,
unmaps pagecache and cancels COW prealloc, and then right shifts
extents from the end of the file back to the target offset of the
insert. Since the i_size update occurs before the pagecache flush,
this creates a transient situation where writeback around EOF can
behave differently.

This appears to be corner case situation, but if happens to be
fronted by COW fork speculative preallocation and a large, dirty
folio that contains at least one full COW block beyond EOF, the
writeback after i_size is bumped may remap that COW fork block into
the data fork within EOF. The block is zeroed and then shifted back
out to post-eof, but this is unexpected in that it leads to a
written post-eof data fork block. This can cause a zero range
warning on a subsequent size extension, because we should never find
blocks that require physical zeroing beyond i_size.

To avoid this quirk, flush the EOF folio before the i_size update
during insert range. The entire range will be flushed, unmapped and
invalidated anyways, so this should be relatively unnoticeable.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7874cf745af3..1f2730558165 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1227,6 +1227,23 @@ xfs_falloc_insert_range(
 	if (offset >= isize)
 		return -EINVAL;
 
+	/*
+	 * Let writeback clean up EOF folio state before we bump i_size. The
+	 * insert flushes before it starts shifting and under certain
+	 * circumstances we can write back blocks that should technically be
+	 * considered post-eof (and thus should not be submitted for writeback).
+	 *
+	 * For example, a large, dirty folio that spans EOF and is backed by
+	 * post-eof COW fork preallocation can cause block remap into the data
+	 * fork. This shifts back out beyond EOF, but creates an expectedly
+	 * written post-eof block. The insert is going to flush, unmap and
+	 * cancel prealloc across this whole range, so flush EOF now before we
+	 * bump i_size to provide consistent behavior.
+	 */
+	error = filemap_write_and_wait_range(inode->i_mapping, isize, isize);
+	if (error)
+		return error;
+
 	error = xfs_falloc_setsize(file, isize + len);
 	if (error)
 		return error;
-- 
2.52.0

