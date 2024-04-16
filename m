Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D144C7E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230638; cv=none; b=P4GHm1XcJM+4GgZxqHVPgXrN0UUnvxmxkYnpL9tElgkhr6q64cmGgmWRAK6Po6+rpfQbZsBHTc+JSjFyu3ssJzLLAYu9tDCXLjrQyo9WDz8+6RYfaAyoQd9bEIpwA8P0DFsOy61ohYzqrhK8g9iFF3IcH+qHkPqT3YioLtYKCNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230638; c=relaxed/simple;
	bh=/qboZDrDewq92xd5dX+06B4GibNHZVs8eURglI/+mac=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BuVZIXe2AAAI3aU2dXQ5R3uKxomYUsk1zh8ymyAdubDAl5RcIH9DcQMVoq2RhmxFlC2PWLCExhNoC55vsmc7Itny0SNaPQBZ4Kgc+PLMRsm/HpBw9nN//pLGSW8bNF4uMPmj5eOFDQmeciBLNKdePbllLnBxJPADlYnjEzY5Ia0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i94/+gOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i94/+gOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6B9C113CC;
	Tue, 16 Apr 2024 01:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230637;
	bh=/qboZDrDewq92xd5dX+06B4GibNHZVs8eURglI/+mac=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i94/+gOdeNjZr9t7L4M0vFE+uxsuAB9edJNdbw5WMG64rmmfX/g1KR4o/xFXBkYud
	 9XMr/TlL43lnvUePAmp0DCtqbgRbFpAZbuG0IK8lEA+UcZi2Q//N7oawpEnrkjXBFW
	 U/hk4FVl3UlL2cZL4BXYEWb3im4abAO2+gNVOSq6P5XghRqcgvshjVpNbV5iefyWjy
	 IXPLZwvIoQtZeXbP7BOwDTIMkuO3/MagKBT9/fyRC/v2tEAOktTiwCXjWb1rKwcqiF
	 YgNIUK+Fl4wlmHVgCtwJGMTpRMlNxr4H+BGSHSA2yjRsnU5wYM1VJSJ6tiznFHRMJZ
	 yKO26SvP62FWg==
Date: Mon, 15 Apr 2024 18:23:57 -0700
Subject: [PATCH 06/14] xfs: check shortform attr entry flags specifically
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Message-ID: <171323027170.251201.11533427139433278808.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
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

While reviewing flag checking in the attr scrub functions, we noticed
that the shortform attr scanner didn't catch entries that have the LOCAL
or INCOMPLETE bits set.  Neither of these flags can ever be set on a
shortform attr, so we need to check this narrower set of valid flags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 5ca79af47e81e..fd22d652a63a1 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -579,6 +579,15 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		/*
+		 * Shortform entries do not set LOCAL or INCOMPLETE, so the
+		 * only valid flag bits here are for namespaces.
+		 */
+		if (sfe->flags & ~XFS_ATTR_NSP_ONDISK_MASK) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)sfe - (char *)sf,
 				sizeof(struct xfs_attr_sf_entry))) {

