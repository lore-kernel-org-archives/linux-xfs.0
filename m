Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A12912BF0A
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998993; cv=none; b=tswqdjE5OA1p7rCOItUY9BiRVbyGsLGfPGjkyhmCE36bH7HUnMCh+SbHA93AP/ehegpkF3sxaeMyKo4U2yzsXP8y6pa9sscdQssd3hLCtaOs/KEb0JTvMa/IEQ85clBiRucUTLzNX7SM450/ip2l08LsuBjZOHoWaoVv3UON7Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998993; c=relaxed/simple;
	bh=IN5irApq31LsjPtg7aXGWkdUpdoADnJdoNPN4bcSQd0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZ9NpuOFFL99Er89fMNGzXYdQB85Zi5tawQlkdkIXQ7XzQa3d13wG0UCzSt2j4n8GN48Yx4NMaynCHUBHym8GBqulaqildO/58WDgup+t6y5tNzv01GEB+b+2xk2QNpL52VEb6sEdZJR2B5Y8QrM7vty4B3n1pEwF5nDwk8VFKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kY+fYMOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kY+fYMOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71822C433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998993;
	bh=IN5irApq31LsjPtg7aXGWkdUpdoADnJdoNPN4bcSQd0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kY+fYMOyoPsfd2Ql5kErQc/Aq+VLBu1QRedQXK0z/ldgtyCJ9+mFKpf9AsNuUfFJb
	 AxmuylDckBRVxUKmOIkcrVJpAsE/L0LNWmLQ3FLpYzCHZY5f/knUwEv2JtQqT5gtNf
	 J87hpaTv+X2SDzb7/DTf1j2YVlL8gZSC8ilv+BoGr0g/JIYJQMUF4o5XEbua7FUZ98
	 4k2a27e+T+/MmcGDMUeYqYX7HHuA32Rrei9pSh36xBjj6sLEz+5/2n+Xdhh2o1qwzn
	 J4A30xn3hWeJ1stRhyHoNECNin2AQ5w6mxEDxGh9YMucCvfJs0Tg2WNiChenNekBEf
	 OSxehyuZ6oX4A==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 35/35] xfs: inode recovery does not validate the recovered inode
Date: Thu, 15 Feb 2024 13:08:47 +0100
Message-ID: <20240215120907.1542854-36-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 038ca189c0d2c1570b4d922f25b524007c85cf94

Discovered when trying to track down a weird recovery corruption
issue that wasn't detected at recovery time.

The specific corruption was a zero extent count field when big
extent counts are in use, and it turns out the dinode verifier
doesn't detect that specific corruption case, either. So fix it too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_inode_buf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 74a1bd227..fd351c252 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -507,6 +507,9 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
+	if (nextents + naextents == 0 && nblocks != 0)
+		return __this_address;
+
 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
 		return __this_address;
 
-- 
2.43.0

