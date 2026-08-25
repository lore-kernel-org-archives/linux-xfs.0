Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D9349362B;
	Tue, 25 Aug 2026 05:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636236; cv=none; b=R8P3HEBeP9xroYWKxOO0SCfXCc75g/I/A8ilBWmYRGxHiFRtogfC72Vh2umGxmYOHNdWr+3Cgk4euA/oTIZEvq1TxgC1TqmqubXZVjRwUYGCUSgqmnQT3iPzErdKJKhTvbQjdX/KH3GIbqyRXkv4OvRV3h+H0m1WpsTqFKp1fJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636236; c=relaxed/simple;
	bh=SahqFbJCDvgki0JhYb52GlafUPdIYAWRZkTIkwYRkMg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KzuYQaxxDPPD7oCZ3lPTBfK4bu/bhXNimq2IU6SfGI4yGGiWaWEQRV/D0YEXRXkph7/tAWKokcrvmuRPgaQfRc/nnxC1iwpwa1yHJ8mTNezVfM46ZE86hdpuiXdzSlq6k/59PD1ALmneHHnm2uSAMK6zvADlWynMq4aw3/PcgCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XP9Y8Yvm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XP9Y8Yvm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 28DB21F000E9;
	Tue, 25 Aug 2026 05:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636235;
	bh=YxtdFAUaS486EHR4WG6tAJcC4w1ktFXrEGV2bA5n5Qc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=XP9Y8Yvm7Pj1Jy4+D9xiMQwKYXlc27Xm6JTlgJzbQTX/SDIQMrUK6mlifqCvBNs/f
	 hphhq1r395C2WI1JBk/66LOJRl7XNOCSCt6V8GQgGP2OXSxeOLCQo4gp1DWkKBQfJS
	 +i80ZzCvASuTv6ZEtpp5Iqshcf+aGGTvu5MuiAU0HpERPTBAzm3xPuSlOLnf4jGp4q
	 NbfR51YZE8KSb2p8jjTNHTa5ykVvIoozUFyxpstp5jmSPjX2iQGzz7MxHNiRXjTA52
	 l32nw/5HVjGQ7RabAh7317hzzcDjJ3C8dbtD1KH8pQuTtmwirTgu4OG+2UTxVWjbiQ
	 3iAQvHsZQ9aqg==
Date: Mon, 24 Aug 2026 22:37:14 -0700
Subject: [PATCH 5/5] xfs: destroy seen inode bitmap when we fail to add a
 dirpath
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178760941186.944364.1427795667692371177.stgit@frogsfrogsfrogs>
In-Reply-To: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes a memory leak in xchk_dirtree_create_path if we create
the directory path object but appending the name to the path fails.
When this happens, we don't tear down the (empty) seen inode bitmap.
This is a pretty trivial error, but let's not leave logic bombs.

Do the same for a similar bug in xrep_dirtree_create_adoption_path.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 928b721a11789a ("xfs: teach online scrub to find directory tree structure problems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dirtree.c        |    1 +
 fs/xfs/scrub/dirtree_repair.c |    1 +
 2 files changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 717cbac2956238..9b0ab23166124e 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -259,6 +259,7 @@ xchk_dirtree_create_path(
 	dl->nr_paths++;
 	return 0;
 out_path:
+	xino_bitmap_destroy(&path->seen_inodes);
 	kfree(path);
 	return error;
 }
diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index bbf6acf6fd400c..8acd55b8c7696d 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -618,6 +618,7 @@ xrep_dirtree_create_adoption_path(
 	return 0;
 
 out_path:
+	xino_bitmap_destroy(&path->seen_inodes);
 	kfree(path);
 	return error;
 }

