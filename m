Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B531C282F27
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 01:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772503012; cv=none; b=FLuEGDTY3DaTpnzo7GsprzaPXoHicOR/sfodDvGK7MNyybejwFpZYNcB35xzVMTyIeeU/hL9M+DRRK+H0RKg+GdMLc4g5z+A11sndVaYRh5vBXtxeoWM3Ye9Z4t+OvyC8omufLnhffM861wieuaB0ILIkV5SY2dQUEoycYFPQzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772503012; c=relaxed/simple;
	bh=2GuG6jseUtnwAkOn5SSNQWYiGJCNQCb6AE5DYmdmuk4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NICjPlwZO/um43D/uBG0VXanfb/eCDyB44f14fVAE66XqTl/cNpvYfnwStZ2YHmG82cz13F2VrP5iAp4ycW6L6UscMmItKOCc2EbkXv1ZH8K2sOxkoNnSBiYaUpClGu6j+hpubQgX9veJfu/ODPeUzen6rZvCxKx6agIlN1A+8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--morbo.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qFsdQVGB; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--morbo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qFsdQVGB"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-824ae2c9ff4so14485027b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2026 17:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772503011; x=1773107811; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=em2es4xDU/QfB/e6n7pQiWKqRu/fZTwwH5eupFRZ/OA=;
        b=qFsdQVGBLqqMhQDmkVsZG+RAIJa9lCbwrZBZlVKq4ImviMVU/C7Co/CFiZq0/YPtII
         E1rBhlC5SYxe3vipRO7xNsBuRindttTwb1rwDqSDe2V7ufPkIw/aOyw8sPSE4RBKBRql
         x0k5TkZ+gEEwWOZpHx/Us8rBXBSwO8u0dw0C8wGomc0dzcGbY9/Oo1BY8/8p0Fxy2Ms+
         6p+ebbpFxdJ/Oe7QZXoC7GTe+51pxlEQ3Sf2sgD6JBIV+v58ngw8iCTc9X0gwEJMi8Xp
         KquQXUhvD33ZxnAqE9QYCZzaOIBfb10xUQJviJGTSJcedU7cowD1NFm1nDH0RvhVt7eT
         ANZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772503011; x=1773107811;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=em2es4xDU/QfB/e6n7pQiWKqRu/fZTwwH5eupFRZ/OA=;
        b=Kz0AXo+NyaoT2Yhsdxkj7Xw/46pHkovGIxu8OPdW2risfDCYXIlU1RTCdX2N+n172g
         ONP1iLbFPdGNOk+Zn2BsCrkAQnhrFecjVexYgyvoCiyrir3wIq/GWPVPO8uq6yXxVyLP
         DeVtaJN7JfWIUO9LEcm0nF8gL66DmOZHDny4e0p/EkOJX282u4bljzmUxL2aaXs+EKdH
         LBEzbxQw8RNyZLqhW97DWdeNk8Xwie9LyTcz4oLwdiuXf+7o2Ln6TkDnwGyC04ihncxk
         dl8dzeapRPkzMvTrDLxBT+Qj8ziZZIbLmUPFw/GCRxGGeugKmutkG5Xgp4wsD/Nfab1D
         cMMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWb+mcU4LQv5QXDik8hinZ67z31QjXaPmG8wCVHy0Pb5gNnEccDEUruZNiigPQyo5vO8FmhfMs0aF8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3/xax94NqnD2+uwxFq4bNeSmFuzKf4q0mvCdsDrpr2AdLmf+c
	Q0UvIunw7P/8OK1aljVtDAvT80u4ZXEym94RkCcJEmdw6RTxPC5WNemckrJG1XzA185EY1O7Cq8
	Z
