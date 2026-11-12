Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445366;
	b=3YJtJKU/6ZUAPXpawEWEdbNefLCcbRWOBGMAkUGKNjDCRjLwoyOTtPKs4871kLCIulnX
	 6Waw5rkOfn+PsoOYGOCQzxWKRcmDHPS2z4Fz2IJLs/iUIxomWNL9E73vrDiai4YveZoJY
	 1jx2IjFNzOPlCStRXSJWmDGz293Gnn07lCmhtnq80U4XCuFdP6IOIBWLOTDaanN1d9AoA
	 Q0LNd/WLGHpH/OwKAilsOJy/ubO25VgMz6TziOdk4Hy7dce662qvX964nT8PmCDGKFBQp
	 3LLoCvdt/5hEy4oCaot55p2P9k++zWbQLdRZfoFMSWOzzHjnPo0c6h27vZMS6NR2OtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445366;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dTZGFQ2HjlmldnF1v/PC3F/K7fTi0SahdtfzaAaqR/A=;
	b=XlUPJfasmS+c60PxIU7WCfR+B+KOHD+Keftef7VNswGvIufQ8woCV1h3t2piEu/h+BEm
	 u1HHzVFkg4kkATvVS2Z7mQz+i9LaDzOJCEk1pE6K+icV3WsrIwC3qxowZcE2HHiJhpF65
	 EcMuZGrV14/g97bxkp7xAsgmdzhj342wuKna7Oc3Ziq5t3UzvwOTs/lWRtOHaH6qwPyQu
	 CD2bAOTblodzenwa1gWzjGK6xYODgkOX4mk0XCR2+EDBlwUl2UcIDYW/N6DrkhLMtJT+f
	 Bjt3f9xikexBA9kQhnK6sneeHNFUga3j/5Qkm7awA0g7pZ2MYYBgmM6jU1bku36vPqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="S/mIddaK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0531B60A3809;
	Thu, 12 Nov 2026 01:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S/mIddaK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3A31F00A11;
	Thu, 12 Nov 2026 01:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445365;
	bh=dTZGFQ2HjlmldnF1v/PC3F/K7fTi0SahdtfzaAaqR/A=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=S/mIddaK4fIB/qLI3euPfBfajbqI7WQl2omZ1lc/mABBOYK3qCYG2xEcTzHL81lb2
	 cvm7mTK/1y//dRMFqA+bBXYg7CdUEdrkB4lhJJI8yqXBbGZXOiUfGakfUVrLi0D8p3
	 KEJhDiZHRj29GVSOoquY6q6UlPA3Pdu63+o3RZ3rTVcbpzWXI4HKwbTdCajta5SJPx
	 usUlz8mgRd6q5a7BFybMp3QudgMhiCadpBmKQ7FuO+7O3BDBudWWxVhiq5/HWJsWhW
	 pwqbxP7n/bIMP7aZbya+3LMVEvpfwkpUv1Eqx4RIAV987zSHaJnfQepLb6uHICeI11
	 naS/KbAMfy72Q==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v8 08/15] xfs: refuse writes to files racing with realtime inode flag changes
Date: Wed, 11 Nov 2026 20:02:37 -0500
Message-ID: <20261112010229.51029-9-mason@kernel.org>
In-Reply-To: <20261112010229.51029-1-mason@kernel.org>
References: <20261112010229.51029-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Zoned writes need to reserve space before taking the iolock to avoid
deadlocks with garbage collection.  But this means that the realtime inode
flag which indicates if the file will be placed on the zoned realtime
device or the main data device can be flipped after taking the reservation
and before taking the write, or after deciding to go down the regular
write path, both of which can't work.

Re-sample the realtime flag just before the actual write, and refuse the
write if the flag changed.  Do not retry the write using the now correct
path, as switching the flag under a write is not a normal use case, and
trying to flip between the zoned and regular path is an inherent life
lock as it could be switched around again the next time this check is
performed.

Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Notes:
    v7->v8:
    - No change.
    
    v6->v7:
    - No change.

 fs/xfs/xfs_file.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d888470d092a..515ddafc6673 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -441,6 +441,19 @@ xfs_file_write_checks(
 		goto restart;
 	}
 
+	/*
+	 * Now that we are in the same IOLOCK critical section as the actual
+	 * write, check that the inode still has the realtime flag in the state
+	 * that the caller expects.  If not, some deliberately cleared it while
+	 * I/O is ongoing, so bail out.
+	 */
+	if (xfs_is_zoned_inode(XFS_I(inode)) != !!ac) {
+		xfs_warn_ratelimited(XFS_I(inode)->i_mount,
+			"RT flag modifying during write for inode 0x%llx.",
+			inode->i_ino);
+		return -EINVAL;
+	}
+
 	/*
 	 * If the offset is beyond the size of the file, we need to zero all
 	 * blocks that fall between the existing EOF and the start of this
-- 
2.55.0

