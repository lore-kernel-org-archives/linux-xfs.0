Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272000;
	b=i/aNiCjMKotBwMrPBUejN4cAWyKD4mkAOMBmF5tY2bEm5u2M2/ToyqtDqn58BTLKgApT
	 duGUE+ou+uRgE9p0WAzVK9J9tjn26GdAxzd2oJ38+y6JPBRONNaQ2F9b4yNgVpJNYZFUV
	 KW3ZBcxvbtXhJ4o2TtOkYMURFZJ+VQATNGazc1Re+f0ipVLdXTeLNcWzzPLNl+CYUjxpj
	 NUmnYLE9aoidqvTDrLOOISiS0+pCC698OMhuN9e0Nsun+5ZYeiAYcIk1k8Np5UueZaia/
	 Sl6QKMDk3+GzSO/5yKaMp6QIwt2k4pbDD8JrS6a0JY7e3uJmC5cwPrzFyviwZj2WZoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=1RiASaiLFclG/o8tbPrpf+cMfXdepz1QPLFzP89j9Us=;
	b=j4XIv6LdyCWzy/eIoI+nRG9WXHSwW+GvNbOz5ZS/e4lzwo58lJNHVPTi3L6t/w/LZBY0
	 U/IleUcmLFKoITClr2MReoKF799h5L72Dyr2VGZR2briy5CBCOS+tk+2jDtnfhZmVRfdd
	 kJpkohZ+by/rzMJbW5MrnQAgAEcH51aSgWSPQXqpTKjUx+QPfVFywNwHNHlwXDDjSIAXQ
	 77ptHKxjFFBEYXPe2zbS3TZ/1n8xmx/TbWYGEUewFRPI+xLUk8rByUWpAQtkCxU1T/p57
	 wze7LLX5hkZORJDYcRlYfGIMUHWB7oWB3EIwYjkL6WqUrmc+xQiaGYQ6DSWacN9bxMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZUB0mNWE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BED606A32A;
	Tue, 10 Nov 2026 00:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZUB0mNWE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120E71F008A1;
	Tue, 10 Nov 2026 00:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271999;
	bh=1RiASaiLFclG/o8tbPrpf+cMfXdepz1QPLFzP89j9Us=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=ZUB0mNWE1h36I6+zdICHZlIsJzjgKwJCHAVffX1FavN47dZFDWK1t/aMatD7dYr4B
	 mnMsvukC6k8lv70vAhkSDNyNW1n7AbFsEWZXQ4tbLYubaULoQH/ZId+UZg2S8wP1V/
	 M2j24J9hs5bsirsU3IkY9/HVh1c8A7a+GAaKTn7rlYZlR66iW66H8kp9h4eLup3eQs
	 0TQ84JU1cwhIPuatbX8o+yL0zyyvClOXyucj74YrmMUJ9Yrw8Jybe/Q8yFqiFLBxHH
	 Q+CGR1Mm/nBeSjoltxbKGZ2g3wRRUZfABH2zAQdz4ErdVYv2Q6UcBznyzveUYo0jZR
	 iHizz5HSFFwZA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	jianyungao89@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix temporary cursor leak in btree shift corruption paths" has been added to the 5.15-stable tree
Date: Mon,  9 Nov 2026 19:53:17 -0500
Message-ID: <20261110005317.3544165-1-sashal@kernel.org>
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

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-temporary-cursor-leak-in-btree-shift-corrupt.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit e27fc47b91acd19457d0808ac1403025ec722505
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
index 13032aec47ee8..503db9741cad0 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2471,7 +2471,7 @@ xfs_btree_lshift(
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2641,7 +2641,7 @@ xfs_btree_rshift(
 	i = xfs_btree_lastrec(tcur, level);
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
