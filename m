Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881A78C11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302957; cv=none; b=E4uozGOADsVeWZhGYWCc1aBVUqLQOTubMeLqzlop0yifLgo92HLxz8euUteqhbbgPPdM9lrpDQSY4RibzCKjr32ZiWCAf2vZFwsSLCNdHZJDJy88f3fqIdT+NRY4NtocQcIjgDGIoBfowAQLtM9Hm5KtwHaQlOklMIWLCIJYLog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302957; c=relaxed/simple;
	bh=1XH7XJXs0mPAwgpyQMYwgaWzhNC2b1KmVVPdx1U8i00=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rW/+dmsCXLrnfmuCYG9Fk0TI/miIyPnphzy5eKYtEIApfruvuYMuV8XLPhKslbFzYaF4BourdWTDCmPsJ95Q1vGympEVGWCyCEmG/IkGVVLO0mnsrbfwSf3NrRySeczx5A790636xTvtxc9OC/RX5w0O+6NIuNRmCy8I8/wuUko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3Az2PnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3Az2PnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BC1C32786;
	Tue, 30 Jul 2024 01:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302957;
	bh=1XH7XJXs0mPAwgpyQMYwgaWzhNC2b1KmVVPdx1U8i00=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y3Az2PnBYS7jhBfWYhf6JJ7V0grCRqFvwA3/KdjElKVgwFPIAXFLt+lSegdslpklf
	 KM6SHVpv4diHS4WDr1SKUcNeBWUlZrHS3CjSKuM086mGDrejKr6DCUicd/WMP7egsH
	 Y54LsgyfGItYOs1h6pJMWiD6ju0o3+E1BrFwmhGYAo1QexwD2IT7gsSynO+udg/epA
	 I2kqs5nGeY7wtvFYlA1K6WibmbAsUwqOr00244aVrejWiKP+zdBwaEWAwp1igfNJ5q
	 MOwL0c/nlGF2iaFUYX8I9HcnEiKYLiVFgozsqMBrdqEpEyItTCZ0IcRol/28rZRfKI
	 ey9vCCBM+H/Ww==
Date: Mon, 29 Jul 2024 18:29:16 -0700
Subject: [PATCH 2/5] xfs_spaceman: report directory tree corruption in the
 health information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229851994.1353015.3930505983118882991.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851966.1353015.1969020594980513131.stgit@frogsfrogsfrogs>
References: <172229851966.1353015.1969020594980513131.stgit@frogsfrogsfrogs>
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

Report directories that are the source of corruption in the directory
tree.  While we're at it, add the documentation updates for the new
reporting flags and scrub type.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_bulkstat.2   |    3 +++
 man/man2/ioctl_xfs_fsbulkstat.2 |    3 +++
 spaceman/health.c               |    4 ++++
 3 files changed, 10 insertions(+)


diff --git a/man/man2/ioctl_xfs_bulkstat.2 b/man/man2/ioctl_xfs_bulkstat.2
index 3203ca0c5..b6d51aa43 100644
--- a/man/man2/ioctl_xfs_bulkstat.2
+++ b/man/man2/ioctl_xfs_bulkstat.2
@@ -326,6 +326,9 @@ Symbolic link target.
 .TP
 .B XFS_BS_SICK_PARENT
 Parent pointers.
+.TP
+.B XFS_BS_SICK_DIRTREE
+Directory is the source of corruption in the directory tree.
 .RE
 .SH ERRORS
 Error codes can be one of, but are not limited to, the following:
diff --git a/man/man2/ioctl_xfs_fsbulkstat.2 b/man/man2/ioctl_xfs_fsbulkstat.2
index 3f059942a..cd38d2fd6 100644
--- a/man/man2/ioctl_xfs_fsbulkstat.2
+++ b/man/man2/ioctl_xfs_fsbulkstat.2
@@ -239,6 +239,9 @@ Symbolic link target.
 .TP
 .B XFS_BS_SICK_PARENT
 Parent pointers.
+.TP
+.B XFS_BS_SICK_DIRTREE
+Directory is the source of corruption in the directory tree.
 .RE
 .SH RETURN VALUE
 On error, \-1 is returned, and
diff --git a/spaceman/health.c b/spaceman/health.c
index 6722babf5..d88a7f6c6 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -165,6 +165,10 @@ static const struct flag_map inode_flags[] = {
 		.mask = XFS_BS_SICK_PARENT,
 		.descr = "parent pointers",
 	},
+	{
+		.mask = XFS_BS_SICK_DIRTREE,
+		.descr = "directory tree structure",
+	},
 	{0},
 };
 

