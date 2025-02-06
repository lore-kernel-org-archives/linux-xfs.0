Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF8C23C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881746; cv=none; b=gTb3fJvFVqtNBCsjeN6KKdadFCxzQ7R1o6Kgtc+jrJVMewJ3gBU2HPkT//UCo526P6ODW3CQ4v7W0lTpInhrACQIHIIKmhPn/RphCn9mxD+IFkD6jYP5NfPQ3Zl00adDKyxSZr72tGzUpTUYqXiNMXGX1e5BfnTOySaOHdtrhL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881746; c=relaxed/simple;
	bh=YFadxdFVkrYZVDHHFMZD6ncDzBFpW4lZPS3fcQaKvdI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hIhRCNmuLLA/Au0emXk/KJV+Kn/AvNPHre4j/4sr3kFF7cK9FffleGEEcDd3HpuYA+7lc6809bx56y/bCkyqBmFcWqJc0+vyoPR5DPZgI4+3jTdzhFH0/r3Nmv8b0XV/5/FmDi7hjv0LPR/nk1MBGU6j3YlRWHmSxFa/V5gjx2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gg7UEXjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gg7UEXjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47652C4CEDD;
	Thu,  6 Feb 2025 22:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881746;
	bh=YFadxdFVkrYZVDHHFMZD6ncDzBFpW4lZPS3fcQaKvdI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Gg7UEXjLPZNlmPMoAd3iPwVHvNnLUnM80ltk+joiSbcBmPPw6hmlvYUXo2p5op46n
	 eY9c+bYD1TXH++74D7detEp6s85+Y30sam5Hb+ofIKjWG1IM+AqeK4QDLPRJb0br/p
	 DuKvPJ1pOO+7PLS9GjsQVcaad3x+N8BLQ9QHvWAqphjQEUj1tYjWY5tb9geKv3YAmq
	 mzFDMP9gQt5fPzESh4A4Twc9Zps3LUdBMTZdueMYEdaBnHhI8v4z5Z/v9BGfHP5tlh
	 6rXb7SQlplorIH3k4pqEwZzLlEmL+7q1e+7Ek6m7EwiKI8Bm33GeT2vSGRh2ZqoYOf
	 AocuO63vXhBUA==
Date: Thu, 06 Feb 2025 14:42:25 -0800
Subject: [PATCH 28/56] xfs: online repair of realtime bitmaps for a realtime
 group
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087220.2739176.7779632985618933086.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 8defee8dff2b202702cdf33f6d8577adf9ad3e82

For a given rt group, regenerate the bitmap contents from the group's
realtime rmap btree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtbitmap.h |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 16563a44bd138a..22e5d9cd95f47c 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -135,6 +135,15 @@ xfs_rtb_to_rtx(
 	return div_u64(rtbno, mp->m_sb.sb_rextsize);
 }
 
+/* Return the offset of a rtgroup block number within an rt extent. */
+static inline xfs_extlen_t
+xfs_rgbno_to_rtxoff(
+	struct xfs_mount	*mp,
+	xfs_rgblock_t		rgbno)
+{
+	return rgbno % mp->m_sb.sb_rextsize;
+}
+
 /* Return the offset of an rt block number within an rt extent. */
 static inline xfs_extlen_t
 xfs_rtb_to_rtxoff(

