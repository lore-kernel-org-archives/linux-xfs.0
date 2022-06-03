Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D6EC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 18:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348469AbiFCS57 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348471AbiFCS56 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 14:57:58 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF67929839
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 11:57:57 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id p8so7800647pfh.8
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jun 2022 11:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p0GvSyaxNxBXM58sBS4doLVL/WnuV1GwKXiFtJxqoUI=;
        b=anRpalqkw/yJD8jwQEq3F8A5Tsb0mokI254xKTo730jn3Coov0QsuhpAXxBXLBYcNk
         L6ccsjSf9WVn9PV2lIAygHvn8SU9i2DJIXZ1CXGaQ+M73l0ahfn7xN3hFYc2nAT3bJ7C
         ny7BIRpYTVHBFEdoqbhT1z2f+36WmTBVRg6Y9GQH4Lie0mLbzjbd6BeBiwmayswB8d+N
         RqYDkoi8ZdGU42dGqlmlYT6YpXA0Odu0kNiSGQW9je0/DgaOqVCQh+VahmcofwxxTepV
         +AZBwuziMV+WllBng1G24TCIZZ0ygidXchYqwZEp/EOj3uPIBoUflw7DAblzGdcyIz72
         IePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p0GvSyaxNxBXM58sBS4doLVL/WnuV1GwKXiFtJxqoUI=;
        b=BTXLJIMbNhwvHFRlDtlb6fCSjnifYNQNFimlR3NJxtxMTg+Xj4ss6Lz7L+W2jdZ9DD
         vJUm0/SFGju28vVn6sWNd9J25EhaRvcOOmJowXIwaMDtbt74L9YFpi3Su+/NCNe6IhcG
         NQ9hxX3BvELYSD77rm+N6h6Lgvno/EK/HVeXr+tEzLutWGOPfWoZA9/y9SNUYlUSYkTC
         8jLfVhGQGWeuzebDK0JypKAxHvKrEArSHO8oqiFO4komRq63Kqhwq/ZWEFZKni3CfoWI
         1cAEcyhAD0TjDXnbSDWerPLYuPFQFeEJgTBW7NhBgWRR/KlugjRvUwANrRsRd0y04VmL
         3a3g==
X-Gm-Message-State: AOAM531dhQkU09pxQNWpx+M3qDpR7xJExFZBRRhLPlqER9lSKYHD+sqL
        YWUSjpScTlh6UdjRaKws7ZPYGcqTh6XovA==
X-Google-Smtp-Source: ABdhPJzRvFNvOmnlRvLO6s/kAceZMAhPkYmNOuaGg7c1wcfesvfKV8sZm3k7FcERpK6UYCZOHKJ7Bw==
X-Received: by 2002:a63:f403:0:b0:3fc:e1c2:6a53 with SMTP id g3-20020a63f403000000b003fce1c26a53mr8599453pgi.302.1654282677344;
        Fri, 03 Jun 2022 11:57:57 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:e74e:a023:a0be:b6a8])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b001621ce92196sm4480969plk.86.2022.06.03.11.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:57:56 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, kernel test robot <lkp@intel.com>,
        Brian Foster <bfoster@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 04/15] xfs: remove xfs_inew_wait
Date:   Fri,  3 Jun 2022 11:57:10 -0700
Message-Id: <20220603185721.3121645-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220603185721.3121645-1-leah.rumancik@gmail.com>
References: <20220603185721.3121645-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1090427bf18f9835b3ccbd36edf43f2509444e27 ]

With the remove of xfs_dqrele_all_inodes, xfs_inew_wait and all the
infrastructure used to wake the XFS_INEW bit waitqueue is unused.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 777eb1fa857e ("xfs: remove xfs_dqrele_all_inodes")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_icache.c | 21 ---------------------
 fs/xfs/xfs_inode.h  |  4 +---
 2 files changed, 1 insertion(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f2210d927481..5f397762a3b8 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -289,22 +289,6 @@ xfs_perag_clear_inode_tag(
 	trace_xfs_perag_clear_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
 }
 
-static inline void
-xfs_inew_wait(
-	struct xfs_inode	*ip)
-{
-	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_INEW_BIT);
-	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_INEW_BIT);
-
-	do {
-		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
-		if (!xfs_iflags_test(ip, XFS_INEW))
-			break;
-		schedule();
-	} while (true);
-	finish_wait(wq, &wait.wq_entry);
-}
-
 /*
  * When we recycle a reclaimable inode, we need to re-initialise the VFS inode
  * part of the structure. This is made more complex by the fact we store
@@ -368,18 +352,13 @@ xfs_iget_recycle(
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	error = xfs_reinit_inode(mp, inode);
 	if (error) {
-		bool	wake;
-
 		/*
 		 * Re-initializing the inode failed, and we are in deep
 		 * trouble.  Try to re-add it to the reclaim list.
 		 */
 		rcu_read_lock();
 		spin_lock(&ip->i_flags_lock);
-		wake = !!__xfs_iflags_test(ip, XFS_INEW);
 		ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
-		if (wake)
-			wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
 		ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
 		spin_unlock(&ip->i_flags_lock);
 		rcu_read_unlock();
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b21b177832d1..2303d035f7d5 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -231,8 +231,7 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 #define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
 #define XFS_ISTALE		(1 << 1) /* inode has been staled */
 #define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
-#define __XFS_INEW_BIT		3	 /* inode has just been allocated */
-#define XFS_INEW		(1 << __XFS_INEW_BIT)
+#define XFS_INEW		(1 << 3) /* inode has just been allocated */
 #define XFS_IPRESERVE_DM_FIELDS	(1 << 4) /* has legacy DMAPI fields set */
 #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
 #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
@@ -492,7 +491,6 @@ static inline void xfs_finish_inode_setup(struct xfs_inode *ip)
 	xfs_iflags_clear(ip, XFS_INEW);
 	barrier();
 	unlock_new_inode(VFS_I(ip));
-	wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
 }
 
 static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
-- 
2.36.1.255.ge46751e96f-goog

