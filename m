Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C0216F271
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 13:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723470968; cv=none; b=kOYQSuGuNgqiAPO0IVbnkJozhRm1JXe6Cq9ktbVQ56czVGDO8nXZkZ2ayuBDE5yJzszDcwcxZp8FZ4ZXghtU5fmO0c917wxZB78r5I77cdc0dQ+jxjkEutP8jn0H4Yu3JUkd8nMxKdIvh+urRZ+NqM4RaXCf8o/uvMZttNJJvkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723470968; c=relaxed/simple;
	bh=YYGgKXuV0O7VXB4yJSDvw3VzjDS1omdPXt9eIgP5Up4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k77JkdVF1CPn8U0FsHOQl3tv6xX9MJtq+u21R29a/Z95Nf+ajXYAwt7vPAdQA7ElMBG8R5wjQBVwchoeRZYXHh72ZiL6FPNIXEac5IOCdyhGptIU4oXWJ/lqVUicehQylqhIjiDNgt2sAV/MgIGJEuiGSQpShel8876t5liVay0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UwixoPmu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UwixoPmu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723470965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=I4sJrEj36tSHzS55DoX6KfEvNbPwzrJz93iSI+d/ydI=;
	b=UwixoPmuPxsqIxOZ4HiMoFSX3Y6XfhiPE04X1iZt58Vnyeby7HGHMvm25mVHIM3Zq01m8g
	x1XgKIwORfnybYQMWD2tcd9AQLPQ/Tz1nG5O9uGZIfyikmG2iZf5RFn7E4Z8FedMp6tM7Y
	uJDSJpPFAp80TX/zGPcONN9trJNzcKQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-SwcX5442Np6yu6HAsU5qfQ-1; Mon,
 12 Aug 2024 09:56:01 -0400
X-MC-Unique: SwcX5442Np6yu6HAsU5qfQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0EC219373D8;
	Mon, 12 Aug 2024 13:56:00 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.74])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A2AF130001A1;
	Mon, 12 Aug 2024 13:55:59 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net
Subject: [RFD] xfsprogs/mkfs: prototype XFS image mode format for scalable AG growth
Date: Mon, 12 Aug 2024 09:56:52 -0400
Message-ID: <20240812135652.250798-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

Hi all,

This is a followup to the idea Darrick brought up in the expansion
discussion here [1]. I poked through the code a bit and found it
somewhat amusing how little was in the way of experimenting with this,
so threw this against an fstests run over the weekend. I see maybe
around ~10 or so test failures, most of which look like simple failures
related to either not expecting agcount == 1 fs' or my generally
hacky/experimental changes. There are a couple or so that require a bit
more investigation to properly characterize before I would consider this
fully sane.

I'm posting this separately from the expansion discussion to hopefully
avoid further conflating the two. My current sense is that if this turns
out to be a fundamentally workable approach, mkfs would more look
something like 'mkfs --image-size 40g ...' and the kernel side may grow
some optional guardrail logic mentioned above and in the previous
discussion here [2], but others might have different ideas.

Darrick, you originally raised this idea and then Eric brought up some
legitimate technical concerns in the expansion design thread. I'm
curious if either of you have any further thoughts/ideas on this.

Brian

[1] https://lore.kernel.org/linux-xfs/20240721230100.4159699-1-david@fromorbit.com/
[2] https://lore.kernel.org/linux-xfs/ZqzMay58f0SvdWxV@bfoster/

 mkfs/xfs_mkfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6d2469c3c..50a874a03 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -325,8 +325,7 @@ static struct opt_params dopts = {
 	},
 	.subopt_params = {
 		{ .index = D_AGCOUNT,
-		  .conflicts = { { &dopts, D_AGSIZE },
-				 { &dopts, D_CONCURRENCY },
+		  .conflicts = { { &dopts, D_CONCURRENCY },
 				 { NULL, LAST_CONFLICT } },
 		  .minval = 1,
 		  .maxval = XFS_MAX_AGNUMBER,
@@ -368,8 +367,7 @@ static struct opt_params dopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_AGSIZE,
-		  .conflicts = { { &dopts, D_AGCOUNT },
-				 { &dopts, D_CONCURRENCY },
+		  .conflicts = { { &dopts, D_CONCURRENCY },
 				 { NULL, LAST_CONFLICT } },
 		  .convert = true,
 		  .minval = XFS_AG_MIN_BYTES,
@@ -1233,7 +1231,7 @@ validate_ag_geometry(
 		usage();
 	}
 
-	if (agsize > dblocks) {
+	if (agsize > dblocks && agcount != 1) {
 		fprintf(stderr,
 	_("agsize (%lld blocks) too big, data area is %lld blocks\n"),
 			(long long)agsize, (long long)dblocks);
@@ -2703,7 +2701,8 @@ validate_supported(
 	 * Filesystems should not have fewer than two AGs, because we need to
 	 * have redundant superblocks.
 	 */
-	if (mp->m_sb.sb_agcount < 2) {
+	if (mp->m_sb.sb_agcount < 2 &&
+	    mp->m_sb.sb_agblocks <= mp->m_sb.sb_dblocks) {
 		fprintf(stderr,
  _("Filesystem must have at least 2 superblocks for redundancy!\n"));
 		usage();
-- 
2.45.0

