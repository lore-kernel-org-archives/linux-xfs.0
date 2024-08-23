Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B61F538A
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372721; cv=none; b=gqn9++mK5lWBgmyCW0BEkaiWbrmtOVE/SQZyTogjl+mrGISP65szC8RkwE6hcKx6PLUgl9NEczvHo3iz8vJfTt10nhjPMqmuipSDFR51SFIr3+apDklIRRwtUbeo9Q6plREI54GEPS8vVQSLOCSMhEJII8KVkSWOT2Bv9kUUMSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372721; c=relaxed/simple;
	bh=fglrqyw/TYGT5a2ze2sXMoGvaXxhbFaLfmNM4vVdKcQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/0U50Cj++kz0wVUu6CkJPpqcL6eVtytyFPGgLdvZ0+FxxmW6pbw05RfPlwe7cQMPUemwhxIDs5mTkEW2u5FPMS2onDF1j9ZejOgdfFV6bM3fu3tTpKGK+svt0PNBlLDzUaMI4tg2fg+lD0ylBHT5gSwApwgiCFINs17U8zb2sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/MfNHZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/MfNHZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012DFC32782;
	Fri, 23 Aug 2024 00:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372721;
	bh=fglrqyw/TYGT5a2ze2sXMoGvaXxhbFaLfmNM4vVdKcQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C/MfNHZhHFttsKI4PcFjmkaHXNpsA0Zpf2QHBfz18AwrE+W6S4LmhYR3ZiTmrD3AN
	 yr+muUKJz8oCTO8ED/ekYa1o3GIcuZ+T4FPlgVuzGh2GOvgNc+lTeTfhiTOGmX1NQS
	 nNYlrHmnZ6TjHhSsTD2P05wYwtY+vc8PqLPSb72Gsku2RWsrAVpxxgwzm21XmprOiR
	 ypzFRg22Xj8QsxQZqWvEY9X8qhjpSyJMrUbKw3uzgoAdrjKQ2hI2ZioOHY2f2CL49D
	 /a8T7o6phTdmLeHE5yW/J8DU9wKvf5ZSJhK9GfQLDLDVGf2YcGoQYbmwm0fHChhMF5
	 vlwa3Q5WSBYEg==
Date: Thu, 22 Aug 2024 17:25:20 -0700
Subject: [PATCH 16/26] xfs: force swapext to a realtime file to use the file
 content exchange ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088799.60592.14096570051407234430.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs_swap_extent_rmap does not use log items to track the overall
progress of an attempt to swap the extent mappings between two files.
If the system crashes in the middle of swapping a partially written
realtime extent, the mapping will be left in an inconsistent state
wherein a file can point to multiple extents on the rt volume.

The new file range exchange functionality handles this correctly, so all
callers must upgrade to that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fe2e2c9309755..025e58daf6f50 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1522,6 +1522,18 @@ xfs_swap_extents(
 		goto out_unlock;
 	}
 
+	/*
+	 * The rmapbt implementation is unable to resume a swapext operation
+	 * after a crash if the allocation unit size is larger than a block.
+	 * This (deprecated) interface will not be upgraded to handle this
+	 * situation.  Defragmentation must be performed with the commit range
+	 * ioctl.
+	 */
+	if (XFS_IS_REALTIME_INODE(ip) && xfs_has_rtgroups(ip->i_mount)) {
+		error = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	error = xfs_qm_dqattach(ip);
 	if (error)
 		goto out_unlock;

