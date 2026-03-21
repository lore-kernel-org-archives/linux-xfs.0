Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5814036EA88;
	Sat, 21 Mar 2026 11:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094152; cv=none; b=kEYXQwu9clebjmmpRl0GKcmYPSOq+QaC77hjdoqcsUiX8+DzoXA4XwCetmiPUc3MRLk2fc5ciBul56QPhIggxH7Z31NQhp99o7kz4qftcyCXJtS06bpsjmDCEuu34wrU4TFlFg+g4SdyOjHNicoxEbKm0ByYIcd8mejRhQA1Mn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094152; c=relaxed/simple;
	bh=TrI53EhYNnozlNDeDanozLEZkWYq1mlcdAshLLkzPUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBFRUmi7DtsQerKytJWra+A0gb1+sSGaxOYJFV5IPh+ugZiMjHP9qrFoCcfBpgi1IQUsr49xrEgx68Jks/th1mv7CxAN21OT0GFYit/iPhvFTKmojJ689lDAhG8PKr2fgK3oZiFS54MvpJA+ArlOmJOVLzklzobfhJH+2gcfjek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GavCWCSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GavCWCSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FD5C2BC87;
	Sat, 21 Mar 2026 11:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774094151;
	bh=TrI53EhYNnozlNDeDanozLEZkWYq1mlcdAshLLkzPUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GavCWCSMln1J51mLkVqpvq+7BGTnlzOpvDsU3ideCNIsHrZgCITQmmL5Tjv/8mQfZ
	 lo5DN3Avj8cBp5qRWSIy8wunIXqkIpkj7Y+PeiymuVaJO8dGMjwHsxI97EgiDJOovq
	 BTS+CTAN3PCx8nUu2urq23Iz2jHnKXUGn9J+5Hq6EQUzh4pI5WyDMsVY8mTwpSfAft
	 kK/kD18m+I5gcztYK6j4udVxYFB9oGJt1J15C2mB6Vu3ngm9tHEEAKLr4DJjkXWLp3
	 iyI/uSt+nWZJqKKAHMIeakRhXfIqZWd0Q69lsSskFcnu7g6GO8IsGoPiymMsyYqvNW
	 pASDQm4pHlhzg==
From: Anand Jain <asj@kernel.org>
To: linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: [PATCH v2 1/3] btrfs: use on-disk uuid for s_uuid in temp_fsid mounts
Date: Sat, 21 Mar 2026 19:55:17 +0800
Message-ID: <4348b87c63bb92a2808916c6f8a38b864e84b51f.1774092915.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1774092915.git.asj@kernel.org>
References: <cover.1774092915.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mounting a cloned filesystem with a temporary fsuuid (temp_fsid),
layered modules like overlayfs require a persistent identifier.

While the internal in-memory fs_devices->fsid must remain unique, to
distinguish each instance of the mounted filesystem, let s_uuid carry
the original on-disk UUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 fs/btrfs/disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c835141ee384..90e0369bf682 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3451,7 +3451,8 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	/* Update the values for the current filesystem. */
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
-	memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
+	/* Copy on-disk uuid, even for temp_fsid mounts */
+	memcpy(&sb->s_uuid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
 
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(fs_info);
-- 
2.43.0

