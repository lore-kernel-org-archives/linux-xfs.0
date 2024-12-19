Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A491A9B49
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637189; cv=none; b=uE8gjJUeMqlSMiGm4qtC9WFajutdIMDqQjdidTElzDalCFDGkC6XHuW88Jli507cCiHVxM2peIX/wwo9liumPfcC9HdiyX0Cdl4qm+T1o7U00GMIpIN5hsxOSQVicjFX4CLu30TBXurgf3kZk1syS/KFVg2eVe/q89vDqtil42g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637189; c=relaxed/simple;
	bh=l1We+YfAluaG5JJJbMdvAWFqQwoR7txgSEEFh3clbgI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DBLFInOAc0II50dmJsBbiVtsMpOnpOjE84S1HN6jY+j5c2/V+dU3vaTQ74UmWaT+LDmR6H5HwdOq9VOUD9x1sGvAZjTY7A5XKK+bppoMocQoRxFLzwJzzpWbo8a75gWaWCAIYSxbQ5f6X2HuEIpsgqELntRq/UbEUOWilgW/Lc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xx+EPkq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xx+EPkq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103DAC4CECE;
	Thu, 19 Dec 2024 19:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637189;
	bh=l1We+YfAluaG5JJJbMdvAWFqQwoR7txgSEEFh3clbgI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xx+EPkq666p3zaETq9SHKqV9XkFceAmzOuCXXU4K5aDe0W7MGgqajVCKIpqaSAeu6
	 83Cih3/8gUVEqrhibET/8WksXElgrxm506NxqkHSB9VuEDrhvJJlssCqlZBpcCicpw
	 zY11lgLgbPFr6jrJ+LpOmoHbA13JVXM3BJCWk8gWWVkmQcCYdP3wViLjYTZjpvm3Ic
	 wMfjEwKjdL2lBFQ3Iz9eueiFjcnooMzF4NWBPW18P20zbUStv/IUHllWxABvhLPYLm
	 PwKaPln6/fSXkHL3oP9kezGDLfA9ZONyq1hSZqfGkHpsN+2c0eIU6mWyC8WKmpRrJo
	 fD6wUPBFZocUg==
Date: Thu, 19 Dec 2024 11:39:48 -0800
Subject: [PATCH 26/43] xfs: check that the rtrefcount maxlevels doesn't
 increase when growing fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581423.1572761.8866411896316189478.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The size of filesystem transaction reservations depends on the maximum
height (maxlevels) of the realtime btrees.  Since we don't want a grow
operation to increase the reservation size enough that we'll fail the
minimum log size checks on the next mount, constrain growfs operations
if they would cause an increase in the rt refcount btree maxlevels.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsops.c   |    2 ++
 fs/xfs/xfs_rtalloc.c |    2 ++
 2 files changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9df5a09c0acd3b..455298503d0102 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -23,6 +23,7 @@
 #include "xfs_trace.h"
 #include "xfs_rtalloc.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -231,6 +232,7 @@ xfs_growfs_data_private(
 
 		/* Compute new maxlevels for rt btrees. */
 		xfs_rtrmapbt_compute_maxlevels(mp);
+		xfs_rtrefcountbt_compute_maxlevels(mp);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f5a3d5f8c948d8..a5de5405800a22 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -995,6 +995,7 @@ xfs_growfs_rt_bmblock(
 	 */
 	mp->m_features |= XFS_FEAT_REALTIME;
 	xfs_rtrmapbt_compute_maxlevels(mp);
+	xfs_rtrefcountbt_compute_maxlevels(mp);
 
 	kfree(nmp);
 	return 0;
@@ -1178,6 +1179,7 @@ xfs_growfs_check_rtgeom(
 	nmp->m_sb.sb_dblocks = dblocks;
 
 	xfs_rtrmapbt_compute_maxlevels(nmp);
+	xfs_rtrefcountbt_compute_maxlevels(nmp);
 	xfs_trans_resv_calc(nmp, M_RES(nmp));
 
 	/*

