Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269375;
	b=caeHyANjl835930DfYwzQG7E1mxIOKeBcZw7G0tPim8mUZkTLKKtqakX36hpFBolbt70
	 CZrdrnkh7aVlxM8vwVNg0lIE+UYnx9pZrjrAroxHjqaKpKCBOoAh0CTMjAzI/FC5p+7vm
	 UUXInfkyi//ALU7pdJzCX/CDNOb5mP2w6+PcoNr3iC1PJPubsvldMbtZPTRJqskIA3xss
	 6H3fWa4L+EZgmE4PNm60citA0NIGwwI5+OXLbxDTfHl/nMh8dc0ZDFt3ddaQOQlbbQPKF
	 0xEVrATW6Gul+8G3VwKkeCgt1rZXyUWkDAJ09sOniTc13sMUdSi2N2wXFa6qEaEyk+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=D73DCMaheYkrJQywXilee4wy6kbBhV6B0vo+Xg1lZjM=;
	b=rQVqCpneuznGrYwwlTaOWW7N2ApRxxBMUvitzotfVFRWW7RS3LTcvmM8VaBFOnSiH6+s
	 YCjZ/pdfuLBlpd3EjlmX4FGEDFzSIZ74ErRUvsqBwiLTbSZaMKKf/DyPu4UYepEF6f5lQ
	 9TZ8Hzm/OW1T6ROxjqLhvd/swC70U/wfHnwIPM7DKO+4GOiWZB326y2xYvPgH1O691xaV
	 EUMA4wHd5wImPJqQMqecPAdk1gBzKtuuG9f2J+LmP89uUUkuEelTMY+WOGkM51aqOorh8
	 jvylQRXjiJNGG+/c4cOrsuONlJBLxg2iqilzuzl9LAxSXQaEOg+fDkBJZ5XsOtuSoqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NSfJsQ5K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302D3606A326;
	Tue, 10 Nov 2026 00:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NSfJsQ5K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC0D1F0089F;
	Tue, 10 Nov 2026 00:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269375;
	bh=D73DCMaheYkrJQywXilee4wy6kbBhV6B0vo+Xg1lZjM=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=NSfJsQ5KtRk6BGcDKlWaw4TbFpsxZcFaSmE9fQKBetJy7YXz4eiThEwXPb0QpisDK
	 y8xa0tX99yTtYlZ/wzkPphd/QcrhopvW8mmDZpo/03xTEGOgajk8lD/jLklLJf5ZBB
	 yYos6KdFTYJ1zTVTqX55Wuab5vtEtzwl4dZl1FL2f2Tn1HdljD8llEWCGPBcReqGaI
	 L3grUh8phkK/clASlknBapQVMxl5nrx1qcYuY2Zlwq3K26CJHbfzFvxuftP1/aIYiZ
	 FlstoINYRDbAyHR8/cVr2vzh3eKAt9E6lmE5KhrUNaviA7PwKSsL4koqtjVrN7Ab83
	 PphaUWZtWPyLw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end" has been added to the 7.3-stable tree
Date: Mon,  9 Nov 2026 19:09:33 -0500
Message-ID: <20261110000933.3488317-1-sashal@kernel.org>
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

    xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end

to the 7.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-a-pnfs-layoutcommit-extent-before-computin.patch
and it can be found in the queue-7.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 947997c2d71a678463d3611b40d94b1396f1c810
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Thu Oct 29 11:23:01 2026 +0900

    xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
    
    [ Upstream commit d8c2bc88460f89e543ab3af622fc8f34c7011d71 ]
    
    xfs_fs_commit_blocks() adds the client's length to the offset before it
    clamps the end to the file size. A large length wraps the sum and
    reaches xfs_iomap_write_unwritten() unclamped. With the previous two
    patches the LAYOUTCOMMIT then fails with -EIO and converts nothing.
    
    Clamp the length first.
    
    Fixes: 527851124d10 ("xfs: implement pNFS export operations")
    Cc: stable@vger.kernel.org
    Signed-off-by: Daejun Park <daejun7.park@samsung.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 7ff83274a5135..19eb18e1290cf 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -328,9 +328,7 @@ xfs_fs_commit_blocks(
 		if (start > size)
 			continue;
 
-		end = start + maps[i].length;
-		if (end > size)
-			end = size;
+		end = start + min_t(u64, maps[i].length, size - start);
 
 		length = end - start;
 		if (!length)
