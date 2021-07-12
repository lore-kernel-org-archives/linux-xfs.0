Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5F2C07E99
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80186610CD
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbhGLLQw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 07:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbhGLLQm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jul 2021 07:16:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC64BC0613DD;
        Mon, 12 Jul 2021 04:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=xieBsUOQPWNOtVW7+/uj5Qg2zjqMrA846E3mzziA//o=; b=UTfOSL6tzWV7idCl9ih30Wy58z
        83fh5+TUkOV+GmoO5KsvAmkiBGp4eATObFwLzbZhwJX4itAa9KLtTUbH7bxBsvfMlGJ2cOSxbyRhh
        xatDc/TdKhA7odx/wVzJ4Q0KeCvBq/NB0mtWpHqkY+9pyKg4NeuUoUWEcyVRyqKrwpizyIYzhS5qK
        K/2KiFtF8NIO61xeSEgMlgjfGhEIlK0RTncaDHj1BgKoYocPmUmeEIkOmbLEiKeL7YCkyOhfE8qXa
        7FHamCvrmZ2+agcqEmshIvpoHkqCrhtjf5ONRrv0cZEyU3lRt5IGFBaCU+9LEmZRdxH5+1Dv0G6MI
        2QyrK7wA==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2tsR-00HXJw-AB; Mon, 12 Jul 2021 11:13:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs/304: don't turn quota accounting off
Date:   Mon, 12 Jul 2021 13:11:45 +0200
Message-Id: <20210712111146.82734-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712111146.82734-1-hch@lst.de>
References: <20210712111146.82734-1-hch@lst.de>
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

