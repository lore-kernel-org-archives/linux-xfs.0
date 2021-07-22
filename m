Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF45C63793
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3058A6023B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhGVHBE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 03:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhGVHBD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 03:01:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5B9C061575;
        Thu, 22 Jul 2021 00:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Gk3FmlS2FETjaPN/NsYYvsduDo/sekD/0gliwGLO6U4=; b=lS8cNKw15IwnuuKAZu6lKd887y
        8O9Y/GM24DmP4T8iHBXpQhx2jMHOeXpbodcLdQPKTuaztmhxRsQK62R8+6yoQTTcvSQ9eaT30cTM9
        WitMRNeqhR16hM3UEQ3a6DVdmLAqiUBzMuz9UpBkxEXMX6zNQGia3lq0dBXWKRLA7+jNjx2sAySoo
        I23lJLJCz19SrGrZYv3lGLy8hGc/ywNC3SRtDm3jd+ZSCu40N5XzsMlFS1R738X5rrMwQ8dAuaYJp
        5wN/q9WZo+sCX3PtX8V1NxqF0GPkxID+nf3USe0YDNjWLh8kYW42jkHJhTQH5wfJjrPqMWrTmAr1D
        EwhVp7hw==;
Received: from [2001:4bb8:193:7660:643c:9899:473:314a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6TKV-00A0aB-NI; Thu, 22 Jul 2021 07:41:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 5/7] xfs/304: don't turn quota accounting off
Date:   Thu, 22 Jul 2021 09:38:30 +0200
Message-Id: <20210722073832.976547-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210722073832.976547-1-hch@lst.de>
References: <20210722073832.976547-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The test case tests just as much when just testing turning quota
enforcement off, so switch it to that.  This is in preparation for
removing support to turn quota accounting off.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/304 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/304 b/tests/xfs/304
index 2716ccd5..91fa5d97 100755
--- a/tests/xfs/304
+++ b/tests/xfs/304
@@ -31,7 +31,7 @@ QUOTA_DIR=$SCRATCH_MNT/quota_dir
 
 mkdir -p $QUOTA_DIR
 echo "*** turn off group quotas"
-xfs_quota -x -c 'off -g' $SCRATCH_MNT
+xfs_quota -x -c 'disable -g' $SCRATCH_MNT
 rmdir $QUOTA_DIR
 echo "*** umount"
 _scratch_unmount
@@ -39,7 +39,7 @@ _scratch_unmount
 _qmount
 mkdir -p $QUOTA_DIR
 echo "*** turn off project quotas"
-xfs_quota -x -c 'off -p' $SCRATCH_MNT
+xfs_quota -x -c 'disable -p' $SCRATCH_MNT
 rmdir $QUOTA_DIR
 echo "*** umount"
 _scratch_unmount
@@ -47,7 +47,7 @@ _scratch_unmount
 _qmount
 mkdir -p $QUOTA_DIR
 echo "*** turn off group/project quotas"
-xfs_quota -x -c 'off -gp' $SCRATCH_MNT
+xfs_quota -x -c 'disable -gp' $SCRATCH_MNT
 rmdir $QUOTA_DIR
 echo "*** umount"
 _scratch_unmount
-- 
2.30.2

