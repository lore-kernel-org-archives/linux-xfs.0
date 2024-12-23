Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0447519048A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990469; cv=none; b=hvpGi8RA/z0/9HQ53iDe1VSAAcDE6yqVQjUVP5YPuE3q9DY/lMz4ZMdByUg1lhPcyF6KFuvePeICjSI1vCQw1xL2+hsIJC5ifemYhILvw/uGg7bjFAbUYNw3ebtkwzN14o3BpXIRU9ljc174wUQVmRkvr/NdSQAMe7qNdlEke68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990469; c=relaxed/simple;
	bh=akE/wcExpLX95MMF+L9aQW6VQ++Jq3oAyIOZT9m0rVQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ROnwqr2dCgIjO4Hi+gn2EcTbovpSH3w/2o/LqioYO9wUwmNXoC3d8SBx4By1y6VC5+/yAVJk4CLHxhC+ArBW/s/UYWCCzcBzDcm0GyvDfo8koTQtfuBWS0Ss3gRVhp/U1Gs4eF9W+fwErgJw+rD/vMM8uD4+0LO12vW7cVzexNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ilXBBNLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ilXBBNLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0D8C4CED3;
	Mon, 23 Dec 2024 21:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990468;
	bh=akE/wcExpLX95MMF+L9aQW6VQ++Jq3oAyIOZT9m0rVQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ilXBBNLG9H91H/ujK31IFvmPWw8cLHYTwoMYRDUN6qNY1rseJu5JfUKBne45X3G7m
	 B7WEqH+NZJUDtqpq6oBAou5t4QsXIBF6w5mH416yKS96uqyi7QGHi5pKAEpdwSsEOv
	 jqbHADwoht/YJH+hb6DqooIwJxJOKOqmTrRSSv50qO9lMHjPoFqZ4FHjnCWxh4wg4o
	 lDfBu9GJdc/xvEUqv5DjApFAszKvAV8lkvL3X/CKtKNLTic09hN+RCTCkulquRkiT0
	 Qvq8MWpPA7TBNiu1q4InEK+p54DuVPlXMuID4zOpSPtebeT4ZLXzeBB9a0hp6q/UGC
	 ldZX9z57jtOUw==
Date: Mon, 23 Dec 2024 13:47:48 -0800
Subject: [PATCH 05/41] man: update scrub ioctl documentation for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941044.2294268.13829508656235306083.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the scrub ioctl manpage to reflect the new metadir path scrubber.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_scrub_metadata.2 |   44 +++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)


diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 44aa139b297a3b..1e7e327b37d226 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -200,6 +200,50 @@ .SH DESCRIPTION
 Mark everything healthy after a clean scrub run.
 This clears out all the indirect health problem markers that might remain
 in the system.
+
+.TP
+.B XFS_SCRUB_TYPE_METAPATH
+Check that a metadata directory path actually points to the active metadata
+inode.
+Metadata inodes are usually cached for the duration of the mount, so this
+scrubber ensures that the same inode will still be reachable after an unmount
+and mount cycle.
+Discrepancies can happen if the directory or parent pointer scrubbers rebuild
+a metadata directory but lose a link in the process.
+The
+.B sm_ino
+field should be passed one of the following special values to communicate which
+path to check:
+
+.RS 7
+.TP
+.B XFS_SCRUB_METAPATH_RTDIR
+Realtime metadata file subdirectory.
+.TP
+.B XFS_SCRUB_METAPATH_RTBITMAP
+Realtime bitmap file.
+.TP
+.B XFS_SCRUB_METAPATH_RTSUMMARY
+Realtime summary file.
+.TP
+.B XFS_SCRUB_METAPATH_QUOTADIR
+Quota metadata file subdirectory.
+.TP
+.B XFS_SCRUB_METAPATH_USRQUOTA
+User quota file.
+.TP
+.B XFS_SCRUB_METAPATH_GRPQUOTA
+Group quota file.
+.TP
+.B XFS_SCRUB_METAPATH_PRJQUOTA
+Project quota file.
+.RE
+
+The values of
+.I sm_agno
+and
+.I sm_gen
+must be zero.
 .RE
 
 .PD 1

