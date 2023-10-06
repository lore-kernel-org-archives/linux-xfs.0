Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFCAE92FE4
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbjJFSym (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbjJFSyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:54:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE95F7
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yqD7XG8yS+x+6YJihiZLALF5OEXtH53Z7avMNl6axyM=;
        b=Rk8vr5rw6M2SXsoix/cwZU0J09V6rfC7SIRZ1TEEbUYFKxRAXQTVvrXG8xOgMZ8h2blC4o
        5y6BUcDE2/Rm42vc9l+bGY7ICCvg3Xo5KPbRz3wx/pu5CjgPKxlgqEtdX5M5Zmd2NtPeDu
        PbDTfsUyWeMzAeTDEaTna53nCxpXsDk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-1x9u9w67MEW_lutW3uhU8g-1; Fri, 06 Oct 2023 14:52:21 -0400
X-MC-Unique: 1x9u9w67MEW_lutW3uhU8g-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9b2c1159b0aso206668766b.3
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618340; x=1697223140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yqD7XG8yS+x+6YJihiZLALF5OEXtH53Z7avMNl6axyM=;
        b=bSW7jyBvxOMMjw9w3xWNH2YwiOvUGUXM8/lS/uop4ccK26oIrFHuVmD/M4P01i9U8h
         6nZlB9K+3ePj1NOt+EO5hTKDd4cBrc1PbX8bwxoJWYyrIugW9tNCshlPZnIkET4H/PbU
         nZuId+DPXqg8fZYQ8bbfXzFTG/JJfvfQAGQ8XzvYylVKJUd03fPK1S6ok6guKjr6xzo3
         yghrTnT0BIAKB8yg4xt4peUBdmoOMmx9bnwLPsMZEpOOSc19MTTEg8UuDyJWbR7dGFx4
         S9xHwwIq1VvuYyM/B1FzssTA9QUyN63FT5x1GaXNH/JOQ9YFdo/yey8I+6ml3k054az/
         AwgQ==
X-Gm-Message-State: AOJu0Yz23w+G/ys+qw21hSWsi9VJ9g0XrtAZmUSwxVvjO5htfV70YRJL
        tu4qTV5hSXeKh3SV3d5OoLTy5EF34GiAW7FSkZA/+2ilPZdIyN1zGefyv59vvn3Jj9//qyYNrOY
        5Cztmf/XbiD7jjPHMMRX1CEZ6BTaHdzQoWFqSkimjy9ka/lxOoDi0cOpRM0hmvyBJovD1n315sh
        dguMI=
X-Received: by 2002:a17:906:18a1:b0:9a1:c659:7c56 with SMTP id c1-20020a17090618a100b009a1c6597c56mr7974562ejf.22.1696618340399;
        Fri, 06 Oct 2023 11:52:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkFaE7RT68FegF5EVtz6eOa4hTMSrosmapJj1/xc/u6mw3c8ziwd+u13FOKpO9RebspAeKLQ==
X-Received: by 2002:a17:906:18a1:b0:9a1:c659:7c56 with SMTP id c1-20020a17090618a100b009a1c6597c56mr7974545ejf.22.1696618340033;
        Fri, 06 Oct 2023 11:52:20 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:19 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com,
        Allison Henderson <allison.henderson@oracle.com>,
        Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v3 02/28] xfs: add parent pointer support to attribute code
Date:   Fri,  6 Oct 2023 20:48:56 +0200
Message-Id: <20231006184922.252188-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
entries; it uses reserved blocks like XFS_ATTR_ROOT.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       | 4 +++-
 fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
 fs/xfs/libxfs/xfs_log_format.h | 1 +
 fs/xfs/scrub/attr.c            | 2 +-
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b1dbed7655e8..101823772bf9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -976,11 +976,13 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			rsvd;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
 
+	rsvd = (args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_PARENT)) != 0;
+
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index f9015f88eca7..fca622d43a38 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -698,12 +698,15 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ONDISK_MASK \
+			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 82f910b857b7..0bc1749fb7bb 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -974,6 +974,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 6c16d9530cca..8bc6aa274fa6 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -494,7 +494,7 @@ xchk_xattr_rec(
 	/* Retrieve the entry and check it. */
 	hash = be32_to_cpu(ent->hashval);
 	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
-			XFS_ATTR_INCOMPLETE);
+			XFS_ATTR_INCOMPLETE | XFS_ATTR_PARENT);
 	if ((ent->flags & badflags) != 0)
 		xchk_da_set_corrupt(ds, level);
 	if (ent->flags & XFS_ATTR_LOCAL) {
-- 
2.40.1

