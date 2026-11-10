Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272206;
	b=CVGrEIAGZ6beu3CZ4ToRzf9YtggO/D0JrIvkkHW4HbEI5lueOeT1Iz4A7hMFRR1Qe5Hj
	 0RKJmkykwH+zSwAQujqq8B2Mfw2rlFFEEq9Yfqt4M/ZADZstlgdV1+GVDc0vOn6aGDjI7
	 7zE+LWhHhdLFYzPnWabmqYa2vD5SbuPpsIc+/kUebuA+bCle3/U9F1dvaCITWH9BzKd7k
	 pDlpvTSLjvjffHOklX2DZ++/9T97neoX/f8FkukLHKue2YQ//1fVPzYXFabDQCRDdnxkL
	 I1pudxHeYClWDcWkax557GG9wgeWgYEJ1IErEmE/m2p2WHSLPGcMq9SbLQuC7OK6S7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=dQx5RQJacGC9sacblpTQX3vu8RF+Tc4ZaB6TWdbyu2E=;
	b=M8DLPMtdffj8wSx3z2nVFYZQI7/tiIglv2KdiQMJ3pSDsaSqbVX7d+xfkg6vxdKEPISf
	 Oy6fYHVrM54acpTMFlJ3dmQRfjxMnBKeOiZ57k+dcQNKoY+bKOd+vY0WU+OC5rUfIisQX
	 F7CLtM7gZX2S0SyCHtsNnu0S1xLR0D8WzIX8lnU/qJ/VBdzk80sh7EMY5SRkX9GS7lqke
	 aAcStFFXPvlZ2DkjYLbcfaaVS8orlNuHBx1JHTR2HyfyyohaSmutrhIhcaKx9T2uIHIU4
	 x9TOHCGZ1qTw0FvPJohvX2bkyPjz0Or19LsMj9ESAzOlFlGZgmaLr0PGsCd+oQYpd3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WejqS+bf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B1E606A31C;
	Tue, 10 Nov 2026 00:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WejqS+bf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B36B1F0089F;
	Tue, 10 Nov 2026 00:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794272206;
	bh=dQx5RQJacGC9sacblpTQX3vu8RF+Tc4ZaB6TWdbyu2E=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=WejqS+bfdPT5gay45bmf3q2u4qH4XlAKN5OdDwlbB/QyoCw3bz3xzWIlJ5/OCZ4KQ
	 iE3QPOMHhyKsVxbGeQ1QlozELUuJDN41P+f13Lamlbnptez4lum79Ijs9j3ejggw26
	 qBjuTr8XWOf1spipLOawlpwItaRkjTMzjojzJyw0jRSPgl9O8OIN7qY04r0qHNRB9D
	 nPo7xJ8asmb8nVmIYOjRJWcIMi3HFRyUH/kkv3YbpG9e8851Nx5nPqyl0tuRN2qND3
	 kZHDNFGE1k0fa2VhFT1WkPbMHBbHsAPai4tzFOPrkpI6o9bzF+mvLj3anpLb6ISGHv
	 s2hocszfA5OIw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	jianyungao89@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix temporary cursor leak in btree shift corruption paths" has been added to the 5.10-stable tree
Date: Mon,  9 Nov 2026 19:56:44 -0500
Message-ID: <20261110005644.3548844-1-sashal@kernel.org>
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

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-temporary-cursor-leak-in-btree-shift-corrupt.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 1362e99af29e04707c32a1bb12c53130ea08807f
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
index aaa59daa77d05..6cae1098f73e1 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2396,7 +2396,7 @@ xfs_btree_lshift(
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2566,7 +2566,7 @@ xfs_btree_rshift(
 	i = xfs_btree_lastrec(tcur, level);
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
