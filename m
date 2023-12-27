Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E731362
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xc0RAyue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C43C433C7;
	Mon,  1 Jan 2024 00:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069489;
	bh=Bt57fd7ZfCOo59EYeSLCkPUULYA1YDFg5I96GhEifSw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xc0RAyuer36lJxPIZGv1XgPo3DSfvMbTJ9CPr0K9tlnVmdNHQEVycqF4uzVqo7nyV
	 rT7ucKpvXEm23BEm3Q/cuEZGIW4Z39mMFq67oGEbkwiz7rmQk6bis/xpoLoXsgZ9Gl
	 nmjwM7VNdn5NAqCECtH2XclASfmi88yHCxgg8nKgt8SozPx5+MiNXPrnQ2zG7fOaGi
	 wubZ6tb49cQlkRwWsXy9mdN4ccMeOEs+GXgf3S8YMTgPl7NhfOBQhfZuCkdn9XY2X/
	 mrz1XbYf+RadlGqERcuMJfNdvcYxdtuuib3n3nlpKqt70egtJYRWjO4/HzmKhd+LRH
	 1bLVlr7Kuhbhw==
Date: Sun, 31 Dec 2023 16:38:09 +9900
Subject: [PATCH 1/1] xfs_quota: report warning limits for realtime space
 quotas
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405018395.1818295.3275890397059640519.stgit@frogsfrogsfrogs>
In-Reply-To: <170405018382.1818295.12964444180016025240.stgit@frogsfrogsfrogs>
References: <170405018382.1818295.12964444180016025240.stgit@frogsfrogsfrogs>
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
index 573441db986..045af9b67fd 100644
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
index 260ef51db18..43fb700f9a7 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -244,6 +244,7 @@ state_quotafile_stat(
 	state_warnlimit(fp, XFS_INODE_QUOTA, sv->qs_iwarnlimit);
 
 	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv->qs_rtbtimelimit);
+	state_warnlimit(fp, XFS_RTBLOCK_QUOTA, sv->qs_rtbwarnlimit);
 }
 
 static void

