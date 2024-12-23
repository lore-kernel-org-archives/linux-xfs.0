Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B543613FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991422; cv=none; b=tFRFz10PjDdRZ01+FGEKc/kB635FQ3YlqU4Yd2LAdTaElFs3fVLxhx0tpFZOLTyb5I1O1LhfDaFQYE5tKBN2nQWez5fxmTcc4e4CWxVyrxFqi/s2QdZR1lLaUSV06pN+vmzMCcmsgqK2KGqCsBffQMLjCkTFAXGYUtyKZsBmAok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991422; c=relaxed/simple;
	bh=bcOsnCCU0+ioyTyXsyHLCHWmFsplb/AZHSKR+X6z/bs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gS17qrU0twmb97D08oquL116x/Q16m2c5ratGPpLM58BtxvyRSpseSkgRHD6Yjwdg1byCqsSDpwFRTWeGkn18LGTFiWRlWrBfUr11HI2+qfJ7GQlIOoUZdioW9tnTC4hvS41qR7Ophwx6aG9hh/Yzer3/9aAaAE1Dej0iYmagx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPCTQMq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPCTQMq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4EDC4CED3;
	Mon, 23 Dec 2024 22:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991422;
	bh=bcOsnCCU0+ioyTyXsyHLCHWmFsplb/AZHSKR+X6z/bs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZPCTQMq3ly0ggjTFMC1P7maqgkMEHaKyXbQ/bPizpeQXuNGhCXwfo80KvCEICshj9
	 un9/R7jjUqAX9IhM0fczKTj/MV+drG7LEIGWJdFBDLtBRX5F3WGbpftmjJJuzHsInC
	 AczoO6Fyio9gnrkyXku0GVheExtdLcThdal8NW9QEmvhINi0dKsyhCTutYqer3e49E
	 YzQhSLqZVs0wLR44cqXgxykqsEoE0cDeiQkBmAZAjlMzHSo8nAHJUvkqKdKL1Yw9vS
	 yTsXmv4V35Xq4yafm5LV2QvQEcW3AOGc+E9Ve2O0n0tHAmEatO0q7nCOESDqJrqJXl
	 NYEJooJwhbk5A==
Date: Mon, 23 Dec 2024 14:03:41 -0800
Subject: [PATCH 21/52] xfs: encode the rtbitmap in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942816.2295836.16721864792950619001.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: eba42c2c53c8b8905307b702c93dffef0719a896

Currently, the ondisk realtime bitmap file is accessed in units of
32-bit words.  There's no endian translation of the contents of this
file, which means that the Bad Things Happen(tm) if you go from (say)
x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h   |    4 +++-
 libxfs/xfs_rtbitmap.h |    7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 016ee4ff537440..cd9457ed5873fe 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -709,10 +709,12 @@ struct xfs_agfl {
 
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
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 2286a98ecb32bb..f9c0d241590104 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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

