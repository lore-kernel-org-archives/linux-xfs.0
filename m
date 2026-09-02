Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82867155757;
	Wed,  2 Sep 2026 05:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327753; cv=none; b=O0rdCzNyY21uGnS9Wk9UONy8rav3sfXPsWRFS6omMQB88ZfwHNkFzV8lGP1wWHt+t8oLpFuyoPNMQnBlZV6CcPk6GBaIydwuCGro6rwulKtu2Z8SQU34mNSkp1nER4xMQbkKwHrAcaIujAol3xCHnRbpoiO8m5NXdYnD3zf76+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327753; c=relaxed/simple;
	bh=TLp8dnc/R35xebcaC9ByRgFV7Jp5m7ikCXeR9Qnjt9I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nava0k6Srgi3FrLV/hUr7tQVgsH/laZT2v/YC1HdTkpDuCeZuyBwHpHVFp/8sMVX7I/tYIDAdgaQOUu3uxI+rVCEtQAUIg2MvnLGlF9DbJT544s0KJVYhrSZrcvZEic4MafyOWnaV4VSeOV9oaL8wd3k8G6+HYMlImWZ3Y3GyXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5uHFCaH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5uHFCaH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2DDAB1F000E9;
	Wed,  2 Sep 2026 05:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327752;
	bh=KiZmLVmPjylIoPf4+fAccLC0B6q7Z0GI33y9OYoZ8+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=G5uHFCaHgkpwkX4VSixjP6ya+/aXZsSCTxOAAs6o9e332JrWI0ik5WgSrD7jnGoVE
	 jBYyHOY8Z/Lph1B5nXrWwLYWPfhWm2kPaYmyRSij8KGqh814X2wAt6oh/YGyZuj9jM
	 77kLfjCmSFBD/B67fAP3qCQvL+lRzWaN6I1WtydHCU+PvnUZ2EfLNsbgylPP00KqBR
	 3UtWJFmaYGNLAvRNkQEZkM8qHoyee0oB0q7PGdkbBOog225qjvTjHSJtMljHJ7TG++
	 PXcOeY9yj8veSZ++8v3mJ2rTWltZmvR6a6N4hxVMfF3FBJUCCRe254l686ayN7/Vmv
	 AR4koyrvasVYg==
Date: Tue, 01 Sep 2026 22:42:31 -0700
Subject: [PATCH 3/6] xfs: fix name string recording in slowpath pptr
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749073.3506928.4352047932674726327.stgit@frogsfrogsfrogs>
In-Reply-To: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
References: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that we memcpy from the xfs_name object, not the name
string pointed to by the xfs_name.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: b961c8bf1fc3d0 ("xfs: deferred scrub of dirents")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 14aa0ec1f09e4a..362c6d39e9f580 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1640,7 +1640,7 @@ DECLARE_EVENT_CLASS(xchk_pptr_class,
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = I_INO(ip);
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name, name->len);
+		memcpy(__get_str(name), name->name, name->len);
 		__entry->far_ino = far_ino;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name '%.*s' far_ino 0x%llx",

