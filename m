Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD68A171A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390112; cv=none; b=J9e5EUG9uuHs80MK2chNjJglDndHXbMyc3XpPSckxfHtZxqBcl4ItTv4x9bWJ1bqGxKYm9XBoE3dKtLt/OnimIMyvfe/aRHOa2oF5olkCF7CcimPySjTIBFWifhguYhoGd37rPPDM2RloFvJvg3RwPY2iPFiuylvvvlULniQteE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390112; c=relaxed/simple;
	bh=nr6vIqOCmlhAeDwWCF51s7LItO6pqKVmkQfEvIHydzU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JGILmoVkbWUdNkJIYmbg37gbtl/cxVXIoEMEGuA06XrBXUHHlCXxUS6XXXbrMWFIiprbLYmyewqBswZ+Mgt0gDC/A81yql79aFsH73lpUvLLiTkEKeUGW8cBTLGzMzO7MaQO+7BRRHU1iZlCkruoBnYptrZdMwcR5t/kp5t5McQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjk0qCTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjk0qCTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B71C3277B;
	Wed, 17 Apr 2024 21:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390112;
	bh=nr6vIqOCmlhAeDwWCF51s7LItO6pqKVmkQfEvIHydzU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mjk0qCTSyFipZ6PJZxoqkGAu4T0tBCD9Y4ttaYnCTHstgwMFg4fW85v26SJkZRy2s
	 fMBfuG0efydfzrHe74WzrA6YXTfVAHQwEVrSplWikInvsRvQdJWdzFjVGOeQG9XTUo
	 9TDsjrtHlQ14kRQLvZgn4oWXMNgHQKWxJgNdCt5LKncXxL8DbB1ybCXz+kXJfp3Krf
	 7Uda7dfhpX3Aqax8WzLPTUAkJzu66sNC+nnaB7CF30zyAyO6Re1Kszd/5ye053sy38
	 gqdWAGn/CQvUD0P/SNbDldxLJ8urBcdfH1FL//476kHbn7p/k8KoX79htCxHiporkQ
	 XCskE5YAPC9Bg==
Date: Wed, 17 Apr 2024 14:41:52 -0700
Subject: [PATCH 3/5] libxfs: remove the S_ISREG check from blkid_get_topology
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338844409.1856006.11959435247152441667.stgit@frogsfrogsfrogs>
In-Reply-To: <171338844360.1856006.17588513250040281653.stgit@frogsfrogsfrogs>
References: <171338844360.1856006.17588513250040281653.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The only caller already performs the exact same check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.c |    9 ---------
 1 file changed, 9 deletions(-)


diff --git a/libxfs/topology.c b/libxfs/topology.c
index 63f0b96a5..706eed022 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -178,15 +178,6 @@ blkid_get_topology(
 {
 	blkid_topology tp;
 	blkid_probe pr;
-	struct stat statbuf;
-
-	/* can't get topology info from a file */
-	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
-		fprintf(stderr,
-	_("%s: Warning: trying to probe topology of a file %s!\n"),
-			progname, device);
-		return;
-	}
 
 	pr = blkid_new_probe_from_filename(device);
 	if (!pr)

