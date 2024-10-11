Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FA3567D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608689; cv=none; b=LvSARc8lqgOQV6y9Oe30ZsJQ6M/RZnVOvmMWazcELqROABP6I1eGZ+M2vWYac7C0xUByG1RqznxZIBw2cd5SJ5av/UviGmKWmmXqGsXBhqlS22HWB7AJJrH5FDHI5Tj9+cWUv1+rbVN3GCB4slnQjSIuzG0Sk2P5ynbPPjFaTlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608689; c=relaxed/simple;
	bh=BTPWT20isBcoEyzSvhMo/o9fJYf05mILVo/UUdaC98k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F6FyKJJp+522oPp43oKH4c8vV0Vvh5QfXENVj4LpYp1KWuQ0ElIOsTpknsyhiPozX+6n1MZIjyoBZ7tjihkvrtuGAoxE5QhjLlB3lEiY3CuL3EzK6ozPWy7L///G/ShcKqsCyZeaRRZ/hIY0rgK/I6TkR9/mTiIv41BUYoQdLj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkZXL6eA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkZXL6eA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D48DC4CEC5;
	Fri, 11 Oct 2024 01:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608689;
	bh=BTPWT20isBcoEyzSvhMo/o9fJYf05mILVo/UUdaC98k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KkZXL6eARscsUAnaBr27wplE0xnw1lpAyUQOn5HYuEvzEPCtdk9sukZhULPOU6gBe
	 0oyZ6y3P0Dnu7tUrN+bUl4Zf/heA8pECudP9T73MffOrq7LDfndSVoakA7sF276EK0
	 HOVT86M1M2q8YsQX3yX/9jRlfkQiuhrTmewvKmtxgUKnzdZvn8N/nhi2Hbk7giT5wF
	 Mo8IW0B6ShN0qNUzHcHWtiCiP/YmO3ktCPqiiMYzDrqav+j6w7RyLQhbcZ7QGbWbAU
	 h42wt4e7g9Ukz7XQj/iUw/CNzFqO7Y9/bVYx6OrlkMmt15jvQNAgCJREmKd+Mqt5o9
	 giicwKgadu+Dg==
Date: Thu, 10 Oct 2024 18:04:48 -0700
Subject: [PATCH 12/36] xfs: encode the rtbitmap in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644448.4178701.301476346055610701.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

Currently, the ondisk realtime bitmap file is accessed in units of
32-bit words.  There's no endian translation of the contents of this
file, which means that the Bad Things Happen(tm) if you go from (say)
x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h   |    4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.h |    7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 3b51ba84128466..728e3cf5ad3221 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -736,10 +736,12 @@ struct xfs_agfl {
 
 /*
  * Realtime bitmap information is accessed by the word, which is currently
- * stored in host-endian format.
+ * stored in host-endian format.  Starting with the realtime groups feature,
+ * the words are stored in be32 ondisk.
  */
 union xfs_rtword_raw {
 	__u32		old;
+	__be32		rtg;
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 2286a98ecb32bb..f9c0d241590104 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -210,6 +210,8 @@ xfs_rtbitmap_getword(
 {
 	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp))
+		return be32_to_cpu(word->rtg);
 	return word->old;
 }
 
@@ -222,7 +224,10 @@ xfs_rtbitmap_setword(
 {
 	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(args, index);
 
-	word->old = value;
+	if (xfs_has_rtgroups(args->mp))
+		word->rtg = cpu_to_be32(value);
+	else
+		word->old = value;
 }
 
 /*

