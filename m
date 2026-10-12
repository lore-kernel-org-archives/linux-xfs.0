Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E530B49B210;
	Mon, 12 Oct 2026 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818562; cv=none; b=oJgzIsHAHmOuwOeqiXFh+TEE3xYF8tPSL5vOhGT8rQHMfwET/YBzCjPl8ntbKEWG27GdJKkRSlkTa150owPJ6ao/O6s2yumDx1p5oeXHNe4IRy+b/U0uFq4sNxaiQC5+jKAr62Jb8CrULF+SvZw/Z+RoaFi0tZfJj1cU/B9uVjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818562; c=relaxed/simple;
	bh=5OC1dJe2GYX6GKWyaVRUzH+16TmfSjplp3qTr8G+S7Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ld7iLm0w1VtdoBc8VxIB9n361Ojng4Sjmh1xaqEWjMLrwdkgRF3WtQyjKZaior1MXxLjE/P6eaAgCXZyVVOmmhPmjp6DYuRBGWsGD5A7D8TrThq1hazZtOZh4DbZkt3MvB68QwiuDAlHiWT4eCbMkT2rrt87AFQZNZQYyeaQmt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXFwL0Mr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXFwL0Mr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 790361F0089B;
	Mon, 12 Oct 2026 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818561;
	bh=MCPmvV+vbsF5Vn4fJ5rrX0NzTLLW1ca2UJ0nSAWiBw8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ZXFwL0Mrkpof+W1gW0qhGQFSfap+fhYYu0RYTjq5ZL6xxMKF2cCH7Bj4zVmHo89wg
	 0NaMnmBjrg6Hrpy9UzK1Zi4VbIvXB6M0RUCQeMSBgQ9Mwa4dVswPyz4tFWQZboDzl5
	 1aIeKSclPnL+e5GWh/+SOJ6XE9wLsE1aFcoegktVto7BWw4Fiof3+qZirtaA5VpiZz
	 FrCKPnj1ItkWCt4JgX/775cyZtb8h+EN/nZIPGU89LIX38kX3CXegqll7RNDFpurA4
	 SuS/j5kU1QwgQ/EuP+NvNvB7Y1izUMuqExlvZ2919GBphWkmSuFnuBRgvCr1C7sTAi
	 o7zOXolFFF0oA==
Date: Mon, 12 Oct 2026 08:22:41 -0700
Subject: [PATCH 09/13] xfs: reject absurdly large xattr value lengths in
 xchk_xattr_actor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179181839441.1417179.12077429416160234960.stgit@frogsfrogsfrogs>
In-Reply-To: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
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

