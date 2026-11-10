Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270083;
	b=Bk4qMkdLKJYG8NZg1ZWwEtVBEsh2UCJ8/z2N6Hs7kKoHXug+VgA8MesrC40kwXGS88j3
	 RjU07V1z2UyPxGCKfRUU4gGRU12Il/SY/3e9e7anY2hbo4yM+yeFriP4PhVvl/6t1m1lj
	 jX9TBfMvGcZ8D1e6mAwX8D8Nco1ICBlJkq7UAYtZ1gABWK/kfWN0c3woWRYOjmldhVphI
	 p1oFe3GmonQG51uwFZq0BaBk+wgM2mMBB7LvClGR29RiV3jTqtOkWnoWuiFkbAlFrE9uI
	 Na9TqsU3cT+ZgKjNHaC1QfxwPQDkkfSM9yIHDZqhFes5xxzaFKpjnXnpNqdAczo7V4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=vPvpQEoYIayIvh3m4bjbw3tcGLHPm7nokhlxoLdwDxw=;
	b=mbuX0R8kPQ5uaKIVNaCt2ugJEOMrn+jWamYJi99INTvAR39793EGg3Cjem+NrV1G5j7W
	 IVsiNVkSWRb27YTgnV0lMicb2q/ityFqmmWsgWP1MF/mWUqC3Z+ZQeDqctY3Q+tAQWKtc
	 3+1Qm1p0Xvm4wCXfkYLzrGoIqa1r/s0qeSL/e4w4tBHZGhtF0+j7CQjoEdczOKoTCuUfB
	 xz0uwzwjBv+159ZgSRzWm076Yu4uI0WbpJE6BEf/A2UTfp055Tk7pgaqQNIEU9qqXSaH4
	 xj5pmbwJOXHVchAo+2G1kUg+qmHGephmm93cVcVwqmaB1ecjJ8IS69mxFujGA3xMMAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VCtCJH8i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0855B606A31C;
	Tue, 10 Nov 2026 00:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VCtCJH8i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4684E1F0089F;
	Tue, 10 Nov 2026 00:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270082;
	bh=vPvpQEoYIayIvh3m4bjbw3tcGLHPm7nokhlxoLdwDxw=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=VCtCJH8iKvusoau2FhMTT/dw4nqZZnvo9bOrWmsICzP89N209iQOjhcivWbspfzXY
	 YqRMYJhWEsvE3lz0/TWxdvtZ45mv2oTgVqDg6bGN0PZglrkkx6B7W4BhyuaOP/Ulj1
	 7xfvxwku+9khRgFOqjlFywuaHUw5jjJtaEVanAQDPczgdRg9yF3tCMqP4MzCepTGRY
	 8sfaQiEWHmVwEVPh7YgQK5buAWXN7ox7qNx9xsEGp+jNQEWerzqJiDxx6x3IhfFcfm
	 N9oLlCERG7KhB7RM5V4meK+lh8yG0QC3gxQoNn2tcv0YCj3y+2z8jZffGVSaoIif8c
	 RB9VMIS+OH67w==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	jianyungao89@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix temporary cursor leak in btree shift corruption paths" has been added to the 6.18-stable tree
Date: Mon,  9 Nov 2026 19:21:20 -0500
Message-ID: <20261110002121.3504551-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    xfs: fix temporary cursor leak in btree shift corruption paths

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-temporary-cursor-leak-in-btree-shift-corrupt.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 4318d42de04df2e8615eae782e34cb539e9d88d4
Author: Jianyun Gao <jianyungao89@gmail.com>
Date:   Mon Nov 2 23:01:41 2026 +0800

    xfs: fix temporary cursor leak in btree shift corruption paths
    
    [ Upstream commit 2bbca049deeb1699cafd966cb2793fee576ee409 ]
    
    In xfs_btree_lshift and xfs_btree_rshift, when XFS_IS_CORRUPT detects
    an invalid firstrec/lastrec result after xfs_btree_dup_cursor has
    successfully allocated a temporary cursor, the error path jumps to
    error0 which returns without freeing tcur.  This leaks the cursor
    memory, the xfs_group reference, and the per-level buffer references
    held by the duplicated cursor.  Jump to error1 instead, which calls
    xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR) to properly release all
    resources.
    
    Cc: stable@vger.kernel.org
    Fixes: 9eaead51bed95 ("[XFS] implement generic xfs_btree_rshift")
    Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
    Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index dbe9df8c33004..b0824d381e7c6 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2567,7 +2567,7 @@ xfs_btree_lshift(
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2737,7 +2737,7 @@ xfs_btree_rshift(
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
