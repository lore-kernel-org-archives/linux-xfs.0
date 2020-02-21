Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD33C35661
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA4D4222C4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K/RXvHHF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgBUOMA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:12:00 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59404 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728754AbgBUOL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EPUYC+s6pguYeMcjLej9GTQUeR8yhOlfX2zNBapNT5U=; b=K/RXvHHF+59SamM3UVrKPZoq50
        MIQwCarCM9FICui3mbLRJA1XmRwL5la/Tjmy4vIMA3d6hnNPHZQCClZGcON0iJbVH31USAF6atLDR
        tjdcO1AoBCMMWd4l8P7GvAtdA02svqYd9sRgDeYJ7e0jpN/Sjd3UyJSF9VZOBVPCSE7wWNFwUIImb
        UyRqHmSmDVpFXNGoHuHxOhZr3ozY1M5am+v8Ov8HzgCl09acnf7VKEbiENAZTfGtlgrScX+JY+5+R
        9lDX5dH64mW72oT+5zm4rO3nbRt68J9CGso+/i24wfLI6xzgBzWtoOBm3TJKzkUxmq1yUk5m321rD
        2lUjXW7g==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5927-0000JN-2B; Fri, 21 Feb 2020 14:11:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 19/31] xfs: remove the unused ATTR_ENTRY macro
Date:   Fri, 21 Feb 2020 06:11:42 -0800
Message-Id: <20200221141154.476496-20-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221141154.476496-1-hch@lst.de>
References: <20200221141154.476496-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0c8f7c7a6b65..31c0ffde4f59 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -69,14 +69,6 @@ typedef struct attrlist_ent {	/* data from attr_list() */
 	char	a_name[1];	/* attr name (NULL terminated) */
 } attrlist_ent_t;
 
-/*
- * Given a pointer to the (char*) buffer containing the attr_list() result,
- * and an index, return a pointer to the indicated attribute in the buffer.
- */
-#define	ATTR_ENTRY(buffer, index)		\
-	((attrlist_ent_t *)			\
-	 &((char *)buffer)[ ((attrlist_t *)(buffer))->al_offset[index] ])
-
 /*
  * Kernel-internal version of the attrlist cursor.
  */
-- 
2.24.1

