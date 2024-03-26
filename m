Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DB686AC1
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423892; cv=none; b=CpHGWNz+CzD9Zs6YBI+FAvNtbzOZDvxwV3GMLaabHMM9K4EB479aZ6gj6b3E2Hzf2y7EPfN95oAfJgo9feuG2LFl3tSzMpX8PdUkZT5aQj9EIBu6fpfc9EEsekmfikizreY2mJPZb+BH4oXmktzTPWlb8q/r8D9gK1mdHoQBfws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423892; c=relaxed/simple;
	bh=yw4WZIki1NS1y7K7AmxfqeuPjNXGCICOhbOZEIpzNaU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CRTkshnq+9W7rIfMLxG7/j/ffJHfurEhbT1PdAbzKkiMB4BsAjuGbaB/I2mLxP/Tq2NfBIjc+nrzdv4W8ZJs7lzlmd6Crtm5RhPkWreUXGdTFERFSzlll/MIpFtMaE5rmPKs2OJ4XbIcmBl5ldwVx7ef7WEv0zORUoVc/1qLuVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DH0R83fo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DH0R83fo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A392FC433C7;
	Tue, 26 Mar 2024 03:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423892;
	bh=yw4WZIki1NS1y7K7AmxfqeuPjNXGCICOhbOZEIpzNaU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DH0R83foAdM/YYcuwm7F7+C8qQVtTLJCfSAr1zGJW2XEpuIk4f3M4br/ZNsl4lvwH
	 834/4oLVO62JZVH8NTYQtZ3PcZcyi+1IDR/uemKBmQDtEG3avYREIoRwauH/RkNTN7
	 LZpuYCH1/M68RNYBj/u9TaC9Ich7ZHxF/zquY/sxqAhtGFb/fTu9QhM0fRxUthrNYx
	 Y0fsZ+oelfUdNhxllUwgfKJMeRHADBCQQ5O2ilSCCnKhvcRWYTDsbWWx12SNPA248d
	 1Aox0/7YgfWVxlHkI+WA1t1H4nVBmC3itVdQCjj5ELnGC1ykQNE6fdxJJosrZ+Ip8w
	 o2v+FUCcDNzrw==
Date: Mon, 25 Mar 2024 20:31:32 -0700
Subject: [PATCH 012/110] xfs: report the health of quota counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131558.2215168.8960477551066115725.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3d8f1426977f1bf10f867bcd26df6518ae6c2b2c

Report the health of quota counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_health.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 6360073865db..711e0fc7efab 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -195,6 +195,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
+#define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 6296993ff8f3..5626e53b3f0f 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -41,6 +41,7 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_UQUOTA	(1 << 1)  /* user quota */
 #define XFS_SICK_FS_GQUOTA	(1 << 2)  /* group quota */
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
+#define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -77,7 +78,8 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
 				 XFS_SICK_FS_UQUOTA | \
 				 XFS_SICK_FS_GQUOTA | \
-				 XFS_SICK_FS_PQUOTA)
+				 XFS_SICK_FS_PQUOTA | \
+				 XFS_SICK_FS_QUOTACHECK)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)

