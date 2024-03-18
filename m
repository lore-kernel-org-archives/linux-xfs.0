Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBCE5A795
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802454; cv=none; b=ba23OSd7IRlxj3sHp0rJ7UOawfub3UJru6BEghZws9cTgEXMVtPR1a0o50KWfij5fGGgPWEFmctIx/sqNQDOqbzto1qQNkMCMDnjKcP30RhgW0kouvdbSaugsFewiZYMYrhyxSDAXeal+gRHYPjCgAoM9Wwso41PmIFxN1yRo94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802454; c=relaxed/simple;
	bh=K+hXIRmj2UrqHnFyP6YOpZV/9Jj4MJQ7dL8qJxEcEM8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqSTaPWJkV8gW0fTzpvd9GFIscwMEgHG84IUrea29x9OeVza8btYywLT0SpVjOK+AJncVIcejgRv9Q9Hnsp+GGBMjJiEb3cf0JOGMgR1J4do71QAf3ReSusM4P3Hma+E48g+WbmwAuK71q2LGaOX1MMBHvexz4NtXlwacI3BWVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=MIGBWTg/; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="MIGBWTg/"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dffa5e3f2dso13176635ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710802453; x=1711407253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vPNKjwUcyb/YsrwpN4HG+VqW4M0Dkp32DMXWxQ+ABjM=;
        b=MIGBWTg/Hc8ljNw+kz0UoVodJnogAV+BEkxXFnXLWqv8153lF9GbCU+ddK/+fisimp
         GUnAleDe6f1Ng0kPAXbzm8wTGtxlxReLScB2203ITAZd6qPESVIzYC6eRtOm/VHKrzK5
         oSLTOMZ56uvGZMiTQHh4Kst0jbBraUZBdJ4mYpbt284/4HLVaxVacjOIJ77TR03Nnh0x
         c+pC8DdaQM26CbVnGDRIKjRRddR7fDJvTn47+9k5KxjwGC0FiatzOUZuCMLtsim8H84t
         gs5wfGMVfypyMN339o+LatdsSX131fegu/jIR+EuDmMggZ+b+q8pPUB019Dovs+Nf3BR
         cmjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802453; x=1711407253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vPNKjwUcyb/YsrwpN4HG+VqW4M0Dkp32DMXWxQ+ABjM=;
        b=ooc70flOx6hB6LbKc7VYjp50K0i8/P/bFQzrFMl0uver62RWljXFVcH+a9VJN2yaZ4
         hdbkRrBbVxjFqiBXEByOKUSJXrDtHKKYIz3n+1yy8KonOmpAtHyXMjO9G/F7X2mTpPD4
         ZOsqoYRb01quz0kifArIjJhL5gd0XrJvI/fLHKB362oIfWG7+wz1ikNYerMk+LRnukIY
         QgjbI74fXnWVYrVLqOMVT+Z2+sw6mteq7xfiCI8YwZRTAQiDCcw0SWH1ottsf+RiDp51
         J9LfZv3ng5vl2Mt6wMNKD3Aao79yq24JaQtw9Rd34UMpRl+H4LVC7DfbbcprzBTpcWY7
         6Nvg==
X-Gm-Message-State: AOJu0YwCO87ydOUU99PG5pNatikyyBOCtRmoE3sbEyv6Y0OriFUYdmx4
	VagtmUdG2ZESiauqWNRtauZswnPjT/ql0KPZqLb52DMcwRGUoJy63xSUfQuLXv7KYgSBZ6iD7KR
	B
X-Google-Smtp-Source: AGHT+IEUmuZZJgKhWgB1Xm4glkbekdEfv2hk8CqCXepcdPPgnTP+ROyoUPuL0d4Fch3hvfK6ZcJ3AA==
X-Received: by 2002:a17:902:ecc9:b0:1e0:2377:b23c with SMTP id a9-20020a170902ecc900b001e02377b23cmr1220454plh.51.1710802452564;
        Mon, 18 Mar 2024 15:54:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d9d4375149sm9934951pld.215.2024.03.18.15.54.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:54:11 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmLrt-003o5x-31
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:54:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmLrt-0000000EB3w-1woq
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:54:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: internalise all remaining i_version support
Date: Tue, 19 Mar 2024 09:51:01 +1100
Message-ID: <20240318225406.3378998-3-david@fromorbit.com>
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

Now that we don't support SB_I_VERSION, completely internalise the
remaining usage of inode->i_version. We use our own internal change
counter now, and leave inode->i_version completely unused. This
grows the xfs_inode by 8 bytes, but also allows us to use a normal
uint64_t rather than an expensive atomic64_t for the counter.

