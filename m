Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE8F1AAE18
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 18:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724868887; cv=none; b=F5ioPOCEYJXCiuXRyk0OFcMAqf2W4hemVO3vNG+7ujvjFrluWaGqj07olkx054SKVpYp8wTvPsUiN3OfE+ELze6C0uOnDNcZ9IXZwn8pid4ZNZgD/2PtK7t6wlxxXRqajoiMrNCtRRhO0b2xoGJidIsN2U9eBCeZIdEQsNBcxK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724868887; c=relaxed/simple;
	bh=cHRUz83EMXaqlfUJ9OTVmO+N10HSLJcP+o16mw1uDtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SEHdrDHdQNsLIJNi4uNNOpupJuLk9eqQuIqVluys3HQ+WN7+IF4PDqtLpnL6KA5yNHkazEgVuQ/nrRmDBkoYYsOdXMJli+WWxBdq5OJ5DwTQcdTP9DmCp8UEIkOHKqjJohiWNFHcvfom9dMQKz/7ZGd7Wx7DTTU7EvCpvGdhuag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S7VhhFSs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S7VhhFSs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724868884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yt9reNIdExQOeIUP0ueGXEa/D+je1P4YQPbZxIQzm0Y=;
	b=S7VhhFSs/HymbOT2VVkqeFWbl4aIk2h06PgUx4rbK+KT+vXhQLFfJOC7iisGp3nBbJkmgE
	0Fjj6r8/Fo4wczZb/yu/ymTfX+edHq98PI2Uka8DCfAB517ElqFJttYBBGXKK45yeXbqbI
	h13kR/F87puVgW0uy8zk5E6FdzNOt0M=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-O_KnlUshPYCdEKDZes_H4g-1; Wed,
 28 Aug 2024 14:14:40 -0400
X-MC-Unique: O_KnlUshPYCdEKDZes_H4g-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF6991955D4B;
	Wed, 28 Aug 2024 18:14:35 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.95])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D798119560A3;
	Wed, 28 Aug 2024 18:14:34 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	josef@toxicpanda.com,
	david@fromorbit.com
Subject: [PATCH v2 1/4] fsx: don't skip file size and buf updates on simulated ops
Date: Wed, 28 Aug 2024 14:15:31 -0400
Message-ID: <20240828181534.41054-2-bfoster@redhat.com>
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

fsx supports the ability to skip through a certain number of
operations of a given command sequence before beginning full
operation. The way this works is by tracking the operation count,
simulating minimal side effects of skipped operations in-memory, and
then finally writing out the in-memory state to the target file when
full operation begins.

Several fallocate() related operations don't correctly track
in-memory state when simulated, however. For example, consider an
ops file with the following two operations:

  zero_range 0x0 0x1000 0x0
  read 0x0 0x1000 0x0

... and an fsx run like so:

  fsx -d -b 2 --replay-ops=<opsfile> <file>

This simulates the zero_range operation, but fails to track the file
extension that occurs as a side effect such that the subsequent read
doesn't occur as expected:

  Will begin at operation 2
  skipping zero size read

The read is skipped in this case because the file size is zero.  The
proper behavior, and what is consistent with other size changing
operations, is to make the appropriate in-core changes before
checking whether an operation is simulated so the end result of
those changes can be reflected on-disk for eventual non-simulated
operations. This results in expected behavior with the same ops file
and test command:

  Will begin at operation 2
  2 read  0x0 thru        0xfff   (0x1000 bytes)

Update zero, copy and clone range to do the file size and EOF change
related zeroing before checking against the simulated ops count.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 ltp/fsx.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 2dc59b06..c5727cff 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1247,6 +1247,17 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
 	log4(OP_ZERO_RANGE, offset, length,
 	     keep_size ? FL_KEEP_SIZE : FL_NONE);
 
+	if (!keep_size && end_offset > file_size) {
+		/*
+		 * If there's a gap between the old file size and the offset of
+		 * the zero range operation, fill the gap with zeroes.
+		 */
+		if (offset > file_size)
+			memset(good_buf + file_size, '\0', offset - file_size);
+
+		file_size = end_offset;
+	}
+
 	if (testcalls <= simulatedopcount)
 		return;
 
@@ -1263,17 +1274,6 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
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
@@ -1538,6 +1538,11 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
 
 	log5(OP_CLONE_RANGE, offset, length, dest, FL_NONE);
 
+	if (dest > file_size)
+		memset(good_buf + file_size, '\0', dest - file_size);
+	if (dest + length > file_size)
+		file_size = dest + length;
+
 	if (testcalls <= simulatedopcount)
 		return;
 
@@ -1556,10 +1561,6 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
 	}
 
 	memcpy(good_buf + dest, good_buf + offset, length);
-	if (dest > file_size)
-		memset(good_buf + file_size, '\0', dest - file_size);
-	if (dest + length > file_size)
-		file_size = dest + length;
 }
 
 #else
@@ -1756,6 +1757,11 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
 
 	log5(OP_COPY_RANGE, offset, length, dest, FL_NONE);
 
+	if (dest > file_size)
+		memset(good_buf + file_size, '\0', dest - file_size);
+	if (dest + length > file_size)
+		file_size = dest + length;
+
 	if (testcalls <= simulatedopcount)
 		return;
 
@@ -1792,10 +1798,6 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
 	}
 
 	memcpy(good_buf + dest, good_buf + offset, length);
-	if (dest > file_size)
-		memset(good_buf + file_size, '\0', dest - file_size);
-	if (dest + length > file_size)
-		file_size = dest + length;
 }
 
 #else
-- 
2.45.0

