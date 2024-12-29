Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9611617BEBF
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479619; cv=none; b=ODvPeSPE/jE68jnXVj10Y+sf3+L9wJgByQYknvm18V72pe1YxpdzsEH8fskGIeSKGohrLHl+U+09ARFQiXuweiJh9rdzKI5eEs6jgKT0wsDfamjR/zrq2QsklhhFwIJz2j6QHaC2XJQS5KF7KAb2F26NEG+v/KelGWVtZl+1boU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479619; c=relaxed/simple;
	bh=2BVroiZKMwtIoXBaD3dZ7cyKCtOsa2zOIE1T910w6sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4ijvIeIuSUZ2hM/3t5Nn0UIbvGRqyWEi/CmAbxMavQBugJUXslfOws2V2iep+ra9cq9dMPI7LiMTmn9b8NHXWgNmYGbPgJW16op7mpoaRaNFQ9rH+7Uc/DIjPbJAu87bzKO9zH7iVRVf6D7+4CDWDgLOACAV8DAhrkBacL/6P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y3b/smW+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y3b/smW+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/xV17dexnfWgI0ooIiF/Bbpu+fsC1cOfUOx4O3UUhSs=;
	b=Y3b/smW+Np492Hs9gTu9agasi8Fb0jmLbEv6RBqg6MLcMx+fHst8fBoPxerTx1hTC75+yH
	JE3nmLZ1agJ3QyipZz13qLLUO5w5iXBULDhwcLa7ztEafz1mc68nx+YhjNEQS83PzxJiiJ
	7LRH/VjsS4maPpe4iu97TzTa22QO0aA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-fs429BowP3-fM1MpwCeoKA-1; Sun, 29 Dec 2024 08:40:15 -0500
X-MC-Unique: fs429BowP3-fM1MpwCeoKA-1
X-Mimecast-MFC-AGG-ID: fs429BowP3-fM1MpwCeoKA
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa6a87f324cso76210466b.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479613; x=1736084413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/xV17dexnfWgI0ooIiF/Bbpu+fsC1cOfUOx4O3UUhSs=;
        b=EYvmwad4QEQCqjl1wGVGcBG6GOTHit5o08tMF091l/a5I/dcKn5Cm3Wi/5EzeDsLaX
         bKkexNNSpvUwkxuDgxw5nQlOGR5q+ZP0VGdOh11qFg7o1jAiYCWygdaUr9ZoLVueViRM
         rdrkipvKDw8qOxl91B9eLgyy1dQENfANhqGwQO0MrP0AiYkHcMLtdSM+RmT09unJxOaE
         EYwoc/HBbRnP/5qZMJ8jLxzTZ6F97OChvQN/dKkrQQjLZf0E4M8Do1CiGpiXIYgA1lTH
         cyK9xXk7zan7zLir3Sz3Fllg+J8OOXuxLj1q8kltTSTYnptDNYVv/WrsYPjrGYof3f14
         2kAg==
X-Gm-Message-State: AOJu0YyMnzl0zJddTx5mEctNkccOOM4dUyv7p+TBUSD8LeV9h8qBqowh
	MK2s/D8V6cpKIS/BKItrhRvD0P29mH5eZQnprXxzoaMUkdUYcEmptcB6T0a91OuPHnhyjTJm6+/
	pIP3glHbM36LXqQPPsbc3yv5c5WbPR1ikGM0Ng6a1U9SN3bryZqr62X1Tl7NN+clxMw2ziRi3gP
	Sc+axXziM75Joq/Aj5r9rXjCN0NNRBDtXqS+WGV00H
X-Gm-Gg: ASbGncs/dRtM9KLvuTFnVvTcycD0qIdIG6Jg/e33aXOcEPc+ekBs+ijZyM0gG2rKQUQ
	yw9t7UnKHA69uSFbeH3lJ/oiAxQu+qk/nZKx8wl7QwuDXMlmMmnaPqaZZaB8b9Tef9UuIbv+eWE
	qtQQp5D2D8HRRHELSL0/5BZyb8wdjlA/UOBBw8r3rrsxUg2gtJCMQIf1tnae4NNBbeS5h326msr
	qWHxENN+rSBBKpGrAk1AELYsa6TIZRMJ1nQ2+YIEXOxZkJlpLdGZz4qJ/sYZYIfPf/42wL4v+V2
	RdBcVCH/+qmQ+hw=
