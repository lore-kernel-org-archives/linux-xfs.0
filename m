Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE44A1C3BEE
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 23:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738626084; cv=none; b=UIoDrlOCFQREZinaAHAVMhoG1EfU3/n+5JQX692mrVLApe+BSz0IL4Blz2j+0DRcXJf6IELjJjUWUti5Qq70qy96TjwXgzZlzxC4FhN0CAaeshirAOQukER52Y94bSn9Z81QPhvrd7TKaeGdpE6QhVj8V7L+NSwpKnKjimH727U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738626084; c=relaxed/simple;
	bh=B15fdMiJFovihKCIsXgqLuKOXES1AY/U0rjBAsXSEHc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Y9/B5+h8GsnRwsOAVorlhjeeakfFn06mgXX428NhWlXdRHubL0H1wsdY5a836q4ZFBNo51ruiFMlfwDSJ3eVAqJ/rJn1/+kEyYL0sjoyOdwAdsH6ahJb8FfpBnRBMWaDqsYCPOyhaDvpfmF69hIPBy7//VBx5EbCYj9WFhx6apI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDBoujMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDBoujMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602A9C4CEE0;
	Mon,  3 Feb 2025 23:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738626083;
	bh=B15fdMiJFovihKCIsXgqLuKOXES1AY/U0rjBAsXSEHc=;
	h=Date:From:To:Subject:From;
	b=dDBoujMO9LizJrP6TA5r/EUZv7MXIUpgWPFzYRrP7QGrHxicGPC7CaRu9PcEoStrh
	 Ei3N/ijtCHZDMozYIJ6Y8R5XGjgW4os3mJIWVo62iTkhddwfaWZgNwEWvEuuT+Db0/
	 CYNvzcEN1vn8yJuOuBTvNaHr4FIfw71/1ma9jPnYXoTamzrpGsd2OFFvViM5HCqn3s
	 9McahzNJjdz5fveKYYgP9CQJdDEoUl6WH0c16AggrEJHH7x/VgPkvDKhfNM+SRGk5S
	 mOD5MVAH+oQ13/81HgjfvWksWnSLtln3vdqS9nCyXPtPtEdTGa2b1rMUkEFSkHduV8
	 Vzlx0Bz2ZkmiA==
Date: Mon, 3 Feb 2025 15:41:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>, grub-devel@gnu.org
Subject: [PATCH] fs/xfs: add new superblock features added in Linux 6.12/6.13
Message-ID: <20250203234122.GH134507@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

The Linux port of XFS added a few new features in 2024.  The existing
grub driver doesn't attempt to read or write any of the new metadata, so
all three can be added to the incompat allowlist.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 grub-core/fs/xfs.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/grub-core/fs/xfs.c b/grub-core/fs/xfs.c
index 8e02ab4a301424..5d809a770a1576 100644
--- a/grub-core/fs/xfs.c
+++ b/grub-core/fs/xfs.c
@@ -89,6 +89,9 @@ GRUB_MOD_LICENSE ("GPLv3+");
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME    (1 << 3)        /* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)       /* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64 (1 << 5)           /* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_EXCHRANGE  (1 << 6)        /* exchangerange supported */
+#define XFS_SB_FEAT_INCOMPAT_PARENT     (1 << 7)        /* parent pointers */
+#define XFS_SB_FEAT_INCOMPAT_METADIR    (1 << 8)        /* metadata dir tree */
 
 /*
  * Directory entries with ftype are explicitly handled by GRUB code.
@@ -98,6 +101,15 @@ GRUB_MOD_LICENSE ("GPLv3+");
  *
  * We do not currently verify metadata UUID, so it is safe to read filesystems
  * with the XFS_SB_FEAT_INCOMPAT_META_UUID feature.
+ *
+ * We do not currently replay the log, so it is safe to read filesystems
+ * with the XFS_SB_FEAT_INCOMPAT_EXCHRANGE feature.
+ *
+ * We do not currently read directory parent pointers, so it is safe to read
+ * filesystems with the XFS_SB_FEAT_INCOMPAT_EXCHRANGE feature.
+ *
+ * We do not currently look at realtime or quota metadata, so it is safe to
+ * read filesystems with the XFS_SB_FEAT_INCOMPAT_METADIR feature.
  */
 #define XFS_SB_FEAT_INCOMPAT_SUPPORTED \
 	(XFS_SB_FEAT_INCOMPAT_FTYPE | \
@@ -105,7 +117,10 @@ GRUB_MOD_LICENSE ("GPLv3+");
 	 XFS_SB_FEAT_INCOMPAT_META_UUID | \
 	 XFS_SB_FEAT_INCOMPAT_BIGTIME | \
 	 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
-	 XFS_SB_FEAT_INCOMPAT_NREXT64)
+	 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
+	 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
+	 XFS_SB_FEAT_INCOMPAT_PARENT | \
+	 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 struct grub_xfs_sblock
 {
