Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6408E155322
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804013; cv=none; b=CR5aw5RaH5U6lPtAI8+1hrD7+3NsyfsT7zfxOvM5T8GcMeJFh4AhCss3E3Wm37cs6MkpkdA4296YKBUDmoG3OJpjjkqce+8GZlCbr/SSznnOGmN8qTQw1VboeSxtQgOUhadKk3RskRktc8Cbs5Sc9dFiqaUpZ+21P0ZR3j1cdqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804013; c=relaxed/simple;
	bh=EK253xF7BpSn9XIb9FTn/fvEtVKLIcQGi0SfzPLOTiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbihlNz/WsaOxXo6967b+aiGxG/KuVqLaoyBmVT/UMkDCzCZI1lXhHu5SUX/57ZhWcd+8sD0khebIh3hES38d8g+dJ3GPwNjlFCinn/3bwM3JQrAJLnyOLMVqT0oN+MhyPfedTEsjPNI6MeoZNSEP/kAduyNoKGYNQhBW14gV9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bo98XKXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bo98XKXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0562CC32782;
	Mon, 22 Apr 2024 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804013;
	bh=EK253xF7BpSn9XIb9FTn/fvEtVKLIcQGi0SfzPLOTiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bo98XKXGmLRU30xAABtKhx+oH2HhhqUCLXKaRRxwFSn5kI6W2b82XAbdp7gjRUrGy
	 Jsy+FN0WNc/RnhMD2yzABNUanZH+Ytc8WlkeJ0uFo+5rqPcWjQuDu3oIKICLpA3Uv7
	 29oueAlLzYB5FLOH/W6+4dmKeAMWK8ZNlsGg+aka2sSes/DHxdgAdGq1DK/hwe8ieS
	 9kDKnX16NaPXSV3Kd0SzSvHVVrAcCX17juBqo9u9wvXGkTTOfRsAombK0w3hBefw2s
	 HOMySlL7un8vPE91jYtdUWHbzFZWoc8ToEyiM+tBXX/L0XFMzZ0nppwle0w+5DYWL+
	 z6ys43HxuNLRA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 43/67] xfs: improve dquot iteration for scrub
Date: Mon, 22 Apr 2024 18:26:05 +0200
Message-ID: <20240422163832.858420-45-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 21d7500929c8a0b10e22a6755850c6f9a9280284

Upon a closer inspection of the quota record scrubber, I noticed that
dqiterate wasn't actually walking all possible dquots for the mapped
blocks in the quota file.  This is due to xfs_qm_dqget_next skipping all
XFS_IS_DQUOT_UNINITIALIZED dquots.

For a fsck program, we really want to look at all the dquots, even if
all counters and limits in the dquot record are zero.  Rewrite the
implementation to do this, as well as switching to an iterator paradigm
to reduce the number of indirect calls.

This enables removal of the old broken dqiterate code from xfs_dquot.c.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_format.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f16974126..e6ca188e2 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1272,6 +1272,9 @@ static inline time64_t xfs_dq_bigtime_to_unix(uint32_t ondisk_seconds)
 #define XFS_DQ_GRACE_MIN		((int64_t)0)
 #define XFS_DQ_GRACE_MAX		((int64_t)U32_MAX)
 
+/* Maximum id value for a quota record */
+#define XFS_DQ_ID_MAX			(U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on
-- 
2.44.0

