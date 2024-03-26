Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886791C6A8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422389; cv=none; b=buvbX/snzqXoLgAhbo4r4ioOzOa8WrMvozJMn8RHjgXbmtfKitHbG0lpTDbgtuj85bngdx1Gg5Di4hV/oAmYDPwcFx6rUd4ebIA6QNUQCMnKVIUpYBm0VTeduHdAQg+fsSLE3rhchD8Ppq4ntPTAsMcfTjuNQknCeE/2yijltOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422389; c=relaxed/simple;
	bh=MOcQJ/bgDAd664tOUNMkZEKC5cIyAIH1c0S7dYeY6Dw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pyPNmUz86FYe8uZBIGO3b3yDJ0nMKPC5+D6QBEDlv5JQnZ2CepNwaoRTsGsn8AvGbEZZQXo9/Hvlr/TDzL5DYHDx61KxdlJfaV6gpQlQiFTjli70pNdU2/bCP5Yt+QEHIBZFI3ryCf8CJUZW4bsw3qeghk6Grg67hVmAbPKmcko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KDc1cE9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDc1cE9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC8EC433F1;
	Tue, 26 Mar 2024 03:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422389;
	bh=MOcQJ/bgDAd664tOUNMkZEKC5cIyAIH1c0S7dYeY6Dw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KDc1cE9J286YQHT4jpPFDQmM+cB4trni5kFg6MlvX1Eh6CUy54BinZzNOPV648S2C
	 MQsGHMrbF4swwxJf8IFAljIFAbaDXs5e7ZvdfHtVINatotELF3PzP1JGUw6QceG/yE
	 VGmG9C2HD1pmKs/aqAJoBG2Ds40EFvAcnxPkWikkP0PivAOw2hGyQHOwLzxAZRGedB
	 jBiBtaKK4D+yq1pZV+pu2OFp2hXu4v4xPjJABh4R+HyYclazXtTMCm+Gj6M8Pf/RQQ
	 xrfN30MXtvBisk8AB+qeHrXvDkWu0r4M/0QEogNuaaXRZbc/2u226tTkhg8YrRsow0
	 92Dt3lK7736Rg==
Date: Mon, 25 Mar 2024 20:06:28 -0700
Subject: [PATCH 14/67] xfs: elide ->create_done calls for unlogged deferred
 work
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127164.2212320.2265101554688110715.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: 9c07bca793b4ff9f0b7871e2a928a1b28b8fa4e3

Extended attribute updates use the deferred work machinery to manage
state across a chain of smaller transactions.  All previous deferred
work users have employed log intent items and log done items to manage
restarting of interrupted operations, which means that ->create_intent
sets dfp_intent to a log intent item and ->create_done uses that item to
create a log intent done item.

However, xattrs have used the INCOMPLETE flag to deal with the lack of
recovery support for an interrupted transaction chain.  Log items are
optional if the xattr update caller didn't set XFS_DA_OP_LOGGED to
require a restartable sequence.

In other words, ->create_intent can return NULL to say that there's no
log intent item.  If that's the case, no log intent done item should be
created.  Clean up xfs_defer_create_done not to do this, so that the
->create_done functions don't have to check for non-null dfp_intent
themselves.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 29ec0bd8138c..722ff6a77260 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -195,6 +195,10 @@ xfs_defer_create_done(
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 	struct xfs_log_item		*lip;
 
+	/* If there is no log intent item, there can be no log done item. */
+	if (!dfp->dfp_intent)
+		return;
+
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:

