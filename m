Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC15881E
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666713; cv=none; b=s2NGdyWhn3iSDGM8s8R5RZlXAKyKRBZUseC+FUezKD/STntQ8+C6oVTHP2VoA9zS2SrvXZxF6/h9FY+HTn64ka4CzBWHpuhQuE+OHZl/gzvX/a9qhwLnRIux+3/kGqRVByusmcnqTJCpRG7hfzNGnTHwrENBli4mAL0uHu7nHyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666713; c=relaxed/simple;
	bh=l13/TD/1Joj+LQn85oI816+hudg/RxoGoeATTMMw8Gc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YTGRL76ZmiZmPlhZkdZin8y1He96QAp1sBAIEzFZM/8PrXUN3e5EothT6lyeoYd+TdnyRv/LXW6DuxwPMWsIMV3mVkQBLm5Oea4xxnCOIb89crfA4qw/tSR4Eb74g0/mlbfUc06ErLxO7idq0DWu+Az39YoEnibZ6qbjC2mSF9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TnyuuowL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TnyuuowL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146C1C4CECF;
	Wed, 27 Nov 2024 00:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666713;
	bh=l13/TD/1Joj+LQn85oI816+hudg/RxoGoeATTMMw8Gc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TnyuuowLeOskexZ2+FtmkqBECc7PWFlo3VOVVVGQ7F0DX2TngCejLjXxzv+s4A5mb
	 VBR3uJZ4Ap6dLtCr86nHNS6eovHEIDZhoWqvlGkN2+5UVEUVGb/p8XPagdWpF84P6F
	 drEjY3gpEM+UnO+3CusQJRSuuobYJJOd33p5z0ro+j1EO46BlWlDld3LzjGZUtyK7h
	 jLPWEdza3MjI69WBvEfbUe08OGf6aD2tlnEaV9lqvF62vc3V3xti4Knmk8DoQgHcAX
	 cIuWmgXEL3ER9oWuGW/MO9Q8dRaZy2aHlunkm2LreDh91TWJ4cGkDBxhQfqUTpN74B
	 ppVGVkrEqyEOg==
Date: Tue, 26 Nov 2024 16:18:32 -0800
Subject: [PATCH 02/10] design: document filesystem properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173266662241.996198.11668830686120619782.stgit@frogsfrogsfrogs>
In-Reply-To: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
References: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that xfsprogs utilities can set properties to coordinate the
behavior of other xfsprogs utilities, record them in the ondisk format
documentation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../fs_properties.asciidoc                         |   28 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    2 +
 2 files changed, 30 insertions(+)
 create mode 100644 design/XFS_Filesystem_Structure/fs_properties.asciidoc


diff --git a/design/XFS_Filesystem_Structure/fs_properties.asciidoc b/design/XFS_Filesystem_Structure/fs_properties.asciidoc
new file mode 100644
index 00000000000000..b639aec9ab6366
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/fs_properties.asciidoc
@@ -0,0 +1,28 @@
+[[Filesystem_Properties]]
+= Filesystem Properties
+
+System administrators can set filesystem-wide properties to coordinate the
+behavior of userspace XFS administration tools.  These properties are recorded
+as extended attributes of the +ATTR_ROOT+ namesace that are set on the root
+directory.
+
+[options="header"]
+|=====
+| Property			| Description
+| +xfs:autofsck+		| Online fsck background scanning behavior
+|=====
+
+*xfs:autofsck*::
+This property controls the behavior of background online fsck.
+Unrecognized values are treated as if the property was not set.
+Check the +xfs_scrub+ manual page for more information.
+
+.autofsck property values
+[options="header"]
+|=====
+| Value				| Description
+| +none+			| Do not perform background scans.
+| +check+			| Only check metadata.
+| +optimize+			| Check and optimize metadata.
+| +repair+			| Check, repair, or optimize metadata.
+|=====
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index a95a5806172a0c..689e2a874c13e9 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -84,6 +84,8 @@ include::journaling_log.asciidoc[]
 
 include::internal_inodes.asciidoc[]
 
+include::fs_properties.asciidoc[]
+
 :leveloffset: 0
 
 Dynamically Allocated Structures

