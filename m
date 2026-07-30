Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912F03AF676;
	Thu, 30 Jul 2026 05:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389226; cv=none; b=M4ljzn/PW1OyRivj0Sbq4lT0PIQ6JaAWPBFoqgJdOSQO7mbMItW6Xdon+ZX9uWACCNbdZuVWUJHnhM5AU68BB3IBk41lqWRS2NHAhB6I4yqgF6+wRzLle0DO1QB+C/iQVlSH+izFZRJTJUSGrDjVm8IX1E0UFiP+Hw9aSpDiGvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389226; c=relaxed/simple;
	bh=cQmSkfd1/wa5tv+bVyTGRiEn4hUBVEES2D+J35fXagY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GUEqGyzgyTSjwLQ51vu81JwoQ/n6BZ+FyFPpS+xH4oUqCE8bUko8hVbBcQEhPwHe3FZeV/hbieX6Cx9hRAxouUoBggt0CU/OHX2d2ajAqlnBZcO3+CdZHQIApazSgEEww1pakr1vK/Au+Jo0Bpp96OWJlzxZfUjiwNCi976TxoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRWfAkm2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRWfAkm2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2F89F1F000E9;
	Thu, 30 Jul 2026 05:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785389225;
	bh=SRqcWiqIeP/lv3VAZhanvrDsTSTIIqAtIwzHgoGYjbw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=LRWfAkm2cy0MzJEEviumkNFM42nFW+7NviyafTNfRQOSjBQ4PBtm3FSzFur3iABu9
	 2wLeZoWWDZZI/qbXqNzTTrMDVFjvggwwEcIbnS2N90z4PZTzfzV/3Gj6+C4gpha+XB
	 YQgJHI5QGx24m9t7fPLP112JbdYV+TfUfq0jpoY+zUaMb5F4rx5VyuXmQwEmHztZ8n
	 EdVuE1h5cIPEyRfkGUVDnK05XgPqz9RzXzUoy4cglkjUrsO3l8u7u+2pFGJ5sdq4i7
	 gca75ZUV01wi+rO1ygADOy5SMMAh/YN4ZlJ2XPaVTjABcwxHPlfa/fShEK4TQSKpJM
	 cnOEHkeovQF+Q==
Date: Wed, 29 Jul 2026 22:27:04 -0700
Subject: [PATCH 4/6] xfs: don't leak dqacct if rhashtable insertion fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178538912965.4070956.18121841188530798974.stgit@frogsfrogsfrogs>
In-Reply-To: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that xqcheck_mod_live_ino_dqtrx doesn't free the newly
allocated dqa object if rhashtable insertion fails.  Fix this leak.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: 200491875ce144 ("xfs: track quota updates during live quotacheck")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/quotacheck.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index c199d128538e55..c32030a0544065 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -263,8 +263,10 @@ xqcheck_mod_live_ino_dqtrx(
 		dqa->tx_id = p->tx_id;
 		error = rhashtable_insert_fast(&xqc->shadow_dquot_acct,
 				&dqa->hash, xqcheck_dqacct_hash_params);
-		if (error)
+		if (error) {
+			kfree(dqa);
 			goto out_abort;
+		}
 	}
 
 	/* Find the shadow dqtrx (or an empty slot) here. */

