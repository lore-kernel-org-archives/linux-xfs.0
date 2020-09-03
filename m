Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004D0C433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBC1C206EB
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:29:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EMuOPz4Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgICO3u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 10:29:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33586 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729339AbgICO2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 10:28:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599143330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2eFVHJlibhxAP8s9jiPt27LxJdTDFONNDVR3fFRgHQo=;
        b=EMuOPz4QkbIZg/2df+js/w364yOOrvoZYusUdNNT3Csq9Al/pUIPeEGLjZieYqi5PeFzXp
        rgFWrPqCTmxrr/b6+dQRYddTD/fOyVygVxzxbhHcqvbGAO0v/Nx3YAMkTHEBKo8/EYMGxs
        Ltx39FxwwvEiH9oZ5f/maIM2JN6JdHs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-BWa03ggOPTyUz__bhuS1yQ-1; Thu, 03 Sep 2020 10:28:49 -0400
X-MC-Unique: BWa03ggOPTyUz__bhuS1yQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5576E81CAFE
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 14:28:48 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0E5F10013D9
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 14:28:47 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 3/4] xfs: Use variable-size array for nameval in xfs_attr_sf_entry
Date:   Thu,  3 Sep 2020 16:28:38 +0200
Message-Id: <20200903142839.72710-4-cmaiolino@redhat.com>
In-Reply-To: <20200903142839.72710-1-cmaiolino@redhat.com>
References: <20200903142839.72710-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

nameval is a variable-size array, so, define it as it, and remove all
the -1 magic number subtractions

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Changelog:

	V2:
	 - Drop wrong change to XFS_ATTR_SF_ENTSIZE_MAX
	V3:
	- Use XFS_ATTR_SF_ENTSIZE_BYNAME in xfs_attr_shortform_allfit()
	- Remove int casting and fix spacing on
	  XFS_ATTR_SF_ENTSIZE_BYNAME

 fs/xfs/libxfs/xfs_attr_leaf.c | 10 ++++------
 fs/xfs/libxfs/xfs_attr_sf.h   |  4 ++--
 fs/xfs/libxfs/xfs_da_format.h |  2 +-
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d920183b08a99..fb05c77fc8c9f 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -992,9 +992,9 @@ xfs_attr_shortform_allfit(
 			return 0;
 		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
 			return 0;
-		bytes += sizeof(struct xfs_attr_sf_entry) - 1
-				+ name_loc->namelen
-				+ be16_to_cpu(name_loc->valuelen);
+		bytes += XFS_ATTR_SF_ENTSIZE_BYNAME(
+					name_loc->namelen,
+					be16_to_cpu(name_loc->valuelen));
 	}
 	if ((dp->i_mount->m_flags & XFS_MOUNT_ATTR2) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
@@ -1036,10 +1036,8 @@ xfs_attr_shortform_verify(
 		 * struct xfs_attr_sf_entry has a variable length.
 		 * Check the fixed-offset parts of the structure are
 		 * within the data buffer.
-		 * xfs_attr_sf_entry is defined with a 1-byte variable
-		 * array at the end, so we must subtract that off.
 		 */
-		if (((char *)sfep + sizeof(*sfep) - 1) >= endp)
+		if (((char *)sfep + sizeof(*sfep)) >= endp)
 			return __this_address;
 
 		/* Don't allow names with known bad length. */
diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
index c4afb33079184..29934103ce559 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -27,11 +27,11 @@ typedef struct xfs_attr_sf_sort {
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
-	(((int)sizeof(struct xfs_attr_sf_entry)-1 + (nlen)+(vlen)))
+	((sizeof(struct xfs_attr_sf_entry) + (nlen) + (vlen)))
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
 	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
 #define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
-	((int)sizeof(struct xfs_attr_sf_entry)-1 + \
+	((int)sizeof(struct xfs_attr_sf_entry) + \
 		(sfep)->namelen+(sfep)->valuelen)
 #define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
 	((struct xfs_attr_sf_entry *)((char *)(sfep) + \
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index e708b714bf99d..b40a4e80f5ee6 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -589,7 +589,7 @@ struct xfs_attr_shortform {
 		uint8_t namelen;	/* actual length of name (no NULL) */
 		uint8_t valuelen;	/* actual length of value (no NULL) */
 		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
-		uint8_t nameval[1];	/* name & value bytes concatenated */
+		uint8_t nameval[];	/* name & value bytes concatenated */
 	} list[1];			/* variable sized array */
 };
 
-- 
2.26.2

