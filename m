Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30D813FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991438; cv=none; b=BN5iku4KIg/vyotN35X7s2Y7hryR3jg9MGtXiEkdzcGyd30N7ylR2fVo0HyITb0y8YVUSHxD5hMUHvo1PSGaa3IGX+EClWkqleiPaDYSMa5gW+FmA1xrl8+muL1m+grfL0ZJKhOPTS4qP994GoEmfV3Ktx8ulFo3PIchmqWyZGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991438; c=relaxed/simple;
	bh=q4lay0O7Hk/yYYg696jBQ5QmCgtE8NeoflfGnkh161g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WMcaxZjkaJe6pw/ezIgeLy7WBnPTppn/vyVW2pGvf02lHv/pjm44Xa1qtazoG4U2pawNEHc+awwAQgmk7BRRXfDnL4yz6GAwZkMg5+Bv9ykIWnYanMt54njZUM4O4vDI4kcOojpklxQmf3Pbi1Gpqz5ZytNxtwaKorElhR8oI94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIzxzZgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIzxzZgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC64C4CED3;
	Mon, 23 Dec 2024 22:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991437;
	bh=q4lay0O7Hk/yYYg696jBQ5QmCgtE8NeoflfGnkh161g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MIzxzZgDYK4lmHKFSfoXfAj6GNjk5DXsphXC7YXDsa2BFgRRXpqGOFgDUBKcBgJ7l
	 vRgHC60gQBpoyzh70beRr2gu0c85+V123rob/xc7efNw4+EAqZ3UVxRfL+HlvwhRvu
	 kEi9ttOHU2FLmrHD8yktrw0AEHAtdjVsUg+MqNVvvINYFm0kUKrlOpvWoGyH/TfGUj
	 V444tobJlfuQCUQppXsh0enTav0/bIXYO00SnHUYB0F6ZkEcmNGit2sRjNOftzEhnE
	 Zvx5YXeFaUjIOq3FD+Q7TD7n5QwqOaWSbalIBNRrewW9EQBpLSSEbjwklzl6kJtOp7
	 2jzKTsJqVxCLQ==
Date: Mon, 23 Dec 2024 14:03:57 -0800
Subject: [PATCH 22/52] xfs: encode the rtsummary in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942832.2295836.11829474887945982016.stgit@frogsfrogsfrogs>
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

Source kernel commit: a2c28367396a85f2d9cfb22acfcedcff08dd1c3c

Currently, the ondisk realtime summary file counters are accessed in
units of 32-bit words.  There's no endian translation of the contents of
this file, which means that the Bad Things Happen(tm) if you go from
(say) x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.  Encode the summary
information in big endian format, like most of the rest of the
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h   |    4 +++-
 libxfs/xfs_rtbitmap.h |    7 +++++++
 2 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index cd9457ed5873fe..f56ff9f43c218f 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -719,10 +719,12 @@ union xfs_rtword_raw {
 
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
index f9c0d241590104..7be76490a31879 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -300,6 +300,8 @@ xfs_suminfo_get(
 {
 	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp))
+		return be32_to_cpu(info->rtg);
 	return info->old;
 }
 
@@ -312,6 +314,11 @@ xfs_suminfo_add(
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

