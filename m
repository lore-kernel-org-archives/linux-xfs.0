Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4163E0227
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 18:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773686526; cv=none; b=Ku1YAE0mEP9zLkcEhppvmHzXfSs/MK5wYVaaAIb1gL4A0Qy8TLC31lpS9SRWSiZMee/LjBEjJfLCLmGsLOFt9xFouRptL093jsf2HesOBZsu2YdTJ5klpST3HWclft4uuBNZ3d3uTloF/vNIctYur3Ec6Ft2J3jkLEu/WNbgRgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773686526; c=relaxed/simple;
	bh=meCDkZNdQoV9AVjvAGbFhG8GrL/vbagcWRmYa3xgdeU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sBwzqWEyQxLtXp2kGNy29+F1LBpeyKIrufM1+8kj1zlRs5QlqEH7t0Az5KZxjT/FDConnacrlu41+lQC3wCSoegxLkZoTrd6WSl6D5171zfZRyFyZYUPY5JjKXbjNfAlcc1lmiK9EnA3EYH4ej9JFQngQIP7loY6EWeSCKJfn9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--morbo.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DXVok95i; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--morbo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DXVok95i"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c739120475fso3029168a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 11:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773686523; x=1774291323; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=meMK1fTvkCROtMML1gkfwIQxzx+YnZ3FUZcDljZmaVM=;
        b=DXVok95iZ6ZikARs3ZLWq7rQEfsHupzpRUQYUMmtxRcwleNgA097eXWlnsufw9/Ng5
         KudKu0bgv2AdsnGu0HIHna5UivAsTvXC82srK68+aCIrHDeG3PIjwIoMhppypLOugPI8
         W2mDDxWodySOvtXkWYz0ts1E/ACG1EEfiMbxrrr3j7dyBVTrEzevraP2r4h73BWsDKdm
         w/ZkKq4/r7jXHOG26tnRrcW+SYGTqzo0BJoE+0gzzCwt+8jKYXDxmyS1zXe/1YQqQAsA
         yoQhsx7hqUiM5WuXabswblWwKoZ08AIw0tx3cq54i/6tN33xDE5N/l9QTiKMIu8ex1ts
         /8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773686523; x=1774291323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=meMK1fTvkCROtMML1gkfwIQxzx+YnZ3FUZcDljZmaVM=;
        b=Knt52DFoCiiuEOEPAT1DFFa4sqnIU2zp2VMweXymiTc898Q9LaR8il/yYFN489Y85s
         dssuQhOOE/T6Sp+YOt2ASaaniWuda5Bhwmzn/yzMqRYsFOGTdu/ykpHZx0aupx7OF2HX
         kHoU2PJwpVntNR5otSbsFudJ/jFt3By9fnLkgeyWbYpOAvg1LDsr4UYFu72xqMJCHr09
         1swTweFypgwZA6vK+n6mQrwyZ1AGkHY+XMlG/u73D1fACEhfwCXq9AzImN5Gfy+KkJ9R
         HvUAFMhAjcemvLi/0FBQHAwuJcPcQqbz8mhDVBnLeBOe2+cbNqhDvqfs88YJYsAL9x1Z
         XZhw==
X-Forwarded-Encrypted: i=1; AJvYcCXTN8gohcVXw1FMDGZ5Kao7TJd9dIxXKLh6tIN5yCTpXf2unmksWQ6YGdYyXiAF67R9cRiC7Qa7epw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLPonUmhiFfZZw2ygoXCQ+RGmkVtji3MrHOnLOo3G9rYX2lT/H
	FlXiwAZGdvrtklN9nT1d4FMnvlsPCQ4jq/sznzDI//8wj8tPmmyw+/u1lmd0XwkI/EXB3htUMMr
	u
X-Received: from pgam8.prod.google.com ([2002:a05:6a02:2b48:b0:c66:7f77:eb66])
 (user=morbo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:729e:b0:398:9ae9:7110
 with SMTP id adf61e73a8af0-398eca00a67mr13549140637.11.1773686522906; Mon, 16
 Mar 2026 11:42:02 -0700 (PDT)
Date: Mon, 16 Mar 2026 18:41:58 +0000
In-Reply-To: <20260303015646.2796170-1-morbo@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303015646.2796170-1-morbo@google.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260316184200.840020-1-morbo@google.com>
Subject: [PATCH v2] xfs: annotate struct xfs_attr_list_context with __counted_by_ptr
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

In all cases, the pointer `buffer` is not accessed before `bufsize` is set.

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
v2 - Place comment in a more readable spot.
---
 fs/xfs/libxfs/xfs_attr.h | 3 ++-
 fs/xfs/xfs_handle.c      | 2 +-
 fs/xfs/xfs_xattr.c       | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 8244305949de..4b4217e23d1c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -55,7 +55,8 @@ struct xfs_attr_list_context {
 	struct xfs_trans	*tp;
 	struct xfs_inode	*dp;		/* inode */
 	struct xfs_attrlist_cursor_kern cursor;	/* position in list */
-	void			*buffer;	/* output buffer */
+	/* output buffer */
+	void			*buffer __counted_by_ptr(bufsize);
 
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
2.53.0.851.ga537e3e6e9-goog

