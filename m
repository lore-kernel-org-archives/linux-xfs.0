Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B47C433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 12:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E340619E5
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 12:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhCZMuP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 08:50:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:57458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229957AbhCZMuI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Mar 2021 08:50:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616763007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=GgRdD7fbH7ZjfEMaUCy+Ljet4pB7OZwmX9lp9NIOQ7g=;
        b=bd87yRMn2pFWQ8tWGjaWR7AVDQsbQ6pHd6L2wit0zO4i+7nQk5BfAz9bl5a4QxefflELb2
        S5z04x0IrWKnH45ppkQpR/nSnfbvATpkXpabXXQ7Lz2nnurLokyEfuWTkuu/+DyTvg0kJx
        7pec6Qb7/ZXfk9dsEic1q5Lhf9Cij04=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 640F5ADD7
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 12:50:07 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove BMV_IF_NO_DMAPI_READ flag
Date:   Fri, 26 Mar 2021 13:53:19 +0100
Message-Id: <20210326125321.28047-1-ailiop@suse.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use of the flag has had no effect since kernel commit 288699fecaff
("xfs: drop dmapi hooks"), which removed all dmapi related code, so
drop it completely.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 fs/xfs/libxfs/xfs_fs.h | 3 +--
 fs/xfs/xfs_ioctl.c     | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6fad140d4c8e..23da047c3098 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -65,13 +65,12 @@ struct getbmapx {
 
 /*	bmv_iflags values - set by XFS_IOC_GETBMAPX caller.	*/
 #define BMV_IF_ATTRFORK		0x1	/* return attr fork rather than data */
-#define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
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

