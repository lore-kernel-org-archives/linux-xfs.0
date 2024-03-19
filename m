Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8170EA29
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 00:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710809205; cv=none; b=dO+jlj0rmmpb58TBpkX1wehZe9+UYozoNrqYdCPd7dN5MGA7mYTpeCq+XUSw5sa4WC44J+vUK5VHRWwAgZF/YeRUeqEoaAVl+hhffOh8fq5awdDxJmkJ7fGwhfBvEOmYgtUb9RjKtBj+5ShY+kNUQR3epwmxDfud1/8g0Sstlg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710809205; c=relaxed/simple;
	bh=i7cUT0i9ha1vG3/Ju4vEMXe+IpDVgo5DCsVK6Efu0po=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FiRv0cbzmwefy/PYxTD1TdI7n9AZlldkDOhTQu+AevLWjHC1BFCcaMpf2SUKa9sAgu9ARWeLl7K4UgxbrFA9wyLgU3xEds1rFKyTtVXFMhf6Kp0n/gK30snmh18cYIDt5g1g5TYiq/+OqBgJ+aNcroS+6tm52MPRJwf8GQZ9Qz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=X/bsLKC0; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="X/bsLKC0"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3c398187b4dso16189b6e.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710809202; x=1711414002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CKjJMu/p9XCokkR6YbXj6GExZkQYyOs8BWyN5wAvxwg=;
        b=X/bsLKC0Q6wHn36zZ8KfDb+MHmGJLLR+IrKzhqhrvr5bRvVxzeHoqdUevGMX+Mnoar
         BbFca+6LwgknAT02ecUvRaDgw8HcOANlKzxHbkiMISNjk2HSs/phBfTBDnMdt7EqlN/h
         GecLW3pH1ZPpAth0iFRCnT1jsC4Dg1FM11aftqORuri003F3vm4zUqd+GimwvbbN5RoP
         bRUFOasf04ZCKNzmpMeq6UOwxjynrVs2zRCKB2scAQA5ByinjVFYqvaE+ZVt25cdpx93
         5YZzbUITbC0gfA9vMtuXPuulgwX0vozXKmuV+d1mqBKZYGXnaf0I7GI06HDy0JtSh8Q3
         0SGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710809202; x=1711414002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CKjJMu/p9XCokkR6YbXj6GExZkQYyOs8BWyN5wAvxwg=;
        b=R7ks1S6VGQ/pM3bXGEL+DWsdk0zhBAqDxPMb+OK8FtQsQmy/ZtnVaa1qx9gyNtPC8G
         9YDFsHtKF/JtIoJ85fYReNm68U6ZEZR09GM9o7we9Z5dXPuaBrM3DhG4St0wiCBf03NT
         xCtMOD6sgGDSIG+QgXsWwW7Etd2wF/x6ixuiwRPIukvUhQ6jCT1F8Muo6eXN6jiVPNY8
         y/1661Mmt2xrzYvK0gF0xTSFVn7OUvfJGf4BPIWf+Qe9h6obEd5WXwTZBW5/vcLWjIl9
         Il++PscvogYpDbwGhwejsoQB6W+ns3C6qsTe4eq4lv4qL4yvp+gQRssi+UXvKbXuhHL6
         Wbbw==
X-Gm-Message-State: AOJu0YzzpLLHo55Mf/ivkNis8q/TZ2zybr6bVkBFHWKRNXYHTapPFmap
	7RdDgjDhZWi26HQQf9D7uak1+skyDnrrZwLo+iTJnJxUGmnE1tOgmnx6Shz5obki1h2jCqlmhCl
	p
