Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC2C3209
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609937; cv=none; b=EKwEtJHl6iTMtCiB6YM17wfUqGBB1hiK+dpzgAm8VErizgznzbsvC9UCO4aQ5OQ2991H684z3hMWwvbIxBl354lSsFlWtsELjatLOvdNQ5mh5akisn1WKgPHbHpn+7iMuwdbYTeR8TeYtegZtbThV5xIQbNFntRIRskA5y+F3Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609937; c=relaxed/simple;
	bh=q1+cjVm/Gq747xB/LNpAtelj3AE2RcQbgpANAZlgfIU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p8+3aReZdJwyXfZdIUECcKv11VGiWWD4tdIqAMQpJ8eLt814OqBGDBldpDZIFsSdOb49gl6lsP81sQqM0KXSwWUBetMGDPnrQTRVngFEGxa4BzzZo33SsfeUmtKs4/LqtQdd5uhjVPmwljEoubWRmwcVlTlO/88iZ3sW6TUpmtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p6yTR/1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6yTR/1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B42C4CEC5;
	Fri, 11 Oct 2024 01:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609937;
	bh=q1+cjVm/Gq747xB/LNpAtelj3AE2RcQbgpANAZlgfIU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p6yTR/1cMIHNqp7dSwZt6g7J3wA627dwoMTlGWAxLmrhtDR2xmvEIoLuNdDjT36va
	 e2Jo3d3Nv1a78j1yJ2TH/5i1+0RBEughbLsL26D5mq7g+lbPqw2auMtlckoxc89zCz
	 9ARBpIWfxq1qRygi6cMwFi9WTe/dOcwTmb6sYodxW+zG6tQUCKFRYDHAjiEy1kLte4
	 uMH87YYEuxU5HjhrJRDml8dzM0ODlEOKw5xwYOH4orThPqOsp/epIDeAv9ppxmn99+
	 fXZmUsfT3uJQvAQ0t0Y4yN9Pre+IdVhFi2F3tYL2YLRfI8ERbVLSvvXrKNJg6+cXx+
	 4RUxuzMdKekNg==
Date: Thu, 10 Oct 2024 18:25:36 -0700
Subject: [PATCH 04/43] libfrog: support scrubbing rtgroup metadata paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655427.4184637.12883881308278820593.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

Support scrubbing the metadata paths of rtgroup metadata inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index e7fb8b890bc133..66000f1ed66be4 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -172,6 +172,21 @@ const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
 		.descr	= "metapath",
 		.group	= XFROG_SCRUB_GROUP_NONE,
 	},
+	[XFS_SCRUB_METAPATH_RTDIR] = {
+		.name	= "rtdir",
+		.descr	= "realtime group metadir",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_RTBITMAP] = {
+		.name	= "rtbitmap",
+		.descr	= "rtgroup bitmap",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
+	[XFS_SCRUB_METAPATH_RTSUMMARY] = {
+		.name	= "rtsummary",
+		.descr	= "rtgroup summary",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */

