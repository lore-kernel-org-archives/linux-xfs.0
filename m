Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D470129A6A
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422844; cv=none; b=PDciDxGBWtlxkUYNw0xd8R/W7NRtQ9N9k7SwLECGyp4uBU04Nzpid6sm2HXhg3ONBTVa1fYLnsbtbTGwYMYXY7R8tfbfa3vpFo48ymxgwi56bKXu31xUWQDPFV3xS9gcGeB4b8Qn++O+29M8NsPpFQ+NyaHW9IpEOF2UpvFzfzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422844; c=relaxed/simple;
	bh=tzeNUh75cn7th7JyktjAqGaGg2K+6YeJVQwBT7xjjAQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M3beGx814V5HFeTmgkuzjKzZ7Ptwa7N3lXvUlrITZFmfmSckecs8h5QC4izbplrsLr1DQJUW/bZ2jliOv3FhcLMNaHNzr5rP4xmP6sN7WdDuLhqSxS8bw3iDf8vGT1jWCXrayhSehv6/Gb9XgRkEf3dcmkxKhY2LtwaW+FEDbzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bk2xYHjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bk2xYHjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE454C433B1;
	Tue, 26 Mar 2024 03:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422843;
	bh=tzeNUh75cn7th7JyktjAqGaGg2K+6YeJVQwBT7xjjAQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Bk2xYHjGQzk4pIByQ4VgqQwTq+u9MZlt1SJrO4/BmXR7yXuQcJ6CQOBK91yIxBR/I
	 LfxO+ovb7aBiSj3TygX3B9+RijWp5UlwRxffhynJymR086wrsp7o9eSYI3bMiO0gNO
	 tqYnG637v0H8cnUuNIHU0COSMMkGyH0o7/AaxlwL70ebYAYG9n8zHGydD63C7J1ibC
	 Ng/S4bt4cjZx6jiHPBFH71ARyFvDq9iv/rWj89hiLQbwCDRE2G0iWmzRTo8UDnZIyI
	 qQHplbh/EzmwY2UOu0Ig8el6rqjIptp/5I//bqkm5oIYJiHCHGA9/fMGP07qOOGS4Z
	 x9vhDYI0cbAZQ==
Date: Mon, 25 Mar 2024 20:14:03 -0700
Subject: [PATCH 43/67] xfs: improve dquot iteration for scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127577.2212320.17366182081229580647.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_format.h |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f16974126ff9..e6ca188e2271 100644
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