X-Google-Smtp-Source: AGHT+IEHLtkKVtERDPpIAAseuYIuxARKWlj5Ba1x069h9pdlfePX+xjqrzOdsdvXYI15w48sDGu1GA==
X-Received: by 2002:a05:6871:8ea7:b0:220:941d:18be with SMTP id zq39-20020a0568718ea700b00220941d18bemr1049422oab.25.1710809202370;
        Mon, 18 Mar 2024 17:46:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id a3-20020a62d403000000b006e6bfff6085sm9192264pfh.143.2024.03.18.17.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 17:46:41 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmNcm-003qKk-0L;
	Tue, 19 Mar 2024 11:46:39 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmNcl-0000000ERme-2JAU;
	Tue, 19 Mar 2024 11:46:39 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org
Subject: [PATCH] xfs: quota radix tree allocations need to be NOFS on insert
Date: Tue, 19 Mar 2024 11:46:39 +1100
Message-ID: <20240319004639.3443383-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

In converting the XFS code from GFP_NOFS to scoped contexts, we
converted the quota radix tree to GFP_KERNEL. Unfortunately, it was
not clearly documented that this set was because there is a
dependency on the quotainfo->qi_tree_lock being taken in memory
reclaim to remove dquots from the radix tree.

In hindsight this is obvious, but the radix tree allocations on
insert are not immediately obvious, and we avoid this for the inode
cache radix trees by using preloading and hence completely avoiding
the radix tree node allocation under tree lock constraints.

Hence there are a few solutions here. The first is to reinstate
GFP_NOFS for the radix tree and add a comment explaining why
GFP_NOFS is used. The second is to use memalloc_nofs_save() on the
radix tree insert context, which makes it obvious that the radix
tree insert runs under GFP_NOFS constraints. The third option is to
simply replace the radix tree and it's lock with an xarray which can
do memory allocation safely in an insert context.

The first is OK, but not really the direction we want to head. The
second is my preferred short term solution. The third - converting
XFS radix trees to xarray - is the longer term solution.

Hence to fix the regression here, we take option 2 as it moves us in
the direction we want to head with memory allocation and GFP_NOFS
removal.

Reported-by: syzbot+8fdff861a781522bda4d@syzkaller.appspotmail.com
Reported-by: syzbot+d247769793ec169e4bf9@syzkaller.appspotmail.com
Fixes: 94a69db2367e ("xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 30d36596a2e4..c98cb468c357 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -811,6 +811,12 @@ xfs_qm_dqget_cache_lookup(
  * caller should throw away the dquot and start over.  Otherwise, the dquot
  * is returned locked (and held by the cache) as if there had been a cache
  * hit.
+ *
+ * The insert needs to be done under memalloc_nofs context because the radix
+ * tree can do memory allocation during insert. The qi->qi_tree_lock is taken in
+ * memory reclaim when freeing unused dquots, so we cannot have the radix tree
+ * node allocation recursing into filesystem reclaim whilst we hold the
+ * qi_tree_lock.
  */
 static int
 xfs_qm_dqget_cache_insert(
@@ -820,25 +826,27 @@ xfs_qm_dqget_cache_insert(
 	xfs_dqid_t		id,
 	struct xfs_dquot	*dqp)
 {
+	unsigned int		nofs_flags;
 	int			error;
 
+	nofs_flags = memalloc_nofs_save();
 	mutex_lock(&qi->qi_tree_lock);
 	error = radix_tree_insert(tree, id, dqp);
 	if (unlikely(error)) {
 		/* Duplicate found!  Caller must try again. */
-		mutex_unlock(&qi->qi_tree_lock);
 		trace_xfs_dqget_dup(dqp);
-		return error;
+		goto out_unlock;
 	}
 
 	/* Return a locked dquot to the caller, with a reference taken. */
 	xfs_dqlock(dqp);
 	dqp->q_nrefs = 1;
-
 	qi->qi_dquots++;
-	mutex_unlock(&qi->qi_tree_lock);
 
-	return 0;
+out_unlock:
+	mutex_unlock(&qi->qi_tree_lock);
+	memalloc_nofs_restore(nofs_flags);
+	return error;
 }
 
 /* Check our input parameters. */
-- 
2.43.0