This clears the way for implementing different inode->i_version
functionality in the future whilst still maintaining the internal
XFS change counters as they currently stand.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c   | 7 ++-----
 fs/xfs/libxfs/xfs_trans_inode.c | 5 +----
 fs/xfs/xfs_icache.c             | 4 ----
 fs/xfs/xfs_inode.c              | 4 +---
 fs/xfs/xfs_inode.h              | 1 +
 fs/xfs/xfs_inode_item.c         | 4 +---
 fs/xfs/xfs_iops.c               | 1 -
 7 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 68989f4bf793..cadd8be83cc4 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -20,8 +20,6 @@
 #include "xfs_dir2.h"
 #include "xfs_health.h"
 
-#include <linux/iversion.h>
-
 /*
  * If we are doing readahead on an inode buffer, we might be in log recovery
  * reading an inode allocation buffer that hasn't yet been replayed, and hence
@@ -244,8 +242,7 @@ xfs_inode_from_disk(
 		xfs_iflags_set(ip, XFS_IPRESERVE_DM_FIELDS);
 
 	if (xfs_has_v3inodes(ip->i_mount)) {
-		inode_set_iversion_queried(inode,
-					   be64_to_cpu(from->di_changecount));
+		ip->i_changecount = be64_to_cpu(from->di_changecount);
 		ip->i_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
 		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
 		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
@@ -339,7 +336,7 @@ xfs_inode_to_disk(
 
 	if (xfs_has_v3inodes(ip->i_mount)) {
 		to->di_version = 3;
-		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
+		to->di_changecount = cpu_to_be64(ip->i_changecount);
 		to->di_crtime = xfs_inode_to_disk_ts(ip, ip->i_crtime);
 		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
 		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index b82f9c7ff2d5..f9196eff6bab 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -15,8 +15,6 @@
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
 
-#include <linux/iversion.h>
-
 /*
  * Add a locked inode to the transaction.
  *
@@ -87,7 +85,6 @@ xfs_trans_log_inode(
 	uint			flags)
 {
 	struct xfs_inode_log_item *iip = ip->i_itemp;
-	struct inode		*inode = VFS_I(ip);
 
 	ASSERT(iip);
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
@@ -101,7 +98,7 @@ xfs_trans_log_inode(
 	 */
 	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags) &&
 	    xfs_has_crc(ip->i_mount)) {
-		atomic64_inc(&inode->i_version);
+		ip->i_changecount++;
 		flags |= XFS_ILOG_IVERSION;
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 74f1812b03cb..6c87b90754c4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,8 +26,6 @@
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
 
-#include <linux/iversion.h>
-
 /* Radix tree tags for incore inode tree. */
 
 /* inode is to be reclaimed */
@@ -309,7 +307,6 @@ xfs_reinit_inode(
 	int			error;
 	uint32_t		nlink = inode->i_nlink;
 	uint32_t		generation = inode->i_generation;
-	uint64_t		version = inode_peek_iversion(inode);
 	umode_t			mode = inode->i_mode;
 	dev_t			dev = inode->i_rdev;
 	kuid_t			uid = inode->i_uid;
@@ -319,7 +316,6 @@ xfs_reinit_inode(
 
 	set_nlink(inode, nlink);
 	inode->i_generation = generation;
-	inode_set_iversion_queried(inode, version);
 	inode->i_mode = mode;
 	inode->i_rdev = dev;
 	inode->i_uid = uid;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e7a724270423..3ca8e905dbd4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3,8 +3,6 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include <linux/iversion.h>
-
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
@@ -828,7 +826,7 @@ xfs_init_new_inode(
 	ip->i_diflags = 0;
 
 	if (xfs_has_v3inodes(mp)) {
-		inode_set_iversion(inode, 1);
+		ip->i_changecount = 1;
 		ip->i_cowextsize = 0;
 		ip->i_crtime = tv;
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ab46ffb3ac19..0f9d32cbae72 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -42,6 +42,7 @@ typedef struct xfs_inode {
 	struct rw_semaphore	i_lock;		/* inode lock */
 	atomic_t		i_pincount;	/* inode pin count */
 	struct llist_node	i_gclist;	/* deferred inactivation list */
+	uint64_t		i_changecount;	/* # of attribute changes */
 
 	/*
 	 * Bitsets of inode metadata that have been checked and/or are sick.
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index f28d653300d1..9ec88a84edfa 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -21,8 +21,6 @@
 #include "xfs_error.h"
 #include "xfs_rtbitmap.h"
 
-#include <linux/iversion.h>
-
 struct kmem_cache	*xfs_ili_cache;		/* inode log item */
 
 static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
@@ -546,7 +544,7 @@ xfs_inode_to_log_dinode(
 
 	if (xfs_has_v3inodes(ip->i_mount)) {
 		to->di_version = 3;
-		to->di_changecount = inode_peek_iversion(inode);
+		to->di_changecount = ip->i_changecount;
 		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, ip->i_crtime);
 		to->di_flags2 = ip->i_diflags2;
 		to->di_cowextsize = ip->i_cowextsize;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 3940ad1ee66e..8a145ca7d380 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -28,7 +28,6 @@
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>
-#include <linux/iversion.h>
 #include <linux/fiemap.h>
 
 /*
-- 
2.43.0