X-Received: by 2002:a17:906:c14f:b0:aa6:8e9e:1b5 with SMTP id a640c23a62f3a-aac27026ce8mr3233216666b.3.1735479613264;
        Sun, 29 Dec 2024 05:40:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/bxzq/qQ1NkUWGDrMuGdE8Ze1WCao7Q9NNH9lXIcsIInd1CtZJIL5NxEUGffGK8hFgos9xw==
X-Received: by 2002:a17:906:c14f:b0:aa6:8e9e:1b5 with SMTP id a640c23a62f3a-aac27026ce8mr3233214166b.3.1735479612892;
        Sun, 29 Dec 2024 05:40:12 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:12 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 23/24] xfs: report verity failures through the health system
Date: Sun, 29 Dec 2024 14:39:26 +0100
Message-ID: <20241229133927.1194609-24-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Record verity failures and report them through the health system.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h     |  1 +
 fs/xfs/libxfs/xfs_health.h |  4 +++-
 fs/xfs/xfs_fsverity.c      | 11 +++++++++++
 fs/xfs/xfs_health.c        |  1 +
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 5cfd4043cb9b..65978a2708ea 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -419,6 +419,7 @@ struct xfs_bulkstat {
 #define XFS_BS_SICK_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
 #define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
+#define XFS_BS_SICK_DATA	(1 << 9)  /* file data */
 
 /*
  * Project quota id helpers (previously projid was 16bit only
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index d34986ac18c3..a24006180bda 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -102,6 +102,7 @@ struct xfs_rtgroup;
 /* Don't propagate sick status to ag health summary during inactivation */
 #define XFS_SICK_INO_FORGET	(1 << 12)
 #define XFS_SICK_INO_DIRTREE	(1 << 13)  /* directory tree structure */
+#define XFS_SICK_INO_DATA	(1 << 14)  /* file data */
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -136,7 +137,8 @@ struct xfs_rtgroup;
 				 XFS_SICK_INO_XATTR | \
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT | \
-				 XFS_SICK_INO_DIRTREE)
+				 XFS_SICK_INO_DIRTREE | \
+				 XFS_SICK_INO_DATA)
 
 #define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
 				 XFS_SICK_INO_BMBTA_ZAPPED | \
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index 0af0f22ff075..967f75a1f97d 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -24,6 +24,7 @@
 #include "xfs_iomap.h"
 #include "xfs_bmap.h"
 #include "xfs_format.h"
+#include "xfs_health.h"
 #include <linux/fsverity.h>
 #include <linux/iomap.h>
 
@@ -462,10 +463,20 @@ xfs_fsverity_write_merkle(
 	return iomap_write_region(&region);
 }
 
+static void
+xfs_fsverity_file_corrupt(
+	struct inode		*inode,
+	loff_t			pos,
+	size_t			len)
+{
+	xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_DATA);
+}
+
 const struct fsverity_operations xfs_fsverity_ops = {
 	.begin_enable_verity		= xfs_fsverity_begin_enable,
 	.end_enable_verity		= xfs_fsverity_end_enable,
 	.get_verity_descriptor		= xfs_fsverity_get_descriptor,
 	.read_merkle_tree_page		= xfs_fsverity_read_merkle,
 	.write_merkle_tree_block	= xfs_fsverity_write_merkle,
+	.file_corrupt			= xfs_fsverity_file_corrupt,
 };
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index c7c2e6561998..a61b27cc6be7 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -485,6 +485,7 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
 	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
+	{ 0, 0 },
 };
 
 /* Fill out bulkstat health info. */
-- 
2.47.0

