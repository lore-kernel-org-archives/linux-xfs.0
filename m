Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E978EC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YRN3p4Vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5216C433C8;
	Sun, 31 Dec 2023 23:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066704;
	bh=t3/tNwQl+QnPj66wwxnQuTvSRPURI1/XBtfZRa8sPa0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YRN3p4VcEd6IDFjJfeht3gM5kzDeykHl8qCtA4zdsKuE5Z/s3pfcd/IkOhH93a5XF
	 kTZz3JaENJP07/pEp0P0G3Fg08xN9oDd97FJLGiGxfekvc8aFzplO7o14+j8j8PegE
	 TpmuxkP/3HfvhlFuon7n0Z+ElO1ivxZmVrIhGVSqCXsSkVulp59S0kfnOfrD2P64dg
	 VuHTgCQNUpXOdj45AM1p+PajKIlC9q8qCQFOWsVN93Go5HOFziB+QT+FCLg1TZDvH2
	 4DM/XNShe5PN9uzZi8AkVEYiG7S+u2i8y0n/BZu0xdIOawW5s8r9+o3uXHZgC9yhuG
	 7b42XrpTsqpzA==
Date: Sun, 31 Dec 2023 15:51:44 -0800
Subject: [PATCH 16/52] xfs: encode the rtsummary in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012382.1811243.15471097545513154248.stgit@frogsfrogsfrogs>
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

Currently, the ondisk realtime summary file counters are accessed in
units of 32-bit words.  There's no endian translation of the contents of
this file, which means that the Bad Things Happen(tm) if you go from
(say) x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.  Encode the summary
information in big endian format, like most of the rest of the
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c            |    7 ++++++-
 libxfs/xfs_format.h   |    4 +++-
 libxfs/xfs_rtbitmap.h |    7 +++++++
 repair/rt.c           |    5 ++++-
 4 files changed, 20 insertions(+), 3 deletions(-)


diff --git a/db/check.c b/db/check.c
index 190565074b6..20de9c74d4a 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1709,6 +1709,8 @@ get_suminfo(
 	struct xfs_mount	*mp,
 	union xfs_suminfo_raw	*raw)
 {
+	if (xfs_has_rtgroups(mp))
+		return be32_to_cpu(raw->rtg);
 	return raw->old;
 }
 
@@ -3625,7 +3627,10 @@ inc_sumcount(
 {
 	union xfs_suminfo_raw	*p = info + index;
 
-	p->old++;
+	if (xfs_has_rtgroups(mp))
+		be32_add_cpu(&p->rtg, 1);
+	else
+		p->old++;
 }
 
 static void
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f2c70e1027e..59ba13db53e 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -759,10 +759,12 @@ union xfs_rtword_raw {
 
 /*
  * Realtime summary counts are accessed by the word, which is currently
- * stored in host-endian format.
+ * stored in host-endian format.  Starting with the realtime groups feature,
+ * the words are stored in be32 ondisk.
  */
 union xfs_suminfo_raw {
 	__u32		old;
+	__be32		rtg;
 };
 
 /*
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index e8558db14b9..0bb63f77ede 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -298,6 +298,8 @@ xfs_suminfo_get(
 {
 	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp))
+		return be32_to_cpu(info->rtg);
 	return info->old;
 }
 
@@ -310,6 +312,11 @@ xfs_suminfo_add(
 {
 	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp)) {
+		be32_add_cpu(&info->rtg, delta);
+		return be32_to_cpu(info->rtg);
+	}
+
 	info->old += delta;
 	return info->old;
 }
diff --git a/repair/rt.c b/repair/rt.c
index c2b2c25ff79..ded968b7d82 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -63,7 +63,10 @@ inc_sumcount(
 {
 	union xfs_suminfo_raw	*p = info + index;
 
-	p->old++;
+	if (xfs_has_rtgroups(mp))
+		be32_add_cpu(&p->rtg, 1);
+	else
+		p->old++;
 }
 
 /*

