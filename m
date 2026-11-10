Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269329;
	b=tKPITYN+eo+BBhv5eYGcKvREwzWTg6Yr7y9krntKhOYKp3kdB1fop1ccWCRG8ekkYP3a
	 iGqGaciSChHF0tODgxyY198mG2my2w55/r1MN4Q2yplfSISamkjl/qgXHr4v8pb9x2OFx
	 4GCgEZhm402TOlfWSPHBMPaedjRLQqxoHztPIig6QU+mAw2+d73aJsHSih9Mt7JFyDHkI
	 uiI1h8fZmq0paeuv5UlDWQant71chionMriIUP/gTTGsyKtXZGQJ+sbhuoGiTaZfBvs9N
	 XXFnZ59fn1QYT+PclzK5K/j6I6f8jXy2MjhHQ9DuKNX4c0R2TxMc94l6PMnxR2wSEYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=NugvLeQAwGUg3CAnccT6/twGHgBhp8467iVwYm6U0MY=;
	b=vTSjS7O7KfwWV8V8dueNFM27jihao7Y5xRWrVTiaeDtwtkN82+Gvb4kIpQ4NhUJPh/FS
	 kcpmN9XrOXtw6f2YzSt/b+6uY8eh7rwPGC9wPhvnCpWEqQOvQC17fuCwei6goyMoJMFbQ
	 Vf3O0B/PAgXuyC8fvvhAzSCH23AKF7uFG9+8jdSLDamrpdxEJ1G2r7RDLeYds5xY3nJRx
	 GfJd8doYPWPmNSkmdMkQZ7qOoqVZvBxdDW98rCczmvih6Raq5fqh2Dsuzp1VwFgDutcOD
	 auV8ZOObRzr3hcDkoEuGzqQoOxQ1EhMMSqCeONbgPyvKpQg/xMjWKQ+/dsQZTTFp7ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rlv3iJ2p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2804606A326;
	Tue, 10 Nov 2026 00:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rlv3iJ2p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1981F1F0089F;
	Tue, 10 Nov 2026 00:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269328;
	bh=NugvLeQAwGUg3CAnccT6/twGHgBhp8467iVwYm6U0MY=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=Rlv3iJ2p8wARi2jVKS66aiZIpQwoPaGUJ18raoUv5cBpFUEgs/zkvqhxZnjnn/i8H
	 /Y68jZSyFCxXCuHYYEyWN16dXpUzh8hcoJTW+lthWsXt4dxN3vUuPpyNQLQRH2PKIi
	 Y7uk67SYncExku3j7ni6UQmBsIRAchN1YmvKnBHKDBcQy3QvsYlsW+foTovAT93Dj/
	 BnopPm8jfQBUyfXgU9gRPjBqMNCEfrMvQOMfoTjAuoZCUbOJiFsV6kYOWfwFOtk17g
	 MNqjoT3R3Q0QcR7OgDoSREqMXFgSYhGNdaPTklLBunIxrt5+d1aIQXX4/auM52+kID
	 D39E7HjKtvnEA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	jianyungao89@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix temporary cursor leak in btree shift corruption paths" has been added to the 7.3-stable tree
Date: Mon,  9 Nov 2026 19:08:46 -0500
Message-ID: <20261110000846.3487274-1-sashal@kernel.org>
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

to the 7.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-temporary-cursor-leak-in-btree-shift-corrupt.patch
and it can be found in the queue-7.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 51b2650de855425bab8a18b76122dc1ab017f021
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
index 60ef7f08b1d30..b978ddc13c15c 100644
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
