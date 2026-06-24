Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6030C3242AC
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324888; cv=none; b=T6vyBHaJNhW9z+EMHbZZJFngh1nN8wY/NN4ln56xcmWbKULCoex14sOjLN4PmJsm9kzQ43uzW2kSsSen3menRO1R/FNwfWjHdKaaTEOsgmZItTnAfzz0wV5U8IaD/TCOtDNupfaUX0h4GcASGkR9QVWTCPhKwm6Z7fdJ9+LPtZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324888; c=relaxed/simple;
	bh=Gc7+YUjfjO161zkdkByved1SaLLRGpzKcU1QiYVwvpE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pQaHSFawFDndE1F4Phuq+is5oSerjp5T+gAKyjKipvRX4BVLtXgnAbFjYkstbkKuk8bTDLrKdQlKpfDrjyDiA/mWKji4MYDQJeMIK/26jN6jyFcNuGFUou2/RiO26AqIIMn7o8EGEnWw7faSMuBq1lExLCptPrlwLMKPOKW+pYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZhjMs7t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZhjMs7t"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0726D1F000E9;
	Wed, 24 Jun 2026 18:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324887;
	bh=G5sSaQrSBiyF7JYQcvMN7MWaL8KcXsHeSeXKvSh2gac=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=XZhjMs7trAGmydj4foG8O32E8Kyq/l/InkMDeNRGEqIWsdgnFbZcJRHHxQeWjXKyM
	 osyrjtzO5i9So4esb3mXFt+6he6mXRV96Vse2W+2psJSElmVBlMOPNjdo6rmEiu8fr
	 7ZTxcXubDJtmLWvpe1vUJ+y8e791ZKrnR37B9J139eE/k7N0go28Egso5MGq4S0zUE
	 /ACYnbD1qFhOelSO4AVpNUoHsCJAvp08dlVkZ4+J9ZD6xwfa8ivqaZ0tkDD9iR1Oyf
	 f19dI+SYw8UHgvZdw5HYVmIAKiq2vInt9EzB4qGmPaB+thrlel7OAgQ8k6g1zr9Gk3
	 YUDEoqKwKzAbg==
Date: Wed, 24 Jun 2026 11:14:46 -0700
Subject: [PATCH 01/11] xfs_scrub: handle missing media verify ioctl failure
 return codes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178232484456.915780.2285571166999058813.stgit@frogsfrogsfrogs>
In-Reply-To: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Back when we reworked the read-verify code to use the kernel ioctl to
perform media scans, we forgot to teach read_verify_one callers to
handle the new error codes.  Codex noticed this discrepancy, so let's
fix that.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: 02760878dd86b9 ("xfs_scrub: use the verify media ioctl during phase 6 if possible")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/read_verify.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 01e96f5bef40f6..efdf6d544858b8 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -383,7 +383,13 @@ read_verify(
 			read_error = errno;
 
 			/* Runtime error, bail out... */
-			if (read_error != EIO && read_error != EILSEQ) {
+			switch (read_error) {
+			case EIO:
+			case EILSEQ:
+			case EREMOTEIO:
+			case ENODATA:
+				break;
+			default:
 				rvp->runtime_error = read_error;
 				return;
 			}

