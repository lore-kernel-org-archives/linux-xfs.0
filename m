Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272016;
	b=gXC13oWuEISFhyCkaVVUyG7mhry7QTdRMmxT2FADss6pPpvtn4kJoP1zc0jriQXDEXJv
	 syACZS2/8ihCQS2bF+hjaNf7OGn7087Y9GlgztU4b8zvibPwzc7cnw6Yfc7F0xgoY24gY
	 YKwV+iYDQdoP2hOocnUtcLMalVUsMkVCZkw1DXCN6AoklBa60uZiKVjjpqtFAnFsw0wVY
	 py8BbLcXc0zM2UlGM7Tz2j6TXcIKXzCenD592OHaHE1WJ3j6VOPD8kMc95f15zoIOKnS/
	 W1ptJUYRosdA02RR3MWdcJqh/73sWmS64zPRqhvX2+XAEpcv/df6BTVxu016bAfL+Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=MNx4lNBhD/MbrvdIk+vviIWhMJ3S5DhhNm0pzCWwpKI=;
	b=w4Nrx9Mujmiv1Lbauyk5A2G6wFxzGxv8G4CScy4xSxwe2+pgWSvxfE42/2K4gQrbrmkg
	 /eBxboBqxXOGRck/ib3WfZyV+2/a7SQ4MQl6NMvNBBOdAt8lb7CExwzfKrVV8LYM+CKAX
	 l159HCTwODDEkE4CVe5Z7f1/K5jG8HzXdZn46SeGci1BN4YhCvZB87F4rc3IMhKmS025s
	 KXTR4UROnhh6hNWJp6Gd39b3ypRCjLg86McPRsXmozOK5UASDCJ2a9kQnt06w7YiB6zgY
	 JZc4IlR8QD+fOJrkX+kpt81jjrCbwVD/rCdr9aq9770LP9vgNWbXI16EUPMPB+7uwHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dW8fvzqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C139C606A31C;
	Tue, 10 Nov 2026 00:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dW8fvzqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E911F0089F;
	Tue, 10 Nov 2026 00:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794272015;
	bh=MNx4lNBhD/MbrvdIk+vviIWhMJ3S5DhhNm0pzCWwpKI=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=dW8fvzqr9EodEf3bKQYa73q/of8GzUJZVIjNt9Yxg+ltylsGHmre1zVu+PBQ4e/3/
	 5ezCrHRVEU1DQPdNsFGFBTkScT+uhLHL09i7XxmYVWkTK4MbOR4AnYbyeaqGT0185O
	 gJuFbHr4bQ0jcxwLxieRVEFyNJ9iBWwt3i5m8/gZPmylWBnYxQb2FPd1K+UenskAy2
	 0S7GHY/ysCLPfqeyJtz5nctcUtcfH8XE37YojUjEmIO1GRULsfAr6h+481TGisgPue
	 bwox9veCshA3fQM4Dr2ij4YnSrXn7nQ9/bZ/HNbyS3CmcU/QPz6vHdO/aYfpag5xSx
	 Qqji+MWiEv1nA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end" has been added to the 5.15-stable tree
Date: Mon,  9 Nov 2026 19:53:33 -0500
Message-ID: <20261110005333.3544555-1-sashal@kernel.org>
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

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-a-pnfs-layoutcommit-extent-before-computin.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 8a7e3f2b00bff977d1ec3376ac9d0f03e2b78d58
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
index 3a82a13d880c2..7f950cf39e4d4 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -250,9 +250,7 @@ xfs_fs_commit_blocks(
 		if (start > size)
 			continue;
 
-		end = start + maps[i].length;
-		if (end > size)
-			end = size;
+		end = start + min_t(u64, maps[i].length, size - start);
 
 		length = end - start;
 		if (!length)
