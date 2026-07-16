Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062A6234994;
	Thu, 16 Jul 2026 06:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784182031; cv=none; b=LT3ocYrq+21WfamKK36Ljynq22lvm/ePgwTkYJVoT5ZpRgz8YfX0wSjQ33K9kCTs2vMow+z+hZQtc5SL5PfNyC51nZ85HXfkjYd7es6hFqmqLga6zmF+B3oEGSIz23iCf1fN0WEAWl5y8hiQmIrQj3ucM+l1d81OTc0aFeEUwVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784182031; c=relaxed/simple;
	bh=TeyJTMmM7nuZaVdN+260jToM9lbv/08H394/kl+IDvA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lFDFXf3nl5gbGWhD2VXmMRxEr1hwFN7cjY54pcvPxgn+lMLDRS0s4mdkjw8/mrRh/sxkDwbUQjlfXBFd4FhODmlJ5D+VGFvdzqKEG71tO8hi/kuiULIeD6rOLb28QNUb9ch8gUS2egDMWP+TNfQgIWbShR3Sp2/mgKhHwVGioP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HCMyUdkT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HCMyUdkT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BFC4A1F00A3E;
	Thu, 16 Jul 2026 06:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784182029;
	bh=NQRFMi+Qbi8m2s6KfgOgFlxB6BFV6JjrEKN9sPOppy4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HCMyUdkTzg3UcRPmcfihAQFirBREaRL5B3M+g9tBzF2YuvNGN+c9B3Xh8A1QJnHv/
	 RQyQ6Y1pLB021yZJFJB92jRQ0WzzJ0jeq9fsbIJaLuFAcQN/HR1u6TSMQjrLlWlX/I
	 JT8aLC5bMSANC5FUow2LfC0si6HQZdbb/8rg8J2v1so02Jh1byTasz6SxCJcvorDxq
	 RrGnGe9eo9GncE9Hlpb0yIfCrzns+doicpRKizZujp6wFnU0iuIw/1wkFnA68TFPr3
	 I4LeATyUULnAXTN6+A7rp5L3AnZfa9lGMO55+LuJqVro+b86Ji2tLCj7Xmn64ixLzX
	 TsDnRcQyIy5Ng==
Date: Wed, 15 Jul 2026 23:07:09 -0700
Subject: [PATCH 4/6] xfs: zero i_nlink before repair puts inode on unlinked
 list
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178416797445.2008054.14130559349245162334.stgit@frogsfrogsfrogs>
In-Reply-To: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that we don't reset i_nlink if we encounter a file with
no parent that isn't on the unlinked list.  This causes unnecessary
assertion trips on debugging kernels and an inconsistent file, so let's
fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 669dfe883c8e20 ("xfs: update the unlinked list when repairing link counts")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/nlinks_repair.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index fbc2ff809fc06f..09e097e1668935 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -232,9 +232,14 @@ xrep_nlinks_repair_inode(
 	 * unlinked list, put it on the unlinked list.
 	 */
 	if (total_links == 0 && !xfs_inode_on_unlinked_list(ip)) {
+		if (actual_nlink)
+			clear_nlink(VFS_I(ip));
 		error = xfs_iunlink(sc->tp, ip);
-		if (error)
+		if (error) {
+			if (actual_nlink)
+				set_nlink(VFS_I(ip), actual_nlink);
 			goto out_trans;
+		}
 		dirty = true;
 	}
 

