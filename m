Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A55DC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+bTmdiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682F5C433C8;
	Sun, 31 Dec 2023 23:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066673;
	bh=D98Nk3kfok/NpQ7FpEBGY/RbmrrpvOvgFDbqm3DFh4w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a+bTmdiCcA8VikiNtkA/9zs3IKA461+NVboo50qVes4HjShvJplvuZaVqvOI7utIK
	 VtiHxiUij3u8HI2WENOU1bptCdtpuOoo65j0iEIgR4q+q3gNX10I5HgNt9KqizVuc6
	 wPX24M71WApW6I4oyTbYnVOh6GCWCX5UvdRfcf+5PdwZsjm1ycyHE86ttNRIN+Na66
	 05ubjuY3BUskXnPIvbDdLXsOQK7zi7O6UaPxx/leM63mdlbs9n0zJerbDH044mP4e/
	 v7O2Q/jhXsZiIGqbdZJsqygSzWsJiaTvQoLjMzEe2GHAAYlyfWRJue47PaCjevdcxx
	 dfZCcIUcIJnTw==
Date: Sun, 31 Dec 2023 15:51:13 -0800
Subject: [PATCH 14/52] xfs: encode the rtbitmap in little endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012357.1811243.2971692742413294258.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_format.h   |    4 +++-
 libxfs/xfs_rtbitmap.h |    7 ++++++-
 repair/rt.c           |    5 ++++-
 3 files changed, 13 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 7178bd463c1..77422fbd337 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index e1cf47d2a92..588689e53ba 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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
diff --git a/repair/rt.c b/repair/rt.c
index e49487829af..c2b2c25ff79 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -49,7 +49,10 @@ set_rtword(
 	union xfs_rtword_raw	*word,
 	xfs_rtword_t		value)
 {
-	word->old = value;
+	if (xfs_has_rtgroups(mp))
+		word->rtg = cpu_to_le32(value);
+	else
+		word->old = value;
 }
 
 static inline void

