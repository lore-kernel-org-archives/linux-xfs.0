Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E5FB67F
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vCnYSwfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70BFC433C7;
	Sun, 31 Dec 2023 21:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057587;
	bh=9+b3UQ29MtamCja/XSHqjFRyedG+1c11tn/lKyuLVLI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vCnYSwfKl0xK97aq5wOxqsibRk1PhvECs19oFKcCa78zNBiuI8oQnGIKYsqindd1g
	 CIGTu/On/MT5ardpJvsZAlnejkhyduu+Bd0OQwqqzIIGjtnjCLMC3XkUAVihM7olvM
	 68Q8y6K0Pxz8E4KPJavxoJ7mNi+Zv9YAZy5zbn9a+jPD51ZLu2k3yv1N3Uw5Wh7fOA
	 y8M5g3sG7858KXWxVLNnDp1bpEGH2TYnBuHNwybjYP1WjRZb9T2ZeLFjkMbpSK28TH
	 80RXOviaOrdZ64bYCPQD5e8GXuQ84z5tU6n2sOIB7wMXnM7OHt0WoxGu7H3FsA5rI0
	 1y1wrQUZVvl0g==
Date: Sun, 31 Dec 2023 13:19:47 -0800
Subject: [PATCH 16/24] xfs: encode the rtbitmap in little endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846496.1763124.7029031511754234393.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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

The natural format of a bitmap is (IMHO) little endian, because the byte
offsets of the bitmap data should always increase in step with the
information being indexed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h   |    4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.h |    7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7178bd463c1c0..77422fbd3372e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -749,10 +749,12 @@ struct xfs_agfl {
 
 /*
  * Realtime bitmap information is accessed by the word, which is currently
- * stored in host-endian format.
+ * stored in host-endian format.  Starting with the realtime groups feature,
+ * the words are stored in le32 ondisk.
  */
 union xfs_rtword_raw {
 	__u32		old;
+	__le32		rtg;
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index e1cf47d2a9281..588689e53ba39 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -208,6 +208,8 @@ xfs_rtbitmap_getword(
 {
 	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp))
+		return le32_to_cpu(word->rtg);
 	return word->old;
 }
 
@@ -220,7 +222,10 @@ xfs_rtbitmap_setword(
 {
 	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(args, index);
 
-	word->old = value;
+	if (xfs_has_rtgroups(args->mp))
+		word->rtg = cpu_to_le32(value);
+	else
+		word->old = value;
 }
 
 /*

