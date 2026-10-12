Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1CE318ED7;
	Mon, 12 Oct 2026 05:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784655; cv=none; b=rq/fziWQRlxMQJDBnOeAbfXWF5SWmI9wZLoela+FjoAkAVTEBWBpqLed8Ky+slNDbXzUYN+LliMA5iyux1igNV8JOTcbHTqUi5I0hPWkzXNmJ40ueKDEg95jG6MnV5tFPpk0DVvlpzXaYzzLFDqQRQ0yLbRGFPhSSWll6YJERoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784655; c=relaxed/simple;
	bh=30d2a25X2geGaRu+Hc3wbK/Wfc011049E5p3sju4mvs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IcbhfRLCq2Jg1nJTtLbIZ+3nlt8enrzEvPO2KrStQXa9EUZbZ+tSo8eLJ41bbq5P8neGef5NawQ/TWndLbu4huG8OTIc/Yq43UdtLKtfKwzmz2t3SDUKvuQxBVneBxYzJHMX4TrvJn70AmgEXgio5L+QJAcrHyeRntCAI/X0DfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EwsuLw29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EwsuLw29"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 04C021F0089B;
	Mon, 12 Oct 2026 05:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784654;
	bh=dA0kJj/hwWHIP/0juof3x48a3PolHeiIZ2Xmy/1Um/0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=EwsuLw29bJ3jL5rUFYJorhLAx/UpE1Qg8R/ekRqP/rlDozNrbKj/2TXKCOOTRcMZX
	 Ouq2ISkJ0KNSYv5T0Kp9s94CZq19qhQi+6s4xmxNf7hxT54EBPHJ5GjTdUxTKKzkp+
	 QXXWOnxQI2P2Gxe6ku5yJzjITUpQAVzFP2wOGAboRh1VxHY0GOD9avpBCr0tU51QOm
	 rCzo6qV3ItIcxoxcjPSWnvh7W3BrO49uFAUxkZavdvufqCHH0XEnBRE17/3eD+1/xN
	 7iFh9s7xv5960s8I1R99moKc1V6kRwE/wH5HMDuNVxIm4DQwmRBxCJUXdsG9WqZ0Li
	 1nyXNNbJosauQ==
Date: Sun, 11 Oct 2026 22:57:33 -0700
Subject: [PATCH 07/12] xfs: check for fragments when full-extent sharing
 matches
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065345.1058326.15234236043122923742.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xchk_refcountbt_process_rmap_fragments returns early
if there are enough rmap records that overlap the space referenced by a
refcountbt record to match the refcount in that refcountbt record.
Unfortunately, it never checks the fragment list in this case, so it
won't find the discrepancy between the rmap and refcount btrees.

Cc: <stable@vger.kernel.org> # v4.16
Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/refcount.c   |    5 ++++-
 fs/xfs/scrub/rtrefcount.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index a900d13c9e27c0..883c273cb9883f 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -185,8 +185,11 @@ xchk_refcountbt_process_rmap_fragments(
 	xfs_nlink_t			target_nr;
 
 	target_nr = refchk->refcount - refchk->seen;
-	if (target_nr == 0)
+	if (target_nr == 0) {
+		if (!list_empty(&refchk->fragments))
+			refchk->seen = 0;
 		return;
+	}
 
 	/*
 	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 00da8e98506d63..c312096e410561 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -200,8 +200,11 @@ xchk_rtrefcountbt_process_rmap_fragments(
 	xfs_nlink_t			target_nr;
 
 	target_nr = refchk->refcount - refchk->seen;
-	if (target_nr == 0)
+	if (target_nr == 0) {
+		if (!list_empty(&refchk->fragments))
+			refchk->seen = 0;
 		return;
+	}
 
 	/*
 	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)

