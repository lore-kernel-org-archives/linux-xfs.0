Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C14D4683
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299778; cv=none; b=qhcXyIa6V2IfDFmKE0xfst6KuDeWSNqIqt/c+KCM9thiuGZmuh2amPerjZe5nfcQZ/B7a4Wa+tyq50FC4zY1LXPTm42eZf4jES9CF1TTH8BJ4+xa8yfzUEyB0JDCIF0zYgHbuHLWDWATE+159swKm59J99SHhmJPuxeoc9GTBss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299778; c=relaxed/simple;
	bh=lVkshSq2H/RLKQFG0I1EnJWH6DEH67LjzmDESbXIr7E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GEP60TRtElkBGprJv6/avIMfjWC27GP5OMGvEmriDX8nFEaWeAhgfEOtDst7XlCiMNZWIASieCfRxZ+QcmXQpGd9DcmXFBi2wTZi1J3rcjXcNlUge0dMS7XNop21sb8jWufQRXJW1iYAyU19Sj3oPODMMZS0aIiQRmHBPkD86gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hCwhVdKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hCwhVdKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17973C32786;
	Tue, 30 Jul 2024 00:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299778;
	bh=lVkshSq2H/RLKQFG0I1EnJWH6DEH67LjzmDESbXIr7E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hCwhVdKM8b3C7nn86FExcYjEDYI/oDLMwmnM13IaamdWsWqzt3jQ0mh9fsgCVd+8/
	 A970WpL7csoZM90r/M+NNrjuYxSZGkWtWlVNfAw/+hOC542+DfXd/zvDIY2zvFRF6s
	 nc2FrcIIWmb7I0/cVLzJjUP/AOmlrSYAUmRMhX7vbDgEF/8owWAgLbR8I97gJvyDar
	 61QoHxE0k4eiKtR99j86B2JxX55Yy2CJEIRXxlI0ohOcFuedmC34CI7WE8DHOzVvix
	 HHOGhhKJ1dcPJ5+qFZbgYrfYm2LdM28i17Q5ly4YshlHqoAju6rficituaOBdCrhy+
	 uOnzckOvLK/Vg==
Date: Mon, 29 Jul 2024 17:36:17 -0700
Subject: [PATCH 048/115] xfs: restructure xfs_attr_complete_op a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843118.1338752.15209002659168190448.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 992c3b5c3fe6f42778436649ddae2b7a2984b7aa

Eliminate the local variable from this function so that we can
streamline things a bit later when we add the PPTR_REPLACE op code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 8e9e23836..26674116f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -430,14 +430,13 @@ xfs_attr_complete_op(
 	enum xfs_delattr_state	replace_state)
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
-	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
+
+	if (!(args->op_flags & XFS_DA_OP_REPLACE))
+		replace_state = XFS_DAS_DONE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
-	if (do_replace)
-		return replace_state;
-
-	return XFS_DAS_DONE;
+	return replace_state;
 }
 
 static int

