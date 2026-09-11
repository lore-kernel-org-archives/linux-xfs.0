Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED542C21D8;
	Fri, 11 Sep 2026 05:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106037; cv=none; b=lBsvw2zMUiuKqA/3t6BhRzIx7j6Ep/3XdXbYB/S4ks7oA0jM4EBBN75OkTPSsyw3CeHFKjaTANg5DxQXVjYOh4hEy4Q+bO6aCfGTgvmonySH62kxhdngaCIg6WqbTCBowMY/y7aVM8p15Z5drsqH/GJkgI6RSUhA3OEoNEsPMGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106037; c=relaxed/simple;
	bh=ZBL6Sf16DauTImOVdTx31Q2I1RRXKY45cdcv4BMEj2Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VC55yybL1DqN7DhDvU4oLm4d1/CAE+8RPnkg+b4r9u9L2UsGJqbyF1d5MirHpht+9+bYDVnJmNc5VS8GXI4TmU4OFP+scByvbVOqfiY2XswNWllleH3B+BosdgL9EV2zao9aooZDLeFuHt4zIpP/8Syha/N2aQeF+G2SMTUX6MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NvmLEXiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NvmLEXiC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E64521F000FF;
	Fri, 11 Sep 2026 05:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789106036;
	bh=TTNpnVPe2Hum6aRPb+eNTCMcRBAS0DHrSdaSxnGM6hk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=NvmLEXiCoTWANW8Yr+/TbTau0ahBZF/TeryhSh73eFxjW9wE+YAztF36u+9Iuq1dD
	 uH8pPOUsLRMOcbxsRoEbXGJ+vip3C4/5d63JphhHVCqo/1I4hjDgag7hvP9Q0zeduy
	 7WuTn8cRwsEOo+FDJ9oV+h6Sla5ip4SNCTqDsMtPMtzqxk32BJfRqFTxXJQIzHfyEk
	 i6LWEbju03ZSKIao8+Tca/FR6+H96ZGVuv+CTw0ne8oQHzbEjeeyWt8jVAVClpcEKc
	 5Wl0S1xbxAsLib1vFM1KERJ9NOMe2clJBqw/OyKNG+O2J889DnLSjBjpqH5dNbA5UG
	 DqwNziEVMDyLw==
Date: Thu, 10 Sep 2026 22:53:55 -0700
Subject: [PATCH 2/6] xfs: don't call xfs_exchange_range_finish for a dry run
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178910162063.174887.8246767904188448425.stgit@frogsfrogsfrogs>
In-Reply-To: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we strip file privileges and whatnot even for a dry
run.  We also shouldn't flush dirty data to disk or trim COW staging
events for a dry run.  Neither of those behaviors are allowed by the
manpage, so fix that by exiting early on DRY_RUN in various functions.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 42672471f938cd ("xfs: bind together the front and back ends of the file range exchange code")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_exchrange.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 07090487c581e8..fafb4e3f065c75 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -633,6 +633,9 @@ xfs_exchrange_prep(
 	if (error)
 		return error;
 
+	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
+		return 0;
+
 	trace_xfs_exchrange_flush(fxr, ip1, ip2);
 
 	/* Flush the relevant ranges of both files. */
@@ -709,9 +712,11 @@ xfs_exchrange_contents(
 	 * other file write would do.  This may involve turning on support for
 	 * logged xattrs if either file has security capabilities.
 	 */
-	error = xfs_exchange_range_finish(fxr);
-	if (error)
-		goto out_unlock;
+	if (!(fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)) {
+		error = xfs_exchange_range_finish(fxr);
+		if (error)
+			goto out_unlock;
+	}
 
 out_unlock:
 	xfs_iunlock2_io_mmap(ip1, ip2);

