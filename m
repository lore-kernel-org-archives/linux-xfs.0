Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBE63AD53F
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 19:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778700723; cv=none; b=t4Xs7RNV/iWOww0UDmtHttdCdO3dI5XW/PoVydULYJS8czOwkTj1FyVTFuD1ISgBpDuz1CKPEml63+fZHA3b6KdCTym1oZx+Rcno9uCSF+k0PFFJY+/07mByqMjpVF/bBgOWySRJ5VuCMM6i3XnkmWRlTqVv4EqK8ma/pq7uOVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778700723; c=relaxed/simple;
	bh=ZSOwrF874+4BnFhUNzNRXd6MLu4n9eTlmMsW15FtZGc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FndM+kbR7gGuwuwSxD963Q24Et1nwuoydn3eAI+uau3kRo7RRM/PkOUfy/OJyZPXOC5KsohWawScg6e8z5JwWjAs+62ZqtGJ5TJ5uyfXQOOEpH8GucvcWAeuqMVdmF4DQ6M8ycr+t94FJYzNNh8mUUV9oFY++ydxqPdcc4nUCPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Sp/ksL5g; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Sp/ksL5g; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Sp/ksL5g";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Sp/ksL5g"
Received: from localhost.localdomain (unknown [10.128.32.2])
	by smtp-out1.suse.de (Postfix) with ESMTP id 7005E6A802
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 19:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778700713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KrEIYNC53mbzP6RE48lsJd1r/QKtt3G9Ti3kiDqOyU8=;
	b=Sp/ksL5guupHnYbSg/3ajS0lsbne42oGZJ795rZ0KVErG06wpRfugV50BTZ/u8Y0e2V7kE
	DFy8PwFLzIUd91gjyt+3vhYE00IcldgGKev+vOSTBLLIjXaE94jvSdghSwGPV/tXSeMAam
	WlK+66Uak6ErpRif2nsstaOFe0qt5UY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778700713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KrEIYNC53mbzP6RE48lsJd1r/QKtt3G9Ti3kiDqOyU8=;
	b=Sp/ksL5guupHnYbSg/3ajS0lsbne42oGZJ795rZ0KVErG06wpRfugV50BTZ/u8Y0e2V7kE
	DFy8PwFLzIUd91gjyt+3vhYE00IcldgGKev+vOSTBLLIjXaE94jvSdghSwGPV/tXSeMAam
	WlK+66Uak6ErpRif2nsstaOFe0qt5UY=
From: Anthony Iliopoulos <ailiop@suse.com>
To: <linux-xfs@vger.kernel.org>
Subject: [PATCH 3/4] libfrog: add fallback stubs for libfrog_statmount and fstatmount
Date: Wed, 13 May 2026 21:30:39 +0200
Message-ID: <20260513193040.2130-4-ailiop@suse.com>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-2.75 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.15)[-0.769];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,localhost.localdomain:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.75

Add stubs for libfrog_statmount and fstatmount to enable compilation of
xfs_healer on systems that lack listmount support. Without these stubs,
statmount.c is not compiled, causing compilation errors due to missing
definitions. The stubs allow xfs_healer to fall back to walking the mount
table in userspace.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 libfrog/statmount.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/libfrog/statmount.h b/libfrog/statmount.h
index b6f1338830a0..13aaad3a99dc 100644
--- a/libfrog/statmount.h
+++ b/libfrog/statmount.h
@@ -98,11 +98,23 @@ struct statmount {
 int libfrog_listmount(uint64_t mnt_id, int mnt_ns_fd, uint64_t *cursor,
 		uint64_t *mnt_ids, size_t nr_mnt_ids);
 
+#ifdef HAVE_LISTMOUNT
 int libfrog_statmount(uint64_t mnt_id, int mnt_ns_fd, uint64_t statmount_flags,
 		struct statmount *smbuf, size_t smbuf_size);
-
 int libfrog_fstatmount(int fd, uint64_t statmount_flags,
 		struct statmount *smbuf, size_t smbuf_size);
+#else
+static inline int libfrog_statmount(uint64_t mnt_id, int mnt_ns_fd, uint64_t statmount_flags,
+		struct statmount *smbuf, size_t smbuf_size)
+{
+	return -ENOSYS;
+}
+static inline int libfrog_fstatmount(int fd, uint64_t statmount_flags,
+		struct statmount *smbuf, size_t smbuf_size)
+{
+	return -ENOSYS;
+}
+#endif
 
 static inline size_t libfrog_statmount_sizeof(size_t strings_bytes)
 {
-- 
2.49.0

