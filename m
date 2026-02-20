Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E172AD2C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 01:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771549263; cv=none; b=b2HQ/lCiyY+XFsOxaVGvBE0bYF2QHYhOsE241+HlQEwT9vkTg0fQH4EmGHQyVVq8R0kXQHIBoX8kaNGzA1yq8qCsH2llmt5xu6Ci1JZlhrGDNi9UUDsNjMcWQhwDJbhkMz1nzVpNNLRS1UzJvq8o0kd62M8rJ9rGItMdq2OZdoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771549263; c=relaxed/simple;
	bh=ACHOOzTdV14NUt+rtU+qcwu4vxDYVeTbAiFMzAAhuk4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qJZw4AUgPOz5n22WB+Rj8B2T1fp/BtW+22KFDQwBLRtkR9YB5WptdJi9fVlulGQrqI+/NDPniZExGXZJD1berpzBalTJyx8Fl+ka/MWz0F7Md56LDo+jcuemT0V6TEVKDIvQmT4ukvbz/cQ+t8+aZbc6+OHvN3MVdGCJAQPo01U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWmlcjV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWmlcjV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFC3C4CEF7;
	Fri, 20 Feb 2026 01:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771549263;
	bh=ACHOOzTdV14NUt+rtU+qcwu4vxDYVeTbAiFMzAAhuk4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hWmlcjV5Kt8PRMzX06UXOKsQJd1TRS7hxSc4YEKbo/smDjRkibxWB3OOn7YUCZeO7
	 arCXDIdDv8IXyAu1+kVaOowBqVpR5bC6x2UIY2OWLuSvOP3UwhNXGLZB2YwIc2W+0c
	 8gDFsHUvyjzrVo0hzuNQaF3kgfWVbnm9PCmOujDGwYiKUqgEUo+BkOm/jf9QBBcuE7
	 yf26DjrWzqxfJLDQiu//XTFzxaLnA/g2dYz1HGz57BolSBIqHc4Y35rAk4P7hAZTnE
	 88irIOYJIc5wkavKvnc6BKNcUPB7MTwvG6Cx2STK5/AWp2rOQoZm7vl8T76S03TzKH
	 n6hZO5jqX2Mrg==
Date: Thu, 19 Feb 2026 17:01:02 -0800
Subject: [PATCH 4/6] xfs: fix potential pointer access race in
 xfs_healthmon_get
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, hch@lst.de, p.raghav@samsung.com,
 pankaj.raghav@linux.dev, linux-xfs@vger.kernel.org
Message-ID: <177154903748.1351708.7656635791637678344.stgit@frogsfrogsfrogs>
In-Reply-To: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
References: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/xfs/xfs_mount.h     |    2 +-
 fs/xfs/xfs_healthmon.c |   11 +++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)


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
index ca7352dcd182fb..1494408f66a0df 100644
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
 
@@ -128,13 +128,16 @@ STATIC void
 xfs_healthmon_detach(
 	struct xfs_healthmon	*hm)
 {
+	struct xfs_mount	*mp;
+
 	spin_lock(&xfs_healthmon_lock);
 	if (hm->mount_cookie == DETACHED_MOUNT_COOKIE) {
 		spin_unlock(&xfs_healthmon_lock);
 		return;
 	}
 
-	XFS_M((struct super_block *)hm->mount_cookie)->m_healthmon = NULL;
+	mp = XFS_M((struct super_block *)hm->mount_cookie);
+	rcu_assign_pointer(mp->m_healthmon, NULL);
 	hm->mount_cookie = DETACHED_MOUNT_COOKIE;
 	spin_unlock(&xfs_healthmon_lock);
 

