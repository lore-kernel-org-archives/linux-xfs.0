Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271089;
	b=NP1i0tPXPgSI3xx7xHVuwAZAs7VhTOpsdZsGpTnQajrN6NBCosSPB3JOhV5xvZRdf1nV
	 dPqilVdgDgU5Yb7C9wc2ns5UpjD424Ihhx/IjGoh9NSc82zBdH8ZjOpJsdPN062yTWumQ
	 8IBFv4UwoU06xmH7oQDYxc90P1m7EAyTi0jWjn/Mk1tC0vGLS5F/SmjjKvPrS/MbMNTlf
	 C3e8OQrozzFo86qr/dOu754v6JLxTdyEw9hU3dQjF1Q3+GQNV6uj74crppNRYmayNTMJ+
	 +JYW2iTtfINYDqcI/9Q7R7efNdo3TZ3rnsz/hq47wn6r83TNfpLtXrRQYEZ8KqzIQRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=HUw04Ltx5FA2iUiX7+l9T98HXG/lqVd97NgCtGgJkc4=;
	b=VKiDw2vpXU2dnasgbkpyvGc3/pjJMFEgM3C6YcRAgRoC62CCoBV4jJrZCX1WDDGHbUqM
	 1umOl++0BZt7UjacL0NGi3o0yOBgz+YpTw701J2XnCjdWbur2PlexHZB9ol1dqB92KpSl
	 bj7AkRSUdfW9M+Ek4qPgcT/ldQYG7jiy8zQ7A79N4Yx0jF1a/e0qOoOvkLSBbDqnNkvK0
	 RBRM30LHakn5kJsB64oEKZpgFNOtKCappn5P6OaC8Yf7jmGUu8OLW/X60uKst5VWc53Ny
	 u4D0Bc1A21/HQTzwH7hguTwoFAC9LX6cm3FpsxyoEqDYqt60XqNfIO8xdIcF+dgu4OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cQR9XGs9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6F4606A31C;
	Tue, 10 Nov 2026 00:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cQR9XGs9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4591F0089F;
	Tue, 10 Nov 2026 00:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271089;
	bh=HUw04Ltx5FA2iUiX7+l9T98HXG/lqVd97NgCtGgJkc4=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=cQR9XGs9yw9ZZ9JDVsvUGlEik2C3x7oD2WuLn1qjdrqm6UUfKb+yQGeS9rIOfDeVq
	 Q2r77yX3WEWyZCiuJbf3BIg3N3v36FsDyXu0+1WcoBm3ZcCZOsr1SpVNzGNiTcojjo
	 xcNbDGCprPMNF2+3RNqomFxmnelvBZQk0+J+4RUEqrSzoPz8VAAWkRupfh5Q4dlhEX
	 6LUXiUGRkujW5c48UYCMZcCavZz9Q/Bko6z5bGus/MaBz6HRmHob3UZvSOzZyTyTOL
	 F3zsYnS5o/jUb8bg/AlJrVY1jJaYWEf+xVrRhENm7+82p4pcXa8xW44Njx+K1OX+ro
	 ws+YDYGF0CsDw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	jianyungao89@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix temporary cursor leak in btree shift corruption paths" has been added to the 6.6-stable tree
Date: Mon,  9 Nov 2026 19:38:07 -0500
Message-ID: <20261110003807.3527291-1-sashal@kernel.org>
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

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-temporary-cursor-leak-in-btree-shift-corrupt.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 2af22d4e1b8e0420eb042c5288c321e027333534
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
index 1328dadcfc299..331bf27f2b219 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2467,7 +2467,7 @@ xfs_btree_lshift(
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2637,7 +2637,7 @@ xfs_btree_rshift(
 	i = xfs_btree_lastrec(tcur, level);
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
