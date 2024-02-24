Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F254D17C8;
	Sat, 24 Feb 2024 01:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737210; cv=none; b=UiX/EoeSEJQef8aZLCGmMaNGpQQuDtwbUD/QqLu8cU9dPCH+Qx/Xr2Itb4RpLYbc/WcvO2GJ7CLjrss9zLSph1n/TUB2/ACic5EZFoCi73Mb26p8di/8+JIIlhhli8qj7lXhf9jKiB+B8prukmUk+IoRWpWixqPxwXAHIuru2nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737210; c=relaxed/simple;
	bh=L6r5bZ+g+t3I8EvVW0YLn6yhuQzgBMKx4LNt5DesAUw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FwE92dHjvqTq70oZh8HXc8jAR0BIBh2swNVdfl0ujUGnQMLmo5abrnvNF2OMouXPzcmhBS2W+Xy3UYoDyCzdwJl+cKdDST50VaOD4h9Ki66DFzayqaAGx2Kg2hYrmwV27O16AO4UllfCCIIN4GMKG+0+IMzbAb23O72S4psvSlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HILgp86V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HILgp86V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F1FC433F1;
	Sat, 24 Feb 2024 01:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737209;
	bh=L6r5bZ+g+t3I8EvVW0YLn6yhuQzgBMKx4LNt5DesAUw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HILgp86Vapq6hdB83NYlpNghW3US98xi+urs0fcq+z/oc55rCiZ2+aBTRChFqhJe1
	 GyVzbvgSkdfzpKJniV0l7PoUPg55NXplxoLs20XlLB0tzuE53xtulBy75s2iEkAmuR
	 G4hT6iiyfE0g0ufGVMxszroiXC4/4P15Gay76k41s6j6hz99Pgw3XdoKfp6P53OKwO
	 VS5MxGtG4XyQbwbm+dFMlZrFD1lp44Vxwh6Vbyt9Hrv5JNYg7sdypBE5uB/UVmtKoJ
	 Z9pKjSl5pL20A7WGqjZRg0w5fXuGrfP/Z/IPnmymPnN/XMOy4WkqzgYo71Xs4p3G6c
	 tmux6HmWhkOJA==
Date: Fri, 23 Feb 2024 17:13:29 -0800
Subject: [PATCH 3/4] xfs: present timestats in json format
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873668498.1861246.3957074733409144492.stgit@frogsfrogsfrogs>
In-Reply-To: <170873668436.1861246.6578314737824782019.stgit@frogsfrogsfrogs>
References: <170873668436.1861246.6578314737824782019.stgit@frogsfrogsfrogs>
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

Export json versions of xfs time statistics information.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/stats.c   |   12 ++++++++++--
 fs/xfs/xfs_timestats.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_timestats.h |    1 +
 3 files changed, 54 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index b9e6ace59e572..12f6ebbda3758 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -163,13 +163,21 @@ xchk_timestats_register(
 		if (!name_map[i])
 			continue;
 
-		snprintf(name, 32, "scrub::%s", name_map[i]);
+		snprintf(name, 32, "scrub::%s.txt", name_map[i]);
 		debugfs_create_file(name, 0444, ts->parent,
 				&ts->scrub[i].scrub, &xfs_timestats_fops);
 
-		snprintf(name, 32, "repair::%s", name_map[i]);
+		snprintf(name, 32, "repair::%s.txt", name_map[i]);
 		debugfs_create_file(name, 0444, ts->parent,
 				&ts->scrub[i].repair, &xfs_timestats_fops);
+
+		snprintf(name, 32, "scrub::%s.json", name_map[i]);
+		debugfs_create_file(name, 0444, ts->parent,
+				&ts->scrub[i].scrub, &xfs_timestats_json_fops);
+
+		snprintf(name, 32, "repair::%s.json", name_map[i]);
+		debugfs_create_file(name, 0444, ts->parent,
+				&ts->scrub[i].repair, &xfs_timestats_json_fops);
 	}
 }
 
diff --git a/fs/xfs/xfs_timestats.c b/fs/xfs/xfs_timestats.c
index 163a37e6717f7..dccecbe1ad922 100644
--- a/fs/xfs/xfs_timestats.c
+++ b/fs/xfs/xfs_timestats.c
@@ -49,6 +49,43 @@ const struct file_operations xfs_timestats_fops = {
 	.read			= xfs_timestats_read,
 };
 
+/* Format a timestats report into a buffer as json. */
+static ssize_t
+xfs_timestats_read_json(
+	struct file		*file,
+	char __user		*ubuf,
+	size_t			count,
+	loff_t			*ppos)
+{
+	struct seq_buf		s;
+	struct time_stats	*ts = file->private_data;
+	char			*buf;
+	ssize_t			ret;
+
+	/*
+	 * This generates a stringly snapshot of a timestats report, so we
+	 * do not want userspace to receive garbled text from multiple calls.
+	 * If the file position is greater than 0, return a short read.
+	 */
+	if (*ppos > 0)
+		return 0;
+
+	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	seq_buf_init(&s, buf, PAGE_SIZE);
+	time_stats_to_json(&s, ts, "mount", TIME_STATS_PRINT_NO_ZEROES);
+	ret = simple_read_from_buffer(ubuf, count, ppos, buf, seq_buf_used(&s));
+	kfree(buf);
+	return ret;
+}
+
+const struct file_operations xfs_timestats_json_fops = {
+	.open			= simple_open,
+	.read			= xfs_timestats_read_json,
+};
+
 /* Set up timestats collection. */
 void
 xfs_timestats_init(
@@ -79,8 +116,12 @@ xfs_timestats_destroy(
 
 /* Export timestats via debugfs */
 #define X(p, ts, name) \
-	debugfs_create_file("blocked::" #name, 0444, (p), &(ts)->ts_##name, \
-			&xfs_timestats_fops)
+	do { \
+		debugfs_create_file("blocked::" #name ".txt", 0444, (p), \
+				&(ts)->ts_##name, &xfs_timestats_fops); \
+		debugfs_create_file("blocked::" #name ".json", 0444, (p), \
+				&(ts)->ts_##name, &xfs_timestats_json_fops); \
+	} while (0)
 void
 xfs_timestats_export(
 	struct xfs_mount	*mp)
diff --git a/fs/xfs/xfs_timestats.h b/fs/xfs/xfs_timestats.h
index 418e5abf2cf12..33ea794bdabce 100644
--- a/fs/xfs/xfs_timestats.h
+++ b/fs/xfs/xfs_timestats.h
@@ -8,6 +8,7 @@
 
 #ifdef CONFIG_XFS_TIME_STATS
 extern const struct file_operations xfs_timestats_fops;
+extern const struct file_operations xfs_timestats_json_fops;
 
 void xfs_timestats_init(struct xfs_mount *mp);
 void xfs_timestats_export(struct xfs_mount *mp);

