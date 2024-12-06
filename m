Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D31E1C548A
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528442; cv=none; b=jEYrG1JAbG++Ps7WaLnxLIHQs4Odfed2CBsXT6Dvq5rzq+vULO8wwFu/Btkl5AlHjDfIEb4f8w1Ao05oINR6Ssa+gSESWGnNgXlANyQY7dTiQE+nUu0TEgfk4h2k65dJrVuo08PD9HObJyWeNXGu93lPsf5X2f+efRLSQ6DaJ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528442; c=relaxed/simple;
	bh=uiE/6SyTGtbU77ImqE1e+LI3lK8vyEtl/VMQfMlydDo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YczQITZuV5CxZMvAXcmMynII3Bfjv0Q4AhytVVWj9dZ0PFJ3lgBssVBgoGi+xsnd/2628FGkt8HKjF8ek+Vw+UU3R/dq2UAfd/i6Mm4vg4//BBlU+EoMAlxNXPnG0dDcwiyeR2HRUxF9L+nVaa/xX8HplLOWcaV4FcbbkiPvoiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HnQuenTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HnQuenTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D09C4CED1;
	Fri,  6 Dec 2024 23:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528441;
	bh=uiE/6SyTGtbU77ImqE1e+LI3lK8vyEtl/VMQfMlydDo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HnQuenTqFDjBdYSsFftcPJWAEnjAYhj4FV648PCeQkwDZ3o68qqf/4nYbRnjNv66P
	 u8T6wy8xuzRAcQVVY+H5BrzHK0fr0NsnqVTMcfTto0emRt3JuzmfUNMxoZ1DYDib9E
	 xMLIjcrw7FknzXrA8cW5JYE8fEkGvvk7kRzUyDMgHHUMYa+AyFELit6y+cGFaXl4rs
	 uuepimRFmPLw3bu9n3rta0MfmxjXTunr1EcjkkPGvV41RUGiUY7SzBQhGAOtE2b0on
	 LIKdKAOQDDvzZmHIn8JrWNLVs32dLBwis/XtlAd/eZ1uLpGr2cakyifhPw49z0sFeK
	 ZCjyCJk/aqT/A==
Date: Fri, 06 Dec 2024 15:40:41 -0800
Subject: [PATCH 04/41] man2: document metadata directory flag in fsgeom ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748300.122992.7800701995690791823.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Document the additions to the fsgeometry ioctl for metadata directory
trees.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index db7698fa922b87..c808ad5b8b9190 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -214,6 +214,9 @@ .SH FILESYSTEM FEATURE FLAGS
 .TP
 .B XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE
 Filesystem can exchange file contents atomically via XFS_IOC_EXCHANGE_RANGE.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_METADIR
+Filesystem contains a metadata directory tree.
 .RE
 .SH XFS METADATA HEALTH REPORTING
 .PP

