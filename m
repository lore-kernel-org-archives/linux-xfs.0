Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327B52837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995428; cv=none; b=BnH9P9xcW7lcnmyHqp29QkAmv6yBGe0AxYBJzTsOejlKFPqVMW9D867yQ5ixZQEndbd5vBG6Bv9MzyHY8nR8uwrrXRE5v6SESQxSJQh+pxceAH9R7Njea5CeRC/KM94nD81RARWze4WOt/1kbHdEX3/bCBk79pqSYhVYsgi4ikI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995428; c=relaxed/simple;
	bh=Jtokb0PVehQconv58gAy6SaT+6s4nqyAG3KPe1xRR5A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=guFbq0ozan+C+/kOiuRSVeCxUquU4YJdLce8T4kBVhEv3KM0HXXPHzUcgArxtwISskKPPHt+1XpRL5uoAU/rERD5Xwvy9IrvO/cdRBfOH0bZsMNI4C/6h+JsFcM5PgXkGVfpKkJNshATLzjtCjGIJtbYnqN4loze6Qz8QbC/z8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ea33yfCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ea33yfCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08890C4CED3;
	Mon, 23 Dec 2024 23:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995428;
	bh=Jtokb0PVehQconv58gAy6SaT+6s4nqyAG3KPe1xRR5A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ea33yfCCHz6JHEHmwhuQ6cU7o/7jDHhwqNcgRIUMVflfpHXAM4q5kHo5QQM7W4cBW
	 cS42PNGGNg+vOtQBi2OkW3l2DAdbRbOb8aCYwPWFAnmnHLluD7QF5LdTSZZZltt7LH
	 W+zKNR0ZIZXAcA+2g4L5RBB7ieABks1Ss+fQC09kdyEEGsAopHf6l9E7eU+IJfHbbV
	 8a4k1yyq4fJ+uQhML0xtdHPwJlDSKOq6v4Uc7yuyB+t9YJkwM5qIMsnCcnRopzRNMn
	 vW1fLEuFg3yyGzw+xKT+hbpA5YKfDiJb8ytCBWqrkAKE2kSpohOI4EcKsOErWJD9qd
	 JnW5gtjIWfJaA==
Date: Mon, 23 Dec 2024 15:10:27 -0800
Subject: [PATCH 16/43] xfs: update rmap to allow cow staging extents in the rt
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420214.2381378.14281983118268217253.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Don't error out on CoW staging extent records when realtime reflink is
enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rmap.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index f8415fd96cc2aa..3cdf50563fecb9 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -285,6 +285,13 @@ xfs_rtrmap_check_meta_irec(
 		if (irec->rm_blockcount != mp->m_sb.sb_rextsize)
 			return __this_address;
 		return NULL;
+	case XFS_RMAP_OWN_COW:
+		if (!xfs_has_rtreflink(mp))
+			return __this_address;
+		if (!xfs_verify_rgbext(rtg, irec->rm_startblock,
+					    irec->rm_blockcount))
+			return __this_address;
+		return NULL;
 	default:
 		return __this_address;
 	}

