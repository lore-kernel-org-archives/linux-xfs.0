Received: from proxima.stupidest.org (proxima.stupidest.org [35.163.12.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401272DF137
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.163.12.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788112173; cv=none; b=In3E6hHgp+0QdCa155+14hKU9jWxRy1ZDhX80dISKwzJXUGsK8CwZ3nwIVvVyOeLmuq6WQlKs5jzGDelI2Uozz6rApHgZJYN7/7Fui9Gnbu40QPRNxeFV5RV/OTuNjr7pYTYMmmGmgkKhbLysYGcpr0Z/bvIupltMxcMyl9r8W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788112173; c=relaxed/simple;
	bh=jWvS/DqdWTeESvxXhOSZV4jwiXurUfyM8h5EFiaLD1g=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject; b=m1wENtVCeI+1Lg2k6oL8bhRdoCb3bvwYYqj7ZNjv7aFtflnYtkC5djND91ITLl3ZCFUxpgfOodYSmBFr3XPTnCVW6ccJYjo8KGgyzMSpRVhb7Khvf0bcLnwiau/t28KcDkJTddU6DbcRNH/smrJbFuAAJNolFHnGIOhwemiHSiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org; spf=pass smtp.mailfrom=f00f.org; dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b=jlarMpQ+; arc=none smtp.client-ip=35.163.12.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=f00f.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b="jlarMpQ+"
Received: from aether.stupidest.org (unknown [10.0.1.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by proxima.stupidest.org (Postfix) with ESMTPS id 4hY04Q3z8Zz6lh
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=f00f.org; s=m2016a;
	t=1788112166; bh=nd+uv7pVMqQE6MSoDkPFYS5jDZpP5O4rNRzOCZEoeVg=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject;
	b=jlarMpQ+sWELAuIFZlwvShnQJw/vuXvHTbD1OYwCOvIzIhVOeHISpOjgXVMg/s4J8
	 cT/vdmrrtk8+OAKJT2dqRDbV8BXOlXEDnzHuVcpppJ4WOCw7w9wy5Te2b5EeVtHqtj
	 IAmBI4BU9X5TsrUkPzfTPLcKdKQgOM/iwq7aWMTnB8ObC1drWsBQlIemNBwG7uMS8q
	 Itws/RWZD4gGT1YGEQR4w8iGSoS1wi3cmFV0X95s2PIPT3HRSdM8889VIuu8gnLJqX
	 vLcaY7v+he6Vvi7OkcNeOq+dnCJPAR7KidATPqg/pq7jOlONfDQNB+BStE91cXPB5P
	 RK74CpcLmqbHw==
Received: from stupidest.org (unknown [172.31.255.110])
	by aether.stupidest.org (Postfix) with SMTP id 4hY04P0cY7z9KVLH
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 10:49:25 -0700 (PDT)
Received: by stupidest.org (sSMTP sendmail emulation); Sun, 30 Aug 2026 10:49:25 -0700
To: linux-xfs@vger.kernel.org
Message-ID: <60509d17767ab0c93d22269c507350840b92e3e1.1788110147.git.cw@f00f.org>
In-Reply-To: <cover.1788110147.git.cw@f00f.org>
References: <cover.1788110147.git.cw@f00f.org>
From: Chris Wedgwood <cw@f00f.org>
Date: Thu, 20 Aug 2026 17:22:39 -0700
Subject: [PATCH 1/9] libxfs: make XBF_DONE actually mark a buffer uptodate
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

XBF_DONE is defined to 0 in the userspace platform header, so every
"this buffer's contents are valid, don't re-read it" annotation that
libxfs inherits from the kernel is silently a no-op:

	bp->b_flags |= XBF_DONE;	/* expands to |= 0 */

The userspace equivalent of the kernel's XBF_DONE is LIBXFS_B_UPTODATE,
which is what libxfs_buf_read_map() actually tests before deciding
whether a physical read can be skipped:

	if (bp->b_flags & (LIBXFS_B_UPTODATE | LIBXFS_B_DIRTY))
		goto ok;		/* no read */

so a buffer that has been marked "done" is nevertheless re-read from
disk, discarding whatever the caller had just constructed in memory.

There are three consequences today:

 - xfs_btree_staging.c documents the intent it does not get:
	"Mark this buffer XBF_DONE (i.e. uptodate) so that a subsequent
	 xfs_buf_read will not pointlessly reread the contents from the
	 disk."
   This is currently masked because xfs_buf_delwri_queue_here() also
   marks the buffer dirty, and LIBXFS_B_DIRTY happens to suppress the
   re-read too.

 - The readahead verifiers in xfs_inode_buf.c and xfs_dquot_buf.c clear
   XBF_DONE to force a subsequent real read through the full verifier,
   as their comments describe.  Those clears are no-ops as well.

 - __xfs_buf_mark_corrupt() asserts on a condition that can never be
   true:
	ASSERT(bp->b_flags & XBF_DONE);
   (Inert in practice only because libxfs/Makefile builds with
   -DNDEBUG unconditionally.)

The path that motivated this, xfs_ialloc_inode_init() marking a freshly
initialised inode chunk uptodate, is only reachable from the kernel's
xfs_icreate_item.c, which libxfs does not carry yet; it becomes live as
soon as log recovery is brought into libxfs.

Define XBF_DONE as LIBXFS_B_UPTODATE so the flag means what its name and
all of its users say it means.

No functional change was observed: xfs_repair -n output and post-repair
superblock counters are unchanged across an 8-image corpus, and mkfs.xfs
superblock geometry is identical.
---
 libxfs/xfs_platform.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index 5cddfbb8..bb9c3e23 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -347,7 +347,7 @@ static inline unsigned long long mask64_if_power2(unsigned long b)
 
 /* buffer management */
 #define XBF_TRYLOCK			0
-#define XBF_DONE			0
+#define XBF_DONE			LIBXFS_B_UPTODATE
 #define xfs_buf_stale(bp)		((bp)->b_flags |= LIBXFS_B_STALE)
 #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
 
-- 
2.47.3

