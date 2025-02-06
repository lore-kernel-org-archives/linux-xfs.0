Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0239B23C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881087; cv=none; b=BTWIDfHUfc47mYaBRT8XejwZSfZDxB89JP4Vdyi/oMEeiWKYvRxsepOYvkxsBvPO475ubt9WzZlPVmuzm/PWeTwlTOjbaZfR6Ive2GKyTyzQmuUrJKzDH3RwV5xaJTZM1/exdE8y1Twn2rF2RW9sL4afCPLfTc9n0twI6oGYGQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881087; c=relaxed/simple;
	bh=A75iD+p2qdMNi7CcjMFVYN/ojm7YOnmP/jjfFEqoEYQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G1btPdc6CXqGehWWN6qHtT5AkafOkNMUg7lSE31OPtR/xNRENSM68r0bGQyNHSAHRKA/xpd6xPTgzr2xFaJNBpJ0fHrj9gngdGTi1VzbmW2yNPY6KnNbaCvurx16gY60JyVJ+wE/nJzZIi0jJ0+mIP+T5YxGbMPYEx7JwmPeGko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aGtiAz25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aGtiAz25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766D2C4CEDD;
	Thu,  6 Feb 2025 22:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881086;
	bh=A75iD+p2qdMNi7CcjMFVYN/ojm7YOnmP/jjfFEqoEYQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aGtiAz25vDITb4laZchIdXyKxnEHgNm6XQEzQNFCTw1ys9tdu8ByxZBIwOjSjwRb7
	 rCivBWXxElroOeD5oz8yKntfZvU1Nh66eZyfJGWdOVQ+AmFWkICDAWxkkHqS96CTnP
	 En+OTApOxk90lsr7DerxARmvIM0CVWgBjush/FwosFQcbWhH/MkgqSH+1XPZPmHt66
	 1t5PJC0Y6kI1N8pO4jw2W98JLgywvl1+6OngkZDxUI2UEMb7Y5wFdvDuyI92GyLref
	 BkFtZFWBOKMVMnoeXpjhJVlpNplH/a5yMihU4ll7iJ/D86Tv5opXfcy01vjQj36trg
	 WkA9T5w+z/VHA==
Date: Thu, 06 Feb 2025 14:31:25 -0800
Subject: [PATCH 03/17] man: document new XFS_BULK_IREQ_METADIR flag to
 bulkstat
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086105.2738568.7689923306499344386.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Document this new flag.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man2/ioctl_xfs_bulkstat.2 |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/man/man2/ioctl_xfs_bulkstat.2 b/man/man2/ioctl_xfs_bulkstat.2
index b6d51aa438111d..0dba16a6b0e2df 100644
--- a/man/man2/ioctl_xfs_bulkstat.2
+++ b/man/man2/ioctl_xfs_bulkstat.2
@@ -101,6 +101,14 @@ .SH DESCRIPTION
 via bs_extents field and bs_extents64 is assigned a value of 0. In the second
 case, bs_extents is set to (2^31 - 1) if data fork extent count is larger than
 2^31. This flag may be set independently of whether other flags have been set.
+.TP
+.B XFS_BULK_IREQ_METADIR
+Return metadata directory tree inodes in the stat output as well.
+The only fields that will be populated are
+.IR bs_ino ", " bs_gen ", " bs_mode ", " bs_sick ", and " bs_checked.
+All other fields, notably
+.IR bs_blksize ,
+will be zero.
 .RE
 .PP
 .I hdr.icount

