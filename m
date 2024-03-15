Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8069653A0
	for <linux-xfs@vger.kernel.org>; Fri, 15 Mar 2024 01:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710465405; cv=none; b=JYSKz3nB4SGUfYgJ7uIckyjjUO3oDhR9P0FZjiENFZiHKGfUfzinkep6YLfRVWzoX1r56yNkgm7/J4apch16gxbS9RTJnE32Hld+IcL90G+L60Cz9KMLIX5wusP0QFEoBPbvWkN2vN8coln6nREJPgu3XzGRcLEC4D+7Surr35k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710465405; c=relaxed/simple;
	bh=SmWje92kSGKChqRcUJkaCe9Y3KbaR2jHd1w9T86nT4w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KM644B4s/qAza1+Nvpe5MpHnIryl7r8GlQw8TRXvYDOPimcWMamfmSUZW7A1XRepjCz538Lp5oJepau2GhPUPUNokIffGMwKwh4V6Pd8PcqpLX9zFG3FFFMQnsphETXd65OViISmIWaytqeRAqXwtCSgajeKrFWEDclulpFvBUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xF+cyDTh; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xF+cyDTh"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1de0f92e649so9696035ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 18:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710465403; x=1711070203; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ukzcBEzvOEl1WhzOS5sFIk+WYDet3NeMs6oNrlcecJI=;
        b=xF+cyDThmisAgTFXaCL5l5AIO41ZX9MLWOUVu0qzw3HPGx/5e6ukyb2eIWIJLsdZJB
         /KFUL0ZofCiR3i9KDU1+qtcxiz8Ujniivuq8JzZhuSt70PIcgDw+6f6S1EjB5G92OpdZ
         YIfZYAEfn3ZCD7/qnqQHUBe8KxubGN0OJontGLkBYMW+9ppLTC9IxkKuGNaPVc2Vx5qg
         zFBleQdBuaRYqF1O4ClmI3eqlzJSlHSAt5FqkOuKn5lwCSHnwAGp+0+GKHXNfu4SDDyf
         CoOKOmmroyKibE7ObNdlts1Ll5OBoOdcoD1lm1x2/ipeBr/SAQKLKeWosZkgAF2LIKHf
         9qCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710465403; x=1711070203;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ukzcBEzvOEl1WhzOS5sFIk+WYDet3NeMs6oNrlcecJI=;
        b=qA7TNWL/hpHSVaxADsVklb6Nla2Bk3S7GI20YeNchMzG5e7kxynqrf+7SbXNKDCiCZ
         SHgALLbulJoz4/nYPT3n6q4G1UVfc/KGYp8DicQak036HhfiN/5lWsOVziMNAMlhkflY
         E9i9YKN/lhzlsXF5lYXLup8MomUZipmhv9ng4VoKtm06jrRbaz/6278DpzaB8mKAKSe/
         uKbR4OuNaTaWkiA2QsTqXfJ57sx+7qOzEX/DpJLDQMhULsXEj/zAF3LXtpswkhNJ0yYC
         vtRKGDf04W/9Ire4pevIpcB5fEZym+I0P4uBf2gRR6sOqSvNe8j4ThhdNU4NI3seWGE8
         ZsOQ==
X-Gm-Message-State: AOJu0YyTS3UZrHhbhgSkEhYQ2F7TnjfKJWz+NQkqCsSDB/0KN66XprVf
	+TlKcMCePQ+xub2LLV0mJQ/mbzmXOJB8UAXB0/biC3d44ftXBcb3GuaZIrVHq8DBgsPT5Sje7zL
	V
X-Google-Smtp-Source: AGHT+IGxPgZ/j/ycpaywRpkOsNx5KAe4R16ppDHCyEZy6pHGJVYZwV8+O0a2WeO0cCzMT5eXdV110Q==
X-Received: by 2002:a17:902:ed83:b0:1dd:1c6f:af45 with SMTP id e3-20020a170902ed8300b001dd1c6faf45mr3248262plj.63.1710465402612;
        Thu, 14 Mar 2024 18:16:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id u11-20020a170903124b00b001dcbffec642sm2405887plh.133.2024.03.14.18.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 18:16:42 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rkwBc-0022z7-0A;
	Fri, 15 Mar 2024 12:16:39 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rkwBb-00000008w1X-2ILE;
	Fri, 15 Mar 2024 12:16:39 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org
Subject: [PATCH] xfs: quota radix tree allocations need to be NOFS on insert
Date: Fri, 15 Mar 2024 12:16:39 +1100
Message-ID: <20240315011639.2129658-1-david@fromorbit.com>
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
---
 fs/xfs/xfs_dquot.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index d2c7fcc2ea6b..9c027e44d88f 100644
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

