Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D9FC05027
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 17:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjBHRwv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 12:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBHRwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 12:52:50 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A649768D
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 09:52:49 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m2-20020a17090a414200b00231173c006fso2558188pjg.5
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 09:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PpMjG83bOPPqiYL947tygxhoRk3zLkQeyfVWRhdXhpY=;
        b=DDFm6uo3UZ2hou+n1alAXJlQAz+ZFThM1Gv93Nd0P7VOASN0lVNsvFTbTxiNOcxb6R
         4bAD0uLAkKFoVyr/rLtC/GRcEc/tNL1uqeI+ts4WrRzNf0w5dzJ156SlzlizLxW1Y2Zw
         aBgslDMbl77NODrOIBHK52uJk6XZwv//nmnnaNv71i4kvbgTR8Feo8zhtdCEwbAryg0K
         ecbTKpzfFrLXMToWOstzcOGyscgHz2YUa14Ii5WpWNBjrDkoL6Z1R0UfSXY+h4s2AxXr
         doEwgVKJZ6ufmrJTcTJKvn8LI1VARLdvyU0qDLY6DvQwSBgtAX51icAee3GTw4mN32J0
         zYRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PpMjG83bOPPqiYL947tygxhoRk3zLkQeyfVWRhdXhpY=;
        b=iohbnzDtZ9HOnpUA1VoBwr/mwEx5L8Nzech/pqK9KnwQc24qzrH0WUuDPJ7YwmcyLn
         bKlGaKrdlxnFih9WO4H9D2OYPj/CDhGSdkdgSvHzlEbz0IeeBH1tl9i4Hqp9fSVMfmC+
         +n5fYXXBlBzXJjwZA8MkfGoWN/NvZtmQ4ltpP3c8biMdBmNRKOFtMGeUZMkDbrdDeHIi
         BQFMgHBwZulqm6B7MRSDubsLyQSPu+V5dzpgvzFYxGBYYSFm0bNCIpwgKNYgC2GU6LKp
         ZNAenk0jPUYisr0eGJ7sfP+uEo8PtVmgtdnOW5oIaic1ECa+VkdvCVsFBhBqFINVaVZW
         l1iA==
X-Gm-Message-State: AO0yUKUsv6lcruungaNeE7cnht4YsCUuhBprjtJCwqDaeEHxtl/isJfW
        RBmG/nYbo0Z+gDzJPQ+9aCVlaoR+X4ZoJw==
X-Google-Smtp-Source: AK7set+SRAEs8DqZKK7nJcVpZzC9umonIRrs3vHPj9Vd0Z4NYbrNyMOlw8wJifSZJak5F6c0yzIdjA==
X-Received: by 2002:a17:902:ce83:b0:196:11b1:101d with SMTP id f3-20020a170902ce8300b0019611b1101dmr8970855plg.28.1675878768617;
        Wed, 08 Feb 2023 09:52:48 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:726:5e6d:fcde:4245])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902d65100b00198e397994bsm10911452plh.136.2023.02.08.09.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:52:48 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 08/10] xfs: assert in xfs_btree_del_cursor should take into account error
Date:   Wed,  8 Feb 2023 09:52:26 -0800
Message-Id: <20230208175228.2226263-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230208175228.2226263-1-leah.rumancik@gmail.com>
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 56486f307100e8fc66efa2ebd8a71941fa10bf6f ]

xfs/538 on a 1kB block filesystem failed with this assert:

XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 || xfs_is_shutdown(cur->bc_mp), file: fs/xfs/libxfs/xfs_btree.c, line: 448

The problem was that an allocation failed unexpectedly in
xfs_bmbt_alloc_block() after roughly 150,000 minlen allocation error
injections, resulting in an EFSCORRUPTED error being returned to
xfs_bmapi_write(). The error occurred on extent-to-btree format
conversion allocating the new root block:

 RIP: 0010:xfs_bmbt_alloc_block+0x177/0x210
 Call Trace:
  <TASK>
  xfs_btree_new_iroot+0xdf/0x520
  xfs_btree_make_block_unfull+0x10d/0x1c0
  xfs_btree_insrec+0x364/0x790
  xfs_btree_insert+0xaa/0x210
  xfs_bmap_add_extent_hole_real+0x1fe/0x9a0
  xfs_bmapi_allocate+0x34c/0x420
  xfs_bmapi_write+0x53c/0x9c0
  xfs_alloc_file_space+0xee/0x320
  xfs_file_fallocate+0x36b/0x450
  vfs_fallocate+0x148/0x340
  __x64_sys_fallocate+0x3c/0x70
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xa

Why the allocation failed at this point is unknown, but is likely
that we ran the transaction out of reserved space and filesystem out
of space with bmbt blocks because of all the minlen allocations
being done causing worst case fragmentation of a large allocation.

Regardless of the cause, we've then called xfs_bmapi_finish() which
calls xfs_btree_del_cursor(cur, error) to tear down the cursor.

So we have a failed operation, error != 0, cur->bc_ino.allocated > 0
and the filesystem is still up. The assert fails to take into
account that allocation can fail with an error and the transaction
teardown will shut the filesystem down if necessary. i.e. the
assert needs to check "|| error != 0" as well, because at this point
shutdown is pending because the current transaction is dirty....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_btree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index b4b5bf4bfed7..482a4ccc6568 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -445,8 +445,14 @@ xfs_btree_del_cursor(
 			break;
 	}
 
+	/*
+	 * If we are doing a BMBT update, the number of unaccounted blocks
+	 * allocated during this cursor life time should be zero. If it's not
+	 * zero, then we should be shut down or on our way to shutdown due to
+	 * cancelling a dirty transaction on error.
+	 */
 	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
-	       xfs_is_shutdown(cur->bc_mp));
+	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kmem_free(cur->bc_ops);
 	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
-- 
2.39.1.519.gcb327c4b5f-goog

