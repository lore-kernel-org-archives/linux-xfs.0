Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4E420332
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 04:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709094545; cv=none; b=JrogoC5Fjo1+ElMZPuu9vyJe4/FHaWbaiamD3vIP/w6NJTeWoajpfaRem87HVLeYGtIbq0I+edHTbAJ7D3jvBQ7c7+q7OeAmgAh2xJRs/u3rFJPqnuf5bB26uJOKfNCszvYnGty9CL2XQ1a545C7Ng9qVzGvs5Ou2d6bCfM7iYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709094545; c=relaxed/simple;
	bh=RnJbLG/wCSkflRTJ9DXhmGmjhg+znrGK9pG1gnnWZYo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hALcb/buXKmkCKt8AvAvC7acbxmGKpA0Vqg9XF2AOKR7uufnRCxj4QmAna60s+xpEvvzMjVXLzn+ylHrkwpAc2Y9d0mfev1JgLHXODcirr1ZnD1BEuXu16WUjGSfmMoV4BHwpDn+HDKttC88OjAAuLYduv2vcUzy7TcVi7Ijv1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AhMEiNXp; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AhMEiNXp"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e55bb75c9eso471940b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 20:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709094543; x=1709699343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GvLGVDkXeXw8ikqc8FjmbAfxHoB2MC+jPP1CVgaet+0=;
        b=AhMEiNXp7v91JBCAj4iUjFXE55EOMk+6JS8JLjUygRiADj/AwgGDoccMsiuTQf+DAG
         yv3ZpXDxT1KnEW4rcrZQQNP+Ow6qmNrSCE7XOcPco2dao6vhGEAyvqIMaIUR48bsJc8F
         VakkQTMPvN6U2hdsBwSQlZyV2ZDessKTa8WxzCFjIeTWNeoz+d6fR2HPecd9V25ANPi+
         gXOVoTpKMMDAthR8TpB1xwvE3SP5jxWOMIxJcbe56UQrri6mfd5/a8yuaFHXgByirNYT
         iYMyALHz0G3T2fJxN+MT7sK086w+wdUWPHqY76wlupRGOXSMFmteU1te2eA0/NTYilE9
         zapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709094543; x=1709699343;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GvLGVDkXeXw8ikqc8FjmbAfxHoB2MC+jPP1CVgaet+0=;
        b=J0KJtBfJ2SvkDqHtsOb6ZmJ0JpC9lTRtGb+15PbbNnqSyZZzYDhWGH+ueFJKfzaLtl
         22lJPbfu42W3FXZNVPmAio/6JWMkKppfsb5/C4YG8tMXc5IyCakmPipvlSWbI/oqRwox
         7IjNtmk7DMwJBSjMiPH8S6ECs6rC3OvJNmDj8Mubudi23xIS+ZkciCJhKsv9yRdsgGCs
         wzwQR4HQsVUJxkcs1+29A9c6APrx8LnhQbw8OmnGHS2cxstSG19bHgZd4PGUXOMfjF2E
         7gpQwQN4iXgvzGX+DJrPhYtOxAcRbKNB/4QpiI/YqoyuFLYIBJymkGbSswpuSzt7J0b4
         qc0Q==
X-Gm-Message-State: AOJu0YxYuR7rp+/eirMhVXz82KvSjm4hvGlzPDEYQBF7OMDd1FpSdQgL
	NDlV6QovcBzX+j8TWLTFbU/r25ccX+R3EV9FcfSeKuo9Unz/DMelOEqImSPCgBCydBCqNIlThG7
	Q
X-Google-Smtp-Source: AGHT+IHGltB03n+8ycK0QOrhos4kvlvRUvr4hRXHQgj7JMMy/aENjVTtsGay5RSsDGC2fJ6Qcd4f4w==
X-Received: by 2002:a05:6a00:80df:b0:6e5:571d:a60a with SMTP id ei31-20020a056a0080df00b006e5571da60amr2148696pfb.5.1709094542767;
        Tue, 27 Feb 2024 20:29:02 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id i2-20020a056a00004200b006e558416202sm861787pfk.148.2024.02.27.20.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 20:29:02 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rfBYy-00CVVl-0F;
	Wed, 28 Feb 2024 15:28:59 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rfBYx-00000003Wwm-2O5b;
	Wed, 28 Feb 2024 15:28:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] xfs: stop advertising SB_I_VERSION
