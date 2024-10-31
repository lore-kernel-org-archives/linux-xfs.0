Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03C319CC1D
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416904; cv=none; b=sTXu+YkyYvzJboc59/0QLEzUIMT5koPuSSoPmdAq33DMYFGSajwGZIdpaISMQIsMxjxSgn0MLMpnnyRscF/P3jROXZpG2PbFxx2Oc0zMi/vdnq46cif+Cu+DNrohmLM/9D3Or0FNcmS7cB0CFyoifl38u9iJGXBL3fefpwTMxd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416904; c=relaxed/simple;
	bh=EqnF7CIpRC91gS4sEMx44gI53kQAc3v8T63Dw+Xutbw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H7zn94ezvwHy96oVJyhwOyU1qsPAS14/0mScPVgfxtC+v+Lc0RXC47k5TaBFWMAD+vq6DEuqbcBP7/kP0DAFByGEIExkWD9jWCvWKXZWMaQLc6V2bQZu9CA2eLYHYP9dAZBsE8rGmr8zazObgirgdn0bI0ndEiqRjhybkyrMHEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cSgeJyrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cSgeJyrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBC7C4CEC3;
	Thu, 31 Oct 2024 23:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416903;
	bh=EqnF7CIpRC91gS4sEMx44gI53kQAc3v8T63Dw+Xutbw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cSgeJyrD8ytiX/3wIRWtQc4dNxW6oU9tUK/Q8tHW4CNsxcMHdjyQt+MQazLkFO4fo
	 7iLfU6fHnmw8pNdUTx0kWuEHaOeQVepSRV7blY2NgRr49s7E5h3OqlEX/CdLfOMBbb
	 PZTPAo1VCgM9Fta3F69AbRHJjHif78AuJe6KYdLAyqgQBiN4OXi0/mUFZtJNNfbRB0
	 FF/gYJRWcNl1zK8opnv2SgGC935SwXFqSY0GgHNZkrAKcWIt/aH9Ffzz1b83o6DnrF
	 AwK9S2iIwXMEzOkOR2Yp3MlQmYzPut6xt5dN01ExkydPPmL00L6GnGJlM/pfNU0MJa
	 Ex1eOlbS+i9Iw==
Date: Thu, 31 Oct 2024 16:21:43 -0700
Subject: [PATCH 2/8] xfs_db: report the realtime device when associated with
 each io cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041567368.964205.6284820036401488617.stgit@frogsfrogsfrogs>
In-Reply-To: <173041567330.964205.623580785256778088.stgit@frogsfrogsfrogs>
References: <173041567330.964205.623580785256778088.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When db is reporting on an io cursor and the cursor points to the
realtime device, print that fact.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/block.c |    2 ++
 db/io.c    |   11 +++++++++++
 db/io.h    |    1 +
 3 files changed, 14 insertions(+)


diff --git a/db/block.c b/db/block.c
index 22930e5a287e8f..bd25cdbe193f4f 100644
--- a/db/block.c
+++ b/db/block.c
@@ -133,6 +133,8 @@ daddr_f(
 			dbprintf(_("datadev daddr is %lld\n"), daddr);
 		else if (iocur_is_extlogdev(iocur_top))
 			dbprintf(_("logdev daddr is %lld\n"), daddr);
+		else if (iocur_is_rtdev(iocur_top))
+			dbprintf(_("rtdev daddr is %lld\n"), daddr);
 		else
 			dbprintf(_("current daddr is %lld\n"), daddr);
 
diff --git a/db/io.c b/db/io.c
index 26b8e78c2ebda8..3841c0dcb86ead 100644
--- a/db/io.c
+++ b/db/io.c
@@ -159,6 +159,15 @@ iocur_is_extlogdev(const struct iocur *ioc)
 	return bp->b_target == bp->b_mount->m_logdev_targp;
 }
 
+bool
+iocur_is_rtdev(const struct iocur *ioc)
+{
+	if (!ioc->bp)
+		return false;
+
+	return ioc->bp->b_target == ioc->bp->b_mount->m_rtdev_targp;
+}
+
 void
 print_iocur(
 	char	*tag,
@@ -171,6 +180,8 @@ print_iocur(
 		block_unit = "fsbno";
 	else if (iocur_is_extlogdev(ioc))
 		block_unit = "logbno";
+	else if (iocur_is_rtdev(ioc))
+		block_unit = "rtbno";
 
 	dbprintf("%s\n", tag);
 	dbprintf(_("\tbyte offset %lld, length %d\n"), ioc->off, ioc->len);
diff --git a/db/io.h b/db/io.h
index cece66a1cf825a..653724e90bd270 100644
--- a/db/io.h
+++ b/db/io.h
@@ -60,6 +60,7 @@ extern void	xfs_verify_recalc_crc(struct xfs_buf *bp);
 
 bool iocur_is_ddev(const struct iocur *ioc);
 bool iocur_is_extlogdev(const struct iocur *ioc);
+bool iocur_is_rtdev(const struct iocur *ioc);
 
 /*
  * returns -1 for unchecked, 0 for bad and 1 for good

