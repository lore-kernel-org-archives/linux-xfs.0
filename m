Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B601118E023
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845982; cv=none; b=QycE3+5IZGVw96mIVsy1q0nTPHup1TFXd13FDse557+QKNoDDRVgI7cXOvSjC+px3VhjWAwgLu4Wc2v5H8Do6g2CIlpfDl6pxF+dOvabbEdpVlBvquVWbjAVdx16HeDeeKbKcP4pwf5YWgSgv/Wm1wDJZ82JKWPoN7DEJ7uE7JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845982; c=relaxed/simple;
	bh=1KcQYzdVtkJ9svKDfS2aqKgKHzDiW6R2lCj79SY1ZVE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DbXXfbJ201V5PVctrbMazB2ILHfrr2uql6JFz0HGWbDEc9KWJ1JV8w2pOHV5Wbr85zn26dVlxUOAXQ1HOoZseNoqSwtkMW5h88NpMYCB30zMCPnsses2vR949R2+tpwsASXagwQqnsfjzOFKx5gAI8nJtvJANhGf+D3XTBSxjvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p6US3DOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6US3DOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441ACC4CECF;
	Tue,  5 Nov 2024 22:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845982;
	bh=1KcQYzdVtkJ9svKDfS2aqKgKHzDiW6R2lCj79SY1ZVE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p6US3DOhrovKendJnMTrb1XUznX/3PgigqFuXtlOIfsqfg/PugRwsMHf0WprvOz2w
	 bpkmEvSTqtdEWO1DP9LCFXUfHSsCTvAo/ZCwX6PdGeHU/BC3E098yv1V1Cw77EDEK5
	 e2rifv8D/xA8q1cjaElu5XZKS99+2Q9pph5Wr0p+Pw/3eKbSg8gYuoEGTLwr1tNAXS
	 mb05iO2JYmmHuWjw4iAJ7JaNyX8HzaUBsQ1ZzL8oDJynsLRCMaOoPe1FQVhexYV6uA
	 r5/eEPUczo/q6DAtZq0iD3ATbKi+dOO84gIaRTdpmiwrxvQek2AY0MtG49tCA3g+FH
	 O2V+CHdSa7nXQ==
Date: Tue, 05 Nov 2024 14:33:01 -0800
Subject: [PATCH 12/34] xfs: encode the rtbitmap in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398389.1871887.8792839657391815166.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
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
index 016ee4ff537440..cd9457ed5873fe 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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

