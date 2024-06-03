Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB6C13A416
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442555; cv=none; b=i36IeRnPmA9NL4r7R3cv1aJjtSrX0mC5XK3tM87h60QSeRo64ewCFJd4X+4fwHm02LDk9fMg1ETq9ZutXn8trDFe9X2+qc8nIZI0NciDLvFcv6P2XC8tLla+rmOYWRpEi3bi6muy7fd19a1EN1CBA/Lu7YjcdOaNKoSxT+1bL+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442555; c=relaxed/simple;
	bh=X/B8CnADYTTgPQpFIxU/xFO+czmbCSbGODZZemcUvBg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uwuozQbFJwcT0tJsktmCbJwb+0eAk2hkPEC6EZSYHYdayvNHDZw7p0LaS7tQBslRz2pPtjgj6F2v1845b9/qln1WHvlH79LBeoV3NFi+2tIdy9saS46+qj9BQFkTIV6e5ypEujyKaF6zoNkrfB6PFLwZNL940ywhLiVEW2Y4DB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TeUCJFVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TeUCJFVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E763DC32782;
	Mon,  3 Jun 2024 19:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442555;
	bh=X/B8CnADYTTgPQpFIxU/xFO+czmbCSbGODZZemcUvBg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TeUCJFVDToP6wZFzxX2LVo58k5JImSUOmiPvwHLFKzPEgZhEiJ6THHE7hI+CZMYbY
	 dafKWlT5ALeIt4KIkq6UgGUxNf6Hys0t4GAdWdj9cbt3Pxo4JWDQ6LqQzJsApcTpYa
	 YWZdMIQyJ5+yoOTYnEH4yKl42M99HQcUri0U0LWt79TLla2dxBYqoiZaiN/OxGCT0P
	 ucwstSLy7EVNB3Fdf1A8tkR1IrYSVZuyiFQT5WIwtxkTgEyMydsNQ7TpwhXo+inGnD
	 Ae4DOiA2FO+fZ2ufUYv/LGSjBva3vY+y1HpKSimCAqXEqMUFSP+A+LHu02+R3f2uu6
	 MeLnPZ5Ylljyg==
Date: Mon, 03 Jun 2024 12:22:34 -0700
Subject: [PATCH 1/2] xfs_spaceman: report the health of quota counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744042059.1449674.9977750150242578269.stgit@frogsfrogsfrogs>
In-Reply-To: <171744042043.1449674.18402357291162524859.stgit@frogsfrogsfrogs>
References: <171744042043.1449674.18402357291162524859.stgit@frogsfrogsfrogs>
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

Report the health of quota counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 spaceman/health.c               |    4 ++++
 2 files changed, 7 insertions(+)


diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index 6b7c83da7..f59a6e8a6 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -256,6 +256,9 @@ Free space bitmap for the realtime device.
 .TP
 .B XFS_FSOP_GEOM_SICK_RT_SUMMARY
 Free space summary for the realtime device.
+.TP
+.B XFS_FSOP_GEOM_SICK_QUOTACHECK
+Quota resource usage counters.
 .RE
 
 .SH RETURN VALUE
diff --git a/spaceman/health.c b/spaceman/health.c
index d83c5ccd9..3318f9d1a 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -72,6 +72,10 @@ static const struct flag_map fs_flags[] = {
 		.descr = "realtime summary",
 		.has_fn = has_realtime,
 	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_QUOTACHECK,
+		.descr = "quota counts",
+	},
 	{0},
 };
 

