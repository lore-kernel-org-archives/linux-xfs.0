Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72767BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQsQNKxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07728C433C8;
	Sun, 31 Dec 2023 21:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057619;
	bh=YBnL93N1sDtUjjwf2KxM+bGeZhbLzyufyZ+rKEkfWxo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uQsQNKxUWzEIuNCJzjrh+tJd0PtMO4xUI/8TeIghfQagbEuZgUoUsGtZ9Q/gfOcmg
	 jexvacHnyzAeo4GOs0jjDlPIO2xuuV7xDCvjdxEZycOIcxb12ytylI2M4caCEvhXT7
	 Ze/DDUeAB0gYBVgfeaEZLHxbht40GwDFIGBYSCSOPnK5j3t3Ss6t6X45VNzNtSlYBY
	 nwUSV+w26oUjTnABjaY6yvkJVHMJxoBDofB6reAid2JSXEYc9Fo31mtFPLuZMLuFve
	 toT0EX7ZlcDepqfH9x1PSpyA57pSiOSADwLBT8tc5wgkkl2ImvL5iKaXufN4Ygncv2
	 uCwV52ojF2j0A==
Date: Sun, 31 Dec 2023 13:20:18 -0800
Subject: [PATCH 18/24] xfs: encode the rtsummary in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846529.1763124.15100521804833298198.stgit@frogsfrogsfrogs>
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

Currently, the ondisk realtime summary file counters are accessed in
units of 32-bit words.  There's no endian translation of the contents of
this file, which means that the Bad Things Happen(tm) if you go from
(say) x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.  Encode the summary
information in big endian format, like most of the rest of the
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h   |    4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.h |    7 +++++++
 fs/xfs/scrub/rtsummary.c     |    5 +++++
 3 files changed, 15 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index f2c70e1027ed7..59ba13db53e7a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index e8558db14b9b7..0bb63f77ede82 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index df9aa29cb94c6..5107873775b7f 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -142,6 +142,11 @@ xchk_rtsum_inc(
 	struct xfs_mount	*mp,
 	union xfs_suminfo_raw	*v)
 {
+	if (xfs_has_rtgroups(mp)) {
+		be32_add_cpu(&v->rtg, 1);
+		return be32_to_cpu(v->rtg);
+	}
+
 	v->old += 1;
 	return v->old;
 }