X-Received: from pfblo22.prod.google.com ([2002:a05:6a00:3d16:b0:824:b9aa:e504])
 (user=morbo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2991:b0:827:3946:a23c
 with SMTP id d2e1a72fcca58-8274d9849e1mr10125001b3a.10.1772503010759; Mon, 02
 Mar 2026 17:56:50 -0800 (PST)
Date: Tue,  3 Mar 2026 01:56:35 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303015646.2796170-1-morbo@google.com>
Subject: [PATCH] xfs: annotate struct xfs_attr_list_context with __counted_by_ptr
From: Bill Wendling <morbo@google.com>
To: linux-kernel@vger.kernel.org
Cc: Bill Wendling <morbo@google.com>, Carlos Maiolino <cem@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Gogul Balakrishnan <bgogul@google.com>, 
	Arman Hasanzadeh <armanihm@google.com>, Kees Cook <kees@kernel.org>, linux-xfs@vger.kernel.org, 
	codemender-patching+linux@google.com
Content-Type: text/plain; charset="UTF-8"

Add the `__counted_by_ptr` attribute to the `buffer` field of `struct
xfs_attr_list_context`. This field is used to point to a buffer of
size `bufsize`.

The `buffer` field is assigned in:
1. `xfs_ioc_attr_list` in `fs/xfs/xfs_handle.c`
2. `xfs_xattr_list` in `fs/xfs/xfs_xattr.c`
3. `xfs_getparents` in `fs/xfs/xfs_handle.c` (implicitly initialized to NULL)

In `xfs_ioc_attr_list`, `buffer` was assigned before `bufsize`. Reorder
them to ensure `bufsize` is set before `buffer` is assigned, although
no access happens between them.

In `xfs_xattr_list`, `buffer` was assigned before `bufsize`. Reorder
them to ensure `bufsize` is set before `buffer` is assigned.

In `xfs_getparents`, `buffer` is NULL (from zero initialization) and
remains NULL. `bufsize` is set to a non-zero value, but since `buffer`
is NULL, no access occurs.

In all cases, the pointer `buffer` is not accessed before `bufsize` is
set.

This patch was generated by CodeMender and reviewed by Bill Wendling.
Tested by running xfstests.

Signed-off-by: Bill Wendling <morbo@google.com>
---
Cc: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Gogul Balakrishnan <bgogul@google.com>
Cc: Arman Hasanzadeh <armanihm@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: codemender-patching+linux@google.com
---
 fs/xfs/libxfs/xfs_attr.h | 2 +-
 fs/xfs/xfs_handle.c      | 2 +-
 fs/xfs/xfs_xattr.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 8244305949de..4cd161905288 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -55,7 +55,7 @@ struct xfs_attr_list_context {
 	struct xfs_trans	*tp;
 	struct xfs_inode	*dp;		/* inode */
 	struct xfs_attrlist_cursor_kern cursor;	/* position in list */
-	void			*buffer;	/* output buffer */
+	void			*buffer __counted_by_ptr(bufsize);	/* output buffer */
 
 	/*
 	 * Abort attribute list iteration if non-zero.  Can be used to pass
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index d1291ca15239..2b8617ae7ec2 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -443,8 +443,8 @@ xfs_ioc_attr_list(
 	context.dp = dp;
 	context.resynch = 1;
 	context.attr_filter = xfs_attr_filter(flags);
-	context.buffer = buffer;
 	context.bufsize = round_down(bufsize, sizeof(uint32_t));
+	context.buffer = buffer;
 	context.firstu = context.bufsize;
 	context.put_listent = xfs_ioc_attr_put_listent;
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index a735f16d9cd8..544213067d59 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -332,8 +332,8 @@ xfs_vn_listxattr(
 	memset(&context, 0, sizeof(context));
 	context.dp = XFS_I(inode);
 	context.resynch = 1;
-	context.buffer = size ? data : NULL;
 	context.bufsize = size;
+	context.buffer = size ? data : NULL;
 	context.firstu = context.bufsize;
 	context.put_listent = xfs_xattr_put_listent;
 
-- 
2.53.0.473.g4a7958ca14-goog

