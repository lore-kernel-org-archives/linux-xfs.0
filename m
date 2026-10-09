Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CCE35E94E;
	Fri,  9 Oct 2026 06:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526632; cv=none; b=AyGhhe0x6E5znXh8r+SHbgMpZyaP/3J7iyjyPVNEa1rrNHedMftpOv+lmIvxDnEbjsPRarfpEpfFCLkaskH5EFaOkNvFMbv6PmAug8waMiVSI6F+1v8jaPX9F2g3NGisYmPDpcmrNnCmVRx3Tl38q+k45r2VBYhlFB4YY1DSy+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526632; c=relaxed/simple;
	bh=5OC1dJe2GYX6GKWyaVRUzH+16TmfSjplp3qTr8G+S7Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WjN+pjIkcSPhlBpz0L4dv/VsgCfV1RM+ttNRrxabT3++6O/JlAm7J+f55R+nuAm8osJnYtmJYgWXuThU2Xcv47uo66pdTI2mtAXRliFIZ+ve1USrrgE/fqUot3/4FYR+jd3MUeK+OL1py3DCh4Txfg3lCERWBagOLml2aeMe+rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9KTiE0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9KTiE0J"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CF80B1F000FF;
	Fri,  9 Oct 2026 06:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526630;
	bh=MCPmvV+vbsF5Vn4fJ5rrX0NzTLLW1ca2UJ0nSAWiBw8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=A9KTiE0J5niYOZYrErlVtlTsPoYw7tucG5dvqkiLYXOq0MChHUubEgLeqCNQkgKtv
	 1SNOMhxjW7PrMuMWaPLWhCiN68PSJteZivxa2DedLIrny+qd7dXVuI6/1AnM1P9j4i
	 3gGYuWpcnOf6LnQlDl9/DNq9+sXmAKIc8nx4tT5dbtE9v5t7yQ3nzxs/BXwdaYT1TH
	 9cluJrfQjmHdIa6feje9DvrzVne98lEIw/c0LpzdNesXhy/jh8q2HE0L4NwdNI2br0
	 wm7B2r6Ga9/UcLUDZoSydP60O80GRVAlehHRviJnMFpCkZN7gqXirRZ6Tr8F2Afy2Z
	 Ufv6IvI0xRaJA==
Date: Thu, 08 Oct 2026 23:17:10 -0700
Subject: [PATCH 09/13] xfs: reject absurdly large xattr value lengths in
 xchk_xattr_actor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179151614815.3163896.10932511456491813899.stgit@frogsfrogsfrogs>
In-Reply-To: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM suggests that we shouldn't try to allocate absurdly large buffers
for xattr value checks because that will push reclaim very hard, never
succeed, and is pointless because nobody can create xattrs that large.
Since the xattr repair code ignores values larger than XATTR_SIZE_MAX,
we can flag the corruption and return early.

Cc: <stable@vger.kernel.org> # v5.3
Fixes: 6d6ccedd76823c ("xfs: only allocate memory for scrubbing attributes when we need it")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c          |    6 ++++++
 fs/xfs/scrub/parent_repair.c |    4 ++++
 2 files changed, 10 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 7600c711362583..842d65834afbc9 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -216,6 +216,12 @@ xchk_xattr_actor(
 		return -ECANCELED;
 	}
 
+	/* Don't even try to handle a bizarrely large xattr. */
+	if (valuelen > XATTR_SIZE_MAX) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+		return -ECANCELED;
+	}
+
 	/*
 	 * Try to allocate enough memory to extract the attr value.  If that
 	 * doesn't work, return -EDEADLOCK as a signal to try again with a
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index f643724910f954..6a3c0a190ff995 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -910,6 +910,10 @@ xrep_parent_fetch_xattr_remote(
 	};
 	int			error;
 
+	/* Don't even try to handle a bizarrely large xattr. */
+	if (valuelen > XATTR_SIZE_MAX)
+		return -EFSCORRUPTED;
+
 	/*
 	 * If we need a larger value buffer, try to allocate one.  If that
 	 * fails, return with -EDEADLOCK to try harder.

