Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7798C143C5F
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928935; cv=none; b=AX4vX7/BjE4Yfm7vKLM9hHMTqa4tniAtgBZ8sK0vFgHEigRM349rwIbeYkqrvujdJ4UGxhJvad248h55oYFWxWa5zE0JcetTSJmHzKbSP3W1u/2hler0eJymr3PI0mq3AcjgU9FFjjm4KZCne1Pchnq0DETokWL5Q1BvQv3EfeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928935; c=relaxed/simple;
	bh=S003xPymKVE/vFtFcbDsEfkIVVu9+1NX25L6nK6OpT8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iXNlOPxsrXRa/gO+QeOHrfeT/zUlmS63FZYSQbR4z8SNyZB+w0ItLrkicCxrheDAn6U02o9QGNm/KJ8D9HrzNhA7hr+rptA6/9K31uuFnu7THPGK/ktNNZz6X0+/8GrGkDbKfpY4tZsPULJiuEBblgsvxMgn+j3K2dRTlbkWzl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9JoCl09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9JoCl09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1080AC2BD11;
	Wed, 24 Apr 2024 03:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928935;
	bh=S003xPymKVE/vFtFcbDsEfkIVVu9+1NX25L6nK6OpT8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u9JoCl09wcKhRDLHt6BoPIOVR4JXHDq5ncAriAKDPm/rTIHx/hP5LKyPeLV5VDQOm
	 5drSqempQo8rcuJsFiaQ54TwVEKrHLj7ELTExehGS7ejYbKaYN0FDhBelK+iqtObH9
	 Hw2qtSjw9HXaDm7fLToEPiuqL0+tay9eFh0hZaqAt6mL+KqQSwjd1Mx7lKPBzLE8zY
	 9n8SmA6rBCwZgRd2F+0LOaN6db5BZesXjniKhxL7ogxZotqP91Uft6l6lySUK3kmOO
	 Tyj4sA29/mhSSceaOOMm+FahRnns8oUaqmKcH/Dl3+hFE5Fre+FRH/BEW63Op+rDIc
	 BDqQCJEurWiKQ==
Date: Tue, 23 Apr 2024 20:22:14 -0700
Subject: [PATCH 7/7] xfs: check parent pointer xattrs when scrubbing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784256.1906133.10044802023458565259.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784119.1906133.5675060874223948555.stgit@frogsfrogsfrogs>
References: <171392784119.1906133.5675060874223948555.stgit@frogsfrogsfrogs>
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

Check parent pointer xattrs as part of scrubbing xattrs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 393ed36709b3..b550f3e34ffc 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -17,6 +17,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_sf.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
@@ -208,6 +209,13 @@ xchk_xattr_actor(
 		return -ECANCELED;
 	}
 
+	/* Check parent pointer record. */
+	if ((attr_flags & XFS_ATTR_PARENT) &&
+	    !xfs_parent_valuecheck(sc->mp, value, valuelen)) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+		return -ECANCELED;
+	}
+
 	/*
 	 * Try to allocate enough memory to extract the attr value.  If that
 	 * doesn't work, return -EDEADLOCK as a signal to try again with a
@@ -219,6 +227,14 @@ xchk_xattr_actor(
 	if (error)
 		return error;
 
+	/*
+	 * Parent pointers are matched on attr name and value, so we must
+	 * supply the xfs_parent_rec here when confirming that the dabtree
+	 * indexing works correctly.
+	 */
+	if (attr_flags & XFS_ATTR_PARENT)
+		memcpy(ab->value, value, valuelen);
+
 	args.value = ab->value;
 
 	/*

