Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A9F53BE
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300858; cv=none; b=o94r4/tcZwYFTEbbvWfckX2qQ8WO/cJsFK/vxi6gdCMXsdXq+YaxcgwptDNh+V0PHBuAKLFGqTvzMiYoHAAKlmBzZExSCuk7mVq1ryQSm/E1Olgf04qbZi9wJWrLDF80gijUDcRAuS/WF4YnAxM4yoOfaxGBm8WsD61Sd5KQ2QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300858; c=relaxed/simple;
	bh=IAjA5NKtkvh4XQgQkOS7h2tbQNOuHu+9UVEv27woPZc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQQW8U5AWHtotRNXxTPBePMXxWHNOkX2V/aSHkQHan9zgT60YUt9cCgzbLXBPcvHjiJN/Vi/wISDMB6PtHv3/3/PVLyyVQvCDltZieyHgQYaKLVNOPTFdAr2zPVOFdbbkx0sTMCqrIAMrIkooTnAXlPpaOuhZtRTbODBhpwiWEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/O3TZ1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/O3TZ1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F9DC32786;
	Tue, 30 Jul 2024 00:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300858;
	bh=IAjA5NKtkvh4XQgQkOS7h2tbQNOuHu+9UVEv27woPZc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g/O3TZ1mPKDb4JOA2Pg/XaUNhXUkIw02y0siLP2XtvHB2ey+9KQDxjiAlGnPp9mEO
	 T0UpUsGPk3NYxLwDezOyFq1vSbbxMSecG0BRN+EE3X3Wps66uv+NQSluI5vVTvmjhB
	 LM06ld1gGGCIhcBy8bXgtIr4n4duBb5yhlBZ+RlImVRCITCKlbspTI9G/GmoOZvDuz
	 K8h5pqzJ/WIigjiG3c2lgL6PWJrYHZmL3YchS2yOmUwnjAA7OTbjnwN8PgWcCVReOe
	 MUhj5pG2zNm04+r2rCdEdfODgO62XuFOHBF2cCXHk8VGLYR2rGINKmEXoDrW+VFwqJ
	 lVBnNo7X1RB6g==
Date: Mon, 29 Jul 2024 17:54:17 -0700
Subject: [PATCH 02/12] man: document XFS_FSOP_GEOM_FLAGS_EXCHRANGE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229844432.1344699.803286273218599484.stgit@frogsfrogsfrogs>
In-Reply-To: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
References: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
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

Document this new feature flag in the fs geometry ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index f59a6e8a6..54fd89390 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -211,6 +211,9 @@ Filesystem stores reverse mappings of blocks to owners.
 .TP
 .B XFS_FSOP_GEOM_FLAGS_REFLINK
 Filesystem supports sharing blocks between files.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_EXCHRANGE
+Filesystem can exchange file contents atomically via XFS_IOC_EXCHANGE_RANGE.
 .RE
 .SH XFS METADATA HEALTH REPORTING
 .PP

