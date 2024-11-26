Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70989C2C6;
	Tue, 26 Nov 2024 01:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584502; cv=none; b=FGnN8VRw6b8RTmsRcpfH4raSWEwEUgRj1Hc+ljpBWpo6FBNgbjGmvaOLyiAniMqn1HM9WbSMj/awOe2vm+wYdLRR6S3dHXyRRVc33wm1sBxWGxk1j/DG2Y05yS+QVlTWH7WCEj1P/CRH58gvTQviygt3gYps8fBN5BegKVUd1xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584502; c=relaxed/simple;
	bh=UjeDlYDq8ScPR+IUo7fNtTSfVftf2MN/U7ORrCmVgV8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PeibGH9kRGVVNIFJZOxGqkkB/3nXRtSsP8RsEsA3+6ede4PujAnj8Pz4cDQK08QuNn8uCcNsVVHJOF1pT6cvEWkNtVIxW1RPWtXMG9ePhrei7a9fldCvH6i1IuEtw3p5FYRmPA/QryNu66+glr9Xc+GoZayKAnDROffrjxUC9b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATMNzXsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATMNzXsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BE8C4CECE;
	Tue, 26 Nov 2024 01:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584502;
	bh=UjeDlYDq8ScPR+IUo7fNtTSfVftf2MN/U7ORrCmVgV8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ATMNzXsYLCkqqu1XBp5sWAwwyRl1SzXNQWIQMPah3SHrP5Q8TSyNAiXIVaA6HXPcN
	 NA1VxfBiNTJK6J4+/TSyldw19qGL5nmYYF1IVTiGRuMwoinQ3kIP7OcDrJGL3eTXhX
	 ESW0kfdkdeePUIE4jVVuKNTfLHrHwQJIxErlRC4ZJiUYtC1q0Ah1qApxxshmsLnqUT
	 sdg4SBbt7EkRYx5cNM7kzyU7NKazr0yim/G1csu6kEHppT7/8gn5s3C4FlQ01dHYLx
	 dXZRG5vnBhX7lIkQPGnZ0m2lPhQvvXdwNhAOMVoO5MIlFC+dbf6H9hpl5dkVmKqSMR
	 fwgozT8Q1SXZQ==
Date: Mon, 25 Nov 2024 17:28:21 -0800
Subject: [PATCH 14/21] xfs: only run precommits once per transaction object
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258398042.4032920.1346072051908401243.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Committing a transaction tx0 with a defer ops chain of (A, B, C)
creates a chain of transactions that looks like this:

tx0 -> txA -> txB -> txC

Prior to commit cb042117488dbf, __xfs_trans_commit would run precommits
on tx0, then call xfs_defer_finish_noroll to convert A-C to tx[A-C].
Unfortunately, after the finish_noroll loop we forgot to run precommits
on txC.  That was fixed by adding the second precommit call.

Unfortunately, none of us remembered that xfs_defer_finish_noroll
calls __xfs_trans_commit a second time to commit tx0 before finishing
work A in txA and committing that.  In other words, we run precommits
twice on tx0:

xfs_trans_commit(tx0)
    __xfs_trans_commit(tx0, false)
        xfs_trans_run_precommits(tx0)
        xfs_defer_finish_noroll(tx0)
            xfs_trans_roll(tx0)
                txA = xfs_trans_dup(tx0)
                __xfs_trans_commit(tx0, true)
                xfs_trans_run_precommits(tx0)

This currently isn't an issue because the inode item precommit is
idempotent; the iunlink item precommit deletes itself so it can't be
called again; and the buffer/dquot item precommits only check the incore
objects for corruption.  However, it doesn't make sense to run
precommits twice.

Fix this situation by only running precommits after finish_noroll.

Cc: <stable@vger.kernel.org> # v6.4
Fixes: cb042117488dbf ("xfs: defered work could create precommits")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 05b18e30368e4b..4a517250efc911 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -860,13 +860,6 @@ __xfs_trans_commit(
 
 	trace_xfs_trans_commit(tp, _RET_IP_);
 
-	error = xfs_trans_run_precommits(tp);
-	if (error) {
-		if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
-			xfs_defer_cancel(tp);
-		goto out_unreserve;
-	}
-
 	/*
 	 * Finish deferred items on final commit. Only permanent transactions
 	 * should ever have deferred ops.
@@ -877,13 +870,12 @@ __xfs_trans_commit(
 		error = xfs_defer_finish_noroll(&tp);
 		if (error)
 			goto out_unreserve;
-
-		/* Run precommits from final tx in defer chain. */
-		error = xfs_trans_run_precommits(tp);
-		if (error)
-			goto out_unreserve;
 	}
 
+	error = xfs_trans_run_precommits(tp);
+	if (error)
+		goto out_unreserve;
+
 	/*
 	 * If there is nothing to be logged by the transaction,
 	 * then unlock all of the items associated with the

