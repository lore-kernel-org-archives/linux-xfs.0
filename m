Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B3EEEA9
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610672; cv=none; b=nZVhJcKUQlxOpjLRgci4+K6osT5r5Jr9jbo7tsX3jWU8YA8cYj1rw9AJQtAxYvdqMTFENBZi/UdM9nvAQhVbzPYEivW3BrC2vFQq7/41v/ffq6kGcJy0Uk53rfaCbLDNq9psIMkq3J7FzatwdgoMouJJ7YjutWSQUM5q+AuKU0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610672; c=relaxed/simple;
	bh=zaiATgbS0V49u/Sk0ooUWwQLsO1DeFMOyLuoRU/hvfs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PbqCNaAtvtvRSz/tbp/LgNMlY6qIVbMIntWlMqIqt9GhUVOKeM7vft2060M1VK0Faacs5Q0qfiP6NjbFGzstYMfrUuyQ4xT72fMXft+ExKX6oGJC3aRlBm8gMRk9/eguzVBg6JYwtvPbyY55sBYeAs+obtkOwev4JZzslFY7FuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lpW7q3rP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lpW7q3rP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0333CC4CEC5;
	Fri, 11 Oct 2024 01:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610672;
	bh=zaiATgbS0V49u/Sk0ooUWwQLsO1DeFMOyLuoRU/hvfs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lpW7q3rPLDR7Pxk1K0eysqudfQxJ0C9obQhRksM00/jm829q5lSggmWf/zWVU4E0d
	 Tqq7ERtDmnxVlqDRBQXpQUUnnYS58pem2ENlEa9hktuAJK+pugnWqiQBNLzN+gJW2o
	 xckCoIiwjD1KTza3w6tGa7lzktvjxYOAI3f+o3s8Dmhn1VkLSTTxFPzA4338kZpdOM
	 ZV1fg/8rZ3dEZjZ0DnH4B0vtVUhHGr3RlNE9v4ySnAjVHaNWlFF2mF/vRY2mHzwALq
	 Qb29VIfdZGQZh9UB655zWxxFXghyr3XiG4Mer4WRzw/jXz2XxIWnfNw69Wk3DAPfGX
	 ksT1fN2/bHEcQ==
Date: Thu, 10 Oct 2024 18:37:51 -0700
Subject: [PATCH 1/2] xfs_quota: report warning limits for realtime space
 quotas
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860656833.4186363.894562006807949291.stgit@frogsfrogsfrogs>
In-Reply-To: <172860656815.4186363.7149995381387622443.stgit@frogsfrogsfrogs>
References: <172860656815.4186363.7149995381387622443.stgit@frogsfrogsfrogs>
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

Report the number of warnings that a user will get for exceeding the
soft limit of a realtime volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xqm.h |    5 ++++-
 quota/state.c |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/include/xqm.h b/include/xqm.h
index 573441db98601a..045af9b67fdf2b 100644
--- a/include/xqm.h
+++ b/include/xqm.h
@@ -184,7 +184,10 @@ struct fs_quota_statv {
 	__s32			qs_rtbtimelimit;/* limit for rt blks timer */
 	__u16			qs_bwarnlimit;	/* limit for num warnings */
 	__u16			qs_iwarnlimit;	/* limit for num warnings */
-	__u64			qs_pad2[8];	/* for future proofing */
+	__u16			qs_rtbwarnlimit;/* limit for rt blks warnings */
+	__u16			qs_pad3;
+	__u32			qs_pad4;
+	__u64			qs_pad2[7];	/* for future proofing */
 };
 
 #endif	/* __XQM_H__ */
diff --git a/quota/state.c b/quota/state.c
index 260ef51db18072..43fb700f9a7317 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -244,6 +244,7 @@ state_quotafile_stat(
 	state_warnlimit(fp, XFS_INODE_QUOTA, sv->qs_iwarnlimit);
 
 	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv->qs_rtbtimelimit);
+	state_warnlimit(fp, XFS_RTBLOCK_QUOTA, sv->qs_rtbwarnlimit);
 }
 
 static void

