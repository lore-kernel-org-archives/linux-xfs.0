Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270692;
	b=HniakZ8uf4t2an+x93hSisbzrK55DiUSWg/p0L53ZD8PnGa4pUQ/9DWGaj0+DoW2NNjx
	 ky29qoTXZ0vdwrwQODvGXnQSNH0Sq908pklJFnA6YwpLwMxQIgJn5S4W2Gj+HKdBjTnST
	 wQF+ojgT4RdUeapGZT0tGSPpwRcjnCJXHA21Xx6cKdEHXiv8OYgs+Qqvr3IsjiQwsc2KA
	 94xsrPvQ+F6Mhd77H6P5fUWrY36LhQTmLQq0Qcqr0AufQeMuCIzaFQj1sNPScpmiBA0S5
	 fYuLTvhf8iuFNNa+gsQuTAnPxGWAm/dSIQdWBlx2y9el1HeZQTQSC1ZOXti64fiBEbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=5oztTCgm8ZKchE4D17lzFJL+zkvvYj09aIlqodDX4jg=;
	b=W9pPsg2SUSi2FK0JjxRnS8c9qee7h43GIQZgpo0H+xR2OK8F9o8aSCYr3e5e7al8zc8K
	 J6muDDmmlk1W/Ksm12uaJt27xZq/SRraoLR9Zb8KWGUBJxDHdkKDw2rNYdzYRQTMi3LFC
	 ugzMOUA9AbP+Zy+yZkuqtoQfPPO0nMrP59iLOsL+zv/+X4fXRpkL5wsQv0OBnY68tPAap
	 AG8UIknTHxo4fOk0MvWbXOgMcc4Q5hNRYtQUYEokPPcjK0qUWRv+vLg//wjcGma2d7wG3
	 M+G+aJ3e0GRNCBTxJMtzUtedDmxamr8tdNOYoYEAlDFu0/HgI575l5TTPL/z/tZuNMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jVzi6y7f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CB0606A321;
	Tue, 10 Nov 2026 00:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jVzi6y7f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D41B1F008A4;
	Tue, 10 Nov 2026 00:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270692;
	bh=5oztTCgm8ZKchE4D17lzFJL+zkvvYj09aIlqodDX4jg=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=jVzi6y7fLMt2UBoSsC3bJa4pgRclsG3+ChefQSmhZVIQpUfptHJ9faOP+SYf1wDSV
	 /NtrCo69/Dk9MMcTi5XSre/K45dyvsmNweHyacKm1TMaX/tfK70PMg05qPjyKwbsmN
	 WP43fmw3wZRe9i3neUOrzrZdtx6ONU78jCfkG3kJXKSbBFcGWrygAnFvWB5CsQak+1
	 8/esoNvq/HaxIl2pSXvumNQKuP/Wj2vccouWOKRLbkNU4IWVdJz61Z2eSYjS2Od6f2
	 rxIU5IAbAHM4TrigeAdg2Su1NHj3ECs1Er0ZZ5mUDAa71LLKbjQs2WT/muIoUPLJtG
	 KQWnXi5Xx4zNQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end" has been added to the 6.12-stable tree
Date: Mon,  9 Nov 2026 19:31:30 -0500
Message-ID: <20261110003130.3518256-1-sashal@kernel.org>
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

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-a-pnfs-layoutcommit-extent-before-computin.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 2ec988432a2fc5e2fc3ce6883ffdc4563a392ef3
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
index ca3d085a3e781..a222410812ac4 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -302,9 +302,7 @@ xfs_fs_commit_blocks(
 		if (start > size)
 			continue;
 
-		end = start + maps[i].length;
-		if (end > size)
-			end = size;
+		end = start + min_t(u64, maps[i].length, size - start);
 
 		length = end - start;
 		if (!length)
