Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292955A780
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798715; cv=none; b=Tz3Wo2LYFH2eIUSgAMLoCL4G7cXJte/8FOvkS0Yiqj/6M/4FKbD8bSQm32evH5/L8WFVL4g2JzDDK8VItB0c6ASEGUgG2ifNPmEYx85j08Nhw6saf13rFm7o1dSb158ZlFXY3kCAA5FDhrtCSVIPjF65vveDS+gGv3PBiAzJcEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798715; c=relaxed/simple;
	bh=Chvih5W3ZdRw5X46mYiIaYZD9QJC2I3H8rOuaROZjOI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e0Wst9DSRHHBzFIjO1W3mNK6fFuQLQ1fojOmO380soPD6j32XoKe7DmvV1rJ6z2QPJV6EsTiKijHiYZRaptZLWdYYq5tM9xXJXy7jy4yoqfPlNmHFqk1vhzr1h9g/SATT54QBdX3NBUmbtX2lGu4TSML3fUZkytDPt1m0K7c4Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WvW42jGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvW42jGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CF3C433F1;
	Mon, 18 Mar 2024 21:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798715;
	bh=Chvih5W3ZdRw5X46mYiIaYZD9QJC2I3H8rOuaROZjOI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WvW42jGJ5vuQXcv7IYrLFh7WCxeGbNHFnw4rgNqaUc8Qq1xvGFSZLkGMq/mNnJ272
	 h7Ek3JhXc67ot47DtiIYv/84O9YL5rtdXPkjamyxOaeJGmjFRQteaTOIaDgAjSgMda
	 7eeyXjvtPYiNCq5xM30mdiHcXn+GORUbta7xwOTglD0lzMlFiqeYJKHgDROc5V0htI
	 zJbvaKa6OhaL1Qpe6OtQ+t1sk7VAmePCcS0cIxvPXPM2dflUYweVlqe3NrjBsSZ3Jc
	 /SPRO02LcCXredqi1ZY7/pM1Nhc8jahThIsBOyeVSBqDJW2BTfnbnXOSfEtsXWGfaV
	 r9DG3MhlHuW2A==
Date: Mon, 18 Mar 2024 14:51:54 -0700
Subject: [PATCH 15/23] xfs: replace namebuf with parent pointer in parent
 pointer repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802938.3808642.10152681201356049071.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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

Replace the dirent name buffer at the end of struct xrep_parent with a
xfs_parent_name_irec object.  The namebuf and p_name usage do not
overlap, so we can save 256 bytes of memory by allowing them to overlap.
Doing so makes the code a bit more complex, so this is called out
separately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/parent_repair.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 1e68bd9e2872f..a66aaafa6c717 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -24,6 +24,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_health.h"
 #include "xfs_exchmaps.h"
+#include "xfs_parent.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -63,8 +64,12 @@ struct xrep_parent {
 	/* Orphanage reparenting request. */
 	struct xrep_adoption	adoption;
 
-	/* Directory entry name, plus the trailing null. */
-	unsigned char		namebuf[MAXNAMELEN];
+	/*
+	 * Scratch buffer for scanning dirents to create pptr xattrs.  At the
+	 * very end of the repair, it can also be used to compute the
+	 * lost+found filename if we need to reparent the file.
+	 */
+	struct xfs_parent_name_irec pptr;
 };
 
 /* Tear down all the incore stuff we created. */
@@ -236,7 +241,7 @@ xrep_parent_move_to_orphanage(
 	if (error)
 		return error;
 
-	error = xrep_adoption_compute_name(&rp->adoption, rp->namebuf);
+	error = xrep_adoption_compute_name(&rp->adoption, rp->pptr.p_name);
 	if (error)
 		return error;
 

