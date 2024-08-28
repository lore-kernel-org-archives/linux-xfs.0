Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCBD1A08C0
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 18:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724868885; cv=none; b=JFs5qHJc0ApF2ZS5PG7revHLxnAtdFAkin4P3Go1sE1J/nvfmATH90Bf9YoMAffWFnHytlhD9zcWOtZKo7k/DcvLmvQMAqSv6Ccqh+NUCjatCtNUMpQnuw+tGsCNoh0ak1vhvaovucf3EBE/Kj34IBKig8yj6xrJirgN6AC02WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724868885; c=relaxed/simple;
	bh=EltExVNBVtwXO0doVvNv0FiKr0r4Lz2Ykpk1zb9lm4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JxlbaPWHkf24vWlacoLryU/7JjxGxAVpzA6PlgtFffyY6ZmSPeVo/pSz6ET0wXUoNknZ2aT9vSwP2LL3U2G05akPhU7AGwEkyOHd+amuyG7wuoYFW5UBMfCu1PRgEMMxP7uZ2BqllqXLZe+gvRZAdYH2mIq4qtKWBFUB/9DAWD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IhfnJBPw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IhfnJBPw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724868881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y08YxeU7UkCu8KXIjOZTX6xc9D1+311RxroFnSp6Kjc=;
	b=IhfnJBPwlWw7aK9xJxjmis/BS4IElW4nKtkApQmlVJ7ELKMGXRAHX/e/xv39nRSr0z3LRD
	2+t+oBVPCxwuODXh3g+zX3m08y5QwIN70FX5cAq0a8PekxxObwtmwq5tBw043uFuq6kIi7
	xKWfOSYql/CieXoKrCgZs5JClsGJ7lw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-OOUI5mS1P_mQuL46k4M3jA-1; Wed,
 28 Aug 2024 14:14:38 -0400
X-MC-Unique: OOUI5mS1P_mQuL46k4M3jA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56D651955D45;
	Wed, 28 Aug 2024 18:14:37 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.95])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4065319560A3;
	Wed, 28 Aug 2024 18:14:36 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	josef@toxicpanda.com,
	david@fromorbit.com
Subject: [PATCH v2 2/4] fsx: factor out a file size update helper
Date: Wed, 28 Aug 2024 14:15:32 -0400
Message-ID: <20240828181534.41054-3-bfoster@redhat.com>
In-Reply-To: <20240828181534.41054-1-bfoster@redhat.com>
References: <20240828181534.41054-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

In preparation for support for eof page pollution, factor out a file
size update helper. This updates the internally tracked file size
based on the upcoming operation and zeroes the appropriate range in
the good buffer for extending operations.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 ltp/fsx.c | 49 +++++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index c5727cff..4a9be0e1 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -983,6 +983,17 @@ gendata(char *original_buf, char *good_buf, unsigned offset, unsigned size)
 	}
 }
 
+/*
+ * Helper to update the tracked file size. If the offset begins beyond current
+ * EOF, zero the range from EOF to offset in the good buffer.
+ */
+void
+update_file_size(unsigned offset, unsigned size)
+{
+	if (offset > file_size)
+		memset(good_buf + file_size, '\0', offset - file_size);
+	file_size = offset + size;
+}
 
 void
 dowrite(unsigned offset, unsigned size)
@@ -1003,10 +1014,8 @@ dowrite(unsigned offset, unsigned size)
 	log4(OP_WRITE, offset, size, FL_NONE);
 
 	gendata(original_buf, good_buf, offset, size);
-	if (file_size < offset + size) {
-		if (file_size < offset)
-			memset(good_buf + file_size, '\0', offset - file_size);
-		file_size = offset + size;
+	if (offset + size > file_size) {
+		update_file_size(offset, size);
 		if (lite) {
 			warn("Lite file size bug in fsx!");
 			report_failure(149);
@@ -1070,10 +1079,8 @@ domapwrite(unsigned offset, unsigned size)
 	log4(OP_MAPWRITE, offset, size, FL_NONE);
 
 	gendata(original_buf, good_buf, offset, size);
-	if (file_size < offset + size) {
-		if (file_size < offset)
-			memset(good_buf + file_size, '\0', offset - file_size);
-		file_size = offset + size;
+	if (offset + size > file_size) {
+		update_file_size(offset, size);
 		if (lite) {
 			warn("Lite file size bug in fsx!");
 			report_failure(200);
@@ -1136,9 +1143,7 @@ dotruncate(unsigned size)
 
 	log4(OP_TRUNCATE, 0, size, FL_NONE);
 
-	if (size > file_size)
-		memset(good_buf + file_size, '\0', size - file_size);
-	file_size = size;
+	update_file_size(size, 0);
 
 	if (testcalls <= simulatedopcount)
 		return;
@@ -1247,16 +1252,8 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
 	log4(OP_ZERO_RANGE, offset, length,
 	     keep_size ? FL_KEEP_SIZE : FL_NONE);
 
-	if (!keep_size && end_offset > file_size) {
-		/*
-		 * If there's a gap between the old file size and the offset of
-		 * the zero range operation, fill the gap with zeroes.
-		 */
-		if (offset > file_size)
-			memset(good_buf + file_size, '\0', offset - file_size);
-
-		file_size = end_offset;
-	}
+	if (!keep_size && end_offset > file_size)
+		update_file_size(offset, length);
 
 	if (testcalls <= simulatedopcount)
 		return;
@@ -1538,10 +1535,8 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
 
 	log5(OP_CLONE_RANGE, offset, length, dest, FL_NONE);
 
-	if (dest > file_size)
-		memset(good_buf + file_size, '\0', dest - file_size);
 	if (dest + length > file_size)
-		file_size = dest + length;
+		update_file_size(dest, length);
 
 	if (testcalls <= simulatedopcount)
 		return;
@@ -1757,10 +1752,8 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
 
 	log5(OP_COPY_RANGE, offset, length, dest, FL_NONE);
 
-	if (dest > file_size)
-		memset(good_buf + file_size, '\0', dest - file_size);
 	if (dest + length > file_size)
-		file_size = dest + length;
+		update_file_size(dest, length);
 
 	if (testcalls <= simulatedopcount)
 		return;
@@ -1848,7 +1841,7 @@ do_preallocate(unsigned offset, unsigned length, int keep_size)
 
 	if (end_offset > file_size) {
 		memset(good_buf + file_size, '\0', end_offset - file_size);
-		file_size = end_offset;
+		update_file_size(offset, length);
 	}
 
 	if (testcalls <= simulatedopcount)
-- 
2.45.0

