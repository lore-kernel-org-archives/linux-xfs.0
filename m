Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3754C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EB83206E3
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:06:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="URxwbZtA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgHaNEm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:04:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45236 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727065AbgHaNEg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 09:04:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598879073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/etHJMU9fW63ziTU9wDBEMMRHR52o9Su/jnjSDrv0x4=;
        b=URxwbZtAQJXGqoovQIC/MJiAH5tb3ujBXm6vOMzV+/WGBzdBUbWoqXK67xWV+SjrjiV6dp
        dvj0dUCRqwn1JvsOhrUXYvfOACFLAFmwtSG4/qcdrusuXtIBp8sD2dqySJzgWeVbfRNLTP
        gtF4mRRc1AMLrRusythzOgmhn1QkMYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-onb-PR3POEijRjUY0Ke1Qg-1; Mon, 31 Aug 2020 09:04:31 -0400
X-MC-Unique: onb-PR3POEijRjUY0Ke1Qg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1CDC8030DD
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 13:04:29 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 539EF5D9D5
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 13:04:29 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: Use variable-size array for nameval in xfs_attr_sf_entry
Date:   Mon, 31 Aug 2020 15:04:20 +0200
Message-Id: <20200831130423.136509-2-cmaiolino@redhat.com>
In-Reply-To: <20200831130423.136509-1-cmaiolino@redhat.com>
References: <20200831130423.136509-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

nameval is a variable-size array, so, define it as it, and remove all
the -1 magic number subtractions.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++----
 fs/xfs/libxfs/xfs_attr_sf.h   | 6 +++---
 fs/xfs/libxfs/xfs_da_format.h | 2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 305d4bc073370..7bbc97e0e4d4a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -992,7 +992,7 @@ xfs_attr_shortform_allfit(
 			return 0;
 		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
 			return 0;
-		bytes += sizeof(struct xfs_attr_sf_entry) - 1
+		bytes += sizeof(struct xfs_attr_sf_entry)
 				+ name_loc->namelen
 				+ be16_to_cpu(name_loc->valuelen);
 	}
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
index bb004fb7944a7..d93012a0be4d0 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -28,11 +28,11 @@ typedef struct xfs_attr_sf_sort {
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
-	(((int)sizeof(xfs_attr_sf_entry_t)-1 + (nlen)+(vlen)))
+	(((int)sizeof(xfs_attr_sf_entry_t) + (nlen)+(vlen)))
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
-	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
+	(1 << (NBBY*(int)sizeof(uint8_t)))
 #define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
-	((int)sizeof(xfs_attr_sf_entry_t)-1 + (sfep)->namelen+(sfep)->valuelen)
+	((int)sizeof(xfs_attr_sf_entry_t) + (sfep)->namelen+(sfep)->valuelen)
 #define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
 	((xfs_attr_sf_entry_t *)((char *)(sfep) + XFS_ATTR_SF_ENTSIZE(sfep)))
 #define XFS_ATTR_SF_TOTSIZE(dp)			/* total space in use */ \
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 059ac108b1b39..e86185a1165b3 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -589,7 +589,7 @@ typedef struct xfs_attr_shortform {
 		uint8_t namelen;	/* actual length of name (no NULL) */
 		uint8_t valuelen;	/* actual length of value (no NULL) */
 		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
-		uint8_t nameval[1];	/* name & value bytes concatenated */
+		uint8_t nameval[];	/* name & value bytes concatenated */
 	} list[1];			/* variable sized array */
 } xfs_attr_shortform_t;
 
-- 
2.26.2

