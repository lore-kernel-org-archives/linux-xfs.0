Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271749;
	b=Erw+ZGeR+M3F6oyjQ+FenkSieT1SwHSnrtKEt5XhOpaIsKFCNbLVArtGIopvRfc8D3gI
	 Etp1uz2/OVtRdKXQRSqveBLRZ9p9oPQyAozcY8uhRq9jgDRwAY622wSJ0EK88MeZQxYk3
	 A+jolCo3gcvPvQ1icYu0aLfbERvokPOmQsU6XxBEc40x2boL1JSsutWofkaIEUiERiY1v
	 Bu76T9vekPFAtH4tlg8CQlUtY3K9UI7Y8CRuhZcSwAC3CsbBiuKjIFXfJcISYDI0G0PgT
	 4OXWQlzGW9gMfomo+FS8QgmpI0qC9QFW8pT7lNGAjVhCrlE1NC1Bb/V0M+Ut8m18+gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=NHMVaWO/zbvenPjNOM+NbEoQp2mPEaflr3T/Dr8YuIo=;
	b=SqWqVNpXFA8QBThNyrlqe6MsesQi4Do+vwdRylpnNmv/58ZH3nTfdsJSEkLrhfNWTorq
	 PmuvunxL/2TJf3TDCN692NOyT1ds8zVroOpU7pC3bRhmLltYle01ZX3SLklHWWDvouMzF
	 CzT4IW+w+lFyo5VCeIK33uzCOtmUzLYzSolv1b6VcMLOAuuaIdTTBI+HT8InCXJ3D4mKs
	 +ubJWhsfnUjKbX9s5X7tMFeRZTyg/92XiUUBVdmhakMH2s04AaCueno6Vn1Be1W4+t+Sg
	 ZyPq+xSAyfsDKPkc3L1ZuV8XzYeYPp4XFwNoC3EFVG+wweE7UjUQDojvKYdAqmleY2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eRt3xmpO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D82606A321;
	Tue, 10 Nov 2026 00:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eRt3xmpO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1CA1F0089F;
	Tue, 10 Nov 2026 00:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271748;
	bh=NHMVaWO/zbvenPjNOM+NbEoQp2mPEaflr3T/Dr8YuIo=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=eRt3xmpOAHPiKn/4tj6rE1zNWSg6dFeZS2NrVTq2wZFoq4IVrdN2wQJZknbXLurLI
	 Rlywu/Cttcuf1UIrI+liCpRugbZ9izSEiIrHV8Micmh/16bSXPm62m2ysnlHh5fzwO
	 4hylGqYjiDvwvf5oBCCsoBQ4pS3UE5/T1XfvkJQANVZegvKHlcy5gzZMWE8+M/cppi
	 FbcnMaVCpNNz9IAppLW0zg6Yn5kQ8hPjTCvGK2wz7P+tV2YqRNRxpwMlcobWVCfQUa
	 SKDg1FTilwZGvbt7t7oauckr4AV7RdtZP9sLjfYZlkYhNsp39/UKPXdIY+hKReKNAP
	 3zHfeXoLoaeiw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	jianyungao89@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix temporary cursor leak in btree shift corruption paths" has been added to the 6.1-stable tree
Date: Mon,  9 Nov 2026 19:49:06 -0500
Message-ID: <20261110004907.3538258-1-sashal@kernel.org>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-temporary-cursor-leak-in-btree-shift-corrupt.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 877b6ed7ac8eb295911ed677dc5518f0b159b2e4
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
index f5c3be85b1356..001db93eb0b90 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2468,7 +2468,7 @@ xfs_btree_lshift(
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2638,7 +2638,7 @@ xfs_btree_rshift(
 	i = xfs_btree_lastrec(tcur, level);
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
