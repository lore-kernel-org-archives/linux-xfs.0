Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BF0C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 16:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74CE461029
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 16:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCaQXk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 12:23:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:49364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhCaQXJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Mar 2021 12:23:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617207788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=jbrCFXVClooRYRlrKaJWUMsBLgSrqYxll7diU+ngh0E=;
        b=s8HFVq1ocAh7Qy5f6ctUlEfEB49Yl+Vnn1Y6gcpzdybfgYg9SpJV7QXUn24Uff/KaF54Bj
        U4VwjANsI+wBk/ozbV+7FuXRjKCyrbxCd4oLWIwu/fiP4tsisum0n5DC731faF+sK1pDRf
        CApQGevV8usPXkmVwM0Q/8xlQ6BHb+Q=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0FBEDB336
        for <linux-xfs@vger.kernel.org>; Wed, 31 Mar 2021 16:23:07 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: deprecate BMV_IF_NO_DMAPI_READ flag
Date:   Wed, 31 Mar 2021 18:26:16 +0200
Message-Id: <20210331162617.17604-1-ailiop@suse.com>
X-Mailer: git-send-email 2.31.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use of the flag has had no effect since kernel commit 288699fecaff
("xfs: drop dmapi hooks"), which removed all dmapi related code, so
deprecate it.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
changes since v1:
 - retain flag definition to prevent reuse and not break kabi, per
   Darrick's suggestion.

 fs/xfs/libxfs/xfs_fs.h | 4 ++--
 fs/xfs/xfs_ioctl.c     | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6fad140d4c8e..4ef813e00e9e 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -65,13 +65,13 @@ struct getbmapx {
 
 /*	bmv_iflags values - set by XFS_IOC_GETBMAPX caller.	*/
 #define BMV_IF_ATTRFORK		0x1	/* return attr fork rather than data */
-#define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
+#define BMV_IF_NO_DMAPI_READ	0x2	/* Deprecated */
 #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
 #define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
 #define BMV_IF_NO_HOLES		0x10	/* Do not return holes */
 #define BMV_IF_COWFORK		0x20	/* return CoW fork rather than data */
 #define BMV_IF_VALID	\
-	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|	\
+	(BMV_IF_ATTRFORK|BMV_IF_PREALLOC|	\
 	 BMV_IF_DELALLOC|BMV_IF_NO_HOLES|BMV_IF_COWFORK)
 
 /*	bmv_oflags values - returned for each non-header segment */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 99dfe89a8d08..9d3f72ef1efe 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1669,8 +1669,6 @@ xfs_ioc_getbmap(
 		bmx.bmv_iflags = BMV_IF_ATTRFORK;
 		/*FALLTHRU*/
 	case XFS_IOC_GETBMAP:
-		if (file->f_mode & FMODE_NOCMTIME)
-			bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
 		/* struct getbmap is a strict subset of struct getbmapx. */
 		recsize = sizeof(struct getbmap);
 		break;
-- 
2.31.0

