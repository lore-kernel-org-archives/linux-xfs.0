Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6656322D4CD
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 16:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574678; cv=none; b=SXipbfjU54omznvXAEnlItSeBR4SY+wZ6eGz9Rzdv4QzmNfvQmK6nii+7XDjxUIUybFepUUyKylPIWmQmCJWbwehvMvab7NXyCTsCQOVNaueIsUWppJdx53VGvvy4/zWggZFR2UIFBoUWiIDDB/UqRqjgKmitQVrXk7BJuvmI7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574678; c=relaxed/simple;
	bh=V2XDysvVLHO3CRPYa1vmlGf0zF+BDT8lzA17X5UCtaA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aIKitKnb2dJg1DEkcMkWF2wgcjtpStv+QfKWFUSUs6+emIl4xnZDIjubmZna8dTsxNirvkfoWhS+GO50zIYBsI/2TxLThaWc0i4KfetUeT0hwvCdlyQl1JvPtC7fdJTznOWBP91BjZu8nMBPuwyGjvfJVja/tOS5fN9pteZq1mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sGgNVxKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sGgNVxKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9F1C4CEE3;
	Fri, 21 Mar 2025 16:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742574675;
	bh=V2XDysvVLHO3CRPYa1vmlGf0zF+BDT8lzA17X5UCtaA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sGgNVxKJ5B1TEc3vAFnG74k1pTUc0D0/n3Y6UjRNDpizWuL7esZN+85bUPy2SuthZ
	 m3qq1KbAU+iuswowuxV6QFASONRLcAM+5zS98LftRSoeqMER7zmod+hrF/yVw8fUI1
	 TGRYBYGTZ5wXbypvdxwBM3PxQ0OJU/s7PI9aCbAlBRX/JUF/BAcpI2inGtFqkG+XpO
	 C56ozJc1lhrIEozlmX/uMTGku2TA72V7YrLApdL4AcACGxFKLp4iiEN0tzvKKapUy6
	 Xjkjj8HxvjJTaGIRzBEGv2btWT79QkCghXP4sF9lMk0jqkpD2XvNS0YUuu4QutwP+9
	 ohRXkBe2A9Lsg==
Date: Fri, 21 Mar 2025 09:31:15 -0700
Subject: [PATCH 1/1] xfs: Use abs_diff instead of XFS_ABSDIFF
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, sandeen@redhat.com,
 willy@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <174257453362.474546.12679550361506145616.stgit@frogsfrogsfrogs>
In-Reply-To: <174257453343.474546.18134930850961940333.stgit@frogsfrogsfrogs>
References: <174257453343.474546.18134930850961940333.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Matthew Wilcox (Oracle) <willy@infradead.org>

Source kernel commit: ca3ac4bf4dc307cea5781dccccf41c1d14c2f82f

We have a central definition for this function since 2023, used by
a number of different parts of the kernel.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/platform_defs.h |   19 +++++++++++++++++++
 libxfs/xfs_alloc.c      |    8 +++-----
 2 files changed, 22 insertions(+), 5 deletions(-)


diff --git a/include/platform_defs.h b/include/platform_defs.h
index 051ee25a5b4fea..9af7b4318f8917 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -261,4 +261,23 @@ static inline bool __must_check __must_check_overflow(bool overflow)
 	__builtin_add_overflow(__a, __b, __d);	\
 }))
 
+/**
+ * abs_diff - return absolute value of the difference between the arguments
+ * @a: the first argument
+ * @b: the second argument
+ *
+ * @a and @b have to be of the same type. With this restriction we compare
+ * signed to signed and unsigned to unsigned. The result is the subtraction
+ * the smaller of the two from the bigger, hence result is always a positive
+ * value.
+ *
+ * Return: an absolute value of the difference between the @a and @b.
+ */
+#define abs_diff(a, b) ({			\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	(void)(&__a == &__b);			\
+	__a > __b ? (__a - __b) : (__b - __a);	\
+})
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 9aebe7227a6148..6675be78a7dae8 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -29,8 +29,6 @@ struct kmem_cache	*xfs_extfree_item_cache;
 
 struct workqueue_struct *xfs_alloc_wq;
 
-#define XFS_ABSDIFF(a,b)	(((a) <= (b)) ? ((b) - (a)) : ((a) - (b)))
-
 #define	XFSA_FIXUP_BNO_OK	1
 #define	XFSA_FIXUP_CNT_OK	2
 
@@ -406,8 +404,8 @@ xfs_alloc_compute_diff(
 		if (newbno1 != NULLAGBLOCK && newbno2 != NULLAGBLOCK) {
 			if (newlen1 < newlen2 ||
 			    (newlen1 == newlen2 &&
-			     XFS_ABSDIFF(newbno1, wantbno) >
-			     XFS_ABSDIFF(newbno2, wantbno)))
+			     abs_diff(newbno1, wantbno) >
+			     abs_diff(newbno2, wantbno)))
 				newbno1 = newbno2;
 		} else if (newbno2 != NULLAGBLOCK)
 			newbno1 = newbno2;
@@ -423,7 +421,7 @@ xfs_alloc_compute_diff(
 	} else
 		newbno1 = freeend - wantlen;
 	*newbnop = newbno1;
-	return newbno1 == NULLAGBLOCK ? 0 : XFS_ABSDIFF(newbno1, wantbno);
+	return newbno1 == NULLAGBLOCK ? 0 : abs_diff(newbno1, wantbno);
 }
 
 /*

