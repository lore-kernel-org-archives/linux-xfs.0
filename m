Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5541862
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063591; cv=none; b=nELeh9yJ3bWQgq9fTXhe4qH53QBeyPWhuHYerlcnQM6OZ+kOn7GaXAV3uGjOp/iLmMoHU/SPmuPKKzHzuUTdM6brA5+Xe2P7OC7mm2h9aKNbXCKsYoF12pE5gayX+E3fC+VD2HeIYow39qdxlkMp5gcn/lTBLEWmBv0o5ytf2Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063591; c=relaxed/simple;
	bh=Qd4zBf5Eb6KRQOJGSLE6Pno9kaM38ZPUoyqVSIV0XlQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kDUyntxWMCnscBvIZNbbssylX85ZYJzRGPX7nTXEbFsgCULBalxMP5Qf/gTi9si2M1hPjBIJXAfYMT/LLqBlPNW//vneLGXNahSJopsvA+9C6T3tuXY2pl2OHE7xXGBbgGe7j8O2i9WSIAr9O9/hNEzK2HH6bZT9y5kgAtAfos8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5lHKvyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5lHKvyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DCBC4CED6;
	Thu, 16 Jan 2025 21:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063590;
	bh=Qd4zBf5Eb6KRQOJGSLE6Pno9kaM38ZPUoyqVSIV0XlQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V5lHKvyhRUqXz/yj9U+/TNL0wW6rsUN6u+z4OnfzFEehInG1ru70Td7Fq6ifMMoRW
	 kkgfQsr2gDJgen80rYEGD+lx1eA4/vkAlG6VvuGPs4AAXtqopO+C0lZm554kwICvXy
	 /rOT/4rzxChyZ7PizJlz5NtsCIXMmzziagm5VL9AMrk5zJQir56S4nlUy0UNLOBCfs
	 NFvzscKfzLbBYfC9RlHH0aaAC2/9ZBirm39G2iRCsDOdvuvOfa55VrHJa+WgyfcwNV
	 gd/yr4iZA4kXXsugnlLbMsbc3TWcdx4jm9R1bjPyJW/UHGLyzlTYr9R+gOz7m+sBWJ
	 /TZ9GLvH7yohg==
Date: Thu, 16 Jan 2025 13:39:49 -0800
Subject: [PATCH 5/8] mkfs: fix parsing of value-less -d/-l concurrency cli
 option
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173706332281.1823674.7436201439160217375.stgit@frogsfrogsfrogs>
In-Reply-To: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
References: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It's supposed to be possible to specify the -d concurrency option with
no value in order to get mkfs calculate the agcount from the number of
CPUs.  Unfortunately I forgot to handle that case (optarg is null) so
mkfs crashes instead.  Fix that.

Fixes: 9338bc8b1bf073 ("mkfs: allow sizing allocation groups for concurrency")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 956cc295489342..deaac2044b94dd 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1722,7 +1722,7 @@ set_data_concurrency(
 	 * "nr_cpus" or "1" means set the concurrency level to the CPU count.
 	 * If this cannot be determined, fall back to the default AG geometry.
 	 */
-	if (!strcmp(value, "nr_cpus"))
+	if (!value || !strcmp(value, "nr_cpus"))
 		optnum = 1;
 	else
 		optnum = getnum(value, opts, subopt);
@@ -1867,7 +1867,7 @@ set_log_concurrency(
 	 * "nr_cpus" or 1 means set the concurrency level to the CPU count.  If
 	 * this cannot be determined, fall back to the default computation.
 	 */
-	if (!strcmp(value, "nr_cpus"))
+	if (!value || !strcmp(value, "nr_cpus"))
 		optnum = 1;
 	else
 		optnum = getnum(value, opts, subopt);

