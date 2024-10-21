Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DE51E2846
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548297; cv=none; b=Xw9Vyn59y9uEuC0zlnYCoF/RmEiQOMj7JwVTOHy3d5MVQieSYwkqXptMSYjnHj4q16ajkEcrZrcIT3snpt+cj5HKU6nSHkayCBlqdB3b00KfRb8aZzA5tHuqq35ADBvLsv79JL0+5cYjZU7QzkcSQkpej8OTyj+52Q0e5R+a+qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548297; c=relaxed/simple;
	bh=8jmw6n/nScN7o36XFdkmO8Q6GCTOrnBze95n3w2Z8eQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gDJfq71BDobvH0o8BULoVTaRIdFvcI0PIz3fvVIU3oSDnxW7piI9eXfgZlu87NvDugofYDtU07WGJNM6y9NEDWB2elcawF0fbbY50dEihH0Lx3vijrglgWgYpjO13QwmAsdcltKT/xXVt175QDoUc3OR/dCBFt+ex5wG1FdLv1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qvdb3osC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qvdb3osC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64718C4CEC3;
	Mon, 21 Oct 2024 22:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548296;
	bh=8jmw6n/nScN7o36XFdkmO8Q6GCTOrnBze95n3w2Z8eQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qvdb3osCoC9VLBZiweweD8nhVph5n5DGpWH05dvFbhgAg2orr059m4G8PyjZGsLio
	 FVH8ylQX6/J8a4rimE05wtB1pp2Mpr2uajmWL+moD3hSt9JV0/CJQo0wURWb/rBRy+
	 XNI9xU0QlY2kmFKOu5ns1fDo6G+8aQi5O623vE1MTLWi9f/nULeuCjIzbNKoQ39q+z
	 ksHBqIZicqLnhlHGOG2SZDi09s52WlWMrXY/J9LAm0OEcmkp+FRC6mtvSbSSG71MXt
	 3W6UAimIjd9H0RVklrUyfm+wCUKvFlbM3qOMzFV20hYhIOoBnZJXeOKl2+Z7A4wBaN
	 4V7gBoQJHVSVw==
Date: Mon, 21 Oct 2024 15:04:55 -0700
Subject: [PATCH 23/37] xfs: use kvmalloc for xattr buffers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783819.34558.5375099362641927547.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: de631e1a8b71017b8a12b57d07db82e4052555af

Pankaj Raghav reported that when filesystem block size is larger
than page size, the xattr code can use kmalloc() for high order
allocations. This triggers a useless warning in the allocator as it
is a __GFP_NOFAIL allocation here:

static inline
struct page *rmqueue(struct zone *preferred_zone,
struct zone *zone, unsigned int order,
gfp_t gfp_flags, unsigned int alloc_flags,
int migratetype)
{
struct page *page;

/*
* We most definitely don't want callers attempting to
* allocate greater than order-1 page units with __GFP_NOFAIL.
*/
>>>>    WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
...

Fix this by changing all these call sites to use kvmalloc(), which
will strip the NOFAIL from the kmalloc attempt and if that fails
will do a __GFP_NOFAIL vmalloc().

This is not an issue that productions systems will see as
filesystems with block size > page size cannot be mounted by the
kernel; Pankaj is developing this functionality right now.

Reported-by: Pankaj Raghav <kernel@pankajraghav.com>
Fixes: f078d4ea8276 ("xfs: convert kmem_alloc() to kmalloc()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Link: https://lore.kernel.org/r/20240822135018.1931258-8-kernel@pankajraghav.com
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 include/kmem.h         |    6 ++++++
 libxfs/xfs_attr_leaf.c |   15 ++++++---------
 2 files changed, 12 insertions(+), 9 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 8dfb2fb0b45020..8739d824008e2a 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -59,12 +59,18 @@ static inline void *kmalloc(size_t size, gfp_t flags)
 }
 
 #define kzalloc(size, gfp)	kvmalloc((size), (gfp) | __GFP_ZERO)
+#define kvzalloc(size, gfp)	kzalloc((size), (gfp))
 
 static inline void kfree(const void *ptr)
 {
 	free((void *)ptr);
 }
 
+static inline void kvfree(const void *ptr)
+{
+	kfree(ptr);
+}
+
 __attribute__((format(printf,2,3)))
 char *kasprintf(gfp_t gfp, const char *fmt, ...);
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 97b71b6500bdc9..db2e48d719d36f 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1135,10 +1135,7 @@ xfs_attr3_leaf_to_shortform(
 
 	trace_xfs_attr_leaf_to_sf(args);
 
-	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
-	if (!tmpbuffer)
-		return -ENOMEM;
-
+	tmpbuffer = kvmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
 
 	leaf = (xfs_attr_leafblock_t *)tmpbuffer;
@@ -1202,7 +1199,7 @@ xfs_attr3_leaf_to_shortform(
 	error = 0;
 
 out:
-	kfree(tmpbuffer);
+	kvfree(tmpbuffer);
 	return error;
 }
 
@@ -1610,7 +1607,7 @@ xfs_attr3_leaf_compact(
 
 	trace_xfs_attr_leaf_compact(args);
 
-	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
+	tmpbuffer = kvmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
 	memset(bp->b_addr, 0, args->geo->blksize);
 	leaf_src = (xfs_attr_leafblock_t *)tmpbuffer;
@@ -1648,7 +1645,7 @@ xfs_attr3_leaf_compact(
 	 */
 	xfs_trans_log_buf(trans, bp, 0, args->geo->blksize - 1);
 
-	kfree(tmpbuffer);
+	kvfree(tmpbuffer);
 }
 
 /*
@@ -2327,7 +2324,7 @@ xfs_attr3_leaf_unbalance(
 		struct xfs_attr_leafblock *tmp_leaf;
 		struct xfs_attr3_icleaf_hdr tmphdr;
 
-		tmp_leaf = kzalloc(state->args->geo->blksize,
+		tmp_leaf = kvzalloc(state->args->geo->blksize,
 				GFP_KERNEL | __GFP_NOFAIL);
 
 		/*
@@ -2368,7 +2365,7 @@ xfs_attr3_leaf_unbalance(
 		}
 		memcpy(save_leaf, tmp_leaf, state->args->geo->blksize);
 		savehdr = tmphdr; /* struct copy */
-		kfree(tmp_leaf);
+		kvfree(tmp_leaf);
 	}
 
 	xfs_attr3_leaf_hdr_to_disk(state->args->geo, save_leaf, &savehdr);

