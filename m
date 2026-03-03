Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6ADD14AD20
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496854; cv=none; b=epteCHAagxcrfWFqunrgPZtVBDH30bC69ESIrblw7alwevxXDEfGMyVbe8HEgEws9i3igfZSkqBvomUqLwGzoX7d7BQwOsMVd+1OQJi8E7PKvvdxFj/EoWlNcbEACNIfz2v/pim9bF90dgSFWl/vnup+JFWUPE/ggvTsiqcx4FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496854; c=relaxed/simple;
	bh=oJmQ7nliGKSrTP1D9rU3lLs5QxiIlUTxs9c65jsu2WI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uoHlWLlsd2UhauF58EMQcS6LoTBeD+5R5kYyZ3tWrKi2PTaHBb0ty71kJGMhIakRrEFgEBzQyLGJrwKIHELjGR5/Q/G6Z9PuWF9Zr0wtuYHADi3GxfzHFryXf4ZWsw6JUZE2dpbXf/xTa3tFKgkVarZSfCT5gJVHd95eePVtJHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7wAd0xW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7wAd0xW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823EBC19423;
	Tue,  3 Mar 2026 00:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496854;
	bh=oJmQ7nliGKSrTP1D9rU3lLs5QxiIlUTxs9c65jsu2WI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d7wAd0xWX4P15tDhEbWEtPhXPxMLdh/15FcWjU1+y9fZBnLIUGvOAz3q1PDoEEkMk
	 lOwQSfjFCTDClX0hip3e8OHJG16sKOISlVH3ditFRrad5wUWdALL8boM7u+D11OQVQ
	 kiDDorRNzg4TrNn+FDH9gISsN50+GmhkTSPLq/qISgR3YjrYhoaR8tAqCLgfy4Idgu
	 gg1McDSJOVG2LvS3bhQfcUdgIoAz4FFCIkLmLOASrrDTEp3DNN91IDXOwKHCFTGbTW
	 klK4obyr9+GkzOCF7kHngk32Kup0zO2aw2P2H920K7mOVSjrncLkqOOiCvV4cP6LQX
	 0CnUq/W9Aw+Uw==
Date: Mon, 02 Mar 2026 16:14:14 -0800
Subject: [PATCH 08/36] xfs: convey externally discovered fsdax media errors to
 the health monitor
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249637923.457970.794607132382987708.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: e76e0e3fc9957a5183ddc51dc84c3e471125ab06

Connect the fsdax media failure notification code to the health monitor
so that xfs can send events about that to the xfs_healer daemon.

Later on we'll add the ability for the xfs_scrub media scan (phase 6) to
report the errors that it finds to the kernel so that those are also
logged by xfs_healer.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index c8f7011a7ef8ef..38aeb1b0d87b5e 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1014,6 +1014,11 @@ struct xfs_rtgroup_geometry {
 #define XFS_HEALTH_MONITOR_DOMAIN_INODE		(3)
 #define XFS_HEALTH_MONITOR_DOMAIN_RTGROUP	(4)
 
+/* disk events */
+#define XFS_HEALTH_MONITOR_DOMAIN_DATADEV	(5)
+#define XFS_HEALTH_MONITOR_DOMAIN_RTDEV		(6)
+#define XFS_HEALTH_MONITOR_DOMAIN_LOGDEV	(7)
+
 /* Health monitor event types */
 
 /* status of the monitor itself */
@@ -1031,6 +1036,9 @@ struct xfs_rtgroup_geometry {
 /* filesystem shutdown */
 #define XFS_HEALTH_MONITOR_TYPE_SHUTDOWN	(6)
 
+/* media errors */
+#define XFS_HEALTH_MONITOR_TYPE_MEDIA_ERROR	(7)
+
 /* lost events */
 struct xfs_health_monitor_lost {
 	__u64	count;
@@ -1071,6 +1079,12 @@ struct xfs_health_monitor_shutdown {
 	__u32	reasons;
 };
 
+/* disk media errors */
+struct xfs_health_monitor_media {
+	__u64	daddr;
+	__u64	bbcount;
+};
+
 struct xfs_health_monitor_event {
 	/* XFS_HEALTH_MONITOR_DOMAIN_* */
 	__u32	domain;
@@ -1092,6 +1106,7 @@ struct xfs_health_monitor_event {
 		struct xfs_health_monitor_group group;
 		struct xfs_health_monitor_inode inode;
 		struct xfs_health_monitor_shutdown shutdown;
+		struct xfs_health_monitor_media media;
 	} e;
 
 	/* zeroes */

