Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C672C9D
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716348083; cv=none; b=Gbr5qVNKVQgBsc8xLveMJt8+/WTDdWW9bhMKLK26UYujpsCAqdJs8f0xx0nlBxp7CF5wlDtDQJJyWU5KBjDxM84QNrUtw///ahfVJdTAgDtWGY8FjvJ/sF1cLQ9Ln3hZcOKgdqKIIOcx1FgJUdKI1tk3GAO6lEeqNt3YBFkxP/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716348083; c=relaxed/simple;
	bh=Ndj7NBRzsbssyfwEqS+KjV5iCt7PHuzMq0I9Zxfi338=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KA2oIm51EMpiSZEcyddHUD4AN+3kksHc2g9M1nkBrrOXJddgYTkOcu1jRBW6VXYDPY6DcBgnoQjX0BOXAH8WSOlyx53Dnp7en0ujXYftOLmoYfUFPPZU5CJbwP1KxtAM8M8gI4MIZOanlQYLDLt6vEmU91r+P4NUoZafxdSSRgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f88ssMPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f88ssMPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E456C2BD11;
	Wed, 22 May 2024 03:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716348083;
	bh=Ndj7NBRzsbssyfwEqS+KjV5iCt7PHuzMq0I9Zxfi338=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f88ssMPNV0wPVrYzZN8mds+RrpRgjvMhYdR9IxvvmKWtuO1gYld7H9No1+M7jsCcq
	 Z4kM7sGklFAu0p6rvF+ueHZoJovl04SJgSHoN3oXRPEVFhrrVUo44ap+t+rCt3h6RK
	 V+gYTGhG5h3j5Pt8EPkuUj3Uj1KzU8MsheTHwKYH5/r7ZaQpueBdbQffjuqW5aZ9/X
	 a4TYWkCrUvu/9Py+hnA9gsR97tVvgrvY73E/NwaoeVjqN9tBKoG5TZGat0O0J/HrhK
	 +ipynOatT3CMWYTSXuhbV+rz3mxdBsR8jJ5AlIMmrbsiPuSunKtA19D5QrPGEq6bjj
	 ITadwyeoUu7HQ==
Date: Tue, 21 May 2024 20:21:22 -0700
Subject: [PATCH 1/6] libxfs: provide a kernel-compatible kasprintf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634535404.2483278.11403421783079513759.stgit@frogsfrogsfrogs>
In-Reply-To: <171634535383.2483278.14868148193055852399.stgit@frogsfrogsfrogs>
References: <171634535383.2483278.14868148193055852399.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The kernel-like kasprintf will be used by the new metadir code, as well
as the rmap data structures in xfs_repair.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: tweak commit message]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/kmem.h |    3 +++
 libxfs/kmem.c  |   13 +++++++++++++
 2 files changed, 16 insertions(+)


diff --git a/include/kmem.h b/include/kmem.h
index 386b4a6be..8dfb2fb0b 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -65,4 +65,7 @@ static inline void kfree(const void *ptr)
 	free((void *)ptr);
 }
 
+__attribute__((format(printf,2,3)))
+char *kasprintf(gfp_t gfp, const char *fmt, ...);
+
 #endif
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index a2a3935d0..2e2935180 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -104,3 +104,16 @@ krealloc(void *ptr, size_t new_size, int flags)
 	}
 	return ptr;
 }
+
+char *kasprintf(gfp_t gfp, const char *fmt, ...)
+{
+	va_list ap;
+	char *p;
+
+	va_start(ap, fmt);
+	if (vasprintf(&p, fmt, ap) < 0)
+		p = NULL;
+	va_end(ap);
+
+	return p;
+}

