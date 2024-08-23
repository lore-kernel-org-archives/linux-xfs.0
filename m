Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899B21C680
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372658; cv=none; b=kL4iM+A6vaLHns31aYac11rv9t8x432pyct1Ghy0D3qCsJu4X5jIFME8wzt7/jNpaNgkfK6RiP+f13XO/8nP3tGfY6s06JO52F9E1g7IUA1+Q2Pgy/aqy5XvTlKVQyLFFn+MyXTPGcjJycFG2Uske+dPgTTigFe3DSf0PF6Hi/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372658; c=relaxed/simple;
	bh=G0QICNynuxKbuWXKSkcNUUhJ2oi0wkUSC9bFeA38+RA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xmhaisj+c+LwFqilquyAokDB6Bn58Cfkui4+kDB8V0PpiCDsJ+d/PesV+pBKkP0+/GqEafKbgdUL3+KlJ0+wU3BsOKEmD7OwOk71HuAHjNzQ7gGjZ2EoqVnhrFC0CpOMroMW+JpnMyRaySVYuSsu/nJWeKemOoQDuTYuSHKhteQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMxb8qya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMxb8qya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6371DC32782;
	Fri, 23 Aug 2024 00:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372658;
	bh=G0QICNynuxKbuWXKSkcNUUhJ2oi0wkUSC9bFeA38+RA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WMxb8qyaFfskdMiV0dpMCWD8/pkrA19mCPktuSe4lqJmN6KLuPlpqWeOdaoQ3fjnI
	 Z3Fi+gmSAtGmeAWM9n+MJ00JU2iWlNqNsQOTFn6FpFl2SxenJBc1nslucSIll0e8zv
	 hbwEb+9H4SacIuD7QbCTZ24Tyzl8oh60Qo0kAyyRJqEsmp5Vuytu9lVsAcWrEv0kyA
	 BS1zNKedGUjx6QM7rgGtHDFcWu3y5aEbI9Nw/2R4DQlfZHNZaA/cBSe41FXiR9kpbn
	 SQJJ2t3o5QUPbKoKF9VxGqL370AFY3ot3k3dKXsSW6W6h7m6IylT/RF417Iq9jV8cT
	 eksGx4yricung==
Date: Thu, 22 Aug 2024 17:24:17 -0700
Subject: [PATCH 12/26] xfs: encode the rtbitmap in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088729.60592.727533950842079798.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_format.h   |    4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.h |    7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 27193a2b0ea62..506f5d5ee03fe 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -715,10 +715,12 @@ struct xfs_agfl {
 
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
index 13a05dce47601..148f7631d7fc2 100644
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

