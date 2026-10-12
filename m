Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C386C272803;
	Mon, 12 Oct 2026 05:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784764; cv=none; b=bbme69fXnj0mTMFq2mKLl9ZnIVE57T9oc0uZhcV+Inpe+RjS+3E7XD9ATjfwzP1dkoKHd9K4InVk8mIE1HEMHFcjOhajnBZhBjeaymKcy2S02Jc5GnK7on157SosxnF/p112Q1WMAHAgZnZJKjWuEcRHTt8+0yxxzqQWJ3r9tpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784764; c=relaxed/simple;
	bh=Nr11PUbilGbvBYxvImrTGTmLJUv6UySDKvNUgmVHmKg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Te/xMuN/3k+BkdSG+OTbLa4wLiUZWKvpHxNwa26zEwoX4XEQoc60KfPEXUKiZ51Hg2SFOAB1yZo/PqLnt/6W6hC5re6ZQfQn9qbnlrlfuUHdvaQsiQKbDKmeQWQtfBZIuuxYgxahu1Xl6yEqyht2ot54rtf5JfGMW5pe+eEXCtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HulubqvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HulubqvI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7220C1F0089B;
	Mon, 12 Oct 2026 05:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784763;
	bh=WbfxZcqmJm/OtMNr6myKRCplYXYn0x9GJqm+KOkWsBg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HulubqvIdAB4eUKTPRpqu9p0J4tGUvy4L6q9c/Sm/v73E7czCRV4h5KKwSIqOe1WE
	 cQIA/DI4oREgXnIvwAgQcTKfkInx2n6osaEtYpwHn7W4G0PioIi2mMBzoZlwg6hXPW
	 X44MXPQKXs8UV19cJ82L1AVjUTcnSKPGTtoBSjJM/J7/FwvOLONYwrqUGzTilSpWVs
	 tkrXwBSD6FkuigTQXkMIaMi+loecXOMURzFPn0lGIhQRsEWHFZDe9fFofZ7APbGLlu
	 fzRxe7V8rrcGSLc3//xWA0/Vsor9o5obLd+NWPYvTPNrWTEaYkpF3fWFFtDGVFOAH9
	 XAo+ncSWQ22pQ==
Date: Sun, 11 Oct 2026 22:59:23 -0700
Subject: [PATCH 02/12] xfs: don't rescan ifree and icount when frozen
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065837.1058822.17239797023919948602.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that it's pointless to rescan the AGs if we've already
frozen the filesystem because there won't be any more perturbations.
Fix this to mark the scan incomplete and exit.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: 75efa57d0bf5fc ("xfs: add online scrub for superblock counters")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/fscounters.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index eb1a095a0fa9b9..5984fe13a973b8 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -379,6 +379,11 @@ xchk_fscount_aggregate_agcounts(
 	 * to maintain ifree <= icount before giving up.
 	 */
 	if (fsc->ifree > fsc->icount) {
+		if (fsc->frozen) {
+			xchk_set_incomplete(sc);
+			return -EFSCORRUPTED;
+		}
+
 		if (tries--)
 			goto retry;
 		return -EDEADLOCK;

