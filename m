Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272225;
	b=BcFCZC6T0/QJUGLenmAjvKR2cbiRFSLme4+cmCojH3VEKtnVWo5bdq4Aoq1hztJijAWN
	 eSKZtle0r6CEF7Lum/nW5cVHY7N1deQNeDDoxMXkwyJa42rb7l9tcRfSv7HqqKCimPkWL
	 VBSc7aS29JHfnjWPsN9t60VSPm0o41UZkSfR1fQeweG6rbFS7HCabbe8l8MurAiSDqrpN
	 B0YReu1FXmO3Vo+uhoDGP01vto9f+R5rvSvWCXUMcDR2z9sQEYDphUMvtJsDF7PW43kzR
	 lyrHZGc6/GSGwx6EWKevxrh4f5OQHszSLkhDtomAjRWAEoJSRgIXdg23h0z33uJUStQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=KuQiEqDbyjASn9MBxtsU7F/0WYNxOa49X1G+VcbZPzc=;
	b=ny4C1RZMA6q6CqX/ZQBRSdTjB5/XMK1OalfMTwEcsXSR5TbueLSEYZkq7selrYXt+RkB
	 02xFWAzbZY04FXzAF+ACHWZvaUTP4/JpWlGbbLX0iWzY5CFKOyAvfxPp6SfQ1O1rfMTp6
	 3fh0FseDZjpwSwFmIorcV8ucOYWxWULPsGJYmeD1Wfm4KvFO6WEpii/4ir/n5R+afqxgL
	 wrzNiOdUz6JX9JH7Km2w9hiK+F3Ij2R4iCN8TJ8xfTlK1jjlE5R2t5UhYJun+GJog+x3X
	 V8bC13e2msGwA+2rcxUyt3FPqhRH0PO0CeiYQzO2F/xXelkN02RIBPU/5DNElVpb+NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=co17Gx2F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6E7606A31C;
	Tue, 10 Nov 2026 00:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=co17Gx2F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE861F008A1;
	Tue, 10 Nov 2026 00:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794272224;
	bh=KuQiEqDbyjASn9MBxtsU7F/0WYNxOa49X1G+VcbZPzc=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=co17Gx2FCNxmilAOmD5M7ha/gx2lJZVzAWQRZSp89L/d1Duk9aJ68Bf6WhtcIjspk
	 03R9tkIfGbDqLo7Pkriigxl1jMQNkyQVB+hKp/QFqpdC4PetcDZ3oPgzu0QdmIGfGS
	 QNECjbyujKuwN8fzw2niXaXDr2RZ0XCufZeneNVuZakIm2ZBJUCila4B13wUph/boM
	 2ybY1QhVLsLarV1pvb3qtvOux2NEjJRAnic4Efk3FK6PEQDBbrjIyvrdsqcXC3l8Tb
	 KhI8Lr3FcFeLp8EhzSmTEosTlRXYuu8jLazYGm4pKjoTDSv9TYmfv5sqV3RbffF5XB
	 XMKQi1+eEPkYA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp the pNFS layout range to the maximum file size" has been added to the 5.10-stable tree
Date: Mon,  9 Nov 2026 19:57:03 -0500
Message-ID: <20261110005703.3549204-1-sashal@kernel.org>
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

    xfs: clamp the pNFS layout range to the maximum file size

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-the-pnfs-layout-range-to-the-maximum-file-.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 0eeb1b8c95e4c1a1abdeeed84bdff00017cb9470
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Thu Oct 29 11:23:03 2026 +0900

    xfs: clamp the pNFS layout range to the maximum file size
    
    [ Upstream commit 29f3c1be4e554c9dbc66e13333034e0947477cb6 ]
    
    xfs_fs_map_blocks() lets two bad layout ranges through. An offset of
    2^63 or more is negative and passes "offset > limit". A length above
    the limit, such as NFS4_UINT64_MAX, wraps "offset > limit - length"
    and stays unclamped. With NFS4_UINT64_MAX, a read layout is built from
    an uninitialized mapping.
    
    Reject a negative offset and one at the limit, and clamp the length.
    This needs "xfs: cap the block count of xfs_iomap_write_direct() at one
    extent".
    
    Fixes: 527851124d10 ("xfs: implement pNFS export operations")
    Cc: stable@vger.kernel.org
    Signed-off-by: Daejun Park <daejun7.park@samsung.com>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 8b82249b48110..e02a6b84c609c 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -124,10 +124,9 @@ xfs_fs_map_blocks(
 	if (!write)
 		limit = max(limit, round_up(i_size_read(inode),
 				     inode->i_sb->s_blocksize));
-	if (offset > limit)
+	if (offset < 0 || offset >= limit)
 		goto out_unlock;
-	if (offset > limit - length)
-		length = limit - offset;
+	length = min_t(u64, length, limit - offset);
 
 	error = filemap_write_and_wait(inode->i_mapping);
 	if (error)
