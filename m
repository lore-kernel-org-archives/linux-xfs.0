Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D454C38F932;
	Thu,  8 Oct 2026 05:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791439032; cv=none; b=lr3owwg7NMe9elbbbnEzBx/y8wOkDfPyCBN3pQsrFIrFoPzKZapZVfXXTgs/C3213gIcXHlY8beFRx+JKFpMVEIZTnlNwArNG/05VM9PcnyiPQyEd/JBUsH/cW7farA/9/tFg3lPHvsLsHdMTwdo/KehMAKpv7HFYJH+tdmW9ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791439032; c=relaxed/simple;
	bh=sYgcsJvAx8hG0/po+7OtzVMnAuV6Q1Eb/KNGGjEoihI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pqh5iAUvGldyEiWjGwv/PyBTarjg27y+VMedvlADt+AwvJTI+OYX+zt+mD41oWDjjsbdMOHts2VuNT6hRKdI1vj+ysWmR8Fc1pHoTIkyhsJ4qQMOQYBwPuRqrAcXNecUj7mDy0BcRJarhLiVL7sBNzK0V1DGvG9Mxafk8pfkjts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2qgA3VU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2qgA3VU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6E1301F000FF;
	Thu,  8 Oct 2026 05:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791439031;
	bh=cpE4kVEd0bohTYFio2MQkpxo0LTf52RdhbSbDIksrXQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=d2qgA3VUkJopDi0Ab7lLJSxAJOgZu7cCMuuzOVmSAEghYUBGMAMin9pmhdO+B1ktx
	 StcFv3YFZlrREr8A5j3yUgQZvltxGhHUX1SdZWmc6Gm5gRiub+IFLUux+LPJs/yOhM
	 xhLP+9lyeI56iyU1XxAi/op6VtsqSauzlpqrtNU8K1dWsVDfHuoCqwaa+YpKTZegnT
	 x5W1CqibmjoJrEfZmliTSaxPv3S8IJgUfSaD1M+Q14DV4tURzSYaSFsPuHq00TvMx3
	 JDfMNW88IQIZ3wHaPHiyeUjG8iOgH/ks7QYEwQIahlZGHXbovAYxoz/+cbvvG1N0su
	 JkOo4RYpUdJkg==
Date: Wed, 07 Oct 2026 22:57:11 -0700
Subject: [PATCH 09/12] xfs: reject absurdly large xattr value lengths in
 xchk_xattr_actor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521450.2728617.8405627225983917643.stgit@frogsfrogsfrogs>
In-Reply-To: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
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

