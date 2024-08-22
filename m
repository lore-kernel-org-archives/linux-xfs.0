Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA89D1CB329
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724337815; cv=none; b=l3KSjJNzLqNUYW6j6z3azLDdlkIdPJ/ZnDOnU4ALncryJmWAwrWzQxONf9bXDBgHJ/Qa8OJh5mHiRXKK7bHCBq/qY0JzNlFbrziixdHirujewkQbN4zDAZVaSXOlcxGazVWn+ETpztJPWqA3v+fyzuXax71mn2BbaRGe+YbP3Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724337815; c=relaxed/simple;
	bh=TFrEpCnesysnmYAvs9EYmztY/dTDib3PCLJW94whfqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vEWXDbyMNtXzoiiqWYNtuMkk5AbtMOrPXgkZc7I2rHpTqn7vifI/IZKppt6H3ouFHs5kyG+ZQABrNkGrRouJv3gS8gmbm6u9bER9xD4Yxnjya5pNlD1aXXw+UMRLEp9I/sq/KXSS9xAvj/NVl2hwOj5Xl/qp31pAaUQF2P1l61o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X1tJjxto; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X1tJjxto"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724337811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Zr6fJxUvK+xuRtzh+ncmJZDLdg6ZMXpqk5SinzTLCg=;
	b=X1tJjxtonfCeA+lhYk+8qgFodfnom2kW0KKQaC1HCGmrt5cF2lJXZ8rNQt/IJOcL9SGEaV
	O3mG9ObTk+LYVhyEeVOzg85mygL1bLsjSxpK/fD9uubjtXifmewgZIIzL2g/is/X9HFcjx
	XttX8rywBMCr227esBPEz8NcLpMla1s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-7ndLi2pbPRuIZgLA7HpCKA-1; Thu,
 22 Aug 2024 10:43:28 -0400
X-MC-Unique: 7ndLi2pbPRuIZgLA7HpCKA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DC641955D50;
	Thu, 22 Aug 2024 14:43:27 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.33.147])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E57801956053;
	Thu, 22 Aug 2024 14:43:25 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	josef@toxicpanda.com,
	david@fromorbit.com
Subject: [PATCH 1/3] fsx: factor out a file size update helper
Date: Thu, 22 Aug 2024 10:44:20 -0400
Message-ID: <20240822144422.188462-2-bfoster@redhat.com>
In-Reply-To: <20240822144422.188462-1-bfoster@redhat.com>
References: <20240822144422.188462-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

In preparation for support for eof page pollution, factor out a file
size update helper. This updates the internally tracked file size
based on the upcoming operation and zeroes the appropriate range in
the good buffer for extending operations.

Note that a handful of callers currently make these updates after
performing the associated operation. Order is not important to
current behavior, but it will be for a follow on patch, so make
those calls a bit earlier as well.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 ltp/fsx.c | 57 +++++++++++++++++++++++++------------------------------
 1 file changed, 26 insertions(+), 31 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 2dc59b06..1389c51d 100644
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
@@ -1247,6 +1252,9 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
 	log4(OP_ZERO_RANGE, offset, length,
 	     keep_size ? FL_KEEP_SIZE : FL_NONE);
 
+	if (end_offset > file_size)
+		update_file_size(offset, length);
+
 	if (testcalls <= simulatedopcount)
 		return;
 
@@ -1263,17 +1271,6 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
 	}
 
 	memset(good_buf + offset, '\0', length);
-
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
 }
 
 #else
@@ -1538,6 +1535,9 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
 
 	log5(OP_CLONE_RANGE, offset, length, dest, FL_NONE);
 
+	if (dest + length > file_size)
+		update_file_size(dest, length);
+
 	if (testcalls <= simulatedopcount)
 		return;
 
@@ -1556,10 +1556,6 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
 	}
 
 	memcpy(good_buf + dest, good_buf + offset, length);
-	if (dest > file_size)
-		memset(good_buf + file_size, '\0', dest - file_size);
-	if (dest + length > file_size)
-		file_size = dest + length;
 }
 
 #else
@@ -1756,6 +1752,9 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
 
 	log5(OP_COPY_RANGE, offset, length, dest, FL_NONE);
 
+	if (dest + length > file_size)
+		update_file_size(dest, length);
+
 	if (testcalls <= simulatedopcount)
 		return;
 
@@ -1792,10 +1791,6 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
 	}
 
 	memcpy(good_buf + dest, good_buf + offset, length);
-	if (dest > file_size)
-		memset(good_buf + file_size, '\0', dest - file_size);
-	if (dest + length > file_size)
-		file_size = dest + length;
 }
 
 #else
@@ -1846,7 +1841,7 @@ do_preallocate(unsigned offset, unsigned length, int keep_size)
 
 	if (end_offset > file_size) {
 		memset(good_buf + file_size, '\0', end_offset - file_size);
-		file_size = end_offset;
+		update_file_size(offset, length);
 	}
 
 	if (testcalls <= simulatedopcount)
-- 
2.45.0

