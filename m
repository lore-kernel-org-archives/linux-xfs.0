Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706FBC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F11A2083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tP9PHU6J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgEGMU3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726908AbgEGMU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89659C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=KxYIxUBgQRP0oeiQHvsygtJwoTC/sqgft1m43OsJNZs=; b=tP9PHU6JJWOjCc3B3n5zKEGBIk
        kaliMjNmMTFUWbuzqTAj822zeawNGkmgtbGBi0LD9L70TMhNCZUADMopUqSgJfePEuEy4qABCt04S
        tqpcWBDZJ50x5aBg3yCcb1CLZC3iW3RtqCAUPAyv1yxld0OaaA3CxUi5M2BHiioVCTesR9jnVR+nZ
        57Us3fiQtG/YWJL6v60vdhneT56NwVoKLKVLrGgHkuXm7k+aY1cT15aMvh+14FfLsuxeZ7h+0OxYd
        TWYXSB/yckgDvMA73dj8b3uh7RfGdgjGpmuSOpKB5ADIR8vB5ZX4A2nMHXHHFGc6FgRTWWkbrpND0
        sJcjGCMg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVt-0007gP-2M; Thu, 07 May 2020 12:20:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 39/58] xfs: introduce new private btree cursor names
Date:   Thu,  7 May 2020 14:18:32 +0200
Message-Id: <20200507121851.304002-40-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 7cace18ab576ef65d16498d3a9e2170fff5f5c93

Just the defines of the new names - the conversion will be in
scripted commits after this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: change "bc_bt" to "bc_ino"]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 8bead747..88750586 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -224,6 +224,8 @@ typedef struct xfs_btree_cur
 #define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)		/* for ext swap */
 		} b;
 	}		bc_private;	/* per-btree type data */
+#define bc_ag	bc_private.a
+#define bc_ino	bc_private.b
 } xfs_btree_cur_t;
 
 /* cursor flags */
-- 
2.26.2

