Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271771;
	b=XAkx/mSJlrbsI3JiEUBPxjFDh2sDN7QRezD+b4w2TCHlN6pjbe5jKpz9nIQ4P1Y6ldHp
	 aCyZvNO+rkl6Tx2D32Vm6PewcB6R7zl2nbbH7KMx/SHMYZZkN2+HSPFmnHPJMLIO1hZ7g
	 QZmlCjKK1YkIxlSwG2WqtK/IPvTZEds7ZLEWOOzt+10DPKGcx50814DOTK9OMZyTmrKPN
	 pITPHDdi7A4O5q+JPdpL6+2o8lPMIykDBTiVeK/TLAYVV9fMd+VicTbxt0E50FJHAneWY
	 SLXE2jEEZECy/68zxeXMHX7e+RO99geh9CC7a6dWfe7QML+ge9inf5RfxeUS6XB0gXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=8b5CTKpJJLir1t2aGKPfr8Jig2ZE3lMjas2xdCQR+y4=;
	b=i8eo4rtBKGUht+EDQIzVCZIX7To9D2BbhYCn+lo+HfC1Avz+FIFk0aZE60Ylcq/8PfN0
	 MWBu6b1WBRBovOSrTydT2IzSfq3bX/vBwQFV1zCya5aOmCuC+szdbf6VSSpB91y22M6gB
	 uhXSiObvdpL4AObYKyZB1MQI+d4IfA+m1e2PaOsJYgG2XngEJmIBnB5BuAWQujM4kattq
	 Y1j5wBeWUWOnjCAyZgKf0LiQbvFiS1uHRYWsJ4FOnqsNT7bUO41KXrEa/7lUO5jFpvPZB
	 zra6Smsrybg2K4YEY410ZuYnjFlNQnigWvTIVNaRr9P2MlXvNyDDjKEEJSDmV4tMXew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i2x3bnrv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E532606A325;
	Tue, 10 Nov 2026 00:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i2x3bnrv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9441F008A6;
	Tue, 10 Nov 2026 00:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271771;
	bh=8b5CTKpJJLir1t2aGKPfr8Jig2ZE3lMjas2xdCQR+y4=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=i2x3bnrv35XOH6vrFJdu1BQZY2wKIZR/rR/2tbiZNQEHQCTgoLQ48zoJ1uOoAVAxz
	 ZH2xeUES8COPvFPOtbwP/PxP3sSV/nmHXJzYSkijpiZJt7Ic1mThtOZEvVYH+9+IQE
	 kErBaHNJLmvYbkMHqqwEbo68NQPbHWd1M+MFKmpdfM2FjfFTgGeqcsbMce4V6Q6cg+
	 R7Xvjb44T5Tff6rvkh5OrCX+cct0IrGxH1yc98wYuJi9GN6wE0SgEOBhvSl3MgIJeg
	 BP4dzWIUwTzcDc4zzFxCZuAoB2+1H2bjgq+JDcXTo1FUgUjP8pf+rHs/z4rPx7fqHm
	 40w2NeGVfoczw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end" has been added to the 6.1-stable tree
Date: Mon,  9 Nov 2026 19:49:29 -0500
Message-ID: <20261110004929.3538772-1-sashal@kernel.org>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-a-pnfs-layoutcommit-extent-before-computin.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 06544fe0c997eb9b53f8fc5c180cb03432fc5a4a
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
index d74133c3d784d..8ee7ca4201f0e 100644
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
