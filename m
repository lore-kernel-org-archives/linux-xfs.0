Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010555A793
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802454; cv=none; b=P/mqfOT6OaoDUPkPMB28uq8ihJcQLJ8/FK4LDMwEiGOBDsAVdBZ/vh360ok+BvRfROxPmzAMU5dNT9K32plucV+TiJ4cIB4iHNMswZPrkPeYESESvlEgvkT4z4S6Uu+XtvhwMF1vrc8kCkg5F2lS8mNs5Pn7YHWrKtnurBhJjPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802454; c=relaxed/simple;
	bh=Oe9Pd00OjDzkwmcGKySzbDI3c+wJp2rKmIvMFZxHfEM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXDkuuQzZyZCFRaEW4bhFY0ao4ucBoJZU2Sg5RH+4SMj/xsqoFgP6GnQz0xQiROlas6asTHB8tcQxzEcU11p/Vd0mbsyX+hs3NHFfHldJoKthBEDYyhdCUR6nes9UHRc3iOQzp973GrkcTqp9JPeCYG7OvaE+idZHqXUD/CIudY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=KE8vkT6K; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KE8vkT6K"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e032fc60a0so8913205ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710802452; x=1711407252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rO/0pOISkOrmL5/qNziapql2KygT0fMo9B6mjjkEdyI=;
        b=KE8vkT6KomcfKbYEmmpQ81ZDaB38k+9F0wGI7peurRORScg7Abn0B3eYXm20pT+gl8
         xuww2MCeApGAp2hsQa2oqQjYPHfJZQFijhIv4+9kKTGLh+/DNw9ZxGkv6TW/BbY5kWUC
         Vaadf0qkxZEzMTs1MthgNbgKWm2DWC8IMHtY00o4Nd2mjvYHgKxpjabTSGvr3Iy9JZXt
         ZDR2fjQ+a9rGatjuD+jY7NTkH5CK3W2r9kOmApqwgkXrDqDUO9B2akLqBNYoT1P6UTWo
         daCVwwCxNPTXrpV5tWjXE9hPcalfXsvivcv45im5lo1DstPw5czEplRl/bl71ZBi5DJQ
         nXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802452; x=1711407252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rO/0pOISkOrmL5/qNziapql2KygT0fMo9B6mjjkEdyI=;
        b=QaNlDIbC/Y8+sDj5zX5ivEAGUZN3O5VAL8eKSO6+yKU1sPbJlRJyQKmHsD9ZJzDnDi
         zyfsKBO9ezt326pdqVZg5hNmDLvQvJRbMQnXwrt8oqZ8ntYszKtjtXHZeEmxiGc+m3YT
         ZcSN++wV7FZUEFFnJhjYuEusxA1cwcyWoJjOTDTRTb1wJ2l2mykuUlm2JWtgt7y+zGPP
         5rOcaBZ2w4RHqDFf2ORtcq/juWv36kE+eEdWwsnCyfuSm+bJ6AmdJP5RAxjZQB6L29r4
         7Ktj9zMDmWG/xUDS2fwq7MLEaUUCYbmJeydg6NjSkH7Py5RvoKwUGTXHIaSwGS7Wl0P5
         SpJQ==
X-Gm-Message-State: AOJu0YzqOlYCgojfKpUROcFXI1ywI4yhgUQ9Rqf5yykOwzL6WXocUsEM
	UWEpjAtIe4OEbHCxuYu/2XFW7Cc6CL8W1cM8Ys8SSEpWf5N+hNSYhV43HXW0rZfqKVVn9a05ZaG
	U
X-Google-Smtp-Source: AGHT+IHSb7KjNon2igQzSjzLzORb9cGFhjjlHebPK+BwwH+KJKO0Vw6oVN5Tt0S6Zdg7CClEShmiDw==
X-Received: by 2002:a17:902:e544:b0:1e0:e36:5e45 with SMTP id n4-20020a170902e54400b001e00e365e45mr1290794plf.2.1710802452145;
        Mon, 18 Mar 2024 15:54:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id lf11-20020a170902fb4b00b001dccaafe249sm9856834plb.220.2024.03.18.15.54.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:54:11 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmLrt-003o5v-2v
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:54:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmLrt-0000000EB3s-1neT
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:54:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: stop advertising SB_I_VERSION
Date: Tue, 19 Mar 2024 09:51:00 +1100
Message-ID: <20240318225406.3378998-2-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240318225406.3378998-1-david@fromorbit.com>
References: <20240318225406.3378998-1-david@fromorbit.com>
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
Acked-by: Jeff Layton <jlayton@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_inode.c | 15 +++++----------
 fs/xfs/xfs_iops.c               | 16 +++-------------
 fs/xfs/xfs_super.c              |  8 --------
 3 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 69fc5b981352..b82f9c7ff2d5 100644
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
+		atomic64_inc(&inode->i_version);
+		flags |= XFS_ILOG_IVERSION;
 	}
 
 	iip->ili_dirty_flags |= flags;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 66f8c47642e8..3940ad1ee66e 100644
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
@@ -1043,16 +1038,11 @@ xfs_vn_update_time(
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
index c21f10ab0f5d..bfc5f3a27451 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1690,10 +1690,6 @@ xfs_fs_fill_super(
 
 	set_posix_acl_flag(sb);
 
-	/* version 5 superblocks support inode version counters. */
-	if (xfs_has_crc(mp))
-		sb->s_flags |= SB_I_VERSION;
-
 	if (xfs_has_dax_always(mp)) {
 		error = xfs_setup_dax_always(mp);
 		if (error)
@@ -1915,10 +1911,6 @@ xfs_fs_reconfigure(
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

