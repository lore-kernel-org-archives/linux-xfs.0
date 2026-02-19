Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8582DD5E2
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480906; cv=none; b=VkGa/nHISJ9hhm7QVqomvVK/NOZBkWjwZ52R5U91RxBpAFMNqaPgv8wHdjA4CjYCJVuxx/8kH+N7/xFih99+DgdVcdSNZiyhsOaBDAovlQiGJ1Kve4V/uJcxLvndoInv/bZraI3BPtkL0Ashv7Jg18KokYXqm1rb1NlsRPCmuh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480906; c=relaxed/simple;
	bh=/xMU+lgE+XOFPCYY7q5euNc3Sn/awF5++pat4HE1YJc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EuybEDA9ZLI2kKuGt4VXy9RkKMrBCSWjS64/IVbRatq1eHdqdsZhqdYS7NIcfRBQiGviKzhCkiwKWpqNozEIVCDf2y+dBIyudrMDma5FBVHNQHnCBiendsixMA3cGp/29kWzYsXJ6DUhJ0lLDjrPZs5rxfcukYUmIKgBqQNAJ/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDHWNoOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDHWNoOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A2BC4CEF7;
	Thu, 19 Feb 2026 06:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771480906;
	bh=/xMU+lgE+XOFPCYY7q5euNc3Sn/awF5++pat4HE1YJc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XDHWNoOlNE3T/SUXozbEjQ3hjOn+najUJ/IE1cfpevB5fy9rd//JiH2WJS9WG+gu1
	 OHIu6YBHY5u6PYalgit9lgifkgc5Kx9gLlSxsRTyUhzwHnP4V7M4SP46KBMcdSQLMy
	 mTniUxOnnqRnQpg/4fyp3pCCuXvjyvZU38QHt5d8hqt+kh8wpCGH6HWHW7Rdj9xwgd
	 K9tDNaWZCyrHQzC2yu8+LX1pKhLrlahnEYxb8BLbEpjlXYUGOecJT89xri4Sgl97CH
	 rM/0/3RY7umDJFdwqR4FazT7xJ7ZLl9ynbaKBRycszh9EV7qt12L29FuOUAUVZ7oYQ
	 H6vtDTAG4CW+w==
Date: Wed, 18 Feb 2026 22:01:45 -0800
Subject: [PATCH 4/6] xfs: fix potential pointer access race in
 xfs_healthmon_get
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: pankaj.raghav@linux.dev, linux-xfs@vger.kernel.org
Message-ID: <177145925494.401799.17980890890269795712.stgit@frogsfrogsfrogs>
In-Reply-To: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Pankaj Raghav asks about this code in xfs_healthmon_get:

  hm = mp->m_healthmon;
  if (hm && !refcount_inc_not_zero(&hm->ref))
    hm = NULL;
  rcu_read_unlock();
  return hm;

(slightly edited to compress a mailing list thread)

"Nit: Should we do a READ_ONCE(mp->m_healthmon) here to avoid any
compiler tricks that can result in an undefined behaviour? I am not sure
if I am being paranoid here.

"So this is my understanding: RCU guarantees that we get a valid object
(actual data of m_healthmon) but does not guarantee the compiler will
not reread the pointer between checking if hm is !NULL and accessing the
pointer as we are doing it lockless.

"So just a barrier() call in rcu_read_lock is enough to make sure this
doesn't happen and probably adding a READ_ONCE() is not needed?"

After some initial confusion I concluded that he's correct.  The
compiler could very well eliminate the hm variable in favor of walking
the pointers twice, turning the code into:

  if (mp->m_healthmon && !refcount_inc_not_zero(&mp->m_healthmon->ref))

If this happens, then xfs_healthmon_detach can sneak in between the
two sides of the && expression and set mp->m_healthmon to NULL, and
thereby cause a null pointer dereference crash.  Fix this by using the
rcu pointer assignment and dereference functions, which ensure that the
proper reordering barriers are in place.

Practically speaking, gcc seems to allocate an actual variable for hm
and only reads mp->m_healthmon once (as intended), but we ought to be
more explicit about requiring this.

Reported-by: Pankaj Raghav <pankaj.raghav@linux.dev>
Fixes: a48373e7d35a89f6f ("xfs: start creating infrastructure for health monitoring")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_mount.h     |    2 +-
 fs/xfs/xfs_healthmon.c |   10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 61c71128d171cb..ddd4028be8d6ba 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -345,7 +345,7 @@ typedef struct xfs_mount {
 	struct xfs_hooks	m_dir_update_hooks;
 
 	/* Private data referring to a health monitor object. */
-	struct xfs_healthmon	*m_healthmon;
+	struct xfs_healthmon __rcu	*m_healthmon;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index ca7352dcd182fb..4b5283fc74335c 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -69,7 +69,7 @@ xfs_healthmon_get(
 	struct xfs_healthmon		*hm;
 
 	rcu_read_lock();
-	hm = mp->m_healthmon;
+	hm = rcu_dereference(mp->m_healthmon);
 	if (hm && !refcount_inc_not_zero(&hm->ref))
 		hm = NULL;
 	rcu_read_unlock();
@@ -110,13 +110,13 @@ xfs_healthmon_attach(
 	struct xfs_healthmon	*hm)
 {
 	spin_lock(&xfs_healthmon_lock);
-	if (mp->m_healthmon != NULL) {
+	if (rcu_access_pointer(mp->m_healthmon) != NULL) {
 		spin_unlock(&xfs_healthmon_lock);
 		return -EEXIST;
 	}
 
 	refcount_inc(&hm->ref);
-	mp->m_healthmon = hm;
+	rcu_assign_pointer(mp->m_healthmon, hm);
 	hm->mount_cookie = (uintptr_t)mp->m_super;
 	spin_unlock(&xfs_healthmon_lock);
 
@@ -134,7 +134,9 @@ xfs_healthmon_detach(
 		return;
 	}
 
-	XFS_M((struct super_block *)hm->mount_cookie)->m_healthmon = NULL;
+	rcu_assign_pointer(XFS_M(
+			(struct super_block *)hm->mount_cookie)->m_healthmon,
+			NULL);
 	hm->mount_cookie = DETACHED_MOUNT_COOKIE;
 	spin_unlock(&xfs_healthmon_lock);
 