Date: Wed, 28 Feb 2024 15:28:59 +1100
Message-ID: <20240228042859.841623-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

The redefinition of how NFS wants inode->i_version to be updated is
incomaptible with the XFS i_version mechanism. The VFS now wants
inode->i_version to only change when ctime changes (i.e. it has
become a ctime change counter, not an inode change counter). XFS has
fine grained timestamps, so it can just use ctime for the NFS change
cookie like it still does for V4 XFS filesystems.

We still want XFS to update the inode change counter as it currently
does, so convert all the code that checks SB_I_VERSION to check for
v5 format support. Then we can remove the SB_I_VERSION flag from the
VFS superblock to indicate that inode->i_version is not a valid
change counter and should not be used as such.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_inode.c | 15 +++++----------
 fs/xfs/xfs_iops.c               | 16 +++-------------
 fs/xfs/xfs_super.c              |  8 --------
 3 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 70e97ea6eee7..8071aefad728 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -97,17 +97,12 @@ xfs_trans_log_inode(
 
 	/*
 	 * First time we log the inode in a transaction, bump the inode change
-	 * counter if it is configured for this to occur. While we have the
-	 * inode locked exclusively for metadata modification, we can usually
-	 * avoid setting XFS_ILOG_CORE if no one has queried the value since
-	 * the last time it was incremented. If we have XFS_ILOG_CORE already
-	 * set however, then go ahead and bump the i_version counter
-	 * unconditionally.
+	 * counter if it is configured for this to occur.
 	 */
-	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags)) {
-		if (IS_I_VERSION(inode) &&
-		    inode_maybe_inc_iversion(inode, flags & XFS_ILOG_CORE))
-			flags |= XFS_ILOG_IVERSION;
+	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags) &&
+	    xfs_has_crc(ip->i_mount)) {
+		inode->i_version++;
+		flags |= XFS_ILOG_IVERSION;
 	}
 
 	iip->ili_dirty_flags |= flags;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index be102fd49560..97e792d9d79a 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -584,11 +584,6 @@ xfs_vn_getattr(
 		}
 	}
 
-	if ((request_mask & STATX_CHANGE_COOKIE) && IS_I_VERSION(inode)) {
-		stat->change_cookie = inode_query_iversion(inode);
-		stat->result_mask |= STATX_CHANGE_COOKIE;
-	}
-
 	/*
 	 * Note: If you add another clause to set an attribute flag, please
 	 * update attributes_mask below.
@@ -1044,16 +1039,11 @@ xfs_vn_update_time(
 	struct timespec64	now;
 
 	trace_xfs_update_time(ip);
+	ASSERT(!(flags & S_VERSION));
 
 	if (inode->i_sb->s_flags & SB_LAZYTIME) {
-		if (!((flags & S_VERSION) &&
-		      inode_maybe_inc_iversion(inode, false))) {
-			generic_update_time(inode, flags);
-			return 0;
-		}
-
-		/* Capture the iversion update that just occurred */
-		log_flags |= XFS_ILOG_CORE;
+		generic_update_time(inode, flags);
+		return 0;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6ce1e6deb7ec..657ce0423f1d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1692,10 +1692,6 @@ xfs_fs_fill_super(
 
 	set_posix_acl_flag(sb);
 
-	/* version 5 superblocks support inode version counters. */
-	if (xfs_has_crc(mp))
-		sb->s_flags |= SB_I_VERSION;
-
 	if (xfs_has_dax_always(mp)) {
 		error = xfs_setup_dax_always(mp);
 		if (error)
@@ -1917,10 +1913,6 @@ xfs_fs_reconfigure(
 	int			flags = fc->sb_flags;
 	int			error;
 
-	/* version 5 superblocks always support version counters. */
-	if (xfs_has_crc(mp))
-		fc->sb_flags |= SB_I_VERSION;
-
 	error = xfs_fs_validate_params(new_mp);
 	if (error)
 		return error;
-- 
2.43.0

