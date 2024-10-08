Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074B21DFE1A
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 13:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393886; cv=none; b=mxMskTZB50Ke5NKcc3XBebchjkORjN2DxzPsBN1RLXnfrfrXgItuBY+ZfqXgaqFzyP/A1Sb0REJf7qs/VnwSJcNdXO2jclrSTYiupJ4KpRTGaWjh2/F2sW3U9B/J2PhG54eDyjGrsDWNzELL7K49vO+sFdUg7n1cbbPAOrqiljA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393886; c=relaxed/simple;
	bh=BpB3IM5TWKstNye9m48Vqz2q9sJ03uNMJCT8ovxgAPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=StfMRCVAR2F5lCs7RF4BhAI6XNBbCR5vsRtJav/QOgeRNO+tEIIETkae34X+vj2pn54UDf4CxUnVn4HwmzmcoEawg9rCrlHP3AiMQDEj6IwyMFBSL3hGNv7bV+GaR4Y7HE2F7oR8P/aDZBG7Z4RrIKVEI8DuzurvysfgqEl1+Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PWYutqU6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PWYutqU6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728393884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/HsfpZySGCEe7YAO5xU4Mllsq/gAJtGfw7aSWiHJYg=;
	b=PWYutqU6qo9k7klpgH/cvCOJyUTz94+xPgUQyDvpZ/OH1AliRgpDfbZUmrF37HNw1+E9P1
	RCb2PzBEJOJBjLF4ub5JG8RBlZdUcBF4Ip+7LHHKtWNR9NBKfnFKLypBy2IhL+Qq+gB5WF
	tHU98vs7dsBFLgo8L1Xrc88tmHnFdoE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-3_O-wuk0OaK7PH3xpxjDQQ-1; Tue,
 08 Oct 2024 09:24:41 -0400
X-MC-Unique: 3_O-wuk0OaK7PH3xpxjDQQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A8861945105;
	Tue,  8 Oct 2024 13:24:40 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.133])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 48B0319560A2;
	Tue,  8 Oct 2024 13:24:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net
Subject: [PATCH] xfsprogs/mkfs: prototype XFS image mode format for scalable AG growth
Date: Tue,  8 Oct 2024 09:25:56 -0400
Message-ID: <20241008132556.81878-1-bfoster@redhat.com>
In-Reply-To: <20241008131348.81013-1-bfoster@redhat.com>
References: <20241008131348.81013-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Tweak a few checks to facilitate experimentation with an agcount=1
filesystem format with a larger agsize than the filesystem data
size. The purpose of this is to POC a filesystem image mode format
for XFS that better supports the typical cloud filesystem image
deployment use case where a very small fs image is created and then
immediately grown orders of magnitude in size once deployed to
container environments. The large grow size delta produces
filesystems with excessive AG counts, which leads to various other
functional problems that eventually derive from this sort of
pathological geometry.

To experiment with this patch, format a small fs with something like
the following:

  mkfs.xfs -f -lsize=64m -dsize=512m,agcount=1,agsize=8g <imgfile>

Increase the underlying image file size, mount and grow. The
filesystem will grow according to the format time AG size as if the
AG was a typical runt AG on a traditional multi-AG fs.

This means that the filesystem remains with an AG count of 1 until
fs size grows beyond AG size. Since the typical deployment workflow
is an immediate very small -> very large, one-time grow, the image
fs can set a reasonable enough default or configurable AG size
(based on user input) that ensures deployed filesystems end up in a
generally supportable geometry (i.e. with multiple AGs for
superblock redundancy) before seeing production workloads.

Further optional changes are possible on the kernel side to help
provide some simple guardrails against misuse of this mechanism. For
example, the kernel could do anything from warn/fail or restrict
runtime functionality for an insufficient grow. The image mode
itself could set a backwards incompat feature bit that requires a
mount option to enable full functionality (with the exception of
growfs). More discussion is required to determine whether this
provides a usable solution for the common cloud workflows that
exhibit this problem and what the right interface and/or limitations
are to ensure it is used correctly.

Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is mostly a repost of the previous RFD patch to allow mkfs to
create single AG filesystems with AG sizes larger than the filesystem
itself. The main tweak in this version is that agcount=1 is allowed not
just for explicitly outsized AG sizes, but for any file-based target
device. This supports either setting a large AG size at format time or
sticking with the default size and letting the kernel set a new AG size
at growfs time.

Brian

 mkfs/xfs_mkfs.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bbd0dbb6c..20168b58d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -329,8 +329,7 @@ static struct opt_params dopts = {
 	},
 	.subopt_params = {
 		{ .index = D_AGCOUNT,
-		  .conflicts = { { &dopts, D_AGSIZE },
-				 { &dopts, D_CONCURRENCY },
+		  .conflicts = { { &dopts, D_CONCURRENCY },
 				 { NULL, LAST_CONFLICT } },
 		  .minval = 1,
 		  .maxval = XFS_MAX_AGNUMBER,
@@ -372,8 +371,7 @@ static struct opt_params dopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_AGSIZE,
-		  .conflicts = { { &dopts, D_AGCOUNT },
-				 { &dopts, D_CONCURRENCY },
+		  .conflicts = { { &dopts, D_CONCURRENCY },
 				 { NULL, LAST_CONFLICT } },
 		  .convert = true,
 		  .minval = XFS_AG_MIN_BYTES,
@@ -1264,7 +1262,7 @@ validate_ag_geometry(
 		usage();
 	}
 
-	if (agsize > dblocks) {
+	if (agsize > dblocks && agcount != 1) {
 		fprintf(stderr,
 	_("agsize (%lld blocks) too big, data area is %lld blocks\n"),
 			(long long)agsize, (long long)dblocks);
@@ -2812,12 +2810,20 @@ validate_supported(
 
 	/*
 	 * Filesystems should not have fewer than two AGs, because we need to
-	 * have redundant superblocks.
+	 * have redundant superblocks. The exception is filesystem image files
+	 * that are intended to be grown on deployment before production use.
+	 *
+	 * A single AG provides more flexibility to grow the filesystem because
+	 * the AG size can be grown until a second AG is added. This helps
+	 * prevent tiny image filesystems being grown to unwieldy AG counts.
 	 */
 	if (mp->m_sb.sb_agcount < 2) {
 		fprintf(stderr,
- _("Filesystem must have at least 2 superblocks for redundancy!\n"));
-		usage();
+ _("Filesystem must have at least 2 superblocks for redundancy.\n"));
+		if (!cli->xi->data.isfile)
+			usage();
+		fprintf(stderr,
+ _("Proceeding for image file, grow before use.\n"));
 	}
 }
 
-- 
2.46.2

