Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D743AC0F0
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 19:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778700717; cv=none; b=hcIfUobdB3ehT0QN0PoL/UXgMZKisoVGdX9yEZ3/B6SMOBPLXdTX4ndDAVMyG8zmDyYMe5N9MFx+QyHZebB2cYVEs4qqKDXZlDysvDzEGqi0GYldBKOZI4KzJ8z0KQSYzeEdDO5q7PEIXmVz+B+C2/0eNqMMqBBrquHYnCcJIbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778700717; c=relaxed/simple;
	bh=bPSzBltpqbz023judXexxILYXsAsLPvxrb9cWxUDGww=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIUU5VkSjh9QnQHRkWSznI5Z0uOv85kCisd6YJMApy77uu4NDaV9Mx+xmj97mM34wIaW1/jZvNAwJv6XzKhu3gJGFB/sch6bQBVwd6K7qSaQJBvuE5En8c5ZMXpmFJDBdpOmZr2DmAfGewEgpa/EhG5sBJkC2VSEFPjQDsXg1kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FvnPrm8F; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FvnPrm8F; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FvnPrm8F";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FvnPrm8F"
Received: from localhost.localdomain (unknown [10.128.32.2])
	by smtp-out1.suse.de (Postfix) with ESMTP id 4A8146A82F
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 19:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778700710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w+Xr2ShSuOzbWcEFPV1o/KRzbf6leOcx70AXFgTAykM=;
	b=FvnPrm8F15j67hKvnWeEc4NrBRWYJ+wV+RoX/hUdVs1GMkHL5qBeXRaRg+aOvmaYD8+lCJ
	FgDBcoT3k3JcQgQYJPmXlik5NUwFtf5lurq8N+QeXVoNpysWXQyZV5JjI2U+q2WhC0sDyR
	C3oaerw2ddWdIwuTmZWg1jC5xQ/WC6g=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778700710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w+Xr2ShSuOzbWcEFPV1o/KRzbf6leOcx70AXFgTAykM=;
	b=FvnPrm8F15j67hKvnWeEc4NrBRWYJ+wV+RoX/hUdVs1GMkHL5qBeXRaRg+aOvmaYD8+lCJ
	FgDBcoT3k3JcQgQYJPmXlik5NUwFtf5lurq8N+QeXVoNpysWXQyZV5JjI2U+q2WhC0sDyR
	C3oaerw2ddWdIwuTmZWg1jC5xQ/WC6g=
From: Anthony Iliopoulos <ailiop@suse.com>
To: <linux-xfs@vger.kernel.org>
Subject: [PATCH 2/4] libfrog: add missing statmount flag definitions
Date: Wed, 13 May 2026 21:30:38 +0200
Message-ID: <20260513193040.2130-3-ailiop@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260513193040.2130-1-ailiop@suse.com>
References: <20260513193040.2130-1-ailiop@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.75
X-Spamd-Result: default: False [-2.75 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.15)[-0.760];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,localhost.localdomain:helo]
X-Spam-Level: 

Add definitions for STATMOUNT_MNT_BASIC and STATMOUNT_MNT_POINT to support
compilation of xfs_healer on systems with older kernel headers that predate
the statmount syscall (introduced in v6.8).

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 libfrog/statmount.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libfrog/statmount.h b/libfrog/statmount.h
index 7e281ce93029..b6f1338830a0 100644
--- a/libfrog/statmount.h
+++ b/libfrog/statmount.h
@@ -52,6 +52,14 @@ struct statmount {
 
 /* all the new flags added since the beginning of statmount */
 
+#ifndef STATMOUNT_MNT_BASIC
+#define STATMOUNT_MNT_BASIC		0x00000002U     /* Want/got mnt_... */
+#endif
+
+#ifndef STATMOUNT_MNT_POINT
+#define STATMOUNT_MNT_POINT		0x00000010U     /* Want/got mnt_point */
+#endif
+
 #ifndef STATMOUNT_MNT_NS_ID
 #define STATMOUNT_MNT_NS_ID		0x00000040U	/* Want/got mnt_ns_id */
 #endif
-- 
2.49.0

