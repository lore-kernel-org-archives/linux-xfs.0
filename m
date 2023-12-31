Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C58BC13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsjDA9jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DB4C433C8;
	Sun, 31 Dec 2023 22:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062781;
	bh=lRds0t1Dul6XSi/tjGZNXm4McQPdnghPTXOb5z8c5rE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LsjDA9jTArd62wVqF30j0TrxWftxHtVO2pxCtgDaNCVM0zL/5JD1nAmg8nqs/2uFF
	 yD6OOz/tU+l4uOxEWI3jITiMlekIv/FcLQVRhBYxHJ6jFlQ9rOwpqg+N2HewznuMwt
	 s1sR7hd3HtGzCilqa57bwPRz8O1tUV9q7gPh3x3+J3DnKUdqP8P4zRzJoN4m1s6VFy
	 M7Tg++IskSvlsSc307JpOyKTnFG2878k4bGjaflfpe9Q5MzV3fD9hf8t72WmAc2/RF
	 x6IXUyK+B7VS6ev8ZcrpS8ANAqPiJ8ypZJGIspvKdgfwUbj0sA5q0z4PQxvDoppHGn
	 ivH2Zqe5jRzxg==
Date: Sun, 31 Dec 2023 14:46:20 -0800
Subject: [PATCH 05/13] xfs_scrub: guard against libicu returning negative
 buffer lengths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000649.1798385.1927157068551407523.stgit@frogsfrogsfrogs>
In-Reply-To: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
References: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
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

The libicu functions u_strFromUTF8, unorm2_normalize, and
uspoof_getSkeleton return int32_t values.  Guard against negative return
values, even though the library itself never does this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 5a61d69705b..1c0597e52f7 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -189,7 +189,7 @@ name_entry_compute_checknames(
 
 	/* Convert bytestr to unistr for normalization */
 	u_strFromUTF8(NULL, 0, &unistrlen, entry->name, entry->namelen, &uerr);
-	if (uerr != U_BUFFER_OVERFLOW_ERROR)
+	if (uerr != U_BUFFER_OVERFLOW_ERROR || unistrlen < 0)
 		return false;
 	uerr = U_ZERO_ERROR;
 	unistr = calloc(unistrlen + 1, sizeof(UChar));
@@ -203,7 +203,7 @@ name_entry_compute_checknames(
 	/* Normalize the string. */
 	normstrlen = unorm2_normalize(uc->normalizer, unistr, unistrlen, NULL,
 			0, &uerr);
-	if (uerr != U_BUFFER_OVERFLOW_ERROR)
+	if (uerr != U_BUFFER_OVERFLOW_ERROR || normstrlen < 0)
 		goto out_unistr;
 	uerr = U_ZERO_ERROR;
 	normstr = calloc(normstrlen + 1, sizeof(UChar));
@@ -217,7 +217,7 @@ name_entry_compute_checknames(
 	/* Compute skeleton. */
 	skelstrlen = uspoof_getSkeleton(uc->spoof, 0, unistr, unistrlen, NULL,
 			0, &uerr);
-	if (uerr != U_BUFFER_OVERFLOW_ERROR)
+	if (uerr != U_BUFFER_OVERFLOW_ERROR || skelstrlen < 0)
 		goto out_normstr;
 	uerr = U_ZERO_ERROR;
 	skelstr = calloc(skelstrlen + 1, sizeof(UChar));

