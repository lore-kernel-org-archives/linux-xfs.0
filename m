Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270659;
	b=n10BagWc8Fow721uyb8Fbi66DueXRnW9HNyC9NSOdcupM4BcgYOLNuXRiaDT5Riq6Qc1
	 iUiPc/X1N/4wQ1GDIsdlrKKDgokM6JMjLFZk987rCDHR1Bqdhcz7GTCH6lJGhLOGLEaD+
	 m9Xe1cB/oG+5qwNx4DinTc+QS1pP9It2XVsJe+Ie5FUUakBZXClYSjesUhlwqV151cVZW
	 U1U+nuuGnAdHk9Q0bkXtXviAzRwCTHojaBAFRuH7N3Ech6a+7FpBIP3/GGGI1qj9N6hFx
	 g6JKEWOAOPX34AJc3rkauiMoVpqSNdyUSCa30OwYC65FVm0jrHqzkfrERclndia3S5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=NzQCMf9SPq+Kqo9gyDnpemlH2o+9Nzq65250Tin5XDE=;
	b=vZWC6uXSgK7DyD9zHg3Z4Bjd8t9n33lmRAIg36DCkEseOWxsS6CwSFywTeSSlMEwrqQK
	 n/YE9LCI5MCLYFWL/YKg+yb7PTiLuJ26PPhrmTBfbVtYxCGbgHh4eO8QAOeLLW/f6BQUa
	 OztnrX2q1gM04ewRi0UAADAAjXUbbismt33wPjEWikRQs2lHQgi+4lur2qV8AS9ZAMDa+
	 B1t3QfI1p8qOxJ7cgcXLuThosbikHvn9GkWxZBq3u+1smFDdhmCJN76x4IyqqkVChnR/O
	 X+aaNbkVRRa70MEL3osALV8fZGbLDx8V3wnCGdJ1g/BZVJ/Wcm34P1kcrb9DRrhCrWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FdXnHekK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27B9606A326;
	Tue, 10 Nov 2026 00:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FdXnHekK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9671F0089F;
	Tue, 10 Nov 2026 00:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270658;
	bh=NzQCMf9SPq+Kqo9gyDnpemlH2o+9Nzq65250Tin5XDE=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=FdXnHekKujl6zmlOaUZwVt7Bm93p1X7fmvafyM3NGDtqvxDroDjJcOfL2QXFqNSJ7
	 robVQs7zu+/y76t21y8le1jj12t8HrYCM6EnPjXbJz7DwBJsmanhq5SudvDUDVb4if
	 4IbqV9AL2qSNwVAdJnV60w9H8jHgCFOuP2+BD4ZZuNOxVada1DGGN1l3yjd25Ig3r9
	 wRNMJdU0hiZa/s6UbbF0QmoL8JwZcnOOpqEGXVaex+nvVbBOAwhYhYWW/00WFRak+p
	 iTQV0fxsm3RjaP17yj4zqLfN09pAen+MBSmDb9NDqqmJD/fiKTH6X2zplsBGWVSbcj
	 f/FFhZ4fQHwHw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	jianyungao89@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix temporary cursor leak in btree shift corruption paths" has been added to the 6.12-stable tree
Date: Mon,  9 Nov 2026 19:30:56 -0500
Message-ID: <20261110003056.3517473-1-sashal@kernel.org>
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

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-temporary-cursor-leak-in-btree-shift-corrupt.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 2018837581845678270984f4a168b97fb05167e7
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
index f0ddaa136a0bf..de09db78df1ad 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2568,7 +2568,7 @@ xfs_btree_lshift(
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2738,7 +2738,7 @@ xfs_btree_rshift(
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
