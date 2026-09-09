Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6712DC783;
	Wed,  9 Sep 2026 06:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933892; cv=none; b=QtQPkQgAkiWeQxuktXAjNSL43OdCwFtI3NmlvNIWgJnujNDJB5JoQ5SSI1WjLlwdH3l3lsmyIy3cNPv05cjP4qEkpYZIjZM64uOvqWcJxgA6HafZxSUKV7Q5hDyo9RqcXc/WzOFKryTwQO7Q3siP1960YDnM3UWb+0ylD6TTAmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933892; c=relaxed/simple;
	bh=h/npL1zs6tdpfDmFiY45hn+oHqAr/YyHQpax9mIA1v4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VnmlOqQQX8sHSLAfvtUrWOn1BjBLYUCZVe6oA/qivS4nSqatYT0R+dZTk7L7CXWJ3KbCWoOjrXwGFxASWq7bf3x3zD+ct6QK8I5pmXagUPFIDTqBA+Ty4Ui7/oxZCdAT9Vgywi1db7GkDsQarVz60KkLAjgn5PbvbPZbflPjvIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IfD11hOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IfD11hOj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E83511F00A3A;
	Wed,  9 Sep 2026 06:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933891;
	bh=HYg7XtWmTks39RErr0fxPRy/O/PGtZI6SQQPXSe0Vuk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=IfD11hOjttJl0UHaAbOD+DUC6lfLWneSvasPAaZ4n1xrb8VGoDlEmVBbTN7brtNFc
	 ky13lNVILCXhXq2WVbfuwjRc8WINyTwY377WWYVEqVlDhDqYkACyAiCqxbkeDvqB/o
	 UNgXxbHJDTxbsxleNKAjmBZ/O3o4oWIBZ9v7FXAPDy4FQOkcipgo3GO6DWdHkX+86L
	 mufmu/a5t4adhV7wMW0pVr81K0gn/kTlUKuRSyi/vkPrcdU7es0rWZp78SUAjgbuJ9
	 RezRuePAes7RHy2W4vXTc+Z2sc9iuFHyyF2+TIDD0gjzHspmj5c5kFC5CR4t2cZbpt
	 tAn6xLCQvJrMQ==
Date: Tue, 08 Sep 2026 23:04:50 -0700
Subject: [PATCH 2/7] xfs: actually check internal-rtdev fields in the
 superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178892936663.4057962.1670503099807440927.stgit@frogsfrogsfrogs>
In-Reply-To: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that the superblock scrubber doesn't check the new
fields that were added for internal realtime volumes when we added zoned
device support.

Cc: <stable@vger.kernel.org> # v6.15
Fixes: 2167eaabe2fadd ("xfs: define the zoned on-disk format")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/agheader.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 1fa66aa68e169f..fa5d32ec020aec 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -418,6 +418,13 @@ xchk_superblock(
 			xchk_block_set_corrupt(sc, bp);
 	}
 
+	if (xfs_has_zoned(mp)) {
+		if (sb->sb_rtstart != cpu_to_be64(mp->m_sb.sb_rtstart))
+			xchk_block_set_corrupt(sc, bp);
+		if (sb->sb_rtreserved != cpu_to_be64(mp->m_sb.sb_rtreserved))
+			xchk_block_set_corrupt(sc, bp);
+	}
+
 	/* Everything else must be zero. */
 	sblen = xchk_superblock_ondisk_size(mp);
 	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))

