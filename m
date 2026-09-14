Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E06037F739
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789365017; cv=none; b=h4L1pjkVaj+/0cpDFXZJZja8I8p2TWdRoIw5nTqqKS6Yw26WXzaProroH+A4B7WeLC8KHzgDTAHrNpiMQd5Cg7NatRIFA7uoc5phSDfE7gg2Oy98/6Eo5jOcpti+LGu5crIsZYSsGjsfaHlu3IeZnepgGozoMrkPXzibEcMItVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789365017; c=relaxed/simple;
	bh=nObh/ZQjE0CPvTp4Eb6qgTnUcuqjYGM6IX0a04Q+s3I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8pBO6v1hiR6xe3yk7rUlO1oPVyEBHe8DHeUSXu0xm6QU+jLdEBnSvFD55gkfx/oLZKDqj9GWar9Oa2nsLjqjEh7jaqrL8N4lBovyV4BJLKFWpqJIdtIpqxv9AV9tlAp90FAcXzghU60GubtdmL1RnrJ1KHKSGiabrMI0JbaN9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=odMFSitz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="odMFSitz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AAF631F000FF;
	Mon, 14 Sep 2026 05:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789365006;
	bh=xveh9vI9f2o4Say1xazGc9XIIetfOfZQ6UlluZrTMWs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=odMFSitzoCYjF+0sP/lH1uZ4aNgSnxwb1m8i55KX+wNPcmpXuE5zOYpo74hSKZX4U
	 wcQLGi7s9J9Mn8nl1r1s3a4hOR9Y9lOIr+RrN6Kp0cupHeL8j2Eb/voEuox2qlBXXi
	 l4EORpNLbM8jNjiNJoKQFKms+X+/A+909D+F3fwk8WXIW8LCCclEGvIYBDIG+GPrm7
	 XSitcfa9zbS5JgpfAY0B/tSNuvd6JlT7dc32IEmG+df3RscH+EED+93k5DSh/gRjy1
	 Nzjne0aNmpzi21QNqitwpM0D5+ocv9wAaA1Lc2tFZEczjLJSwssMwn4yvlOuthLDcc
	 zw5X+IKNym5ZQ==
Date: Sun, 13 Sep 2026 22:50:06 -0700
Subject: [PATCH 2/7] libfrog: clean up xfsquotactl a little bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178936484843.2108717.10271335394491802697.stgit@frogsfrogsfrogs>
In-Reply-To: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Clean up this function so that we actually take advantage of enums for
the quota command, and get ready for adding quotactl_fd in the next
patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/quotactl.h |   10 ++++------
 libfrog/quotactl.c |   22 ++++++++++------------
 2 files changed, 14 insertions(+), 18 deletions(-)


diff --git a/libfrog/quotactl.h b/libfrog/quotactl.h
index f76d02567408a0..5e351d53bb4b1e 100644
--- a/libfrog/quotactl.h
+++ b/libfrog/quotactl.h
@@ -8,12 +8,7 @@
 
 #include "xqm.h"
 
-/*
- * System call definitions mapping to platform-specific quotactl
- */
-extern int xfsquotactl(int __cmd, const char *__device,
-			uint __type, uint __id, void * __addr);
-enum {
+enum xfs_quota_cmd {
 	XFS_QUOTAON,	/* enable accounting/enforcement */
 	XFS_QUOTAOFF,	/* disable accounting/enforcement */
 	XFS_GETQUOTA,	/* get disk limits and usage */
@@ -25,4 +20,7 @@ enum {
 	XFS_GETNEXTQUOTA, /* get disk limits and usage */
 };
 
+int xfsquotactl(enum xfs_quota_cmd xcommand, const char *device,
+		unsigned int xtype, unsigned int id, void *addr);
+
 #endif /* LIBFROG_QUOTACTL_H_ */
diff --git a/libfrog/quotactl.c b/libfrog/quotactl.c
index ffef72b44eeadf..81df2baf4a76b4 100644
--- a/libfrog/quotactl.c
+++ b/libfrog/quotactl.c
@@ -28,9 +28,9 @@ xtype_to_qtype(
 
 static int
 xcommand_to_qcommand(
-	uint		command)
+	enum xfs_quota_cmd	xcommand)
 {
-	switch (command) {
+	switch (xcommand) {
 	case XFS_QUOTAON:
 		return Q_XQUOTAON;
 	case XFS_QUOTAOFF:
@@ -55,16 +55,14 @@ xcommand_to_qcommand(
 
 int
 xfsquotactl(
-	int		command,
-	const char	*device,
-	uint		type,
-	uint		id,
-	void		*addr)
+	enum xfs_quota_cmd	xcommand,
+	const char		*device,
+	uint			xtype,
+	uint			id,
+	void			*addr)
 {
-	int		qcommand, qtype;
+	const int		op = QCMD(xcommand_to_qcommand(xcommand),
+					  xtype_to_qtype(xtype));
 
-	qtype = xtype_to_qtype(type);
-	qcommand = xcommand_to_qcommand(command);
-
-	return quotactl(QCMD(qcommand, qtype), device, id, addr);
+	return quotactl(op, device, id, addr);
 }

